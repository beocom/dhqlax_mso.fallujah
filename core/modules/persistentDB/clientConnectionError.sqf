/* 
 * Filename:
 * clientConnectionError.sqf 
 *
 * Description:
 * Called from system.sqf
 * 
 * Created by [KH]Jman
 * Creation date: 19/01/2012
 * Email: jman@kellys-heroes.eu
 * Web: http://www.kellys-heroes.eu
 * 
 * */

// ====================================================================================
// MAIN

	_player = _this select 0;        
	                      
	if (player != _player) exitWith { }; // Im not the player so I shouldn't continue
	endLoadingScreen;
	player allowdamage true;
	initText = "<br/><t color='#ff0000' size='1.0' shadow='1' shadowColor='#000000' align='center'>ERROR</t><br/><br/>Failed to contact database.<br/>Please reconnect to the mission and retry.<br/><br/>";
	hint parseText (initText);
    sleep 10;
	failMission "LOSER";
	

// ====================================================================================