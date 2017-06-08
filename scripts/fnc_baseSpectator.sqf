/*
    Call from initPlayerLocal.sqf through CfgFunctions or compile directly:
        params ["_player"];
        [_player] call compile preprocessFileLineNumbers "functions\fnc_baseSpectator.sqf";

    Define SPECATOR_OBJECT defined below this comment.
*/
#define SPECTATOR_OBJECT baseSpectator // Object where spectator is toggled on

params ["_player"];

// Event for closing spectator from other machines
["tac_baseSpectatorOff", {
    if (_thisArgs getVariable ["tac_baseSpectatorSet", false]) then {
        [false] call ace_spectator_fnc_setSpectator;
        _thisArgs setVariable ["tac_baseSpectatorSet", false];
    };
}, _player] call CBA_fnc_addEventHandlerArgs;

// Player open spectator on specified object
private _actionOpenSpectator = [
    "tac_baseSpectatorOpen",
    "Open Spectator",
    "\A3\UI_F_Curator\Data\Displays\RscDisplayCurator\modeUnits_ca.paa",
    {
        [true] call ace_spectator_fnc_setSpectator;
        (_this select 2) setVariable ["tac_baseSpectatorSet", true];
    },
    {
        SPECTATOR_OBJECT getVariable ["tac_baseSpectatorEnabled", false]
    },
    {},
    _player
] call ace_interact_menu_fnc_createAction;

[SPECTATOR_OBJECT, 0, ["ACE_MainActions"], _actionOpenSpectator] call ace_interact_menu_fnc_addActionToObject;

// Admin chat command to toggle spectator availability
["tac-spectator", {
    params ["_args"];
    if (_args == "on") then {
        SPECTATOR_OBJECT setVariable ["tac_baseSpectatorEnabled", true, true];
    } else {
        SPECTATOR_OBJECT setVariable ["tac_baseSpectatorEnabled", false, true];
        ["tac_baseSpectatorOff", nil, call CBA_fnc_players] call CBA_fnc_targetEvent;
    };
}] call CBA_fnc_registerChatCommand;

// Player chat command to exit spectator
["tac-spectator-exit", {
    [false] call ace_spectator_fnc_setSpectator;
    ace_player setVariable ["tac_baseSpectatorSet", false];
}, "all"] call cba_fnc_registerChatCommand;


// Can't add ACE canInteractWith exception in SQF
/*
private _actionCloseSpectator = [
    "tac_baseSpectatorClose",
    "Close Spectator",
    "\A3\UI_F_Curator\Data\Displays\RscDisplayCurator\modeUnits_ca.paa",
    {
        //TODO stage, set?
        [false] call ace_spectator_fnc_setSpectator;
    },
    {
        (_this select 2) getVariable ["tac_baseSpectatorSet", false];
    },
    {},
    _player
] call ace_interact_menu_fnc_createAction;

[_player, 1, ["ACE_SelfActions"], _actionCloseSpectator] call ace_interact_menu_fnc_addActionToObject;
*/
