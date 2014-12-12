/* 
 * Filename:
 * main.sqf 
 *
 * Description:
 * Gives the currently logged in admin access to special actions: teleport (click on map), ghost (enemy will not fire on you), Spectator (ACE only)
 * 
 * Created by [KH]Jman
 * Creation date: 15/12/2010
 * Email: jman@kellys-heroes.eu
 * Web: http://www.kellys-heroes.eu
 * 
 * modified for MSO: 16/08/2012
 *
 * */
 
 	if (isnil "CFG_AdminCmds") then {CFG_AdminCmds = 1};
    if (CFG_AdminCmds == 0) exitwith {diag_log format ["MSO-%1 Adminactions turned off - Exiting.",time];};
    
	FNC_PLAYER_RESPAWN = {
		_player = _this select 0;
		if (player != _player) exitWith { }; 
		
		private ["_isAdmin "];

		FNC_GHOST_ACTION = -1;
		FNC_TELEPORT_ACTION = -1;
		FNC_SPECTATOR_ACTION = -1;
		FNC_Vehicle_Action = -1;
		
			if (CFG_AdminCmds == 1) then { 
				teleportMode = false;
					while { not gameOver } do { 
					_isAdmin = serverCommandAvailable "#kick";
						if (_isAdmin) then {
							if (CFG_AdminCmdGhost == 1) then { [player] call FNC_GHOST_CODE; };
							if (CFG_AdminCmdTeleport == 1) then { [player] call FNC_TELEPORT_CODE; };
							if (isClass(configFile>>"CfgPatches">>"ace_main") && CFG_AdminCmdSpectator == 1) then { [player] call FNC_SPECTATOR_CODE; };
						};
						
						if (!_isAdmin) then {
							if (((FNC_GHOST_ACTION != -1) || (FNC_TELEPORT_ACTION != -1) || (FNC_SPECTATOR_ACTION != -1))) then {
								if (CFG_AdminCmdGhost == 1) then { player removeAction FNC_GHOST_ACTION;};
								if (CFG_AdminCmdTeleport == 1) then { player removeAction FNC_TELEPORT_ACTION; };
								if (isClass(configFile>>"CfgPatches">>"ace_main") && CFG_AdminCmdSpectator == 1) then { player removeAction FNC_SPECTATOR_ACTION;};
								_this call FNC_PLAYER_RESPAWN;
							};
						};
				 };
			};
};	
// ====================================================================================
	FNC_GHOST_CODE =
	{ 
		_player = _this select 0;
		 if (player != _player) exitWith { }; 
		 	if (FNC_GHOST_ACTION == -1)  then {
				FNC_GHOST_ACTION = player addAction ["Ghost Mode", "core\modules\adminActions\ghostmode.sqf"];
			};
	};
// ====================================================================================
	FNC_TELEPORT_CODE =
	{ 		
		_player = _this select 0;
		 if (player != _player) exitWith { };
		 	if (FNC_TELEPORT_ACTION == -1)  then { 
				FNC_TELEPORT_ACTION = player addAction ["Teleport Mode", "core\modules\adminActions\teleportmode.sqf"];
			};
	};
// ====================================================================================
	FNC_SPECTATOR_CODE =
	{ 
		_player = _this select 0;
		 if (player != _player) exitWith { };
		 	if (FNC_SPECTATOR_ACTION == -1)  then {
				FNC_SPECTATOR_ACTION = player addAction ["Spectator Mode", "core\modules\adminActions\spectatormode.sqf"];
			};
	};


// ====================================================================================
// MAIN
	_player = _this select 0;
	
	 if (player != _player) exitWith { };
	 if(isNil "CFG_AdminCmds") then {CFG_AdminCmds = 1;};
	 if(isNil "CFG_AdminCmdTeleport") then {CFG_AdminCmdTeleport = 1;};
	 if(isNil "CFG_AdminCmdGhost") then {CFG_AdminCmdGhost = 1;};
	 if(isNil "CFG_AdminCmdSpectator" && isClass(configFile>>"CfgPatches">>"ace_main")) then {CFG_AdminCmdSpectator = 1;};
	 
		if (CFG_AdminCmds == 1) then {
			 gameOver = false;
			 player addeventhandler ["Respawn", { _this call FNC_PLAYER_RESPAWN; } ];
			_this call FNC_PLAYER_RESPAWN;
		};
// ====================================================================================
