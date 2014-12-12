createDialog "RMM_ui_logbook";

lbClear 1;

private ["_vehicle", "_log", "_count"];
_vehicle = _this select 0;

if (isnil {_vehicle getvariable "RMM_logbook"}) then {_vehicle setvariable ["RMM_logbook",[],true]};
_log = _vehicle getvariable "RMM_logbook";
{
	lbadd [1, format ["%1, %2", _x select 0, _x select 1]];
} foreach _log;

_count = count _log;

player setvariable ["RMM_logbook_target",_vehicle];

waituntil {not dialog};

player setvariable ["RMM_logbook_target",nil];

if (_count == count (_vehicle getvariable "RMM_logbook")) then {
	doGetOut player;
};