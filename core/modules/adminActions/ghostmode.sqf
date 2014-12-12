/* 
 * Filename:
 * ghostmode.sqf 
 *
 * Description:
 * Spawns off init function to set admin player's visiblity 
 * 
 * Created by [KH]Jman
 * Creation date: 06/03/2011
 * Email: jman@kellys-heroes.eu
 * Web: http://www.kellys-heroes.eu
 * 
 * */
// ====================================================================================
// MAIN

/* 
	Params passed to this script:
		object action was attached to
		unit that activated action
		index of action
*/

	_player = _this select 0;                              
	_name = _this select 1;        
	_index = _this select 2;
    

	 if (player != _player) exitWith { };
	
			private ["_isAdmin "];
	
if (CFG_AdminCmds == 1) then { 
	_isAdmin = serverCommandAvailable "#kick";
	
	 if (_isAdmin) then {

		if (captive player) then { 
			player setcaptive false; 
			hint "Ghost mode off";
		} else {
			player setcaptive true; 
			hint "Ghost mode on";
		};
	 }else {
			hint "Command not available";
	 };	
};
// ====================================================================================