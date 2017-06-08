/*
 * Author: John Doe (atlasicus), Jonpas
 *
 * Randomizes popup targets and records the metrics about the firing session
 *
 * Arguments:
 * none
 *
 */
 // target = TargetP_Inf2_NoPop_F;
USEC_SERVER_MG_TargetPopupTest = true;
USEC_SERVER_MG_TargetPupupTestKilled = false;
USEC_SERVER_MG_InvalidTestPlayer = false;
USEC_SERVER_MG_InvalidTestWeapon = false;
USEC_SERVER_MG_TargetHitCount = 0;

_popupCounter = 1;
USEC_SERVER_MG_row = 1;
USEC_SERVER_MG_rowCount = USEC_GLOBAL_CONFIG_MG_EXAM_NumbersPerRow;

if(count USEC_MP_STATIC_RIFLE_all_targets > 0) then {
    _rowCounter = 1;
    _row = 1;
    _is3Row = false;
    
    {
      _pos = getPos _x;
      deleteVehicle _x;
      if(_row == 1) then {
          _is3Row = false;
          _target =  createVehicle["TargetP_Inf2_NoPop_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP; 
          USEC_MP_STATIC_MG_lane4Targets = USEC_MP_STATIC_MG_lane4Targets + [_target];
          USEC_MP_STATIC_MG_all_targets = USEC_MP_STATIC_MG_all_targets + [_target];
        };
      if(_row == 2) then {
          _is3Row = true;
          _target =  createVehicle["TargetP_Inf2_NoPop_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP; 
          USEC_MP_STATIC_MG_lane3Targets = USEC_MP_STATIC_MG_lane3Targets + [_target];
          USEC_MP_STATIC_MG_all_targets = USEC_MP_STATIC_MG_all_targets + [_target];
        };
      if(_row == 3) then {
          _is3Row = false;
          _target =  createVehicle["TargetP_Inf2_NoPop_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP; 
          USEC_MP_STATIC_MG_lane2Targets = USEC_MP_STATIC_MG_lane2Targets + [_target];
          USEC_MP_STATIC_MG_all_targets = USEC_MP_STATIC_MG_all_targets + [_target];
        };
      if(_row == 4) then {
          _is3Row = true;
          _target =  createVehicle["TargetP_Inf2_NoPop_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP; 
          USEC_MP_STATIC_MG_lane1Targets = USEC_MP_STATIC_MG_lane1Targets + [_target];
          USEC_MP_STATIC_MG_all_targets = USEC_MP_STATIC_MG_all_targets + [_target];
        };
      if(_row == 5) then {
          _is3Row = false;
          _target =  createVehicle["TargetP_Inf2_NoPop_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
          USEC_MP_STATIC_MG_lane8Targets = USEC_MP_STATIC_MG_lane8Targets + [_target];
          USEC_MP_STATIC_MG_all_targets = USEC_MP_STATIC_MG_all_targets + [_target];
        };
      if(_row == 6) then { 
          _is3Row = true;
          _target =  createVehicle["TargetP_Inf2_NoPop_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP; 
          USEC_MP_STATIC_MG_lane7Targets = USEC_MP_STATIC_MG_lane7Targets + [_target];
          USEC_MP_STATIC_MG_all_targets = USEC_MP_STATIC_MG_all_targets + [_target];
        };
      if(_row == 7) then { 
          _is3Row = false;
          _target =  createVehicle["TargetP_Inf2_NoPop_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP; 
          USEC_MP_STATIC_MG_lane6Targets = USEC_MP_STATIC_MG_lane6Targets + [_target];
          USEC_MP_STATIC_MG_all_targets = USEC_MP_STATIC_MG_all_targets + [_target];
        };
      if(_row == 8) then { 
          _is3Row = true;
          _target =  createVehicle["TargetP_Inf2_NoPop_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP; 
          USEC_MP_STATIC_MG_lane5Targets = USEC_MP_STATIC_MG_lane5Targets + [_target];
          USEC_MP_STATIC_MG_all_targets = USEC_MP_STATIC_MG_all_targets + [_target];
        };
        
      _rowCounter = _rowCounter + 1;
      
      if(_rowCounter > 3) then {
          if(_is3Row) then {
              _rowCounter = 1;
              _row = _row + 1;
          };
      };
      
      if(_rowCounter > 4) then {
          if(not _is3Row) then {
              _rowCounter = 1;
              _row = _row + 1;
          };
      };
    } forEach USEC_MP_STATIC_RIFLE_all_targets;
    
    USEC_MP_STATIC_RIFLE_all_targets = [];
    USEC_MP_STATIC_RIFLE_lane1Targets = [];
    USEC_MP_STATIC_RIFLE_lane2Targets = [];
    USEC_MP_STATIC_RIFLE_lane3Targets = [];
    USEC_MP_STATIC_RIFLE_lane4Targets = [];
    USEC_MP_STATIC_RIFLE_lane5Targets = [];
    USEC_MP_STATIC_RIFLE_lane6Targets = [];
    USEC_MP_STATIC_RIFLE_lane7Targets = [];
    USEC_MP_STATIC_RIFLE_lane8Targets = [];
};

_currentTime = time;
waitUntil{time > _currentTime + 1};

while {USEC_SERVER_MG_TargetPopupTest} do {
  // Random selection of a target
  _randomTarget = "";
  
  if(_popupCounter == (USEC_GLOBAL_CONFIG_MG_EXAM_MagSize + 1)) then {
          _currentTime = time;
          waitUntil{time > _currentTime + USEC_GLOBAL_CONFIG_MG_EXAM_ReloadTime};
      };
  
  if(USEC_SERVER_MG_row == 1) then {
      _randomTarget = USEC_MP_STATIC_MG_lane1Targets select (floor (random (count USEC_MP_STATIC_MG_lane1Targets)));
  };
  if(USEC_SERVER_MG_row == 2) then {
      _randomTarget = USEC_MP_STATIC_MG_lane2Targets select (floor (random (count USEC_MP_STATIC_MG_lane2Targets)));
  };
  if(USEC_SERVER_MG_row == 3) then {
      _randomTarget = USEC_MP_STATIC_MG_lane3Targets select (floor (random (count USEC_MP_STATIC_MG_lane3Targets)));
  };
  if(USEC_SERVER_MG_row == 4) then {
      _randomTarget = USEC_MP_STATIC_MG_lane4Targets select (floor (random (count USEC_MP_STATIC_MG_lane4Targets)));
  };
  if(USEC_SERVER_MG_row == 5) then {
      _randomTarget = USEC_MP_STATIC_MG_lane5Targets select (floor (random (count USEC_MP_STATIC_MG_lane5Targets)));
  };
  if(USEC_SERVER_MG_row == 6) then {
      _randomTarget = USEC_MP_STATIC_MG_lane6Targets select (floor (random (count USEC_MP_STATIC_MG_lane6Targets)));
  };
  if(USEC_SERVER_MG_row == 7) then {
      _randomTarget = USEC_MP_STATIC_MG_lane7Targets select (floor (random (count USEC_MP_STATIC_MG_lane7Targets)));
  };
  if(USEC_SERVER_MG_row == 8) then {
      _randomTarget = USEC_MP_STATIC_MG_lane8Targets select (floor (random (count USEC_MP_STATIC_MG_lane8Targets)));
  };
  
  USEC_SERVER_MG_rowCount = USEC_SERVER_MG_rowCount - 1;
  
  if(USEC_SERVER_MG_rowCount < 1) then {
      USEC_SERVER_MG_row = USEC_SERVER_MG_row + 1;
      USEC_SERVER_MG_rowCount = USEC_GLOBAL_CONFIG_MG_EXAM_NumbersPerRow;
  };
  
  // Pop target UP
  [[_randomTarget], "USEC_MP_TRAINING_targetUp"] call BIS_fnc_MP;
  USEC_VALIDATION_MG_playerCaused = "";
  //Add event handler for hit
  _hitEventIndex = _randomTarget addEventHandler ["HandleDamage", "USEC_SERVER_MG_TargetHitCount = USEC_SERVER_MG_TargetHitCount + 1; 0;"];      
  // Wait and pop target DOWN
  _currentTime = time;
  waitUntil {time > _currentTime + USEC_GLOBAL_CONFIG_MG_EXAM_TimeUpInSeconds || USEC_SERVER_MG_TargetHitCount > 2}; //Found in CONFIG.sqf
  if(USEC_SERVER_MG_TargetHitCount > 2) then {
      //if(USEC_VALIDATION_MG_playerCaused == USEC_SERVER_MG_PlayerObject) then {
          USEC_SERVER_MG_TargetsHit = USEC_SERVER_MG_TargetsHit + 1;
      //}else{
      //    USEC_SERVER_MG_InvalidTestPlayer = true;
      //    USEC_SERVER_MG_TargetPopupTest = false;
    };
  //};
  
  USEC_SERVER_MG_TargetHitCount = 0;
  
  //Reset marker and short pause until next popup
  _currentTime = time;
  [[_randomTarget], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
  _randomTarget removeEventHandler  ["HandleDamage", _hitEventIndex];
  _randomTarget setDamage 0;
  waitUntil{time > _currentTime + USEC_GLOBAL_CONFIG_MG_EXAM_TimeBetweenPopInSeconds}; //Found in CONFIG.sqf`
  
  if(_popupCounter == USEC_GLOBAL_CONFIG_MG_EXAM_TestLength) then {
      USEC_SERVER_MG_TargetPopupTest = false;
  };
  
  _popupCounter = _popupCounter + 1;
};

if (USEC_SERVER_MG_TestType == 1) then {
    //Todo: Add chronos interface here
};

if(USEC_SERVER_MG_InvalidTestPlayer) then {
    USEC_MP_TRAINING_MG_ShooterInvalid = 1;
    USEC_SERVER_MG_PlayerOwner publicVariableClient "USEC_MP_TRAINING_MG_ShooterInvalid";
};
if(USEC_SERVER_MG_InvalidTestWeapon) then {
    USEC_MP_TRAINING_MG_WeaponInvalid = str (currentWeapon USEC_VALIDATION_MG_playerCaused);
    USEC_SERVER_MG_PlayerOwner publicVariableClient "USEC_MP_TRAINING_MG_WeaponInvalid";
}else{
    USEC_MP_TRAINING_MG_ShooterResults = str ((USEC_SERVER_MG_TargetsHit / USEC_GLOBAL_CONFIG_MG_EXAM_TestLength) * 100);
    USEC_CLIENT_MESSAGE_ToAll = (((USEC_SERVER_MG_PlayerName + " just scored ") + USEC_MP_TRAINING_MG_ShooterResults) + " percent on the MG Course");
    publicVariable "USEC_CLIENT_MESSAGE_ToAll";
};
