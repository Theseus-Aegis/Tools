params ["_shooter", "_target", "_thisList"];

private _weapon = (weaponState _shooter) select 1;

_shooter doTarget _target;

[{
    params ["_args", "_pfhId"];
    _args params ["_shooter", "_weapon", "_thisList"];

    // Exit and remove PFH if player left trigger
    if ((_thisList select {isPlayer _x}) isEqualTo []) exitWith {
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    _shooter forceWeaponFire [_weapon, "Single"];
}, 0.5, [_shooter, _weapon, _thisList]] call CBA_fnc_addPerFrameHandler;
