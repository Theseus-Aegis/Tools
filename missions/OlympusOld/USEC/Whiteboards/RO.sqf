/*
 * Specific whiteboard configuration.
 */

// DO NO EDIT!
private ["_defaultTexture", "_actions"];


// ============================== EDIT STARTS HERE

// This image will be set as the default image on the object
_defaultTexture = "Images\RO_default.jpg";

// These are all the actions which will be added in the order written here
// Format is "Text Message, "imageURL"
_actions = [
  ["Clear Board", "Images\RO_default.jpg"],
  ["RT-152", "Images\M3_rt1523G.jpg"],
  ["PCR-152", "Images\M3_pcr152.jpg"],
  ["Rules 1", "Images\RO_rules0.jpg"],
  ["Rules 2", "Images\RO_rules.jpg"],
  ["Rules 3", "Images\RO_rules2.jpg"],
  ["Radio-Net", "Images\M3_radiostructure.jpg"],
  ["Callsigns", "Images\RO_callsigns.jpg"],
  ["Alphabet", "Images\RO_alphabet.jpg"],
  ["Numbers", "Images\RO_numbers.jpg"]
    // Last action has to be without a comma, all others must have it
];

// ============================== EDIT STOPS HERE


// DO NOT EDIT!
[_this select 0, _this select 1, _defaultTexture, _actions] call USEC_Misc_fnc_whiteboardController;
