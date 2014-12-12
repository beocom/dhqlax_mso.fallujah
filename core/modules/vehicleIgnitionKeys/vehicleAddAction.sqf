/* 
 * Filename:
 * vehicleAddAction.sqf 
 *
 * Description:
 * Set player's vehicle actions
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

	private ["_a","_b","_c","_d","_vehicle","_position","_enterer"];
	
	_vehicle = _this select 0;
	_position = _this select 1;
	_enterer = _this select 2;
	_a = true; _b = true;_c = true;_d = true;

	if (player != _enterer) exitWith { }; 
	
			// Start monitoring the players position in vehicle
			while { (vehicle player != player) } do 

			{
					switch ((assignedVehicleRole _enterer) select 0) do
						{
						   case "Driver":
							{
										if (_a) then { 
								  		_b = true;_c = true;_d = true;			 	
								  		[_enterer] call FNC_VEHICLE_CODE; 
								  		_a =false;   
										};
							};
						   case "Cargo":
							{
										if (_b) then {
									  	_a = true;_c = true;_d = true;
										  if (CFG_VehicleIgnitionKeys == 1) then {_vehicle removeAction FNC_Vehicle_Keys;};
									  	FNC_Vehicle_Action = -1;_b = false;
										};
							};
							   case "":
							{
										if (_c) then {
									  	_a = true;_b= true;_d = true;
										  if (CFG_VehicleIgnitionKeys == 1) then {_vehicle removeAction FNC_Vehicle_Keys;};
									  	FNC_Vehicle_Action = -1;_c = false;
										};
							};
							   case "Turret":
							{
										if (_d) then {
									  	_d = true;
										  if (CFG_VehicleIgnitionKeys == 1) then {_vehicle removeAction FNC_Vehicle_Keys;};
									  	FNC_Vehicle_Action = -1;_d = false;
										};
							};
						  
						};	
			};
// ====================================================================================