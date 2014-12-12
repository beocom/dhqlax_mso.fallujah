private ["_leader","_unit","_spawnpos","_units"];
    
	_group = _this select 0;
	_bldgpos = _this select 1;
	_leader = leader _group;
	_units = units _group;

	for "_i" from 0 to ((count _units)-1) do {
		_spawnpos = _bldgpos select floor(random count _bldgpos);
        _spawnpos = [_spawnpos select 0,_spawnpos select 1,(_spawnpos select 2)];
		_unit = (_units select _i);
		_unit setpos _spawnpos;
        _unit setvelocity [0,0,-0.2];
		_unit setUnitPos "Middle";
		if ((getposATL _unit select 2) > 3) then {
        _unit setUnitPos "DOWN"};
	};
    
    [_units] spawn {
			{
        		sleep 20;
        		_x setUnitPos "AUTO";
			} foreach (_this select 0);
	};
    