if(count mps_loc_towns < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK AIR_strike.sqf"];

private["_location","_position","_taskid","_object","_vehtype","_target1","_cfg","_compositions"];

_location = (mps_loc_towns call mps_getRandomElement);
while { _location == mps_loc_last } do {
	_location = (mps_loc_towns call mps_getRandomElement);
	sleep 1;
};
mps_loc_last = _location;

_position = [(position _location) select 0,(position _location) select 1, 0];
_position = [_position,500,0.1,2] call mps_getFlatArea;

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];
_troops = [];

// Add composition and find warfare targets
_compositions = [];
_cfg =(configFile >> "CfgObjectCompositions");
_count = count _cfg;

_faction = switch(PO2_EFACTION) do {
			case "BIS_TK": {
				"tk_army";
			};
			case "BIS_TK_GUE": {
				"tk_militia";
			};
			case "RU": {
				"ru";
			};
			case "cwr2_ru": {
				"ru";
			};
            case "cwr2_fia": {
				"ins";
			};
            case "tigerianne": {
				"tk_local";
			};
};

for [{_i = 0}, {_i < _count}, {_i = _i + 1}] do {
	_cfgiTags = getArray (_cfg select _i >> "tags");
	_cfgiName = configName (_cfg select _i);
	if (_faction in _cfgiTags) then { _compositions set [count _compositions, _cfgiName];};
};

_camptype = _compositions call BIS_fnc_selectRandom;
_newComp = [_position,random 360, _camptype] call BIS_fnc_dyno;

// Find Warfare Building as target
_targets = nearestObjects[_position,["WarfareBBaseStructure"],100]; 

if (count _targets == 0) then {
	// Select random WarfareBuilding
	_targetex = count(configFile >> "CfgVehicles");
	for "_y" from 1 to _targetex - 1 do {
		_vehx = (configFile >> "CfgVehicles") select _y;
		_cx = configName _vehx;
		if (_cx iskindof "WarfareBBaseStructure") then {
			_fx = getText(_vehx >> "faction");
			if (_fx == PO2_EFACTION) then {
				_targets set [count _targets, _cx];
			};
		};
	};
};

_grp = createGroup east;
_target1 = ([_position,random 320,_targets call BIS_fnc_selectRandom,_grp] call BIS_fnc_spawnVehicle) select 0;
diag_log format ["Target = %1", typeof _target1];
_target1 spawn mps_object_aironly;
_vehtype1 = getText (configFile >> "CfgVehicles" >> typeof _target1  >> "displayName");

// Setup EN Camp team
_grp = [_position,"INF",(5 + random 5),50] call CREATE_OPFOR_SQUAD;
(_grp addWaypoint [_position,20]) setWaypointType "HOLD";
_grp setFormation "DIAMOND";

// Set EN AA teams
_b = (2 max (round (random (playersNumber (SIDE_A select 0) / 4)))) * MISSIONDIFF;

for "_i" from 1 to _b do {
	if (random 1 > 0.5) then {
		_grp = [_position,"AA",(2 + random 3),150,"patrol"] call CREATE_OPFOR_SQUAD;
		if(random 1 > 0.8) then {
			_car_type = (mps_opfor_car+mps_opfor_apc) call mps_getRandomElement;
			_vehgrp = [_car_type,(SIDE_B select 0),_position,100] call mps_spawn_vehicle;
			(units _vehgrp) joinSilent _grp;
		};
		_troops = _troops + (units _grp);
	};
};

[format["TASK%1",_taskid],
	format["Air Strike! Destroy %1 near %2", _vehtype1, text _location],
	format["Enemy have a %1 near %2. Destroy this target using air assets.", _vehtype1, text _location],
	true,
	[format["MARK%1",_taskid],(position _location),"hd_objective","ColorRedAlpha"," Target"],
	"created",
	_position
] call mps_tasks_add;

while {!ABORTTASK_AIR && ({damage _x < 1} count nearestObjects[_position,[typeof _target1],80] > 0) } do { sleep 5 };

if(!ABORTTASK_AIR) then {
PAPABEAR sideChat format ["%1 this is PAPA BEAR. Target Destroyed! RTB. Over.", group player];
[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
mps_mission_status = 2;
} else {
   	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3; 
};

[_troops] spawn {
	sleep 60;
	{ _x setDamage 1}forEach (_this select 0);
};