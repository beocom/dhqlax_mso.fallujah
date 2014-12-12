//#squint filter Code-block is never called
//#squint filter Expected ; or operator but got ,

private ["_g_nomad","_s_nomad"];
if (isdedicated) exitwith {};

if(isNil "nomadHeader")then{nomadHeader = 1;};
if(isNil "nomadTime")then{nomadTime = 60;};
if(isNil "nomadRespawns")then{nomadRespawns = 999;};
if(isNil "nomadReinforcements")then{nomadReinforcements = 1;};

if (nomadHeader == 0) exitWith{};

waituntil {not isnull player};
waituntil {!isMultiplayer || getplayeruid player != ""};

if (nomadTime == 43200) then {
	// Setup UI option to Save Player State
	["player", [mso_interaction_key], -9450, ["core\modules\rmm_nomad\fn_menuDef.sqf", "main"]] call CBA_ui_fnc_add;
	["SPS","updatePlayerStateNow = true"] call mso_core_fnc_updateMenu;
};

_g_nomad = [
        /*{deaths player} //auto-integrated*/
        {if(nomadClassRestricted == 1) then {typeof player;};},
        {playerSide;},
        {magazines player;},
        {weapons player;},
        {typeof (unitbackpack player);},
        {getmagazinecargo (unitbackpack player);},
        {getweaponcargo (unitbackpack player);},
        {getposATL player;},
        {damage player;},
        {rating player;},
        {score player;},
        {viewdistance;},
        {if(isnil "terraindetail")then{1;}else{terraindetail;};},
        {getDir player;},
        {[vehicle player, driver (vehicle player) == player, gunner (vehicle player) == player, commander (vehicle player) == player];},
        {lifestate player;},
        {rank player;},
        #include <mods\aaw_g.hpp>
        {[group player, (leader player == player)];}
];

_s_nomad = [
        {}, /*auto-integrated*/
        {
                if (nomadClassRestricted == 1 && typeof player != _this) then {_disconnect = true;};
        },
        {
                if (playerSide != _this) then {_disconnect = true;};
        },
        {
                {player removemagazine _x;} foreach (magazines player);
		{player addmagazine _x;} foreach _this;
        },
        {
                {player removeweapon _x;} foreach ((weapons player) + (items player));
				{
					if (isClass(configFile>>"CfgPatches">>"acre_main")) then {
					// Catch any acre radios and store as base radio (do not store radio with ID) http://tracker.idi-systems.com/issues/2
						private ["_ret"];
						_ret = [_x] call acre_api_fnc_getBaseRadio;
						if (typeName _ret == "STRING") then {
							player addweapon _ret;
						} else {
							player addweapon _x;
						};
					} else {
						player addweapon _x;
					};
				} foreach _this;
                player selectweapon (primaryweapon player);
        },
        {
                if (_this != "") then {
                        player addbackpack _this;
                        clearweaponcargo (unitbackpack player);
                        clearmagazinecargo (unitbackpack player);
                };
        },
        {
                for "_i" from 0 to ((count (_this select 0))-1) do {
                        (unitbackpack player) addmagazinecargo [(_this select 0) select _i,(_this select 1) select _i];
                };
        },
        {
                for "_i" from 0 to ((count (_this select 0))-1) do {
                        (unitbackpack player) addweaponcargo [(_this select 0) select _i,(_this select 1) select _i];
                };
        },
        {player setposATL _this;},
        {player setdamage _this;},
        {player addrating (-(rating player) + _this);},
        {player addscore (-(score player) + _this);},
        {setviewdistance _this;},
        {
                setterraingrid ((-10 * _this + 50) max 1);
                terraindetail = _this;
        },
        {player setdir _this;},
        {
                private ["_vehicle"];
                _vehicle = _this select 0;
                if (not isnull _vehicle || _vehicle != player) then {
                        player assignAsCargo _vehicle;
                        player moveInCargo _vehicle;
                        if ((_this select 1) and (isnull(driver _vehicle))) exitwith {
                                player assignAsDriver _vehicle;
                                player moveInDriver _vehicle;
                        };
                        if ((_this select 2) and (isnull(gunner _vehicle))) exitwith {
                                player assignAsGunner _vehicle;
                                player moveInGunner _vehicle;
                        };
                        if ((_this select 3) and (isnull(commander _vehicle))) exitwith {
                                player assignAsCommander _vehicle;
                                player moveInCommander _vehicle;
                        };
                };
        },
        {
                if (tolower(_this) == "unconscious") then {
                        player setUnconscious true;
                };
        },
        {player setunitrank _this;},
        #include <mods\aaw_s.hpp>
        {
                [player] joinSilent (_this select 0);
                if (_this select 1) then {
                        (_this select 0) selectLeader player;
                };
        }
];


if (isClass(configFile>>"CfgPatches">>"ace_main")) then { 
        _g_nomad = _g_nomad + [
                #include <mods\ace_sys_ruck_g.hpp>
                #include <mods\ace_sys_wounds_g.hpp>
                #include <mods\ace_earplugs_g.hpp>
                #include <mods\ace_glasses_g.hpp>
                #include <mods\ace_rangefinder_g.hpp>
                {}
        ];
        
        _s_nomad = _s_nomad + [
                #include <mods\ace_sys_ruck_s.hpp>
                #include <mods\ace_sys_wounds_s.hpp>
                #include <mods\ace_earplugs_s.hpp>
                #include <mods\ace_glasses_s.hpp>
                #include <mods\ace_rangefinder_s.hpp>
                {} 
        ];                
};

[_g_nomad, _s_nomad] execfsm "core\modules\rmm_nomad\nomad.fsm";
