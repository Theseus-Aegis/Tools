_weapons = []; // [weap1, weap2, weap3]
_magazines = []; // [ [weap1mag1, weap1mag2, weap1mag3], [weap2mag1, weap2mag2, weap2mag3] ]
_combined = []; // [ [weapon, magazine1], [weapon, magazine2] ]

_config = configFile >> "CfgWeapons";

for "_i" from 0 to (count _config - 1) do {
    _configWeapon = _config select _i;
    _configMagazines = _configWeapon >> "magazines"; // Exclude weapons without compatible magazines config entry
    _linkedItems = _configWeapon >> "LinkedItems"; // Exclude linked items (weapons with preset attachments)

    if (isArray _configMagazines && !(isClass _linkedItems)) then {
        _compatibleMagazines = if ((getArray _configMagazines) isEqualTo []) then {false} else {true}; // Exclude weapons with no compatible magazines
        _weaponScope = if ((getNumber (_configWeapon >> "scope")) == 2) then {true} else {false}; // Only scope 2 (public) weapons
        _weaponType = if ((getNumber (_configWeapon >> "type")) in [1, 2, 4, 2^12]) then {true} else {false}; // Only primary (1), handguns (2), secondaries (4) and binoculars (4096)

        if (_compatibleMagazines && _weaponScope && _weaponType) then {
            _weapons pushBack (configName _configWeapon);
            _magazines pushBack (getArray _configMagazines);
            _combined pushBack (configName _configWeapon);
            _combined pushBack (getArray _configMagazines)
        };
    };
};

_br = toString [13, 10]; // CRLF
_compatibleMagazinesString = [_weapons, _magazines] joinString _br;
//copyToClipboard _compatibleMagazinesString;
copyToClipboard str(_combined);
