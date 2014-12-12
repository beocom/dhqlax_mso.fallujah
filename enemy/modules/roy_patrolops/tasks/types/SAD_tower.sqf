if(count mps_loc_hills < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK SAD_tower.sqf"];

private["_location","_position","_taskid","_tower","_guards"];

_location = (mps_loc_hills call mps_getRandomElement);

while {_location == mps_loc_last} do {
    _location = (mps_loc_hills call mps_getRandomElement);
	sleep 0.1;
};

mps_loc_last = _location;

_position = [(position _location) select 0,(position _location) select 1, 0];
_position = [_position,8,0.1,2] call mps_getFlatArea;

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];
_troops = [];

_tower = "Land_Vysilac_FM" createVehicle _position;
[_tower] spawn mps_object_c4only;

_guards = nil;

while {isNil "_guards"} do {
     _guards = [_position, "Infantry", MSO_FACTIONS] call mso_core_fnc_randomGroup;
};
[_guards] call BIN_fnc_taskDefend;
_troops = _troops + (units _guards);

_grp = [_position,"INS",(3 + random 3),50] call CREATE_OPFOR_SQUAD;
(_grp addWaypoint [_position,20]) setWaypointType "HOLD";
_grp setFormation "DIAMOND";

_b = (2 max (round (random (playersNumber (SIDE_A select 0) / 4)))) * MISSIONDIFF;

for "_i" from 1 to _b do {
	_grp = [_position,"INS",(5 + random 5),50,"patrol"] call CREATE_OPFOR_SQUAD;
	if(random 1 > 0.5) then {
		_car_type = (mps_opfor_car+mps_opfor_apc) call mps_getRandomElement;
		_vehgrp = [_car_type,(SIDE_B select 0),_position,100] call mps_spawn_vehicle;
		(units _vehgrp) joinSilent _grp;
	};
	_troops = _troops + (units _grp);
};

mps_civilian_intel = []; publicVariable "mps_civilian_intel";

[format["TASK%1",_taskid],
	format["Destroy Comms Tower %1", text _location],
	format["Enemy have deployed a communications tower. Disable their transmission ability to hinder their co-ordination.", text _location],
	true,
	[format["MARK%1",_taskid],(_position),"hd_objective","ColorRedAlpha"," Tower"],
	"created",
	_position
] call mps_tasks_add;

while {!ABORTTASK_PO && {damage _x < 1} count nearestObjects[_position,["Land_Vysilac_FM"],80] > 0 } do { sleep 5 };

if(!ABORTTASK_PO) then {
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