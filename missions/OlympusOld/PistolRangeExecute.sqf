/*
 * Author: John Doe (atlasicus), Jonpas
 *
 * Randomizes popup targets and records the metrics about the firing session
 *
 * Arguments:
 * none
 *
 */
 
USEC_SERVER_PISTOL_TargetPopupTest = true;
USEC_SERVER_PISTOL_TargetPupupTestKilled = false;
USEC_SERVER_PISTOL_InvalidTestPlayer = false;
USEC_SERVER_PISTOL_InvalidTestWeapon = false;
USEC_SERVER_PISTOL_CompetitiveScore = 0;
USEC_SERVER_PISTOL_CompetitiveHitPos = [];
USEC_SERVER_PISTOL_CompetitiveTargetLoc = [];
USEC_SERVER_PISTOL_CompetitiveHitValue = 0;

_randomTarget = "";
USEC_SERVER_PISTOL_row = 1;
USEC_SERVER_PISTOL_rowCount = USEC_GLOBAL_CONFIG_PISTOL_EXAM_NumbersPerRow;

/**********************************************
        Pistol Course Practice and Exam
***********************************************/

if(USEC_SERVER_PISTOL_TestType < 2) then {
    _popupCounter = 1;

    while {USEC_SERVER_PISTOL_TargetPopupTest} do {
      // Random selection of a target
      
      if(_popupCounter == (USEC_GLOBAL_CONFIG_PISTOL_EXAM_MagSize + 1)) then {
          _currentTime = time;
          waitUntil{time > _currentTime + USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_ReloadTime};
      };
      
      if(USEC_SERVER_PISTOL_row == 1) then {
          _randomTarget = USEC_MP_STATIC_PISTOL_lane1Targets select (floor (random (count USEC_MP_STATIC_PISTOL_lane1Targets)));
      };
      if(USEC_SERVER_PISTOL_row == 2) then {
          _randomTarget = USEC_MP_STATIC_PISTOL_lane2Targets select (floor (random (count USEC_MP_STATIC_PISTOL_lane2Targets)));
      };
      if(USEC_SERVER_PISTOL_row == 3) then { 
          _randomTarget = USEC_MP_STATIC_PISTOL_lane3Targets select (floor (random (count USEC_MP_STATIC_PISTOL_lane3Targets)));
      };
      if(USEC_SERVER_PISTOL_row == 4) then {
          _randomTarget = USEC_MP_STATIC_PISTOL_lane4Targets select (floor (random (count USEC_MP_STATIC_PISTOL_lane4Targets)));
      };
      
      USEC_SERVER_PISTOL_rowCount = USEC_SERVER_PISTOL_rowCount - 1;
      
      if(USEC_SERVER_PISTOL_rowCount < 1) then {
          USEC_SERVER_PISTOL_row = USEC_SERVER_PISTOL_row + 1;
          USEC_SERVER_PISTOL_rowCount = USEC_GLOBAL_CONFIG_PISTOL_EXAM_NumbersPerRow;
      };
      
      // Pop target UP
      [[_randomTarget], "USEC_MP_TRAINING_targetUp"] call BIS_fnc_MP;
      USEC_VALIDATION_PISTOL_playerCaused = "";
      //Add event handler for hit
      _hitEventIndex = _randomTarget addEventHandler ["Hit", "USEC_SERVER_PISTOL_TargetPupupTestKilled = true; USEC_VALIDATION_PISTOL_playerCaused = (_this select 1);"];      
      // Wait and pop target DOWN
      _currentTime = time;
      waitUntil {time > _currentTime + USEC_GLOBAL_CONFIG_PISTOL_EXAM_TimeUpInSeconds || USEC_SERVER_PISTOL_TargetPupupTestKilled}; //Found in CONFIG.sqf
      if(USEC_SERVER_PISTOL_TargetPupupTestKilled) then {
          if(USEC_VALIDATION_PISTOL_playerCaused == USEC_SERVER_PISTOL_PlayerObject) then {
              if((currentWeapon USEC_VALIDATION_PISTOL_playerCaused) == USEC_GLOBAL_CONFIG_PISTOL_EXAM_Weapon) then {
                  USEC_SERVER_PISTOL_TargetPupupTestKilled = false;
                  USEC_SERVER_PISTOL_TargetsHit = USEC_SERVER_PISTOL_TargetsHit + 1;
              }else{
                  USEC_SERVER_PISTOL_InvalidTestWeapon = true;
                  USEC_SERVER_PISTOL_TargetPopupTest = false;
              };
          }else{
              USEC_SERVER_PISTOL_InvalidTestPlayer = true;
              USEC_SERVER_PISTOL_TargetPopupTest = false;
        };
      };
      
      //Reset marker and short pause until next popup
      _currentTime = time;
      [[_randomTarget], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
      _randomTarget removeEventHandler  ["Hit", _hitEventIndex];
      waitUntil{time > _currentTime + USEC_GLOBAL_CONFIG_PISTOL_EXAM_TimeBetweenPopInSeconds}; //Found in CONFIG.sqf`
      
      if(_popupCounter == USEC_GLOBAL_CONFIG_PISTOL_EXAM_TestLength) then {
          USEC_SERVER_PISTOL_TargetPopupTest = false;
      };
      
      _popupCounter = _popupCounter + 1;
    };

    if (USEC_SERVER_PISTOL_TestType == 1) then {
        //Todo: Add chronos interface here
    };

    if(USEC_SERVER_PISTOL_InvalidTestPlayer) then {
        USEC_MP_TRAINING_PISTOL_ShooterInvalid = 1;
        USEC_SERVER_PISTOL_PlayerOwner publicVariableClient "USEC_MP_TRAINING_PISTOL_ShooterInvalid";
    };
    if(USEC_SERVER_PISTOL_InvalidTestWeapon) then {
        USEC_MP_TRAINING_PISTOL_WeaponInvalid = 1;
        USEC_SERVER_PISTOL_PlayerOwner publicVariableClient "USEC_MP_TRAINING_PISTOL_WeaponInvalid";
    }else{
        USEC_MP_TRAINING_PISTOL_ShooterResults = ((USEC_SERVER_PISTOL_TargetsHit / USEC_GLOBAL_CONFIG_PISTOL_EXAM_TestLength) * 100);
        USEC_CLIENT_MESSAGE_ToAll = (((USEC_SERVER_PISTOL_PlayerName + " just scored ") + str (USEC_MP_TRAINING_PISTOL_ShooterResults)) + " percent on the Pistol Course");
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
};

/**********************************************
                  Pistol Competition
***********************************************/

if(USEC_SERVER_PISTOL_TestType == 2) then {
    _popupCounter = 1;
    
    "USEC_TRAINING_PISTOL_COMPETITIVE_HitResult" addPublicVariableEventHandler{
        _result = (_this select 1);
        USEC_SERVER_PISTOL_CompetitiveTarget = _result select 0;
        USEC_SERVER_PISTOL_CompetitiveHitPos = _result select 1;
        
        _targetObject = USEC_SERVER_PISTOL_CompetitiveTarget;
        _targetPos = (getPosASL _targetObject);
        _hitPosition = USEC_SERVER_PISTOL_CompetitiveHitPos;

        _resultX = (_hitPosition select 0) - (_targetPos select 0);
        _resultY = (_hitPosition select 1) - (_targetPos select 1);
        _resultZ = (_hitPosition select 2) - (_targetPos select 2);
          
        _center = USEC_SERVER_ALL_COURSES_BullseyePoint;
        _hitDelta = [_resultX, _resultY, _resultZ];

        _distance = _center vectorDistance _hitDelta;

        if((_distance min USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_BullsEyeTolerance) == _distance) then {
            USEC_SERVER_PISTOL_CompetitiveHitValue = USEC_SERVER_PISTOL_CompetitiveHitValue + USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_BullseyeValue;
              
        }else {
            USEC_SERVER_PISTOL_CompetitiveHitValue = USEC_SERVER_PISTOL_CompetitiveHitValue + (USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_BullseyeValue * (1 - (_distance - USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_BullsEyeTolerance)));
        };  
    };

    while {USEC_SERVER_PISTOL_TargetPopupTest} do {
      // Random selection of a target
      _randomTarget = "";
      
      _randomTarget = USEC_MP_STATIC_PISTOL_ALL_targets select (floor (random (count USEC_MP_STATIC_PISTOL_ALL_targets)));
      
      if(_popupCounter == (USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_MagSize + 1)) then {
          _currentTime = time;
          waitUntil{time > _currentTime + USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_ReloadTime};
      };
      
      // Pop target UP
      USEC_TRAINING_PISTOL_COMPETITIVE_Target = _randomTarget;
      USEC_SERVER_PISTOL_PlayerOwner publicVariableClient "USEC_TRAINING_PISTOL_COMPETITIVE_Target";
      [[_randomTarget], "USEC_MP_TRAINING_targetUp"] call BIS_fnc_MP;
      USEC_VALIDATION_PISTOL_playerCaused = "";
      //Add event handler for hit
      _randomTarget addEventHandler ["Hit", "USEC_SERVER_PISTOL_TargetPupupTestKilled = true; USEC_VALIDATION_PISTOL_playerCaused = (_this select 1);"];      
      
      // Wait and pop target DOWN
      _currentTime = time;
      waitUntil {time > _currentTime + USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_TimeUpInSeconds || USEC_SERVER_PISTOL_TargetPupupTestKilled}; //Found in CONFIG.sqf
      
      if(USEC_SERVER_PISTOL_TargetPupupTestKilled) then {
          if(USEC_VALIDATION_PISTOL_playerCaused == USEC_SERVER_PISTOL_PlayerObject) then {
              if((currentWeapon USEC_VALIDATION_PISTOL_playerCaused) == USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_Weapon) then {
                  USEC_SERVER_PISTOL_TargetPupupTestKilled = false;
                  USEC_SERVER_PISTOL_CompetitiveScore = USEC_SERVER_PISTOL_CompetitiveScore + USEC_SERVER_PISTOL_CompetitiveHitValue;
              }else{
                  USEC_SERVER_PISTOL_InvalidTestWeapon = true;
                  USEC_SERVER_PISTOL_TargetPopupTest = false;
              };
          }else{
              USEC_SERVER_PISTOL_InvalidTestPlayer = true;
              USEC_SERVER_PISTOL_TargetPopupTest = false;
        };
      };
      
      //Reset marker and short pause until next popup
      _currentTime = time;
      [[_randomTarget], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
      _randomTarget removeAllEventHandlers "HitPart";
      waitUntil{time > _currentTime + USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_TimeBetweenPopInSeconds}; //Found in CONFIG.sqf`
      
      if(_popupCounter == USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_TestLength) then {
          USEC_SERVER_PISTOL_TargetPopupTest = false;
      };
      
      _popupCounter = _popupCounter + 1;
    };

    //Todo: Add chronos interface here

    if(USEC_SERVER_PISTOL_InvalidTestPlayer) then {
        USEC_MP_TRAINING_PISTOL_ShooterInvalid = 1;
        USEC_SERVER_PISTOL_PlayerOwner publicVariableClient "USEC_MP_TRAINING_PISTOL_ShooterInvalid";
    };
    if(USEC_SERVER_PISTOL_InvalidTestWeapon) then {
        USEC_MP_TRAINING_PISTOL_WeaponInvalid = 1;
        USEC_SERVER_PISTOL_PlayerOwner publicVariableClient "USEC_MP_TRAINING_PISTOL_WeaponInvalid";
    }else{
        USEC_MP_TRAINING_PISTOL_ShooterResults = USEC_SERVER_PISTOL_CompetitiveScore;
        USEC_CLIENT_MESSAGE_ToAll =  (((USEC_SERVER_PISTOL_PlayerName + " just scored ") + str ( USEC_MP_TRAINING_PISTOL_ShooterResults)) + " points on the Pistol Course");
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
};
