#include "\x\cba\addons\main\script_macros_mission.hpp"

// Do Lift
private ["_grp","_droppos","_placeholder","_wp","_request","_Transporter","_destpos", "_obj","_timer","_wait"];

// Function to airlift object from vehicle
_request = _this select 0;
_Transporter = _this select 1;
_destpos = _this select 2;
_obj = _this select 3;

if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: Airlift in progress for %2 at %3 by %4 containing %5", time, typeof _obj, position _obj, _Transporter, _request];};

_grp = group _Transporter;

// Find suitable drop point
_droppos = [_destpos,0,75,4,0,0,0] call BIS_fnc_findSafePos;
_placeholder = "HeliHEmpty" createVehicle _droppos;

if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: Position chosen %2", time, _droppos];};

waitUntil {sleep 5; !(_grp call CBA_fnc_isAlive) || (damage _Transporter > 0.6) || (_Transporter distance _destpos < 275)};
// Tell Helo to hover at pos
deleteWaypoint [_grp,(currentWaypoint _grp)];

_wp = _grp addwaypoint [_droppos, 0];
_Transporter FlyInHeight 10;
_wp setWaypointSpeed "LIMITED";
_wp setWaypointBehaviour "CARELESS";

// If Container, then add items to container using R3F else apply object
If ((typeof _obj == "Misc_Cargo1B_military") || (typeof _obj in tup_logistics_container)) then {
	private "_objectArray";
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
	
} else {
    private ["_id","_name"];
	//// Enable R3F
	_obj setVariable ["R3F_LOG_disabled", false, true];
	
	// Enable PDB saving 
	_id = 1000 + ceil(random(9000));
	_name = format["mso_log_%1",_id];
	_obj setVariable ["pdb_save_name", _name, true];
	
	if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: Obj pdb enabled %2", time, _name];};
};
_timer = time;
_wait = 90;
//// Wait until ground reached
waitUntil {sleep 0.5; (!(_grp call CBA_fnc_isAlive)  || (damage _Transporter > 0.6) || ((getPosATL _obj select 2) < 10) && (_Transporter distance _droppos < 175)) || (time > _timer + _wait) };
deletevehicle _placeholder;

_Transporter setVariable ["R3F_LOG_heliporte", objNull, true];
_obj setVariable ["R3F_LOG_est_transporte_par", objNull, true];

detach _obj;
sleep 0.3;
_obj setPosATL [(getPosATL _obj select 0),(getPosATL _obj select 1),0.1];

deleteWaypoint [_grp,(currentWaypoint _grp)];

_wp = _grp addwaypoint [[0,0,0], 10];
_wp setWaypointSpeed "FULL";
_Transporter flyInHeight 500;
_wp setWaypointBehaviour "CARELESS";

if (debug_mso) then {
	private ["_objm","_name"];
    _name = format["log_%1",random 1000];
	_objm = [_name, position _obj, "Icon", [1,1], "TEXT:", "OBJ", "TYPE:", "Dot", "COLOR:", "ColorBlue", "GLOBAL"] call CBA_fnc_createMarker;
};
	