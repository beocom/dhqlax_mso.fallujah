if(count mps_loc_towns < 1) exitWith{ diag_log "Failed to Open CAP_target.sqf. Not Enough Towns" };

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK CAP_target.sqf"];

private["_location","_position","_taskid","_object","_grp","_stance ","_b"];

_location = (mps_loc_towns call mps_getRandomElement);
while {_location == mps_loc_last } do {
    _location = (mps_loc_towns call mps_getRandomElement);
	sleep 0.1;
};
mps_loc_last = _location;

_position = [(position _location) select 0,(position _location) select 1, 0];
_position = [_position,10,0.1,2] call mps_getFlatArea;

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];
_troops = [];

_grp = [_position,"TARGET",1,10] call CREATE_OPFOR_SQUAD; sleep 1;
_object = (units _grp) select 0;
_object setRank "PRIVATE";
_object setCaptive true;
removeAllWeapons _object;

_houses = [_position,1000] call mps_getEnterableHouses;
_house = [];
_hideout = [];

for "_i" from 1 to 10000 do {
	_house = _houses call mps_getRandomElement;
	_buildingpos = round random (_house select 1);
	_house = (_house select 0);
	_hideout = (_house buildingPos _buildingpos);
	if(count (_hideout - [0]) > 0) exitWith{};
};
_object setPos _hideout;

[nil, _object, "per", rADDACTION, (format ["<t color=""#FF0000"">Arrest %1</t>",name _object]),(mps_path+"action\mps_unit_join.sqf"), [], 1, true, true, "", ""] call RE;

if(mps_debug) then {
	_marker = createMarkerLocal [format["Debug%1",_taskid],position _object];
	_marker setMarkerTypeLocal "mil_dot";
	_marker setMarkerColorLocal "ColorGreen";
};

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

if(random 1 > 0.5) then {
	[_position] spawn CREATE_OPFOR_TOWER;
};

mps_civilian_intel = [
	format["This person is indicating the target is in %1",text _location],
	format["This person belives the target is in a building in %1",text _location],
	format["This person has seen the target move into a building in %1",text _location]
];
publicVariable "mps_civilian_intel";

[format["TASK%1",_taskid],
	format["Capture: %1", name _object],
	format["Warrant issued for the Arrest of %1, a corrupt Officer located somewhere in %2. Arrest him and return him to base.<br/><br/>Intel places him within the perimiter of the town, in a building.", name _object,text _location],
	true,
	[format["MARK%1",_taskid],(_position),"hd_objective","ColorRedAlpha"," Target"],
	"created",
	_position
] call mps_tasks_add;

while {!ABORTTASK_PO && alive _object && _object distance (getMarkerPos format["return_point_%1",(SIDE_A select 0)]) > 10 } do { sleep 5 };

mps_civilian_intel = [];
publicVariable "mps_civilian_intel";

if(!ABORTTASK_PO && alive _object) then {
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
}else{
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
};

_object action ["eject",vehicle _object];
sleep 1;
deleteVehicle _object;
deleteGroup _grp;

[_troops,_position] spawn {
	while{!ABORTTASK_PO && {isPlayer _x} count nearestObjects[(_this select 1),["Man","LandVehicle","Plane"],1500] > 0} do { sleep 10 };
	{ _x setDamage 1}forEach (_this select 0);
};
