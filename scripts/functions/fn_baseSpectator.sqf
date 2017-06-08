/*
 * Author: Jonpas
 * Adds dynamic spectator availability through CBA Chat Commands and ACE3 Interaction Menu.
 * Call from initPlayerLocal.sqf.
 *
 * Arguments:
 * 0: Player <OBJECT>
 * 1: Spectator Object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, spectatorObject] call TAC_Scripts_fnc_baseSpectator
 */

params ["_player", "_object"];

// Event for closing spectator from other machines
["tac_baseSpectatorOff", {
    if (_thisArgs getVariable ["tac_baseSpectatorSet", false]) then {
        [false] call ace_spectator_fnc_setSpectator;
        _thisArgs setVariable ["tac_baseSpectatorSet", false];
    };
}, _player] call CBA_fnc_addEventHandlerArgs;

// Player open spectator on specified object
private _actionOpen = [
    "tac_baseSpectatorOpen",
    "Open Spectator",
    "\a3\3den\data\cfg3den\camera\cameratexture_ca.paa",
    {
        (_this select 2) params ["_player"];
        [true] call ace_spectator_fnc_setSpectator;
        _player setVariable ["tac_baseSpectatorSet", true];
        systemChat "[TAC] Entered Spectator - Write '#tac-spectator-exit' in chat to exit";
    },
    {
        (_this select 2) params ["", "_object"];
        _object getVariable ["tac_baseSpectatorAllowed", false]
    },
    {},
    [_player, _object]
] call ace_interact_menu_fnc_createAction;

[_object, 0, ["ACE_MainActions"], _actionOpen] call ace_interact_menu_fnc_addActionToObject;

// Admin chat command to toggle spectator availability
["tac-spectator", {
    params ["_args"];
    if (_args == "on") then {
        _thisArgs setVariable ["tac_baseSpectatorAllowed", true, true];
        ["ace_common_systemChatGlobal", "[TAC] Spectator Allowed"] call CBA_fnc_globalEvent;
    } else {
        if (_thisArgs getVariable ["tac_baseSpectatorAllowed", false]) then {
            ["tac_baseSpectatorOff", nil, call CBA_fnc_players] call CBA_fnc_targetEvent;
            _thisArgs setVariable ["tac_baseSpectatorAllowed", false, true];
            ["ace_common_systemChatGlobal", "[TAC] Spectator Prohibited"] call CBA_fnc_globalEvent;
        };
    };
}, nil, _object] call CBA_fnc_registerChatCommand;

// Player chat command to exit spectator
["tac-spectator-exit", {
    [false] call ace_spectator_fnc_setSpectator;
    _thisArgs setVariable ["tac_baseSpectatorSet", false];
}, "all", _player] call CBA_fnc_registerChatCommand;


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
