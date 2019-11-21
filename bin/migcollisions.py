#!/usr/bin/env python3

from collections import defaultdict
from functools import reduce
import os
from pathlib import Path
import sys

def main():
    if len(sys.argv) > 1:
        paths = [ Path(arg) for arg in sys.argv[1:] ]
    else:
        paths = [ Path() ]

    for path in paths:
        if not path.is_dir():
            continue

        for root, dirs, files in os.walk(path):
            if Path(root).name == 'migrations':
                collisions = detect(files)
                if collisions:
                    print(f' --> {root}:')
                    for c in collisions:
                        print(c)


def detect(files):
    prefixes = defaultdict(list)
    for f in files:
        if f.endswith('.py'):
            prefixes[f[:4]].append(f)

    collisions = reduce(lambda a, x: a + (x if len(x) > 1 else []), prefixes.values(), [])
    return collisions


if __name__ == '__main__':
    main()
