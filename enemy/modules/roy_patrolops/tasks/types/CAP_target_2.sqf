if(count mps_loc_towns < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK CAP_target_2.sqf"];

private["_location","_position","_taskid","_grp","_stance ","_b"];

_location = (mps_loc_towns call mps_getRandomElement);
while {_location == mps_loc_last } do {
    _location = (mps_loc_towns call mps_getRandomElement);
	sleep 0.1;
};
mps_loc_last = _location;

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

_grp = [_position,"TARGET",1,10] call CREATE_OPFOR_SQUAD; sleep 1;
CAPT2_target = (units _grp) select 0;
CAPT2_target setRank "PRIVATE";
CAPT2_target setPos _hideout;

if(_random_scenario > 0) then {
	CAPT2_target setCaptive true;
	removeAllWeapons CAPT2_target;
	[nil, CAPT2_target, "per", rADDACTION, (format ["<t color=""#FF0000"">Arrest %1</t>",name CAPT2_target]),(mps_path+"action\mps_unit_join.sqf"), [], 1, true, true, "", ""] call RE;
};

if(mps_debug) then {
	_marker = createMarkerLocal [format["Debug%1",_taskid],position CAPT2_target];
	_marker setMarkerTypeLocal "mil_dot";
	_marker setMarkerColorLocal "ColorGreen";
};

objective_intel = 0;
objective_marker = [];
objective_location = position CAPT2_target;

objective_intel_KILLED = {
	if(side _this == (SIDE_B select 0) && random 3 < 1) then {
		_this addEventHandler ["Killed",{
			_unit = _this select 0;
			_pos = [(getPos _unit select 0) + 1 - random 2,(getPos _unit select 1) + 1 - random 2,0];
			_ev = (["EvMap","EvMoscow","EvPhoto"] call mps_getRandomElement) createvehicle _pos;
			_ev setPosATL _pos;
			_ev spawn {
				while{!ABORTTASK_PO && alive CAPT2_target && {isPlayer _x && side _x == (SIDE_A select 0)} count nearestObjects[position _this,["All"],3] == 0} do {sleep 2};
				if(!alive CAPT2_target) exitWith {deleteVehicle _this};
				deleteVehicle _this;
				mission_sidechat = "Gained new intel about the targets possible location."; publicVariable "mission_sidechat"; player sideChat mission_sidechat;
				objective_intel = objective_intel + 200;
				_markername = format["objective_int_%1",objective_intel];
				_markeraccuracy = 50 max (2000 - objective_intel);
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
	_grp = [position CAPT2_target,"INF",(5 + random 5),50,_stance ] call CREATE_OPFOR_SQUAD;
	_enemies = _enemies + (units _grp);
};

{
		_loc = position _x;
		_grp = [_loc,"INS",(5 + random 5),50,"patrol"] call CREATE_OPFOR_SQUAD;
		_enemies = _enemies + (units _grp);
		if(random 1 > 0.5) then {
			_car_type = (mps_opfor_car+mps_opfor_apc+mps_opfor_armor) call mps_getRandomElement;
			_vehgrp = [_car_type,(SIDE_B select 0),_loc,100] call mps_spawn_vehicle;
			[_vehgrp,_loc,"patrol"] spawn mps_patrol_init;
			_enemies = _enemies + (units _vehgrp);
		};
	sleep 0.125;
} forEach (nearestLocations [_position,["Name","NameLocal","NameVillage","NameCity","NameCityCapital"],3000]);

[] spawn {
	While{!ABORTTASK_PO && alive CAPT2_target} do {
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

_dirn = "NORTH"; if( (position CAPT2_target) select 1 < (position _location) select 1) then {_dirn = "SOUTH"};
_dire = "EAST"; if( (position CAPT2_target) select 0 < (position _location) select 0) then {_dire = "WEST"};
_distintel = (position CAPT2_target) distance (position _location);

mps_civilian_intel = [
	format["This person has seen the target move into a building at Grid Ref: %1", mapGridPosition (position CAPT2_target)],
	format["This person has seen the target move into a building some %2m from %1",text _location, round _distintel],
	format["This person has seen the target move into a building near %1",text _location],
	format["This person belives the target is in a building %2 of %1",text _location,_dirn],
	format["This person belives the target is in a building %2 of %1",text _location,_dire],
	format["This person belives the target is in a building around %1",text _location],
	format["This person is indicating the target is %2 of %1",text _location,_dirn],
	format["This person is indicating the target is %2 of %1",text  _location,_dire],
	format["This person is indicating the target is near %1",text _location],
	format["This person is afraid of the armed men in %1",text _location],
	format["This person has seen dangerous men in %1",text _location],
	format["This person has seen armed men in %1",text _location],
	"This person belives the target is in a building somewhere",
	"This person belives the target is somewhere",
	"This person has not seen the target"
];
publicVariable "mps_civilian_intel";

[format["TASK%1",_taskid],
	format["Capture %1", name CAPT2_target],
	format["Warrant issued for the arrest of %1, a high profile enemy leader located somewhere in %2. Locate, Arrest and return him to base.<br/><br/>Hostile insurgent and government troops patrolling random towns will be the key. <br/>Gather Intel from the enemies located in towns to narrow down the targets location.", name CAPT2_target,worldname],
	true,
	[],
	"created"
] call mps_tasks_add;

{_x spawn objective_intel_KILLED;} foreach _enemies;

while {!ABORTTASK_PO && alive CAPT2_target && CAPT2_target distance (getMarkerPos format["return_point_%1",(SIDE_A select 0)]) > 10 } do { sleep 5 };

mps_civilian_intel = []; publicVariable "mps_civilian_intel";

if(!ABORTTASK_PO && _random_scenario > 0 && alive CAPT2_target) then {
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
}else{
	if(_random_scenario > 0) then {
		[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
		mps_mission_status = 3;
	}else{
		[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
		mps_mission_status = 2;
	};
};

CAPT2_target action ["eject",vehicle CAPT2_target];
sleep 1;
deleteVehicle CAPT2_target;
{_x setdamage 1} forEach _enemies;
{deleteMarker _x} forEach objective_marker;