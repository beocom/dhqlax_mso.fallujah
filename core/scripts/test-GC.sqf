private ["_gcdist","_pos","_units","_unit","_timeout","_result","_fnc_testStat"];
diag_log format["MSO-%1 Test Garbage Collector Start", time];

_result = true;
_gcdist = 600;

_fnc_testStat = {
        private ["_param","_msg","_verbose"];
	_param = _this select 0;
        _msg = _this select 1;
	_verbose = true;
        if(!_param || _verbose) then {
                diag_log format["MSO-%1 Test Garbage Collector - %2 - %3", time, _msg, _param];
        };
        _param;
};

//--- Execute Functions
if (isnil "bis_fnc_init") then {
	(group player) createunit ["FunctionsManager",[0,0,0],[],0,"none"];
	waitUntil{!isNil "BIS_functions_mainscope"};
};

//--- Is Garbage collector running?
if (isnil "BIS_GC") then {
	BIS_GC = (group BIS_functions_mainscope) createUnit ["GarbageCollector", position BIS_functions_mainscope, [], 0, "NONE"];
};

waitUntil{!isNil "BIS_GC"};
//BIS_GC setVariable ["auto", false];
_result = _result && ([(!isNil "BIS_GC") && (BIS_GC getVariable "auto"), "GC loaded and auto-scavenge set"] call _fnc_testStat);

// Create empty vehicles
_pos = player modelToWorld [0, _gcdist];
_units = [];
_unit = createVehicle ["MTVR", _pos, [], 50, "NONE"];
_units set [count _units, _unit];

_unit = createVehicle ["M1A1", _pos, [], 50, "NONE"];
_units set [count _units, _unit];

_unit = createVehicle ["MH60S", _pos, [], 50, "NONE"];
_units set [count _units, _unit];

// Create units
_unit = (createGroup west) createUnit ["USMC_Soldier", _pos, [], 500, "NONE"];
_units set [count _units, _unit];

waituntil {!isnil "BIS_fnc_init"};
_unit = [player modelToWorld [0, _gcdist + 20], 0, "MTVR", west] call BIS_fnc_spawnVehicle;
_units set [count _units, _unit select 0];

_unit = [player modelToWorld [20, _gcdist], 0, "M1A1", west] call BIS_fnc_spawnVehicle;
_units set [count _units, _unit select 0];

_unit = [player modelToWorld [-20, _gcdist], 0, "MH60S", west] call BIS_fnc_spawnVehicle;
_units set [count _units, _unit select 0];

{
	{_x setDamage 1} forEach units _x;
	_x setDamage 1;
} forEach _units;
_result = _result && ([(count _units > 0), format["Creating destroyed unit(s) & vehicle(s): %1", _units]] call _fnc_testStat);

_timeout = time + 600;

while{time < _timeout && {!isNull _x} count _units > 0} do {
	sleep 5;
};

_result = _result && ({isNull _x} count _units > 0);
if (_result) then {
	diag_log format["MSO-%1 Test Garbage Collector Successful", time];
} else {
	diag_log format["MSO-%1 Test Garbage Collector ***Failed***", time];
};

_result;
