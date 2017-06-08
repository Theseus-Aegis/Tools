/*
 * Author: John Doe (atlasicus)
 *
 * Used to determine how close to a designated point 
 * a shooter has hit
 *
 * Arguments:
 * 0: object to check (Number)
 * 1: hit position(array)
 * 2: tolerance (Number)
 * 3: max score value (Number)
 *
 * Returns:
 * score for shot
 *
 */
USEC_SERVER_ACCURACY_Value = 0;
_targetObject = (_this select 0);
_targetPos = (getPosASL _targetObject);
_hitPosition = (_this select 1);

_resultX = (_hitPosition select 0) - (_targetPos select 0);
_resultY = (_hitPosition select 1) - (_targetPos select 1);
_resultZ = (_hitPosition select 2) - (_targetPos select 2);

_center = USEC_SERVER_ALL_COURSES_BullseyePoint;
_hitDelta = [_resultX, _resultY, _resultZ];

_distance = _center vectorDistance _hitDelta;

if((_distance min (_this select 2)) == _distance) then {
    USEC_SERVER_ACCURACY_Value = USEC_SERVER_ACCURACY_Value + (_this select 3);
    
}else {
    USEC_SERVER_ACCURACY_Value = USEC_SERVER_ACCURACY_Value + ((_this select 3) * (1 - (_distance - (_this select 2))));
};

_returnValue = USEC_SERVER_ACCURACY_Value;

_returnValue;