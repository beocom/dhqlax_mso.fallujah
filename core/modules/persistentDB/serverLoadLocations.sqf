// Load Locations

private ["_missionid", "_procedureName", "_parameters", "_response", "_LocationCountInDB", "_serverData", "_countInDB", "_z", "_thisID", "_locationData", "_vlocation", "_tmp", "_thislocation", "_vPosition", "_vDir", "_vUp", "_vDam", "_vWeaponCargo", "_vMagazineCargo"];

_missionid = _this select 0;

// START load the location data

// Count the number of locations associated with this mission id
_procedureName = "CountLocationIDsByMission"; 
_parameters = format["[tmid=%1]",_missionid];		
_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	

if (pdb_log_enabled) then {
	diag_log format["SERVER MSG: SQL output: %1", _parameters];
};

_LocationCountInDB = _response select 0;    // copy the returned row into array

// diag_log ["CountLocationIDsByMission _LocationCountInDB: ",  _locationCountInDB, typeName _locationCountInDB];

diag_log format ["SERVER MSG: Loading %1 Locations from database.",   _locationCountInDB];

_serverData = format["Getting Locations from database..."];
PDB_SERVER_LOADERSTATUS = [_serverData]; publicVariable "PDB_SERVER_LOADERSTATUS";

// now get the vehicledata per id

_procedureName = "GetlocationByInitid"; 

_countInDB = parseNumber (_locationCountInDB select 0);

// Wipe the current location parent arrays
if (_countInDB > 0) then {
	// CQB
	CQBPositionsReg = [];
	CQBPositionsStrat = [];
	
	// EN_POP
	DEP_LOCS = [];
};

// START LOOP
for [{_z=0},{_z < _countInDB},{_z=_z+1}] do {

	_thisID = _z+1;
	
	_parameters = format["[tintid=%1,tmid=%2]", _thisID,_missionid];
	
	if (pdb_log_enabled) then {
		diag_log format["SERVER MSG: SQL output: %1", _parameters];
	};
	
	//	diag_log ("callExtension->Arma2NETMySQL: GetlocationByInitid");		
	_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
	//	diag_log ["callExtension->Arma2NETMySQL: GetlocationByInitid _response: ",  _response, typeName _response];
		
	_locationData	= _response select 0;    // copy the returned row into array
	
	//	diag_log ["GetlocationByInitid _locationData: ",  _locationData, typeName _locationData];
	
	// Use position to find house
	_vPosition =[_locationData select 2, "read"] call persistent_fnc_convertFormat;
	
	//										diag_log ["_vPosition: ",  _vPosition, typeName _vPosition];
	
	// Get object based on save string name - match on nearest house to position provided
	_vlocation = _locationData select 1;
	
	//diag_log ["_vlocation: ",  _vlocation, typeName _vlocation];
	
	// Given object position, find the nearest house - which should provide us with the correct object (may/will need better solution in future! Hoping Wolffy's hashmap function will provide this)
	_vParentArray = _locationData select 9;
		
	if (_vParentArray != "DEP_LOCS") then {
		_thislocation = nearestObject [_vPosition, "house"];
	} else {
		_thislocation = "Can_small" createvehicle _vPosition;
	};

	_vHousePositions = [_locationData select 3, "read"] call persistent_fnc_convertFormat;
		
	_vCleared = _locationData select 4;
	if (_vCleared == "true") then { _vCleared = true; } else{ _vCleared = nil; };
	
	_vSuspended = _locationData select 5;
	if (_vSuspended == "true") then { _vSuspended = true; } else{ _vSuspended = false; };
	
	_vGroupType = [_locationData select 6, "read"] call persistent_fnc_convertFormat;

	// diag_log format ["vGroupType %1",_vGroupType];
	
	_vGroupStrength = [_locationData select 7, "read"] call persistent_fnc_convertFormat;
	
	_vType = [_locationData select 8, "|", ","] call CBA_fnc_replace;
	_vType = call compile _vType;
	
	//diag_log format ["type = %1",_vType];
	
	// Set location data
	_thislocation setvariable ["c", _vCleared, true];
	//_thislocation setvariable ["s", _vSuspended, true];
	_thislocation setvariable ["groupType", _vGroupType, true];
	_thislocation setvariable ["groupStrength", _vGroupStrength, true];
	_thislocation setvariable ["type", _vType, true];
	
	// Add location to array (currently based on CQB arrays [object,houseposmax])
	call compile format["%1 set [count %1, [_thisLocation,_vHousePositions]]", _vParentArray];

};

// PV the location arrays
Publicvariable "CQBpositionsStrat";
Publicvariable "CQBpositionsReg";

PDB_CQB_positionsloaded = true;
PDB_DEP_positionsloaded = true;

Publicvariable "PDB_CQB_positionsloaded";
Publicvariable "PDB_DEP_positionsloaded";