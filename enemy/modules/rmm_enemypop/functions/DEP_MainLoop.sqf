private ["_pos","_pos2","_grpt","_camp","_grpt2","_AA","_RB","_RBspawned","_obj","_group","_grp2Pos","_grp2","_debug","_cleared","_spawned","_AAspawned","_locunits","_groupPos","_posGrp2","_breakouttimer","_idx","_var","_temp","_suspended"];
                                        
	_obj = _this select 0;
    _pos = _this select 1;
	_grpt = _this select 2;
	_camp = _this select 3; if !(typename _camp == "STRING") then {_camp = nil};
    _grpt2 = _this select 4; if !(typename _grpt2 == "ARRAY") then {_grpt2 = nil};
    _cleared = (_this select 0) getvariable "c";
	if (count (_obj getvariable "type") > 2) then {
		_RB = (_obj getvariable "type") select 2;
	};
	if (isnil "_RB") then {_RB = false}; // RB Flag (bool)
    _spawned = false;
  	_breakouttimer = 0;
	_suspended = true;                               
	_groupDEACTIVATED = nil; _groupDEACTIVATED = _obj getvariable "GRPdeact"; if (isnil "_groupDEACTIVATED") then {_obj setvariable ["GRPdeact",false]};
	_group2DEACTIVATED = nil; _group2DEACTIVATED = _obj getvariable "GRP2deact"; if (isnil "_group2DEACTIVATED") then {_obj setvariable ["GRP2deact",false]};
	_debug = debug_mso;

	if (_debug) then {
		diag_log format["MSO-%1 PDB EP Population: Starting Waituntil-Loop: _obj %2 | _pos %3 | _grpt %4 | _camp %5 | _grpt2 %6 | _AA %7 | _RB %8 | _cleared %9", time, _obj, _pos, _grpt, _camp, _grpt2, _AA, _RB, _cleared];
	};                                                                                                           
	waituntil {
        if (_cleared) exitwith {diag_log format["MSO-%1 PDB EP Population: Failsafe on cleared location %2 triggered...",time, _pos];true};
		if (([_pos, rmm_ep_spawn_dist] call fPlayersInside) && (!_spawned)) then {
			_spawned = true;
			
			//check for groups position, spawn them and let em patrol
			_groupDEACTIVATED = _obj getvariable "GRPdeact";
			if !(_groupDEACTIVATED) then {
				_groupPos = _obj getvariable "groupPos";
		        if (isnil "_groupPos") then {_pos2 = [_pos, 0, 50, 10, 0, 5, 0] call bis_fnc_findSafePos;} else {_pos2 = _groupPos};
				_group = [_pos2, call compile (_grpt select 0), [_grpt] call DEP_convert_group] call BIS_fnc_spawnGroup;
		        (leader _group) setBehaviour "AWARE";
		        _group setSpeedMode "LIMITED";
		        _group setFormation "STAG COLUMN";
		        if (_debug) then {diag_log format["MSO-%1 PDB EP Population: %3 group created %2 (%4)", time, _pos, _grpt, _group];};
		        ep_groups set [count ep_groups, _group];
		                                            
		        if ((isnil "_camp") || count units _group <= 2) then {
		        	[_group,_pos,500,2 + (random 3), "MOVE", "AWARE", "RED", "LIMITED", "STAG COLUMN", "if (dayTime < 18 or dayTime > 6) then {this setbehaviour ""STEALTH""}", [120,200,280]] call CBA_fnc_taskPatrol;
		        } else {
					[_group,_pos,100,4 + random 6, "MOVE", "AWARE", "RED", "LIMITED", "STAG COLUMN", "if (dayTime < 18 or dayTime > 6) then {this setbehaviour ""STEALTH""}", [120,200,280]] call CBA_fnc_taskPatrol;
				};
			};
			
			//spawn camp guards
	        if(!(isnil "_camp")) then {
				_group2DEACTIVATED = _obj getvariable "GRP2deact";
				if !(_group2DEACTIVATED) then {
		            _grp2 = [_pos, call compile (_grpt2 select 0), [_grpt2] call DEP_convert_group] call BIS_fnc_spawnGroup;
		            [_grp2, _pos, _obj] call HH_fnc_taskDefend;
		            if (_debug) then {diag_log format["MSO-%1 PDB EP Population: Guards created %2 (%3)", time, _pos, _grp2];};
		            ep_groups set [count ep_groups, _grp2];
				};
	        };

			//spawn RB once (and only once)
	        if (_RB) then {
				if !(_obj getvariable "RBspawned") then {
					_obj setvariable ["RBspawned",true];
					_RBpos = [_group, _pos] call TUP_fnc_deployRoadblock;
	                diag_log format["MSO-%1 PDB EP Population: Attempted to Deploy Road Block near %2", time, _RBpos];
				};
	        };
		};
                                        
		//store groups data
 		_locunits = [];
 		if (({alive _x} count (units _group)) > 0) then {{_locunits set [count _locunits, _x]} foreach units _group; if !(str(position (leader _group)) == "[0,0,0]") then {_groupPos = position (leader _group); _obj setvariable ["groupPos",_groupPos]}} else {_obj setvariable ["GRPdeact",true]};
 		if (({alive _x} count (units _grp2)) > 0) then {{_locunits set [count _locunits, _x]} foreach units _grp2; if !(str(position (leader _grp2)) == "[0,0,0]") then {_grp2Pos = position (leader _grp2); _obj setvariable ["grp2Pos",_grp2Pos]}} else {_obj setvariable ["GRP2deact",true]};    	
		
		//check for players proximity as the group moves around and delete if players are out of range for more than 20 seconds.
		if (!([_pos, rmm_ep_spawn_dist] call fPlayersInside) && (_spawned)) then {
    		if (_breakouttimer > 20) exitwith {
            	if !(isnil "_group") then {
            		ep_groups = ep_groups - [_group];
            		while {(count (waypoints (_group))) > 0} do {deleteWaypoint ((waypoints (_group)) select 0);};
        			{deletevehicle (vehicle _x); deletevehicle _x} foreach units _group;
        			deletegroup _group;
            		if (_debug) then {diag_log format["MSO-%1 PDB EP Population: Deleting group - player out of range %2 (%3)", time, _pos, _group];}; 
    			};
    			if !(isnil "_grp2") then {
            		ep_groups = ep_groups - [_grp2];
            		while {(count (waypoints (_grp2))) > 0} do {deleteWaypoint ((waypoints (_grp2)) select 0);};
        			{if !((vehicle _x) iskindof "StaticWeapon") then {deletevehicle (vehicle _x)}; deletevehicle _x} foreach units _grp2;
        			deletegroup _grp2;
            		if (_debug) then {diag_log format["MSO-%1 PDB EP Population: Deleting Guards - player out of range %2 (%3)", time, _pos, _grp2];};
    			};
                _breakouttimer = 0;
				_obj setvariable ["s",nil]; _suspended = false;
				true;
        	};
			_breakouttimer = _breakouttimer + 3;
 		};

		//check if groups got killed and exit the loop, the location is cleared then
		if ((count _locunits < 1) && (_spawned)) exitwith {
    		if !(isnil "_group") then {
            	ep_groups = ep_groups - [_group];
            	while {(count (waypoints (_group))) > 0} do {deleteWaypoint ((waypoints (_group)) select 0);};
        		{deletevehicle (vehicle _x); deletevehicle _x} foreach units _group;
        		deletegroup _group;
            	if (_debug) then {diag_log format["MSO-%1 PDB EP Population: Deleting group - Position cleared %2 (%3)", time, _pos, _group];}; 
    		};
    		if !(isnil "_grp2") then {
            	ep_groups = ep_groups - [_grp2];
            	while {(count (waypoints (_grp2))) > 0} do {deleteWaypoint ((waypoints (_grp2)) select 0);};
        		{if !((vehicle _x) iskindof "StaticWeapon") then {deletevehicle (vehicle _x)}; deletevehicle _x} foreach units _grp2;
        		deletegroup _grp2;
            	if (_debug) then {diag_log format["MSO-%1 PDB EP Population: Deleting group - Position cleared %2 (%3)", time, _pos, _grp2];};
    		};
            
            _obj setvariable ["c",true];
			_obj setvariable ["s",nil]; _suspended = false;
			true;
    	};
		sleep (2 + (random 1));
		!(_suspended);
    };
if (_debug) then {diag_log format["MSO-%1 PDB EP Population: Ending Waituntil loop %2 - Thread end...", time, _pos];};