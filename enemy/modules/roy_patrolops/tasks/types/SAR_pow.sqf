if(count mps_loc_towns < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK SAR_pow.sqf"];

_location = (mps_loc_towns call mps_getRandomElement);

while {_location == mps_loc_last} do {
	_location = (mps_loc_towns call mps_getRandomElement); 
    sleep 0.1;
};

mps_loc_last = _location;


_position = [(position _location) select 0,(position _location) select 1, 0];
_houses = [_position,200] call mps_getEnterableHouses;

_house = [];
_hideout = [];
_troops = [];

for "_i" from 1 to 10000 do {
	_house = _houses call mps_getRandomElement;
	_buildingpos = round random (_house select 1);
	_house = (_house select 0);
	_hideout = (_house buildingPos _buildingpos);
	if(count (_hideout - [0]) > 0) exitWith{};
};

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];

	_powtype = "FR_Commander";
	if(count mps_blufor_leader > 0) then { _powtype = mps_blufor_leader call mps_getRandomElement };

	_powgrp = createGroup west;
	_pow1 = _powgrp createUnit [_powtype,_position,[],0,"FORM"];
	_pow1 setPos _hideout;
	_pow1 setRank "private";
	_pow1 allowFleeing 0;
	_pow1 setDamage 0.5;
	_pow1 setCaptive true;
	removeAllWeapons _pow1;
	[nil, _pow1, "per", rADDACTION, (format ["<t color=""#00FFFF"">Rescue %1</t>",name _pow1]),(mps_path+"action\mps_unit_join.sqf"), [], 1, true, true, "", ""] call RE;

	(_powgrp addWaypoint [position _pow1,0]) setWaypointType "HOLD";

_b = (2 max (round (random (playersNumber (SIDE_A select 0) / 3)))) * MISSIONDIFF;

for "_i" from 1 to _b do {
	_grp = [position _pow1,"INF",(5 + random 5),50,"patrol"] call CREATE_OPFOR_SQUAD;
	if(random 1 > 0.5) then {
		_car_type = (mps_opfor_car+mps_opfor_apc) call mps_getRandomElement;
		_vehgrp = [_car_type,(SIDE_B select 0),_position,100] call mps_spawn_vehicle;
		(units _vehgrp) joinSilent _grp;
	};
	_troops = _troops + (units _grp);
};

mps_civilian_intel = []; publicVariable "mps_civilian_intel";

[format["TASK%1",_taskid],
	"Rescue POW",
	format["An Officer has been captured after an attack on a convoy. It is believed he is being held in %1. Locate and rescue the officer",text _location],
	true,
	[format["MARK%1",_taskid],(_position),"hd_objective","ColorRedAlpha"," POW"],
	"created",
	_position
] call mps_tasks_add;

While{!ABORTTASK_PO && _pow1 distance getMarkerPos format["return_point_%1",(SIDE_A select 0)] > 100 && alive _pow1 } do {sleep 1};

if( (alive _pow1) and (_pow1 distance getMarkerPos format["return_point_%1",(SIDE_A select 0)] < 120)) then {
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
}else{
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
};

_pow1 action ["eject",vehicle _object];
sleep 1;
deleteVehicle _pow1;
deleteGroup _powgrp;

[_troops] spawn {
	sleep 60;
	{ _x setDamage 1}forEach (_this select 0);
};
