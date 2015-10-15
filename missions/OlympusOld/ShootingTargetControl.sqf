/*
 * Author: John Doe (atlasicus), Jonpas
 *
 * Randomizes popup targets with disregard for who hit them
 * Will eventually be merged as overall target function
 *
 * Arguments:
 * 0: Course Controller (Object)
 *
 */
 
//animation definitions for MP
USEC_MP_TRAINING_targetUp = compileFinal "(_this select 0) animate ['terc', 0];";
USEC_MP_TRAINING_targetDown = compileFinal "(_this select 0) animate ['terc', 1];";  
USEC_MP_TRAINING_sendReport = compileFinal "USEC_TRAINING_FRANGE_TargetReport = 1;(owner (_this select 0)) publicVariableClient 'USEC_TRAINING_FRANGE_TargetReport';";
  
_controller = (_this select 0);

USEC_CLIENT_firingEventIndex = -1;

/**********************************************
         Basic Training Course Controller
***********************************************/

if(_controller == laptop_peel || _controller == laptop_bounding) then{
  _controller addAction ["Toggle Targets", {
    _addActionArgs = _this select 3; // addAction argument
    _controller = _addActionArgs select 0; // Object addAction is assigned to
    
    if(_controller == laptop_peel) then {
      USEC_TRAINING_FRANGE_BeginCourse = 1;
      
      publicVariableServer "USEC_TRAINING_FRANGE_BeginCourse";
    };
    if(_controller == laptop_bounding) then {
      USEC_TRAINING_FRANGE_BeginCourse = 2;
      
      publicVariableServer "USEC_TRAINING_FRANGE_BeginCourse";
    };
    
  },[_controller], 6, false, true,"","true"];
};

/**********************************************
          Pistol Course Controller
***********************************************/

if(_controller == laptop_pistol_range) then {

    /**********************************************
             Pistol Course Practice
    ***********************************************/
    _controller addAction ["Pistol Practice", {
    _addActionArgs = _this select 3; // addAction argument
    _controller = _addActionArgs select 0; // Object addAction is assigned to
    
    USEC_TRAINING_FRANGE_PISTOL_PlayerWeapon = (currentWeapon player);
    USEC_TRAINING_FRANGE_PISTOL_PlayerName = (name player);
    USEC_TRAINING_FRANGE_PISTOL_PlayerID = (getPlayerUID player);
    USEC_TRAINING_FRANGE_PISTOL_PlayerOwner = player;
    USEC_TRAINING_FRANGE_PISTOL_FiredShot = 0;
  
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_PlayerOwner";
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_PlayerName";
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_PlayerID";
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_PlayerWeapon";
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_TestLength";
    
    removeAllWeapons player;
    
    USEC_CLIENT_firingEventIndex = player addEventHandler["Fired", {
        USEC_TRAINING_FRANGE_PISTOL_FiredShot = player;
        publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_FiredShot";
        
        if((player ammo (currentWeapon player)) < 1) then {
            hint "Reload!";
        };
    }];
    
    "USEC_GLOBAL_CONFIG_PISTOL_EXAM_Weapon" addPublicVariableEventHandler{
        player addWeapon (_this select 1);
    };
    
    "USEC_TRAINING_PISTOL_EXAM_PlayerAmmo" addPublicVariableEventHandler{
        waitUntil{isNil (currentWeapon player)};
        _count = (_this select 1 select 2);
        _magType = (_this select 1 select 0);
        _magSize = (_this select 1 select 1);
        _totalMag = [_magType, _magSize];
        while {_count > 0} do{
            player addMagazine _totalMag;
            _count = _count - 1;
        };
    };
    
    USEC_TRAINING_FRANGE_PISTOL_TestType = 0;
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_TestType";
        
    //text before course starts
    hint "Get in position.";
    sleep 10;
    hint "Load Magazine";
    sleep 5;
    hint "Starting in 5";
    sleep 1;
    hint "Starting in 4";
    sleep 1;
    hint "Starting in 3";
    sleep 1;
    hint "Starting in 2";
    sleep 1;
    hint "Starting in 1";
    sleep 1;
    hint "Start!";
    
    "USEC_MP_TRAINING_PISTOL_ShooterResults" addPublicVariableEventHandler{
      _accuracy = (_this select 1);
      _output = (("Hit " + (str _accuracy)) + " percent of the targets");
      player globalChat _output;
      player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_PISTOL_ShooterInvalid" addPublicVariableEventHandler{
        hint "Unauthorized shooter on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_PISTOL_WeaponInvalid" addPublicVariableEventHandler{
        hint "Unauthorized weapon on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
  
    USEC_TRAINING_FRANGE_BeginCourse = 0;
    
    publicVariableServer "USEC_TRAINING_FRANGE_BeginCourse";
 },[_controller], 6, false, true,"","true"];
    
    /**********************************************
                  Pistol Course Exam
    ***********************************************/
    
    _controller addAction ["Pistol Exam", {
    _addActionArgs = _this select 3; // addAction argument
    _controller = _addActionArgs select 0; // Object addAction is assigned to
    
    USEC_TRAINING_FRANGE_PISTOL_PlayerWeapon = (currentWeapon player);
    USEC_TRAINING_FRANGE_PISTOL_PlayerName = (name player);
    USEC_TRAINING_FRANGE_PISTOL_PlayerID = (getPlayerUID player);
    USEC_TRAINING_FRANGE_PISTOL_PlayerOwner = player;
    USEC_TRAINING_FRANGE_PISTOL_FiredShot = 0;
  
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_PlayerOwner";
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_PlayerName";
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_PlayerID";
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_PlayerWeapon";
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_TestLength";
    
    removeAllWeapons player;
    
    USEC_CLIENT_firingEventIndex = player addEventHandler["Fired", {
        USEC_TRAINING_FRANGE_PISTOL_FiredShot = player;
        publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_FiredShot";
        if((player ammo (currentWeapon player)) < 1) then {
            hint "Reload!";
        };
    }];
    
    "USEC_GLOBAL_CONFIG_PISTOL_EXAM_Weapon" addPublicVariableEventHandler{
        player addWeapon (_this select 1);
    };
    
    "USEC_TRAINING_PISTOL_EXAM_PlayerAmmo" addPublicVariableEventHandler{
        waitUntil{isNil (currentWeapon player)};
        _count = (_this select 1 select 2);
        _magType = (_this select 1 select 0);
        _magSize = (_this select 1 select 1);
        _totalMag = [_magType, _magSize];
        while {_count > 0} do{
            player addMagazine _totalMag;
            _count = _count - 1;
        };
    };
    
    USEC_TRAINING_FRANGE_PISTOL_TestType = 1;
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_TestType";
        
    //text before course starts
    hint "Get in position.";
    sleep 10;
    hint "Load Magazine";
    sleep 5;
    hint "Starting in 5";
    sleep 1;
    hint "Starting in 4";
    sleep 1;
    hint "Starting in 3";
    sleep 1;
    hint "Starting in 2";
    sleep 1;
    hint "Starting in 1";
    sleep 1;
    hint "Start!";
    
    "USEC_MP_TRAINING_PISTOL_ShooterResults" addPublicVariableEventHandler{
      _accuracy = (_this select 1);
      _output = (("Hit " + (str _accuracy)) + " percent of the targets");
      player globalChat _output;
      player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_PISTOL_ShooterInvalid" addPublicVariableEventHandler{
        hint "Unauthorized shooter on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_PISTOL_WeaponInvalid" addPublicVariableEventHandler{
        hint "Unauthorized weapon on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
  
    USEC_TRAINING_FRANGE_BeginCourse = 0;
    
    publicVariableServer "USEC_TRAINING_FRANGE_BeginCourse";
    },[_controller], 5, false, true,"","true"];
    
    /**********************************************
                  Pistol Competition
    ***********************************************/
    
    _controller addAction ["Pistol Competition", {
    _addActionArgs = _this select 3; // addAction argument
    _controller = _addActionArgs select 0; // Object addAction is assigned to
    
    USEC_TRAINING_FRANGE_PISTOL_PlayerWeapon = (currentWeapon player);
    USEC_TRAINING_FRANGE_PISTOL_PlayerName = (name player);
    USEC_TRAINING_FRANGE_PISTOL_PlayerID = (getPlayerUID player);
    USEC_TRAINING_FRANGE_PISTOL_PlayerOwner = player;
    USEC_TRAINING_FRANGE_PISTOL_FiredShot = 0;
  
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_PlayerOwner";
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_PlayerName";
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_PlayerID";
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_PlayerWeapon";
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_TestLength";
    
    removeAllWeapons player;
    
    USEC_CLIENT_firingEventIndex = player addEventHandler["Fired", {
        USEC_TRAINING_FRANGE_PISTOL_FiredShot = player;
        publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_FiredShot";
        if((player ammo (currentWeapon player)) < 1) then {
            hint "Reload!";
        };
    }];
    
    "USEC_GLOBAL_CONFIG_PISTOL_EXAM_Weapon" addPublicVariableEventHandler{
        player addWeapon (_this select 1);
    };
    
    "USEC_TRAINING_PISTOL_EXAM_PlayerAmmo" addPublicVariableEventHandler{
        waitUntil{isNil (currentWeapon player)};
        _count = (_this select 1 select 2);
        _magType = (_this select 1 select 0);
        _magSize = (_this select 1 select 1);
        _totalMag = [_magType, _magSize];
        while {_count > 0} do{
            player addMagazine _totalMag;
            _count = _count - 1;
        };
    };
    
    "USEC_TRAINING_PISTOL_COMPETITIVE_Target" addPublicVariableEventHandler{
       USEC_TRAINING_PISTOL_COMPETITIVE_HitResult = []; 
       (_this select 1) addEventHandler["HitPart", "USEC_TRAINING_PISTOL_COMPETITIVE_HitResult = [(_this select 0 select 0), (_this select 0 select 3)];
                                                    publicVariableServer 'USEC_TRAINING_PISTOL_COMPETITIVE_HitResult';
                                                    (_this select 0 select 0) removeAllEventHandlers 'HitPart';"];
    };
    
    USEC_TRAINING_FRANGE_PISTOL_TestType = 2;
    publicVariableServer "USEC_TRAINING_FRANGE_PISTOL_TestType";
        
    //text before course starts
    hint "Get in position.";
    sleep 10;
    hint "Load Magazine";
    sleep 5;
    hint "Starting in 5";
    sleep 1;
    hint "Starting in 4";
    sleep 1;
    hint "Starting in 3";
    sleep 1;
    hint "Starting in 2";
    sleep 1;
    hint "Starting in 1";
    sleep 1;
    hint "Start!";
    
    "USEC_MP_TRAINING_PISTOL_ShooterResults" addPublicVariableEventHandler{
      _accuracy = (_this select 1);
      _output = (("Earned " + (str _accuracy)) + " points");
      player globalChat _output;
      player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_PISTOL_ShooterInvalid" addPublicVariableEventHandler{
        hint "Unauthorized shooter on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_PISTOL_WeaponInvalid" addPublicVariableEventHandler{
        hint "Unauthorized weapon on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
  
    USEC_TRAINING_FRANGE_BeginCourse = 0;
    
    publicVariableServer "USEC_TRAINING_FRANGE_BeginCourse";
    },[_controller], 4, false, true,"","true"];
};

/**********************************************
     Rifle + MG + Marksman Course Controller
***********************************************/

if(_controller == laptop_rifle_course) then {

    /**********************************************
                Rifle Course Practice
    ***********************************************/
    _controller addAction ["Practice Rifle Targets", {
    _addActionArgs = _this select 3; // addAction argument
    _controller = _addActionArgs select 0; // Object addAction is assigned to
    
    USEC_TRAINING_FRANGE_RIFLE_PlayerWeapon = (currentWeapon player);
    USEC_TRAINING_FRANGE_RIFLE_PlayerName = (name player);
    USEC_TRAINING_FRANGE_RIFLE_PlayerID = (getPlayerUID player);
    USEC_TRAINING_FRANGE_RIFLE_PlayerOwner = player;
    USEC_TRAINING_FRANGE_RIFLE_TestLength = (player ammo (currentWeapon player));
    USEC_TRAINING_FRANGE_RIFLE_FiredShot = 0;
  
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_PlayerOwner";
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_PlayerName";
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_PlayerID";
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_PlayerWeapon";
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_TestLength";
    
    removeAllWeapons player;
    
    USEC_CLIENT_firingEventIndex = player addEventHandler["Fired", {
        USEC_TRAINING_FRANGE_RIFLE_FiredShot = player;
        publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_FiredShot";
        if((player ammo (currentWeapon player)) < 1) then {
            hint "Reload!";
        };
    }];
    
    "USEC_TRAINING_RIFLE_EXAM_WeaponTotal" addPublicVariableEventHandler{
        _weapon = (_this select 1 select 0);
        waitUntil{isNil (currentWeapon player)};
        _attachments = (_this select 1 select 1);
        player addWeapon _weapon;
        {
          player addPrimaryWeaponItem _x;
        }forEach _attachments;
    };
    
    "USEC_TRAINING_RIFLE_EXAM_PlayerAmmo" addPublicVariableEventHandler{
        waitUntil{isNil (currentWeapon player)};
        _count = (_this select 1 select 2);
        _magType = (_this select 1 select 0);
        _magSize = (_this select 1 select 1);
        _totalMag = [_magType, _magSize];
        while {_count > 0} do{
            player addMagazine _totalMag;
            _count = _count - 1;
        };
    };
    
    USEC_TRAINING_FRANGE_RIFLE_TestType = 0;
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_TestType";
    
    //text before course starts
    hint "Get in position.";
    sleep 15;
    hint "Load Magazine";
    sleep 5;
    hint "Starting in 5";
    sleep 1;
    hint "Starting in 4";
    sleep 1;
    hint "Starting in 3";
    sleep 1;
    hint "Starting in 2";
    sleep 1;
    hint "Starting in 1";
    sleep 1;
    hint "Start!";
    
    
    "USEC_MP_TRAINING_RIFLE_ShooterResults" addPublicVariableEventHandler{
      _accuracy = (_this select 1);
      _output = (("Hit " + (str _accuracy)) + " percent of the targets");
      player globalChat _output;
      player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_RIFLE_ShooterInvalid" addPublicVariableEventHandler{
        hint "Unauthorized shooter on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_RIFLE_WeaponInvalid" addPublicVariableEventHandler{
        hint "Unauthorized weapon on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
  
    USEC_TRAINING_FRANGE_BeginCourse = 3;
    publicVariableServer "USEC_TRAINING_FRANGE_BeginCourse";
    
  },[_controller], 12, false, true,"","true"];
  
  /**********************************************
                Rifle Course Exam
    ***********************************************/
  
  _controller addAction ["Rifle Exam", {
    _addActionArgs = _this select 3; // addAction argument
    _controller = _addActionArgs select 0; // Object addAction is assigned to
    
    USEC_TRAINING_FRANGE_RIFLE_PlayerWeapon = (currentWeapon player);
    USEC_TRAINING_FRANGE_RIFLE_PlayerName = (name player);
    USEC_TRAINING_FRANGE_RIFLE_PlayerID = (getPlayerUID player);
    USEC_TRAINING_FRANGE_RIFLE_PlayerOwner = player;
    USEC_TRAINING_FRANGE_RIFLE_TestLength = (player ammo (currentWeapon player));
    USEC_TRAINING_FRANGE_RIFLE_FiredShot = 0;
  
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_PlayerOwner";
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_PlayerName";
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_PlayerID";
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_PlayerWeapon";
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_TestLength";
    
    removeAllWeapons player;
    
    USEC_CLIENT_firingEventIndex = player addEventHandler["Fired", {
        USEC_TRAINING_FRANGE_RIFLE_FiredShot = player;
        publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_FiredShot";
        if((player ammo (currentWeapon player)) < 1) then {
            hint "Reload!";
        };
    }];
    
    "USEC_TRAINING_RIFLE_EXAM_WeaponTotal" addPublicVariableEventHandler{
        _weapon = (_this select 1 select 0);
        waitUntil{isNil (currentWeapon player)};
        _attachments = (_this select 1 select 1);
        player addWeapon _weapon;
        {
          player addPrimaryWeaponItem _x;
        }forEach _attachments;
    };
    
    "USEC_TRAINING_RIFLE_EXAM_PlayerAmmo" addPublicVariableEventHandler{
        waitUntil{isNil (currentWeapon player)};
        _count = (_this select 1 select 2);
        _magType = (_this select 1 select 0);
        _magSize = (_this select 1 select 1);
        _totalMag = [_magType, _magSize];
        while {_count > 0} do{
            player addMagazine _totalMag;
            _count = _count - 1;
        };
    };
    
    USEC_TRAINING_FRANGE_RIFLE_TestType = 1;
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_TestType";
    
    //text before course starts
    hint "Get in position.";
    sleep 15;
    hint "Load Magazine";
    sleep 5;
    hint "Starting in 5";
    sleep 1;
    hint "Starting in 4";
    sleep 1;
    hint "Starting in 3";
    sleep 1;
    hint "Starting in 2";
    sleep 1;
    hint "Starting in 1";
    sleep 1;
    hint "Start!";
      
    USEC_TRAINING_FRANGE_BeginCourse = 3;
    publicVariableServer "USEC_TRAINING_FRANGE_BeginCourse";
    
    "USEC_MP_TRAINING_RIFLE_ShooterResults" addPublicVariableEventHandler{
      _accuracy = (_this select 1);
      _output = (("Hit " + (str _accuracy)) + " percent of the targets");
      player globalChat _output;
      player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_RIFLE_ShooterInvalid" addPublicVariableEventHandler{
        hint "Unauthorized shooter on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_RIFLE_WeaponInvalid" addPublicVariableEventHandler{
        hint "Unauthorized weapon on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };

  },[_controller], 11, false, true,"","true"];
  
  /**********************************************
                   Rifle Competition
    ***********************************************/
  
  _controller addAction ["Rifle Competition", {
    _addActionArgs = _this select 3; // addAction argument
    _controller = _addActionArgs select 0; // Object addAction is assigned to
    
    USEC_TRAINING_FRANGE_RIFLE_PlayerWeapon = (currentWeapon player);
    USEC_TRAINING_FRANGE_RIFLE_PlayerName = (name player);
    USEC_TRAINING_FRANGE_RIFLE_PlayerID = (getPlayerUID player);
    USEC_TRAINING_FRANGE_RIFLE_PlayerOwner = player;
    USEC_TRAINING_FRANGE_RIFLE_TestLength = (player ammo (currentWeapon player));
    USEC_TRAINING_FRANGE_RIFLE_FiredShot = 0;
  
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_PlayerOwner";
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_PlayerName";
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_PlayerID";
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_PlayerWeapon";
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_TestLength";
    
    removeAllWeapons player;
    
    USEC_CLIENT_firingEventIndex = player addEventHandler["Fired", {
        USEC_TRAINING_FRANGE_RIFLE_FiredShot = player;
        publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_FiredShot";
        if((player ammo (currentWeapon player)) < 1) then {
            hint "Reload!";
        };
    }];
    
    "USEC_TRAINING_RIFLE_EXAM_WeaponTotal" addPublicVariableEventHandler{
        _weapon = (_this select 1 select 0);
        waitUntil{isNil (currentWeapon player)};
        _attachments = (_this select 1 select 1);
        player addWeapon _weapon;
        {
          player addPrimaryWeaponItem _x;
        }forEach _attachments;
    };
    
    "USEC_TRAINING_RIFLE_EXAM_PlayerAmmo" addPublicVariableEventHandler{
        waitUntil{isNil (currentWeapon player)};
        _count = (_this select 1 select 2);
        _magType = (_this select 1 select 0);
        _magSize = (_this select 1 select 1);
        _totalMag = [_magType, _magSize];
        while {_count > 0} do{
            player addMagazine _totalMag;
            _count = _count - 1;
        };
    };
    
    "USEC_TRAINING_RIFLE_COMPETITIVE_Target" addPublicVariableEventHandler{
       USEC_TRAINING_RIFLE_COMPETITIVE_HitResult = []; 
       (_this select 1) addEventHandler["HitPart", "USEC_TRAINING_RIFLE_COMPETITIVE_HitResult = [(_this select 0 select 0), (_this select 0 select 3)];
                                                    publicVariableServer 'USEC_TRAINING_RIFLE_COMPETITIVE_HitResult';
                                                    (_this select 0 select 0) removeAllEventHandlers 'HitPart';"];
    };
    
    USEC_TRAINING_FRANGE_RIFLE_TestType = 2;
    publicVariableServer "USEC_TRAINING_FRANGE_RIFLE_TestType";
    
    //text before course starts
    hint "Get in position.";
    sleep 15;
    hint "Load Magazine";
    sleep 5;
    hint "Starting in 5";
    sleep 1;
    hint "Starting in 4";
    sleep 1;
    hint "Starting in 3";
    sleep 1;
    hint "Starting in 2";
    sleep 1;
    hint "Starting in 1";
    sleep 1;
    hint "Start!";
      
    USEC_TRAINING_FRANGE_BeginCourse = 3;
    publicVariableServer "USEC_TRAINING_FRANGE_BeginCourse";
    
    "USEC_MP_TRAINING_RIFLE_ShooterResults" addPublicVariableEventHandler{
      _accuracy = (_this select 1);
      _output = (("Hit " + (str _accuracy)) + " percent of the targets");
      player globalChat _output;
      player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_RIFLE_ShooterInvalid" addPublicVariableEventHandler{
        hint "Unauthorized shooter on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_RIFLE_WeaponInvalid" addPublicVariableEventHandler{
        hint "Unauthorized weapon on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };

  },[_controller], 10, false, true,"","true"];
  
    /**********************************************
                MG Course Practice
    ***********************************************/
  
  _controller addAction ["Practice MG Targets", {
    _addActionArgs = _this select 3; // addAction argument
    _controller = _addActionArgs select 0; // Object addAction is assigned to
    
    USEC_TRAINING_FRANGE_MG_PlayerWeapon = (currentWeapon player);
    USEC_TRAINING_FRANGE_MG_PlayerName = (name player);
    USEC_TRAINING_FRANGE_MG_PlayerID = (getPlayerUID player);
    USEC_TRAINING_FRANGE_MG_PlayerOwner = player;
    USEC_TRAINING_FRANGE_MG_TestLength = (player ammo (currentWeapon player));
    USEC_TRAINING_FRANGE_MG_FiredShot = 0;
  
    publicVariableServer "USEC_TRAINING_FRANGE_MG_PlayerOwner";
    publicVariableServer "USEC_TRAINING_FRANGE_MG_PlayerName";
    publicVariableServer "USEC_TRAINING_FRANGE_MG_PlayerID";
    publicVariableServer "USEC_TRAINING_FRANGE_MG_PlayerWeapon";
    publicVariableServer "USEC_TRAINING_FRANGE_MG_TestLength";
    
    removeAllWeapons player;
    
    USEC_CLIENT_firingEventIndex = player addEventHandler["Fired", {
        USEC_TRAINING_FRANGE_MG_FiredShot = player;
        publicVariableServer "USEC_TRAINING_FRANGE_MG_FiredShot";
        if((player ammo (currentWeapon player)) < 1) then {
            hint "Reload!";
        };
    }];
    
    "USEC_TRAINING_MG_EXAM_WeaponTotal" addPublicVariableEventHandler{
        _weapon = (_this select 1 select 0);
        waitUntil{isNil (currentWeapon player)};
        _attachments = (_this select 1 select 1);
        player addWeapon _weapon;
        {
          player addPrimaryWeaponItem _x;
        }forEach _attachments;
    };
    
    "USEC_TRAINING_MG_EXAM_PlayerAmmo" addPublicVariableEventHandler{
        waitUntil{isNil (currentWeapon player)};
        _count = (_this select 1 select 2);
        _magType = (_this select 1 select 0);
        _magSize = (_this select 1 select 1);
        _totalMag = [_magType, _magSize];
        while {_count > 0} do{
            player addMagazine _totalMag;
            _count = _count - 1;
        };
    };
    
    USEC_TRAINING_FRANGE_MG_TestType = 0;
    publicVariableServer "USEC_TRAINING_FRANGE_MG_TestType";
    
    //text before course starts
    hint "Get in position.";
    sleep 15;
    hint "Load Magazine";
    sleep 5;
    hint "Starting in 5";
    sleep 1;
    hint "Starting in 4";
    sleep 1;
    hint "Starting in 3";
    sleep 1;
    hint "Starting in 2";
    sleep 1;
    hint "Starting in 1";
    sleep 1;
    hint "Start!";
      
    USEC_TRAINING_FRANGE_BeginCourse = 4;
    publicVariableServer "USEC_TRAINING_FRANGE_BeginCourse";
    
    "USEC_MP_TRAINING_MG_ShooterResults" addPublicVariableEventHandler{
      _accuracy = (_this select 1);
      _output = (("Hit " + (str _accuracy)) + " percent of the targets");
      player globalChat _output;
      player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_MG_ShooterInvalid" addPublicVariableEventHandler{
        hint "Unauthorized shooter on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_MG_WeaponInvalid" addPublicVariableEventHandler{
        hint "Unauthorized weapon on course, test cancelled.";
        player globalChat "Offending weapon: " + str (_this select 1);
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };

  },[_controller], 9, false, true,"","true"];
  
  /**********************************************
                MG Course Exam
    ***********************************************/
  
  _controller addAction ["MG Exam", {
    _addActionArgs = _this select 3; // addAction argument
    _controller = _addActionArgs select 0; // Object addAction is assigned to
    
    USEC_TRAINING_FRANGE_MG_PlayerWeapon = (currentWeapon player);
    USEC_TRAINING_FRANGE_MG_PlayerName = (name player);
    USEC_TRAINING_FRANGE_MG_PlayerID = (getPlayerUID player);
    USEC_TRAINING_FRANGE_MG_PlayerOwner = player;
    USEC_TRAINING_FRANGE_MG_TestLength = (player ammo (currentWeapon player));
    USEC_TRAINING_FRANGE_MG_FiredShot = 0;
  
    publicVariableServer "USEC_TRAINING_FRANGE_MG_PlayerOwner";
    publicVariableServer "USEC_TRAINING_FRANGE_MG_PlayerName";
    publicVariableServer "USEC_TRAINING_FRANGE_MG_PlayerID";
    publicVariableServer "USEC_TRAINING_FRANGE_MG_PlayerWeapon";
    publicVariableServer "USEC_TRAINING_FRANGE_MG_TestLength";
    
    removeAllWeapons player;
    
    USEC_CLIENT_firingEventIndex = player addEventHandler["Fired", {
        USEC_TRAINING_FRANGE_MG_FiredShot = player;
        publicVariableServer "USEC_TRAINING_FRANGE_MG_FiredShot";
        if((player ammo (currentWeapon player)) < 1) then {
            hint "Reload!";
        };
    }];
    
    "USEC_TRAINING_RIFLE_EXAM_WeaponTotal" addPublicVariableEventHandler{
        _weapon = (_this select 1 select 0);
        waitUntil{isNil (currentWeapon player)};
        _attachments = (_this select 1 select 1);
        player addWeapon _weapon;
        {
          player addPrimaryWeaponItem _x;
        }forEach _attachments;
    };
    
    "USEC_TRAINING_RIFLE_EXAM_PlayerAmmo" addPublicVariableEventHandler{
        waitUntil{isNil (currentWeapon player)};
        _count = (_this select 1 select 2);
        _magType = (_this select 1 select 0);
        _magSize = (_this select 1 select 1);
        _totalMag = [_magType, _magSize];
        while {_count > 0} do{
            player addMagazine _totalMag;
            _count = _count - 1;
        };
    };
    
    USEC_TRAINING_FRANGE_MG_TestType = 1;
    publicVariableServer "USEC_TRAINING_FRANGE_MG_TestType";
    
    //text before course starts
    hint "Get in position.";
    sleep 15;
    hint "Load Magazine";
    sleep 5;
    hint "Starting in 5";
    sleep 1;
    hint "Starting in 4";
    sleep 1;
    hint "Starting in 3";
    sleep 1;
    hint "Starting in 2";
    sleep 1;
    hint "Starting in 1";
    sleep 1;
    hint "Start!";
      
    USEC_TRAINING_FRANGE_BeginCourse = 4;
    publicVariableServer "USEC_TRAINING_FRANGE_BeginCourse";
    
    "USEC_MP_TRAINING_MG_ShooterResults" addPublicVariableEventHandler{
      _accuracy = (_this select 1);
      _output = (("Hit " + (str _accuracy)) + " percent of the targets");
      player globalChat _output;
      player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_MG_ShooterInvalid" addPublicVariableEventHandler{
        hint "Unauthorized shooter on course, test cancelled.";
        player globalChat "Offending weapon: " + str (_this select 1);
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_MG_WeaponInvalid" addPublicVariableEventHandler{
        hint "Unauthorized weapon on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };

  },[_controller], 8, false, true,"","true"];
  
    /**********************************************
                Marksman Course Practice
    ***********************************************/
  
  _controller addAction ["Practice Marksman Targets", {
    _addActionArgs = _this select 3; // addAction argument
    _controller = _addActionArgs select 0; // Object addAction is assigned to
    
    USEC_TRAINING_FRANGE_MARKSMAN_PlayerWeapon = (currentWeapon player);
    USEC_TRAINING_FRANGE_MARKSMAN_PlayerName = (name player);
    USEC_TRAINING_FRANGE_MARKSMAN_PlayerID = (getPlayerUID player);
    USEC_TRAINING_FRANGE_MARKSMAN_PlayerOwner = player;
    USEC_TRAINING_FRANGE_MARKSMAN_TestLength = (player ammo (currentWeapon player));
    USEC_TRAINING_FRANGE_MARKSMAN_FiredShot = 0;
  
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_PlayerOwner";
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_PlayerName";
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_PlayerID";
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_PlayerWeapon";
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_TestLength";
    
    removeAllWeapons player;
    
    USEC_CLIENT_firingEventIndex = player addEventHandler["Fired", {
        USEC_TRAINING_FRANGE_MARKSMAN_FiredShot = player;
        publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_FiredShot";
        if((player ammo (currentWeapon player)) < 1) then {
            hint "Reload!";
        };
    }];
    
    "USEC_TRAINING_MARKSMAN_EXAM_WeaponTotal" addPublicVariableEventHandler{
        _weapon = (_this select 1 select 0);
        waitUntil{isNil (currentWeapon player)};
        _attachments = (_this select 1 select 1);
        player addWeapon _weapon;
        {
          player addPrimaryWeaponItem _x;
        }forEach _attachments;
    };
    
    "USEC_TRAINING_MARKSMAN_EXAM_PlayerAmmo" addPublicVariableEventHandler{
        waitUntil{isNil (currentWeapon player)};
        _count = (_this select 1 select 2);
        _magType = (_this select 1 select 0);
        _magSize = (_this select 1 select 1);
        _totalMag = [_magType, _magSize];
        while {_count > 0} do{
            player addMagazine _totalMag;
            _count = _count - 1;
        };
    };
    
    USEC_TRAINING_FRANGE_MARKSMAN_TestType = 0;
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_TestType";
    
    //text before course starts
    hint "Get in position.";
    sleep 15;
    hint "Load Magazine";
    sleep 5;
    hint "Starting in 5";
    sleep 1;
    hint "Starting in 4";
    sleep 1;
    hint "Starting in 3";
    sleep 1;
    hint "Starting in 2";
    sleep 1;
    hint "Starting in 1";
    sleep 1;
    hint "Start!";
      
    USEC_TRAINING_FRANGE_BeginCourse = 5;
    publicVariableServer "USEC_TRAINING_FRANGE_BeginCourse";
    
    "USEC_MP_TRAINING_MARKSMAN_ShooterResults" addPublicVariableEventHandler{
      _accuracy = (_this select 1);
      _output = (("Hit " + (str _accuracy)) + " percent of the targets");
      player globalChat _output;
      player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_MARKSMAN_ShooterInvalid" addPublicVariableEventHandler{
        hint "Unauthorized shooter on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_MARKSMAN_WeaponInvalid" addPublicVariableEventHandler{
        hint "Unauthorized weapon on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };

  },[_controller], 7, false, true,"","true"];

    /**********************************************
                Marksman Course Exam
    ***********************************************/
  
  _controller addAction ["Marksman Exam", {
    _addActionArgs = _this select 3; // addAction argument
    _controller = _addActionArgs select 0; // Object addAction is assigned to
    
    USEC_TRAINING_FRANGE_MARKSMAN_PlayerWeapon = (currentWeapon player);
    USEC_TRAINING_FRANGE_MARKSMAN_PlayerName = (name player);
    USEC_TRAINING_FRANGE_MARKSMAN_PlayerID = (getPlayerUID player);
    USEC_TRAINING_FRANGE_MARKSMAN_PlayerOwner = player;
    USEC_TRAINING_FRANGE_MARKSMAN_TestLength = (player ammo (currentWeapon player));
    USEC_TRAINING_FRANGE_MARKSMAN_FiredShot = 0;
  
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_PlayerOwner";
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_PlayerName";
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_PlayerID";
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_PlayerWeapon";
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_TestLength";
    
    removeAllWeapons player;
    
    USEC_CLIENT_firingEventIndex = player addEventHandler["Fired", {
        USEC_TRAINING_FRANGE_MARKSMAN_FiredShot = player;
        publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_FiredShot";
        if((player ammo (currentWeapon player)) < 1) then {
            hint "Reload!";
        };
    }];
    
    "USEC_TRAINING_MARKSMAN_EXAM_WeaponTotal" addPublicVariableEventHandler{
        _weapon = (_this select 1 select 0);
        waitUntil{isNil (currentWeapon player)};
        _attachments = (_this select 1 select 1);
        player addWeapon _weapon;
        {
          player addPrimaryWeaponItem _x;
        }forEach _attachments;
    };
    
    "USEC_TRAINING_MARKSMAN_EXAM_PlayerAmmo" addPublicVariableEventHandler{
        waitUntil{isNil (currentWeapon player)};
        _count = (_this select 1 select 2);
        _magType = (_this select 1 select 0);
        _magSize = (_this select 1 select 1);
        _totalMag = [_magType, _magSize];
        while {_count > 0} do{
            player addMagazine _totalMag;
            _count = _count - 1;
        };
    };
    
    USEC_TRAINING_FRANGE_MARKSMAN_TestType = 1;
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_TestType";
    
    //text before course starts
    hint "Get in position.";
    sleep 15;
    hint "Load Magazine";
    sleep 5;
    hint "Starting in 5";
    sleep 1;
    hint "Starting in 4";
    sleep 1;
    hint "Starting in 3";
    sleep 1;
    hint "Starting in 2";
    sleep 1;
    hint "Starting in 1";
    sleep 1;
    hint "Start!";
      
    USEC_TRAINING_FRANGE_BeginCourse = 5;
    publicVariableServer "USEC_TRAINING_FRANGE_BeginCourse";
    
    "USEC_MP_TRAINING_MARKSMAN_ShooterResults" addPublicVariableEventHandler{
      _accuracy = (_this select 1);
      _output = (("Hit " + (str _accuracy)) + " percent of the targets");
      player globalChat _output;
      player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_MARKSMAN_ShooterInvalid" addPublicVariableEventHandler{
        hint "Unauthorized shooter on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_MARKSMAN_WeaponInvalid" addPublicVariableEventHandler{
        hint "Unauthorized weapon on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };

  },[_controller], 6, false, true,"","true"];
  
  /**********************************************
                Marksman Competition
    ***********************************************/
  
  _controller addAction ["Marksman Competition", {
    _addActionArgs = _this select 3; // addAction argument
    _controller = _addActionArgs select 0; // Object addAction is assigned to
    
    USEC_TRAINING_FRANGE_MARKSMAN_PlayerWeapon = (currentWeapon player);
    USEC_TRAINING_FRANGE_MARKSMAN_PlayerName = (name player);
    USEC_TRAINING_FRANGE_MARKSMAN_PlayerID = (getPlayerUID player);
    USEC_TRAINING_FRANGE_MARKSMAN_PlayerOwner = player;
    USEC_TRAINING_FRANGE_MARKSMAN_TestLength = (player ammo (currentWeapon player));
    USEC_TRAINING_FRANGE_MARKSMAN_FiredShot = 0;
  
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_PlayerOwner";
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_PlayerName";
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_PlayerID";
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_PlayerWeapon";
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_TestLength";
    
    removeAllWeapons player;
    
    USEC_CLIENT_firingEventIndex = player addEventHandler["Fired", {
        USEC_TRAINING_FRANGE_MARKSMAN_FiredShot = player;
        publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_FiredShot";
        if((player ammo (currentWeapon player)) < 1) then {
            hint "Reload!";
        };
    }];
    
    "USEC_TRAINING_MARKSMAN_EXAM_WeaponTotal" addPublicVariableEventHandler{
        _weapon = (_this select 1 select 0);
        waitUntil{isNil (currentWeapon player)};
        _attachments = (_this select 1 select 1);
        player addWeapon _weapon;
        {
          player addPrimaryWeaponItem _x;
        }forEach _attachments;
    };
    
    "USEC_TRAINING_MARKSMAN_EXAM_PlayerAmmo" addPublicVariableEventHandler{
        waitUntil{isNil (currentWeapon player)};
        _count = (_this select 1 select 2);
        _magType = (_this select 1 select 0);
        _magSize = (_this select 1 select 1);
        _totalMag = [_magType, _magSize];
        while {_count > 0} do{
            player addMagazine _totalMag;
            _count = _count - 1;
        };
    };
    
    "USEC_TRAINING_MARKSMAN_COMPETITIVE_Target" addPublicVariableEventHandler{
       USEC_TRAINING_MARKSMAN_COMPETITIVE_HitResult = []; 
       (_this select 1) addEventHandler["HitPart", "USEC_TRAINING_MARKSMAN_COMPETITIVE_HitResult = [(_this select 0 select 0), (_this select 0 select 3)];
                                                    publicVariableServer 'USEC_TRAINING_MARKSMAN_COMPETITIVE_HitResult';
                                                    (_this select 0 select 0) removeAllEventHandlers 'HitPart';"];
    };
    
    USEC_TRAINING_FRANGE_MARKSMAN_TestType = 2;
    publicVariableServer "USEC_TRAINING_FRANGE_MARKSMAN_TestType";
    
    //text before course starts
    hint "Get in position.";
    sleep 15;
    hint "Load Magazine";
    sleep 5;
    hint "Starting in 5";
    sleep 1;
    hint "Starting in 4";
    sleep 1;
    hint "Starting in 3";
    sleep 1;
    hint "Starting in 2";
    sleep 1;
    hint "Starting in 1";
    sleep 1;
    hint "Start!";
      
    USEC_TRAINING_FRANGE_BeginCourse = 5;
    publicVariableServer "USEC_TRAINING_FRANGE_BeginCourse";
    
    "USEC_MP_TRAINING_MARKSMAN_ShooterResults" addPublicVariableEventHandler{
      _accuracy = (_this select 1);
      _output = (("Hit " + (str _accuracy)) + " percent of the targets");
      player globalChat _output;
      player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_MARKSMAN_ShooterInvalid" addPublicVariableEventHandler{
        hint "Unauthorized shooter on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };
     
     "USEC_MP_TRAINING_MARKSMAN_WeaponInvalid" addPublicVariableEventHandler{
        hint "Unauthorized weapon on course, test cancelled.";
        player removeEventHandler ["Fired", USEC_CLIENT_firingEventIndex];
     };

  },[_controller], 5, false, true,"","true"];
};
 