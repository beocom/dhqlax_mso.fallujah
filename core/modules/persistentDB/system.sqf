/* 
 * Filename:
 * system.sqf 
 *
 * Description:
 * PDB scripts
 * 
 * Created by [KH]Jman
 * Creation date: 23/11/2010
 * Email: jman@kellys-heroes.eu
 * Web: http://www.kellys-heroes.eu
 * 
 * */
// ====================================================================================
//	PERSISTENT DB FUNCTIONS
// ====================================================================================
persistent_fnc_convertFormat = compile preprocessfilelinenumbers "core\modules\persistentDB\fn_convertFormat.sqf";

	PDB_FNC_SERVER_LOADERSTATUS = {
			_serverData = _this select 0;
			  if ((ENV_dedicated)  && (pdb_serverError != 1)) then { 
			  	diag_log["PersistentDB: PDB_FNC_SERVER_LOADERSTATUS: ", _serverData];
			  	startLoadingScreen [_serverData, "PDB_loadingScreen"];
			  	 };
	};
// ====================================================================================

	PDB_FNC_SERVER_LOADERERROR = {
				_serverData = _this select 0;			
				  if ((ENV_dedicated) && (pdb_serverError != 1)) then { 
				  	pdb_serverError = 1;
				  	diag_log["PersistentDB: PDB_FNC_SERVER_LOADERERROR: ", _serverData];
				  	startLoadingScreen [_serverData, "PDB_loadingScreen"];
				  	for [{_a=0},{_a < 5000},{_a=_a+1}] do {};
				  	[player] execVM "core\modules\persistentDB\serverConnectionError.sqf";
				  	 };
	};
// ====================================================================================

	PDB_FNC_CLIENT_LOADERSTATUS = {
			  _player = _this select 0;
			  _serverData = _this select 1;
			  if ((ENV_dedicated)  && (pdb_clientError != 1)) then { 
			  	if (player != _player) exitWith { }; // Im not the player so I shouldn't continue
			  	diag_log["PersistentDB: PDB_FNC_CLIENT_LOADERSTATUS: ", _serverData];
			  	startLoadingScreen [_serverData, "PDB_loadingScreen"];
			  	 };
	};
// ====================================================================================

	PDB_FNC_CLIENT_LOADERERROR = {
			_player = _this select 0;
			_serverData = _this select 1;
  			if ((ENV_dedicated) && (pdb_clientError != 1)) then { 
		  	pdb_clientError = 1;
		  	if (player != _player) exitWith { }; // Im not the player so I shouldn't continue
		  	diag_log["PersistentDB: PDB_FNC_CLIENT_LOADERERROR: ", _serverData];
		  	startLoadingScreen [_serverData, "PDB_loadingScreen"];
		  	for [{_a=0},{_a < 5000},{_a=_a+1}] do {};
		  	[player] execVM "core\modules\persistentDB\clientConnectionError.sqf";
		  	 };
	};
// ====================================================================================
	
	PDB_FNC_ACTIVATEPLAYER = {
		   _player = _this select 0;
		   _pname = _this select 1;
			_seen = _this select 2;
			
		   if (player != _player) exitWith { }; // Im not the player so I shouldn't continue
			if (pdb_date_enabled) then {
				if ((count MISSIONDATE) == 5)  then {
						diag_log["PersistentDB: MISSIONDATE: ", MISSIONDATE];
						setdate MISSIONDATE;
				};
			};
			if  (ENV_dedicated) then { 	player setVariable ["loader", "Standby entering game"]; startLoadingScreen [(player getVariable "loader"), "PDB_loadingScreen"]; };	
		   diag_log["PersistentDB: ACTIVATE PLAYER"];		  
		   endLoadingScreen;
		   player allowdamage true; 
		 
		   if (pdb_ace_enabled) then {				
			// set the ace ruck variables now so that they can be saved to the DB even if the 'ace_sys_ruck_changed' has not been fired before the player decides to exit.
				["ace_sys_ruck_changed", {call PDB_FNC_PLAYER_RUCK}] call CBA_fnc_addEventhandler;
				 
				 _ruck = [player] call ACE_fnc_FindRuck;
				 player setVariable ["RUCK", _ruck, true];
				 
				_thisWeaponsList = [player] call ACE_fnc_RuckWeaponsList;
				_thisWeaponsList = [_thisWeaponsList, "write"] call persistent_fnc_convertFormat;
				player setVariable ["WEAPON", _thisWeaponsList, true];
				
				_thisMagazinesList = [player] call ACE_fnc_RuckMagazinesList;
				_thisMagazinesList = [_thisMagazinesList, "write"] call persistent_fnc_convertFormat; 	
				player setVariable ["MAGAZINE", _thisMagazinesList, true];
				
				_thiswob = [player] call ACE_fnc_WeaponOnBackName;
				_lengthThiswob = [_thiswob] call CBA_fnc_strLen;
					if (_lengthThiswob > 0) then {
						 player setVariable ["WOB", _thiswob, true];
					};
					
			// Handle ACE Wounds also
				["ace_sys_wounds_hdeh", {call PDB_FNC_ACE_WOUNDS}] call CBA_fnc_addEventhandler;
				
				// Update player in case they are not wounded or respawned before saving.
				[player,"Player is having wounds initialized."] call PDB_FNC_ACE_WOUNDS;
				
			};
				 
			diag_log["PersistentDB: PLAYER READY: ", name player];

			diag_log["PersistentDB: PLAYER CONNECTED"];
			[pdb_shortmissionName ,  pdb_author] spawn BIS_fnc_infoText;
			diag_log ["PersistentDB: _seen: ",  _seen, typeName _seen];
			
			if (!_seen) then { 
				
				initText = "<br/>Multi-Session Operations<br/><br/>Welcome<br/><t color='#ffff00' size='1.0' shadow='1' shadowColor='#000000' align='center'> "
				+name player+"</t><br/><br/>Your details have been entered into the database.<br/><br/>";
				hintSilent parseText (initText);
			
				// player sideChat format["Welcome %1, your details have been entered into the database",  name player];
				 diag_log ["PersistentDB: New player: ",  (name player), typeName  (name player)];
				 
			} else { 
					
				initText = "<br/>Multi-Session Operations<br/><br/>Welcome back<br/><t color='#ffff00' size='1.0' shadow='1' shadowColor='#000000' align='center'> "
				+name player+"</t><br/><br/>Your details have been retrieved from the database.<br/><br/>";
				hintSilent parseText (initText);
			
				switch (mpdb_teleport_player) do {
					case 2: {
						_pdbPrompt = createDialog "pdbTeleportPrompt";
						noesckey = (findDisplay 1599) displayAddEventHandler ["KeyDown", "if ((_this select 1) == 1) then { true }"]; 
					};
					case 1: {
						[player,1] execVM "core\modules\persistentDB\teleportPlayer.sqf";
					};
					case 0: {
						[player,0] execVM "core\modules\persistentDB\teleportPlayer.sqf";
					};
					default  {
						[player,1] execVM "core\modules\persistentDB\teleportPlayer.sqf";
					};
				};
			
				// player sideChat format["Welcome back %1, your details have been retrieved from the database",  name player];
				diag_log ["PersistentDB: Existing player: ",  (name player), typeName  (name player)]; 
			};
		};	
// ====================================================================================
	PDB_FNC_ACE_WOUNDS = {
		diag_log format ["PDB_FNC_ACE_WOUNDS = %1",_this];
		_player = player;
		
		_aceWounds = [];
		
		_aceWounds = [
				(_player getVariable ["ace_w_overall",0]),
				([_player] call ace_sys_wounds_fnc_getDamage),
				([_player,0] call ace_sys_wounds_fnc_getHit),
				([_player,1] call ace_sys_wounds_fnc_getHit),
				([_player,2] call ace_sys_wounds_fnc_getHit),
				([_player,3] call ace_sys_wounds_fnc_getHit),
				(_player getVariable ["ace_w_state",0]),
				(_player getVariable ["ace_sys_wounds_uncon",false]),
				(_player getVariable ["ace_w_bleed",0]),
				(_player getVariable ["ace_w_bleed_add",0]),
				(_player getVariable ["ace_w_pain",0]),
				(_player getVariable ["ace_w_pain_add",0]),
				(_player getVariable ["ace_w_epi",0]),
				(_player getVariable ["ace_w_nextuncon",-1]),
				(_player getVariable ["ace_w_unconlen",-1]),
				(_player getVariable ["ace_w_stab",1]),
				(_player getVariable ["ace_w_revive",-1]),
				(_player getVariable ["ace_w_wakeup",0])
			];
			
		PDB_ACE_WOUNDS_UPDATE = [player, _aceWounds];
		
		publicVariableServer "PDB_ACE_WOUNDS_UPDATE";
	};
	
	"PDB_ACE_WOUNDS_UPDATE" addPublicVariableEventHandler { 
			if (isServer) then {
				_data = _this select 1;
				_player = _data select 0;
				_thisWounds = _data select 1;
				
				_player setVariable ["ACE_WOUNDS", _thisWounds, true];
			};
	};

// ====================================================================================
	
	PDB_FNC_PLAYER_RUCK = {
		// [_amount,_type,_class]
		_amount = _this select 0;	 //_amount - int, negative or positive count
		_type = _this select 1;       // _type - int, 0 for WOB, 1 for weapon, 2 for magazine
		_class = _this select 2;      //_class - string, class name
		_thisRuckPlayer = player;
		_thisRuckPuid = getPlayerUID player;
		/*
		diag_log ["START PDB_FNC_PLAYER_RUCK"];
		diag_log ["_amount:", _amount, typeName _amount];
		diag_log ["_type:", _type, typeName _type];
		diag_log ["_class:", _class, typeName _class];
		diag_log ["_thisRuckPlayer:", _thisRuckPlayer, typeName _thisRuckPlayer];
		diag_log ["_thisRuckPuid:", _thisRuckPuid, typeName _thisRuckPuid];
		diag_log ["END PDB_FNC_PLAYER_RUCK"];
		*/

		_WeaponsList = [];
		_MagazinesList = [];
		
			switch (_type) do
			{
	   			 case 1:  // weapon
			   {
			   	 _WeaponsList = [_thisRuckPlayer] call ACE_fnc_RuckWeaponsList;
			 //  	 diag_log["_WeaponsList: ", _WeaponsList, typename _WeaponsList];
			   };
			   case 2:  // magazine
			   {	
			   	_MagazinesList = [_thisRuckPlayer] call ACE_fnc_RuckMagazinesList;
		    //   diag_log["_MagazinesList: ", _MagazinesList, typename _MagazinesList];
			   };
			};
			
			_wob = [player] call ACE_fnc_WeaponOnBackName;
		
			_ruck = [player] call ACE_fnc_FindRuck;
			 player setVariable ["RUCK", _ruck, true];

		PDB_PLAYER_RUCK_UPDATE = [player, _amount, _type,_class, _thisRuckPuid,_WeaponsList,_MagazinesList,_wob];
	   publicVariableServer "PDB_PLAYER_RUCK_UPDATE";
	  // diag_log["PersistentDB: PDB_PLAYER_RUCK_UPDATE"];
	};

// ====================================================================================
//  PERSISTENT DB PUBLIC VARIABLE HANDLERS
// ====================================================================================
	"PDB_SAVE_PLAYER" addPublicVariableEventHandler { 
		if (isServer && (persistentDBHeader == 1)) then {
				private "_data";
				_data = _this select 1;
				diag_log ["PersistentDB: SERVER MSG - Saving Player Data, time: ", time];
				[0, (_data select 0), (_data select 1)] call compile preprocessfilelinenumbers "core\modules\persistentDB\onDisconnected.sqf";
		};
	};
	if (pdb_killStats_enabled) then {
		"PDB_PLAYER_UPDATE_KILLS" addPublicVariableEventHandler { 
			if (isServer && (persistentDBHeader == 1)) then {
				_data = _this select 1;
				_player = str(_data select 0); // Player guid
				_weapon = _data select 1;
				_distance = str (_data select 2);
				_fac = str (_data select 3);
				_kill = _data select 4;
				_death = str (_data select 5);
				_pos = [_data select 6, "write"] call persistent_fnc_convertFormat;
				_date = [_data select 7, "write"] call persistent_fnc_convertFormat;
				
				_mid = (MISSIONDATA select 1); // Mission id
		
				// Write Kills data to DB
				_sql = format ["Arma2NETMySQLCommand ['arma', 'INSERT INTO kills (mid,pid,wea,dist,fac,kil,dea,pos,da) values (%1,%2,'%3','%4','%5','%6','%7','%8','%9')']", _mid, _player, _weapon, _distance, _fac, _kill, _death, _pos, _date];
				_result = "Arma2Net.Unmanaged" callExtension _sql;
				
			};
		};
	};
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	"PDB_PLAYER_RUCK_UPDATE" addPublicVariableEventHandler { 
			if (isServer) then {
				_data = _this select 1;
				_player = _data select 0;
				_thisAmount = _data select 1; 
				_thisType = _data select 2;
				_thisClass = _data select 3;
				_thisPuid = _data select 4;
				_thisWeaponsList = _data select 5;
				_thisMagazinesList = _data select 6;
				_thiswob =_data select 7;
		
				switch (_thisType) do
				{
				   case 0:  // WOB
				   {
						//   	diag_log["WOB"];
						if (_thisAmount == 1) then { _player setVariable ["WOB", _thisClass, true]; } else { _player setVariable ["WOB", "", true]; };
				   };
				   
					case 1:  // weapon
				   {
						//   	diag_log["WEAPON"];
						_thisWeaponsList = [_thisWeaponsList, "write"] call persistent_fnc_convertFormat;
						_player setVariable ["WEAPON", _thisWeaponsList, true];
				   };
					case 2:  // magazine
				   {	
				 //  	diag_log["MAGAZINE"];
						_thisMagazinesList = [_thisMagazinesList, "write"] call persistent_fnc_convertFormat;
						_player setVariable ["MAGAZINE", _thisMagazinesList, true];
				   };
				};
				
				// fix for 'inhands"
				_lengthThiswob = [_thiswob] call CBA_fnc_strLen;
				if (_lengthThiswob > 0) then {
					 _player setVariable ["WOB", _thiswob, true];
				};
				
				_player setVariable ["RUCK", _thisClass, true];
			
			};
		};

// ====================================================================================

   "PDB_PLAYER_HANDLER" addPublicVariableEventHandler {
		if (PDB_PLAYER_HANDLED) exitWith {}; // I am already initialized! Is there some other player with the same name or what?
	
		_data = _this select 1;
				
			if (name player == _data select 1) then {
				
				// parse the data

				// Add Datamodel actions together
				_dataModel = [];
				_newArray = [];
				{
					call compile format["_newArray = %1", _x];
					_dataModel = _dataModel + _newArray;
				} foreach PDB_CLIENT_SET_DATA;
				
				// Read in player data to client side player object
				_i = 0;
				{
					// Set data on client side player object
					[_data select _i, player] call (_dataModel select _i);
					// Log Data
					if (pdb_log_enabled) then {	
						diag_log format["PersistentDB: Database player: %1 - Data %3: %2", name player, _data select _i, _i];
					};
					// Next attribute
					_i =_i + 1;
				} foreach _data;
			
				PDB_PLAYER_HANDLED = true; // Flag to set that I am initialized.
			};
	};
	
// ====================================================================================
//	PERSISTENT DB HANDLERS
// ====================================================================================	
    "PDB_ACTIVATEPLAYER" addPublicVariableEventHandler { (_this select 1) call PDB_FNC_ACTIVATEPLAYER };
    "PDB_SERVER_LOADERSTATUS" addPublicVariableEventHandler { (_this select 1) call PDB_FNC_SERVER_LOADERSTATUS };
    "PDB_SERVER_LOADERERROR" addPublicVariableEventHandler { (_this select 1) call PDB_FNC_SERVER_LOADERERROR };
    "PDB_CLIENT_LOADERSTATUS" addPublicVariableEventHandler { (_this select 1) call PDB_FNC_CLIENT_LOADERSTATUS };
    "PDB_CLIENT_LOADERERROR" addPublicVariableEventHandler { (_this select 1) call PDB_FNC_CLIENT_LOADERERROR };
// ====================================================================================	

// MISC FUNCTIONS
	reverseArray = {
		 private ["_r","_c"];
		 _r = [];
		 _c = (count _this select 0) -1;
		 {
		  _r set [_c,_x];
		  _c = _c -1 ;
		 } foreach _this select 0;
		 _r;
	};
// ====================================================================================	

	searchArray = { 
		// usage:  _key = [getPlayerUID player, CONNECTEDPLAYERS] call searchArray;
		private ["_needle","_haystack","_key","_notString","_i"];
		_needle = _this select 0;
		_haystack = _this select 1; 		
		_notString = _this select 2;
/*
		diag_log["_this: ", _this];
	    diag_log["_needle: ", _needle];
		diag_log["_haystack: ", _haystack];
		diag_log["_notString: ", _notString];
*/
		_key = -1;
		
			for [{_i=0},{_i < count _haystack},{_i=_i+1}] do 	
			{
				
		//	diag_log["loop: ", _i];	
			
			if (!_notString) then { 
				 _thisHaystack = _haystack select _i;
/* 
				diag_log["_notString: ", _notString];
				diag_log["_thisHaystack: ", _thisHaystack];	
				diag_log["_thisHaystack type: ", typeName _thisHaystack];				
				diag_log["_needle: ", _needle];
				diag_log["_needle type: ", typeName _needle];		 
*/
				if (_thisHaystack == _needle) then  {			
//		diag_log["PASS"];
				 _key = _i;
				};
				  } else { 
					_thisHaystack = (str(_haystack select _i)); 
/*
					diag_log["_notString: ", _notString];
					diag_log["_thisHaystack: ", _thisHaystack];	
					diag_log["_thisHaystack type: ", typeName _thisHaystack];				
					diag_log["_needle: ", _needle];
					diag_log["_needle type: ", typeName _needle];		
*/
				if (_thisHaystack == _needle) then  {			
	//	diag_log["PASS"];
				 _key = _i;
				};		
				};
			};
		_key;
	};
// ====================================================================================
	searchMultiDimensionalArray = { 
		// usage:  _key = [ARRAY, 0, 1, "Jman"] call searchMultiDimensionalArray;
		// if not found returns -1
		private ["_array","_element","_lstsize","_i","_entry","_nestedvalue","_index","_locinarray","_start","_JayArma2lib_log"];
		_array      = _this select 0;  // the multi-d
		_start      = _this select 1;  // key number of the multi-d to start searching from
		_locinarray = _this select 2;  // element location in array to look
		_element    = _this select 3;  // value to search for

		_index    = -1;
		_lstsize  = count _array;
		_i        = _start;

		while {(_i < _lstsize)} do {
		  _entry = _array Select _i;
		   _nestedvalue = _entry Select _locinarray;
		   
		  //	diag_log["_nestedvalue: ", _nestedvalue];
		  //	diag_log["_element: ", _element];
		   
		  if (_nestedvalue == _element) then {
			_index=_i;
			_i = _lstsize;
		  };
		  _i=_i+1;
		};
		_index;
	};
	// ====================================================================================
	searchMultiDimensionalArrayWhere = { 
		// (TWO where ELEMENTS)
		// usage:  _key = [ARRAY, 0, 2, 7, 1, "'" + _puid + "'", _missionid, "'" + _pname + "'"] call searchMultiDimensionalArrayWhere;
		// if not found returns -1
		private ["_array","_element","_where","_andwhere","_lstsize","_i","_entry","_nestedvalue","_nestedvalueWhere","_nestedvalueAndWhere","_index","_locinarray","_locinarrayWhere","_locinarrayAndWhere","_start","_JayArma2lib_log"];
		_array = _this select 0;  // the multi-d
		_start = _this select 1;  // key number of the multi-d to start searching from
		_locinarray = _this select 2;  // element location in array to look
		_locinarrayWhere = _this select 3;  // where element location in array to look
		_locinarrayAndWhere = _this select 4;  // and where element location in array to look
		_element = _this select 5;  // value to search for
		_where = _this select 6;  // value of where element
		_andwhere = _this select 7;  // value of and where element
		
		_where = [_where, "'", ""] call CBA_fnc_replace; 
		
	//	diag_log ["_element:", _element, typeName _element];
	//	diag_log ["_where:", _where, typeName _where];
	//	diag_log ["_andwhere:", _andwhere, typeName _andwhere]; 

		_index    = -1;
		_lstsize  = count _array;
		_i        = _start;

		while { (_i < _lstsize) } do {
			
		   _entry = _array Select _i;
		   _nestedvalue = _entry select _locinarray;
		   _nestedvalueWhere = _entry select _locinarrayWhere;
		   _nestedvalueAndWhere = _entry select _locinarrayAndWhere;
		   
		  if (((_nestedvalue == _element) && (_nestedvalueWhere == _where) &&  (_nestedvalueAndWhere == _andwhere))) then {
			_index=_i;
			_i = _lstsize;
		  };
		  _i=_i+1;
		};
		_index;
	};
// ====================================================================================	