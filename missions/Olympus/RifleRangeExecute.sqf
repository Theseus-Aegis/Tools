/*
 * Author: John Doe (atlasicus), Jonpas
 *
 * Randomizes popup targets and records the metrics about the firing session
 *
 * Arguments:
 * none
 *
 */
     
USEC_SERVER_RIFLE_TargetPopupTest = true;
USEC_SERVER_RIFLE_TargetPupupTestKilled = false;
USEC_SERVER_RIFLE_InvalidTestPlayer = false;
USEC_SERVER_RIFLE_InvalidTestWeapon = false;
USEC_SERVER_RIFLE_CompetitiveScore = 0;
USEC_SERVER_RIFLE_CompetitiveHitPos = [];
USEC_SERVER_RIFLE_CompetitiveTargetLoc = [];
USEC_SERVER_RIFLE_CompetitiveHitValue = 0;


USEC_SERVER_RIFLE_row = 1;
USEC_SERVER_RIFLE_rowCount = USEC_GLOBAL_CONFIG_RIFLE_EXAM_NumbersPerRow;

if(count USEC_MP_STATIC_MG_all_targets > 0) then {
    _rowCounter = 1;
    _row = 1;
    _is3Row = false;
    
    {
      _pos = getPos _x;
      deleteVehicle _x;
      if(_row == 1) then {
          _is3Row = false;
          _target =  createVehicle["TargetP_Inf2_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP; 
          USEC_MP_STATIC_RIFLE_lane4Targets = USEC_MP_STATIC_RIFLE_lane4Targets + [_target];
          USEC_MP_STATIC_RIFLE_all_targets = USEC_MP_STATIC_RIFLE_all_targets + [_target];
        };
      if(_row == 2) then {
          _is3Row = true;
          _target =  createVehicle["TargetP_Inf2_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP; 
          USEC_MP_STATIC_RIFLE_lane3Targets = USEC_MP_STATIC_RIFLE_lane3Targets + [_target];
          USEC_MP_STATIC_RIFLE_all_targets = USEC_MP_STATIC_RIFLE_all_targets + [_target];
        };
      if(_row == 3) then {
          _is3Row = false;
          _target =  createVehicle["TargetP_Inf2_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP; 
          USEC_MP_STATIC_RIFLE_lane2Targets = USEC_MP_STATIC_RIFLE_lane2Targets + [_target];
          USEC_MP_STATIC_RIFLE_all_targets = USEC_MP_STATIC_RIFLE_all_targets + [_target];
        };
      if(_row == 4) then {
          _is3Row = true;
          _target =  createVehicle["TargetP_Inf2_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP; 
          USEC_MP_STATIC_RIFLE_lane1Targets = USEC_MP_STATIC_RIFLE_lane1Targets + [_target];
          USEC_MP_STATIC_RIFLE_all_targets = USEC_MP_STATIC_RIFLE_all_targets + [_target];
        };
      if(_row == 5) then {
          _is3Row = false;
          _target =  createVehicle["TargetP_Inf2_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
          USEC_MP_STATIC_RIFLE_lane8Targets = USEC_MP_STATIC_RIFLE_lane8Targets + [_target];
          USEC_MP_STATIC_RIFLE_all_targets = USEC_MP_STATIC_RIFLE_all_targets + [_target];
        };
      if(_row == 6) then { 
          _is3Row = true;
          _target =  createVehicle["TargetP_Inf2_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP; 
          USEC_MP_STATIC_RIFLE_lane7Targets = USEC_MP_STATIC_RIFLE_lane7Targets + [_target];
          USEC_MP_STATIC_RIFLE_all_targets = USEC_MP_STATIC_RIFLE_all_targets + [_target];
        };
      if(_row == 7) then { 
          _is3Row = false;
          _target =  createVehicle["TargetP_Inf2_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP; 
          USEC_MP_STATIC_RIFLE_lane6Targets = USEC_MP_STATIC_RIFLE_lane6Targets + [_target];
          USEC_MP_STATIC_RIFLE_all_targets = USEC_MP_STATIC_RIFLE_all_targets + [_target];
        };
      if(_row == 8) then { 
          _is3Row = true;
          _target =  createVehicle["TargetP_Inf2_F", _pos, [], 0, "CAN_COLLIDE"];
          _target setDir USEC_MP_STATIC_rifleRangeDir;
          [[_target], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP; 
          USEC_MP_STATIC_RIFLE_lane5Targets = USEC_MP_STATIC_RIFLE_lane5Targets + [_target];
          USEC_MP_STATIC_RIFLE_all_targets = USEC_MP_STATIC_RIFLE_all_targets + [_target];
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
    } forEach USEC_MP_STATIC_MG_all_targets;
    
    USEC_MP_STATIC_MG_all_targets = [];
    USEC_MP_STATIC_MG_lane1Targets = [];
    USEC_MP_STATIC_MG_lane2Targets = [];
    USEC_MP_STATIC_MG_lane3Targets = [];
    USEC_MP_STATIC_MG_lane4Targets = [];
    USEC_MP_STATIC_MG_lane5Targets = [];
    USEC_MP_STATIC_MG_lane6Targets = [];
    USEC_MP_STATIC_MG_lane7Targets = [];
    USEC_MP_STATIC_MG_lane8Targets = [];
};

_currentTime = time;
waitUntil{time > _currentTime + 1};

/**********************************************
        Rifle Course Practice and Exam
***********************************************/

_popupCounter = 1;
if(USEC_SERVER_RIFLE_TestType < 2) then {
  while {USEC_SERVER_RIFLE_TargetPopupTest} do {
    // Random selection of a target
    _randomTarget = "";
    
    if(_popupCounter == (USEC_GLOBAL_CONFIG_RIFLE_EXAM_MagSize + 1)) then {
          _currentTime = time;
          waitUntil{time > _currentTime + USEC_GLOBAL_CONFIG_RIFLE_EXAM_ReloadTime};
      };
    
    if(USEC_SERVER_RIFLE_row == 1) then {
        _randomTarget = USEC_MP_STATIC_RIFLE_lane1Targets select (floor (random (count USEC_MP_STATIC_RIFLE_lane1Targets)));
    };
    if(USEC_SERVER_RIFLE_row == 2) then {
        _randomTarget = USEC_MP_STATIC_RIFLE_lane2Targets select (floor (random (count USEC_MP_STATIC_RIFLE_lane2Targets)));
    };
    if(USEC_SERVER_RIFLE_row == 3) then {
        _randomTarget = USEC_MP_STATIC_RIFLE_lane3Targets select (floor (random (count USEC_MP_STATIC_RIFLE_lane3Targets)));
    };
    if(USEC_SERVER_RIFLE_row == 4) then {
        _randomTarget = USEC_MP_STATIC_RIFLE_lane4Targets select (floor (random (count USEC_MP_STATIC_RIFLE_lane4Targets)));
    };
    if(USEC_SERVER_RIFLE_row == 5) then {
        _randomTarget = USEC_MP_STATIC_RIFLE_lane5Targets select (floor (random (count USEC_MP_STATIC_RIFLE_lane5Targets)));
    };
    if(USEC_SERVER_RIFLE_row == 6) then {
        _randomTarget = USEC_MP_STATIC_RIFLE_lane6Targets select (floor (random (count USEC_MP_STATIC_RIFLE_lane6Targets)));
    };
    if(USEC_SERVER_RIFLE_row == 7) then {
        _randomTarget = USEC_MP_STATIC_RIFLE_lane7Targets select (floor (random (count USEC_MP_STATIC_RIFLE_lane7Targets)));
    };
    if(USEC_SERVER_RIFLE_row == 8) then {
        _randomTarget = USEC_MP_STATIC_RIFLE_lane8Targets select (floor (random (count USEC_MP_STATIC_RIFLE_lane8Targets)));
    };
    
    USEC_SERVER_RIFLE_rowCount = USEC_SERVER_RIFLE_rowCount - 1;
    
    if(USEC_SERVER_RIFLE_rowCount < 1) then {
        USEC_SERVER_RIFLE_row = USEC_SERVER_RIFLE_row + 1;
        USEC_SERVER_RIFLE_rowCount = USEC_GLOBAL_CONFIG_RIFLE_EXAM_NumbersPerRow;
    };
    
    // Pop target UP
    [[_randomTarget], "USEC_MP_TRAINING_targetUp"] call BIS_fnc_MP;
    USEC_VALIDATION_RIFLE_playerCaused = "";
    //Add event handler for hit
    _hitEventIndex = _randomTarget addEventHandler ["Hit", "USEC_SERVER_RIFLE_TargetPupupTestKilled = true; USEC_VALIDATION_RIFLE_playerCaused = (_this select 1);"];      
    // Wait and pop target DOWN
    _currentTime = time;
    waitUntil {time > _currentTime + USEC_GLOBAL_CONFIG_RIFLE_EXAM_TimeUpInSeconds || USEC_SERVER_RIFLE_TargetPupupTestKilled}; //Found in CONFIG.sqf
    if(USEC_SERVER_RIFLE_TargetPupupTestKilled) then {
        if(USEC_VALIDATION_RIFLE_playerCaused == USEC_SERVER_RIFLE_PlayerObject) then {
            if((currentWeapon USEC_VALIDATION_RIFLE_playerCaused) == USEC_GLOBAL_CONFIG_RIFLE_EXAM_Weapon) then {
                USEC_SERVER_RIFLE_TargetPupupTestKilled = false;
                USEC_SERVER_RIFLE_TargetsHit = USEC_SERVER_RIFLE_TargetsHit + 1;
            }else{
                USEC_SERVER_RIFLE_InvalidTestWeapon = true;
                USEC_SERVER_RIFLE_TargetPopupTest = false;
            };
        }else{
            USEC_SERVER_RIFLE_InvalidTestPlayer = true;
            USEC_SERVER_RIFLE_TargetPopupTest = false;
      };
    };
    
    //Reset marker and short pause until next popup
    _currentTime = time;
    [[_randomTarget], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
    _randomTarget removeEventHandler  ["Hit", _hitEventIndex];
    _randomTarget setDamage 0;
    waitUntil{time > _currentTime + USEC_GLOBAL_CONFIG_RIFLE_EXAM_TimeBetweenPopInSeconds}; //Found in CONFIG.sqf`
    
    if(_popupCounter == USEC_GLOBAL_CONFIG_RIFLE_EXAM_TestLength) then {
        USEC_SERVER_RIFLE_TargetPopupTest = false;
    };
    
    _popupCounter = _popupCounter + 1;
  };
  
  if (USEC_SERVER_RIFLE_TestType == 1) then {
      //Todo: Add chronos interface here
  };

  if(USEC_SERVER_RIFLE_InvalidTestPlayer) then {
      USEC_MP_TRAINING_RIFLE_ShooterInvalid = 1;
      USEC_SERVER_RIFLE_PlayerOwner publicVariableClient "USEC_MP_TRAINING_RIFLE_ShooterInvalid";
  };
  if(USEC_SERVER_RIFLE_InvalidTestWeapon) then {
      USEC_MP_TRAINING_RIFLE_WeaponInvalid = 1;
      USEC_SERVER_RIFLE_PlayerOwner publicVariableClient "USEC_MP_TRAINING_RIFLE_WeaponInvalid";
  }else{
      USEC_MP_TRAINING_RIFLE_ShooterResults = str ((USEC_SERVER_RIFLE_TargetsHit / USEC_GLOBAL_CONFIG_RIFLE_EXAM_TestLength) * 100);
      USEC_CLIENT_MESSAGE_ToAll = (((USEC_SERVER_RIFLE_PlayerName + " just scored ") + USEC_MP_TRAINING_RIFLE_ShooterResults) + " percent on the Rifle Course");
      publicVariable "USEC_CLIENT_MESSAGE_ToAll";
  };
};

/**********************************************
               Rifle Competition
***********************************************/

if(USEC_SERVER_RIFLE_TestType == 2) then {
    _popupCounter = 1;
    
    "USEC_TRAINING_RIFLE_COMPETITIVE_HitResult" addPublicVariableEventHandler{
        _result = (_this select 1);
        USEC_SERVER_RIFLE_CompetitiveTarget = _result select 0;
        USEC_SERVER_RIFLE_CompetitiveHitPos = _result select 1;
        
        _targetObject = USEC_SERVER_RIFLE_CompetitiveTarget;
        _targetPos = (getPosASL _targetObject);
        _hitPosition = USEC_SERVER_RIFLE_CompetitiveHitPos;

        _resultX = (_hitPosition select 0) - (_targetPos select 0);
        _resultY = (_hitPosition select 1) - (_targetPos select 1);
        _resultZ = (_hitPosition select 2) - (_targetPos select 2);
          
        _center = USEC_SERVER_ALL_COURSES_BullseyePoint;
        _hitDelta = [_resultX, _resultY, _resultZ];

        _distance = _center vectorDistance _hitDelta;

        if((_distance min USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_BullsEyeTolerance) == _distance) then {
            USEC_SERVER_RIFLE_CompetitiveHitValue = USEC_SERVER_RIFLE_CompetitiveHitValue + USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_BullseyeValue;
              
        }else {
            USEC_SERVER_RIFLE_CompetitiveHitValue = USEC_SERVER_RIFLE_CompetitiveHitValue + (USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_BullseyeValue * (1 - (_distance - USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_BullsEyeTolerance)));
        };  
    };

    while {USEC_SERVER_RIFLE_TargetPopupTest} do {
      // Random selection of a target
      _randomTarget = "";
      
      _randomTarget = USEC_MP_STATIC_RIFLE_ALL_targets select (floor (random (count USEC_MP_STATIC_RIFLE_ALL_targets)));
      
      if(_popupCounter == (USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_MagSize + 1)) then {
          _currentTime = time;
          waitUntil{time > _currentTime + USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_ReloadTime};
      };
      
      // Pop target UP
      USEC_TRAINING_RIFLE_COMPETITIVE_Target = _randomTarget;
      USEC_SERVER_RIFLE_PlayerOwner publicVariableClient "USEC_TRAINING_RIFLE_COMPETITIVE_Target";
      [[_randomTarget], "USEC_MP_TRAINING_targetUp"] call BIS_fnc_MP;
      USEC_VALIDATION_RIFLE_playerCaused = "";
      //Add event handler for hit
      _randomTarget addEventHandler ["Hit", "USEC_SERVER_RIFLE_TargetPupupTestKilled = true; USEC_VALIDATION_RIFLE_playerCaused = (_this select 1);"];      
      
      // Wait and pop target DOWN
      _currentTime = time;
      waitUntil {time > _currentTime + USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_TimeUpInSeconds || USEC_SERVER_RIFLE_TargetPupupTestKilled}; //Found in CONFIG.sqf
      
      if(USEC_SERVER_RIFLE_TargetPupupTestKilled) then {
          if(USEC_VALIDATION_RIFLE_playerCaused == USEC_SERVER_RIFLE_PlayerObject) then {
              if((currentWeapon USEC_VALIDATION_RIFLE_playerCaused) == USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_Weapon) then {
                  USEC_SERVER_RIFLE_TargetPupupTestKilled = false;
                  USEC_SERVER_RIFLE_CompetitiveScore = USEC_SERVER_RIFLE_CompetitiveScore + USEC_SERVER_RIFLE_CompetitiveHitValue;
              }else{
                  USEC_SERVER_RIFLE_InvalidTestWeapon = true;
                  USEC_SERVER_RIFLE_TargetPopupTest = false;
              };
          }else{
              USEC_SERVER_RIFLE_InvalidTestPlayer = true;
              USEC_SERVER_RIFLE_TargetPopupTest = false;
        };
      };
      
      //Reset marker and short pause until next popup
      _currentTime = time;
      [[_randomTarget], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
      _randomTarget removeAllEventHandlers "HitPart";
      waitUntil{time > _currentTime + USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_TimeBetweenPopInSeconds}; //Found in CONFIG.sqf`
      
      if(_popupCounter == USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_TestLength) then {
          USEC_SERVER_RIFLE_TargetPopupTest = false;
      };
      
      _popupCounter = _popupCounter + 1;
    };

    //Todo: Add chronos interface here

    if(USEC_SERVER_RIFLE_InvalidTestPlayer) then {
        USEC_MP_TRAINING_RIFLE_ShooterInvalid = 1;
        USEC_SERVER_RIFLE_PlayerOwner publicVariableClient "USEC_MP_TRAINING_RIFLE_ShooterInvalid";
    };
    if(USEC_SERVER_RIFLE_InvalidTestWeapon) then {
        USEC_MP_TRAINING_RIFLE_WeaponInvalid = 1;
        USEC_SERVER_RIFLE_PlayerOwner publicVariableClient "USEC_MP_TRAINING_RIFLE_WeaponInvalid";
    }else{
        USEC_MP_TRAINING_RIFLE_ShooterResults = USEC_SERVER_RIFLE_CompetitiveScore;
        USEC_CLIENT_MESSAGE_ToAll =  (((USEC_SERVER_RIFLE_PlayerName + " just scored ") + str ( USEC_MP_TRAINING_RIFLE_ShooterResults)) + " points on the Rifle Course");
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
};


