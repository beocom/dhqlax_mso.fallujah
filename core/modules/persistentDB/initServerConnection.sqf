/* 
* Filename:
* initServerConnection.sqf 
*
* Description:
* Called from playerConnected.sqf
* Runs on server only
* 
* Created by Tupolov
* Creation date: 6/6/2012
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
// This is done for all players connecting...
//sleep 5;
sleep 0.01;

private ["_missionid","_id","_pname","_puid"];

_id = _this select 0; 
_pname = _this select 1; 
_puid  = _this select 2; 

// ====================================================================================	

if (( MISSIONDATA_LOADED == "false") && (_pname == "__SERVER__")) then {
	

	missionNameSpace setVariable ["server_initmissiondata", 1];
	
	// Load Mission
	script_missionload = [] execVM "core\modules\persistentDB\serverLoadMission.sqf";
	waitUntil {scriptDone script_missionload};
	
	_missionid = MISSIONDATA select 1;
	
	// Load Map Markers
	if (pdb_markers_enabled) then {	
			[_missionid] execVM "core\modules\persistentDB\serverLoadMarkers.sqf";
	};
	
	// Load Tasks
	if (pdb_tasks_enabled) then {	
			[_missionid] execVM "core\modules\persistentDB\serverLoadTasks.sqf";
	};
	
	// Load AAR & Log
	if (pdb_AAR_enabled) then {	
			[_missionid] execVM "core\modules\persistentDB\serverLoadAAR.sqf";
	};
	
	// Load Vehicles
	if (pdb_landvehicles_enabled) then {	
		[_missionid] execVM "core\modules\persistentDB\serverLoadVehicles.sqf";
	};			
	
	// Load Objects
	if (pdb_objects_enabled) then {	
		[_missionid] execVM "core\modules\persistentDB\serverLoadObjects.sqf";
	};	
	
	// Load Locations?
	if (pdb_locations_enabled) then {	
		[_missionid] execVM "core\modules\persistentDB\serverLoadLocations.sqf";
	};	
	
	MISSIONDATA_LOADED = "true";
	publicVariable "MISSIONDATA_LOADED"; // update the global array	
	
}; 