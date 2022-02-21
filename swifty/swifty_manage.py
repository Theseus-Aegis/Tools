#!/usr/bin/env python3

import argparse
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

MODS_PATH = "mods"
BUILD_PATH = "build"
PUBLISH_PATH = "publish"
SWIFTY_CLI = Path(__file__).parent / "swifty-cli.exe"


def publish(repo):
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


def build(repo, repojson):
    build = Path(BUILD_PATH, repo)

    # Parse JSON for mod folders in use
    print(f"parse '{repojson}'")
    modfolders = {"": []}
    with open(repojson, "r", encoding="utf-8") as repodata:
        data = json.load(repodata)
        mods = data["requiredMods"] + data["optionalMods"]
        for mod in mods:
            mod = Path(mod["modName"])
            print(f"  {mod.name} -> {mod.parent}")
            if mod.name == "@*":
                modfolders[""].append(mod.parent)
            else:
                modfolders[mod.name] = mod.parent

    # Prepare build folder
    if build.exists():
        print(f"remove old build '{build}'")
        shutil.rmtree(build)

    print(f"prepare build '{build}'")
    os.makedirs(build)

    # Generate Swifty files (mod.srf and repo.json)
    threads = os.cpu_count() // 2
    swifty_cli = [
        "mono" if os.name == "posix" else "",
        str(SWIFTY_CLI),
        "create",
        str(repojson),
        str(build),
        "--nocopy",
        f"--threads {threads}",
    ]
    print(f"generate swifty: {swifty_cli}")
    try:
        sp = subprocess.Popen(swifty_cli, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        for line in sp.stdout:
            if "TRACE" not in line.strip():
                sys.stdout.write(f"  {line}")
    except subprocess.CalledProcessError as e:
        print(f"error: swifty generating failed! {e}")
        return 1

    # Assemble the modline for Arma Server and symlink mods
    print("symlink")
    modline = "-mod="
    modline_errors = 0
    for mod in build.glob("@*"):
        modpath = ""
        if mod.name in modfolders:
            modline += f"{modfolders[mod.name]}/{mod.name};"
        else:
            for modfolder in modfolders[""]:
                if (MODS_PATH / modfolder / mod.name).exists():
                    modpath = modfolder / mod.name
                    modline += f"mods/{modpath};"
                    break
            else:
                print(f"error: mod folder for '{mod.name}' not found!")
                modline_errors += 1

        # Move generated folder, create symlink and move contents of generated folder back (mod.srf)
        print(f"  {modpath} -> {mod}")
        modtmp = Path(f"{mod}_tmp")
        os.rename(mod, modtmp)
        os.symlink((MODS_PATH / modpath).resolve(), mod)  # resolve to get absolute symlink target
        for file in modtmp.iterdir():
            shutil.copy2(file, mod)
        shutil.rmtree(modtmp)

    if modline_errors != 0:
        return 2

    print(f"arma modline:\n  {modline}")

    return 0


def main():
    # Parse arguments
    parser = argparse.ArgumentParser(description="Swifty Modpack Manager")
    parser.add_argument("repo", type=str, nargs="+", help="names of the repositories to operate on")
    parser.add_argument("-p", "--publish", action="store_true", help="publish the available builds")
    parser.add_argument("--swifty", type=Path, help="path to swifty-cli.exe (default: <this-file>/swifty-cli.exe)")
    args = parser.parse_args()

    if args.swifty:
        if args.swifty.exists():
            global SWIFTY_CLI
            SWIFTY_CLI = args.swifty
        else:
            print("warning: invalid swifty location - falling back to default")

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
            return build(repo, repojson)

    return 0


if __name__ == "__main__":
    sys.exit(main())
