/* 
 * Filename:
 * vehicleRemoveAction.sqf 
 *
 * Description:
 * Spawns off init function to set player's vehicle respawn time
 * 
 * Created by [KH]Jman
 * Creation date: 02/05/2011
 * Email: jman@kellys-heroes.eu
 * Web: http://www.kellys-heroes.eu
 * 
 * */
// ====================================================================================
// MAIN

/* 
	Params passed to this script:
		object action was attached to
		unit that activated action
		index of action
*/
		
	_vehicle = _this select 0;
	_position = _this select 1;
	_leaver = _this select 2;
	
   if (player != _leaver) exitWith { };
   _vehicle removeAction FNC_Vehicle_Keys;  // Ignition
     FNC_Vehicle_Action = -1;
     
// ====================================================================================