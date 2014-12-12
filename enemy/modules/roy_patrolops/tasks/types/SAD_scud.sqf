if(count mps_loc_towns < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK SAD_scud.sqf"];

private["_location","_position","_taskid","_object","_vehtype","_target1","_guards"];

_location = (mps_loc_towns call mps_getRandomElement);

while {_location == mps_loc_last} do {
	_location = (mps_loc_towns call mps_getRandomElement); 
    sleep 0.1;
};

mps_loc_last = _location;

_markerpos = [(position _location) select 0,(position _location) select 1, 0];
_position = [(position _location) select 0,(position _location) select 1, 0];
_position = [_position,500,0.1,2] call mps_getFlatArea;

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];


_vehtype = "GRAD_RU";
if(mps_oa) then {_vehtype = "MAZ_543_SCUD_TK_EP1"};

_scudgrp = createGroup east;
_target1 = ([_position,random 320,_vehtype,_scudgrp] call BIS_fnc_spawnVehicle) select 0;
_target2 = ([_position,random 320,_vehtype,_scudgrp] call BIS_fnc_spawnVehicle) select 0; 

_vehtype = getText (configFile >> "CfgVehicles" >> typeof _target1  >> "displayName");


_troops = [];

_guards = nil;

while {isNil "_guards"} do {
     _guards = [_position, "Infantry", MSO_FACTIONS] call mso_core_fnc_randomGroup;
};
[_guards] call BIN_fnc_taskDefend;
_troops = _troops + (units _guards);

_b = (2 max (round (random (playersNumber (SIDE_A select 0) / 3)))) * MISSIONDIFF;
for "_i" from 1 to _b do {
	_grp = [_position,"INF",(5 + random 5),50,"patrol"] call CREATE_OPFOR_SQUAD;
	if(random 1 > 0.5) then {
		_car_type = (mps_opfor_car+mps_opfor_apc+mps_opfor_armor) call mps_getRandomElement;
		_vehgrp = [_car_type,(SIDE_B select 0),_position,100] call mps_spawn_vehicle;
		(units _vehgrp) joinSilent _grp;
	};
	_troops = _troops + (units _grp);
};

[format["TASK%1",_taskid],
	format["Urgent! Destroy: %2 spotted near %1", text _location,_vehtype],
	format["Witnesses report a couple of %2 near %1. Clear the area and destroy them before they can launch.",text _location,_vehtype],
	true,
	[format["MARK%1",_taskid],(_markerpos),"hd_objective","ColorRedAlpha"," Last Known"],
	"created",
	_markerpos
] call mps_tasks_add;

_dirn = "NORTH"; if( _position select 1 < _markerpos select 1) then {_dirn = "SOUTH"};
_dire = "EAST"; if( _position select 0 < _markerpos select 0) then {_dire = "WEST"};
_distintel = _position distance _markerpos;

mps_civilian_intel = [
	format["This person has seen some men moving around some %2m %3 from %1",text _location, round _distintel,_dirn],
	format["This person has seen some men moving around some %2m %3 from %1",text _location, round _distintel,_dire],
	format["This person has spotted the %2s at Grid Ref: %1", mapGridPosition _position,_vehtype],
	format["This person has seen some men moving around %2 from %1",text _location, _dirn],
	format["This person has seen some men moving around %2 from %1",text _location, _dire],
	format["This person has seen dangerous men on a hill near %1",text _location],
	format["This person has seen armed men on a hill around %1",text _location],
	format["This person spotted a supply truck moving to %1",text _location],
	format["This person has seen armed men in %1",text _location],
	"This person belives the target is somewhere",
	"This person has not seen the tower"
];
publicVariable "mps_civilian_intel";

scudcount = 0;
fired = false;

While {!ABORTTASK_PO && {damage _x < 1} count [_target1,_target2] > 0 && scudcount < 600} do { 
	scudcount = scudcount + 1;
	sleep 1;
	if(damage _target1 < 1) then {
		switch (scudcount) do {
			case 340 : { fire = _target1 action ["scudLaunch",_target1]; };
			case 899 : { fire = _target1 action ["scudStart",_target1]; };
		};
	};
	if(damage _target2 < 1) then {
		switch (scudcount) do {
			case 400 : { fire = _target2 action ["scudLaunch",_target2]; };
			case 900 : { fire = _target2 action ["scudStart",_target2]; };
		};
	};
};

mps_civilian_intel = []; publicVariable "mps_civilian_intel";

if ( damage _target1 >= 1 && damage _target2 >= 1 && scudcount < 900) then {
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
