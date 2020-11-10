# Place '@tac_mods' into 'tac_core' (with 'optionals' intact).
# This script will copy wanted optionals out, but will NOT delete them from original.

# STATIC VARIABLES
# Relative path to modpack folder
$modpack = "tac_core"
# Mod folder with list of optionals to copy
$mods = @{} # initialize
$mods["@tac_mods"] = @(
    "a3_acre_racks",
    "bnae_falkor_compat_ace",
    "bnae_mk1_compat_ace",
    "bnae_rk95_compat_ace",
    "bnae_trg42_compat_ace",
    "compat_amp",
    "compat_cup_vehicles",
    "compat_cup_weapons",
    "compat_melb",
    "cup_ace_hearing",
    "cup_units_nouniformrestrictions",
    "cup_vehicles_acre_racks",
    "melb_ace_fastroping",
    "melb_tweaks",
    "milgp_ace_hearing"
)

$mods["@theseus_services"] = @(
	"arcadian",
	"variants_cup",
	"variants_melb",
	"weapons_apex"
)

foreach ($mod in $mods.keys) {
    Write-Host $mod
    foreach ($optional in $mods.$mod) {
        $optionalName = "$($mod)_$($optional)"
        $optionalPath = "$($modpack)\$($mod)\optionals\$optionalName"
        if (Test-Path $optionalPath) {
            if (Test-path $modpack\$optionalName) {
                Write-Host "- ERROR: $($optional) already exists!"
            } else {
                Copy-Item $optionalPath -Destination $modpack -Recurse
                Write-Host "- Copied $($optional)"
            }
        } else {
            Write-Host "- ERROR: $($optional) not found!"
        }
    }
}

Read-Host -Prompt "Press Enter to exit"
