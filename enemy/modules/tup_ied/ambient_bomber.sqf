// Ambient Bomber - create EOD Mod Ambient Bomber module at location
private ["_location","_debug","_victim","_size"];

if !(isServer) exitWith {diag_log "Ambient Bomber Not running on server!";};

_victim = objNull;
_location = _this select 0;
_victim = (_this select 1) select 0;
_size = _this select 2;

_debug = debug_mso;

	if ((isClass(configFile>>"CfgPatches">>"reezo_eod")) && (tup_ied_eod == 1)) then {
		("reezo_eod_suicarea" createUnit [_location, group BIS_functions_mainscope, 
			format ["this setVariable ['reezo_eod_range',[0,%1]];
			this setVariable ['reezo_eod_probability',1];
			this setVariable ['reezo_eod_interval',1];",_size], 0, ""]);
	} else {
		// Create non-eod suicide bomber
		private ["_grp","_skins","_bomber","_pos","_time","_marker"];
//		_grp = createGroup CIVILIAN;
		_grp = createGroup EAST;
		_pos = [_location, 0, _size - 10, 3, 0, 0, 0] call BIS_fnc_findSafePos;

		// Selecting classes from civis
        _bomberfactions = (BIS_alice_mainscope getvariable "townsFaction");
        _skins = [];
        {
    		_faction = _x select 2;
     		if (_faction in _bomberfactions) then {_skins = _skins + [_x select 0]};
		} foreach (BIS_alice_mainscope getvariable "Alice_Classes");
        if (count _skins < 1) then {
          _skins = ["TK_CIV_Takistani01_EP1","TK_CIV_Takistani02_EP1","TK_CIV_Takistani03_EP1","TK_CIV_Takistani04_EP1","TK_CIV_Takistani05_EP1","TK_CIV_Takistani06_EP1","TK_CIV_Worker01_EP1","TK_CIV_Worker02_EP1"];
        };
        
        _skin = _skins call BIS_fnc_selectRandom;
		_bomber = _grp createUnit [_skin, _pos, [], _size, "NONE"];
		_bomber addweapon "EvMoney";
		if (_debug) then {
			diag_log format ["MSO-%1 Suicide Bomber: created at %2", time, _pos];
			_marker = [format ["suic_%1", random 1000], _pos, "Icon", [1,1], "TEXT:", "Suicide", "TYPE:", "Dot", "COLOR:", "ColorRed", "GLOBAL"] call CBA_fnc_createMarker;
			[_marker,_bomber] spawn {
				_marker = _this select 0;
				_bomber = _this select 1;
				while {alive _bomber} do {
					_marker setmarkerpos position _bomber;
					sleep 0.1;
				};
				[_marker] call CBA_fnc_deleteEntity;
			};
		};
		sleep (random 60);
		_victim = units (group _victim) call BIS_fnc_selectRandom;
		_time = time + 600;
		waitUntil {_bomber doMove getposATL _victim; sleep 5; (_bomber distance _victim < 8) || (time > _time) || !(alive _bomber)};
		if ((_bomber distance _victim < 8) && (alive _bomber)) then {
			_bomber addRating -2001;
			_bomber playMoveNow "AmovPercMstpSsurWnonDnon";
			[_bomber, "reezo_eod_sound_akbar"] call CBA_fnc_globalSay3d;
			sleep 5;
			_bomber disableAI "ANIM";
			_bomber disableAI "MOVE";
			diag_log format ["BANG! Suicide Bomber %1", _bomber];
			"Sh_82_HE" createVehicle (getposATL _bomber);
		} else {
			sleep 1;
			if (_debug) then {
				diag_log format ["Deleting Suicide Bomber %1 as out of time or dead.", _bomber];
				[_marker] call CBA_fnc_deleteEntity;
			};
			sleep 120;
			deletevehicle _bomber;
		};
	};
