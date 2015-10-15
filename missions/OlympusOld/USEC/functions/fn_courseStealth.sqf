/*
 * Author: Jonpas
 *
 * Handles the Stealth Course.
 *
 * Arguments:
 * 0: New Timer Status (String)
 * 1: Course Controller (Object)
 *
 * Return Value:
 * None
 */

#define COURSE_NAME "UTG Stealth Course"

_desiredStatus = _this select 0;
_controller = _this select 1;

_playerLineupArea = stealth_lineupArea; // Starting area
_playerMoveArea = stealth_moveArea; // Movement area
_playerFinishArea = stealth_finishArea; // Finishing area
_startObjs = [ // Starting locations objects
  stealth_startObj1,
  stealth_startObj2,
  stealth_startObj3,
  stealth_startObj4,
  stealth_startObj5
];
_timeUntilFreeze = 3; // Time until freeze

/**********************************************
  Course Started
**********************************************/
if (!isNil "_controller") then {
  _controller addAction ["Begin Course", {
    _playerLineupArea = (_this select 3) select 0;
    _startObjsFree = (_this select 3) select 1;
    _timeUntilFreeze = (_this select 3) select 2;
    _playerMoveArea = (_this select 3) select 3;
    _controller = _this select 0;

    _playerMoveList = +(list _playerMoveArea);
    _playerLineupList = +(list _playerLineupArea);
    _playersLeft = count _playerLineupList;
    if (count _playerLineupList > 0 && count _playerMoveList == 0) then {
      // Put round number into a variable on controller object
      _controller setVariable ["UTG_courseStealth_round", 1];
      
      {
        if (count _startObjsFree > 0) then {
          // Disable movement
          [[_x, "HubSpectator_stand"], "USEC_Misc_fnc_switchMove", true, false, true] call BIS_fnc_MP; // switchMove is local

          // Teleport to random start position
          _startObj = _startObjsFree select (floor (random (count _startObjsFree))); // Select random start object
          _x setPosASL (getPosASL _startObj); // Move player to randomized start object position
          _startObjsFree = _startObjsFree - [_startObj]; // Remove occupied start object (prevents multiple players on same spot)
          _playersLeft = _playersLeft - 1; // Decrement players left for hint

          // Countdown
          ["Prepare!", "hint", _x, false, true] call BIS_fnc_MP; sleep 1;
          /*["3", "hint", _x, false, true] call BIS_fnc_MP; sleep 1;
          ["2", "hint", _x, false, true] call BIS_fnc_MP; sleep 1;
          ["1", "hint", _x, false, true] call BIS_fnc_MP; sleep 1;
          ["GO!", "hint", _x, false, true] call BIS_fnc_MP; sleep 1;*/

          // Enable movement
          [[_x, "AmovPercMstpSrasWrflDnon"], "USEC_Misc_fnc_switchMove", true, false, true] call BIS_fnc_MP; // switchMove is local

          // Put round number into a variable on player
          _x setVariable ["UTG_courseStealth_round", 1];
        };
      } forEach _playerLineupList;

      // Add all players to the menu
      hint format ["%1 attendees added to the menu. \n%2 attendees left behind.", count _playerLineupList, _playersLeft];
      //add _controller addActions for player spotting here
      

    } else {
      if (count _playerLineupList == 0) then {
        hint "No attendees at Start!";
      } else {
        hint "Attendees are in the course area!";
      };
    };

  }, [_playerLineupArea, _startObjs, _timeUntilFreeze, _playerMoveArea], 6, true, true, "", "isNil{_target getVariable 'UTG_courseStealth_round'}"];

  _controller addAction ["Stop Course", {
    (_this select 0) setVariable ["UTG_courseStealth_round", nil];
  }, nil, 5, true, true, "", "!isNil{_target getVariable 'UTG_courseStealth_round'}"];
};

/**********************************************
  Course Finished
**********************************************/
if (_desiredStatus == "finish" && {!isNil{player getVariable "UTG_courseStealth_round"}}) then {
  {
    _rounds = _x getVariable "UTG_courseStealth_round";

    hint format["You completed the %1 in \n round %2!!", COURSE_NAME, _rounds];
    // BIS_fnc_MP necessary - 'systemChat' Effect = Local
    [format["%1 completed the %2 in round %3!", name _x, COURSE_NAME, _rounds], "systemChat", nil, false] call BIS_fnc_MP;

    // Chronos stuff comes here

    // Set round number variable to nil (for IF checks in this function)
    _x setVariable ["UTG_courseStealth_round", nil];
  } forEach (list _playerFinishArea);
};

/**********************************************
  Course Failed
**********************************************/
if (_desiredStatus == "fail" && {!isNil{player getVariable "UTG_courseStealth_round"}}) then {
  hint "You failed the course!";
  // Set round number variable to nil (for IF checks in this function)
  player setVariable ["UTG_courseStealth_round", nil];
};
