/*
 * Author: John Doe (atlasicus)
 *
 * Randomizes popup targets for basic training course
 *
 * Arguments:
 * 0: Course Selection (Number)
 *
 */

_selection = (_this select 0);
_targets = [];
if( _selection == 1) then {
    _targets = USEC_SERVER_BASIC_TRAINING_PEEL_Targets;
    {
        [[_x], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
    } forEach _targets;
    
    while{USEC_SERVER_BASIC_TRAINING1_Enabled} do {
      // Random selection of a target
    _randomTarget = _targets select (floor (random (count _targets)));
    _randomTarget2 = _targets select (floor (random (count _targets)));
    
    while{_randomTarget == _randomTarget2} do {
        _randomTarget2 = _targets select (floor (random (count _targets)));
    };

    // Pop target UP
    [[_randomTarget], "USEC_MP_TRAINING_targetUp"] call BIS_fnc_MP;
    [[_randomTarget2], "USEC_MP_TRAINING_targetUp"] call BIS_fnc_MP;

    // Wait and pop target DOWN
    _currentTime = time;
    waitUntil {time > _currentTime + USEC_GLOBAL_CONFIG_BASIC_TimeUpInSeconds}; //Found in CONFIG.sqf
    
    //Reset marker
    _currentTime = time;
    [[_randomTarget], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
    [[_randomTarget2], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
    
    waitUntil {time > _currentTime + USEC_GLOBAL_CONFIG_BASIC_TimeBetweenPopInSeconds}; //Found in CONFIG.sqf
   };
};
if( _selection == 2) then {
  _targets = USEC_SERVER_BASIC_TRAINING_BOUNDING_Targets;
  
  while{USEC_SERVER_BASIC_TRAINING2_Enabled} do {
    // Random selection of a target
  _randomTarget = _targets select (floor (random (count _targets)));
  _randomTarget2 = _targets select (floor (random (count _targets)));
  
  while{_randomTarget == _randomTarget2} do {
      _randomTarget2 = _targets select (floor (random (count _targets)));
  };

  // Pop target UP
  [[_randomTarget], "USEC_MP_TRAINING_targetUp"] call BIS_fnc_MP;
  [[_randomTarget2], "USEC_MP_TRAINING_targetUp"] call BIS_fnc_MP;

  // Wait and pop target DOWN
  _currentTime = time;
  waitUntil {time > _currentTime + USEC_GLOBAL_CONFIG_BASIC_TimeUpInSeconds}; //Found in CONFIG.sqf
  
  //Reset marker
  _currentTime = time;
  [[_randomTarget], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
  [[_randomTarget2], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
  
  waitUntil {time > _currentTime + USEC_GLOBAL_CONFIG_BASIC_TimeBetweenPopInSeconds}; //Found in CONFIG.sqf
 };
};
  

 
 
 