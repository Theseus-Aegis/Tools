/* InitPopUpTarget.sqf
 *
 * SYNTAX:      _dummy = [Object, Number, Boolean] execVM "InitPopUpTarget.sqf
 *
 * PARAMETERS:  Object:  A pop-up target
 *              Number:  The number of hits it takes to knock the target down
 *              Boolean: If set to True, the target will pop up again.
 *
 * NOTES:       This function is meant to be placed in the Initialization field
 *              of a pop-up target.
 *
 * Author: http://www.ofpec.com/forum/index.php/topic,32607.msg224892.html?PHPSESSID=571720c2df8cd07ce9844f1efd0c2fef#msg224892
 */


nopop = true;

_target       = _this select 0;
_requiredHits = _this select 1;
_isPopUp      = _this select 2;

_hitHandler = {
    private ["_target", "_requiredHits", "_isPopUp", "_hitCount", "_keepUp"];
    _target       = _this select 0;
    _requiredHits = _this select 1;
    _isPopUp      = _this select 2;
    if (_target animationPhase "terc" > 0.1) exitWith {};
    _hitCount = (_target getVariable "HitCounter") + 1;
    _keepUp = true;
    if (_hitCount == _requiredHits) then {
        _hitCount = 0;
        _target animate ["terc", 1];
        sleep 3;
        _keepUp = _isPopUp;
    };
    if _keepUp then {
        _target animate ["terc", 0];
    };
    _target setVariable ["HitCounter", _hitCount];
};

_target setVariable ["HitCounter", 0];
_target setVariable ["AdvPopUp_OnHit_Params", _this];
_target setVariable ["AdvPopUp_OnHit_Handler", _hitHandler];

_code = {
    _t = _this select 0;
    (_t getVariable "AdvPopUp_OnHit_Params") spawn (_t getVariable "AdvPopUp_OnHit_Handler"); // weird!
};

_index = _target addEventHandler ["Hit", _code];
_target setVariable ["AdvPopUp_OnHit_Index", _index];