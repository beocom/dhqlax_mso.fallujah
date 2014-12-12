private ["_taskname","_description","_destination","_playerSide","_state","_mkr","_name"];
_taskname = _this select 0;
_description = _this select 1;
_destination = _this select 2;
_state = if(count _this > 3) then {_this select 3;} else {"created";};
_playerSide = if(count _this > 4) then {_this select 4;} else {playerSide;};

if (_playerSide == playerSide) then {
	private "_task";
	_task = player createsimpletask [_taskname];
	_task setsimpletaskdescription _description;
	_task setsimpletaskdestination _destination;
	_task settaskstate _state;
	missionnamespace setvariable [_taskname,_task];

	RMM_mytasks set [count RMM_mytasks, _task];
	_task;
};
/*
// Add a marker too
_name = "mkr" + str(random time + 1);
_mkr = createMarkerLocal [_name, [_destination select 0, (_destination select 1) + 5, 0]];
_mkr setmarkertypeLocal ("mil_marker");
_mkr setmarkertextLocal (_description select 1);
_mkr setmarkercolorLocal ("colorRed");
*/
