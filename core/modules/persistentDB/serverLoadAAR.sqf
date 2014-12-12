// Load AARs and Logs

private ["_missionid", "_procedureName", "_parameters", "_response", "_aarCountInDB", "_countInDB", "_z", "_i", "_m","_thisID", "_aarData", "_vMarker", "_tmp", "_thisaar", "_vPosition", "_vType", "_vSide", "_vColor", "_vText"];

RMM_aars = [];

_missionid = _this select 0;

// START load the aar data

// Count the number of aar associated with this mission id
_procedureName = "CountAARIDsByMission"; 
_parameters = format["[tmid=%1]",_missionid];

//	diag_log ("callExtension->Arma2NETMySQL: CountaarIDsByMission");		
_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
//    diag_log ["callExtension->Arma2NETMySQL: CountaarIDsByMission _response: ",  _response, typeName _response];

if (pdb_log_enabled) then {
	diag_log format["SERVER MSG: SQL output: %1", _parameters];
};

_aarCountInDB = _response select 0;    // copy the returned row into array

diag_log format ["SERVER MSG: Loading %1 After Action Reports from database.",   _aarCountInDB];

_serverData = format["Getting After Action Reports from database..."];
PDB_SERVER_LOADERSTATUS = [_serverData]; publicVariable "PDB_SERVER_LOADERSTATUS";

// now get the aar per ID

_procedureName = "GetaarByInitid"; 

_countInDB = parseNumber (_aarCountInDB select 0);

// START LOOP
for [{_z=0},{_z < _countInDB},{_z=_z+1}] do {

	_thisID = _z+1;
	
	_parameters = format["[tintid=%1,tmid=%2]", _thisID,_missionid];
	
	//	diag_log ("callExtension->Arma2NETMySQL: GetaarByInitid");		
	_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
	//	diag_log ["callExtension->Arma2NETMySQL: GetaarByInitid _response: ",  _response, typeName _response];
		
	_aarData	= _response select 0;    // copy the returned row into array
	
	//	diag_log ["GetaarByInitid _aarData: ",  _aarData, typeName _aarData];
	
	_vAAR = [_aarData select 1, "read"] call persistent_fnc_convertFormat;
	_vType = _aarData select 2;
	
	if (_vType == "AAR") then {
		RMM_aars set [count RMM_aars, _vAAR];
	} else {
		// add log
	};


};

publicvariable "RMM_aars";