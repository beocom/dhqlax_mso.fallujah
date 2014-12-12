private ["_pos", "_cidx", "_cpos", "_i","_updatedtask","_state","_playerSide"];
_pos = _this select 0;
_playerSide = _this select 1;
_state = _this select 2;
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

// Update everyone's tasks
[2,[_cidx, _playerSide, _state],{if(playerSide == (_this select 1)) then {[RMM_mytasks select (_this select 0),_this select 2] call tasks_fnc_taskUpdate;};}] call mso_core_fnc_ExMP;

// Update global task array
_updatedtask = RMM_tasks select _cidx;
_updatedtask set [3,_state];
RMM_tasks set [_cidx, _updatedtask];
publicvariable "RMM_tasks";

diag_log format ["Task updating: %1, %2, %3, %4", _cidx, _state, _updatedtask, RMM_tasks select _cidx];