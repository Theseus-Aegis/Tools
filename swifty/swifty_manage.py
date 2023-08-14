#!/usr/bin/env python3

import argparse
import ctypes
import filecmp
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

MODS_FOLDER = "mods"
OPTIONAL_FOLDER = "mods/optional"
KEYS_GLOBAL_FOLDER = MODS_FOLDER
KEYS_DLC_FOLDER = "mods/keys"
BUILD_FOLDER = "build"
PUBLISH_PATH = "../release"
PRELOAD_MODS = ["@cba_a3", "@ace", "@tac_mods"]
ALWAYS_COPY = ["server"]

SWIFTY_CLI = Path(__file__).resolve().parent / "swifty-cli.exe"
OUTPUT_FILE = f"{os.path.splitext(__file__)[0]}_cfg.log"


def can_make_symlinks():
    # Linux
    if os.name == "posix":
        return True

    # Windows
    try:
        return ctypes.windll.shell32.IsUserAnAdmin() == 1
    except AttributeError:
        return False


def get_swifty_json(repo):
    if repo.endswith(".json"):
        repo = os.path.splitext(repo)[0]
    return Path(f"{repo}.json")


# Check existence of JSON configuration files and presence of the mods
def check_swifty_json(repo):
    repojson = get_swifty_json(repo)

    if not repojson.exists():
        print(f"error: repository file '{repojson}' does not exist!")
        return 1

    print("check mod list")
    mod_errors = 0
    for modfolder, modpath in parse_swifty_json(repojson)[0].items():
        if not (modpath / modfolder).exists():
            print(f"error: mod folder '{modpath / modfolder}' not found!")
            mod_errors += 1

    if mod_errors != 0:
        return 2

    print(f"checked repository: {repo}")
    return 0


# Parse JSON for mod folders in use
def parse_swifty_json(repojson):
    print(f"parse '{repojson}'")
    modfolders = dict()
    dlcs = []

    with open(repojson, "r", encoding="utf-8") as repodata:
        data = json.load(repodata)

        # Mods
        mods = data.get("requiredMods", []) + data.get("optionalMods", [])
        for mod in mods:
            enabled = mod.get("enabled", True) and mod.get("Enabled", True)
            modpath = Path(MODS_FOLDER, mod["modName"])

            print(f"  {modpath.name} -> {modpath.parent} {'' if enabled else '(disabled)'}")
            if not enabled:
                continue

            if modpath.name == "@*":
                for modfolder in modpath.parent.iterdir():
                    print(f"    {modfolder.name} -> {modpath.parent}")
                    modfolders[modfolder.name] = modpath.parent
            elif modpath.name.startswith("@") and modpath.name.endswith("*"):
                for modfolder in modpath.parent.iterdir():
                    if modfolder.name.startswith(modpath.name[:-1]):
                        print(f"    {modfolder.name} -> {modpath.parent}")
                        modfolders[modfolder.name] = modpath.parent
            else:
                modfolders[modpath.name] = modpath.parent

        # DLCs
        for dlc in data.get("requiredDLCS", []):
            if dlc != "":
                print(f"  {dlc} (dlc)")
                dlcs.append(dlc)

    return modfolders, dlcs


def publish(path):
    publish_build = Path(path, BUILD_FOLDER)
    publish_mods = Path(path, MODS_FOLDER)
    build = Path(BUILD_FOLDER)

    # Prepare publish folders
    os.makedirs(publish_build, exist_ok=True)
    os.makedirs(publish_mods, exist_ok=True)

    # Prepare all mod folder data
    modfolders = dict()
    for repojson in Path(MODS_FOLDER).parent.glob("*.json"):
        if (build / os.path.splitext(repojson)[0]).exists():
            modfolders |= parse_swifty_json(repojson)[0]
    for folder in ALWAYS_COPY:
        for modfolder in Path(MODS_FOLDER, folder).glob("@*"):
            modfolders[modfolder.name] = modfolder.parent

    # Copy mods that changed
    print("copy mods")
    for modname, modpath in modfolders.items():
        mod = modpath / modname
        publish_mod = path / modpath / modname

        equal = False
        if mod.exists() and publish_mod.exists():
            modsrf = mod / "mod.srf"
            publish_modsrf = publish_mod / "mod.srf"

            if modsrf.exists() and publish_modsrf.exists():
                equal = filecmp.cmp(modsrf, publish_modsrf)
            else:
                dir_compare = filecmp.dircmp(mod, publish_mod)
                diff_files = dir_compare.diff_files or dir_compare.funny_files
                missing_or_excessive = dir_compare.left_only or dir_compare.right_only
                equal = not diff_files and not missing_or_excessive

        if not equal:
            cleaned = False
            if publish_mod.exists():
                shutil.rmtree(publish_mod)
                cleaned = True

            print(f"  {mod} -> {publish_mod} {'(clean)' if cleaned else '(new)'}")
            os.makedirs(publish_mod.parent, exist_ok=True)
            shutil.copytree(mod, publish_mod)

    # Remove removed mods
    print("cleanup mods")
    modfolder_names = set([d.name for d in modfolders.values()])
    for root, dirs, files in os.walk(publish_mods):
        dirs[:] = [d for d in dirs if d not in modfolders]

        for d in dirs:
            if d not in modfolder_names:
                x = Path(root, d)
                print(f"  {x}")
                shutil.rmtree(x)

    # Clean copy built repos
    removed = []
    for publish_build_repo in publish_build.iterdir():
        shutil.rmtree(publish_build_repo)
        removed.append(publish_build_repo)

    print("copy build")
    for build_repo in build.iterdir():
        publish_build_repo = publish_build / build_repo.name
        print(f"  '{build_repo}' -> '{publish_build_repo}' {'(clean)' if publish_build_repo in removed else '(new)'}")
        # Copy with preserving symlinks - must happen after symlinked copying mods, so they get correctly referenced!
        shutil.copytree(build_repo, publish_build_repo, symlinks=True)

    return 0


def build(repo, swifty_cli, output):
    print(f"repository: {repo}")

    # Lower-case all mod folders, their 'addons' and PBO files
    print("lower-case")
    for root, dirs, files in os.walk(MODS_FOLDER, topdown=False):
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

    build = Path(BUILD_FOLDER, repo)
    repojson = get_swifty_json(repo)
    modfolders, dlcs = parse_swifty_json(repojson)

    # Prepare build folder
    if build.exists():
        print(f"remove old build '{build}'")
        shutil.rmtree(build)
    os.makedirs(build)

    # Generate Swifty files (mod.srf and repo.json)
    threads = os.cpu_count() // 2
    swifty_run = [
        str(swifty_cli.as_posix()),
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
        return 2

    if swifty_exception:
        print("error: swifty generating failed! see exception above")
        return 2

    # Check the list of mods and prioritize preload mods
    print("check build list")
    mods = [""] * len(PRELOAD_MODS)
    mod_errors = 0
    for mod in build.glob("@*"):
        if mod.name not in modfolders:
            print(f"error: mod folder for '{mod.name}' not in mod list!")
            mod_errors += 1

        if mod.name in PRELOAD_MODS:
            modindex = PRELOAD_MODS.index(mod.name)
            print(f"  preload '{mod.name}' at index {modindex}")
            mods[modindex] = mod
        else:
            mods.append(mod)

    mods = list(filter(None, mods))

    if mod_errors != 0:
        return 3

    # Symlink mods and apply generated checksums
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
            shutil.copyfile(file, mod / file.name)
        shutil.rmtree(modtmp)

    for dlc in dlcs:
        modline = f"{dlc};{modline}"

    # Assemble keys
    print("keys")
    key_errors = 0

    build_keys = build / "keys"
    if build_keys.exists():
        print(f"remove old keys '{build_keys}'")
        shutil.rmtree(build_keys)
    os.makedirs(build_keys)

    for mod in mods:
        modkeys = mod / "keys"
        for modkey in modkeys.glob("*.bikey"):
            print(f"  {modkey} -> {build_keys}")
            shutil.copyfile(modkey, build_keys / modkey.name)

    for dlc in dlcs:
        key = Path(KEYS_DLC_FOLDER) / f"{dlc}.bikey"
        if key.exists():
            print(f"  {key} -> {build_keys} (dlc)")
            shutil.copyfile(key, build_keys / key.name)
        else:
            print(f"error: key '{key}' not found!")
            key_errors += 1

    for key in Path(KEYS_GLOBAL_FOLDER).glob("*.bikey"):
        print(f"  {key} -> {build_keys} (global)")
        shutil.copyfile(key, build_keys / key.name)

    if key_errors != 0:
        return 4

    # Report and log config
    modline = f"{repo} modline:\n  -mod={modline}\n"
    print(modline)
    output.open("a", encoding="utf-8").write(modline)

    return 0


def move_optionals():
    print("move optionals")
    os.makedirs(OPTIONAL_FOLDER, exist_ok=True)

    for optionals_type in ("optionals", "compats"):
        for optionals_dir in Path(MODS_FOLDER).glob(f"*/@*/{optionals_type}"):

            for optional in optionals_dir.glob("@*"):
                target = Path(OPTIONAL_FOLDER) / optional.name
                if target.exists():
                    shutil.rmtree(target)
                print(f"  {optional} -> {target}")
                os.rename(optional, target)

            print(f"  remove '{optionals_dir}'")
            shutil.rmtree(optionals_dir)


def main():
    min_python = (3, 9)
    if sys.version_info < min_python:
        sys.exit(f"Python {min_python[0]}.{min_python[1]} or later is required.")

    # Parse arguments
    parser = argparse.ArgumentParser(description="Swifty Modpack Manager")
    parser.add_argument("repo", type=str, nargs="*", help="names of the repositories to operate on")
    parser.add_argument("-p", "--publish", type=Path, nargs="?", const=PUBLISH_PATH, help="publish the available builds")
    parser.add_argument("-o", "--output", type=Path, default=OUTPUT_FILE, help="output file")
    parser.add_argument("--only-optional", action="store_true", help="only move optionals")
    parser.add_argument("--swifty", type=Path, default=SWIFTY_CLI,
                        help="path to swifty-cli.exe (default: <this-file>/swifty-cli.exe)")
    args = parser.parse_args()

    if args.repo:
        if not args.swifty.exists():
            parser.error(f"invalid swifty location '{args.swifty}'")

        if not can_make_symlinks():
            print("error: cannot create symlinks - run as admin!")
            return 1

        move_optionals()

        for repo in args.repo:
            if check_swifty_json(repo) != 0:
                print(f"error: invalid repository '{repo}'")
                return 1

        args.output.open("w", encoding="utf-8")

        success = 0
        for repo in args.repo:
            success = build(repo, args.swifty, args.output)
            if success != 0:
                return success
    elif args.only_optional:
        move_optionals()
        return 0
    elif args.publish is None:
        parser.error("no repositories given")

    if args.publish is not None:
        return publish(args.publish)

    return 0


if __name__ == "__main__":
    sys.exit(main())
