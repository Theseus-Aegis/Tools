/*
 * Specific whiteboard configuration.
 */

// DO NO EDIT!
private ["_defaultTexture", "_actions"];


// ============================== EDIT STARTS HERE

// This image will be set as the default image on the object
_defaultTexture = "Images\basic_formationsdefault.jpg";

// These are all the actions which will be added in the order written here
// Format is "Text Message, "imageURL"
_actions = [
  ["Clear Board", "Images\basic_formationsdefault.jpg"], 
  ["Line", "Images\basic_line.jpg"],  
  ["Column", "Images\basic_column.jpg"], 
  ["File", "Images\basic_file.jpg"], 
  ["Stag Column", "Images\basic_staggeredcolumn.jpg"], 
  ["Wedge H-left", "Images\basic_heavyleft.jpg"], 
  ["Wedge H-right", "Images\basic_heavyright.jpg"] 
  // Last action has to be without a comma, all others must have it
];

// ============================== EDIT STOPS HERE


// DO NOT EDIT!
[_this select 0, _this select 1, _defaultTexture, _actions] call USEC_Misc_fnc_whiteboardController;
