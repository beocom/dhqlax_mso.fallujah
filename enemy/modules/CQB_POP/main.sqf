if (isnil "CQB_spawn") then {CQB_spawn = 10};
if (CQB_spawn == 0) exitwith {diag_log format["MSO-%1 CQB Population turned off! Exiting...", time]};

if (isnil "CQBaicap") then {CQBaicap = 2};
switch (CQBaicap) do {
    case 0: {CQB_AUTO = true; CQBaiBroadcast = true};
    case 1: {CQBaicap = 15; CQBaiBroadcast = false};
    case 2: {CQBaicap = 25; CQBaiBroadcast = false};
    case 3: {CQBaicap = 50; CQBaiBroadcast = false};
    case 4: {CQBaicap = 100; CQBaiBroadcast = false};
    case 5: {CQB_AUTO = true; CQBaiBroadcast = false};
	default {CQBaicap = 15; CQBaiBroadcast = false};
};
if (isnil "CQBmaxgrps") then {CQBmaxgrps = 50};
_debug = debug_mso;

diag_log format["MSO-%1 CQB Population: starting to load functions...", time];
if (isnil "BIN_fnc_taskDefend") then {BIN_fnc_taskDefend = compile preprocessFileLineNumbers "enemy\scripts\BIN_taskDefend.sqf"};
if (isnil "BIN_fnc_taskPatrol") then {BIN_fnc_taskPatrol = compile preprocessFileLineNumbers "enemy\scripts\BIN_taskPatrol.sqf"};
if (isnil "BIN_fnc_taskSweep") then {BIN_fnc_taskSweep = compile preprocessFileLineNumbers "enemy\scripts\BIN_taskSweep.sqf"};
if (isnil "MSO_fnc_CQBclientloop") then {MSO_fnc_CQBclientloop = compile preprocessFileLineNumbers "enemy\modules\CQB_POP\functions\MSO_fnc_CQBclientloop.sqf"};
if (isnil "CQB_findnearhousepos") then {CQB_findnearhousepos = compile preprocessFileLineNumbers "enemy\modules\CQB_POP\functions\CQB_findnearhousepos.sqf"};
if (isnil "CQB_setposgroup") then {CQB_setposgroup = compile preprocessFileLineNumbers "enemy\modules\CQB_POP\functions\CQB_setposgroup.sqf"};
if (isnil "CQB_houseguardloop") then {CQB_houseguardloop = compile preprocessFileLineNumbers "enemy\modules\CQB_POP\functions\CQB_houseguardloop.sqf"};
if (isnil "CQB_patrolloop") then {CQB_patrolloop = compile preprocessFileLineNumbers "enemy\modules\CQB_POP\functions\CQB_patrolloop.sqf"};
if (isnil "MSO_fnc_CQBspawnRandomgroup") then {MSO_fnc_CQBspawnRandomgroup = compile preprocessFileLineNumbers "enemy\modules\CQB_POP\functions\MSO_fnc_CQBspawnRandomgroup.sqf"};
if (isnil "MSO_fnc_CQBmovegroup") then {MSO_fnc_CQBmovegroup = compile preprocessFileLineNumbers "enemy\modules\CQB_POP\functions\MSO_fnc_CQBmovegroup.sqf"};
if (isnil "MSO_fnc_getEnterableHouses") then {MSO_fnc_getEnterableHouses = compile preprocessFileLineNumbers "enemy\modules\CQB_POP\functions\MSO_fnc_getEnterableHouses.sqf"};
if (isnil "MSO_fnc_CQBgetSpawnposRegular") then {MSO_fnc_CQBgetSpawnposRegular = compile preprocessFileLineNumbers "enemy\modules\CQB_POP\functions\MSO_fnc_CQBgetSpawnposRegular.sqf"};
if (isnil "MSO_fnc_CQBgetSpawnposStrategic") then {MSO_fnc_CQBgetSpawnposStrategic = compile preprocessFileLineNumbers "enemy\modules\CQB_POP\functions\MSO_fnc_CQBgetSpawnposStrategic.sqf"};
if (isnil "MSO_fnc_CQBhousepos") then {MSO_fnc_CQBhousepos = compile preprocessFileLineNumbers "enemy\modules\CQB_POP\functions\MSO_fnc_CQBhousepos.sqf"};
if (isnil "getGridPos") then {getGridPos = compile preprocessFileLineNumbers "enemy\modules\CQB_POP\functions\getGridPos.sqf"};
if (isnil "CQB_GCS") then {CQB_GCS = compile preprocessFileLineNumbers "enemy\modules\CQB_POP\functions\CQB_GCS.sqf"};
diag_log format["MSO-%1 CQB Population: loaded functions...", time];

if (isServer) then {
_center = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
_spawnhouses = [_center,CRB_LOC_DIST] call MSO_fnc_getEnterableHouses;
CQBpositionsStrat = [_spawnhouses] call MSO_fnc_CQBgetSpawnposStrategic;
CQBpositionsReg = [_spawnhouses] call MSO_fnc_CQBgetSpawnposRegular;

Publicvariable "CQBpositionsStrat";
Publicvariable "CQBpositionsReg";

[] spawn CQB_GCS;
};

if !(isDedicated) then {
	[_debug] spawn MSO_fnc_CQBclientloop;
};
