if (isdedicated) exitwith {};

/*
LDL_init = compile preprocessFileLineNumbers "support\modules\rmm_cas\LDL_ac130\LDL_init.sqf";
[]spawn LDL_init;	
waitUntil {!isNil "LDL_initDone"};
waitUntil {LDL_initDone};
*/

RMM_cas_types = [
	"A10",
	"AH64D",
	"AH1Z"
	//"C130J",
	//"MQ9PredatorB"
];
RMM_cas_lines = [
	{[mapGridPosition player]},
	{[str (group player)]},
	{RMM_cas_types}
];
RMM_cas_missiontime = 540;
RMM_cas_flyinheight = 500;

if (isnil "RMM_cas_frequency") then {
	RMM_cas_frequency = 3600;
	publicvariable "RMM_cas_frequency";
};

if (isnil "RMM_cas_lastTime") then {
	RMM_cas_lastTime = -RMM_cas_frequency;
	publicvariable "RMM_cas_lastTime";
};

["player", [mso_interaction_key], -9406, ["support\modules\rmm_cas\fn_menuDef.sqf", "main"]] call CBA_ui_fnc_add;
["CAS","if(call mso_fnc_hasRadio && ((getPlayerUID player) in MSO_R_Leader)) then {createDialog ""RMM_ui_cas""}"] call mso_core_fnc_updateMenu;