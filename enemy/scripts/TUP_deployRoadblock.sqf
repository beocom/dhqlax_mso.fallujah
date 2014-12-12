/*
 =======================================================================================================================
Script: TUP_deployRoadBlock.sqf v1.0
Author(s): Tupolov
		Thanks to Evaider for roadblock layout
		
Description:
Group will setup a roadblock on the nearest road within 500m and man it

Parameter(s):
_this select 0: group (Group)
_this select 1: defense position (Array)
    
Returns:
Boolean - success flag

Example(s):
null = [group this,(getPos this)] execVM "TUP_deployRoadBlock.sqf"

-----------------------------------------------------------------------------------------------------------------------
Notes:

Type of roadblock will be based on faction.
Roadblock will be deployed on nearest road to the position facing along the road
Group will man static weaponary

to do: Current issue if road ahead bends.
	 Change roadblock based on faction
	 
=======================================================================================================================
*/

private ["_grp","_pos","_roadpos","_vehicle","_vehtype","_blockers","_roads","_fac","_debug"];

if(isNil "rmm_ep_spawn_dist")then{rmm_ep_spawn_dist = 2000;};

_debug = debug_mso;

_grp = _this select 0;
_pos = _this select 1;

fPlayersInside = {
        private["_pos","_dist"];
        _pos = _this select 0;
        _dist = _this select 1;
        ({_pos distance _x < _dist} count ([] call BIS_fnc_listPlayers) > 0);
};

_fac = faction leader _grp;
if (_fac == "BIS_TK_CIV" || _fac == "BIS_CIV_special") then {_fac = "BIS_TK_INS";};
if (_fac == "CIV" ) then {_fac = "GUE";};
if (_fac == "CIV_RU") then {_fac = "INS";};

// Find nearest road
_roads = _pos nearRoads 500;
while {_roadpos = _roads call BIS_fnc_selectRandom; _roads = _roads - [_roadpos]; count (nearestobjects [getpos _roadpos, ["House"], 60]) > 0} do {
	if (count _roads == 1) exitWith {_roadpos = _roads select 0};
};
if (_debug) then {
	private "_id";
	_id = floor (random 1000);
	diag_log format["Position of Road Block is %1", getpos _roadpos];
	[format["roadblock_%1", _id], _roadpos, "Icon", [1,1], "TYPE:", "Dot", "TEXT:", "RoadBlock",  "GLOBAL", "PERSIST"] call CBA_fnc_createMarker;
};

// Define [ Gate, Blocks, Barriers, Guides, Nest, Wire, Weapon] for each faction

_list = switch (_fac) do {
	// RU
	case "RU": {["ZavoraAnim","Land_CncBlock","RoadBarrier_long","Land_arrows_desk_L","Land_arrows_desk_R","Land_fortified_nest_small","Fort_RazorWire","M2StaticMG"]};
	// ACE_RU
    case "ACE_RU": {["ZavoraAnim","Land_CncBlock","RoadBarrier_long","Land_arrows_desk_L","Land_arrows_desk_R","Land_fortified_nest_small","Fort_RazorWire","M2StaticMG"]};
	// GUE
	case "GUE": {["","Sign_Checkpoint","RoadBarrier_long","RoadCone","RoadCone","Land_BagFenceLong","RoadBarrier_light","SearchLight"]};
	// INS
	case "INS": {["","Sign_Checkpoint","RoadBarrier_long","RoadCone","RoadCone","Land_BagFenceLong","RoadBarrier_light","SearchLight"]};
	// BIS_TK
	case "BIS_TK": {["ZavoraAnim","Land_CncBlock","RoadBarrier_long","Land_arrows_desk_L","Land_arrows_desk_R","Land_fortified_nest_small","Fort_RazorWire","M2StaticMG"]};
	// BIS_TK_INS
	case "BIS_TK_INS": {["","Sign_Checkpoint_TK_EP1","RoadBarrier_long","Land_Pneu","Land_Pneu","","Misc_TyreHeapEP1","SearchLight_TK_INS_EP1"]};
	// Default
	default {["ZavoraAnim","Land_CncBlock","RoadBarrier_long","Land_arrows_desk_L","Land_arrows_desk_R","Land_fortified_nest_small","Fort_RazorWire","M2StaticMG"]};
};

// Ideally Workout angle (away from unit) of roadblock?

// Place Gate
if !(_list select 0 == "") then {
	_bg1 = _list select 0 createVehicle (_roadpos modelToWorld [0,7,0]);
	_bg1 setDir ((direction _roadpos) -360);
};

// Place Blocking Element (concrete, tyres etc)
if !(_list select 1 == "") then {
	_cb1 = _list select 1 createVehicle (_roadpos modelToWorld [5,6,0]);
	_cb1 setDir ((direction _roadpos) -360);
	_cb2 = _list select 1  createVehicle (_roadpos modelToWorld [10,6,0]);
	_cb2 setDir ((direction _roadpos) -360);
	_cb3 = _list select 1  createVehicle (_roadpos modelToWorld [-5,6,0]);
	_cb3 setDir ((direction _roadpos) -360);
	_cb4 = _list select 1 createVehicle (_roadpos modelToWorld [-10,6,0]);
	_cb4 setDir ((direction _roadpos) -360);
};

// Place Road Barriers
if !(_list select 2 == "") then {
	_rb1 = _list select 2 createVehicle (_roadpos modelToWorld [5,5,0]);
	_rb1 setDir ((direction _roadpos) -360);
	_rb2 = _list select 2 createVehicle (_roadpos modelToWorld [10,5,0]);
	_rb2 setDir ((direction _roadpos) -360);
	_rb3 = _list select 2 createVehicle (_roadpos modelToWorld [-5,5,0]);
	_rb3 setDir ((direction _roadpos) -360);
	_rb4 = _list select 2 createVehicle (_roadpos modelToWorld [-10,5,0]);
	_rb4 setDir ((direction _roadpos) -360);
};

// Place Guides

if !(_list select 3 == "") then {
	_s1 = _list select 3 createVehicle (_roadpos2 modelToWorld [-4,0,0]);
	_s1 setDir ((direction _roadpos) -90);
	_s2 = _list select 3 createVehicle (_roadpos modelToWorld [-4,4,0]);
	_s2 setDir ((direction _roadpos) -90);
	_s3 = _list select 4 createVehicle (_roadpos modelToWorld [3,4,0]);
	_s3 setDir ((direction _roadpos) -270);
	_s4 = _list select 4 createVehicle (_roadpos modelToWorld [3,0,0]);
	_s4 setDir ((direction _roadpos) -270);
	_s5 = _list select 4 createVehicle (_roadpos modelToWorld [3,-4,0]);
	_s5 setDir ((direction _roadpos) -270);
	_s6 = _list select 4 createVehicle (_roadpos modelToWorld [0,-7,0]);
	_s6 setDir ((direction _roadpos) -180);
};

// Place Fortification

if !(_list select 5 == "") then {
	_b1 = _list select 5 createVehicle (_roadpos modelToWorld [10,-6,0]);
	_b1 setDir ((direction _roadpos) -180);
	_b2 = _list select 5 createVehicle (_roadpos modelToWorld [-10,-6,0]);
	_b2 setDir ((direction _roadpos) -180);
};

// Place Wire

if !(_list select 6 == "") then {
	_rw1 = _list select 6 createVehicle (_roadpos modelToWorld [10,8,0]);
	_rw1 setDir ((direction _roadpos) -360);
	_rw2 = _list select 6 createVehicle (_roadpos modelToWorld [-10,8,0]);
	_rw2 setDir ((direction _roadpos) -360);
};

// Place Weapon

if !(_list select 7 == "") then {
	_sg1 = _list select 7 createVehicle (_roadpos modelToWorld [10,-7,0]);
	_sg1 setDir ((direction _roadpos) -360);
	_sg2 = _list select 7 createVehicle (_roadpos modelToWorld [-10,-7,0]);
	_sg2 setDir ((direction _roadpos) -360);
};

// Place a vehicle
_vehtype = ([2, _fac, "Car"] call mso_core_fnc_findVehicleType) call BIS_fnc_selectRandom;
_vehicle = _vehtype createVehicle (_roadpos modelToWorld [0,-13,0]);
_vehicle setDir getdir _roadpos;
_vehicle setposATL (getposATL _vehicle);

// Spawn group and get them to defend
[_vehicle, _roadpos, _fac] spawn {
	private["_roadpos","_fac","_vehicle"];
	_roadpos = _this select 0;
	_vehicle = _this select 1;
	_fac = _this select 2;
	waitUntil{sleep 10; ([_roadpos, rmm_ep_spawn_dist] call fPlayersInside)};
	// Spawn group and get them to defend
	_blockers = [getpos _roadpos, "infantry", _fac] call mso_core_fnc_randomGroup;
	_blockers addVehicle _vehicle;
	sleep 1;
	[_blockers, getpos _roadpos] call HH_fnc_taskDefend;
};
_roadposition = [getpos _roadpos select 0, getpos _roadpos select 1, 0];
_roadposition;
