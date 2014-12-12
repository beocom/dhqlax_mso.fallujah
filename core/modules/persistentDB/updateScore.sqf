/* 
 * Filename:
 * updateScore.sqf 
 *
 * Description:
 * Called from initPlayerConnection.sqf
 * Runs on server and updates the player's score
 * 
 * Created by [KH]Jman
 * Creation date: 17/10/2010
 * Email: jman@kellys-heroes.eu
 * Web: http://www.kellys-heroes.eu
 * 
 * */

// ====================================================================================
// MAIN
//	sleep 0.01;	

	_player = _this select 0; 
	_pname = _this select 1; 
	_puid = _this select 2; 
	_score = _this select 3;   
	_globalPlayerScore = _this select 4;
   _seen = _this select 5;

if (pdb_persistentScores_enabled) then {
	   	// zero the score before we deal with it...
		   _player addScore (-(score _player));
		// if using the global score...
		if (pdb_globalScores_enabled) then {
			_player addScore _globalPlayerScore; // add the globalscore
			if (pdb_log_enabled) then {
				 	diag_log format["SERVER MSG: Adding score %1 to %2, playerObject:%3, puid:%4", _globalPlayerScore, _pname, _player, _puid];
			};
		} else {
			_thisscore = _score;
			_player addScore _thisscore;
			if (pdb_log_enabled) then {
				  	diag_log format["SERVER MSG: Adding score %1 to %2, playerObject:%3, puid:%4",_thisscore, _pname, _player, _puid];
			};
		};
};
	_serverData = format["Activating player: %1 ...", _pname];
	PDB_CLIENT_LOADERSTATUS = [_player,_serverData]; publicVariable "PDB_CLIENT_LOADERSTATUS";
		   	
   _thistime = time;
   	waituntil { time > (random 5) + _thistime };

		PDB_ACTIVATEPLAYER = [_player,_pname,_seen]; 
		publicVariable "PDB_ACTIVATEPLAYER";
		diag_log ["PersistentDB: SERVER PV - PDB_ACTIVATEPLAYER: ",  PDB_ACTIVATEPLAYER];
		//diag_log["PersistentDB: UPDATESCORES, time: ", time];
		



// ====================================================================================