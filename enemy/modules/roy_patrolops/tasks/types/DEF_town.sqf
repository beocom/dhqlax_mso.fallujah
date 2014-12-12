if(count mps_loc_towns < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK DEF_town.sqf"];

private["_location","_defendpos","_spawnpos","_taskid","_rmin","_rmax","_rplayers","_ra","_rb","_diffresult","_enemyforce"];

_location = (mps_loc_towns call mps_getRandomElement);
while {_location == mps_loc_last } do {
    _location = (mps_loc_towns call mps_getRandomElement);
	sleep 0.1;
};
mps_loc_last = _location;

_enemyforce = [];

_defendpos = [(position _location) select 0,(position _location) select 1, 0];
_defendpos = position ([_defendpos] call mps_getnearestroad);

_spawnpos = [_defendpos,(-20 + random 40),1200] call mps_new_position;
_spawnpos = position ([_spawnpos] call mps_getnearestroad);

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];

for "_i" from 1 to 2 do {
	_stance = ["patrol","standby"] call mps_getRandomElement;
	_grp = [_defendpos,"INS",(4 + random 2),50,_stance] call CREATE_OPFOR_SQUAD;
	_enemyforce = _enemyforce + (units _grp);
};

[ format["TASK%1",_taskid],
	format["Battle for %1", text _location],
	format["%1 is under threat of attack from enemy forces. Secure the town and defend it at all costs.<br/>NOTE: If all friendly forces have vacate the area before completion, the task will fail.", text _location],
	true,
	[format["MARK%1",_taskid],(_defendpos),"defend","ColorBlue"," Defend"],
	"created",
	_defendpos
] call mps_tasks_add;

while{!ABORTTASK_PO && {alive _x && side _x == (SIDE_A select 0)} count nearestObjects[_defendpos,["MAN","LandVehicle","Air"],100] == 0 } do { sleep 5 };

_enemyforce = [];
_b = 2 max (round (random (playersNumber (SIDE_A select 0) / 3)));

for "_i" from 1 to _b do {
	_grp = [_spawnpos,"INS",(4 + random 2),10] call CREATE_OPFOR_SQUAD;
	[_grp,_defendpos,"patrol"] spawn mps_patrol_init;
	_enemyforce = _enemyforce + (units _grp);
	if(random 1 > 0.5) then {
		_car_type = (mps_opfor_car+mps_opfor_apc+mps_opfor_armor) call mps_getRandomElement;
		_vehgrp = [_car_type,(SIDE_B select 0),_spawnpos,100] call mps_spawn_vehicle;
		[_vehgrp,_defendpos,"standby"] spawn mps_patrol_init;
		_enemyforce = _enemyforce + (units _vehgrp);
	};
};

for "_i" from 0 to (round random 1) do {
	_regrp = [_spawnpos,"INF",(8 + random 4),50] call CREATE_OPFOR_SQUAD;
	[_regrp,format["respawn_%1",(SIDE_B select 0)],_defendpos,true] spawn CREATE_OPFOR_PARADROP;
	_enemyforce = _enemyforce + (units _regrp);
};

while{!ABORTTASK_PO && {alive _x && side _x == (SIDE_A select 0)} count nearestObjects[_defendpos,["MAN","LandVehicle","Air"],100] > 0 && {alive _x} count _enemyforce > 3} do { sleep 5 };


if(!ABORTTASK_PO && {alive _x} count _enemyforce < 3 ) then {
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
}else{
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
};
