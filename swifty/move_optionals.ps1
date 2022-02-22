# Place '@mod' into 'mods/<sub-folder>' (with 'optionals' intact).
# This script will move wanted optionals out, and delete the entire source optionals folder.

# STATIC VARIABLES
# Relative path to modpack folder
$modpack = "mods/core"

# Mod folder with list of optionals to move
$mods = @{} # initialize
$mods["@tac_mods"] = @(
    "a3_acre_racks",
    "bnae_falkor_compat_ace",
    "bnae_mk1_compat_ace",
    "bnae_rk95_compat_ace",
    "bnae_trg42_compat_ace",
    "compat_amp",
    "compat_cup_vehicles",
    "compat_melb",
    "cup_ace_hearing",
    "cup_units_nouniformrestrictions",
    "cup_vehicles_acre_racks",
    "melb_ace_fastroping",
    "melb_tweaks",
    "milgp_ace_hearing"
)

$mods["@theseus_services"] = @(
    "variants_cup",
    "variants_melb",
    "weapons_apex"
)

$mods["@ace"] = @(
    "nouniformrestrictions",
    "noactionmenu",
    "particles",
    "realisticdispersion"
)

$mods["@zen"] = @(
    "compat_ace"
)

foreach ($mod in $mods.keys) {
    Write-Host $mod
    foreach ($optional in $mods.$mod) {
        $optionalName = "$($mod)_$($optional)"
        $optionalsPath = "$($modpack)/$($mod)/optionals"
        $optionalPath = "$($optionalsPath)/$optionalName"
        if (Test-Path $optionalPath) {
            if (Test-path $modpack/$optionalName) {
                Write-Host "- ERROR: $($optional) already exists!"
            } else {
                Move-Item $optionalPath -Destination $modpack
                Write-Host "- Moved $($optional)"
            }
        } else {
            Write-Host "- ERROR: $($optional) not found!"
        }
    }

    if (Test-Path $optionalsPath) {
        Remove-Item $optionalsPath -Recurse
    }
    Write-Host "removed $($optionalsPath)"
}
