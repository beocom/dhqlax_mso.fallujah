// Load Tasks

private ["_missionid", "_procedureName", "_parameters", "_response", "_taskCountInDB", "_countInDB", "_z", "_i", "_m","_thisID", "_taskData", "_vtask", "_tmp", "_thistask", "_vPosition", "_vType", "_vSide", "_vColor", "_vText"];

RMM_tasks = [];

_missionid = _this select 0;

// START load the landVehicle data

// Count the number of objects associated with this mission id
_procedureName = "CountTaskIDsByMission"; 
_parameters = format["[tmid=%1]",_missionid];

//	diag_log ("callExtension->Arma2NETMySQL: CounttaskIDsByMission");		
_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
//    diag_log ["callExtension->Arma2NETMySQL: CounttaskIDsByMission _response: ",  _response, typeName _response];

if (pdb_log_enabled) then {
	diag_log format["SERVER MSG: SQL output: %1", _parameters];
};

_taskCountInDB = _response select 0;    // copy the returned row into array

diag_log format ["SERVER MSG: Loading %1 tasks from database.",   _taskCountInDB];

_serverData = format["Getting Tasks from database..."];
PDB_SERVER_LOADERSTATUS = [_serverData]; publicVariable "PDB_SERVER_LOADERSTATUS";

// now get the task per ID

_procedureName = "GetTaskByInitid"; 

_countInDB = parseNumber (_taskCountInDB select 0);

// START LOOP
for [{_z=0},{_z < _countInDB},{_z=_z+1}] do {

	_thisID = _z+1;
	
	_parameters = format["[tintid=%1,tmid=%2]", _thisID,_missionid];
	
	//	diag_log ("callExtension->Arma2NETMySQL: GettaskByInitid");		
	_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
	//	diag_log ["callExtension->Arma2NETMySQL: GettaskByInitid _response: ",  _response, typeName _response];
		
	_taskData	= _response select 0;    // copy the returned row into array
	
	//	diag_log ["GettaskByInitid _taskData: ",  _taskData, typeName _taskData];
	_vDescr = [_taskData select 2, "read"] call persistent_fnc_convertFormat;
	_vPosition = [_taskData select 3, "read"] call persistent_fnc_convertFormat;
	_vSide = call compile (_taskdata select 5);
	
	RMM_tasks set [count RMM_tasks, [_taskData select 1, _vDescr, _vPosition, _taskData select 4, _vSide]];

};

publicvariable "RMM_tasks";