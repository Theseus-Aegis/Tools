/*
 * Specific whiteboard configuration.
 */

// DO NO EDIT!
private ["_defaultTexture", "_actions"];


// ============================== EDIT STARTS HERE

// This image will be set as the default image on the object
_defaultTexture = "Images\M2_utg_M2_logo.jpg";

// These are all the actions which will be added in the order written here
// Format is "Text Message, "imageURL"
_actions = [
  ["Clear Board", "Images\M2_utg_M2_logo.jpg"], 
  ["USEC Progression", "Images\M2_progression.jpg"], 
  ["Module 2 overview", "Images\M2_overview_M2.jpg"]
  // Last action has to be without a comma, all others must have it
];

// ============================== EDIT STOPS HERE


// DO NOT EDIT!
[_this select 0, _this select 1, _defaultTexture, _actions] call USEC_Misc_fnc_whiteboardController;
