/* 
* Filename:
* playerDisconnected.sqf 
*
* Description:
* Called from init.sqf
* Runs on server only
* 
* Created by [KH]Jman
* Creation date: 17/10/2010
* Email: jman@kellys-heroes.eu
* Web: http://www.kellys-heroes.eu
* 
* */

// ====================================================================================
// INCLUDES
#include "\x\cba\addons\main\script_mod.hpp"
//http://dev-heaven.net/docs/cba/files/extended_eventhandlers/script_macros_common-hpp.html#DEBUG_MODE_FULL
#define DEBUG_MODE_FULL
#define DEBUG_SETTINGS DEBUG_SETTINGS_MAIN
#include "\x\cba\addons\main\script_macros.hpp"
#define COMPONENT arma2mysql
#define PREFIX asff

// ====================================================================================
// MAIN

private ["_disconnectflag","_id", "_allobjectTypes","_pname", "_puid", "_player", "_missionid", "_thisPlayerData", "_thisdata", "_thisWeaponData", "_thisACEData", "_params", "_parameters", "_i", "_procedureName", "_response", "_thisObject", "_landVehicles", "_landVehicleCount", "_missionLandVehicles", "_vDir", "_vUp", "_vDam", "_vPosition", "_vObject", "_vFuel", "_vLocked", "_vWeaponCargo", "_vMagazineCargo","_vEngine", "_result", "_thisObjectData", "_object", "_date"];

_id = _this select 0; 
_pname = _this select 1; 
_puid  = _this select 2; 
if (count _this > 3) then {
	_disconnectflag = _this select 3;
} else {
	_disconnectflag = false;
};

_missionid = (MISSIONDATA select 1);

if (pdb_log_enabled) then {
	if (_disconnectflag) then {
		diag_log format["SERVER MSG: Player %1, is leaving the server, frame Number: %2, Tick: %3, Time: %4", _pname, diag_frameno, diag_tickTime, time];
	} else {
		diag_log format["SERVER MSG: Player %1, is auto-saving, frame Number: %2, Tick: %3, Time: %4", _pname, diag_frameno, diag_tickTime, time];
	};	
};
	
	if (_pname != "__SERVER__") then {

		_player = objNull;
		{
			
			if (pdb_log_enabled) then {
				diag_log format["SERVER MSG: Loop. %1", getPlayerUID _x];
			};	
			

			if (getPlayerUID _x == _puid) exitWith {
				
				if (pdb_log_enabled) then {		
					diag_log format["SERVER MSG: Loop break. %1", getPlayerUID _x];
				};
				
				_player = _x;
			};

		} forEach playableUnits; // Return a list of playable units (occupied by both AI or players) in a multiplayer game. 
		
		if !(isNull _player) then {	
			
			// Set disconnect flag for player
			if (_disconnectflag) then {
				private "_timenow";
				_timenow = "Arma2Net.Unmanaged" callExtension "DateTime ['utcnow',]";
				_player setvariable ["LastDisconnected", _timenow, true];
			};
			
			// for each persistence type get and save data
			{
				private ["_type","_typestring","_procedure"];
				// Get data for object from client
				_typestring = _x;
				call compile format ["_type = %1",_typestring];
				_thisClientData = [_player, _type] call persistent_fnc_getData;
				// Set stored procedure to be called
				call compile format["_procedure = %1_PROCEDURE",_typestring];
				// Set parameters to be passed to stored procedure
				call compile format["_params = %1_PARAMS",_typestring];
				// Set id params for client get data call
				_idparams = format["tpid=%1,tna=%2,tmid=%3", _puid, _pname, _missionid];
				// Save Data to DB
				_response = [_thisClientData,_params,_procedure,_idparams] call persistent_fnc_saveData;
			} foreach PDB_CLIENT_GET_DATA;
			
		} else {
			// player not found!
			if (pdb_log_enabled) then {
				diag_log format["SERVER MSG: Player %1, not found in playableUnits!, frame Number: %2, Tick: %3, Time: %4", _pname, diag_frameno, diag_tickTime, time];
			};
		};
		
	} else {
		
	// __SERVER__ : 
	// This is a bit of a mess right now

	_missionid = (MISSIONDATA select 1);

	if (pdb_landvehicles_enabled) then {
		
		// START remove mission's current LandVehicles data				
		
		
		_procedureName = "RemoveLandVehicles"; 
		_parameters = format["[tmid=%1]",_missionid];
		
		if (pdb_log_enabled) then {
			diag_log format["SERVER MSG: SQL output: %1", _parameters];
		};
	
		_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
		
		// END remove mission's current LandVehicles data						
		
		// START save mission's LandVehicles data
		_procedureName = "InsertLandVehicles"; 
				
		// get LandVehicle data
		_thisObject = objNull;
		_landVehicles = [];
		_landVehicleCount = 1;
		_missionLandVehicles = "";
		{
			private "_psn";
			
			_thisObject = _x;
							
			_vDir = [0,0,0];
			_vUp = [0,0,0];
			_vDam = 0;
			_vPosition = [];
			
			_psn = _thisObject getvariable "pdb_save_name";
			
			//diag_log format ["Name: %1, getvar: %2", vehiclevarname _thisObject, _psn];
			
			if ((vehiclevarname _thisObject != "") || (!isNil "_psn")) then {

				if (vehiclevarname _thisObject != "") then {
					_vObject = vehiclevarname _thisObject;
				} else {
					_vObject = _thisObject getvariable "pdb_save_name";
				};

				_vType = typeOf _thisObject; // Object Type (for creating objects)
				_vPosition = str(getPosATL _thisObject); // setPosATL
				_vDam = str(getDammage _thisObject); // setDammage
				_vDir = str(vectorDir _thisObject); // setVectorDirAndUp
				_vUp = str(vectorUp _thisObject); //   setVectorDirAndUp
				_vFuel = str(fuel _thisObject);  // setFuel
				_vLocked = str(locked _thisObject); // Lock  || setVehicleLock ?
				_vEngine = str(isEngineOn _thisObject); // engineOn

				if (pdb_objects_contents_enabled) then {
					_vWeaponCargo = str(getWeaponCargo _thisObject); // addWeaponCargo 
					_vMagazineCargo = str(getMagazineCargo _thisObject); // addMagazineCargo
				} else {
					_vWeaponCargo = "";
					_vMagazineCargo = "";
				};
				_vPosition = [_vPosition, ",", "|"] call CBA_fnc_replace;
				_vDir = [_vDir, ",", "|"] call CBA_fnc_replace;
				_vUp = [_vUp, ",", "|"] call CBA_fnc_replace;
				_vWeaponCargo = [_vWeaponCargo, ",", "|"] call CBA_fnc_replace;
				_vMagazineCargo = [_vMagazineCargo, ",", "|"] call CBA_fnc_replace; 		
			
				_parameters = format["[tobj=%1,ttyp=%2,tpos=%3,tdir=%4,tup=%5,tdam=%6,tfue=%7,tlkd=%8,twcar=%9,teng=%10,twmag=%11,tmid=%12,tintid=%13]",_vObject, _vType, _vPosition, _vDir, _vUp, _vDam, _vFuel, _vLocked, _vWeaponCargo, _vEngine, _vMagazineCargo, _missionid, _landVehicleCount];
				
				if (pdb_log_enabled) then {
					diag_log format["SERVER MSG: SQL output: %1", _parameters];
				};
				
				//	diag_log ("callExtension->Arma2NETMySQL: InsertLandVehicles");		
				_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
				
				_landVehicleCount =_landVehicleCount+1;
			};
			
		} forEach vehicles; 
		
		// END save mission's LandVehicles data			
		
	};
			
	// Store Mission Objects
	// For each object, get object data, convert to DB format, store in array to be passed to DB function
	if (pdb_objects_enabled) then {
		
		// START remove mission's current objects data				
		
		_procedureName = "RemoveObjects"; 
		_parameters = format["[tmid=%1]",_missionid];
		
		if (pdb_log_enabled) then {
			diag_log format["SERVER MSG: SQL output: %1", _parameters];
		};
	
		_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
		
		// END remove mission's current object data						
		
		// START save mission's Object data
		_procedureName = "InsertObjects"; 
		
		// Set list of objects to look for (based on R3F)
		_allobjectTypes = allmissionobjects "static";
		
		// get Object data
		_thisObject = objNull;
		_objects = [];
		_objectCount = 1;
		_missionObjects = "";
		{
			private "_psn";
			
			_thisObject = _x;
			
			_psn = _thisObject getvariable "pdb_save_name";
			
			// Check to see if object should be persisted (i.e. a var name has been set)
			if ((vehiclevarname _thisObject != "") || (!isNil "_psn")) then {

				if (vehiclevarname _thisObject != "") then {
					_vObject = vehiclevarname _thisObject;
				} else {
					_vObject = _thisObject getvariable "pdb_save_name";
				};

				_vType = typeOf _thisObject; // Object Type (for creating objects)

				_vDir = [0,0,0];
				_vUp = [0,0,0];
				_vDam = 0;
				_vPosition = [];
				
				_vPosition = str(getPosATL _thisObject); // setPosATL
				_vDam = str(getDammage _thisObject); // setDammage
				_vDir = str(vectorDir _thisObject); // setVectorDirAndUp
				_vUp = str(vectorUp _thisObject); //   setVectorDirAndUp
				
				if (pdb_objects_contents_enabled) then {
					_vWeaponCargo = str(getWeaponCargo _thisObject); // addWeaponCargo 
					_vMagazineCargo = str(getMagazineCargo _thisObject); // addMagazineCargo
				} else {
					_vWeaponCargo = "";
					_vMagazineCargo = "";
				};
				
				//_vR3FTransportedBy = _thisObject getVariable "R3F_LOG_est_transporte_par";
				//_vR3FMovedBy = _thisObject getVariable "R3F_LOG_est_deplace_par";
		
				_vPosition = [_vPosition, ",", "|"] call CBA_fnc_replace;
				_vDir = [_vDir, ",", "|"] call CBA_fnc_replace;
				_vUp = [_vUp, ",", "|"] call CBA_fnc_replace;
				_vWeaponCargo = [_vWeaponCargo, ",", "|"] call CBA_fnc_replace; 	
				_vMagazineCargo = [_vMagazineCargo, ",", "|"] call CBA_fnc_replace; 			
						
				_parameters = format["[tobj=%1,ttyp=%2,tpos=%3,tdir=%4,tup=%5,tdam=%6,twcar=%7,twmag=%8,tmid=%9,tintid=%10]",_vObject, _vType, _vPosition, _vDir, _vUp, _vDam, _vWeaponCargo, _vMagazineCargo, _missionid,_ObjectCount];
				
				if (pdb_log_enabled) then {
					diag_log format["SERVER MSG: SQL output: %1", _parameters];
				};
				
				_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	

				_objectCount =_objectCount+1;
			};
		} forEach _allobjectTypes; 
		
		// END save mission's Object data			
		
	};
	
	if (pdb_locations_enabled) then {
		
		// START remove mission's current location data		
		
		_procedureName = "RemoveLocations"; 
		_parameters = format["[tmid=%1]",_missionid];
		
		if (pdb_log_enabled) then {
			diag_log format["SERVER MSG: SQL output: %1", _parameters];
		};
	
		_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
		
		// END remove mission's current Locations data						
		
		// START save mission's Locations data
		_procedureName = "InsertLocations"; 
				
		// Set the locations arrays to use
		_parentArrays = ["CQBPositionsReg","CQBPositionsStrat","DEP_LOCS"];
		
		// get Locations data
		_locationCount = 1;
		{
			_thisObject = objNull;
			_locations = [];
			_parentArrayName = _x;
			call compile format ["_locations = %1", _parentArrayName];
			{
				_thisObject = _x select 0;
				_vHousePositions = str (_x select 1);		
				
				_vObject = str _thisObject;
				_vPosition = [getPosATL _thisObject, "write"] call persistent_fnc_convertFormat;
				_vCleared = str (_thisObject getvariable "c");
				_vSuspended = str (_thisObject getvariable "s");
							
				_vGroupType = [_thisObject getvariable "groupType", "write"] call persistent_fnc_convertFormat;
				_vType = [_thisObject getvariable "type", "write"] call persistent_fnc_convertFormat;
				_vGroupStrength = [1, "write"] call persistent_fnc_convertFormat;
								
				_parameters = format["[tobj=%1,tpos=%2,thpo=%3,tcle=%4,tsus=%5,tgrt=%6,tgrs=%7,ttyp=%8,tpa=%9,tmid=%10,tintid=%11]",_vObject, _vPosition, _vHousePositions, _vCleared, _vSuspended, _vGroupType, _vGroupStrength, _vType, _ParentArrayName, _missionid, _locationCount];
				
				if (pdb_log_enabled) then {
					diag_log format["SERVER MSG: SQL output: %1", _parameters];
				};

				_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
				
				_locationCount = _locationCount+1;
				
			} forEach _locations;
		} forEach _parentArrays;
				
	};
	
	if (pdb_markers_enabled) then {
		
		// START remove mission's current narker data		
		
		_procedureName = "RemoveMarkers"; 
		_parameters = format["[tmid=%1]",_missionid];
		
		if (pdb_log_enabled) then {
			diag_log format["SERVER MSG: SQL output: %1", _parameters];
		};
	
		_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
		
		// END remove mission's current marker data						
		
		// START save mission's marker data
		_procedureName = "InsertMarkers"; 
				
		// get marker data
		_markerCount = 1;
		_markers = [];

		{
			_vName = _x select 0;	

			_vPosition = [_x select 1, "write"] call persistent_fnc_convertFormat;
			_vType = _x select 2;
			_vText = _x select 3;
						
			_vSide = str (_x select 4);
			_vColor = _x select 5;
							
			_parameters = format["[tnam=%1,tpos=%2,ttyp=%3,ttxt=%4,tside=%5,tcol=%6,tmid=%7,tintid=%8]",_vName, _vPosition, _vType, _vText, _vSide, _vColor, _missionid, _markerCount];
			
			if (pdb_log_enabled) then {
				diag_log format["SERVER MSG: SQL output: %1", _parameters];
			};

			_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
			
			_markerCount = _markerCount+1;
			
		} forEach RMM_jipmarkers;
				
	};
	
	// Save Task Data
	if (pdb_tasks_enabled) then {
		
		// START remove mission's current task data		
		
		_procedureName = "Removetasks"; 
		_parameters = format["[tmid=%1]",_missionid];
		
		if (pdb_log_enabled) then {
			diag_log format["SERVER MSG: SQL output: %1", _parameters];
		};
	
		_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
		
		// END remove mission's current task data						
		
		// START save mission's task data
		_procedureName = "Inserttasks"; 
				
		// get task data
		_taskCount = 1;
		_tasks = [];

		{
			_vName = _x select 0;	
			_vDescr = [_x select 1, "write"] call persistent_fnc_convertFormat;
			_vPosition = [_x select 2, "write"] call persistent_fnc_convertFormat;
			_vState = _x select 3;
			_vSide = str (_x select 4);
							
			_parameters = format["[tnam=%1,tdes=%2,tdest=%3,tsta=%4,tside=%5,tmid=%6,tintid=%7]",_vName, _vDescr, _vPosition, _vState, _vSide, _missionid, _taskCount];
			
			if (pdb_log_enabled) then {
				diag_log format["SERVER MSG: SQL output: %1", _parameters];
			};

			_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
			
			_taskCount = _taskCount+1;
			
		} forEach RMM_tasks;
				
	};
		
	// Save AAR data
	if (pdb_AAR_enabled) then {
		
		// START remove mission's current AAR data		
		
		_procedureName = "RemoveAARs"; 
		_parameters = format["[tmid=%1]",_missionid];
		
		if (pdb_log_enabled) then {
			diag_log format["SERVER MSG: SQL output: %1", _parameters];
		};
	
		_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
		
		// END remove mission's current aar data						
		
		// START save mission's aar data
		_procedureName = "InsertAARs"; 
				
		// get AAR data
		_aarCount = 1;
		_aars = [];

		{
			_vSitrep = [_x , "write"] call persistent_fnc_convertFormat;
			_vType = "AAR";
													
			_parameters = format["[tsitrep=%1,ttyp=%2,tmid=%3,tintid=%4]",_vSitRep, _vType, _missionid, _aarCount];
			
			if (pdb_log_enabled) then {
				diag_log format["SERVER MSG: SQL output: %1", _parameters];
			};

			_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
			
			_aarCount = _aarCount+1;
			
		} forEach RMM_aars;
				
	};
	
	// START save the time and date
	if (pdb_date_enabled) then {
		
		_date = [date, "write"] call persistent_fnc_convertFormat;
		
		_procedureName = "UpdateDate";
		_parameters = format["[tda=%1,tmid=%2]",_date,_missionid]; 
		
		if (pdb_log_enabled) then {
			diag_log format["SERVER MSG: SQL output: %1", _parameters];
		};
				
		//	diag_log ("callExtension->Arma2NETMySQL: UpdateDate");		
		_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	
		
	};
	// END save the time and date		

	// __SERVER__ exit

	if (pdb_log_enabled) then {
		diag_log format["SERVER MSG: %1 exiting/saving, frame Number: %2, Tick: %3, Time: %4", _pname, diag_frameno, diag_tickTime, time];
	};
	exit;	
			
	};




// ====================================================================================