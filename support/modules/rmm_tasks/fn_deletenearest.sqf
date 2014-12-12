private ["_pos", "_cidx", "_cpos", "_i"];
_pos = _this select 0;
_playerSide = _this select 1;
_cidx = 0;
_cpos = [0,0,0];
_i=0;
{
	if ((_x select 2) distance _pos < _cpos distance _pos && (_x select 4) == _playerSide)then{
		_cpos = _x select 2;
		_cidx = _i;
	};
	_i=_i+1;
} foreach RMM_tasks;

diag_log format ["Deleting task(%2/%3) - %1", RMM_mytasks select _cidx, _cidx, count RMM_mytasks];

[2,[_cidx, _playerSide],{if(playerSide == (_this select 1)) then {player removeSimpleTask (RMM_mytasks select (_this select 0)); RMM_mytasks = RMM_mytasks - [RMM_mytasks select (_this select 0)];};}] call mso_core_fnc_ExMP;

RMM_tasks set [_cidx, objnull];
RMM_tasks = RMM_tasks - [objnull];
publicvariable "RMM_tasks";
