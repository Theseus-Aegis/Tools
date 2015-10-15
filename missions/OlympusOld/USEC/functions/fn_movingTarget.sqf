/*
 * Author: zooloo75
 * Modified: Jonpas
 *
 * Makes the desired target move back and forth.
 *
 * Arguments:
 * 0: Target (Object)
 * 1: Direction (Number)
 * 2: Distance to move (Number)
 * 3: Speed (Number)
 * 4: Pause time (Number)
 *
 * Return Value:
 * None
 */

private ["_target","_distance","_speed","_dir"];
_target = _this select 0;
_dir = _this select 1;
_distance = _this select 2;
_speed = _this select 3;
_pause = _this select 4;

while {true} do
{
  sleep _pause;
  for "_i" from 0 to _distance/_speed do
  {
    _target setPos 
    [
      (position _target select 0) + ((sin (_dir)))*_speed,
      (position _target select 1) + ((cos (_dir)))*_speed,
      0
    ];
    sleep 0.01;
  };
  sleep _pause;
  for "_i" from 0 to _distance/_speed do
  {
    _target setPos 
    [
      (position _target select 0) - (sin (_dir))*_speed,
      (position _target select 1) - ((cos (_dir)))*_speed,
      0
    ];
    sleep 0.01;
  };
};
