#!/usr/bin/env python3

import json
import subprocess
import sys


def main():
    print(sys.version + '\n')

    dev_path = json.load(open('package.json'))['submoduleConfig']['dev']

    for path in dev_path:
        print('Directory: ', path)
        print('Git branch: ', dev_path[path])

        checkout(path, dev_path[path])
        pull(path, dev_path[path])
        print('\n')


def checkout(path, branch):
    execute('git checkout {}'.format(branch), path)


def pull(path, branch):
    execute('git pull origin {}'.format(branch), path)


def execute(cmd, path):
    subprocess.call(cmd, shell=True, cwd=path)


if __name__ == '__main__':
    main()
