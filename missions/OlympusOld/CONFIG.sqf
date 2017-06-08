/*
 * Author: John Doe (atlasicus)
 *
 * Server variables for testing configuration
 *
 * Arguments:
 * none
 *
 */
 
//Bullseye location for targets = posASL  x  y   z  
 USEC_SERVER_ALL_COURSES_BullseyePoint = [0, 0, 0.94];
 
 /************************************************
         Basic Training Course - Implemented
 *************************************************/
 
 //Change this variable for how long a target should stay up (seconds)
 USEC_GLOBAL_CONFIG_BASIC_TimeUpInSeconds = 3;
 
 //Change this variable for how long the range should wait before popping next targets (seconds)
 USEC_GLOBAL_CONFIG_BASIC_TimeBetweenPopInSeconds = 0.5;
 
  /************************************************
        Pistol Range - Practice/Exam
 *************************************************/
 
 //Change this variable for how long a target should stay up (seconds)
 USEC_GLOBAL_CONFIG_PISTOL_EXAM_TimeUpInSeconds = 1.5;
 
 //Change this variable for how long the range should wait before popping next targets (seconds)
 USEC_GLOBAL_CONFIG_PISTOL_EXAM_TimeBetweenPopInSeconds = 0.333;
 
 //Change this variable for the number of targets per row should be tested
 USEC_GLOBAL_CONFIG_PISTOL_EXAM_NumbersPerRow = 3;

 //Change this ONLY IF the number of rows on the pistol course has changed
 _handgunCourseNumberOfRows = 4;
 
//This calculates how many targets should be tested
//Change first number if more target rows are added
 USEC_GLOBAL_CONFIG_PISTOL_EXAM_TestLength = _handgunCourseNumberOfRows * USEC_GLOBAL_CONFIG_PISTOL_EXAM_NumbersPerRow;
  
 //Change this variable to assign the weapon used for the exam
 USEC_GLOBAL_CONFIG_PISTOL_EXAM_Weapon = "hgun_P07_F";
 
 //Change this variable to assign a different type of ammo for the exam
 USEC_GLOBAL_CONFIG_PISTOL_EXAM_MagType = "16Rnd_9x21_Mag";
 
 //Change this variable to assign this number of magazines to the player
 USEC_GLOBAL_CONFIG_PISTOL_EXAM_MagCount = 2;
 
  //Calculates how much ammo each magazine should hold
 USEC_GLOBAL_CONFIG_PISTOL_EXAM_MagSize = USEC_GLOBAL_CONFIG_PISTOL_EXAM_TestLength / USEC_GLOBAL_CONFIG_PISTOL_EXAM_MagCount;
 
  //Change this variable to determine wait time for reload
 USEC_GLOBAL_CONFIG_PISTOL_EXAM_ReloadTime = 4;
 
 //Change this variable to designate a passing score (PLAYER REPORTING ONLY) --Placeholder
 USEC_GLOBAL_CONFIG_PISTOL_EXAM_PassingScore = 24;
  
 /************************************************
              Pistol Range - Competitive
 *************************************************/
 
 //Change this variable for how long a target should stay up (seconds)
 USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_TimeUpInSeconds = 1.7;
 
 //Change this variable for how long the range should wait before popping next targets (seconds)
 USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_TimeBetweenPopInSeconds = 0;
 
 //Change this variable for the number of targets per row should be tested
 USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_NumbersPerRow = 3;

 //Change this ONLY IF the number of rows on the pistol course has changed
 _handgunCourseNumberOfRows = 4;
 
//This calculates how many targets should be tested
//Change first number if more target rows are added
 USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_TestLength = _handgunCourseNumberOfRows * USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_NumbersPerRow;
  
 //Change this variable to assign the weapon used for the COMPETITIVE
 USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_Weapon = "hgun_P07_F";
 
 //Change this variable to assign a different type of ammo for the COMPETITIVE
 USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_MagType = "16Rnd_9x21_Mag";
 
 //Change this variable to assign this number of magazines to the player
 USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_MagCount = 2;
 
  //Calculates how much ammo each magazine should hold
 USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_MagSize = USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_TestLength / USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_MagCount;
 
  //Change this variable to determine wait time for reload
 USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_ReloadTime = 4;
 
 //Change this variable to designate the maximum hitting a target is worth
 USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_BullseyeValue = 2;
 
 //Change this variable to assign how tolerant a bullseye is as a percent, see: http://i.imgur.com/WLAEVoV.png and http://i.imgur.com/FbAdlfP.png
 USEC_GLOBAL_CONFIG_PISTOL_COMPETITIVE_BullsEyeTolerance = 0.25; 

 /************************************************
              Rifle Range - Exam
 *************************************************/
 
 //Change this variable for how long a target should stay up (seconds)
  //For latency related reasons, it is suggested this number not be lower than 1.25.
 USEC_GLOBAL_CONFIG_RIFLE_EXAM_TimeUpInSeconds = 2.5;
 
 //Change this variable for how long the range should wait before popping next targets (seconds)
 USEC_GLOBAL_CONFIG_RIFLE_EXAM_TimeBetweenPopInSeconds = 0.25;
 
  //Change this variable for the number of targets per row should be tested
 USEC_GLOBAL_CONFIG_RIFLE_EXAM_NumbersPerRow = 2;
 
 //Change this ONLY IF the number of rows on the rifle course has changed
 _rifleCourseNumberOfRows = 8;
 
//This calculates how many targets should be tested
//Change first number if more target rows are added
 USEC_GLOBAL_CONFIG_RIFLE_EXAM_TestLength = _rifleCourseNumberOfRows * USEC_GLOBAL_CONFIG_RIFLE_EXAM_NumbersPerRow;
 
 //Change this variable to assign the weapon used for the exam
 USEC_GLOBAL_CONFIG_RIFLE_EXAM_Weapon = "rhs_weap_m16a4_carryhandle";
 
 //Add or remove attachments for test weapon
 USEC_GLOBAL_CONFIG_RIFLE_EXAM_WeaponAttachments =[];
 
 //Change this variable to assign a different type of ammo for the exam
 USEC_GLOBAL_CONFIG_RIFLE_EXAM_MagType = "rhs_mag_30Rnd_556x45_M855A1_Stanag";
 
 //Change this variable to assign this number of magazines to the player
 USEC_GLOBAL_CONFIG_RIFLE_EXAM_MagCount = 2;
 
 //Calculates how much ammo each magazine should hold
 USEC_GLOBAL_CONFIG_RIFLE_EXAM_MagSize = USEC_GLOBAL_CONFIG_RIFLE_EXAM_TestLength / USEC_GLOBAL_CONFIG_RIFLE_EXAM_MagCount;
 
 //Change this variable to determine wait time for reload
 USEC_GLOBAL_CONFIG_RIFLE_EXAM_ReloadTime = 5;
 
 //Change this variable to designate a passing score (PLAYER REPORTING ONLY) --Placeholder
 USEC_GLOBAL_CONFIG_RIFLE_EXAM_PassingScore = 24;
 
 
 /************************************************
              Rifle Range - Competitive
 *************************************************/
 
  //Change this variable for how long a target should stay up (seconds)
 USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_TimeUpInSeconds = 1.7;
 
 //Change this variable for how long the range should wait before popping next targets (seconds)
 USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_TimeBetweenPopInSeconds = 0;
 
 //Change this variable for the number of targets per row should be tested
 USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_NumbersPerRow = 2;

 //Change this ONLY IF the number of rows on the RIFLE course has changed
 _rifleCourseNumberOfRows = 8;
 
//This calculates how many targets should be tested
//Change first number if more target rows are added
 USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_TestLength = _rifleCourseNumberOfRows * USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_NumbersPerRow;
  
 //Change this variable to assign the weapon used for the COMPETITIVE
 USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_Weapon = "rhs_weap_m16a4";
 
 //Add or remove attachments for test weapon
 USEC_GLOBAL_CONFIG_RIFLE_EXAM_WeaponAttachments =["rhsusf_acc_compm4"];
 
 //Change this variable to assign a different type of ammo for the COMPETITIVE
 USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_MagType = "rhs_mag_30Rnd_556x45_M855A1_Stanag";
 
 //Change this variable to assign this number of magazines to the player
 USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_MagCount = 2;
 
  //Calculates how much ammo each magazine should hold
 USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_MagSize = USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_TestLength / USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_MagCount;
 
  //Change this variable to determine wait time for reload
 USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_ReloadTime = 4;
 
 //Change this variable to designate the maximum hitting a target is worth
 USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_BullseyeValue = 2;
 
 //Change this variable to assign how tolerant a bullseye is as a percent, see: http://i.imgur.com/WLAEVoV.png and http://i.imgur.com/FbAdlfP.png
 USEC_GLOBAL_CONFIG_RIFLE_COMPETITIVE_BullsEyeTolerance = 0.25; 
 
 /************************************************
              MG Range - Exam
 *************************************************/
 
 //Change this variable for how long a target should stay up (seconds)
  //For latency related reasons, it is suggested this number not be lower than 1.25.
 USEC_GLOBAL_CONFIG_MG_EXAM_TimeUpInSeconds = 1.5;
 
 //Change this variable for how long the range should wait before popping next targets (seconds)
 USEC_GLOBAL_CONFIG_MG_EXAM_TimeBetweenPopInSeconds = 0.25;
 
 //Change this variable for the number of targets per row should be tested
 USEC_GLOBAL_CONFIG_MG_EXAM_NumbersPerRow = 3;
 
 //Change this ONLY IF the number of rows on the rifle course has changed
 _rifleCourseNumberOfRows = 8;
 
  //This calculates how many targets should be tested
  //Change first number if more target rows are added
 USEC_GLOBAL_CONFIG_MG_EXAM_TestLength = _rifleCourseNumberOfRows * USEC_GLOBAL_CONFIG_MG_EXAM_NumbersPerRow;
 
 //Change this variable to assign the weapon used for the exam
 USEC_GLOBAL_CONFIG_MG_EXAM_Weapon = "rhs_weap_m249_pip";
 
 //Add or remove attachments for test weapon
 USEC_GLOBAL_CONFIG_MG_EXAM_WeaponAttachments =["rhsusf_acc_ELCAN"];
 
 //Change this variable to assign a different type of ammo for the exam
 USEC_GLOBAL_CONFIG_MG_EXAM_MagType = "rhsusf_100Rnd_556x45_soft_pouch";
 
 //Change this variable to assign this number of magazines to the player
 USEC_GLOBAL_CONFIG_MG_EXAM_MagCount = 2;
 
 //Calculates how much ammo each magazine should hold
 USEC_GLOBAL_CONFIG_MG_EXAM_MagSize = (USEC_GLOBAL_CONFIG_MG_EXAM_TestLength / USEC_GLOBAL_CONFIG_MG_EXAM_MagCount) * 3;
 
 //Change this variable to determine wait time for reload
 USEC_GLOBAL_CONFIG_MG_EXAM_ReloadTime = 15;
 
 //Change this variable to designate a passing score (PLAYER REPORTING ONLY) --Placeholder
 USEC_GLOBAL_CONFIG_MG_EXAM_PassingScore = 24;
 
 /************************************************
              MG Range - Competitive
 *************************************************/
 
 //Change this variable for how long a target should stay up (seconds) --Placeholder
 USEC_GLOBAL_CONFIG_MG_COMPETITIVE_TimeUpInSeconds = 1;
 
 //Change this variable for how long the range should wait before popping next targets (seconds) --Placeholder
 USEC_GLOBAL_CONFIG_MG_COMPETITIVE_TimeBetweenPopInSeconds = 0;
 
 /************************************************
              Marksman Range - Exam
 *************************************************/
 
 //Change this variable for how long a target should stay up (seconds)
  //For latency related reasons, it is suggested this number not be lower than 1.25.
 USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_TimeUpInSeconds = 1.5;
 
 //Change this variable for how long the range should wait before popping next targets (seconds)
 USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_TimeBetweenPopInSeconds = 0.25;
 
  //Change this variable for the number of targets per row should be tested
 USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_NumbersPerRow = 2;
 
 //Change this ONLY IF the number of rows on the MARKSMAN course has changed
 _marksmanCourseNumberOfRows = 8;
 
//This calculates how many targets should be tested
//Change first number if more target rows are added
 USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_TestLength = _marksmanCourseNumberOfRows * USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_NumbersPerRow;
 
 //Change this variable to assign the weapon used for the exam
 USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_Weapon = "rhs_weap_m14ebrri";
 
 //Add or remove attachments for test weapon
 USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_WeaponAttachments =["rhsusf_acc_ACOG"];
 
 //Change this variable to assign a different type of ammo for the exam
 USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_MagType = "rhsusf_20Rnd_762x51_m993_Mag";
 
 //Change this variable to assign this number of magazines to the player
 USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_MagCount = 2;
 
 //Calculates how much ammo each magazine should hold
 USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_MagSize = USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_TestLength / USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_MagCount;
 
 //Change this variable to determine wait time for reload
 USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_ReloadTime = 5;
 
 //Change this variable to designate a passing score (PLAYER REPORTING ONLY) --Placeholder
 USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_PassingScore = 24;
 
 /************************************************
              Marksman Range - Competitive
 *************************************************/
 
 //Change this variable for how long a target should stay up (seconds)
 USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITIVE_TimeUpInSeconds = 1.7;
 
 //Change this variable for how long the range should wait before popping next targets (seconds)
 USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITIVE_TimeBetweenPopInSeconds = 0;
 
 //Change this variable for the number of targets per row should be tested
 USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITIVE_NumbersPerRow = 2;

 //Change this ONLY IF the number of rows on the MARKSMAN course has changed
 _marksmanCourseNumberOfRows = 8;
 
//This calculates how many targets should be tested
//Change first number if more target rows are added
 USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITIVE_TestLength = _marksmanCourseNumberOfRows * USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITIVE_NumbersPerRow;
  
 //Change this variable to assign the weapon used for the COMPETITIVE
 USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITIVE_Weapon = "rhs_weap_m14ebrri";
 
 //Add or remove attachments for test weapon
 USEC_GLOBAL_CONFIG_MARKSMAN_EXAM_WeaponAttachments =["rhsusf_acc_ACOG"];
 
 //Change this variable to assign a different type of ammo for the COMPETITIVE
 USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITIVE_MagType = "rhsusf_20Rnd_762x51_m993_Mag";
 
 //Change this variable to assign this number of magazines to the player
 USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITIVE_MagCount = 2;
 
  //Calculates how much ammo each magazine should hold
 USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITIVE_MagSize = USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITIVE_TestLength / USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITIVE_MagCount;
 
  //Change this variable to determine wait time for reload
 USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITIVE_ReloadTime = 4;
 
 //Change this variable to designate the maximum hitting a target is worth
 USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITIVE_BullseyeValue = 2;
 
 //Change this variable to assign how tolerant a bullseye is as a percent, see: http://i.imgur.com/WLAEVoV.png and http://i.imgur.com/FbAdlfP.png
 USEC_GLOBAL_CONFIG_MARKSMAN_COMPETITIVE_BullsEyeTolerance = 0.25; 
 