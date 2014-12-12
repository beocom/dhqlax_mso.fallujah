// Load Markers

private ["_missionid", "_procedureName", "_parameters", "_response", "_MarkerCountInDB", "_countInDB", "_z", "_i", "_m","_thisID", "_markerData", "_vMarker", "_tmp", "_thisMarker", "_vPosition", "_vType", "_vSide", "_vColor", "_vText"];

RMM_jipmarkers = [];

_missionid = _this select 0;

// START load the landVehicle data

// Count the number of objects associated with this mission id
_procedureName = "CountMarkerIDsByMission"; 
_parameters = format["[tmid=%1]",_missionid];

//	diag_log ("callExtension->Arma2NETMySQL: CountMarkerIDsByMission");		
_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
//    diag_log ["callExtension->Arma2NETMySQL: CountMarkerIDsByMission _response: ",  _response, typeName _response];

if (pdb_log_enabled) then {
	diag_log format["SERVER MSG: SQL output: %1", _parameters];
};

_MarkerCountInDB = _response select 0;    // copy the returned row into array

diag_log format ["SERVER MSG: Loading %1 Markers from database.",   _markerCountInDB];

_serverData = format["Getting Markers from database..."];
PDB_SERVER_LOADERSTATUS = [_serverData]; publicVariable "PDB_SERVER_LOADERSTATUS";

// now get the marker per ID

_procedureName = "GetMarkerByInitid"; 

_countInDB = parseNumber (_MarkerCountInDB select 0);

// START LOOP
for [{_z=0},{_z < _countInDB},{_z=_z+1}] do {

	_thisID = _z+1;
	
	_parameters = format["[tintid=%1,tmid=%2]", _thisID,_missionid];
	
	//	diag_log ("callExtension->Arma2NETMySQL: GetmarkerByInitid");		
	_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
	//	diag_log ["callExtension->Arma2NETMySQL: GetmarkerByInitid _response: ",  _response, typeName _response];
		
	_markerData	= _response select 0;    // copy the returned row into array
	
	//	diag_log ["GetmarkerByInitid _markerData: ",  _markerData, typeName _markerData];
	
	_vPosition = [_markerData select 2, "read"] call persistent_fnc_convertFormat;
	_vSide = call compile (_markerdata select 5);
	
	RMM_jipmarkers set [count RMM_jipmarkers, [_markerData select 1, _vPosition, _markerData select 3, _markerData select 4, _vSide, _markerData select 6]];

};

publicvariable "RMM_jipmarkers";