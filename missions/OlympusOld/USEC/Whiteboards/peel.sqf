/*
 * Specific whiteboard configuration.
 */

// DO NO EDIT!
private ["_defaultTexture", "_actions"];


// ============================== EDIT STARTS HERE

// This image will be set as the default image on the object
_defaultTexture = "Images\basic_peeldefault.jpg";

// These are all the actions which will be added in the order written here
// Format is "Text Message, "imageURL"
_actions = [
  ["Clear Board", "Images\basic_peeldefault.jpg"], 
  ["Step 1", "Images\basic_peelstep1.jpg"],  
  ["Step 2", "Images\basic_peelstep2.jpg"], 
  ["Step 3", "Images\basic_peelstep3.jpg"],
  ["Step 4", "Images\basic_peelstep4.jpg"],
  ["Step 5", "Images\basic_peelstep5.jpg"]  
  // Last action has to be without a comma, all others must have it
];

// ============================== EDIT STOPS HERE


// DO NOT EDIT!
[_this select 0, _this select 1, _defaultTexture, _actions] call USEC_Misc_fnc_whiteboardController;
