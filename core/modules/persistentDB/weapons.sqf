// WEAPONS DATA MODEL

// Get Weapons Data
G_WEAPON_DATA_PROCEDURE = "UpdatePlayerWeapons"; 

G_WEAPON_DATA_PARAMS = ["twea","tmag","trck","trwe","trma"];

G_WEAPON_DATA = [
	{weapons  (_this select 0);},
	{magazines  (_this select 0);},
	{typeof (unitbackpack (_this select 0));},
	{getweaponcargo (unitbackpack (_this select 0));},
	{getmagazinecargo (unitbackpack (_this select 0));}
];

// Set Weapons Data
S_WEAPON_DATA_PROCEDURE = "GetPlayerWeapons"; 

S_WEAPON_DATA = [
	{	if (typeName (_this select 0) == "ARRAY") then 
		{
			{
				(_this select 1) removeweapon _x;
			} foreach ((weapons (_this select 1)) + (items (_this select 1)));
			{
				if (isClass(configFile>>"CfgPatches">>"acre_main")) then {
					// Catch any acre radios and restore as base radio (do not restore radio with ID) http://tracker.idi-systems.com/issues/2
					private ["_ret"];
					_ret = [_x] call acre_api_fnc_getBaseRadio;
					if (typeName _ret == "STRING") then {
						(_this select 1) addweapon _ret;
					} else {
						(_this select 1) addweapon _x;
					};
				} else {
					(_this select 1) addweapon _x;
				};
			} foreach (_this select 0);
			if (primaryWeapon (_this select 1) != "") then {
				(_this select 1) selectweapon (primaryweapon (_this select 1));
				_muzzles = getArray(configFile>>"cfgWeapons" >> primaryWeapon (_this select 1) >> "muzzles"); // Fix for weapons with grenade launcher
				(_this select 1) selectWeapon (_muzzles select 0);
				//diag_log format ["muzzle: %1", _muzzles];
			};
		};
	}, // Weapons and Items
		
	{	if (typeName (_this select 0) == "ARRAY") then 
		{
			{
				(_this select 1) removemagazine _x;
			} foreach (magazines (_this select 1));
			{
				(_this select 1) addmagazine _x;
			} foreach (_this select 0) select 0;
			reload (_this select 1);
		};
	}, // Magazines
	{
		if ((_this select 0) != "") then {
			(_this select 1) addbackpack (_this select 0);
			clearweaponcargo (unitbackpack (_this select 1));
			clearmagazinecargo (unitbackpack (_this select 1));
		};
	}, // Ruck
		{if (typeName (_this select 0) == "ARRAY") then 
		{
			for "_i" from 0 to ((count ((_this select 0) select 0))-1) do {
				(unitbackpack (_this select 1)) addweaponcargo [((_this select 0) select 0) select _i,((_this select 0) select 1) select _i];
			};
		};
	}, // Ruck Weapons
	{
		if (typeName (_this select 0) == "ARRAY") then 
		{
			for "_i" from 0 to ((count ((_this select 0) select 0))-1) do {
				(unitbackpack (_this select 1)) addmagazinecargo [((_this select 0) select 0) select _i,((_this select 0) select 1) select _i];
			}
		};
	} // Ruck magazines
];


