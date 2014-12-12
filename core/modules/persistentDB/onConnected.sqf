/* 
 * Filename:
 * playerConnected.sqf 
 *
 * Description:
 * Called from onConnected.sqf
 * Runs on server only
 * 
 * Created by [KH]Jman
 * Creation date: 17/10/2010
 * Email: jman@kellys-heroes.eu
 * Web: http://www.kellys-heroes.eu
 * 
 * */

// ====================================================================================
// MAIN


_id = _this select 0; 
_pname = _this select 1; 
_puid  = _this select 2; 
	

if (( MISSIONDATA_LOADED == "false") && (_pname == "__SERVER__")) then {
	[_id, _pname, _puid] execVM "core\modules\persistentDB\initServerConnection.sqf";
	[_id, _pname, _puid] execVM "core\modules\persistentDB\initPlayerConnection.sqf";
};

// ====================================================================================