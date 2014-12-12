
//#squint filter Unknown variable mso_core_fnc_initStat

#include <modules\modules.hpp>
#include <msofactions_defaults.hpp>

#ifndef execNow
#define execNow call compile preprocessfilelinenumbers
#endif

MSO_FACTIONS = [];

if(isNil "faction_RU") then {faction_RU = DEFAULT_RU;};
if(faction_RU == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["RU"];
};
if(isNil "faction_ACE_RU") then {faction_ACE_RU = DEFAULT_ACE_RU;};
if(faction_ACE_RU == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["ACE_VDV","ACE_GRU","ACE_MVD"];
};
if(isNil "faction_INS") then {faction_INS = DEFAULT_INS;};
if(faction_INS == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["INS"];
};
if(isNil "faction_GUE") then {faction_GUE = DEFAULT_GUE;};
if(faction_GUE == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["GUE"];
};
if(isNil "faction_BIS_TK") then {faction_BIS_TK = DEFAULT_BIS_TK;};
if(faction_BIS_TK == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["BIS_TK"];
};
if(isNil "faction_BIS_TK_INS") then {faction_BIS_TK_INS = DEFAULT_BIS_TK_INS;};
if(faction_BIS_TK_INS == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["BIS_TK_INS"];
};
if(isNil "faction_BIS_TK_GUE") then {faction_BIS_TK_GUE = DEFAULT_BIS_TK_GUE;};
if(faction_BIS_TK_GUE == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["BIS_TK_GUE"];
};
if(isNil "faction_CWR2_US") then {faction_CWR2_US = DEFAULT_CWR2_US;};
if(faction_CWR2_US == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["cwr2_us"];
};
if(isNil "faction_CWR2_RU") then {faction_CWR2_RU = DEFAULT_CWR2_RU;};
if(faction_CWR2_RU == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["cwr2_ru"];
};
if(isNil "faction_CWR2_FIA") then {faction_CWR2_FIA = DEFAULT_CWR2_FIA;};
if(faction_CWR2_FIA == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["cwr2_fia"];
};
if(isNil "faction_tigerianne") then {faction_tigerianne = DEFAULT_tigerianne;};
if(faction_tigerianne == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["tigerianne"];
};
if(isNil "faction_ibr_arl_faction") then {faction_ibr_arl_faction = DEFAULT_ibr_arl_faction;};
if(faction_ibr_arl_faction == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["ibr_arl_faction"];
};
if(isNil "faction_ibr_drg_faction") then {faction_ibr_drg_faction = DEFAULT_ibr_drg_faction;};
if(faction_ibr_drg_faction == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["ibr_drg_faction"];
};
if(isNil "faction_ibr_unisol_faction") then {faction_ibr_unisol_faction = DEFAULT_ibr_unisol_faction;};
if(faction_ibr_unisol_faction == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["ibr_unisol_faction"];
};
if(isNil "faction_ibr_venator_faction") then {faction_ibr_venator_faction = DEFAULT_ibr_venator_faction;};
if(faction_ibr_venator_faction == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["ibr_venator_faction"];
};
if(isNil "faction_ibr_police_unit") then {faction_ibr_police_unit = DEFAULT_ibr_police_unit;};
if(faction_ibr_police_unit == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["ibr_police_unit"];
};
if(isNil "faction_LIN_army") then {faction_LIN_army = DEFAULT_LIN_army;};
if(faction_LIN_army == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["LIN_army"];
};
if(isNil "faction_NLA") then {faction_NLA = DEFAULT_NLA;};
if(faction_NLA == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["NLA"];
};
if(isNil "faction_MOL_army") then {faction_MOL_army = DEFAULT_MOL_army;};
if(faction_MOL_army == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["MOL_army"];
};
if(isNil "faction_ibr_rebel_faction") then {faction_ibr_rebel_faction = DEFAULT_ibr_rebel_faction;};
if(faction_ibr_rebel_faction == 1) then {
        MSO_FACTIONS = MSO_FACTIONS + ["ibr_rebel_faction"];
};


if(count MSO_FACTIONS == 0) then {
        
        MSO_FACTIONS = MSO_FACTIONS + ["RU"];
};

#ifdef RMM_ZORA
"ZORA" call mso_core_fnc_initStat;
execNow "enemy\modules\rmm_zora\main.sqf";
#endif

#ifdef TUP_IED
"Ambient IEDs" call mso_core_fnc_initStat;
execNow "enemy\modules\tup_ied\main.sqf";
#endif

#ifdef CRB_TERRORISTS
"Terrorist Cells" call mso_core_fnc_initStat;
execNow "enemy\modules\crb_terrorists\main.sqf";
#endif

#ifdef CQB_POP
"CQB Populator" call mso_core_fnc_initStat;
execNow "enemy\modules\CQB_POP\main.sqf";
#endif

#ifdef RMM_ENEMYPOP
"Enemy Populate" call mso_core_fnc_initStat;
execNow "enemy\modules\rmm_enemypop\main.sqf";
#endif

#ifdef WICT_ENEMYPOP
"WICT Populate" call mso_core_fnc_initStat;
execNow "enemy\modules\wict_enemypop\main.sqf";
#endif

#ifdef RYD_HAC
"Enemy AI Commander" call mso_core_fnc_initStat;
execNow "enemy\modules\ryd_hac\main.sqf";
#endif

#ifdef BIS_WARFARE
"BIS Warfare" call mso_core_fnc_initStat;
execNow "enemy\modules\bis_warfare\main.sqf";
#endif

#ifdef CRB_CONVOYS
"Convoys" call mso_core_fnc_initStat;
execNow "enemy\modules\crb_convoys\main.sqf";
#endif

#ifdef ROY_PATROLOPS
"OCB Patrol Ops" call mso_core_fnc_initStat;
execNow "enemy\modules\roy_patrolops\init.sqf";
#endif


