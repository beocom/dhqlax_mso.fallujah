// Load Vehicles

private ["_missionid", "_procedureName", "_parameters", "_response", "_ObjectCountInDB", "_serverData", "_countInDB", "_z", "_i", "_m","_thisID", "_objectData", "_vObject", "_tmp", "_thisObject", "_vPosition", "_vDir", "_vUp", "_vDam", "_vWeaponCargo","_vMagazineCargo"];

_missionid = _this select 0;

// START load the landVehicle data

// Count the number of objects associated with this mission id
_procedureName = "CountObjectIDsByMission"; 
_parameters = format["[tmid=%1]",_missionid];

//	diag_log ("callExtension->Arma2NETMySQL: CountLandVehicleIDsByMission");		
_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
//    diag_log ["callExtension->Arma2NETMySQL: CountLandVehicleIDsByMission _response: ",  _response, typeName _response];

if (pdb_log_enabled) then {
	diag_log format["SERVER MSG: SQL output: %1", _parameters];
};

_ObjectCountInDB = _response select 0;    // copy the returned row into array

diag_log format ["SERVER MSG: Loading %1 Objects from database.",   _objectCountInDB];

_serverData = format["Getting objects from database..."];
PDB_SERVER_LOADERSTATUS = [_serverData]; publicVariable "PDB_SERVER_LOADERSTATUS";

// now get the vehicledata per id

_procedureName = "GetObjectByInitid"; 

_countInDB = parseNumber (_objectCountInDB select 0);

// START LOOP
for [{_z=0},{_z < _countInDB},{_z=_z+1}] do {

	private ["_vType","_tmp","_thisObject"];
	
	_thisID = _z+1;
	
	_parameters = format["[tintid=%1,tmid=%2]", _thisID,_missionid];
	
	//	diag_log ("callExtension->Arma2NETMySQL: GetobjectByInitid");		
	_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
	//	diag_log ["callExtension->Arma2NETMySQL: GetobjectByInitid _response: ",  _response, typeName _response];
		
	_objectData	= _response select 0;    // copy the returned row into array
	
	//	diag_log ["GetobjectByInitid _objectData: ",  _objectData, typeName _objectData];
	
	_vObject =_objectData select 1;
	//diag_log ["ObjectData: ",  _ObjectData, typeName _ObjectData];
	
	_vType = _objectData select 2;
	//diag_log ["_vType: ",  _vType, typeName _vType];
	
	_vPosition =_objectData select 3;
	_vPosition = [_vPosition, "|", ","] call CBA_fnc_replace; 
	_vPosition = call compile _vPosition;
	
	//										diag_log ["_vPosition: ",  _vPosition, typeName _vPosition];
	
	// Convert string to Object

		call compile format ["_tmp = %1",_vObject];
				
		//diag_log ["_tmp: ",  _tmp, typeName _tmp];
		
		// Check to see if object is already on map
		if (!isNil "_tmp") then{
			_thisObject = _tmp;			
		} else {
			_thisObject = createVehicle [_vType, _vPosition, [], 0, "NONE"];
			_thisObject setvariable ["pdb_save_name", _vObject, true];
		};

		//_serverData = format["Loading Object: %1...", _thisObject];
		//PDB_SERVER_LOADERSTATUS = [_serverData]; publicVariable "PDB_SERVER_LOADERSTATUS";
		
		_vDir = _objectData select 4;
		_vDir = [_vDir, "|", ","] call CBA_fnc_replace;
		_vDir = call compile _vDir;
		
		//										diag_log ["_vDir: ",  _vDir, typeName _vDir];
		
		_vUp = _objectData select 5;
		_vUp = [_vUp, "|", ","] call CBA_fnc_replace;
		_vUp = call compile _vUp;
		
		//											diag_log ["_vUp: ",  _vUp, typeName _vUp];
		
		_vDam = _objectData select 6;
		_vDam = parseNumber _vDam;
		
		//										diag_log ["_vDam: ",  _vDam, typeName _vDam];
		
		if (pdb_objects_contents_enabled) then {
			clearWeaponCargoGlobal _thisObject;
			_vWeaponCargo = _objectData select 7;
			_vWeaponCargo = [_vWeaponCargo, "|", ","] call CBA_fnc_replace; 
			_vWeaponCargo = call compile _vWeaponCargo;	
			
			clearMagazineCargoGlobal _thisObject;
			_vMagazineCargo = _objectData select 8;
			_vMagazineCargo = [_vMagazineCargo, "|", ","] call CBA_fnc_replace; 
			_vMagazineCargo = call compile _vMagazineCargo;	
			//										diag_log ["_vWeaponCargo: ",  _vWeaponCargo, typeName _vWeaponCargo];
		} else {
			_vWeaponCargo = [];
			_vMagazineCargo = [];
		};
		
		// set the objects position
		_thisObject setPosATL _vPosition;
		// set the objects direction
		_thisObject setVectorDirAndUp [_vDir,_vUp];
		// set the objects damage
		_thisObject setDammage _vDam;
		
		// set the objects WeaponCargo 
		for "_i" from 0 to ((count (_vWeaponCargo select 0)) -1) do {
				_thisObject addWeaponCargoGlobal [(_vWeaponCargo select 0) select _i, (_vWeaponCargo select 1) select _i];
		};
		
		for "_m" from 0 to ((count (_vMagazineCargo select 0)) -1) do {
				_thisObject addMagazineCargoGlobal [(_vMagazineCargo select 0) select _m, (_vMagazineCargo select 1) select _m];
		};

};