/* 
 * Filename:
 * playerFired.sqf 
 *
 * Description:
 * Called from init.sqf
 * 
 * Created by Tupolov
 * Creation date: 19/05/2012
 * 
 * */

// ====================================================================================
// MAIN

	private ["_shotsfired"];

	//diag_log["playerFired: ", _this];

	_player = _this select 0;                              
	
	_shotsfired = (_player getvariable "pshotsfired") + 1;
	
	//hintsilent format["%1", _shotsfired];

	_player setVariable ["pshotsfired", _shotsfired, true];
		
// ====================================================================================