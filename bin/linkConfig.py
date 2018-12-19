#!/usr/bin/env python3

import argparse
import os
#import os.path
from pathlib import Path
import shutil
import stat
import subprocess
import sys


g_args = None
g_exclude_file_sufixes = ('~','.swp')
g_exclude_paths = ['.git', '.ropeproject']
g_homeDir = Path.home()


def _pathname_excluded(rel_path):
    pathstr = str(rel_path)
    if any( pathstr.startswith(name) for name in g_exclude_paths ):
        return True


def go_file(relative_path):
    name = relative_path.name
    if _pathname_excluded(relative_path):
        return False
    if any( name.endswith(ext) for ext in g_exclude_file_sufixes ):
        return False

    return True


def go_dir(relative_path):
    if _pathname_excluded(relative_path):
        return False

    return True


def areHardLinked(f1, f2):
    try:
        f1Details = os.stat(f1)
        f2Details = os.stat(f2)
    except BaseException:
        return False
    return f1Details[stat.ST_INO] == f2Details[stat.ST_INO]


# src is the newer file in this case and we are diffing the old home dst to the new repo src
def diff(src):
    src_full = g_args.repo_dir / src
    dst_full = g_homeDir / src

    if g_args.verbose:
        sys.stderr.write(f"diffing: diff -wu {dst_full} {src_full}\n")
    if not g_args.quiet:
        subprocess.call(["diff", "-wu", dst_full, src_full])


def link(src):
    src_full = g_args.repo_dir / src
    dst_full = g_homeDir / src

    # kind of crapy - I use quiet as both no output and assume yes to all questions...
    if g_args.quiet:
        answer = 'y'
    else:
        subprocess.call(["diff", "-wu", dst_full, src_full])
        print(f"--> {dst_full} will become a hard link of: {src_full}")
        answer = input("     Are you sure? Link (y), skip (n), yes to link all (a) (y/n/a) ?")

    if answer == 'a':
        g_args.quiet = True
        answer = 'y'

    # replace homeDir file with file in repo
    if answer == 'y':
        # filters and preparations
        if not dst_full.parent.exists():
            dst_full.parent.mkdir(parents=True, exist_ok=True)
        elif areHardLinked(src_full, dst_full):
            if g_args.verbose: print(f"{src_full} and {dst_full} are already linked")
            return
        elif dst_full.exists():
            dst_bak_name = dst_full.parent / (dst_full.name + ".git.bak")
            if (dst_bak_name.exists()):
                os.remove(dst_bak_name)
            os.rename(dst_full, dst_bak_name)

        # the real linkage
        # if it is a symlink, create a dst one to the same target
        if src_full.is_symlink():
            linkto = os.readlink(src_full)
            try:
                os.symlink(linkto, dst_full)
            except BaseException as why:
                if not g_args.quiet: print(why)
        else:
            os.link(src_full, dst_full)

def post_merge_relink(src):
    """Hard links repo file with home file one only if the link was broken."""
    src_full = g_args.repo_dir / src
    dst_full = g_homeDir / src
    # if src has only one hard link count
    stat_details = os.stat(src_full)
    if stat_details.st_nlink == 1:
        link(src)


def load_independent(name='.repo_only_files'):
    path = g_args.repo_dir / name
    # use something ordered here
    try:
        with path.open() as f:
            for line in f:
                g_exclude_paths.append(line.strip())
    except:
        if not g_args.quiet:
            sys.stderr.write(f"Failed to open {path} for reading\n")


def main(args):
    global g_args
    g_args = args

    actions = {
        'diff': diff,
        'link': link,
        'post-merge': post_merge_relink,
    }
    action = actions[g_args.action]

    # we'll use HOME and repo_dir as abs paths
    g_args.repo_dir = g_args.repo_dir.resolve()
    repo_dir = g_args.repo_dir

    # Path() is neutral in merges
    paths = g_args.subpath or [ Path() ]
    # now the innerpaths work relative to both repo_dir and HOME
    paths = [ p.resolve().relative_to(repo_dir) for p in paths ]

    load_independent()

    for path in paths:
        path_in_repo = repo_dir / path
        path_rel = path_in_repo.relative_to(repo_dir)
        if not path_in_repo.exists():
            continue

        if path_in_repo.is_file() and go_file(path_rel):
            action(path_rel)
        elif path_in_repo.is_dir() and go_dir(path_rel):
            for root, dirs, files in os.walk(path_in_repo):
                root = Path(root)
                if not go_dir(root.relative_to(repo_dir)):
                    continue
                for name in files:
                    full_path = root / name
                    rel_path = full_path.relative_to(repo_dir)
                    if go_file(rel_path):
                        action(rel_path)


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description=f"""Manage hard links between the location of the git versioned config \
files and their proper OS location in the HOME dir.
Files that exist in repo dir but not in HOME will get a fresh hard link in the HOME context.
Files listed in .repo_only_file will not be linked to the HOME dir.
Backup files {g_exclude_file_sufixes} and special pathnames {g_exclude_paths} are excluded anyway.
""", formatter_class=argparse.RawTextHelpFormatter)

    mutual_exclusive_args = parser.add_mutually_exclusive_group()
    mutual_exclusive_args.add_argument("-v", "--verbose", action="store_true")
    mutual_exclusive_args.add_argument("-q", "--quiet", action="store_true")

    parser.add_argument("action", type=str, choices=["link", "diff", "post-merge"],
            help="""Action to perform:
    link: hard link the files in the specified repo dir to the one present in your home dir
    diff: show diffs between files in the specified repo dir and their home dir corespondents
    post-merge: same as link but silent and not requiring user interaction; designed to be called from git hooks""")

    parser.add_argument("repo_dir", type=Path, default=Path(), help="location of the repo config files from cwd")
    parser.add_argument("subpath", type=Path, nargs="*", default=[], help="path/to/dir or file inside the repo, from cwd; if only a subtree needs linking")

    args = parser.parse_args()

    main(args)
