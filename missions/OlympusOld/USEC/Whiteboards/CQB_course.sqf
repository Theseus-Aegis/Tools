/*
 * Specific whiteboard configuration.
 */

// DO NO EDIT!
private ["_defaultTexture", "_actions"];


// ============================== EDIT STARTS HERE

// This image will be set as the default image on the object
_defaultTexture = "Images\CQB_default.jpg";

// These are all the actions which will be added in the order written here
// Format is "Text Message, "imageURL"
_actions = [
  ["Clear Board", "Images\CQB_default.jpg"], 
  ["Step 1", "Images\CQB_step1.jpg"], 
  ["Step 2", "Images\CQB_step2.jpg"], 
  ["Step 3", "Images\CQB_step3.jpg"], 
  ["Step 4", "Images\CQB_step4.jpg"], 
  ["Step 5", "Images\CQB_step5.jpg"], 
  ["Step 6", "Images\CQB_step6.jpg"]
  // Last action has to be without a comma, all others must have it
];

// ============================== EDIT STOPS HERE


// DO NOT EDIT!
[_this select 0, _this select 1, _defaultTexture, _actions] call USEC_Misc_fnc_whiteboardController;
