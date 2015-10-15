/*
 * Author: Jonpas
 *
 * Modifier: John Doe (atlasicus)
 *
 * Randomizes popup targets
 *
 *
 * Arguments:
 * 0: Course Controller (Object)
 *
 *
 */

_controller = _this;

 _controller addAction ["Start Practice", {
      _addActionArgs = _this select 3; // addAction argument
      _controller = _addActionArgs select 0; // Object addAction is assigned to
          
      // Names of all targets
      _targets = [ 
        pistolL1T1,
        pistolL1T2,
        pistolL1T3,
        pistolL1T4,
        pistolL1T5,
        pistolL2T1,
        pistolL2T2,
        pistolL2T3,
        pistolL2T4,
        pistolL2T5,
        pistolL3T1,
        pistolL3T2,
        pistolL3T3,
        pistolL3T4,
        pistolL3T5,
        pistolL4T1,
        pistolL4T2,
        pistolL4T3,
        pistolL4T4,
        pistolL4T5
      ];

      // Loop through all targets to put them DOWN on default
      {
        _x animate ["terc", 1];
      } forEach _targets;
      
            //text before course starts
            hint "Get in position.";
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
   
    
        //stop popping up targets
    _controller addAction ["Stop", {
            UTG_TargetPopupTest = false;
      },[_controller], 6, false, true,"","true"];
   
    UTG_TargetPopupTest = true;
    UTG_TargetPupupTestKilled = false;
    while {UTG_TargetPopupTest} do {
      // Random selection of a target
      _randomTarget = _targets select (floor (random (count _targets)));

      // Pop target UP
      _randomTarget animate ["terc", 0];
      
      //Add event handler for hit
      _randomTarget addEventHandler ["Hit", "
          UTG_TargetPupupTestKilled = true;

          hint 'target Hit';
        "];

      // Wait and pop target DOWN
      _currentTime = time;
      waitUntil {time > _currentTime + 3 || UTG_TargetPupupTestKilled};
      if(UTG_TargetPupupTestKilled) then{
        UTG_TargetPupupTestKilled = false;
      };
      
      //Reset marker and short pause until next popup
      _currentTime = time;
      _randomTarget animate ["terc", 1];
      _randomTarget removeAllEventHandlers "Hit";
      waitUntil{time > _currentTime + 0.5}; //Adjust this for faster or slower target pop`
    };
    
 },[_controller], 6, false, true,"","true"];
 