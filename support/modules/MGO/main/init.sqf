if(isNil "MGO_Active") then {MGO_Active = 1;};
if (MGO_Active == 0) exitwith {diag_log format["MSO-%1 MGO Attach turned off! Exiting...", time]};
//#define DEBUG_MODE_FULL
#include "script_component.hpp"

diag_log [diag_frameno, diag_ticktime, time, "Executing MGO init.sqf"];

//Params from config
if (isNil {missionNamespace getVariable (configName ((missionConfigFile >> "Params") select 0))}) then {
	if (isNil "paramsArray") then {
	    if (isClass (missionConfigFile/"Params")) then {
	        for "_i" from 0 to (count (missionConfigFile/"Params") - 1) do {
	            _paramName = configName ((missionConfigFile >> "Params") select _i);
	            missionNamespace setVariable [_paramName, getNumber (missionConfigFile >> "Params" >> _paramName >> "default")];
	        };
	    };
	} else {
	    for "_i" from 0 to (count paramsArray - 1) do {
	        missionNamespace setVariable [configName ((missionConfigFile >> "Params") select _i), paramsArray select _i];
	    };
	};
};


/*SECTION REMOVED - WAS FOR OTHER PARTS OF MGO SCRIPT SUITE THAT ARE NOT NEEDED FOR THE ATTACH*/

if (!isDedicated) then {
	["ACE_sys_interaction", "Interaction_Menu", { _this call FUNC(menuopen) }] call CBA_fnc_addKeyHandlerFromConfig;
};

#ifdef MGO_ATTACH_ENAB
LOADCP(attach);
#endif

diag_log [diag_frameno, diag_ticktime, time, "MGO init.sqf processed"];
