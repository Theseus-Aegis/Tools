nopop = true; // Disables pop-up, can be manually animated using: Object animate["terc",0]; (0-up, 1-down)


if (isDedicated) then {
    execVM "ShootingCourseServer.sqf"; 
}else{
    waitUntil {not isNull player && time > 0}; //Add controller code here for JIT player access
    [laptop_pistol_range] execVM "ShootingTargetControl.sqf";
    [laptop_peel]execVM "ShootingTargetControl.sqf";
    [laptop_bounding]execVM "ShootingTargetControl.sqf";
    [laptop_rifle_Course] execVM "ShootingTargetControl.sqf";
    
    "USEC_CLIENT_MESSAGE_ToAll" addPublicVariableEventHandler {
        systemChat (_this select 1);
    };
};
#include "initPlayerLocal.sqf"
