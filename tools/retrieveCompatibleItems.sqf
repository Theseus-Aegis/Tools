/*
 * Author: Jonpas
 * Retrieves compatible items of all weapons (primary, secondary, handgun, binoculars) and pastes the data to clipboard.
 * Requires: CBA A3
 *
 * Arguments:
 * 0: Type (0 - magazines, 1 - attachments) <NUMBER> (default: 0)
 *
 * Return Value:
 * Data <ARRAY>
 *
 * Example:
 * [0] execVM "retrieveCompatibleItems.sqf";
 *
 * Public: No
 */

params [["_type", 0]];

private _data = []; // [ [weapon, [items]], [weapon, [items] ]

private _config = configFile >> "CfgWeapons";

for "_i" from 0 to count _config - 1 do {
    private _weapon = _config select _i;
    private _weaponClassname = configName _weapon;

    // Weapon checks
    private _hasLinkedItems = isClass (_weapon >> "LinkedItems"); // Exclude linked items (weapons with preset attachments)
    private _isPublicScope = getNumber (_weapon >> "scope") == 2; // Only scope 2 (public) weapons
    private _isWantedWeaponType = getNumber (_weapon >> "type") in [1, 2, 4, 2^12]; // Only primary (1), handguns (2), secondaries (4) and binoculars (4096)

    // Compatible Magazines check
    private _magazines = getArray (_weapon >> "magazines");
    private _hasMagazines = !(_magazines isEqualTo []); // Exclude weapons without compatible magazines

    // Compatible Attachments check
    private _attachments = [_weaponClassname] call CBA_fnc_compatibleItems;
    private _hasAttachments = !(_attachments isEqualTo []); // Exclude weapons without compatible attachments

    // Add to data
    if (!_hasLinkedItems && _isPublicScope && _isWantedWeaponType) then {
        if (_type == 0 && _hasMagazines) then {
            _data pushBack _weaponClassname;
            _data pushBack _magazines;
        };
        if (_type == 1 && _hasAttachments) then {
            _data pushBack _weaponClassname;
            _data pushBack _attachments;
        };
    };
};

copyToClipboard str(_data); // Too long for diag_log

_data
