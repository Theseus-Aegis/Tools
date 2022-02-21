#!/usr/bin/env python3

import argparse
import ctypes
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

MODS_PATH = "mods"
BUILD_PATH = "build"
PUBLISH_PATH = "publish"
PRELOAD_MODS = ["@cba_a3", "@ace", "@tac_mods"]

DEFAULT_SWIFTY_CLI = Path(__file__).parent / "swifty-cli.exe"
DEFAULT_OUTPUT = f"{os.path.splitext(__file__)[0]}_cfg.log"


def can_make_symlinks():
    # Linux
    if os.name == "posix":
        return True

    # Windows
    try:
        return ctypes.windll.shell32.IsUserAnAdmin() == 1
    except AttributeError:
        return False


def publish(repo):
    # TODO
    # Make a clean copy of all mods/
    # Make a clean copy of build/<repo>

    # TODO Handle server keys
    # ???

    build = Path(BUILD_PATH, repo)
    publish = Path(PUBLISH_PATH, repo)

    # Check if build exists
    if not build.exists():
        print(f"error: build '{build}' not found!")
        return 1

    # Prepare publish folder
    if publish.exists():
        print(f"remove old publish '{publish}'")
        shutil.rmtree(publish)
    elif not Path(PUBLISH_PATH).exists():
        print(f"prepare publish '{PUBLISH_PATH}'")
        os.mkdir(PUBLISH_PATH)

    # Copy with preserving symlinks
    print(f"publish '{build}' -> '{publish}'")
    shutil.copytree(build, publish, symlinks=True)


def build(repo, repojson, swifty_cli, output):
    # Lower-case all mod folders, their 'addons' and PBO files
    print("lower-case")
    for root, dirs, files in os.walk(MODS_PATH, topdown=False):
        def _to_lower(src, dst):
            if src.as_posix() != dst.as_posix():
                print(f"  {src} -> {dst}")
                os.rename(src, dst)

        for d in dirs:
            if d.startswith("@") or d.lower() == "addons":
                _to_lower(Path(root, d), Path(root, d.lower()))
        for f in files:
            if os.path.splitext(f)[1] == ".pbo":
                _to_lower(Path(root, f), Path(root, f.lower()))

    build = Path(BUILD_PATH, repo)

    # Parse JSON for mod folders in use
    print(f"parse '{repojson}'")
    modfolders = dict()
    with open(repojson, "r", encoding="utf-8") as repodata:
        data = json.load(repodata)
        mods = data["requiredMods"] + data["optionalMods"]
        for mod in mods:
            enabled = mod.get("enabled", True) and mod.get("Enabled", True)
            modpath = Path(MODS_PATH, mod["modName"])

            print(f"  {modpath.name} -> {modpath.parent} {'' if enabled else '(disabled)'}")
            if not enabled:
                continue

            if modpath.name == "@*":
                for modfolder in modpath.parent.iterdir():
                    print(f"    {modfolder.name} -> {modpath.parent}")
                    modfolders[modfolder.name] = modpath.parent
            else:
                modfolders[modpath.name] = modpath.parent

    # Prepare build folder
    if build.exists():
        print(f"remove old build '{build}'")
        shutil.rmtree(build)

    print(f"prepare build '{build}'")
    os.makedirs(build)

    # Generate Swifty files (mod.srf and repo.json)
    threads = os.cpu_count() // 2
    swifty_run = [
        str(swifty_cli),
        "create",
        str(repojson.as_posix()),
        str(build.as_posix()),
        "--nocopy",
        f"--threads {threads}",
    ]
    if os.name == "posix":
        swifty_run.insert(0, "mono")

    print(f"generate swifty: {swifty_run}")
    swifty_exception = False
    try:
        sp = subprocess.Popen(swifty_run, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        for line in sp.stdout:
            if "TRACE" not in line.strip():
                sys.stdout.write(f"  {line}")
            if "unhandled exception" in line.strip().lower():
                swifty_exception = True
    except (OSError, ValueError, subprocess.SubprocessError) as e:
        print(f"error: swifty generating failed! {e}")
        return 1

    if swifty_exception:
        print("error: swifty generating failed! see exception above")
        return 1

    # Check the list of mods and prioritize preload mods
    print("check mod list")
    mods = [""] * len(PRELOAD_MODS)
    mod_errors = 0
    for mod in build.glob("@*"):
        if mod.name not in modfolders:
            print(f"error: mod folder for '{mod.name}' not found!")
            mod_errors += 1

        if mod.name in PRELOAD_MODS:
            modindex = PRELOAD_MODS.index(mod.name)
            print(f"  preload '{mod.name}' at index {modindex}")
            mods[modindex] = mod
        else:
            mods.append(mod)

    mods = list(filter(None, mods))

    if mod_errors != 0:
        return 2

    print("symlink")
    modline = ""
    for mod in mods:
        modpath = modfolders[mod.name] / mod.name
        print(f"  {modpath} -> {mod}")

        # Assemble the modline for Arma Server
        modline += f"{modpath.as_posix()};"

        # Symlink mod - move generated folder, create symlink and move contents of generated folder back (mod.srf)
        modtmp = Path(f"{mod}_tmp")
        os.rename(mod, modtmp)
        os.symlink(Path("..", "..", modpath), mod)
        for file in modtmp.iterdir():
            shutil.copy2(file, mod)
        shutil.rmtree(modtmp)

    modline = f"{repo} modline:\n  -mod={modline}\n"
    print(modline)
    output.open("a", encoding="utf-8").write(modline)

    return 0


def main():
    # Parse arguments
    parser = argparse.ArgumentParser(description="Swifty Modpack Manager")
    parser.add_argument("repo", type=str, nargs="+", help="names of the repositories to operate on")
    parser.add_argument("-p", "--publish", action="store_true", help="publish the available builds")
    parser.add_argument("-o", "--output", type=Path, default=DEFAULT_OUTPUT, help="output file")
    parser.add_argument("--swifty", type=Path, default=DEFAULT_SWIFTY_CLI,
                        help="path to swifty-cli.exe (default: <this-file>/swifty-cli.exe)")
    args = parser.parse_args()

    if not args.swifty.exists():
        parser.error(f"invalid swifty location '{args.swifty}'")
        return 1

    args.output.open("w", encoding="utf-8")

    for repo in args.repo:
        print(f"repository: {repo}")
        if repo.endswith(".json"):
            repo = os.path.splitext(repo)[0]
        repojson = Path(f"{repo}.json")

        if not repojson.exists():
            parser.error(f"repository '{repo}' does not exist")

        if args.publish:
            return publish(repo)
        else:
            if not can_make_symlinks():
                print("error: cannot create symlinks - run as admin!")
                return 2
            return build(repo, repojson, args.swifty, args.output)

    return 0


if __name__ == "__main__":
    sys.exit(main())
