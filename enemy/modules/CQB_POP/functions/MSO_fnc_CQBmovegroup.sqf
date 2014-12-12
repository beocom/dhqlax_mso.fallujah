if (isDedicated) exitwith {};

private ["_bldgpos","_nearbldgs","_unittype","_spawnpos","_endpos","_unit","_leader","_group","_count","_units","_cleared","_suspended","_patrol","_movehome","_near","_houseguards"];
waitUntil {!isNil "bis_fnc_init"};

_pos = _this select 0;
_house = _this select 1;
_group = _this select 2;
_units = _this select 3;
_despawn = _this select 4;
_debug = debug_mso;

_bldgpos = [_pos,50]  call CQB_findnearhousepos;
if ((count _bldgpos) < 1) then {_bldgpos = [_pos,100]  call CQB_findnearhousepos};
if ((count _bldgpos) < 1) exitwith {
    {_x setdamage 1; deletevehicle _x;} foreach _units;
    waituntil {count (units _group) == 0};
	if (_debug) then {diag_log format["MSO-%1 CQB Population: Group %2 deleted - script end...", time, _group];};
	deletegroup _group;
    _house setvariable ["c",true,true];
	_house setvariable ["s",nil, CQBaiBroadcast];
};

if (_debug) then {diag_log format["MSO-%1 CQB Population: Found %2 buildingpositions...", time, count _bldgpos]};

[_group, _bldgpos] call CQB_setposgroup;

if ((random 1 > 0.35)) then {_houseguards = true;} else {_houseguards = false;};
waituntil {!(isnil "_houseguards")};

if (_houseguards) then {
	[_pos,_group,_house,_bldgpos,_despawn] call CQB_houseguardloop;
} else {
    [_pos,_group,_house,_bldgpos,_despawn] call CQB_patrolloop;
};

{
      _x setdamage 1;
      deletevehicle _x;
} foreach _units;
       
waituntil {count (units _group) == 0};
if (_debug) then {diag_log format["MSO-%1 CQB Population: Group %2 deleted - script end...", time, _group];};
deletegroup _group;
_house setvariable ["s",nil, CQBaiBroadcast];
true;