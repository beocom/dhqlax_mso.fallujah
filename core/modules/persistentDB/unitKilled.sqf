/* 
 * Filename:
 * unitKilled.sqf 
 *
 * Description:
 * Extended Killed Eventhandler, set in mso-description.ext
 * 
 * Created by Tupolov
 * Creation date: 21/05/2012
 * 
 * */

// ====================================================================================
// MAIN

	private ["_enemykills","_civkills","_friendlykills","_killed","_killer","_sideKilled","_sideKiller","_suicides","_deaths","_killedtype","_killerweapon","_killertype","_distance","_pos","_datetime","_factionKiller","_factionKilled"];

	_killed = _this select 0;
	_killer = _this select 1;
	
	_sideKilled = side (group _killed); // group side is more reliable
	_sideKiller = side _killer;
	
	_factionKiller = getText (configFile >> "cfgFactionClasses" >> (faction _killer) >> "displayName"); 
	_factionKilled = getText (configFile >> "cfgFactionClasses" >> (faction _killed) >> "displayName"); 
	
	_killedtype = getText (configFile >> "cfgVehicles" >> (typeof _killed) >> "displayName");
	_killertype = getText (configFile >> "cfgVehicles" >> (typeof _killer) >> "displayName");
	
	_datetime = date;
	
	_killerweapon = getText (configFile >> "cfgWeapons" >> (currentweapon _killer) >> "displayName");
	
	if (vehicle _killer != _killer) then {
			_killerweapon = _killerweapon + format[" (%1)", getText (configFile >> "cfgVehicles" >> (typeof (vehicle _killer)) >> "displayName")];
	};
	
	_distance = _killed distance _killer;
	
	_pos = position _killed;
	
	if (debug_mso_setting == 1) then {
		diag_log format["%1 - Unit Killed: %2, Killed side = %3, Killer side = %4, Weapon: %5, Killer: %6, Distance: %7", _datetime, _killedtype, _sideKilled, _sideKiller, _killerweapon, _killertype, _distance];
	};
	
	if (isPlayer _killed) exitWith { // Player was killed
		_deaths = (_killed getvariable "pdeaths") + 1;		
		//hintsilent format["Player Deaths: %1", _deaths];
		_killed setVariable ["pdeaths", _deaths, true];
		
		if (pdb_killStats_enabled) then {
			// Send data to server to be written to DB
			PDB_PLAYER_UPDATE_KILLS = [getplayeruid _killed, _killerweapon, _distance, _factionKiller, _killertype, true, _pos, _datetime];
			publicVariableServer "PDB_PLAYER_UPDATE_KILLS";
		};

	};
	
	if (isNull _killer) exitWith {}; // Unit was likely killed in a collision with something
	
	if (isPlayer _killer) then {
		
		if (_killer == _killed) exitWith { // Suicide
			_suicides = (_killer getvariable "psuicides") + 1;	
			//hintsilent format["Suicide: %1", _suicides];
			_killer setVariable ["psuicides", _suicides, true];
		};
		
		if (_sideKilled == _sideKiller) then { // BLUE on BLUE
			_friendlykills = (_killer getvariable "pfriendlykills") + 1;		
			//diag_log format["BLUFOR Kills: %1", _friendlykills];
			_killer setVariable ["pfriendlykills", _friendlykills, true];
		};
		
		if ((_sideKilled == civilian) || (_sideKilled == sideFriendly)) then { // civpop killing
			_civkills = (_killer getvariable "pcivkills") + 1;		
			//hintsilent format["Civ Kills %1", _civkills];
			_killer setVariable ["pcivkills", _civkills, true];
		};
		
		if ((_sideKilled != civilian) && (_sideKilled != _sideKiller) && (_sideKilled != sideFriendly) && (_sideKiller != sideEnemy)) then { // enemy killing yay!
			_enemykills = (_killer getvariable "penemykills") + 1;		
			//diag_log format["%1 Enemy Kills %2", _killer, _enemykills];} else {hintsilent format["Enemy Kills %1", _enemykills];};
			_killer setVariable ["penemykills", _enemykills, true];
		};
		
		if (pdb_killStats_enabled) then {
			// Send data to server to be written to DB
			PDB_PLAYER_UPDATE_KILLS = [getplayeruid _killer, _killerweapon, _distance, _factionKilled, _killedtype, false, _pos, _datetime];
			publicVariableServer "PDB_PLAYER_UPDATE_KILLS";
		};
	};
// ====================================================================================