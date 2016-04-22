/*
Author: Rory

Function: Removes all items from playable unit.
*/

params ["_unit", "_randomUniform", "_randomHeadgear"];
_unit = _this select 0;
_randomUniform = selectRandom ["tacs_Uniform_Polo_TP_LS_TP_TB","tacs_Uniform_Polo_TP_GS_TP_TB","tacs_Uniform_Polo_TP_BS_LP_BB"];
_randomHeadgear = selectRandom ["tacs_Cap_BlackLogo","tacs_Cap_TanLogo"];

//removal of items
if (isServer) then {
  removeallweapons _unit;
  removeallassigneditems _unit;
  removeuniform _unit;
  removeVest _unit;
  removeBackpack _unit;
  removeHeadgear _unit;
  removeGoggles _unit;

//adding basic gear
  _unit forceAddUniform _randomUniform;
  _unit addHeadgear _randomHeadgear;
  _unit addItem "ItemMap";
  _unit addItem "ItemCompass";
  _unit addItem "ItemWatch";
  _unit addItem "ACRE_PRC343";

//assigns items to player
  _unit assignItem "ItemMap";
  _unit assignItem "ItemCompass";
  _unit assignItem "ItemWatch";

};
