/*
 =======================================================================================================================
Script: Originally BIN_taskDefend.sqf v1.4
Author(s): Binesi, HighHead
Partly based on original code by BIS

Description:
Group will man all nearby static defenses and vehicle turrets and guard/patrol the position and surrounding area.

Parameter(s):
_this select 0: group (Group)
_this select 1: defense position (Array)
_this select 2: Placeholder object (for setting variable) 
    
Returns:
Boolean - success flag

Example(s):
null = [group this,(getPos this),_obj] execVM "HH_taskDefend.sqf"

-----------------------------------------------------------------------------------------------------------------------
Notes:

Needs CBA.
To prevent this script from manning vehicle turrets find and replace "LandVehicle" with "StaticWeapon".
The ideal method would be to write a new FSM and I may attempt that in a future project if no one else does. 

=======================================================================================================================
*/

private ["_grp", "_pos","_loc", "_units"];
_grp = _this select 0;
_pos = position leader _grp;
if (count _this > 1) then {
	_pos = _this select 1;
};

_staticWeapons = nil;
if (count _this > 2) then {
	_loc = _this select 2;
    _staticWeapons = _loc getvariable "statdef";
};
_units = (units _grp) - [leader _grp]; // The leader should not man defenses

if (isnil "_staticWeapons") then {
	private ["_list"];
    _staticWeapons = [];
	_list = _pos nearObjects ["LandVehicle", 50];
	
	// Find all nearby static defenses or vehicles without a gunner
	{
	    if ((_x emptyPositions "gunner") > 0) then 
	    {
	        _staticWeapons set [count _staticWeapons, _x];    
	    };
	} forEach _list;
    if (count _this > 2) then {_loc setvariable ["statdef",_staticWeapons]};
};

_grp setBehaviour "SAFE";
_grp setSpeedmode "LIMITED";
_grp move _pos;

// Have the group man empty static defenses and vehicle turrets
{
    // Are there still units available?
    if ((count _units) > 0) then 
    {
        private ["_unit"];
        _unit = (_units select ((count _units) - 1));
    
        _unit assignAsGunner _x;
        [_unit] orderGetIn true;
        _unit moveInGunner _x;
            
        _units resize ((count _units) - 1);
    };
} forEach _staticWeapons;

// Let the other units patrol until dead or deleted
[_pos,_units] spawn {

    _pos = _this select 0;
    _units = _this select 1;
    
    while {({alive _x} count _units > 0)} do {
        
        sleep random 20;
		{
            if ((random 1 < 0.33) && !((currentCommand _x) in ["ATTACK", "ATTACKFIRE", "FIRE"])) then {
	        	_pospatrol = [_pos, 50] call CBA_fnc_randPos;
                _unit = _units select floor(random ((count _units)-1));
		        _unit domove _pospatrol;
				_unit setSpeedmode "LIMITED";	
        	};
		} foreach _units;
	    sleep (30 + random 10);
	};
};

true;