if(count mps_loc_towns < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK AIR_CAP.sqf"];

private["_location","_defendpos","_spawnpos","_taskid","_rmin","_rmax","_rplayers","_ra","_rb","_diffresult","_enemyforce"];

while { _location = (mps_loc_towns call mps_getRandomElement); _location == mps_loc_last } do {
	sleep 0.1;
};
mps_loc_last = _location;
_enemyforce = [];

_defendpos = [(position _location) select 0,(position _location) select 1, 0];

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];

// Setup AA team within 2km of location
_spawnpos = [_defendpos,(-20 + random 40),2000] call mps_new_position;
if (random 1 > 0.5) then {
	_stance = ["patrol","standby"] call mps_getRandomElement;
	_grp = [_spawnpos,"AA",(2 + random 2),50,_stance] call CREATE_OPFOR_SQUAD;
	if(random 1 > 0.8) then {
		_car_type = (mps_opfor_mobiaa) call mps_getRandomElement;
		_vehgrp = [_car_type,(SIDE_B select 0),_spawnpos,100] call mps_spawn_vehicle;
		[_vehgrp,_defendpos,"standby"] spawn mps_patrol_init;
	};
};

[ format["TASK%1",_taskid],
	format["Combat Air Patrol over %1", text _location],
	format["Enemy air assets are expected over %1. Fly to %1 and conduct a Combat Air Patrol eliminating any enemy aircraft. <br/>NOTE: HQ will notify you of any inbound threats and when the CAP is complete. Be aware of enemy AA. Stay within 10km of location or task will fail.", text _location],
	true,
	[format["MARK%1",_taskid],(_defendpos),"defend","ColorBlue"," Combat Air Patrol"],
	"created",
	_defendpos
] call mps_tasks_add;

while{!ABORTTASK_AIR && {alive _x && side _x == (SIDE_A select 0) && isPlayer _x} count nearestObjects[_defendpos,["Air"],1000] == 0 } do { sleep 5 };
PAPABEAR sideChat format ["%1 this is PAPA BEAR. You are now on station, you have 30 minutes of playtime. Good luck.", group player];
_timer = time + 3600;

_enemyforce = [];
_b = 2 max (({alive _x && side _x == (SIDE_A select 0) && isPlayer _x} count nearestObjects[_defendpos,["Air"],2000]) * MISSIONDIFF);

while {time < _timer && !ABORTTASK_AIR && ({(alive _x) && (side _x == (SIDE_A select 0)) && (isPlayer _x)} count nearestObjects[_defendpos,["Air"],10000] > 0)} do {
	sleep (random 30)+30;

	_grp = [_spawnpos,"Air"] call mso_core_fnc_randomGroup;
	(_grp addWaypoint [_defendpos,500]) setWaypointType "SAD";
	{
		vehicle _x flyinheight 1000;
	} foreach units _grp;
	_enemyforce = _enemyforce + (units _grp);
	PAPABEAR sideChat format ["%1 this is PAPA BEAR. Bogeys inbound at 2km. Looks like a flight of %2. Angels 1. Watch your six.", group player, typeof vehicle leader _grp];
	while{!ABORTTASK_AIR && ({(alive _x) && (side _x == (SIDE_A select 0)) && (isPlayer _x)} count nearestObjects[_defendpos,["Air"],10000] > 0) && (time < _timer) && ({alive _x} count _enemyforce > 0)} do {
		sleep 30; 
	};
};

if(!ABORTTASK_AIR && {alive _x} count _enemyforce < 1 && _timer < time ) then {
	PAPABEAR sideChat format ["%1 this is PAPA BEAR. Combat Air Patrol is complete, RTB.", group player];
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
}else{
	PAPABEAR sideChat format ["%1 this is PAPA BEAR. Combat Air Patrol failed.", group player];
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
};
