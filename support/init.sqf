#include <modules\modules.hpp>

#ifndef execNow
#define execNow call compile preprocessfilelinenumbers
#endif

//player globalChat "Initialise First Aid Fix";
//[] execVM "scripts\firstaidfix.sqf";

#ifdef RMM_REVIVE
if !(isClass(configFile>>"CfgPatches">>"ace_main")) then {
	"Revive" call mso_core_fnc_initStat;
	waitUntil{!isnil "revive_fnc_init"};
	if (!isDedicated) then {
        player call revive_fnc_init;
	};
	if (!isNil "revive_test") then {
        revive_test call revive_fnc_init;
        revive_test setDamage 0.6;
        revive_test call revive_fnc_unconscious;
	};
};
#endif

#ifdef R3F_REVIVE
if !(isClass(configFile>>"CfgPatches">>"ace_main")) then {
    "R3F Revive " call mso_core_fnc_initStat;
	execVM "support\modules\R3F_revive\revive_init.sqf";
};
#endif

#ifdef RMM_AAR
"After Action Reports" call mso_core_fnc_initStat;
execNow "support\modules\rmm_aar\main.sqf";
#endif

#ifdef RMM_CAS
"Close Air Support" call mso_core_fnc_initStat;
execNow "support\modules\rmm_cas\main.sqf";
#endif

#ifdef RMM_CASEVAC
"CASEVAC" call mso_core_fnc_initStat;
execNow "support\modules\rmm_casevac\main.sqf";
#endif

#ifdef CRB_FLIPPABLE
"Flippable Vehicles" call mso_core_fnc_initStat;
execNow "support\modules\crb_flippable\main.sqf";
#endif

#ifdef GC_PACK_COW
"Gen Carver's Pack Cow" call mso_core_fnc_initStat;
execNow "support\modules\gc_pack_cow\main.sqf";
#endif

#ifdef RMM_JIPMARKERS
"JIP Markers" call mso_core_fnc_initStat;
execNow "support\modules\rmm_jipmarkers\main.sqf";
#endif

#ifdef RMM_LOGISTICS
"Logistics" call mso_core_fnc_initStat;
execNow "support\modules\rmm_logistics\main.sqf";
#endif

#ifdef TUP_LOGISTICS
"Logistics Requests" call mso_core_fnc_initStat;
execNow "support\modules\tup_logistics\main.sqf";
#endif

#ifdef R3F_LOGISTICS
"R3F Logistics" call mso_core_fnc_initStat;
execNow "support\modules\R3F_logistics\init.sqf";
#endif

// FOB HQ MultiSpawn
#ifdef WHB_MULTISPAWN
"FOB HQ Multispawn" call mso_core_fnc_initStat;
execNow "support\modules\WHB_Multispawn\main.sqf";
#endif

#ifdef RMM_NOTEBOOK
"Notebook" call mso_core_fnc_initStat;
execNow "support\modules\rmm_notebook\main.sqf";
#endif

#ifdef RMM_RECRUITMENT
"Recruitment" call mso_core_fnc_initStat;
execNow "support\modules\rmm_recruitment\main.sqf";
#endif

#ifdef RMM_TASKS
"JIP Tasks" call mso_core_fnc_initStat;
execNow "support\modules\rmm_tasks\main.sqf";	
#endif

#ifdef CRB_TWNMGR
"Town Manager" call mso_core_fnc_initStat;
execNow "support\modules\crb_twnmgr\main.sqf";	
#endif

#ifdef RMM_TYRES
if !(isClass(configFile>>"CfgPatches">>"ace_main")) then {
	"Tyre Changing" call mso_core_fnc_initStat;
	execNow "support\modules\rmm_tyres\main.sqf";
};
#endif

// AAW INKO Fix
if (isClass(configFile>>"CfgPatches">>"ace_main")) then {
	"AAW INKO Fix" call mso_core_fnc_initStat;
	AAWinf_HelmChangeAnyWhere = true; 
	execNow "support\scripts\ace_aaw_fix.sqf";
};

#ifdef BIS_SOM
"BI Secondary Ops Mgr" call mso_core_fnc_initStat;
execNow "support\modules\bis_som\main.sqf";	
#endif

#ifdef CREWINFO
if(isNil "EnableCrewinfo") then {enablecrewinfo = 1;};
if (enablecrewinfo == 1) then {
	"Crew Info" call mso_core_fnc_initStat;
	fnc_crewInfo = compile preprocessfilelinenumbers "support\modules\crewinfo\main.sqf";
	crewStatus = [] spawn fnc_crewInfo;
};
#endif

#ifdef MGO
if (isClass(configFile>>"CfgPatches">>"ace_main")) then {
"MGO Attach" call mso_core_fnc_initStat;
execNow "support\modules\mgo\main\init.sqf";
};
#endif

#ifdef PXS_SATCOM_OA
"PXS SATCOMs" call mso_core_fnc_initStat;
["ON"] execVM "support\modules\pxs_satcom_oa\init_satellite.sqf";
#endif
