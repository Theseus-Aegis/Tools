/*
 * Author: John Doe (atlasicus)
 *
 * For use in single player editing only
 * Used to measure hit points on a given 
 * Target
 *
 * Arguments:
 * none
 *
 */

_targetObject = (_this select 0);
_targetPos = (getPosASL _targetObject);
_hitPosition = (_this select 1);

_resultX = (_hitPosition select 0) - (_targetPos select 0);
_resultY = (_hitPosition select 1) - (_targetPos select 1);
_resultZ = (_hitPosition select 2) - (_targetPos select 2);

_center = [0.0, 0.0, 0.94];
_hitDelta = [_resultX, _resultY, _resultZ];

_distance = _center distance _hitDelta;

player globalChat "Result X: " + str _resultX;
player globalChat "Result Y: " + str _resultY;
player globalChat "Result Z: " + str _resultZ;
player globalChat "Distance: " + str _distance;

