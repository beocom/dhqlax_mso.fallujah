/* 
 * Filename:
 * vehicleUnLock.sqf 
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

		_key = [VEHICLEKEYSARRAY, 0, 0, _vehicle] call searchMultiDimensionalArray;
	//	diag_log["(VEHICLEKEYSARRAY select _key) select 2",(VEHICLEKEYSARRAY select _key) select 2];
		
		_thisFuelAmount = parseNumber str((VEHICLEKEYSARRAY select _key) select 2);
		_vehicle setFuel _thisFuelAmount;
		
	// Remove vehicle from VEHICLEKEYSARRAY (all vehicles below shuffle up one index number)
		_v = _vehicle;

		for "_i" from 0 to (count VEHICLEKEYSARRAY - 1) do {
			  _m = VEHICLEKEYSARRAY select _i;
			  if (_v in _m) then { VEHICLEKEYSARRAY set [_i,"Delete"] };
		};
		VEHICLEKEYSARRAY = VEHICLEKEYSARRAY - ["Delete"];
		publicVariable "VEHICLEKEYSARRAY";
		
		_vehicle removeAction FNC_Vehicle_Keys;
		FNC_Vehicle_Keys = _vehicle addAction ["Take ignition keys", "core\modules\vehicleIgnitionKeys\vehicleLock.sqf"];
	  
		driver _vehicle action["engineOn", _vehicle];
		
	  hint "You have started the engine with the ignition keys";
// ====================================================================================