/*
 * Author: Rory
 *
 * Handles the Vehicle Course.
 *
 * Arguments:
 * 0: Course Controller (Object)
 *
 * Return Value:
 * None
 */

#define COURSE_NAME "UTG Vehicle Course"
#define HUMVEE 'rhsusf_m1025_d'
#define STARTOBJ drive_startObj
#define ENDOBJ drive_endObj

_controller = _this;

_controller addAction ["Start Practice", {
  _controller = _this select 0; // Object addAction is assigned to

  hint "Spawning vehicle";
  sleep 2;
  hint "Stand by";
  sleep 2;

  _veh = createVehicle [HUMVEE, STARTOBJ, [],0,"CAN_COLLIDE"];
  _veh setDir (getDir STARTOBJ);

  _veh addEventHandler ["Engine", {
    {engine=true};
    _drivenvehicle = _this select 0;
    engine;
    hint "START!";
 
  }];

  hint "Vehicle Spawned";
  sleep 2;
  hint "Placing you in the vehicle";
  Sleep 2;
  hint "Course starts when you start the engine";
  player moveInDriver _veh;
  
 

  _veh addAction ["Restart", {
    _veh = _this select 0;
    _veh setPos (getPos STARTOBJ); 
    _veh setDir (getDir STARTOBJ);
  }];
  
}, nil, 6, false, true, "", "true"];

