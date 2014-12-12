/* 
 * Filename:
 * vehicleLock.sqf 
 *
 * Description:
 * Spawns off init function to set player's vehicle lock state
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
	_name = _this select 1;        
	_index = _this select 2;

	_thisVehicleFuel = fuel _vehicle;
	_vehicleDetails = [_vehicle, player, _thisVehicleFuel]; 
						
	  VEHICLEKEYSARRAY set [count VEHICLEKEYSARRAY, _vehicleDetails];
	  publicVariable "VEHICLEKEYSARRAY";
	  _vehicle setFuel 0;
	  _vehicle removeAction FNC_Vehicle_Keys;
	  FNC_Vehicle_Keys = _vehicle addAction ["Use ignition keys", "core\modules\vehicleIgnitionKeys\vehicleUnLock.sqf"];
	  
	  hint "You have taken the ignition keys";
// ====================================================================================