import json
import sys

if __name__ == '__main__':
    optionals_file = sys.argv[1] if len(sys.argv) > 1 else "optionals.json"
    try:
        with open(optionals_file) as fp:
            data = json.load(fp)
    except FileNotFoundError:
        print(f"File '{optionals_file}' not found")

    for mod in data["mods"]:
        for layer in mod["optionals"].keys():
            for optional in mod["optionals"][layer]:
                origin = f"{data['paths'][mod['layer']]}{mod['name']}/optionals/{optional}"
                dest = f"{data['paths'][layer]}{mod['name']}_{optional}"
                print(f"{origin} —> {dest}")
                # TODO: move files from origin to dest
                #  TODO: eror handling scenarios:
                #   it's possible that /optionals/ does not exist if the mod wasn't updated in this release -> just skip it
                #   it's possible that certain optional mod gets removed from mod itself -> show an error that optional XXX from mod YYY is missing

    # TODO: remove /optionals/ folder (if present) from all of the mods
