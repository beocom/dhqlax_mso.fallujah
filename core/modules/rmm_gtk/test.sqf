private ["_origpos","_pos","_grp","_result","_fnc_testStat"];
diag_log format["MSO-%1 Test Group Tracker Start", time];

_origpos = position player;
_result = true;

waituntil {!isnil "BIS_fnc_init"};

_fnc_testStat = {
        private ["_param","_msg","_verbose"];
	_param = _this select 0;
        _msg = _this select 1;
	_verbose = true;
        if(!_param || _verbose) then {
                diag_log format["MSO-%1 Test Group Tracker - %2 - %3", time, _msg, _param];
        };
        _param;
};

// Create civilians group outside of range
_pos = player modelToWorld [0, 150];
_grp = [_pos, civilian, (configFile >> "CfgGroups" >> "Civilian" >> "CIV" >> "Infantry" >> "CIV_Crowd")] call BIS_fnc_spawnGroup;
sleep 1;
[[_grp], 100, "DEBUG", 1] call compile preprocessFileLineNumbers "core\modules\rmm_gtk\main.sqf";
sleep 1;
_result = _result && ([(_grp getVariable "rmm_gtk_cached"), "Create and cache group outside of range"] call _fnc_testStat);

// Move player into range
_pos = player modelToWorld [0, 100];
player setPosATL _pos;
sleep 1;
_result = _result && ([(IsNil {_grp getVariable "rmm_gtk_cached"}), "Uncache group when inside of range"] call _fnc_testStat);
player setPosATL _origpos;
_grp call CBA_fnc_deleteEntity;
sleep 1;

// Create civilians group within range
_pos = player modelToWorld [0, 50];
_grp = [_pos, civilian, (configFile >> "CfgGroups" >> "Civilian" >> "CIV" >> "Infantry" >> "CIV_Crowd")] call BIS_fnc_spawnGroup;
sleep 1;
[[_grp], 100, "DEBUG", 1] call compile preprocessFileLineNumbers "core\modules\rmm_gtk\main.sqf";
sleep 1;
_result = _result && ([(IsNil {_grp getVariable "rmm_gtk_cached"}), "Create and uncache group within range"] call _fnc_testStat);

// Move player out of range
_pos = player modelToWorld [0, -100];
player setPosATL _pos;
sleep 1;
_result = _result && ([(_grp getVariable "rmm_gtk_cached"), "Cache group outside of range"] call _fnc_testStat);
player setPosATL _origpos;
_grp call CBA_fnc_deleteEntity;

// Create civilians group outside of range with exclude set to true
_pos = player modelToWorld [0, 150];
_grp = [_pos, civilian, (configFile >> "CfgGroups" >> "Civilian" >> "CIV" >> "Infantry" >> "CIV_Crowd")] call BIS_fnc_spawnGroup;
_grp setVariable ["rmm_gtk_exclude", true];
sleep 1;
[[_grp], 100, "DEBUG", 1] call compile preprocessFileLineNumbers "core\modules\rmm_gtk\main.sqf";
sleep 1;
_result = _result && ([(_grp getVariable "rmm_gtk_exclude") && (IsNil {_grp getVariable "rmm_gtk_cached"}), "Create with exclude set and uncache group when outside of range"] call _fnc_testStat);

// Move player inside range with exclude set
_pos = player modelToWorld [0, 100];
player setPosATL _pos;
sleep 1;
_result = _result && ([(_grp getVariable "rmm_gtk_exclude") && (IsNil {_grp getVariable "rmm_gtk_cached"}), "Uncaching group with exclude set and  inside of range"] call _fnc_testStat);
player setPosATL _origpos;

// Move player outside of range and with exclude set to false
_grp setVariable ["rmm_gtk_exclude", false];
sleep 1;
_result = _result && ([!(_grp getVariable "rmm_gtk_exclude") && (_grp getVariable "rmm_gtk_cached"), "Caching group with exclude false and outside of range"] call _fnc_testStat);

// Move player inside range with exclude set to false
_pos = player modelToWorld [0, 100];
player setPosATL _pos;
sleep 1;
_result = _result && ([!(_grp getVariable "rmm_gtk_exclude") && (IsNil {_grp getVariable "rmm_gtk_cached"}), "Uncaching group with exclude false and inside of range"] call _fnc_testStat);
player setPosATL _origpos;

_grp call CBA_fnc_deleteEntity;

if(_result) then {
        diag_log format["MSO-%1 Test Group Tracker Successful", time];
} else{ 
        diag_log format["MSO-%1 Test Group Tracker ***Failed***", time];
};

_result;
