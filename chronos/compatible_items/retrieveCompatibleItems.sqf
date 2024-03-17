/*
 * Author: Jonpas
 * Retrieves compatible items of all weapons (primary, secondary, handgun, binoculars) and pastes the data to clipboard.
 * It is faster to call this as a function rather than spawn it, but it is laggy.
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

private _data = []; // [ weapon, [items], weapon, [items], ... ]

{
    private _weaponClassname = configName _x;

    // Compatible Magazines
    if (_type == 0) then {
        // Weapon magazines and all muzzles magazines
        private _magazines = [_x, true] call CBA_fnc_compatibleMagazines;

        // Exclude weapons without compatible magazines
        if !(_magazines isEqualTo []) then {
            _data pushBack _weaponClassname;
            _data pushBack _magazines;
        };
    };

    // Compatible Attachments
    if (_type == 1) then {
        private _attachments = [_weaponClassname] call CBA_fnc_compatibleItems;

        // Exclude weapons without compatible attachments
        if !(_attachments isEqualTo []) then {
            _data pushBack _weaponClassname;
            _data pushBack _attachments;
        };
    };
} forEach (
    configProperties [
        configFile >> "CfgWeapons",
        "isClass _x &&" +
        "{getNumber (_x >> 'type') in [1, 2, 4, 2^12]} && " + // Only primary (1), handguns (2), secondaries (4) and binoculars (4096)
        "{getNumber (_x >> 'scope') == 2} && " + // Only scope 2 (public) weapons
        "{!isClass (_x >> 'LinkedItems') || {count (_x >> 'LinkedItems') == 0}}", // Exclude linked items (weapons with preset attachments) or empty linkedItems class
        true
    ]
);

copyToClipboard (str _data); // Too long for diag_log

_data
