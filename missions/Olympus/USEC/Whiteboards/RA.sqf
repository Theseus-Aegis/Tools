/*
 * Specific whiteboard configuration.
 */

// DO NO EDIT!
private ["_defaultTexture", "_actions"];


// ============================== EDIT STARTS HERE

// This image will be set as the default image on the object
_defaultTexture = "Images\RA_default.jpg";

// These are all the actions which will be added in the order written here
// Format is "Text Message, "imageURL"
_actions = [
  ["Clear Board", "Images\RA_default.jpg"],
  ["RATEL info", "Images\RA_info.jpg"],
  ["Fire-missions", "Images\RA_firemissions.jpg"],
  ["example CAS", "Images\RA_CAS_example.jpg"],
  ["example CFF", "Images\RA_CFF_example.jpg"],
  ["CASEVAC/TRANSPORT", "Images\RA_CASEVAC_TRANSPORT.jpg"],
  ["example CASEV/TRANS", "Images\RA_CASEVAC_TRANSPORT_example.jpg"],
  ["SITREP", "Images\RA_SITREP.jpg"],
  ["example SITREP", "Images\RA_SITREP_example.jpg"]
    // Last action has to be without a comma, all others must have it
];

// ============================== EDIT STOPS HERE


// DO NOT EDIT!
[_this select 0, _this select 1, _defaultTexture, _actions] call USEC_Misc_fnc_whiteboardController;
