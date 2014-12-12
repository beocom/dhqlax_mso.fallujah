/* 
 * Filename:
 * serverConnectionError.sqf 
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

	endLoadingScreen;
	player allowdamage true;
	initText = "<br/><t color='#ff0000' size='1.0' shadow='1' shadowColor='#000000' align='center'>ERROR</t><br/><br/>The server failed to contact database.<br/>Please restart the mission and check the connection.<br/><br/>";
	hint parseText (initText);
    sleep 10;
	failMission "LOSER";
	

// ====================================================================================