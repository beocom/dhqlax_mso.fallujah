if(count mps_loc_towns < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK SAD_cache.sqf"];

_location = (mps_loc_towns call mps_getRandomElement);

while {_location == mps_loc_last} do {
	_location = (mps_loc_towns call mps_getRandomElement); 
    sleep 0.1;
};

mps_loc_last = _location;

/*
_location = (mps_loc_towns call mps_getRandomElement);
mps_loc_towns = mps_loc_towns - [_location];
*/

_position = [(position _location) select 0,(position _location) select 1, 0];
_position = [_position,20,0.1,2] call mps_getFlatArea;

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];

_cachetype = "RUSpecialWeaponsBox";
if(mps_oa) then {_cachetype = "GuerillaCacheBox_EP1"};

_cachelocs = [_position,300] call mps_getEnterableHouses;
_cache0 = _cachetype createvehicle (_position);
_cache1 = _cachetype createvehicle (_position);
_cache2 = _cachetype createvehicle (_position);

_hideout = [];
_Enemies = [];

	for "_i" from 1 to 10000 do {
		_house = _cachelocs call mps_getRandomElement;
		_cachelocs = _cachelocs - [_house];
		_buildingpos = round random (_house select 1);
		_house = _house select 0;
		_hideout = (_house buildingPos _buildingpos);
		if(count (_hideout - [0]) > 0) exitWith{};
		_hideout = [(getPos _cache0 select 0) + _size - random (2*_size),(getPos _cache0 select 1) + _size - random (2*_size),0];
	};
	_cache0 setPos _hideout;

	for "_i" from 1 to 10000 do {
		_house = _cachelocs call mps_getRandomElement;
		_cachelocs = _cachelocs - [_house];
		_buildingpos = round random (_house select 1);
		_house = _house select 0;
		_hideout = (_house buildingPos _buildingpos);
		if(count (_hideout - [0]) > 0) exitWith{};
		_hideout = [(getPos _cache1 select 0) + _size - random (2*_size),(getPos _cache1 select 1) + _size - random (2*_size),0];
	};
	_cache1 setPos _hideout;

	for "_i" from 1 to 10000 do {
		_house = _cachelocs call mps_getRandomElement;
		_cachelocs = _cachelocs - [_house];
		_buildingpos = round random (_house select 1);
		_house = _house select 0;
		_hideout = (_house buildingPos _buildingpos);
		if(count (_hideout - [0]) > 0) exitWith{};
		_hideout = [(getPos _cache2 select 0) + _size - random (2*_size),(getPos _cache2 select 1) + _size - random (2*_size),0];
	};
	_cache2 setPos _hideout;

if(mps_debug) then {
	_marker = createMarkerLocal [format["Debug0%1",_taskid],position _cache0];
	_marker setMarkerTypeLocal "mil_dot";
	_marker setMarkerColorLocal "ColorGreen"; sleep 1;
	_marker = createMarkerLocal [format["Debug1%1",_taskid],position _cache1];
	_marker setMarkerTypeLocal "mil_dot";
	_marker setMarkerColorLocal "ColorGreen"; sleep 1;
	_marker = createMarkerLocal [format["Debug2%1",_taskid],position _cache2];
	_marker setMarkerTypeLocal "mil_dot";
	_marker setMarkerColorLocal "ColorGreen";
};

_rmin = 0;
_rmax = 1;
_rplayers = 1 max (playersNumber (SIDE_A select 0));
_ra = (_rmax-_rmin)/(mps_ref_playercount-1);
_rb = _rmin - _ra;
_diffresult = round(_rplayers * _ra + _rb);

_b = (2 max (round (random (playersNumber (SIDE_A select 0) / 3)))) * MISSIONDIFF;

if( _diffresult > 0.18 ) then { [_position] spawn CREATE_OPFOR_SNIPERS };

if(random 1 > 0.5) then {
	[_position] spawn CREATE_OPFOR_TOWER;
};

for "_i" from 1 to _b do {
	_stance = ["patrol","hide"] call mps_getRandomElement;
	_grp = [_position,"INF",(5 + random 5),50,_stance ] call CREATE_OPFOR_SQUAD;
	if(random 1 > 0.5) then {
		_car_type = (mps_opfor_car+mps_opfor_apc) call mps_getRandomElement;
		_vehgrp = [_car_type,(SIDE_B select 0),_position,100] call mps_spawn_vehicle;
		[_vehgrp,_position,"patrol"] spawn mps_patrol_init;
	};
};

mps_civilian_intel = [
	format["This person has seen a cache being moved into a building at Grid Ref: %1", mapGridPosition (position _cache0)],
	format["This person has seen a cache being moved into a building at Grid Ref: %1", mapGridPosition (position _cache1)],
	format["This person has seen a cache being moved into a building at Grid Ref: %1", mapGridPosition (position _cache2)],
	format["This person belives the weapons cache is in a building around %1",text _location],
	format["This person has seen the weapons cache in a building in %1",text _location],
	format["This person is indicating the target is near %1",text _location],
	format["This person is afraid of the armed men in %1",text _location],
	format["This person has seen dangerous men in %1",text _location],
	format["This person has seen armed men in %1",text _location],
	"This person belives the cache is in a building somewhere",
	"This person belives the cache is somewhere",
	"This person has not seen any caches"
];
publicVariable "mps_civilian_intel";


[format["TASK%1",_taskid],
	"Destroy Weapons Cache",
	format["Enemy have stored 3 small weapons caches in %1. Locate and destroy them.", text _location],
	true,
	[format["MARK%1",_taskid],(_position),"hd_objective","ColorRedAlpha"," Target"],
	"created",
	_position
] call mps_tasks_add;

cachesalive = true;
While {!ABORTTASK_PO AND cachesalive} do {
    									if (damage _cache0 < 1 || damage _cache1 < 1 || damage _cache2 < 1) then {cachesalive = true} else {cachesalive = false};
    									sleep (10);
                                        };

if (!cachesalive) then {
    [format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
} else {
    [format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
};