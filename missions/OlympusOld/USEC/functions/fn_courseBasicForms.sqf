/*
 * Author: Rory, Jonpas
 *
 * Handles the Formations part of Basic Training Course.
 *
 * Arguments:
 * 0: Course Controller (Object)
 *
 * Return Value:
 * None
 */

_controller = _this select 0;

// Define parts of unit initializations (Ex = Extra)
_initAll = "
  this disableAI 'ANIM';
  removeAllWeapons this; 
  removeUniform this; 
  removeVest this; 
  removeHeadgear this;
  removeAllAssignedItems this;
  enableSentences false;
  this forceAddUniform 'U_B_CTRG_1';
  this addHeadgear 'H_HelmetSpecB';
  this addVest 'V_PlateCarrierH_CTRG';
  this addBackpack 'B_Kitbag_cbr';
  ";
_initExRM = "
  this addWeapon 'rhs_weap_m16a4_carryhandle';
  this addMagazine ['rhs_mag_30Rnd_556x45_M855A1_Stanag', 4];
  this addPrimaryWeaponItem 'rhsusf_acc_compm4';
  ";
_initExMG = "
  this addWeapon 'rhs_weap_m249_pip';
  this addMagazine ['rhsusf_100Rnd_556x45_soft_pouch', 4];
  this addPrimaryWeaponItem 'rhsusf_acc_compm4';
  ";
_initExSL = "
  removeHeadgear this;
  this addHeadgear 'H_Booniehat_khk_hs';
  this addWeapon 'rhs_m4_m320';
  this addMagazine ['rhs_mag_30Rnd_556x45_M855A1_Stanag', 4];
  this addPrimaryWeaponItem 'rhsusf_acc_compm4';
  ";
_initExAT = "
  this addWeapon 'rhs_weap_m16a4_carryhandle';
  this addWeapon 'launch_NLAW_F';
  this addMagazine ['rhsusf_100Rnd_556x45_soft_pouch', 4];
  this addPrimaryWeaponItem 'rhsusf_acc_compm4';
  ";

// Combine into usable initializations
_initRM = _initAll + _initExRM;
_initMG = _initAll + _initExMG;
_initSL = _initAll + _initExSL;
_initAT = _initAll + _initExAT;

// Create a group for all units spawned by this script
_grp = createGroup west;

/**********************************************
  Information (everything needed for set up)
**********************************************/
_formationInfo = [
  // Formation name (NO spaces), Unit initializations (in order, number of them specifies the number of units, each value is initialization of one unit)
  ["Line", [_initRM, _initMG, _initSL, _initAT]],
  ["Column", [_initSL, _initMG, _initAT, _initRM]],
  ["WedgeHLeft", [_initSL, _initMG, _initAT, _initRM, _initRM]],
  ["WedgeHRight", [_initSL, _initMG, _initAT, _initRM, _initRM]],
  ["File", [_initSL, _initMG, _initAT, _initRM]],
  ["StaggeredColumn", [_initSL, _initMG, _initAT, _initRM]]
];

/**********************************************
  Spawn Units
**********************************************/
// Loop through formation information
{
  // Formation name
  _formation = _x select 0;

  // Spawn action
  _controller addAction ["Spawn " + _formation, {
    _addActionArgs = _this select 3; // addAction argument

    _controller = _addActionArgs select 0; // Object addAction is assigned to
    _grp = _addActionArgs select 1; // Group to spawn units in

    // Loop values
    _arrayElement = _addActionArgs select 2;
    _formation = _arrayElement select 0; // Formation name
    _inits = _arrayElement select 1; // Array of initializations
    _numOfUnits = count _inits; // Count number of unit to be spawned from number of initializations

    // Loops through initializations supplied
    _unitNames = [];
    for [{_i = 1}, {_i <= _numOfUnits}, {_i = _i + 1}] do {
      // Give the spawned unit a name and add it to array (for removal)
      _unitName = toLower("forms_" + _formation + "_unit" + str(_i));
      _unitNames pushBack _unitName;

      // Prepare information needed to spawn the unit and spawn it
      _formationMarkerPos = getMarkerPos ("forms_" + _formation + str(_i));
      _init = (_inits select (_i - 1)) + (_unitName + " = this;");
      "B_soldier_F" createUnit [_formationMarkerPos, _grp, _init];
    };

    // Put names of all units spawned into a variable
    _controller setVariable ["UTG_courseBasicForms_units", _unitNames];
  }, [_controller, _grp, _x], 6, true, true, "", "isNil{_target getVariable 'UTG_courseBasicForms_units'}"];
} forEach _formationInfo;

/**********************************************
  Remove Units
**********************************************/
_controller addAction ["Remove Units", {
  _controller = _this select 3;

  // Get names of all units spawned from a variable
  _unitNames = _controller getVariable "UTG_courseBasicForms_units";
  // Loop through all units and delete them (get object from string through missionNamespace)
  {
    deleteVehicle (missionNamespace getVariable [_x, objNull]);
  } forEach _unitNames;

  // Set variable back to nil (for addActions condition)
  _controller setVariable ["UTG_courseBasicForms_units", nil];
}, _controller, 6, true, true, "", "!isNil{_target getVariable 'UTG_courseBasicForms_units'}"];
