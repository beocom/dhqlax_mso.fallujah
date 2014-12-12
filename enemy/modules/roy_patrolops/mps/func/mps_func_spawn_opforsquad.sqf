// Written by BON_IF
// Adpated by EightySix
//
//	requires Position
//	[_position,"INF",5,50] spawn CREATE_OPFOR_SQUAD;
//

private ["_side","_strength","_unit","_allunits","_pos","_radius","_count","_inftype","_spawnpos"];

if(count _this < 1) exitWith{hint "ERROR no position in CREATE_OPFOR_SQUAD";};

_side = (SIDE_B select 0);
_pos = (_this select 0) call mps_get_position;

_type = "INF";
if(count _this > 1) then{
	_type = _this select 1;
};

_strength = 2 + (round random 3);
if(count _this > 2) then{ _strength = _this select 2; };

_radius = 20;
if(count _this > 3) then{ _radius = _this select 3; };

_patrol = false;
_movetype = "patrol";
if(count _this > 4) then{ _patrol = true; _movetype = switch (_this select 4) do { case "standby" : {"standby"}; case "patrol": {"patrol"}; case "hide" : {"hide"}; default {"patrol"}; }; };

_x = _pos select 0;
_y = _pos select 1;

_Grp = createGroup _side;

_spawnpos = [0,0];
_count=0;
While{(surfaceIsWater _spawnpos || count (_spawnpos - [0]) == 0) && _count < 100} do {
	_spawnpos = [_x + _radius - random (_radius*2), _y + _radius - random (_radius*2)];
	_count = _count + 1;
};
if(_count == 100) exitWith{_Grp};
_spawnpos set [2,0];

switch _type do{
	case "INF": {_allunits = mps_opfor_inf};
	case "INS": {_allunits = mps_opfor_ins};
	case "AA": {_allunits = mps_opfor_aa + mps_opfor_inf};
	case "TARGET" : {_allunits = mps_opfor_leader};
	default {_allunits = mps_opfor_inf};
};

_max = (count _allunits) - 1;

for "_j" from 1 to _strength do {
	_unit = _Grp createUnit [_allunits select (round random _max),_spawnpos,[],0,"NONE"];
	_unit allowFleeing 0;
};

if(_patrol) then {[_Grp,_spawnpos,_movetype] spawn mps_patrol_init;};

// Cleanup
_Grp spawn {
	_units = units _this;
	_hidetime = 100;

	While{({alive _x} count _units) > 0} do{sleep 5};

	sleep _hidetime;
	{
		hidebody _x;
		sleep 3;
		deleteVehicle _x;
	} foreach _units;

	sleep 5;
	deleteGroup _this;
};

_Grp;