#define PREFIX MGO
#define COMPONENT MAIN

#ifdef DEBUG_ENABLED_MGO_MAIN
	#define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_MGO_MAIN
	#define DEBUG_SETTINGS DEBUG_SETTINGS_MGO_MAIN
#endif

#include "\x\cba\addons\main\script_macros_mission.hpp"

#include "script_settings.hpp"

#define FMAN(var1) TRIPLES(MGO_MAIN,fnc,var1)

#define CALLC(var1) call compile preprocessFileLineNumbers 'var1'

#define LOADCP(var1) call compile preprocessFileLineNumbers 'support\modules\mgo\var1\init.sqf'
