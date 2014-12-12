_nukepos = _this select 0;

[] execvm "scripts\nuke\nuke_fx_fnc.sqf";
waituntil {!isnil "_nukepos"};

_center = "HeliHempty" createVehicle _nukepos;
waituntil {!isnil "_center"};

/*
if isNil("echo_fallout_decay_rate") then {
	echo_fallout_decay_rate = 1.0;
};

if isNil("echo_fallout_number") then {
	echo_fallout_number = 0;
	publicVariable "echo_fallout_number";
};

if (isNil "echo_logic_center") then {
	echo_logic_center = createCenter sideLogic;
	echo_logic_group = createGroup echo_logic_center;
};

if (isNil "ECHO_FalloutGL") then {
    "Logic" createUnit [[0, 0, 0], echo_logic_group, "ECHO_FalloutGL = this"];
	publicVariable "ECHO_FalloutGL";
};

if (isNil "echo_nuke_fnc_fallout") then {
	echo_nuke_fnc_fallout = compile preprocessFile ("scripts\nuke\nuke_fallout.sqf");
};
*/

if (isserver) then {
    [_nukepos,7200] execvm "scripts\nuke\nuke_damage_server.sqf";
};

if !(isserver) then {
    [_nukepos] execvm "scripts\nuke\nuke_explosion_client.sqf";
    [_nukepos,7200] execvm "scripts\nuke\nuke_radzonefx_client.sqf";
};