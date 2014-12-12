if(count mps_loc_towns < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK AIR_scud.sqf"];

private["_location","_position","_taskid","_object","_vehtype","_target1"];

while { _location = (mps_loc_towns call mps_getRandomElement); _location == mps_loc_last } do {
	sleep 0.1;
};
mps_loc_last = _location;

_markerpos = [(position _location) select 0,(position _location) select 1, 0];
_position = [(position _location) select 0,(position _location) select 1, 0];
_position = [_position,500,0.1,2] call mps_getFlatArea;

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];

_vehtype = "GRAD_RU";
if(mps_oa) then {_vehtype = "MAZ_543_SCUD_TK_EP1"};

_grp = createGroup east;
_target1 = ([_position,random 320,_vehtype,_grp] call BIS_fnc_spawnVehicle) select 0;
_target2 = ([_position,random 320,_vehtype,_grp] call BIS_fnc_spawnVehicle) select 0; 

[_target1,_target2] spawn mps_object_aironly;

_vehtype = getText (configFile >> "CfgVehicles" >> typeof _target1  >> "displayName");

_troops = [];
_b = (2 max (round (random (playersNumber (SIDE_A select 0) / 3)))) * MISSIONDIFF;
for "_i" from 1 to _b do {
	_grp = [_position,"AA",(2 + random 5),100,"patrol"] call CREATE_OPFOR_SQUAD;
	if(random 1 > 0.5) then {
		_car_type = (mps_opfor_car+mps_opfor_apc+mps_opfor_armor) call mps_getRandomElement;
		_vehgrp = [_car_type,(SIDE_B select 0),_position,100] call mps_spawn_vehicle;
		(units _vehgrp) joinSilent _grp;
	};
	if(random 1 > 0.7) then {
		_car_type = (mps_opfor_mobiaa) call mps_getRandomElement;
		_vehgrp = [_car_type,(SIDE_B select 0),_position,100] call mps_spawn_vehicle;
		(units _vehgrp) joinSilent _grp;
	};
	_troops = _troops + (units _grp);
};

[format["TASK%1",_taskid],
	format["Urgent Air Strike! Destroy: %2 spotted near %1", text _location,_vehtype],
	format["Witnesses report a couple of %2 near %1. Clear the area and destroy them using air assets before launch. WARNING! AA threat high.",text _location,_vehtype],
	true,
	[format["MARK%1",_taskid],(_markerpos),"hd_objective","ColorRedAlpha"," Last Known"],
	"created",
	_position
] call mps_tasks_add;

scudcount = 0;
fired = false;

While {!ABORTTASK_AIR && {damage _x < 1} count [_target1,_target2] > 0 && scudcount < 1200} do { 
	scudcount = scudcount + 1;
	sleep 1;
	if(damage _target1 < 1) then {
		switch (scudcount) do {
			case 600 : { fire = _target1 action ["scudLaunch",_target1]; };
			case 1199 : { fire = _target1 action ["scudStart",_target1]; };
		};
	};
	if(damage _target2 < 1) then {
		switch (scudcount) do {
			case 800 : { fire = _target2 action ["scudLaunch",_target2]; };
			case 1199 : { fire = _target2 action ["scudStart",_target2]; };
		};
	};
};

if ( damage _target1 >= 1 && damage _target2 >= 1 && scudcount < 1200) then {
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
}else{
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
};

[_troops,_target1,_target2] spawn {
	sleep 60;
	{ _x setDamage 1}forEach (_this select 0);
	deleteVehicle (_this select 1);
	deleteVehicle (_this select 2);
};
