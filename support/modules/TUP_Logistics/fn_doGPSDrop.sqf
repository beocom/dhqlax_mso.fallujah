#include "\x\cba\addons\main\script_macros_mission.hpp"

// Function to GPS para drop object from vehicle
private ["_Transporter","_request","_obj","_Parachute","_Marker","_markertype","_objectArray","_pos","_pilot","_wp"];
_request = _this select 0;
_Transporter = _this select 1;
_pos = _this select 2;
_obj = _this select 3;

_objectArray = [];
{
	private ["_itemObj","_id","_name"];
	_itemObj = _x createVehicle [random 100, random 100,0];
	//// Enable R3F
	_itemObj setVariable ["R3F_LOG_disabled", false];
	
	// Enable PDB saving 
	_id = 1000 + ceil(random(9000));
	_name = format["mso_log_%1",_id];
	_itemObj setVariable ["pdb_save_name", _name, true];
	
	_objectArray set [count _objectArray, _itemObj];
} foreach _request;

if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: Objects Created %2", time, _objectArray];};

// Load items into container (hope they fit!) using R3F
[_obj,_objectArray] call logistics_fnc_addItemsR3F;

//// Animate ramp
sleep 1;
_Transporter animate ["ramp_top", 1];
_Transporter animate ["ramp_bottom", 1];

//// Detach object (drop)
sleep 1;

_obj attachTo [_Transporter,[0,-21,0]];
sleep 0.1;
deTach _obj;
_obj setPos [(_pos select 0),(_pos select 1),(getPos _obj select 2)-6];

//// Create parachute and smoke
sleep 1;
_pilot = (group _Transporter) createUnit ["BAF_Pilot_MTP", _pos, [], 0, "CAN_COLLIDE"];
[_pilot] join grpNull;
_pilot allowDamage false;

_Parachute = createVehicle ["BIS_Steerable_Parachute", position _obj,[],0,"CAN_COLLIDE"];
[_Parachute] join grpNull;
_Parachute setPos (getPos _obj);

_pilot moveInGunner _Parachute;

// Move, go to waypoint
_pilot move [_pos select 0, _pos select 1];
_Parachute doMove (_pos); // needed?
_wp = group _pilot addwaypoint [_pos, 0];

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

[_obj,_Parachute, _Marker, _pos] spawn {
	private ["_name","_obj","_Parachute","_Marker","_pos"];
	
	_obj = _this select 0;
	_Parachute = _this select 1;
	_Marker = _this select 2;
	_pos = _this select 3;
		
	waitUntil {sleep 2; ((getPosATL _obj select 2) < 15) || !(_Parachute call CBA_fnc_isAlive) };
	
	deleteVehicle (gunner _Parachute);
		
	waitUntil {sleep 0.5; ((getPosATL _obj select 2) < 3) || !(_Parachute call CBA_fnc_isAlive) };
	
	//// Wait until ground reached
	deleteVehicle _Parachute;
	detach _obj;
	_obj setVelocity [0, 0, 0];
	detach _Marker;
	sleep 0.3;
	_obj setPosATL [(getPosATL _obj select 0),(getPosATL _obj select 1),0.1];
	_Marker setPosATL [(getPosATL _obj select 0) + 1,(getPosATL _obj select 1) + 1,0.1];
	_Marker =  _markertype createVehicle position _Marker;
	
	//// Enable R3F on container
	_obj setVariable ["R3F_LOG_disabled", false, true];
	
	if (debug_mso) then {
		private ["_objm"];
        _name = format ["obj_", random 100]; 
		_objm = [_name, position _obj, "Icon", [1,1], "TEXT:", "OBJ", "TYPE:", "Dot", "COLOR:", "ColorBlue", "GLOBAL"] call CBA_fnc_createMarker;
	};
	
	//// Delete parachute and smoke
	sleep 500;
	deleteVehicle _Marker;
};

	
//// Animate ramp again
sleep 1;
_Transporter animate ["ramp_top", 0];
_Transporter animate ["ramp_bottom", 0];	