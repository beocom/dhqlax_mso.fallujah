if(count mps_loc_towns < 1) exitWith{PAPABEAR sideChat format ["%1 this is PAPA BEAR. Mission Cancelled!", group player]};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK SAD_depot.sqf"];

private["_location","_position","_taskid","_object","_grp","_stance ","_b","_camptype","_troops","_guards"];

_location = (mps_loc_towns call mps_getRandomElement);

while {_location == mps_loc_last} do {
	_location = (mps_loc_towns call mps_getRandomElement); 
    sleep 0.1;
};

mps_loc_last = _location;

_markerpos = [(position _location) select 0,(position _location) select 1, 0];
_position = [[(position _location) select 0,(position _location) select 1, 0],800,0.1,2] call mps_getFlatArea;

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];
_b = (2 max (round (random (playersNumber (SIDE_A select 0) / 4)))) * MISSIONDIFF;
_troops = [];

_camptype = "FuelDump1_RU";
if(mps_oa) then {_camptype = "FuelDump1_TK_EP1";};

_newComp = [_position,random 360,_camptype] call BIS_fnc_dyno;

_guards = nil;

while {isNil "_guards"} do {
     _guards = [_position, "Infantry", MSO_FACTIONS] call mso_core_fnc_randomGroup;
};
[_guards] call BIN_fnc_taskDefend;
_troops = _troops + (units _guards);

_fueltanks = nearestObjects[_position,["Land_Ind_TankSmall","Land_Ind_TankSmall2"],100];

for "_i" from 1 to _b do {
	_grp = [_position,"INF",(5 + random 5),50,"patrol"] call CREATE_OPFOR_SQUAD;
	if(random 1 > 0.5) then {
		_car_type = (mps_opfor_car+mps_opfor_apc+mps_opfor_armor) call mps_getRandomElement;
		_vehgrp = [_car_type,(SIDE_B select 0),_position,100] call mps_spawn_vehicle;
		(units _vehgrp) joinSilent _grp;
	};
	_troops = _troops + (units _grp);
};

_dirn = "NORTH"; if( _position select 1 < _markerpos select 1) then {_dirn = "SOUTH"};
_dire = "EAST"; if( _position select 0 < _markerpos select 0) then {_dire = "WEST"};
_distintel = _position distance _markerpos;

mps_civilian_intel = [
	format["This person has seen some men moving around some %2m %3 from %1",text _location, round _distintel,_dirn],
	format["This person has seen some men moving around some %2m %3 from %1",text _location, round _distintel,_dire],
	format["This person delivered supplies to a depot at Grid Ref: %1", mapGridPosition _position],
	format["This person has seen some men moving around %2 from %1",text _location, _dirn],
	format["This person has seen some men moving around %2 from %1",text _location, _dire],
	format["This person has seen dangerous men in towns around %1",text _location],
	format["This person is afraid of the armed men around %1",text _location],
	format["This person spotted weapons trucks moving to %1",text _location],
	format["This person has seen dangerous men around %1",text _location],
	format["This person has seen armed men in %1",text _location],
	"This person belives the target is somewhere",
	"This person has not seen the target"
];
publicVariable "mps_civilian_intel";

[ format["TASK%1",_taskid],
	format["Destroy Depot: %1", text _location],
	format["Hostile Forces have constructed a supply depot near %1. Destroy the depot to cut their supply lines.", text _location],
	true,
	[format["MARK%1",_taskid],(_markerpos),"hd_objective","ColorRedAlpha"," Supply Trucks Spotted"],
	"created",
	_markerpos
] call mps_tasks_add;

while {!ABORTTASK_PO && {damage _x < 1} count _fueltanks > 0 } do { sleep 5 };

_dirn = "NORTH"; if( _position select 1 < _markerpos select 1) then {_dirn = "SOUTH"};
_dire = "EAST"; if( _position select 0 < _markerpos select 0) then {_dire = "WEST"};
_distintel = _position distance _markerpos;

mps_civilian_intel = []; publicVariable "mps_civilian_intel";

if(!ABORTTASK_PO) then {
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
