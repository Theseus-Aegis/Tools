/*
 * Author: John Doe (atlasicus)
 *
 * Global Variables for Shooting Course Server
 *
 * Arguments:
 * none
 *
 */

USEC_SERVER_BASIC_COURSE_CODE = compileFinal preprocessFile "BasicRangeExecute.sqf";
USEC_SERVER_PISTOL_CODE = compileFinal preprocessFile "PistolRangeExecute.sqf";
USEC_SERVER_RIFLE_CODE = compileFinal preprocessFile "RifleRangeExecute.sqf";
USEC_SERVER_MG_CODE = compileFinal preprocessFile "MGRangeExecute.sqf";
USEC_SERVER_MARKSMAN_CODE = compileFinal preprocessFile "MarksmanRangeExecute.sqf";

USEC_MP_TRAINING_targetUp = compileFinal "(_this select 0) animate ['terc', 0];";  
USEC_MP_TRAINING_targetDown = compileFinal "(_this select 0) animate ['terc', 1];";  
USEC_MP_TRAINING_targetReset = compileFinal preprocessFile "ServerDropTargets.sqf";

USEC_MP_STATIC_rifleRangeDir = getDir rifle_close_1;

/**********************************************
              Basic Course Variables
***********************************************/

USEC_SERVER_BASIC_TRAINING1_Enabled = false;
USEC_SERVER_BASIC_TRAINING2_Enabled = false;

USEC_SERVER_BASIC_TRAINING_PEEL_Targets = [BasicTarget_1_1, BasicTarget_1_2, BasicTarget_1_3, BasicTarget_1_4, BasicTarget_1_5, BasicTarget_1_6, BasicTarget_1_7];
USEC_SERVER_BASIC_TRAINING_BOUNDING_Targets = [BasicTarget_2_1, BasicTarget_2_2, BasicTarget_2_3, BasicTarget_2_4, BasicTarget_2_5, BasicTarget_2_6, BasicTarget_2_7];

/**********************************************
              Pistol Range Variables
***********************************************/

USEC_SERVER_PISTOL_PlayerName = "";
USEC_SERVER_PISTOL_PlayerOwner = "";
USEC_SERVER_PISTOL_PlayerObject = "";
USEC_SERVER_PISTOL_PlayerID = "";
USEC_SERVER_PISTOL_PlayerWeapon = "";
USEC_SERVER_PISTOL_TestLength = 0;

USEC_SERVER_PISTOL_TargetsHit = 0;
USEC_SERVER_PISTOL_ShotsFired = 0;

USEC_SERVER_PISTOL_CompetitiveScore = 0;

USEC_SERVER_PISTOL_TestType = -1;

USEC_MP_TRAINING_PISTOL_ShooterResults = -1;

/**********************************************
              Rifle Range Variables
***********************************************/

USEC_SERVER_RIFLE_PlayerName = "";
USEC_SERVER_RIFLE_PlayerOwner = "";
USEC_SERVER_RIFLE_PlayerObject = "";
USEC_SERVER_RIFLE_PlayerID = "";
USEC_SERVER_RIFLE_PlayerWeapon = "";
USEC_SERVER_RIFLE_TestLength = 0;

USEC_SERVER_RIFLE_TargetsHit = 0;
USEC_SERVER_RIFLE_ShotsFired = 0;

USEC_SERVER_RIFLE_TestType = -1;

USEC_MP_TRAINING_RIFLE_ShooterResults = -1;

/**********************************************
                MG Range Variables
***********************************************/

USEC_SERVER_MG_PlayerName = "";
USEC_SERVER_MG_PlayerOwner = "";
USEC_SERVER_MG_PlayerObject = "";
USEC_SERVER_MG_PlayerID = "";
USEC_SERVER_MG_PlayerWeapon = "";
USEC_SERVER_MG_TestLength = 0;

USEC_SERVER_MG_TargetsHit = 0;
USEC_SERVER_MG_ShotsFired = 0;

USEC_SERVER_MG_TestType = -1;

USEC_MP_TRAINING_MG_ShooterResults = -1;

/**********************************************
             Marksman Range Variables
***********************************************/

USEC_SERVER_MARKSMAN_PlayerName = "";
USEC_SERVER_MARKSMAN_PlayerOwner = "";
USEC_SERVER_MARKSMAN_PlayerObject = "";
USEC_SERVER_MARKSMAN_PlayerID = "";
USEC_SERVER_MARKSMAN_PlayerWeapon = "";
USEC_SERVER_MARKSMAN_TestLength = 0;

USEC_SERVER_MARKSMAN_TargetsHit = 0;
USEC_SERVER_MARKSMAN_ShotsFired = 0;

USEC_MP_TRAINING_MARKSMAN_ShooterResults = -1;

/**********************************************
       All Course Target Object Arrays
***********************************************/

USEC_MP_STATIC_PISTOL_ALL_targets = [pistolL1T1, pistolL1T2, pistolL1T3, pistolL1T4, pistolL1T5, 
                                 pistolL2T1, pistolL2T2, pistolL2T3, pistolL2T4, pistolL2T5,
                                 pistolL3T1, pistolL3T2, pistolL3T3, pistolL3T4, pistolL3T5,
                                 pistolL4T1, pistolL4T2, pistolL4T3, pistolL4T4, pistolL4T5
                                 ];
USEC_MP_STATIC_PISTOL_lane1Targets = [pistolL1T1, pistolL1T2, pistolL1T3, pistolL1T4, pistolL1T5];
USEC_MP_STATIC_PISTOL_lane2Targets = [pistolL2T1, pistolL2T2, pistolL2T3, pistolL2T4, pistolL2T5];
USEC_MP_STATIC_PISTOL_lane3Targets = [pistolL3T1, pistolL3T2, pistolL3T3, pistolL3T4, pistolL3T5];
USEC_MP_STATIC_PISTOL_lane4Targets = [pistolL4T1, pistolL4T2, pistolL4T3, pistolL4T4, pistolL4T5];

USEC_MP_STATIC_RIFLE_all_targets = [rifle_close_1, rifle_close_2, rifle_close_3, rifle_close_4, rifle_close_5,
                                    rifle_close_6, rifle_close_7, rifle_close_8, rifle_close_9, rifle_close_10,
                                    rifle_close_11, rifle_close_12, rifle_close_13, rifle_close_14,
                                    rifle_long_1, rifle_long_2, rifle_long_3, rifle_long_4, rifle_long_5,
                                    rifle_long_6, rifle_long_7, rifle_long_8, rifle_long_9, rifle_long_10,
                                    rifle_long_11, rifle_long_12, rifle_long_13, rifle_long_14
                                    ];


USEC_MP_STATIC_RIFLE_lane1Targets = [rifle_close_12, rifle_close_13, rifle_close_14];
USEC_MP_STATIC_RIFLE_lane2Targets = [rifle_close_8, rifle_close_9, rifle_close_10, rifle_close_11];                                    
USEC_MP_STATIC_RIFLE_lane3Targets = [rifle_close_5, rifle_close_6, rifle_close_7];
USEC_MP_STATIC_RIFLE_lane4Targets = [rifle_close_1, rifle_close_2, rifle_close_3, rifle_close_4];
USEC_MP_STATIC_RIFLE_lane5Targets = [rifle_long_12, rifle_long_13, rifle_long_14];
USEC_MP_STATIC_RIFLE_lane6Targets = [rifle_long_8, rifle_long_9, rifle_long_10, rifle_long_11];
USEC_MP_STATIC_RIFLE_lane7Targets = [rifle_long_5, rifle_long_6, rifle_long_7];
USEC_MP_STATIC_RIFLE_lane8Targets = [rifle_long_1, rifle_long_2, rifle_long_3, rifle_long_4];

USEC_MP_STATIC_MG_all_targets = [];
USEC_MP_STATIC_MG_lane1Targets = [];
USEC_MP_STATIC_MG_lane2Targets = [];
USEC_MP_STATIC_MG_lane3Targets = [];
USEC_MP_STATIC_MG_lane4Targets = [];
USEC_MP_STATIC_MG_lane5Targets = [];
USEC_MP_STATIC_MG_lane6Targets = [];
USEC_MP_STATIC_MG_lane7Targets = [];
USEC_MP_STATIC_MG_lane8Targets = [];
                                    
                                    
USEC_MP_STATIC_MARKSMAN_all_targets = [dmr_mid_1, dmr_mid_2, dmr_mid_3, dmr_mid_4, dmr_mid_5,
                                       dmr_mid_6, dmr_mid_7, dmr_mid_8, dmr_mid_9, dmr_mid_10,
                                       dmr_mid_11, dmr_mid_12, dmr_mid_13, dmr_mid_14,
                                       dmr_long_1, dmr_long_2, dmr_long_3, dmr_long_4, dmr_long_5, 
                                       dmr_long_6, dmr_long_7, dmr_long_8, dmr_long_9, dmr_long_10, 
                                       dmr_long_11, dmr_long_12, dmr_long_13, dmr_long_14
                                      ];
                                      
USEC_MP_STATIC_MARKSMAN_lane1Targets = [dmr_mid_12, dmr_mid_13, dmr_mid_14];
USEC_MP_STATIC_MARKSMAN_lane2Targets = [dmr_mid_8, dmr_mid_9, dmr_mid_10, dmr_mid_11];                                    
USEC_MP_STATIC_MARKSMAN_lane3Targets = [dmr_mid_5, dmr_mid_6, dmr_mid_7];
USEC_MP_STATIC_MARKSMAN_lane4Targets = [dmr_mid_1, dmr_mid_2, dmr_mid_3, dmr_mid_4];
USEC_MP_STATIC_MARKSMAN_lane5Targets = [dmr_long_11, dmr_long_13, dmr_long_14];
USEC_MP_STATIC_MARKSMAN_lane6Targets = [dmr_long_8, dmr_long_9, dmr_long_10, dmr_long_11];
USEC_MP_STATIC_MARKSMAN_lane7Targets = [dmr_long_5, dmr_long_6, dmr_long_7];
USEC_MP_STATIC_MARKSMAN_lane8Targets = [dmr_long_1, dmr_long_2, dmr_long_3, dmr_long_4];                                      
