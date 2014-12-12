MSO_fnc_CQBspawnRandomgroup = {
if (({(local _x) && ((faction _x) in MSO_FACTIONS)} count allunits) > CQBaicap) exitwith {diag_log format["MSO-%1 CQB Population: Local AI unitcount above limits. Exiting...", time]};

_pos = _this select 0;
_house = _this select 1;
_despawn = _this select 2;
_debug = debug_mso;
_grpPos = [_pos select 0,_pos select 1,-30];

if ({_pos distance _x < 100} count ([] call BIS_fnc_listPlayers) > 0) exitwith {diag_log format["MSO-%1 CQB Population: Players too near. Exiting...", time]};

_house setVariable ["s", true, CQBaiBroadcast];

sleep (random 1);

_fact = MSO_FACTIONS call BIS_fnc_selectRandom;

_sidex = getNumber(configFile >> "CfgFactionClasses" >> _fact >> "side");
_side = nil;
switch(_sidex) do {
        case 0: {
                _side = east;
        };
        case 1: {
                _side = west;
        };
        case 2: {
                _side = resistance;
        };
        case 3: {
                _side = civilian;
        };
		default {
				_side = east;
        };
};

_types = [0, [_fact],"Man"] call mso_core_fnc_findVehicleType;
_unittypes = [];
for "_i" from 0 to (1 + floor(random 3)) do {
    _unittype = _types call BIS_fnc_selectRandom;
	_unittypes set [count _unittypes, _unittype];
};

_group = [_grpPos, _side, _unittypes] call BIS_fnc_spawnGroup;
_units = units _group;

if (count _units < 1) exitwith {
    if (_debug) then {diag_log format["MSO-%1 CQB Population: Group %2 deleted on creation - no units...", time, _group]};
    deletegroup _group;
    _house setVariable ["s", nil, CQBaiBroadcast];
};

CQBgroupsLocal set [count CQBgroupsLocal, _group];
leader _group setvariable ["PM",_house,true];
if (_debug) then {diag_log format["MSO-%1 CQB Population: Created group name %2 with %3 units...", time, _group, count units _group];};

[_pos, _house, _group, _units, _despawn] spawn MSO_fnc_CQBmovegroup;
_group;
};