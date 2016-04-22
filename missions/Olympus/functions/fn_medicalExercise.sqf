/*
Author: Rory

Function: Makes 2 AI run into house and sets specific damage for medical practice.
*/

params ["_victims", "_controller", "_mine", "_runWaypoint"];

// @todo - change to ACE Action
_controller addAction ["Commence exercise", {
    (_this select 3) params ["_victims", "_runWaypoint"];

    // Move victims to position
    {
        _x move (getPos _runWaypoint);
    } forEach _victims;
}, [_victims, _runWaypoint]];


[{
    params ["_victims", "_runWaypoint"];

    private _nearWaypointObjects = nearestObjects [ASLToAGL (getPosASL _runWaypoint), ["CAManBase"], 2];
    diag_log _nearWaypointObjects;
    _nearWaypointObjects = _nearWaypointObjects select [0, 2];

    (([_victims select 0, _victims select 1] isEqualTo _nearWaypointObjects) || ([_victims select 1, _victims select 0] isEqualTo _nearWaypointObjects))
}, {
    params ["_victims"];

    // Apply damage to all victims
    {
        [_x, 0.3, "leg_r", "bullet"] call ace_medical_fnc_addDamageToUnit;
        [_x, 0.1, "head", "bullet"] call ace_medical_fnc_addDamageToUnit;
        [_x, 0.3] call ace_medical_fnc_adjustPainLevel;
    } forEach _victims;

    // Apply damage to specific victims
    [_victims select 0] call ace_medical_fnc_setCardiacArrest;
    [_victims select 1, true, 2, true] call ace_medical_fnc_setUnconscious;
}, [_victims, _runWaypoint]] call ace_common_fnc_waitUntilAndExecute;
