if(isNil "settings_maxvd") then {settings_maxvd = 10000;};
if(settings_maxvd != 10000) then {
        [settings_maxvd] spawn {
                while{true} do {
                        if(viewDistance > settings_maxvd) then {
                                setViewDistance settings_maxvd;
                        };
                        sleep 60;
                };
        };
};

if (isdedicated) exitwith {};

["player", [mso_interaction_key], -9400, ["core\modules\rmm_settings\fn_menuDef.sqf", "main"]] call CBA_ui_fnc_add;
["Settings","createDialog ""RMM_ui_settings"""] call mso_core_fnc_updateMenu;