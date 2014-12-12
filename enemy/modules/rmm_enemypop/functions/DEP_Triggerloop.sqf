waituntil {
		{
	        private ["_obj","_pos","_grpt","_grpt","_camp","_grpt2","_AA","_RB","_cleared"];
	        //Using "DEP_locs"-array for quick access [[_obj,[_pos select 0,_pos select 1,_pos select 2]],[_obj,[_pos select 0,_pos select 1,_pos select 2]],...]
			_obj = _x select 0; // Placeholder Object (string), must be created on missionstart
			_pos = position (_x select 0); // Position Array (array)
			_grpt = ((_x select 0) getvariable "groupType") select 0; if (isnil "_grpt") then {_grpt = false}; //Type of Group (array [side,grouptype])
			_camp = ((_x select 0) getvariable "type") select 0; if (isnil "_camp") then {_camp = false}; //Type of Camp (string)
			_grpt2 = ((_x select 0) getvariable "groupType") select 1; if (isnil "_grpt2") then {_grpt2 = false}; // Type of Campguards (array [side,grouptype])
			_AA = ((_x select 0) getvariable "type") select 1; if (isnil "_AA") then {_AA = false}; // AA Flag (bool)
			if (count ((_x select 0) getvariable "type") > 2) then {
				_RB = ((_x select 0) getvariable "type") select 2;
			};
			if (isnil "_RB") then {_RB = false}; // RB Flag (bool)
			_cleared = (_x select 0) getvariable "c"; // cleared position (bool)
	        _suspended = (_x select 0) getvariable "s";
	        
	       if ((isnil "_suspended") && (isnil "_cleared") && {([_pos, rmm_ep_spawn_dist] call fPlayersInside)}) then {
	           
	           [_obj,_pos,_grpt,_camp,_grpt2,_AA,_RB] spawn DEP_MainLoop;
	           _obj setvariable ["s",true];
	       };
	       
		} foreach DEP_LOCS;
	false;
    sleep 2;
};
