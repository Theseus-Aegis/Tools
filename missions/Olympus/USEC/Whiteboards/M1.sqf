/*
 * Specific whiteboard configuration.
 */

// DO NO EDIT!
private ["_defaultTexture", "_actions"];


// ============================== EDIT STARTS HERE

// This image will be set as the default image on the object
_defaultTexture = "Images\M1_utg_M1_logo.jpg";

// These are all the actions which will be added in the order written here
// Format is "Text Message, "imageURL"
_actions = [
  ["Clear Board", "Images\M1_utg_M1_logo.jpg"],
  ["Lancers logo", "Images\M1_lancers_logo.jpg"],
  ["Self-interaction", "Images\M1_self_interaction.jpg"],
  ["Others-interaction", "Images\M1_others_interaction.jpg"],
  ["Self-treatment", "Images\M1_self_treatment.jpg"],
  ["Others-Treatment", "Images\M1_others_treatment.jpg"],
  ["Damage Report", "Images\M1_damage_report.jpg"],
  ["Personal Radio", "Images\M1_personal_radio.jpg"]
  // Last action has to be without a comma, all others must have it
];

// ============================== EDIT STOPS HERE


// DO NOT EDIT!
[_this select 0, _this select 1, _defaultTexture, _actions] call USEC_Misc_fnc_whiteboardController;
