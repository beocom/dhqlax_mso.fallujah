#include "\x\cba\addons\main\script_macros_mission.hpp"

// Function to para drop object from vehicle
private ["_Transporter","_request"];
_request = _this select 0;
_Transporter = _this select 1;

//// Animate ramp
sleep 1;
_Transporter animate ["ramp_top", 1];
_Transporter animate ["ramp_bottom", 1];

//// Detach object (drop)
sleep 1;

{
	private ["_obj","_Parachute","_Marker","_markertype"];
	_obj = _x createvehicle (position _Transporter);
	_obj attachTo [_Transporter,[0,-21,0]];
	sleep 0.1;
	deTach _obj;
	_obj setPos [(getPos _obj select 0),(getPos _obj select 1),(getPos _obj select 2)-6];

	//// Create parachute and smoke
	sleep 1;
	_Parachute = "ParachuteBigWest" createVehicle position _obj;
	_Parachute setPos (getPos _obj);
	if ((daytime < 17) && (daytime > 7)) then {
		_markertype = "SmokeShellBlue";
	} else {
		_markertype = "NVG_TargetC";
	};

	_Marker =  _markertype createVehicle position _obj;
	_Marker setPosATL (getPosATL _obj);
	_Marker attachTo [_obj,[0,0,1]];
	
	_obj attachTo [_Parachute,[0,0,-1.5]];
	
	if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: Dropping %2 at %3", time, typeof _obj, position _obj];};
	
	[_obj,_Parachute, _Marker] spawn {
		private ["_name","_obj","_id","_Parachute","_Marker"];
		
		_obj = _this select 0;
		_Parachute = _this select 1;
		_Marker = _this select 2;
		
		//// Wait until ground reached
		waitUntil {sleep 2; (getPosATL _obj select 2) < 4};
		detach _obj;
		detach _Marker;
		sleep 0.3;
		_obj setPosATL [(getPosATL _obj select 0),(getPosATL _obj select 1),0.1];
		_Marker setPosATL [(getPosATL _obj select 0) + 1,(getPosATL _obj select 1) + 1,0.1];
		
		//// Enable R3F
		_obj setVariable ["R3F_LOG_disabled", false];
		
		// Enable PDB saving 
		_id = 1000 + ceil(random(9000));
		_name = format["mso_log_%1",_id];
		_obj setVariable ["pdb_save_name", _name, true];
		
		//diag_log format["%1 position = %2", typeof _obj, getposATL _obj];
		
		if (debug_mso) then {
			private ["_objm"];
			_objm = [_name, position _obj, "Icon", [1,1], "TEXT:", "OBJ", "TYPE:", "Dot", "COLOR:", "ColorBlue", "GLOBAL"] call CBA_fnc_createMarker;
		};
		
		//// Delete parachute and smoke
		sleep 500;
		deleteVehicle _Marker;
		deleteVehicle _Parachute;
	};
} foreach _request;
	
//// Animate ramp again
sleep 1;
_Transporter animate ["ramp_top", 0];
_Transporter animate ["ramp_bottom", 0];	