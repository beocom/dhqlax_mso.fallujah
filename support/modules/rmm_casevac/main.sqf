if (isdedicated) exitwith {};

//http://forums.bistudio.com/showthread.php?t=92142
RMM_casevac_lines = [
	{[mapGridPosition player]},
	{[str (group player)]},
	{["Urgent","Urgent Surgical","Priority","Routine","Convenience"]},
	{["None","MASH Unit"]},
	{["1","4","7","12","16","23"]},
	{["No Enemy","Possible Enemy","Enemy","Heavy Enemy"]},
	{["Nothing","Chem-lights","IR Strobe","Smoke"]},
	{["BLUFOR Mil","BLUFOR Civ","Mil","Civ","OPFOR"]}
];

RMM_casevac_speed = "NORMAL";
RMM_casevac_behav = "AWARE";
RMM_casevac_flyinheight = 120 + random 380;
RMM_casevac_active = false;

["player", [mso_interaction_key], -9405, ["support\modules\rmm_casevac\fn_menuDef.sqf", "main"]] call CBA_ui_fnc_add;
["CASEVAC","if(call mso_fnc_hasRadio && ((getPlayerUID player) in MSO_R_Leader)) then {createDialog ""RMM_ui_casevac""}"] call mso_core_fnc_updateMenu;
