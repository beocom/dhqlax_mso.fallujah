
private ["_type","_crew","_pos","_dir","_startpos","_veh","_spawnDistance"];

_type = _this select 0;
_pos = _this select 1;

_crew = creategroup WEST;

if (_type iskindof "Air") then {
	_dir = random 360;
	_spawnDistance = 6000 + (random 1000);
	_startpos = [(_pos select 0) + (sin _dir)*_spawnDistance, (_pos select 1) + (cos _dir)*_spawnDistance, 800];
} else {
	_startroad = (_pos nearRoads 100) call BIS_fnc_selectRandom; 
	_startpos =  position _startroad; 
	_dir = getdir _startroad;	
};

_veh = ([_startpos, _dir, _type, _crew] call BIS_fnc_spawnVehicle) select 0;

if (_type iskindof "Air") then {
	_veh FlyInHeight 350; 
};

if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: Spawning %2 at %3m from position", time, typeof _veh, _pos distance _veh];};

_veh;
