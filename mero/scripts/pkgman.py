#!/usr/bin/env python3

import argparse
from dataclasses import dataclass
from typing import List
import subprocess


@dataclass
class Manager:
    name: str
    install: List[str]
    uninstall: List[str]
    upgrade: List[str]


class PackageManager:
    managers = {
        "dnf": Manager(name="dnf", install=["install"], uninstall=["remove"], upgrade=["upgrade", "--refresh"]),
        "pacman": Manager(name="pacman", install=["-S"], uninstall=["-R"], upgrade=[]),
        "apt": Manager(name="apt", install=["install"], uninstall=["remove"], upgrade=[]),
    }

    managers.update({
        "paru": managers["pacman"],
        "yay": managers["pacman"],
    })

    def install(self, apps: List[str]):
        self.exec(apps)

    def uninstall(self, apps: List[str]):
        self.exec(apps)

    def exec(self, args: List[str]):
        pkgman = self.managers[self.system_pkgman()]

        subprocess.run(["sudo", pkgman.name, *pkgman.upgrade, *args])

    def system_pkgman(self):
        with open("/etc/os-release", encoding="utf8") as file:
            os = next(
                line for line in file.read().splitlines()
                if line.startswith("ID=")
            )
            # extract 'ID=' part
            os = os[3:]

            pkgman = None

            match os.lower():
                case "fedora":
                    pkgman = "dnf"
                case "archlinux" | "manjaro":
                    pkgman = "pacman"
                case "ubuntu" | "linuxmint":
                    pkgman = "apt"

            if not pkgman:
                exit("Error: Unsupported os")

            return pkgman


class Cli:
    parser = argparse.ArgumentParser(
        description="Stupid simple universal package manager")

    a: argparse.Namespace

    def __init__(self):
        self.parser.add_argument(
            "-i", "--install", help="INSTALL HELP TEXT", metavar='package', type=str, nargs="+")
        self.parser.add_argument(
            "-u", "--upgrade", help="UPGRADE HELP TEXT", action="store_false")
        self.parser.add_argument(
            "-r", "--remove", help="REMOVE HELP TEXT", metavar='package', type=str, nargs="+")
        self.parser.add_argument(
            "-v",
            '--version', action='version', version='%(prog)s 0.01')

        self.a = self.parser.parse_args()


def main():
    # pkgman = PackageManager()

    # # pkgman.install()
    # # pkgman.uninstall()
    # pkgman.exec("echo hello world".split(" "))
    cli = Cli()

    print("cli.a.install", cli.a.install)


if __name__ == "__main__":
    main()
