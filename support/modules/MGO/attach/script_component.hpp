#define PREFIX MGO
#define COMPONENT ATTACH

#ifdef DEBUG_ENABLED_MGO_ATTACH
	#define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_MGO_ATTACH
	#define DEBUG_SETTINGS DEBUG_SETTINGS_MGO_ATTACH
#endif

#include "\x\cba\addons\main\script_macros_mission.hpp"

#include "script_settings.hpp"

#define FMAN(var1) TRIPLES(MGO_MAIN,fnc,var1)
