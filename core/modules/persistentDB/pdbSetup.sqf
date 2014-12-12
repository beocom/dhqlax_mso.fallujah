/* 
* Filename:
* pdbSetup.sqf
*
* Description:
* Setup file for PDB
* 
* Created by [KH]Jman
* Creation date: 31/12/2011
* Email: jman@kellys-heroes.eu
* Web: http://www.kellys-heroes.eu
* 
* */
#define PP preprocessfilelinenumbers
// ====================================================================================

pdb_fullmissionName = missionName;   // the full unique mission name that will appear in the database
pdb_shortmissionName = format["MSO %1", mso_version]; // for BIS_fnc_infoText
pdb_author = "Thanks to the PDB Dev Team"; // for BIS_fnc_infoText

[] call compile PP "core\modules\persistentDB\player.sqf"; // Player data model
PDB_CLIENT_GET_DATA = ["G_PLAYER_DATA"]; // Setup an array of object data that we need to get from client
PDB_CLIENT_SET_DATA = ["S_PLAYER_DATA"];

// The following are set initially with a mission param or by default and then overridden by the mission DB vars if mission exists
// mpdb = mission param variable
// pdb = setting used by pdb
// Add any data models here as necessary

if (isnil"mpdb_save_delay_server") then {mpdb_save_delay_server = 0;}; 
if (isnil"mpdb_save_delay_player") then {mpdb_save_delay_player = 0;};

if (isnil"mpdb_date_enabled" || mpdb_date_enabled == 1) then {pdb_date_enabled = true;} else {pdb_date_enabled = false;};
if (isnil"mpdb_killStats_enabled" || mpdb_killStats_enabled == 1) then { pdb_killStats_enabled = true;} else { pdb_killStats_enabled = false;};
if (isnil"mpdb_persistentScores_enabled" || mpdb_persistentScores_enabled == 1) then { pdb_persistentScores_enabled = true;} else { pdb_persistentScores_enabled = false;};
if (isnil"mpdb_globalScores_enabled" || mpdb_globalScores_enabled == 1) then { pdb_globalScores_enabled = true;} else {pdb_globalScores_enabled = false;};
if (isnil"mpdb_log_enabled" || mpdb_log_enabled == 1) then {pdb_log_enabled = true;} else {pdb_log_enabled = false;};

if (isnil"mpdb_weapons_enabled" || mpdb_weapons_enabled == 1) then { 
	pdb_weapons_enabled = true;
	[] call compile PP "core\modules\persistentDB\weapons.sqf"; // Weapon data model 
	PDB_CLIENT_GET_DATA set [count PDB_CLIENT_GET_DATA, "G_WEAPON_DATA"];
	PDB_CLIENT_SET_DATA set [count PDB_CLIENT_SET_DATA, "S_WEAPON_DATA"];
} else {
	pdb_weapons_enabled = false;
};

if (isClass(configFile>>"CfgPatches">>"ace_main")) then {
	mpdb_ace_enabled = 1; 
	pdb_ace_enabled = true;
	[] call compile PP "core\modules\persistentDB\ace.sqf"; // ACE data model
	PDB_CLIENT_GET_DATA set [count PDB_CLIENT_GET_DATA, "G_ACE_DATA"];
	PDB_CLIENT_SET_DATA set [count PDB_CLIENT_SET_DATA, "S_ACE_DATA"];
} else {
	mpdb_ace_enabled = 0; pdb_ace_enabled = false;
};

if (isnil"mpdb_landvehicles_enabled" || mpdb_landvehicles_enabled == 1) then { pdb_landvehicles_enabled = true;} else {pdb_landvehicles_enabled = false;};
if (isnil"mpdb_objects_enabled" || mpdb_objects_enabled == 0) then { pdb_objects_enabled = false;} else {pdb_objects_enabled = true;};
if (isnil"mpdb_locations_enabled" || mpdb_locations_enabled == 0) then {pdb_locations_enabled = false;} else {pdb_locations_enabled = true;};
if (isnil"mpdb_objects_contents_enabled" || mpdb_objects_contents_enabled == 0) then {pdb_objects_contents_enabled = false;} else {pdb_objects_contents_enabled = true;};
if (isnil"mpdb_marker_enabled" || mpdb_marker_enabled == 0) then {pdb_marker_enabled = false;} else {pdb_marker_enabled = true;};
if (isnil"mpdb_AAR_enabled" || mpdb_AAR_enabled == 0) then {pdb_AAR_enabled = false;} else {pdb_AAR_enabled = true;}; 
if (isnil"mpdb_tasks_enabled" || mpdb_tasks_enabled == 0) then {pdb_tasks_enabled = false;} else {pdb_tasks_enabled = true;};




// ====================================================================================
