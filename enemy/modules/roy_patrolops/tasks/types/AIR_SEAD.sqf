if(count mps_loc_towns < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK AIR_SEAD.sqf"];

private["_location","_position","_taskid","_object","_grp","_stance ","_b","_camptype","_troops"];

while { _location = (mps_loc_towns call mps_getRandomElement); _location == mps_loc_last } do {
	sleep 0.1;
};
mps_loc_last = _location;

_markerpos = [(position _location) select 0,(position _location) select 1, 0];
_position = [[(position _location) select 0,(position _location) select 1, 0],900,0.1,2] call mps_getFlatArea;

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];
_b = (2 max (round (random (playersNumber (SIDE_A select 0) / 4)))) * MISSIONDIFF;
_troops = [];

_camptype = "RadarSite1_RU";
if(mps_oa) then {_camptype = "RadarSite1_TK_EP1";};

_newComp = [_position,random 360,_camptype] call BIS_fnc_dyno;

_radartower = nearestObjects[_position,["76n6ClamShell","76n6ClamShell_EP1","BASE_WarfareBAntiAirRadar"],100];
_radartower spawn mps_object_aironly;

for "_i" from 1 to _b do {
	_grp = [_position,"AA",(2 + random 2),250,"patrol"] call CREATE_OPFOR_SQUAD;
	if(random 1 > 0.3) then {
		_car_type = (mps_opfor_mobiaa) call mps_getRandomElement; 
		_vehgrp = [_car_type,(SIDE_B select 0),_position,100] call mps_spawn_vehicle;
		(units _vehgrp) joinSilent _grp;
	};
	_troops = _troops + (units _grp);
};

[ format["TASK%1",_taskid],
	"Destroy Enemy Air Defenses",
	format["Hostile Forces have constructed an Anti-Air Radar near %1. Destroy it to prevent the interception of BLUFOR air assets. Avoid civilian casualties or collateral damage.", text _location],
	true,
	[format["MARK%1",_taskid],(_markerpos),"hd_objective","ColorRedAlpha"," Radar Signal Detected"],
	"created",
	_position
] call mps_tasks_add;

while {!ABORTTASK_AIR && {damage _x < 1} count _radartower > 0 } do { sleep 5 };

if(!ABORTTASK_AIR) then {
	PAPABEAR sideChat format ["%1 this is PAPA BEAR. Target Destroyed! RTB. Over.", group player];
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
}else{
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
};

[_troops] spawn {
	sleep 60;
	{ _x setDamage 1}forEach (_this select 0);
};
