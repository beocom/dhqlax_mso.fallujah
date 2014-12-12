/* 
* Filename:
* init.sqf 
*
* Description:
* Runs on server and client
* 
* Created by [KH]Jman
* Creation date: 31/12/2011
* Email: jman@kellys-heroes.eu
* Web: http://www.kellys-heroes.eu
* 
* */

if(isNil "persistentDBHeader")then{persistentDBHeader = 0;};

if(persistentDBHeader == 0) exitWith{diag_log format ["MSO-%1 Persistent DB Disabled - Exiting.",time];};
	
// ====================================================================================
// DEFINES
#define PP preprocessfilelinenumbers
#define VAR_DEFAULT(var,val) if (isNil #var) then {var=(val);}
// ====================================================================================	

// PDB SETUP	
_pdbsettings = [] execVM "core\modules\persistentDB\pdbSetup.sqf";
waitUntil {scriptDone _pdbsettings};
diag_log["PersistentDB: pdb settings loaded"];


PDB_PLAYER_HANDLED = false;

diag_log format ["############################# Starting PDB for %1 #############################", pdb_fullmissionName];

[] call compile PP "core\modules\persistentDB\system.sqf";

pdb_serverError = 0;
pdb_clientError = 0;

if (isServer) then { 
	publicVariable "MISSIONDATA_LOADED";  
	if (isNil "MISSIONDATA_LOADED") then {	
		MISSIONDATA_LOADED = "false";  
		publicVariable "MISSIONDATA_LOADED"; 	
	}; 
};

if (isdedicated) then {	
	persistent_fnc_callDatabase = compile PP "core\modules\persistentDB\callDatabase.sqf"; 
	persistent_fnc_getData = compile PP "core\modules\persistentDB\fn_getData.sqf";
	persistent_fnc_saveData = compile PP "core\modules\persistentDB\fn_saveData.sqf";
	ENV_dedicated = true; publicVariable "ENV_dedicated"; 
	onPlayerConnected {[_id, _name, _uid] call compile PP "core\modules\persistentDB\onConnected.sqf"}; 
	onPlayerDisconnected {[_id, _name, _uid, true] call compile PP "core\modules\persistentDB\onDisconnected.sqf" }; 
	
	// Spawn auto-save process - server
	[] spawn {
		PDBLastSaveTimeServer = time;
		while {mpdb_save_delay_server > 0} do {
			waitUntil {
				sleep 60; 
				//diag_log format ["Time: %1, PDBLST: %2, PDBSD: %3", time, PDBLastSaveTimeServer, mpdb_save_delay_server];
				(time > (PDBLastSaveTimeServer + mpdb_save_delay_server))
			};
			diag_log["PersistentDB: SERVER MSG - Saving Server Data, time: ", time];
			[0, "__SERVER__", 0] call compile PP "core\modules\persistentDB\onDisconnected.sqf";
			PDBLastSaveTimeServer = time;
			sleep 5;
		};
	};
	
	// Spawn Auto-Save process - players
	[] spawn {
		PDBLastSaveTimePlayer = time;
		while {mpdb_save_delay_player > 0} do {
			waitUntil {
				sleep (60 + random 15); 
				//diag_log format ["Time: %1, PDBLST: %2, PDBSD: %3", time, PDBLastSaveTimePlayer, mpdb_save_delay_player];
				(time > (PDBLastSaveTimePlayer + mpdb_save_delay_player))
			};
			{
				diag_log["PersistentDB: SERVER MSG - Saving Player Data, time: ", time];
				[0, name _x, getplayeruid _x] call compile PP "core\modules\persistentDB\onDisconnected.sqf";
				sleep 5;
			} foreach playableunits;
			PDBLastSaveTimePlayer = time;
		};
	};
	
};

// Compile player EHs
persistent_fnc_playerDamage = compile PP "core\modules\persistentDB\playerDamage.sqf";
persistent_fnc_playerHeal = compile PP "core\modules\persistentDB\playerHeal.sqf";
persistent_fnc_playerRespawn = compile PP "core\modules\persistentDB\playerRespawn.sqf";
persistent_fnc_playerFired = compile PP "core\modules\persistentDB\playerFired.sqf";

//Add manual persistence action for Admins (aka "Magicwand")
PersistActionLocal = {
    _id = player addAction ["Persist cursor", "core\modules\persistentDB\magicwand.sqf", nil, 6, True, True, "", "serverCommandAvailable '#kick'"];
};
[] call PersistActionLocal;

if (!isdedicated) then { VAR_DEFAULT(ENV_dedicated, false); };
// ====================================================================================
// PDB STARTUP
if ((!isServer) && (player != player)) then { waitUntil {player == player};};
if ((!isServer) || (!isdedicated)) then {	
		
	[] spawn {  
		waitUntil { !(isNull player) };		
		sleep 0.2;
		waituntil { (player getvariable "mso_initcomplete" == 1) };
		diag_log["PersistentDB: SPAWN"];
		if  (ENV_dedicated) then { startLoadingScreen ["Please wait setting up client...", "PDB_loadingScreen"];	 };
		player setVariable ["BIS_noCoreConversations", true];
		player addeventhandler ["Dammaged", { _this call persistent_fnc_playerDamage; } ];
		player addeventhandler ["animChanged", { _this call persistent_fnc_playerHeal; } ];
		player addeventhandler ["Respawn", { _this call persistent_fnc_playerRespawn; _this call PersistActionLocal} ];
		player addeventhandler ["Fired", { _this call persistent_fnc_playerFired; } ];
		player allowdamage false;
		processInitCommands;
		finishMissionInit;
		waituntil { (PDB_PLAYERS_CONNECTED select 0 == "000000") };  // wait until server has finished loading data
		waituntil {time > 3};
		_thistime = time; waituntil { time > (random 5) + _thistime };
		diag_log["PersistentDB CLIENT: FINISHED MISSION INIT, time: ", time];
		if  (ENV_dedicated) then { startLoadingScreen ["Server is loading persistent mission data please standby...", "PDB_loadingScreen"]; };
		waituntil { (MISSIONDATA_LOADED == "true") };
		PDB_PLAYER_READY = [getPlayerUID player, player, name player, playerside];
		publicVariableServer "PDB_PLAYER_READY";
		if  (ENV_dedicated) then { startLoadingScreen ["Client is loading persistent player data...", "PDB_loadingScreen"]; };
		diag_log["PersistentDB CLIENT: PLAYER READY"];
		// Setup Player Menu Save
		[] spawn {
				waitUntil {!isNil "mso_interaction_key"};
				["player", [mso_interaction_key], -9500, ["core\modules\persistentDB\menuSavePlayer.sqf", "main"]] call CBA_ui_fnc_add;
		};
	};
};
// ====================================================================================
