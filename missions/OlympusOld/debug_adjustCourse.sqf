/*
 * Author: John Doe (atlasicus)
 *
 * Randomizes popup targets and records the metrics about the firing session
 *
 * Arguments:
 * 0: Course weapon (String)
 * 1: Course type (String)
 * 2: Course length (Number)
 *
 */
 
 _weaponType = (_this select 0);
 _courseType = (_this select 1);
 _courseLength = (_this select 2);
 
 if(_weaponType == "PISTOL") then {
    if(_courseType == "EXAM") then {
        USEC_GLOBAL_CONFIG_PISTOL_EXAM_NumbersPerRow = round(_courseLength / 4); 
    
        if(_courseLength > 16 * USEC_GLOBAL_CONFIG_PISTOL_EXAM_MagCount) then {
            _max = 16 * USEC_GLOBAL_CONFIG_PISTOL_EXAM_MagCount;
            USEC_CLIENT_MESSAGE_ToAll = "Error: Exam Test Length too great; Defaulting to " + str (_max);
            publicVariable "USEC_CLIENT_MESSAGE_ToAll";
            USEC_GLOBAL_CONFIG_PISTOL_EXAM_NumbersPerRow = round (_max / 4); 
        };
        
        USEC_GLOBAL_CONFIG_PISTOL_EXAM_TestLength = 4 * USEC_GLOBAL_CONFIG_PISTOL_EXAM_NumbersPerRow; 
        USEC_GLOBAL_CONFIG_PISTOL_EXAM_MagSize = USEC_GLOBAL_CONFIG_PISTOL_EXAM_TestLength / USEC_GLOBAL_CONFIG_PISTOL_EXAM_MagCount; 
        
        USEC_CLIENT_MESSAGE_ToAll = "Pistol Exam Length changed to: " + str (_courseLength);
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
    
    if(_courseType == "COMPETITION") then {
        USEC_GLOBAL_CONFIG_PISTOL_COMPETITION_NumbersPerRow = round(_courseLength / 4); 
    
        if(_courseLength > 16 * USEC_GLOBAL_CONFIG_PISTOL_COMPETITION_MagCount) then {
            _max = 16 * USEC_GLOBAL_CONFIG_PISTOL_COMPETITION_MagCount;
            USEC_CLIENT_MESSAGE_ToAll = "Error: COMPETITION Test Length too great; Defaulting to " + str (_max);
            publicVariable "USEC_CLIENT_MESSAGE_ToAll";
            USEC_GLOBAL_CONFIG_PISTOL_COMPETITION_NumbersPerRow = round (_max / 4); 
        };
        
        USEC_GLOBAL_CONFIG_PISTOL_COMPETITION_TestLength = 4 * USEC_GLOBAL_CONFIG_PISTOL_COMPETITION_NumbersPerRow; 
        USEC_GLOBAL_CONFIG_PISTOL_COMPETITION_MagSize = USEC_GLOBAL_CONFIG_PISTOL_COMPETITION_TestLength / USEC_GLOBAL_CONFIG_PISTOL_COMPETITION_MagCount; 
        
        USEC_CLIENT_MESSAGE_ToAll = "Pistol COMPETITION Length changed to: " + str (_courseLength);
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
    
    if(not (_courseType == "EXAM") && not (_courseType == "COMPETITION")) then {
        USEC_CLIENT_MESSAGE_ToAll = "Error: Course Type Invalid (did you misspell?)";
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
 };
  if(_weaponType == "RIFLE") then {
      if(_courseType == "EXAM") then {
        USEC_GLOBAL_CONFIG_RIFLE_EXAM_NumbersPerRow = round(_courseLength / 4); 
    
        if(_courseLength > 16 * USEC_GLOBAL_CONFIG_RIFLE_EXAM_MagCount) then {
            _max = 16 * USEC_GLOBAL_CONFIG_RIFLE_EXAM_MagCount;
            USEC_CLIENT_MESSAGE_ToAll = "Error: Exam Test Length too great; Defaulting to " + str (_max);
            publicVariable "USEC_CLIENT_MESSAGE_ToAll";
            USEC_GLOBAL_CONFIG_RIFLE_EXAM_NumbersPerRow = round (_max / 4); 
        };
        
        USEC_GLOBAL_CONFIG_RIFLE_EXAM_TestLength = 4 * USEC_GLOBAL_CONFIG_RIFLE_EXAM_NumbersPerRow; 
        USEC_GLOBAL_CONFIG_RIFLE_EXAM_MagSize = USEC_GLOBAL_CONFIG_RIFLE_EXAM_TestLength / USEC_GLOBAL_CONFIG_RIFLE_EXAM_MagCount; 
        
        USEC_CLIENT_MESSAGE_ToAll = "RIFLE Exam Length changed to: " + str (_courseLength);
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
    
    if(_courseType == "COMPETITION") then {
        USEC_GLOBAL_CONFIG_RIFLE_COMPETITION_NumbersPerRow = round(_courseLength / 4); 
    
        if(_courseLength > 16 * USEC_GLOBAL_CONFIG_RIFLE_COMPETITION_MagCount) then {
            _max = 16 * USEC_GLOBAL_CONFIG_RIFLE_COMPETITION_MagCount;
            USEC_CLIENT_MESSAGE_ToAll = "Error: COMPETITION Test Length too great; Defaulting to " + str (_max);
            publicVariable "USEC_CLIENT_MESSAGE_ToAll";
            USEC_GLOBAL_CONFIG_RIFLE_COMPETITION_NumbersPerRow = round (_max / 4); 
        };
        
        USEC_GLOBAL_CONFIG_RIFLE_COMPETITION_TestLength = 4 * USEC_GLOBAL_CONFIG_RIFLE_COMPETITION_NumbersPerRow; 
        USEC_GLOBAL_CONFIG_RIFLE_COMPETITION_MagSize = USEC_GLOBAL_CONFIG_RIFLE_COMPETITION_TestLength / USEC_GLOBAL_CONFIG_RIFLE_COMPETITION_MagCount; 
        
        USEC_CLIENT_MESSAGE_ToAll = "RIFLE COMPETITION Length changed to: " + str (_courseLength);
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
    
    if(not (_courseType == "EXAM") && not (_courseType == "COMPETITION")) then {
        USEC_CLIENT_MESSAGE_ToAll = "Error: Course Type Invalid (did you misspell?)";
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
 };
  if(_weaponType == "MG") then {
      if(_courseType == "EXAM") then {
        USEC_GLOBAL_CONFIG_MG_EXAM_NumbersPerRow = round(_courseLength / 4); 
    
        if(_courseLength > 16 * USEC_GLOBAL_CONFIG_MG_EXAM_MagCount) then {
            _max = 16 * USEC_GLOBAL_CONFIG_MG_EXAM_MagCount;
            USEC_CLIENT_MESSAGE_ToAll = "Error: Exam Test Length too great; Defaulting to " + str (_max);
            publicVariable "USEC_CLIENT_MESSAGE_ToAll";
            USEC_GLOBAL_CONFIG_MG_EXAM_NumbersPerRow = round (_max / 4); 
        };
        
        USEC_GLOBAL_CONFIG_MG_EXAM_TestLength = 4 * USEC_GLOBAL_CONFIG_MG_EXAM_NumbersPerRow; 
        USEC_GLOBAL_CONFIG_MG_EXAM_MagSize = USEC_GLOBAL_CONFIG_MG_EXAM_TestLength / USEC_GLOBAL_CONFIG_MG_EXAM_MagCount; 
        
        USEC_CLIENT_MESSAGE_ToAll = "MG Exam Length changed to: " + str (_courseLength);
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
    
    if(_courseType == "COMPETITION") then {
        USEC_GLOBAL_CONFIG_MG_COMPETITION_NumbersPerRow = round(_courseLength / 4); 
    
        if(_courseLength > 16 * USEC_GLOBAL_CONFIG_MG_COMPETITION_MagCount) then {
            _max = 16 * USEC_GLOBAL_CONFIG_MG_COMPETITION_MagCount;
            USEC_CLIENT_MESSAGE_ToAll = "Error: COMPETITION Test Length too great; Defaulting to " + str (_max);
            publicVariable "USEC_CLIENT_MESSAGE_ToAll";
            USEC_GLOBAL_CONFIG_MG_COMPETITION_NumbersPerRow = round (_max / 4); 
        };
        
        USEC_GLOBAL_CONFIG_MG_COMPETITION_TestLength = 4 * USEC_GLOBAL_CONFIG_MG_COMPETITION_NumbersPerRow; 
        USEC_GLOBAL_CONFIG_MG_COMPETITION_MagSize = USEC_GLOBAL_CONFIG_MG_COMPETITION_TestLength / USEC_GLOBAL_CONFIG_MG_COMPETITION_MagCount; 
        
        USEC_CLIENT_MESSAGE_ToAll = "MG COMPETITION Length changed to: " + str (_courseLength);
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
    
    if(not (_courseType == "EXAM") && not (_courseType == "COMPETITION")) then {
        USEC_CLIENT_MESSAGE_ToAll = "Error: Course Type Invalid (did you misspell?)";
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
 };
  if(_weaponType == "MARKSMAN") then {
      if(_courseType == "EXAM") then {
        USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_NumbersPerRow = round(_courseLength / 4); 
    
        if(_courseLength > 16 * USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_MagCount) then {
            _max = 16 * USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_MagCount;
            USEC_CLIENT_MESSAGE_ToAll = "Error: Exam Test Length too great; Defaulting to " + str (_max);
            publicVariable "USEC_CLIENT_MESSAGE_ToAll";
            USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_NumbersPerRow = round (_max / 4); 
        };
        
        USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_TestLength = 4 * USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_NumbersPerRow; 
        USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_MagSize = USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_TestLength / USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_MagCount; 
        
        USEC_CLIENT_MESSAGE_ToAll = "MARKSMAN Exam Length changed to: " + str (_courseLength);
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
    
    if(_courseType == "COMPETITION") then {
        USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITION_NumbersPerRow = round(_courseLength / 4); 
    
        if(_courseLength > 16 * USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITION_MagCount) then {
            _max = 16 * USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITION_MagCount;
            USEC_CLIENT_MESSAGE_ToAll = "Error: COMPETITION Test Length too great; Defaulting to " + str (_max);
            publicVariable "USEC_CLIENT_MESSAGE_ToAll";
            USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITION_NumbersPerRow = round (_max / 4); 
        };
        
        USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITION_TestLength = 4 * USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITION_NumbersPerRow; 
        USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITION_MagSize = USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITION_TestLength / USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITION_MagCount; 
        
        USEC_CLIENT_MESSAGE_ToAll = "MARKSMAN COMPETITION Length changed to: " + str (_courseLength);
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
    
    if(not (_courseType == "EXAM") && not (_courseType == "COMPETITION")) then {
        USEC_CLIENT_MESSAGE_ToAll = "Error: Course Type Invalid (did you misspell?)";
        publicVariable "USEC_CLIENT_MESSAGE_ToAll";
    };
 };
 if(not (_weaponType == "PISTOL") && not (_weaponType == "RIFLE") && not (_weaponType == "MG") && not (_weaponType == "MARKSMAN")) then {
    USEC_CLIENT_MESSAGE_ToAll = "Error: Weapon Type Invalid (did you misspell?)";
    publicVariable "USEC_CLIENT_MESSAGE_ToAll";
 };
 