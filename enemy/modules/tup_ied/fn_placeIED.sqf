// Find suitable spot for IED
// Pass location and booleans to look for roads, objects, entrances
// Returns an array of position s
private ["_addroads","_addobjects","_addentrances","_goodspots","_location","_size"];

_location = _this select 0;
_addroads = _this select 1;
_addobjects = _this select 2;
_addentrances = _this select 3;
_size = _this select 4;

_goodspots = [];

// Look for objects
If (_addobjects) then {
	private ["_spottype"];
	// broken fences, low walls,  garbage, garbage containers, gates, rubble
	_spottype = ["Land_Misc_Rubble_EP1","Land_Misc_Garb_Heap_EP1","Garbage_container","Misc_TyreHeapEP1","Misc_TyreHeap","Garbage_can","Land_bags_EP1","Paleta2","Land_ruin_wall","Land_ruin_wall_EP1","Land_ruin_wall_PMC","Land_ruin_rubble","Land_ruin_rubble_PMC","Land_A_Mosque_big_wall_gate_EP1","Land_Wall_L1_gate_EP1","Land_Wall_Gate_Ind1_L","Land_A_CityGate1_EP1","Land_Wall_CGry_5_D","Land_wall_indvar1_5_d","Land_wall_indfnc_3_d","Land_wall_indcnc_4_d","Land_wall_fenw_7_d","MAP_Wall_Stone"]; 
	{
		_goodspots set [count _goodspots, getposATL  _x];
	} foreach nearestobjects [_location,_spottype,_size];
};

// Look for building entrances
If (_addentrances) then {
	// Get first building postion (entrance) for each building within range
	{
		_goodspots set [count _goodspots, getposATL  _x];
	} foreach (nearestobjects [_location ,["House"],_size]);
};

// Look for roads
If (_addroads) then {
	// Get raods within range
	{
		_goodspots set [count _goodspots, getposATL  _x];
	} foreach (_location nearRoads _size);
};

_goodspots
