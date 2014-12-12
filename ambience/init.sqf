#include <modules\modules.hpp>

#ifndef execNow
#define execNow call compile preprocessfilelinenumbers
#endif

civilian setFriend [west, 1];
civilian setFriend [east, 1];
civilian setFriend [resistance, 1];

#ifdef CRB_DESTROYCITY
"Destroy City" call mso_core_fnc_initStat;
[] execNow "ambience\modules\crb_destroyCity\main.sqf";
#endif
#ifdef CRB_DOGS
"Dogs" call mso_core_fnc_initStat;
[east] execNow "ambience\modules\crb_dogs\main.sqf";
#endif
#ifdef RMM_CTP
"Call To Prayer" call mso_core_fnc_initStat;
execNow "ambience\modules\rmm_ctp\main.sqf";
#endif
#ifdef CRB_EMERGENCY
"Civilian Emergency Services" call mso_core_fnc_initStat;
execNow "ambience\modules\crb_emergency\main.sqf";
#endif
#ifdef CRB_CIVILIANS
"Ambient Civilians" call mso_core_fnc_initStat;
execNow "ambience\modules\crb_civilians\main.sqf";
#endif
#ifdef CRB_SHEPHERDS
"Shepherds" call mso_core_fnc_initStat;
execNow "ambience\modules\crb_shepherds\main.sqf";
#endif
#ifdef AEG
"Ambient Power Grids" call mso_core_fnc_initStat;
execNow "ambience\modules\AEG\main.sqf";
#endif
#ifdef TUP_SEATRAFFIC
"Ambient Sea" call mso_core_fnc_initStat;
execNow "ambience\modules\tup_seatraffic\main.sqf";
#endif
#ifdef TUP_AIRTRAFFIC
"Ambient Airports" call mso_core_fnc_initStat;
execNow "ambience\modules\tup_airtraffic\main.sqf";
#endif
