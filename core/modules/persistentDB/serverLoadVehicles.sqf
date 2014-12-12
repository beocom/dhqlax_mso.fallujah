// Load Vehicles

private ["_procedureName", "_parameters", "_missionid", "_response", "_landVehicleCountInDB", "_serverData", "_countInDB", "_z", "_thisID", "_landVehicleData", "_vObject", "_vPosition", "_vDir", "_vUp", "_vDam", "_vFuel", "_vLocked", "_vWeaponCargo", "_vMagazineCargo","_vEngine","_m"];

_missionid = _this select 0;

// START load the landVehicle data

// Count the number of land vehicles associated with this mission id
_procedureName = "CountLandVehicleIDsByMission"; 
_parameters = format["[tmid=%1]",_missionid];

//	diag_log ("callExtension->Arma2NETMySQL: CountLandVehicleIDsByMission");		
_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
//    diag_log ["callExtension->Arma2NETMySQL: CountLandVehicleIDsByMission _response: ",  _response, typeName _response];

if (pdb_log_enabled) then {
	diag_log format["SERVER MSG: SQL output: %1", _parameters];
};

_landVehicleCountInDB = _response select 0;    // copy the returned row into array

diag_log format ["SERVER MSG: Loading %1 Vehicles from database.",  _landVehicleCountInDB];

_serverData = format["Getting land vehicles from database..."];
PDB_SERVER_LOADERSTATUS = [_serverData]; publicVariable "PDB_SERVER_LOADERSTATUS";

// now get the vehicledata per id

_procedureName = "GetLandVehicleByInitid"; 

_countInDB = parseNumber (_landVehicleCountInDB select 0);

// START LOOP
for [{_z=0},{_z < _countInDB},{_z=_z+1}] do {
	
	private ["_m","_vType","_tmp", "_thisVehicle"];

	_thisID = _z+1;
	
	_parameters = format["[tintid=%1,tmid=%2]", _thisID,_missionid];
	
	//	diag_log ("callExtension->Arma2NETMySQL: GetLandVehicleByInitid");		
	_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
	//	diag_log ["callExtension->Arma2NETMySQL: GetLandVehicleByInitid _response: ",  _response, typeName _response];
		
	_landVehicleData	= _response select 0;    // copy the returned row into array
	
	//	diag_log ["GetLandVehicleByInitid _landVehicleData: ",  _landVehicleData, typeName _landVehicleData];
	
	_vObject =_landVehicleData select 1;
	//diag_log ["_vObject: ",  _vObject, typeName _vObject];
		
	_vType = _landVehicleData select 2;
	//diag_log ["_vType: ",  _vType, typeName _vType];
	
	_vDam = _landVehicleData select 6;
	_vDam = parseNumber _vDam;
	
	//diag_log ["_vDam: ",  _vDam, typeName _vDam];
	
	_vPosition = _landVehicleData select 3;
	_vPosition = [_vPosition, "|", ","] call CBA_fnc_replace; 
	_vPosition = call compile _vPosition;
	//diag_log ["_vPosition: ",  _vPosition, typeName _vPosition];
		
	// Convert string to Object
		call compile format ["_tmp = %1",_vObject];
		
		//diag_log ["_tmp: ",  _tmp, typeName _tmp];
		
		// Check to see if object is already on map
		if (!isNil "_tmp") then {
			_thisVehicle = _tmp;			
		} else {
			if (_vDam < 1) then {
				//diag_log format["Creating Vehicle: %1",  _vType];
				_thisVehicle = createVehicle [_vType, _vPosition, [], 0, "NONE"];
				_thisVehicle setvariable ["pdb_save_name", _vObject, true];
			};
		};

		//diag_log ["_thisVehicle: ",  _thisVehicle, typeName _thisVehicle];
		
		//_serverData = format["Loading land vehicle: %1...", _thisVehicle];
		//PDB_SERVER_LOADERSTATUS = [_serverData]; publicVariable "PDB_SERVER_LOADERSTATUS";
				
		_vDir = _landVehicleData select 4;
		_vDir = [_vDir, "|", ","] call CBA_fnc_replace;
		_vDir = call compile _vDir;
		
		//										diag_log ["_vDir: ",  _vDir, typeName _vDir];
		
		_vUp = _landVehicleData select 5;
		_vUp = [_vUp, "|", ","] call CBA_fnc_replace;
		_vUp = call compile _vUp;
		
		//											diag_log ["_vUp: ",  _vUp, typeName _vUp];
		

		
		_vFuel = _landVehicleData select 7;
		_vFuel = parseNumber _vFuel;
		
												diag_log ["_vFuel: ",  _vFuel, typeName _vFuel];
		
		_vLocked = _landVehicleData select 8;
		
		if (_vLocked == "false") then { _vLocked = false; } else{ _vLocked = true; };
		//										 diag_log ["_vLocked: ",  _vLocked, typeName _vLocked];
		
		_vEngine = _landVehicleData select 10;
		if (_vEngine == "false") then { _vEngine = false; } else{ _vEngine = true; };
		//										diag_log ["_vEngine: ",  _vEngine, typeName _vEngine]

		if (pdb_objects_contents_enabled) then {
			clearWeaponCargoGlobal _thisVehicle;
			_vWeaponCargo = _landVehicleData select 9;
			_vWeaponCargo = [_vWeaponCargo, "|", ","] call CBA_fnc_replace; 
			_vWeaponCargo = call compile _vWeaponCargo;	

			//if (count (v_weaponcargo select 0) > 0) then { diag_log ["_vWeaponCargo: ",  _vWeaponCargo, typeName _vWeaponCargo];};

			clearMagazineCargoGlobal _thisVehicle;
			_vMagazineCargo = _landVehicleData select 11;
			_vMagazineCargo = [_vMagazineCargo, "|", ","] call CBA_fnc_replace; 
			_vMagazineCargo = call compile _vMagazineCargo;
			
			//if (count (v_MagazineCargo select 0) > 0) then { diag_log ["_vMagazineCargo: ",  _vMagazineCargo, typeName _vMagazineCargo];};
		} else {
			_vWeaponCargo = [];
			_vMagazineCargo = [];
		};
		
		// set the vehicles position
		_thisVehicle setPosATL _vPosition;
		// set the vehicles direction
		_thisVehicle setVectorDirAndUp [_vDir,_vUp];
		// set the vehicles damage
		_thisVehicle setDammage _vDam;
		// set the vehicles fuel 
		_thisVehicle setFuel _vFuel;
		// set the vehicles lock 
		_thisVehicle lock _vLocked;
		// set the vehicles WeaponCargo 
		for "_i" from 0 to ((count (_vWeaponCargo select 0)) -1) do {
				_thisVehicle addWeaponCargoGlobal [(_vWeaponCargo select 0) select _i, (_vWeaponCargo select 1) select _i];
				//diag_log format ["Adding Weapon %1 to vehicle %2", (_vWeaponCargo select 0) select _i, _thisVehicle];
		};
		for "_i" from 0 to ((count (_vMagazineCargo select 0)) -1) do {
				_thisVehicle addMagazineCargoGlobal [(_vMagazineCargo select 0) select _i, (_vMagazineCargo select 1) select _i];
				//diag_log format ["Adding Magazine %1 to vehicle %2", (_vMagazineCargo select 0) select _i, _thisVehicle];
		};
		// set the vehicles engine 
		_thisVehicle engineOn _vEngine;

	
};