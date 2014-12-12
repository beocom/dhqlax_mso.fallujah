nukeposition = _this select 0;
publicvariable "nukeposition";

[0,[],{
    [nukeposition] execvm "scripts\nuke\nuke_init_all.sqf";
}] call mso_core_fnc_ExMP;

sleep 5;
nukeposition = nil;
publicvariable "nukeposition";