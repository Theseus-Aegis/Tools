/*
 * Author: John Doe (atlasicus)
 *
 * Lowers targets for a new assessment
 *
 * Arguments:
 * 0: Targets to lower (Number)
 *
 */
 
 _course = (_this select 0);
 
if (_course == 0) then {
  {
    [[_x], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
  } forEach USEC_MP_STATIC_PISTOL_targets;
};
if (_course == 1) then {
  {
    [[_x], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
  } forEach USEC_SERVER_BASIC_TRAINING_PEEL_Targets;
};

if(_course == 2) then {
  {
    [[_x], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
  } forEach USEC_SERVER_BASIC_TRAINING_BOUNDING_Targets;  
};

if(_course > 2) then {
  {
    [[_x], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
  } forEach USEC_MP_STATIC_RIFLE_all_targets;

  {
    [[_x], "USEC_MP_TRAINING_targetDown"] call BIS_fnc_MP;
  } forEach USEC_MP_STATIC_MARKSMAN_all_targets;
};
 