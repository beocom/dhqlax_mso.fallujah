// PLAYER DATA MODEL

// Get code - i.e. getting player data so we can write it to DB
G_PLAYER_DATA_PARAMS = ["tsc","tpos","tdam","tdhe","tdbo","tdha","tdle","tdir","tsta","tsid","tveh","tsea","ttyp","trat","tvd","ttd","tran","tfir","tek","tck","tfk","tsui","tlif","tdea","ttp","tlc","tld"];

G_PLAYER_DATA_PROCEDURE = "UpdatePlayer";

G_PLAYER_DATA = [
	{if (pdb_globalScores_enabled) then {			
		_loadedPlayerScore =  (_this select 0) getVariable "loadedPlayerScore"; 
        _globalPlayerScore =  (_this select 0) getVariable "globalPlayerScore";
		_otherScores = _globalPlayerScore -_loadedPlayerScore; 
		_score = (score  (_this select 0)) - _otherScores;	
		if (debug_mso) then{
			diag_log format["Saving Score: %1", _score];
		};
		if (typeName _score != "SCALAR") then{
			_score = 0;
		};
		_score;
	  } else {
		score  (_this select 0);
	  }; },
	{getposATL  (_this select 0);},
	{damage  (_this select 0);},
	{ (_this select 0) getVariable "head_hit";},
	{ (_this select 0) getVariable "body";},
	{ (_this select 0) getVariable "hands";},
	{ (_this select 0) getVariable "legs";},
	{getDir  (_this select 0);},
	{	_animState = animationState _player; _animStateChars = toArray _animState; 
		_animP = toString [_animStateChars select 5, _animStateChars select 6, _aniMStateChars select 7]; _thisstance = "";
		switch (_animP) do
		{
			case "erc":
			{
				//diag_log ["player is standing"];
				_thisstance = "Stand";
			};
			case "knl":
			{
				//diag_log ["player is kneeling"];
				_thisstance = "Crouch"; 
			};
			case "pne":
			{
				//diag_log ["player is prone"];
				_thisstance = "Lying";
			};
		}; _thisstance;},
	{ (_this select 0) getVariable "playerSide";},
	{	//diag_log format["vehicle = %1", vehicle (_this select 0)];
		if (vehicle (_this select 0) != (_this select 0)) then { 
			str (vehicle (_this select 0));
		};},
	
	{	_pseat = "";	
		if (vehicle (_this select 0) != (_this select 0)) then { 
			_result = [str(vehicle (_this select 0)), "REMOTE", 0] call CBA_fnc_find;  // http://dev-heaven.net/docs/cba/files/strings/fnc_find-sqf.html
			if ( _result == -1 ) then {
				if (driver (vehicle (_this select 0)) == (_this select 0)) then { _pseat = "driver"; };
				if (gunner (vehicle (_this select 0)) == (_this select 0)) then { _pseat = "gunner"; };
				if (commander (vehicle (_this select 0)) == (_this select 0)) then { _pseat = "commander"; };
			};
		}; _pseat;},
		
	{typeof  (_this select 0);},
	{rating  (_this select 0);},
	{ (_this select 0) getvariable "pviewdistance";},
	{ (_this select 0) getvariable "pterraindetail";},
	{ (_this select 0) getvariable "prank";},
	{ (_this select 0) getVariable "pshotsfired";},
	{ (_this select 0) getVariable "penemykills";},
	{ (_this select 0) getVariable "pcivkills";},
	{ (_this select 0) getVariable "pfriendlykills";},
	{ (_this select 0) getVariable "psuicides";},
	{ lifestate  (_this select 0);},
	{ (_this select 0) getVariable "pdeaths";},
	{ ((_this select 0) getVariable "TimePlayed") + ( time - ((_this select 0) getVariable "connectTime") );},
	{ (_this select 0) getVariable "LastConnected";},
	{ (_this select 0) getVariable "LastDisconnected";}
//    {[group  (_this select 0), (leader  (_this select 0) ==  (_this select 0))];}
];
		
	
// Set Player data - i.e. setting player variables on login (read from DB)
S_PLAYER_DATA_PROCEDURE = "GetPlayer";

S_PLAYER_DATA = [
	{(_this select 1) setVariable ["ID", (_this select 0), false];}, // ID 0
	{(_this select 1) setVariable ["Name", (_this select 0), false];}, // NAME 1
	{(_this select 1) setVariable ["PUID", (_this select 0), false];}, // PUID 2
	{(_this select 1) setVariable ["MissionID", (_this select 0), false];}, // Mission ID	3
	
	{	if (pdb_globalScores_enabled) then {
			(_this select 1) setVariable ["loadedPlayerScore", (_this select 0), true]; 
		};
		if (pdb_persistentScores_enabled) then {
			_p = _this select 1; _s = _this select 0;
			_p addscore (-(score _p) + _s);
		};}, // SCORE 4
		
	{(_this select 1) setVariable ["pPosition", (_this select 0), true];}, // Pos	 5
	
	{if (typeName (_this select 0) == "SCALAR") then {(_this select 1) setdamage (_this select 0);};}, // Damage 6
		
	{if (typeName (_this select 0) == "SCALAR") then {	(_this select 1) setHit ["head_hit", (_this select 0)];
		(_this select 1) setVariable ["head_hit", (_this select 0), true];};}, // 	Head 7
		
	{if (typeName (_this select 0) == "SCALAR") then {	(_this select 1) setHit ["body", (_this select 0)];
		(_this select 1) setVariable ["body", (_this select 0), true];};}, // Body	8
	
	{if (typeName (_this select 0) == "SCALAR") then {	(_this select 1) setHit ["hands", (_this select 0)];
		(_this select 1) setVariable ["hands", (_this select 0), true];};}, //Hands 9
	
	{if (typeName (_this select 0) == "SCALAR") then {	(_this select 1) setHit ["legs", (_this select 0)];
		(_this select 1) setVariable ["legs", (_this select 0), true];};}, 	// Legs	10
	
	{(_this select 1) setdir (_this select 0); (_this select 1) setVariable ["pDirection", (_this select 0), true];},	// Dir	11
	{(_this select 1) setVariable ["pStance", (_this select 0), true];}, //Stance 	12
	{if (str(side (_this select 1)) != (_this select 0)) then {nomadDisconnect = true;} else {(_this select 1) setVariable ["playerSide", (_this select 0), true];};}, //Side	13

	{ (_this select 1) setVariable ["pVehicle", (_this select 0), true]; }, // Vehicle 14
	
	{ (_this select 1) setVariable ["pSeat", (_this select 0), true]; }, // Seat	15

	{(_this select 1) setvariable ["ptype",(_this select 0),true]; if (nomadClassRestricted == 1 && (typeof (_this select 1) != (_this select 0))) then {nomadDisconnect = true;};}, // Type 16
	{(_this select 1) addrating (-(rating (_this select 1)) + (_this select 0));(_this select 1) setVariable ["prating", (_this select 0), true];}, // Rating	17
	{setviewdistance (_this select 0); (_this select 1) setVariable ["pviewdistance", (_this select 0), true];},  // View Distance	18
	
	{	setterraingrid ((-10 * (_this select 0) + 50) max 1); (_this select 1) setVariable ["pterraindetail", (_this select 0), true];
		if !(isDedicated) then {
			terraindetail = (_this select 0);
		};}, // Terrain Detail	19
	
	{ (_this select 1) setunitrank (_this select 0); (_this select 1) setvariable ["prank",(_this select 0),true];}, // Rank	20
	{ (_this select 1) setvariable ["pshotsfired",(_this select 0),true];}, // Shots	21
	{ (_this select 1) setvariable ["penemykills",(_this select 0),true];}, // Enemy Kills	22
	{ (_this select 1) setvariable ["pcivkills",(_this select 0),true];}, // Civ Kills	23
	{ (_this select 1) setvariable ["pfriendlykills",(_this select 0),true];}, //Blue on Blues	24
	{ (_this select 1) setvariable ["psuicides",(_this select 0),true];}, // Suicides	25
	
	{	if (tolower(_this select 0) == "unconscious") then {
			(_this select 1) setUnconscious true;
		};}, // Lifestate	26
		
	{ (_this select 1) setvariable ["pdeaths",(_this select 0),true];}, // Deaths	27
	{ (_this select 1) setVariable ["TimePlayed", (_this select 0), true]; (_this select 1) setVariable ["connectTime", time, true];}, // Time Played	28
	{ },	
	{ (_this select 1) setvariable ["LastDisconnected",(_this select 0),true];}
	
	/*
	{	[(_this select 1)] joinSilent ((_this select 0) select 0);
		if ((_this select 0) select 1) then {
			((_this select 0) select 0) selectLeader (_this select 1);
		};} // Group 29 */
		
];




