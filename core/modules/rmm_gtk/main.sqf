private ["_groups","_range","_type","_sleep","_array","_forEachIndex","_functions","_fnc_init"];

if !(isServer) exitWith {};

if(isNil "gtk_cache_header") then { gtk_cache_header = 0; };
if(gtk_cache_header == 0) exitWith{};

_debug = debug_mso;

_groups = allGroups;
_range = 1500; 
_sleep = 3;

if(_debug) then {
	_range = 100;
	_sleep = 1;
};

if(!isNil "gtk_cache_distance") then { _range = gtk_cache_distance; };
if(!isNil "gtk_cache_interval") then {  _sleep = gtk_cache_interval; };
switch(gtk_cache_header) do {
        case 1: {
                _type = "NOUJAY";
        };
        case 2: {
                _type = "CEP";
        };
//        case 3: {
//                _type = "OSOM";
//        };
};

// Check if from the Editor or scripted
if (!isNil "_this") then {
	if (tolower(typename _this) == "object") then {
        	_groups = synchronizedObjects _this;
	        _range = _this getvariable ["range", _range];
        	_type = _this getvariable ["type", _type];
	        _sleep = _this getvariable ["sleep", _sleep];
	} else {
        	if (count _this > 0) then {
		        _groups = _this select 0;
		};
	        if (typeName _groups != "ARRAY") then {
        	        _groups = [group (_this select 0)];
	        };
        
        	if (count _this > 1) then {
                	_range = _this select 1;
	        };
        	if (count _this > 2) then {
                	_type = _this select 2;
	        };
        	if (count _this > 3) then {
                	_sleep = _this select 3;
	        };
	};
};

// Check if all items are group objects
{
        if (tolower(typename _x) != "group") then {
                _groups set [_forEachIndex, group _x];
        };
} foreach _groups;

// If there is init code, execute now
_functions = _type call {
        #include <config.sqf>
};
_fnc_init = _functions select 0;
if(!isNil "_fnc_init") then {
        _array = _groups call _fnc_init;
} else {
        _array = _groups;
};

diag_log format["MSO-%1 GTK Initialised %2 Groups, launching %3 Caching...", time, count _array, _type];

[_array, _range, _type, _sleep] spawn {
        private ["_array","_range","_type","_sleep","_functions","_fnc_sync","_exclude","_cached","_fnc_cache","_fnc_uncache","_fnc_refresh"];
        _array = _this select 0;
        _range = _this select 1;
        _type = _this select 2;
        _sleep = _this select 3;
        
        _functions = _type call {
                #include <config.sqf>
        };
        
        _fnc_sync = _functions select 1;
        _fnc_cache = _functions select 2;
        _fnc_uncache = _functions select 3;
        _fnc_refresh = _functions select 4;
        
        while {count _array > 0} do {
                {
                        _x call _fnc_sync;
                        
                        // Is group deleted?
                        if (isnull _x) then {
                                _array = _array - [_x];
                        } else {
                                _exclude = _x getvariable "rmm_gtk_exclude";
                                if (isNil "_exclude") then {_exclude = false;};
                                
                                _cached = _x getvariable "rmm_gtk_cached";
                                if (isNil "_cached") then {_cached = false;};
                                
                                // Is group excluded from processing?
                                if (!_exclude) then {
                                        // Is group cached?
                                        if (_cached) then {
                                                // Any player within range?
                                                if ([_x, _range] call CBA_fnc_nearPlayer) then {
                                                        _x setvariable ["rmm_gtk_cached", nil];
                                                        _x call _fnc_uncache;
                                                };
                                        } else {
                                                // All players outside 1.1 * range?
                                                if !([_x, _range * 1.1] call CBA_fnc_nearPlayer) then {
                                                        _x setvariable ["rmm_gtk_cached", true];
                                                        _x call _fnc_cache;
                                                };
                                        };
                                };
                        };
                } foreach _array;
                
                sleep _sleep;
                _array = _array call _fnc_refresh;
        };
};

_array;
