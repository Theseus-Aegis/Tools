/*
 * Author: John Doe (atlasicus)
 *
 * Handles authentication and logic for rating 
 * and feedback of shooting range
 *
 * Arguments:
 * none
 *
 */

call compileFinal preprocessFile "SCServerGlobals.sqf";
call compileFinal preprocessFile "CONFIG.sqf";


/**********************************************
              Pistol Event Handlers
***********************************************/

"USEC_TRAINING_FRANGE_PISTOL_FiredShot" addPublicVariableEventHandler {
    USEC_SERVER_PISTOL_ShotsFired = USEC_SERVER_PISTOL_ShotsFired + 1;
};

"USEC_TRAINING_FRANGE_PISTOL_PlayerName" addPublicVariableEventHandler {
    USEC_SERVER_PISTOL_PlayerName = (_this select 1);
};

"USEC_TRAINING_FRANGE_PISTOL_PlayerWeapon" addPublicVariableEventHandler {
    USEC_SERVER_PISTOL_PlayerWeapon = (_this select 1);
};

"USEC_TRAINING_FRANGE_PISTOL_PlayerID" addPublicVariableEventHandler {
    USEC_SERVER_PISTOL_PlayerID = (_this select 1);
};

"USEC_TRAINING_FRANGE_PISTOL_PlayerOwner" addPublicVariableEventHandler {
    USEC_SERVER_PISTOL_PlayerObject = (_this select 1);
    USEC_SERVER_PISTOL_PlayerOwner = owner (_this select 1); 
};

"USEC_TRAINING_FRANGE_PISTOL_TestLength" addPublicVariableEventHandler {
    USEC_SERVER_PISTOL_TestLength = (_this select 1);
};

"USEC_TRAINING_FRANGE_PISTOL_TestType" addPublicVariableEventHandler {
    USEC_SERVER_PISTOL_TestType = (_this select 1);
    USEC_TRAINING_PISTOL_EXAM_PlayerAmmo = [USEC_GLOBAL_CONFIG_PISTOL_EXAM_MagType, USEC_GLOBAL_CONFIG_PISTOL_EXAM_MagSize, USEC_GLOBAL_CONFIG_PISTOL_EXAM_MagCount];
    USEC_SERVER_PISTOL_PlayerOwner publicVariableClient "USEC_GLOBAL_CONFIG_PISTOL_EXAM_Weapon";
    USEC_SERVER_PISTOL_PlayerOwner publicVariableClient "USEC_TRAINING_PISTOL_EXAM_PlayerAmmo";
};

/**********************************************
              Rifle Event Handlers
***********************************************/

"USEC_TRAINING_FRANGE_RIFLE_FiredShot" addPublicVariableEventHandler {
    USEC_SERVER_RIFLE_ShotsFired = USEC_SERVER_RIFLE_ShotsFired + 1;
};

"USEC_TRAINING_FRANGE_RIFLE_PlayerName" addPublicVariableEventHandler {
    USEC_SERVER_RIFLE_PlayerName = (_this select 1);
};

"USEC_TRAINING_FRANGE_RIFLE_PlayerWeapon" addPublicVariableEventHandler {
    USEC_SERVER_RIFLE_PlayerWeapon = (_this select 1);
};

"USEC_TRAINING_FRANGE_RIFLE_PlayerID" addPublicVariableEventHandler {
    USEC_SERVER_RIFLE_PlayerID = (_this select 1);
};

"USEC_TRAINING_FRANGE_RIFLE_PlayerOwner" addPublicVariableEventHandler {
    USEC_SERVER_RIFLE_PlayerObject = (_this select 1);
    USEC_SERVER_RIFLE_PlayerOwner = owner (_this select 1); 
};

"USEC_TRAINING_FRANGE_RIFLE_TestLength" addPublicVariableEventHandler {
    USEC_SERVER_RIFLE_TestLength = (_this select 1);
};

"USEC_TRAINING_FRANGE_RIFLE_TestType" addPublicVariableEventHandler {
    USEC_SERVER_RIFLE_TestType = (_this select 1);
    USEC_TRAINING_RIFLE_EXAM_PlayerAmmo = [USEC_GLOBAL_CONFIG_RIFLE_EXAM_MagType, USEC_GLOBAL_CONFIG_RIFLE_EXAM_MagSize, USEC_GLOBAL_CONFIG_RIFLE_EXAM_MagCount];
    USEC_TRAINING_RIFLE_EXAM_WeaponTotal = [USEC_GLOBAL_CONFIG_RIFLE_EXAM_Weapon, USEC_GLOBAL_CONFIG_RIFLE_EXAM_WeaponAttachments];
    USEC_SERVER_RIFLE_PlayerOwner publicVariableClient "USEC_TRAINING_RIFLE_EXAM_WeaponTotal";
    USEC_SERVER_RIFLE_PlayerOwner publicVariableClient "USEC_TRAINING_RIFLE_EXAM_PlayerAmmo";
};

/**********************************************
                MG Event Handlers
***********************************************/

"USEC_TRAINING_FRANGE_MG_FiredShot" addPublicVariableEventHandler {
    USEC_SERVER_MG_ShotsFired = USEC_SERVER_MG_ShotsFired + 1;
};

"USEC_TRAINING_FRANGE_MG_PlayerName" addPublicVariableEventHandler {
    USEC_SERVER_MG_PlayerName = (_this select 1);
};

"USEC_TRAINING_FRANGE_MG_PlayerWeapon" addPublicVariableEventHandler {
    USEC_SERVER_MG_PlayerWeapon = (_this select 1);
};

"USEC_TRAINING_FRANGE_MG_PlayerID" addPublicVariableEventHandler {
    USEC_SERVER_MG_PlayerID = (_this select 1);
};

"USEC_TRAINING_FRANGE_MG_PlayerOwner" addPublicVariableEventHandler {
    USEC_SERVER_MG_PlayerObject = (_this select 1);
    USEC_SERVER_MG_PlayerOwner = owner (_this select 1); 
};

"USEC_TRAINING_FRANGE_MG_TestLength" addPublicVariableEventHandler {
    USEC_SERVER_MG_TestLength = (_this select 1);
};

"USEC_TRAINING_FRANGE_MG_TestType" addPublicVariableEventHandler {
    USEC_SERVER_MG_TestType = (_this select 1);
    USEC_TRAINING_MG_EXAM_PlayerAmmo = [USEC_GLOBAL_CONFIG_MG_EXAM_MagType, USEC_GLOBAL_CONFIG_MG_EXAM_MagSize, USEC_GLOBAL_CONFIG_MG_EXAM_MagCount];
    USEC_TRAINING_MG_EXAM_WeaponTotal = [USEC_GLOBAL_CONFIG_MG_EXAM_Weapon, USEC_GLOBAL_CONFIG_MG_EXAM_WeaponAttachments];
    USEC_SERVER_MG_PlayerOwner publicVariableClient "USEC_TRAINING_MG_EXAM_WeaponTotal";
    USEC_SERVER_MG_PlayerOwner publicVariableClient "USEC_TRAINING_MG_EXAM_PlayerAmmo";
};

/**********************************************
             Marksman Event Handlers
***********************************************/

"USEC_TRAINING_FRANGE_MARKSMAN_FiredShot" addPublicVariableEventHandler {
    USEC_SERVER_MARKSMAN_ShotsFired = USEC_SERVER_PISTOL_ShotsFired + 1;
};

"USEC_TRAINING_FRANGE_MARKSMAN_PlayerName" addPublicVariableEventHandler {
    USEC_SERVER_MARKSMAN_PlayerName = (_this select 1);
};

"USEC_TRAINING_FRANGE_MARKSMAN_PlayerWeapon" addPublicVariableEventHandler {
    USEC_SERVER_MARKSMAN_PlayerWeapon = (_this select 1);
};

"USEC_TRAINING_FRANGE_MARKSMAN_PlayerID" addPublicVariableEventHandler {
    USEC_SERVER_MARKSMAN_PlayerID = (_this select 1);
};

"USEC_TRAINING_FRANGE_MARKSMAN_PlayerOwner" addPublicVariableEventHandler {
    USEC_SERVER_MARKSMAN_PlayerObject = (_this select 1);
    USEC_SERVER_MARKSMAN_PlayerOwner = owner (_this select 1); 
};

"USEC_TRAINING_FRANGE_MARKSMAN_TestLength" addPublicVariableEventHandler {
    USEC_SERVER_MARKSMAN_TestLength = (_this select 1);
};

"USEC_TRAINING_FRANGE_MARKSMAN_TestType" addPublicVariableEventHandler {
    USEC_SERVER_MARKSMAN_TestType = (_this select 1);
    USEC_TRAINING_MARKSMAN_EXAM_PlayerAmmo = [USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_MagType, USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_MagSize, USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_MagCount];
    USEC_TRAINING_MARKSMAN_EXAM_WeaponTotal = [USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_Weapon, USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_WeaponAttachments];
    USEC_SERVER_MARKSMAN_PlayerOwner publicVariableClient "USEC_TRAINING_MARKSMAN_EXAM_WeaponTotal";
    USEC_SERVER_MARKSMAN_PlayerOwner publicVariableClient "USEC_TRAINING_MARKSMAN_EXAM_PlayerAmmo";
};


/**********************************************
          Course Control Event Handler
***********************************************/

"USEC_TRAINING_FRANGE_BeginCourse" addPublicVariableEventHandler {
    _selection = (_this select 1);
    
    [_selection] call USEC_MP_TRAINING_targetReset;
    
    /**********************************************
                Pistol Range Activation
    ***********************************************/
    
    if(_selection == 0) then {
      USEC_SERVER_PISTOL_TargetsHit = 0;
      USEC_SERVER_PISTOL_ShotsFired = 0;
      [] spawn USEC_SERVER_PISTOL_CODE;
    };
    
    /**********************************************
                Peel Range Activation
    ***********************************************/
    
    if(_selection == 1) then{
        USEC_SERVER_BASIC_TRAINING1_Enabled = not USEC_SERVER_BASIC_TRAINING1_Enabled;
        
        if(USEC_SERVER_BASIC_TRAINING1_Enabled) then {
            [_selection] spawn USEC_SERVER_BASIC_COURSE_CODE;
        };
    };
    
    /**********************************************
                Bounding Range Activation
    ***********************************************/
    
    if(_selection == 2) then{
      USEC_SERVER_BASIC_TRAINING2_Enabled = not USEC_SERVER_BASIC_TRAINING2_Enabled;
        
        if(USEC_SERVER_BASIC_TRAINING2_Enabled) then {
            [_selection] spawn USEC_SERVER_BASIC_COURSE_CODE;
        };
    };
    
    /**********************************************
                Rifle Range Activation
    ***********************************************/
   if(_selection == 3) then {
      USEC_SERVER_RIFLE_TargetsHit = 0;
      USEC_SERVER_RIFLE_ShotsFired = 0;
      [] spawn USEC_SERVER_RIFLE_CODE;
   };
   
   /**********************************************
                MG Range Activation
    ***********************************************/
   
   if(_selection == 4) then {
      USEC_SERVER_MG_TargetsHit = 0;
      USEC_SERVER_MG_ShotsFired = 0;
      [] spawn USEC_SERVER_MG_CODE;
   };
   
   /**********************************************
                MARKSMAN Range Activation
    ***********************************************/
   
   if(_selection == 5) then {
      USEC_SERVER_MARKSMAN_TargetsHit = 0;
      USEC_SERVER_MARKSMAN_ShotsFired = 0;
      [] spawn USEC_SERVER_MARKSMAN_CODE;
   };
};
