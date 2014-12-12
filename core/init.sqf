#include <modules\modules.hpp>

#ifndef execNow
#define execNow call compile preprocessfilelinenumbers
#endif

private ["_uid"];

//All client should have the Functions Manager initialized, to be sure.
if (isnil "BIS_functions_mainscope") then {
        createCenter sideLogic;
        BIS_functions_mainscope = (createGroup sideLogic) createUnit ["FunctionsManager", [0,0,0], [], 0, "NONE"];
	BIS_fnc_locations = compile preprocessFileLineNumbers "CA\modules\functions\systems\fn_locations.sqf";
};

waitUntil{!isNil "BIS_fnc_init"};

mso_version = "4.55";
diag_log format["MSO-%1 Version: %2", time, mso_version];


    
    FNC_GLOBAL_MESSAGE = {
	   		 if (player != _player) exitWith { };
			_side = _this select 0;
			_msg = _this select 1;
			if(isNil "twnmgr_broadcastMP")then{twnmgr_broadcastMP = 0;};
			if (twnmgr_broadcastMP == 1) then { crossroad=[_side,"HQ"]; crossroad SideChat _msg; };
    };
    
    "GLOBAL_MESSAGE" addPublicVariableEventHandler { (_this select 1) call FNC_GLOBAL_MESSAGE };
    

//Create the comms menu on all machines.
[] call BIS_fnc_commsMenuCreate; 

// Add briefing for MSO
execNow  "core\scripts\briefing.sqf";

//http://community.bistudio.com/wiki/enableSaving
enableSaving [false, false];

CRB_MAPCLICK = "";

"RMM_MPe" addPublicVariableEventHandler {
        private ["_data","_locality","_params","_code"];
        _data = _this select 1;
        _locality = _data select 0;
        _params = _data select 1;
        _code = _data select 2;
        
        if (switch (_locality) do {
                case 0 : {true};
                case 1 : {isserver};
                case 2 : {not isdedicated};
                default {false};
        }) then {
                if (isnil "_params") then {call _code} else {_params call _code};
        };
};

mso_menuname = "Multi-Session Operations";

if (isnil "mso_interaction_key") then {
	mso_interaction_key = [221,[false,false,false]];
};

mso_fnc_hasRadio = {
    if (isClass(configFile>>"CfgPatches">>"ace_main")) then {
        if (player call ACE_fnc_hasRadio) then {true;} else {hint "You require a radio.";false;};
    } else {
        // Thanks Sickboy
        private ["_hasRadio"];
        _hasRadio = false; 
        {
                if (getText(configFile >> "CfgWeapons" >> _x >> "simulation") == "ItemRadio") exitWith { _hasRadio = true };
        } forEach (weapons player);
        if(_hasRadio) then {true} else {hint "You require a radio.";false;};
    };
};

"Mission Parameters" call mso_core_fnc_initStat;
if (!isNil "paramsArray") then {
        diag_log format["MSO-%1 Mission Parameters", time];
        for "_i" from 0 to ((count paramsArray)-1) do {
                missionNamespace setVariable [configName ((missionConfigFile/"Params") select _i),paramsArray select _i];
                diag_log format["MSO-%1    %2 = %3", time, configName ((missionConfigFile/"Params") select _i), paramsArray select _i];
        };
};

if(isNil "debug_mso_setting") then {debug_mso_setting = 0;};
if(debug_mso_setting == 0) then {debug_mso = false; debug_mso_loc = false;};
if(debug_mso_setting == 1) then {debug_mso = true; debug_mso_loc = false;};
if(debug_mso_setting == 2) then {debug_mso = true; debug_mso_loc = true;};
publicvariable "debug_mso";
publicvariable "debug_mso_loc";

"Custom Locations(" + worldName + ")" call mso_core_fnc_initStat;

if (isServer) then {
	["CityCenter",[],debug_mso_loc] call BIS_fnc_locations;
        CRB_LOCS = [] call mso_core_fnc_initLocations;
};

"Player" call mso_core_fnc_initStat;
execNow "core\scripts\init_player.sqf";

#ifdef RMM_MP_RIGHTS
private ["_uid"];
if(isNil "mprightsDisable") then {mprightsDisable = 1;};
if(mprightsDisable == 1) then {
        "MP Rights disabled" call mso_core_fnc_initStat;
        _uid = getPlayerUID player;
        MSO_R_Admin = [_uid];
        MSO_R_Leader = [_uid];
        MSO_R_Officer = [_uid];
        MSO_R_Air = [_uid];
        MSO_R_Crew = [_uid];
} else {
        "MP Rights" call mso_core_fnc_initStat;
        execNow "core\modules\rmm_mp_rights\main.sqf";
};
#endif
if(isNil "mprightsDisable") then {
        "Default Rights" call mso_core_fnc_initStat;
        _uid = getPlayerUID player;
        MSO_R_Admin = [_uid];
        MSO_R_Leader = [_uid];
        MSO_R_Officer = [_uid];
        MSO_R_Air = [_uid];
        MSO_R_Crew = [_uid];
};

#ifdef RMM_DEBUG
"Debug" call mso_core_fnc_initStat;
execNow "core\modules\rmm_debug\main.sqf";
#endif

#ifdef ADMINACTIONS
"Admin Actions" call mso_core_fnc_initStat;
[player] execVM "core\modules\adminActions\main.sqf";
#endif

#ifdef RMM_NOMAD
"NOMAD" call mso_core_fnc_initStat;
execNow "core\modules\rmm_nomad\main.sqf";
#endif

#ifdef persistentDB
"Persistent DB" call mso_core_fnc_initStat;
execNow "core\modules\persistentDB\main.sqf";
#endif

#ifdef RMM_GTK
"Group Tracking" call mso_core_fnc_initStat;
execNow "core\modules\rmm_gtk\main.sqf";
#endif

#ifdef CRB_TIMESYNC
"Time Sync" call mso_core_fnc_initStat;
execNow "core\modules\crb_timesync\main.sqf";
#endif
#ifdef DRN_WEATHER
"DRN Weather" call mso_core_fnc_initStat;
[-1, -1, -1, [-1, -1], debug_mso] execNow "core\modules\DRN_weather\DynamicWeatherEffects.sqf";
#endif

setViewDistance 2500;
setTerrainGrid 25;
#ifdef RMM_SETTINGS
"View Distance Settings" call mso_core_fnc_initStat;
execNow "core\modules\rmm_settings\main.sqf";	
#endif

#ifdef VEHICLEIGNITIONKEYS
"Vehicle Ignition Keys" call mso_core_fnc_initStat;
execNow "core\modules\vehicleIgnitionKeys\main.sqf";
#endif

#ifdef SPYDER_ONU
"Spyder Object Network Updater" call mso_core_fnc_initStat;
execNow "core\modules\spyder_onu\main.sqf";
#endif

"Remove Destroyed Objects" call mso_core_fnc_initStat;
//--- Is Garbage collector running?
if (isnil "BIS_GC") then {
        BIS_GC = (group BIS_functions_mainscope) createUnit ["GarbageCollector", position BIS_functions_mainscope, [], 0, "NONE"];
};
if (isnil "BIS_GC_trashItFunc") then {
        BIS_GC_trashItFunc = compile preprocessFileLineNumbers "ca\modules\garbage_collector\data\scripts\trashIt.sqf";
};
waitUntil{!isNil "BIS_GC"};
BIS_GC setVariable ["auto", true];
