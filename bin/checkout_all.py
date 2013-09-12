#! /usr/bin/python

from io import StringIO
import os
import re
import shlex
import subprocess
import sys

def execWithOutput(*args, **kwargs):
    """Runs subprocess.Popen and returns a tuple (resultCode, stdOut)"""
    kwargs['stdout'] = subprocess.PIPE
    kwargs['stderr'] = subprocess.PIPE
    proc = subprocess.Popen(*args, **kwargs)
    output, error = proc.communicate()

    return (proc.wait(), output)


def tryCheckout(branch, gitDir):
    (branch_result, branch_output) = execWithOutput([ "git", "branch", "-a" ], cwd = gitDir)
    if branch_result != 0:
        return # not a git repo
    if re.search(r'\bproduction\b', branch_output) is None:
        return # no production branch
    (status_result, status_output) = execWithOutput([ "git", "status" ], cwd = gitDir)
    if re.search(r'nothing to commit, working directory clean', status_output) is None:
        print("Skipping {0}. Not clean.".format(os.path.basename(gitDir)))
        return

    (_, _) = execWithOutput([ "git", "fetch" ], cwd = gitDir)

    (branch_diff_result, branch_diff_output) = execWithOutput(shlex.split(
            "git log --oneline --left-right --boundary origin/{0}..{0}".format(branch)),
        cwd = gitDir)
    # if we don't have unpushed commits in the branch we are going to move into,
    # we can force the head to the origin
    if branch_diff_output:
        print("Failed to checkout {0}. Unpushed commits on destination.".format(os.path.basename(gitDir)))
        return

    (co_result, co_output) = execWithOutput(shlex.split(
            'git checkout {0}'.format(branch)),
            cwd = gitDir)
    if co_result != 0:
        print("Failed to checkout {0}".format(os.path.basename(gitDir)))
        return

    if re.search(r'\borigin/production\b', branch_output) is not None:
        (pull_result, pull_output) = execWithOutput([ "git", "pull", "origin", branch ], cwd = gitDir)
        if pull_result != 0:
            print("Failed to pull {0}".format(os.path.basename(gitDir)))
            return

    print("Switched {0}".format(os.path.basename(gitDir)))


def main(branch):
    if len(sys.argv) >= 3 and sys.argv[2]:
        if os.path.isdir(sys.argv[2]):
            tryCheckout(branch, os.path.abspath(sys.argv[2]))
    else:
        for potentialGit in os.listdir('.'):
            if os.path.isdir(potentialGit):
                tryCheckout(branch, os.path.abspath(potentialGit))


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: {0} [branch name]".format(sys.argv[0]))
        print("Checks out the specified branch in all git repos directly ")
        print("beneath the current working directory that also have a ")
        print("branch named 'production'.")
        sys.exit(1)
    main(sys.argv[1])

