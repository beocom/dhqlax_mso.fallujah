if(count mps_loc_towns < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK SAD_cache_2.sqf"];

private["_location","_position","_taskid","_grp","_stance ","_b"];

_location = (mps_loc_towns call mps_getRandomElement);
while {_location == mps_loc_last } do {
    _location = (mps_loc_towns call mps_getRandomElement);
	sleep 0.1;
};

_position = [(position _location) select 0,(position _location) select 1, 0];
_position = [_position,10,0.1,2] call mps_getFlatArea;
_houses = [_position,1000] call mps_getEnterableHouses;

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];
_b = 2 max (round (random (playersNumber (SIDE_A select 0) / 3)));
_random_scenario = round random 1;

_house = [];
_hideout = [];
_enemies = [];

for "_i" from 1 to 10000 do {
	_house = _houses call mps_getRandomElement;
	_buildingpos = round random (_house select 1);
	_house = (_house select 0);
	_hideout = (_house buildingPos _buildingpos);
	if(count (_hideout - [0]) > 0) exitWith{};
};

_cachetype = "RUSpecialWeaponsBox";
if(mps_oa) then {_cachetype = "GuerillaCacheBox_EP1"};

TARGET_CACHE = _cachetype createVehicle _position;
TARGET_CACHE setPos _hideout;
[TARGET_CACHE] spawn mps_object_c4only;

if(mps_debug) then {
	_marker = createMarkerLocal [format["Debug%1",_taskid],position TARGET_CACHE];
	_marker setMarkerTypeLocal "mil_dot";
	_marker setMarkerColorLocal "ColorGreen";
};

objective_intel = 0;
objective_marker = [];
objective_location = position TARGET_CACHE;

objective_intel_KILLED = {
	if(side _this == (SIDE_B select 0) && random 3 < 1) then {
		_this addEventHandler ["Killed",{
			_unit = _this select 0;
			_pos = [(getPos _unit select 0) + 1 - random 2,(getPos _unit select 1) + 1 - random 2,0];
			_ev = (["EvMap","EvMoscow","EvPhoto"] call mps_getRandomElement) createvehicle _pos;
			_ev setPosATL _pos;
			_ev spawn {
				while{!ABORTTASK_PO && alive TARGET_CACHE && {isPlayer _x && side _x == (SIDE_A select 0)} count nearestObjects[position _this,["All"],3] == 0} do {sleep 2};
				if(!alive TARGET_CACHE) exitWith {deleteVehicle _this};
				deleteVehicle _this;
				mission_sidechat = "Gained new intel about the caches possible location."; publicVariable "mission_sidechat"; player sideChat mission_sidechat;
				objective_intel = objective_intel + 150;
				_markername = format["objective_int_%1",objective_intel];
				_markeraccuracy = 50 max (1500 - objective_intel);
				_markerpos = [objective_location,random 360,random _markeraccuracy,false,2] call mps_new_position;
				_marker = createMarker [_markername,_markerpos];
				_marker setMarkerType "hd_unknown";
				_marker setMarkerSize [0.75,0.75];
				_marker setMarkerText format["%1m",_markeraccuracy];
				objective_marker set [count objective_marker, _markername]; publicVariable "objective_marker";
			};
		}];
	};
};

for "_i" from 1 to 2 do {
	_stance = ["patrol","standby","hide"] call mps_getRandomElement;
	_grp = [_position,"INF",(5 + random 5),50,_stance ] call CREATE_OPFOR_SQUAD;
	_enemies = _enemies + (units _grp);
};

{
		_loc = position _x;
		_grp = [_loc,"INS",(5 + random 5),50,"patrol"] call CREATE_OPFOR_SQUAD;
		_enemies = _enemies + (units _grp);
		if(random 1 > 0.5) then {
			_car_type = (mps_opfor_car+mps_opfor_apc) call mps_getRandomElement;
			_vehgrp = [_car_type,(SIDE_B select 0),_loc,100] call mps_spawn_vehicle;
			[_vehgrp,_loc,"patrol"] spawn mps_patrol_init;
			_enemies = _enemies + (units _vehgrp);
		};
	sleep 0.125;
} forEach (nearestLocations [_position,["Name","NameLocal","NameVillage","NameCity","NameCityCapital"],3000]);

[] spawn {
	While{!ABORTTASK_PO && alive TARGET_CACHE} do {
		{
			_xmarkerposition = getMarkerPos _x;
			_xmarkercolor = getMarkerColor _x;
			_xmarkerType = getMarkerType _x;
			_xmarkertext = markerText _x;
			objective_marker = objective_marker - [_x];
			deleteMarker _x;
			_xmarker = createMarker [format["INTEL_%1",random 99999],_xmarkerposition];
			_xmarker setMarkerType _xmarkerType;
			_xmarker setMarkerSize [0.75,0.75];
			_xmarker setMarkerColor _xmarkercolor;
			_xmarker setMarkerText _xmarkertext;
			objective_marker set [count objective_marker, _xmarker];
		} forEach objective_marker;
		sleep 30;
	};
};

mps_civilian_intel = [
	format["This person has seen a cache being moved into a building at Grid Ref: %1", mapGridPosition (position TARGET_CACHE)],
	format["This person has seen dangerous men in towns around %1",text _location],
	format["This person has seen armed men in towns around %1",text _location],
	format["This person spotted weapons trucks moving to %1",text _location],
	format["This person is afraid of the armed men in %1",text _location],
	format["This person has seen dangerous men in %1",text _location],
	"This person belives the cache is in a building somewhere",
	"This person belives the cache is somewhere",
	"This person has not seen any caches",
	"This person belives the cache is in a building somewhere",
	"This person belives the cache is somewhere",
	"This person has not seen any caches",
	"This person belives the cache is in a building somewhere",
	"This person belives the cache is somewhere",
	"This person has not seen any caches"
];
publicVariable "mps_civilian_intel";

[format["TASK%1",_taskid],
	"Search and Destroy Weapons Cache",
	format["Enemy have taken delivery of a large weapons cache and stored it in a town somewhere in %1. Locate and Destroy the weapons cache using C4.<br/><br/>Hostile insurgent and government troops patrolling random towns will be the key. <br/>Gather Intel from the enemies located in towns to narrow down the cache location.",worldname],
	true,
	[],
	"created"
] call mps_tasks_add;

{_x spawn objective_intel_KILLED;} foreach _enemies;

while {!ABORTTASK_PO && damage TARGET_CACHE < 1 } do { sleep 5 };

mps_civilian_intel = []; publicVariable "mps_civilian_intel";

if(!ABORTTASK_PO && damage TARGET_CACHE >= 1) then {
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
}else{
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
};

sleep 1;
deleteVehicle TARGET_CACHE;
{_x setdamage 1} forEach _enemies;
{deleteMarker _x} forEach objective_marker;