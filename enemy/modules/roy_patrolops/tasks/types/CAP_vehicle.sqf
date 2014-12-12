if(count mps_loc_towns < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK CAP_vehicle.sqf"];

private["_location","_position","_taskid","_object","_type"];

_location = (mps_loc_towns call mps_getRandomElement);
while {_location == mps_loc_last } do {
    _location = (mps_loc_towns call mps_getRandomElement);
	sleep 0.1;
};
mps_loc_last = _location;

_position = [(position _location) select 0,(position _location) select 1, 0];
_position = [_position,250,0.1,2] call mps_getFlatArea;

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];

_vehicles = (mps_opfor_apc+mps_opfor_armor);
_object = (_vehicles) select (random ((count _vehicles) - 1)) createVehicle _position;
_vehtype = getText (configFile >> "CfgVehicles" >> typeof _object >> "displayName");

_b = (2 max (round (random (playersNumber (SIDE_A select 0) / 3)))) * MISSIONDIFF;
_troops = [];

_grp = [_position,"INF",(5 + random 5),50] call CREATE_OPFOR_SQUAD;
_troops = _troops + (units _grp);

for "_i" from 1 to _b do {
	_stance = ["patrol","standby","hide"] call mps_getRandomElement;
	_grp = [_position,"INF",(5 + random 5),50,_stance ] call CREATE_OPFOR_SQUAD;
	_troops = _troops + (units _grp);
	if(random 1 > 0.5) then {
		_car_type = (mps_opfor_car+mps_opfor_apc+mps_opfor_armor) call mps_getRandomElement;
		_vehgrp = [_car_type,(SIDE_B select 0),_position,100] call mps_spawn_vehicle;
		[_vehgrp,_position,"patrol"] spawn mps_patrol_init;
		_troops = _troops + (units _vehgrp);
	};
};

if(random 1 > 0.5) then {
	[_position] spawn CREATE_OPFOR_TOWER;
};

_dirn = "NORTH"; if( (position CAPT2_target) select 1 < (position _location) select 1) then {_dirn = "SOUTH"};
_dire = "EAST"; if( (position CAPT2_target) select 0 < (position _location) select 0) then {_dire = "WEST"};
_distintel = (position CAPT2_target) distance (position _location);

mps_civilian_intel = [
	format["This person has seen the %2 at Grid Ref: %1", mapGridPosition (position _object),_vehtype],
	format["This person is indicating the target is near %1",text _location],
	format["This person is afraid of the armed men in %1",text _location],
	format["This person has seen dangerous men in %1",text _location],
	format["This person has seen armed men in %1",text _location],
	"This person has not seen the target"
];
publicVariable "mps_civilian_intel";


[format["TASK%1",_taskid],
	format["Capture a %1", _vehtype],
	format["The enemy have been intergrating unknown technology onto a %1. Locate and capture the %1 then get it safely back to the return point at base to be examined.", _vehtype],
	true,
	[format["MARK%1",_taskid],(_position),"hd_objective","ColorRedAlpha"," Target"],
	"created",
	_position
] call mps_tasks_add;

while {!ABORTTASK_PO && alive _object && _object distance (getMarkerPos format["return_point_%1",(SIDE_A select 0)]) > 100} do { sleep 5 };

mps_civilian_intel = []; publicVariable "mps_civilian_intel";


if(!ABORTTASK_PO && alive _object) then {
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
}else{
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
};

sleep 5;

{_x action ["eject",_object]}foreach (crew _object);

sleep 2;
deleteVehicle _object;
{_x setdamage 1}forEach _troops;
