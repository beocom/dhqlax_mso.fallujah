/* 
 * Filename:
 * main.sqf 
 *
 * Description:
 * Vehicle Ignition Keys
 * 
 * Created by [KH]Jman
 * Creation date: 15/12/2010
 * Email: jman@kellys-heroes.eu
 * Web: http://www.kellys-heroes.eu
 * 
 * modified for MSO: 16/08/2012
 *
 * */
 
 
  if(isNil "CFG_VehicleIgnitionKeys") then {CFG_VehicleIgnitionKeys = 1;};
  
// ====================================================================================
// SERVER FUNCTIONS
// ====================================================================================
	// SET VEHICLE RESPAWN PV ARRAY
	if (isServer) then {
			if (isNil "NORESPAWNVEHICLESARRAY") then {
				NORESPAWNVEHICLESARRAY = [];
				publicVariable "NORESPAWNVEHICLESARRAY";
			};
	
		// SET VEHICLE KEYS PV MULTi-D ARRAY
			if (isNil "VEHICLEKEYSARRAY") then {
				VEHICLEKEYSARRAY = [];
				publicVariable "VEHICLEKEYSARRAY";
			};
	
		 // SET VEHICLE STATES
		 publicVariable "VEHICLE_STATES_LOADED"; 
			if (isNil "VEHICLE_STATES_LOADED") then {
				VEHICLE_STATES_LOADED = "true";	
				execVM "core\modules\vehicleIgnitionKeys\setVehicle_state.sqf";
				publicVariable "VEHICLE_STATES_LOADED"; 
			};
	};
// ====================================================================================	
	 "VEHICLERESPAWNED" addPublicVariableEventHandler { (_this select 1) call FNC_INITVEHICLEACTIONS };
// ====================================================================================
// MODULE FUNCTIONS
// ====================================================================================
	FNC_INITVEHICLEACTIONS = {
	//	hint "FNC_INITVEHICLEACTIONS";
		 _vehicle = _this select 0; 
	//	diag_log["_vehicle: ", _vehicle];
	
			if (typeOf _vehicle != "MMT_Civ" || 
					typeOf _vehicle != "SearchLight" ||
					typeOf _vehicle != "BAF_L2A1_Minitripod_D" ||
					typeOf _vehicle != "M119" ||
					typeOf _vehicle != "MtvrRefuel" ||
					typeOf _vehicle != "BAF_L2A1_Tripod_D" ||
					typeOf _vehicle != "Barrels") 
			then {
				 _vehicle addeventhandler ["getin", { _this execVM "core\modules\vehicleIgnitionKeys\vehicleAddAction.sqf"; } ];
				 _vehicle addeventhandler ["getout", { _this execVM "core\modules\vehicleIgnitionKeys\vehicleRemoveAction.sqf"; } ];
			};
	};
// ====================================================================================
	FNC_VEHICLE_CODE =
	{ 
		_player = _this select 0;
		
		 if (player != _player) exitWith { };
		
		 	if (FNC_Vehicle_Action == -1)  then {
				// VEHICLEKEYSARRAY:
				//  0 = vehicle 
				//  1 = player who has keys
				//  2 = the vehicles fuel amount 
			if (CFG_VehicleIgnitionKeys == 1) then {
				_thisvehicle = [VEHICLEKEYSARRAY, 0, 0, vehicle player] call searchMultiDimensionalArray;     // get the vehicle
				
				if (_thisvehicle != -1) then {  // if we find the vehicle in the array
					// lets see if this player has the keys...
					_keys = [VEHICLEKEYSARRAY, 0, 1, player] call searchMultiDimensionalArray;  // find the player in the array and return the index number
							if (_keys != -1) then {   // if the player has the keys to this vehicle
							FNC_Vehicle_Keys = vehicle player addAction ["Use ignition keys", "core\modules\vehicleIgnitionKeys\vehicleUnLock.sqf"];
							 hint "You have the ignition keys to this vehicle";
					} else {  // if the player does not have the keys to this vehicle 
						  // lets see who has the keys...  
							_playerWithKeys = (VEHICLEKEYSARRAY select _thisvehicle) select 1;
							// check if the player with keys is still in the game and if not return the keys to the vehicle
									_thisPlayer = objNull;
									{	
										if (_x == _playerWithKeys) exitWith {
										   _thisPlayer = _x;
										 };
									} 
									forEach playableUnits;
										if !(isNull _thisPlayer) then {	
											hint format["%1 has the ignition keys to this vehicle", str((name _thisPlayer))];
										} else { 
											[_playerWithKeys] call FNC_REMOVE_FROM_VEHICLE_KEYS_ARRAY;
										 };
					};
				} else {  // if the vehicle is not in the array (therefore it's not locked)...
						FNC_Vehicle_Keys = vehicle player addAction ["Take ignition keys", "core\modules\vehicleIgnitionKeys\vehicleLock.sqf"];
				};
			};
			};
	};
// ====================================================================================
	FNC_REMOVE_FROM_VEHICLE_KEYS_ARRAY =     // Return all keys to vehicles the player holds.
	{
			_player = _this select 0;
				// VEHICLEKEYSARRAY:
				//  0 = vehicle 
				//  1 = player who has keys
				//  2 = the vehicles fuel amount 
			for [{_i=0},{_i < count(VEHICLEKEYSARRAY)},{_i=_i+1}] do 	// START loop through all records
			{	
				// find player  in array...
				_key = [VEHICLEKEYSARRAY, 0, 1, _player] call searchMultiDimensionalArray;
				 if (_key != -1) then { 
				//		diag_log["count(VEHICLEKEYSARRAY): ", count(VEHICLEKEYSARRAY)];
						// add fuel back to this vehicle that the player has keys to
						_thisFuelAmount = parseNumber str((VEHICLEKEYSARRAY select _key) select 2);
						_thisVehicle = (VEHICLEKEYSARRAY select _key) select 0;
						_thisVehicle setFuel _thisFuelAmount;
						// Remove vehicle from VEHICLEKEYSARRAY (all vehicles below shuffle up one index number)
						VEHICLEKEYSARRAY set [_key,"Delete"];
						VEHICLEKEYSARRAY = VEHICLEKEYSARRAY - ["Delete"];
					};
				publicVariable "VEHICLEKEYSARRAY";
			};		
	};
// ====================================================================================
		if ((!isServer) || (!isdedicated)) then {
			if (CFG_VehicleIgnitionKeys == 1) then {
					_thisObject = objNull;
					{
					_thisObject = _x;
						if (vehiclevarname _thisObject != "") then {
							/*
								diag_log["_thisObject: ", _thisObject];
								diag_log["typeOf _thisObject: ", typeOf _thisObject];
							*/	
								if (typeOf _thisObject != "MMT_Civ" || 
										typeOf _thisObject != "SearchLight" ||
										typeOf _thisObject != "BAF_L2A1_Minitripod_D" ||
										typeOf _thisObject != "M119" ||
										typeOf _thisObject != "MtvrRefuel" ||
										typeOf _thisObject != "BAF_L2A1_Tripod_D" ||
										typeOf _thisObject != "Barrels") 
								then {
									 _thisObject addeventhandler ["getin", { _this execVM "core\modules\vehicleIgnitionKeys\vehicleAddAction.sqf"; } ];
					 				 _thisObject addeventhandler ["getout", { _this execVM "core\modules\vehicleIgnitionKeys\vehicleRemoveAction.sqf"; } ];
				 				};
						};
					} forEach vehicles; 		
			};
	};
