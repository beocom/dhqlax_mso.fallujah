
private ["_loc","_loctype","_pos","_placeholder","_grptype","_camp","_grptype2","_d","_type"];

_debug = debug_mso;
diag_log format["MSO-%1 PDB EP Population: Starting INIT...", time];

	// Function to convert group into appropriate format (avoiding config > string issues)
	// Set side
	// Set group as [Side,Faction,GroupType,Group]
	DEP_format_group = {
		private ["_grptemp","_var"];
		_grptemp = str ((_this select 0) select 1);
		// Convert group type
		_grptemp = [_grptemp, "bin\config.bin/CfgGroups/", ""] call CBA_fnc_replace;
		_grptemp = [_grptemp, "/"] call CBA_fnc_split;
		// Check for guerrilas...
		if (_grptemp select 0 == "Guerrila") then {
			_grptemp set [0,"resistance"];
		};
		// diag_log format ["_group initialised = %1", _grptemp];
		_grptemp;
	};

//Select Active locations
_DEP_loctypes = ["Hill","Strategic","StrongpointArea","Airport","HQ","FOB","Heliport","Artillery","AntiAir","City","Strongpoint","Depot","Storage","PlayerTrail","WarfareStart","FlatArea", "FlatAreaCity","FlatAreaCitySmall","CityCenter","NameMarine","NameCityCapital","NameCity","NameVillage","NameLocal","fakeTown","ViewPoint","RockArea","VegetationBroadleaf","VegetationFir","VegetationPalm","VegetationVineyard"];
_CRB_locs_tmp = CRB_LOCS;
_DEP_locs_tmp = [];
_timenow = time;

diag_log format["MSO-%1 PDB EP Population: Start collecting locs...!", time];
while {count _DEP_locs_tmp < DEP_ACTIVE_LOCS} do {
    private ["_continue"];

    _loc = _CRB_locs_tmp call BIS_fnc_selectRandom;
    _posLoc = position _loc;
    
    //check if location is too near to an other selected location
    _continue = true;
    if (count _DEP_locs_tmp > 0) then {
	    {
            _dist = _posLoc distance (position _x);
	        if (_dist < DEP_DENSITY) exitwith {_continue = false};
	    } foreach _DEP_locs_tmp;
    };
    
    //if minimum-distance fits, check for some other params and if ok then collect location
	if (
    	(_continue) &&
        {(_posLoc distance getmarkerpos "ammo" > rmm_ep_safe_zone)} &&
        {(_posLoc distance getmarkerpos "ammo_1" > rmm_ep_safe_zone)} &&
        {(type _loc) in _DEP_loctypes}
    ) then {
	    _DEP_locs_tmp set [count _DEP_locs_tmp, _loc];
	    _CRB_locs_tmp = _CRB_locs_tmp - [_loc];
        if (_debug) then {diag_log format["MSO-%1 PDB EP Population: Location %1 at %2 selected...", time,_loc,_posLoc]};
    };
    
    //Failsafe exit
    _timeactual = time;
    if ((_timeactual - _timenow) > 180) exitwith {diag_log format["MSO-%1 PDB EP Population: Collection didnt finish in a timely manner!", time]};
};
_CRB_locs_tmp = nil;
_DEP_loctypes = nil;
diag_log format["MSO-%1 PDB EP Population: Collected %2 locations...!", time, count _DEP_locs_tmp];

DEP_LOCS = [];
for "_i" from 0 to ((count _DEP_locs_tmp)-1) do {
	private ["_loc","_loctype","_pos","_placeholder","_grptype","_camp","_grptype2","_d","_type"];
    
    _loc = _DEP_locs_tmp select _i;
    _loctype = type _loc;
    _pos = position _loc;
	_grptype = nil;
	_AA = false;
	
    	_loctype = type _loc;
    	_pos = position _loc;

    	if ((_loctype == "Hill")) then {
        	_pos = [position _loc, 0, 30, 1, 0, 5, 0] call bis_fnc_findSafePos;
        	_placeholder = "Can_small" createvehicle _pos;
        
			_type = [["Infantry", "Motorized", "Mechanized", "Armored"],[rmm_ep_inf,rmm_ep_mot,rmm_ep_mec,rmm_ep_arm]] call mso_core_fnc_selectRandomBias;
			while {isnil "_grptype"} do {
            	_grptype = [_type, MSO_FACTIONS] call MSO_fnc_getrandomgrouptype;
			};
			_grptype = [_grptype] call DEP_format_group;
    		_placeholder setVariable ["groupType",[_grptype]];
        
        	if (random 1 < ep_campprob) then {
				_camp = [] call mso_fnc_selectcamptype;
            	_pos = [position _loc,200,0.15,5] call rmm_ep_getFlatArea;
            	_grptype2 = ["Infantry", MSO_FACTIONS] call MSO_fnc_getrandomgrouptype;
				_grptype2 = [_grptype2] call DEP_format_group;
				_placeholder setVariable ["groupType", [_grptype] + [_grptype2]];
                
        		if (random 1 < 0.5) then { // Add AA
					_AA = true;
				};
                _placeholder setVariable ["type", [_camp,_AA,false]];                
        	};
        
       		_placeholder setpos [_pos select 0, _pos select 1, -30];
        	DEP_LOCS set [count DEP_LOCS,[_placeholder,0]];
    	};
    
    	if ((_loctype in ["Strategic","StrongpointArea","Airport","HQ","FOB","Heliport","Artillery","AntiAir","City","Strongpoint","Depot","Storage","PlayerTrail","WarfareStart"])) then {
        	_d = 500;
      	  	_pos = [position _loc, 0,_d / 2 + random _d, 1, 0, 5, 0] call bis_fnc_findSafePos;
      		_placeholder = "Can_small" createvehicle _pos;
	
			_type = [["Infantry", "Motorized", "Mechanized", "Armored"],[rmm_ep_inf,rmm_ep_mot,rmm_ep_mec,rmm_ep_arm]] call mso_core_fnc_selectRandomBias;
			while {isnil "_grptype"} do {
            	_grptype = [_type, MSO_FACTIONS] call MSO_fnc_getrandomgrouptype;
			};
			_grptype = [_grptype] call DEP_format_group;
    		_placeholder setVariable ["groupType",[_grptype]];
                        
        	if (random 1 < ep_campprob) then {
            	_camp = [] call mso_fnc_selectcamptype;
            	_pos = [position _loc,200,0.15,5] call rmm_ep_getFlatArea;
            	_grptype2 = ["Infantry", MSO_FACTIONS] call MSO_fnc_getrandomgrouptype;
				_grptype2 = [_grptype2] call DEP_format_group;
				_placeholder setVariable ["groupType", [_grptype] + [_grptype2]];
                
        		if (random 1 < 0.5) then { // Add AA
					_AA = true;
				};
                _placeholder setVariable ["type", [_camp,_AA,false]];                      
        	};

        	_placeholder setpos [_pos select 0, _pos select 1, -30];
        	DEP_LOCS set [count DEP_LOCS,[_placeholder,0]];
    	};
    
    	if ((_loctype in ["FlatArea", "FlatAreaCity","FlatAreaCitySmall","CityCenter","NameMarine","NameCityCapital","NameCity","NameVillage","NameLocal","fakeTown"])) then {
        	_d = 300;
        	_pos = [position _loc, 0,_d / 2 + random _d, 1, 0, 5, 0] call bis_fnc_findSafePos;
        	_placeholder = "Can_small" createvehicle _pos;
        	
        	_type = [["Infantry", "Motorized", "Mechanized", "Armored"],[rmm_ep_inf,rmm_ep_mot,rmm_ep_mec,rmm_ep_arm]] call mso_core_fnc_selectRandomBias;
			while {isnil "_grptype"} do {
            	_grptype = [_type, MSO_FACTIONS] call MSO_fnc_getrandomgrouptype;
			};
			_grptype = [_grptype] call DEP_format_group;
    		_placeholder setVariable ["groupType",[_grptype]];
			
        	if (random 1 < ep_campprob) then {
				_camp = [] call mso_fnc_selectcamptype;
            	_pos = [position _loc,200,0.15,5] call rmm_ep_getFlatArea;
            	_grptype2 = ["Infantry", MSO_FACTIONS] call MSO_fnc_getrandomgrouptype;
				_grptype2 = [_grptype2] call DEP_format_group;
				_placeholder setVariable ["groupType", [_grptype] + [_grptype2]];
                
        		if (random 1 < 0.5) then { // Add AA
					_AA = true;
        		};
        	};
            
            if (((random 1 < 0.8) && (count (_pos nearRoads 500) > 0)) ) then {
				_placeholder setVariable ["type", [_camp,_AA,true]];  
        	} else {
				_placeholder setVariable ["type", [_camp,_AA,false]]; 
			};
      
        	_placeholder setpos [_pos select 0, _pos select 1, -30];
        	DEP_LOCS set [count DEP_LOCS,[_placeholder,0]];
    	};
    
    	if ((_loctype in ["ViewPoint","RockArea","VegetationBroadleaf","VegetationFir","VegetationPalm","VegetationVineyard"])) then {
        	_d = 200;
        	_pos = [position _loc, 0,_d / 2 + random _d, 1, 0, 5, 0] call bis_fnc_findSafePos;
        	_placeholder = "Can_small" createvehicle _pos;
        
        	_type = [["Infantry", "Motorized", "Mechanized", "Armored"],[rmm_ep_inf,rmm_ep_mot,rmm_ep_mec,rmm_ep_arm]] call mso_core_fnc_selectRandomBias;
			while {isnil "_grptype"} do {
            	_grptype = [_type, MSO_FACTIONS] call MSO_fnc_getrandomgrouptype;
			};
			_grptype = [_grptype] call DEP_format_group;
    		_placeholder setVariable ["groupType",[_grptype]];
        
        	if (random 1 < ep_campprob) then {
				_camp = [] call mso_fnc_selectcamptype;
            	_pos = [position _loc,200,0.15,5] call rmm_ep_getFlatArea;
            	_grptype2 = ["Infantry", MSO_FACTIONS] call MSO_fnc_getrandomgrouptype;
				_grptype2 = [_grptype2] call DEP_format_group;
				_placeholder setVariable ["type", [_camp,_AA,false]];
				_placeholder setVariable ["groupType", [_grptype] + [_grptype2]];
        	};

        	_placeholder setpos [_pos select 0, _pos select 1, -30];
        	DEP_LOCS set [count DEP_LOCS,[_placeholder,0]];
    	};
};

diag_log format["MSO-%1 PDB EP Population: Endet INIT! Finalized DEP Locations: %2", time,count DEP_LOCS];