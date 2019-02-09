# You can run this tests from the parent dir. (you need pytest, coverage, pytest-cov)
# pytest -v
# pytest --cov=linkConfig --cov-report=html tests/

import pytest

from argparse import Namespace
from copy import copy
from pathlib import Path
import os
import stat

import linkConfig

g_repo_only_files_expected = (
    ".repo_only_files",
    "__pycache__",
    "dir2/__pycache__",
)
g_exclude_paths = ['.git',]
g_dirs = (
    Path("dir1/subdir1"),
    Path("dir2"),
    Path("__pycache__"),
    Path("dir2/__pycache__"),
    Path(".git"),
)
g_files = (
    g_dirs[0] / "dir1_subdir1_file",
    g_dirs[0].parent / "dir1_file",
    g_dirs[1] / "dir2_file_to_skip~",
    g_dirs[2] / "__pycache__file_to_skip",
    g_dirs[3] / "dir2__pycache__file_to_skip",
    g_dirs[4] / ".git_file_to_skip",
)

@pytest.fixture
def dir_structure(tmp_path):
    repo = tmp_path / 'repo'
    repo.mkdir()
    f = repo / '.repo_only_files'
    f.write_text("\n".join(g_repo_only_files_expected))
    yield tmp_path, repo

@pytest.fixture
def global_vars(monkeypatch, dir_structure):
    home, repo = dir_structure
    args = Namespace(
        repo_dir=Path(str(repo)),
        action='link',
        subpath=[repo],
        verbose=False,
        quiet=True,
    )

    global_var_names = ("g_args", "g_exclude_file_sufixes", "g_exclude_paths", "g_homeDir",)
    save = {}

    v = Namespace(
        g_args=args,
        g_exclude_paths=g_exclude_paths,
        g_homeDir=home,
        g_exclude_file_sufixes=linkConfig.g_exclude_file_sufixes,
    )

    for name in global_var_names:
        monkeypatch.setattr(linkConfig, name, getattr(v, name))
    yield v


@pytest.mark.usefixtures("dir_structure", "global_vars")
class TestLinkConfigMisc:

    def test_load_independent(self):
        expected_repo_only_files = copy(g_exclude_paths)
        expected_repo_only_files.extend(g_repo_only_files_expected)

        linkConfig.load_independent()

        assert linkConfig.g_exclude_paths == expected_repo_only_files

    @pytest.mark.parametrize("rel_path, expected_result", [
        (g_files[0], True),                 # normal file
        (g_files[1], True),                 # normal file
        (g_files[2], False),                # normal file with excluded name
        (g_files[3], False),                # normal file inside excluded dir
        (g_files[4], False),                # normal file inside excluded dir/subdir
        (g_files[5], False),                # normal file inside excluded dot dir
        (Path("missing_file"), True),       # missing file OK if name OK
        (Path(".repo_only_files"), False),  # excluded file path
    ])
    def test_go_file(self, dir_structure, rel_path, expected_result):
        assert linkConfig.go_file(rel_path) == expected_result

    @pytest.mark.parametrize("rel_path, expected_result", [
        (g_dirs[0], True),              # normal dir
        (g_dirs[1], True),              # normal dir
        (Path("missing_dir"), True),    # missing dir with normal name OK
        (g_dirs[2], False),             # existing dir with excluded name; from .exclude file
        (g_dirs[3], False),             # existing dir with excluded name/name; from .exclude file
        (g_dirs[4], False),             # existing dir with excluded name; from global constant
    ])
    def test_go_dir(self, dir_structure, rel_path, expected_result):
        assert linkConfig.go_dir(rel_path) == expected_result

    def test_areHardLinked_ok(self, dir_structure, dir_structure_files_hardlinks):
        f, l = dir_structure_files_hardlinks
        assert f.exists()
        assert l.exists()
        assert linkConfig.areHardLinked(f, l)

    def test_areHardLinked_not(self, dir_structure, dir_structure_files):
        src_full = linkConfig.g_args.repo_dir / g_files[0]
        dst_full = linkConfig.g_args.repo_dir / g_files[1]
        assert src_full.exists()
        assert dst_full.exists()
        assert not linkConfig.areHardLinked(src_full, dst_full)

    def test_areHardLinked_missing(self, dir_structure, dir_structure_files):
        src_full = linkConfig.g_args.repo_dir / g_files[0]
        dst_full = linkConfig.g_args.repo_dir / 'missing'
        assert src_full.exists()
        assert not dst_full.exists()
        assert not linkConfig.areHardLinked(src_full, dst_full)


g_file_content = "something"

@pytest.fixture
def dir_structure_files_content(dir_structure):
    home, repo = dir_structure
    repo_full = repo / ".config"
    home_full = home / ".config"
    repo_full.write_text(g_file_content)
    home_full.touch(exist_ok=True)

    yield repo_full.relative_to(repo)


@pytest.mark.usefixtures("dir_structure", "global_vars")
class TestLinkConfigDiff:

    def test_diff_ok(self, monkeypatch, capfd, dir_structure_files_content):
        repo_rel_path = dir_structure_files_content
        args = copy(linkConfig.g_args)
        args.quiet = False
        monkeypatch.setattr(linkConfig, 'g_args', args)

        linkConfig.diff(repo_rel_path)
        output = capfd.readouterr()
        assert g_file_content in output.out



@pytest.fixture
def dir_structure_files_samelink(dir_structure, dir_structure_files_content):
    home, repo = dir_structure
    repo_rel_path = dir_structure_files_content
    repo_full = repo / repo_rel_path
    home_full = home / repo_rel_path

    os.unlink(home_full)
    os.link(repo_full, home_full)
    assert linkConfig.areHardLinked(repo_full, home_full)
    inode = os.stat(repo_full)[stat.ST_INO]
    yield repo_full.relative_to(repo), inode

@pytest.fixture
def dir_structure_dirs(dir_structure):
    home, repo = dir_structure
    for d in g_dirs:
        (repo / d).mkdir(parents=True, exist_ok=True)
 
@pytest.fixture
def dir_structure_files(dir_structure, dir_structure_dirs):
    home, repo = dir_structure
    for f in g_files:
        (repo / f).touch(exist_ok=False)

@pytest.mark.usefixtures("dir_structure", "global_vars")
class TestLinkConfigLink:

    def test_link_new(self, dir_structure_files):
        src_full = linkConfig.g_args.repo_dir / g_files[0]
        dst_full = linkConfig.g_homeDir / g_files[0]
        assert src_full.exists()
        assert not dst_full.exists()

        linkConfig.link(g_files[0])
        assert dst_full.exists()
        # lol, we include module function on the side of expected results. hope it is well tested :-))
        assert linkConfig.areHardLinked(src_full, dst_full)

    def test_link_diff(self, dir_structure_files_content):
        repo_rel_path = dir_structure_files_content
        repo_full = linkConfig.g_args.repo_dir / repo_rel_path
        home_full = linkConfig.g_homeDir / repo_rel_path

        assert repo_full.exists()
        assert home_full.exists()
        assert not linkConfig.areHardLinked(repo_full, home_full)

        linkConfig.link(repo_rel_path)

        assert linkConfig.areHardLinked(repo_full, home_full)
        bakfile = home_full.parent / (home_full.name + ".git.bak")
        assert bakfile.exists()

    def test_link_same(self, dir_structure_files_samelink):
        repo_rel_path, inode = dir_structure_files_samelink
        repo_full = linkConfig.g_args.repo_dir / repo_rel_path

        linkConfig.link(repo_rel_path)
        assert os.stat(repo_full)[stat.ST_INO] == inode

    def test_post_merge_linkNotCalled(self, monkeypatch, dir_structure_files_samelink):
        repo_rel_path, inode = dir_structure_files_samelink
        repo_full = linkConfig.g_args.repo_dir / repo_rel_path
        home_full = linkConfig.g_homeDir / repo_rel_path

        monkeypatch.setattr(linkConfig, 'link', 0)
        try:
            linkConfig.post_merge_relink(repo_rel_path)
            assert True
        except TypeError as why:
            assert False, "link was called"


@pytest.fixture
def dir_structure_files_hardlinks(dir_structure, dir_structure_files):
    home, repo = dir_structure
    src = repo / g_files[0]
    dst = home / g_files[0]
    dst.parent.mkdir(parents=True, exist_ok=True)
    os.link(src, dst)
    yield src, dst


@pytest.mark.usefixtures("dir_structure", "global_vars")
class TestLinkRecurse:
    def test_link(self, dir_structure, dir_structure_files_hardlinks):
        expected_links = [
            g_files[0],
            g_files[1],
        ]
        expected_not_links = [
            g_files[2],
            g_files[3],
        ]

        linkConfig.main(linkConfig.g_args)

        for src in expected_links:
            src_full = linkConfig.g_args.repo_dir / src
            dst_full = linkConfig.g_homeDir / src
            assert linkConfig.areHardLinked(src_full, dst_full)

        for src in expected_not_links:
            src_full = linkConfig.g_args.repo_dir / src
            dst_full = linkConfig.g_homeDir / src
            assert not dst_full.exists() or not linkConfig.areHardLinked(src_full, dst_full)

    @pytest.mark.parametrize("rel_subpath, expected_results", [
        ( g_dirs[0].parent, [ g_files[0], g_files[1] ] ),   # dir1 subpath
        ( g_files[1], [ g_files[1] ] ),                     # specific file, not the already existing hardlink
    ])
    def test_link_subpath(self, dir_structure, dir_structure_files_hardlinks, rel_subpath, expected_results):
        linkConfig.g_args.subpath = [ linkConfig.g_args.repo_dir / rel_subpath ]

        linkConfig.main(linkConfig.g_args)

        for src in expected_results:
            src_full = linkConfig.g_args.repo_dir / src
            dst_full = linkConfig.g_homeDir / src
            assert linkConfig.areHardLinked(src_full, dst_full)

