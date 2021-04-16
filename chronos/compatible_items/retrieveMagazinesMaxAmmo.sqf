/*
 * Author: Jonpas
 * Retrieves maximum ammo (bullet count) of all magazines and pastes the data to clipboard.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Data <ARRAY>
 *
 * Example:
 * [] execVM "retrieveMagazinesMaxAmmo.sqf";
 *
 * Public: No
 */

// [ [magazine, magazine, ...], [maxAmmo, maxAmmo, ...] ]
private _magazines = [];
private _maxAmmo = [];

{
    _magazines pushBack configName _x;
    _maxAmmo pushBack (getNumber (_x >> "count"));
} forEach (configProperties [configFile >> "CfgMagazines", "getNumber (_x >> 'scope') == 2", true]);

private _data = [_magazines, _maxAmmo];

copyToClipboard (str _data); // Too long for diag_log

_data
