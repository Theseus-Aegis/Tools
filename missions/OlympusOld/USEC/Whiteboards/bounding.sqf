/*
 * Specific whiteboard configuration.
 */

// DO NO EDIT!
private ["_defaultTexture", "_actions"];


// ============================== EDIT STARTS HERE

// This image will be set as the default image on the object
_defaultTexture = "Images\basic_boundingdefault.jpg";

// These are all the actions which will be added in the order written here
// Format is "Text Message, "imageURL"
_actions = [
  ["Clear Board", "Images\basic_boundingdefault.jpg"], 
  ["Step 1", "Images\basic_boundingstep1.jpg"],  
  ["Step 2", "Images\basic_boundingstep2.jpg"], 
  ["Step 3", "Images\basic_boundingstep3.jpg"],
  ["Bounding disengage", "Images\basic_boundingdis.jpg"]   
  // Last action has to be without a comma, all others must have it
];

// ============================== EDIT STOPS HERE


// DO NOT EDIT!
[_this select 0, _this select 1, _defaultTexture, _actions] call USEC_Misc_fnc_whiteboardController;
