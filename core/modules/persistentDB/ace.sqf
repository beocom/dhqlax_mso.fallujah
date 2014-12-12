// ACE DATA MODEL

// Get ACE Data
G_ACE_DATA_PROCEDURE = "UpdatePlayerACE"; 

G_ACE_DATA_PARAMS = ["tawb","tarc","taw","tarm","tawo"];

G_ACE_DATA = [
	{(_this select 0) getVariable ["WOB",""];},
	{(_this select 0) getVariable ["RUCK",""];},  //[(_this select 0)] call ACE_fnc_FindRuck;
	{(_this select 0) getVariable ["WEAPON",""];},
	{(_this select 0) getVariable ["MAGAZINE",""];},
	{(_this select 0) getVariable ["ACE_WOUNDS",""];}
	/* OTHER ACE SETTINGS THAT COULD BE STORED
	{(_this select 0) getVariable ["ace_sys_goggles_earplugs",false];},
	{(_this select 0) getVariable ["ace_sys_goggles_identity",""];},
	{EMP_RF_BAT;}, // Rangefinder */

];

// Set ACE Data
S_ACE_DATA_PROCEDURE = "GetPlayerACE"; 

S_ACE_DATA = [
	{ 	(_this select 1) setVariable ["WOB", _this select 0, true];         
		//(_this select 1) addWeapon (_this select 0);
        [(_this select 1), (_this select 0)] call ACE_fnc_PutWeaponOnBack;}, // ACE Weapon on Back

	{}, // ACE Ruck
		
	{ 	(_this select 1) setVariable ["WEAPON", _this select 0, true];
		if (typename (_this select 0) == "ARRAY") then {
			{
				[(_this select 1), _x select 0, _x select 1] call ACE_fnc_PackWeapon;
			} forEach (_this select 0);
		};}, // ACE Ruck Weapons
		
	
	{ 	(_this select 1) setVariable ["MAGAZINE", _this select 0, true];   
		if (typename (_this select 0) == "ARRAY") then {
			{
				[(_this select 1), _x select 0, _x select 1] call ACE_fnc_PackMagazine;
			} forEach (_this select 0);
		};}, // ACE Ruck Mags
	{
		(_this select 1) setVariable ["ACE_WOUNDS", _this select 0, true];
		if (typename (_this select 0) == "ARRAY") then {
			(_this select 1) setVariable ["ace_w_overall", (_this select 0) select 0, true];
			[(_this select 1), (_this select 0) select 1] call ace_sys_wounds_fnc_addDamage; // ACE Damage
			[(_this select 1),0,(_this select 0) select 2] call ace_sys_wounds_fnc_setHit; // Head
			[(_this select 1),1,(_this select 0) select 3] call ace_sys_wounds_fnc_setHit; // Body
			[(_this select 1),2,(_this select 0) select 4] call ace_sys_wounds_fnc_setHit; // Hands
			[(_this select 1),3,(_this select 0) select 5] call ace_sys_wounds_fnc_setHit; // Legs
			(_this select 1) setVariable ["ace_w_state", (_this select 0) select 6, true];
			(_this select 1) setVariable ["ace_sys_wounds_uncon", (_this select 0) select 7, true];
			(_this select 1) setVariable ["ace_w_bleed", (_this select 0) select 8, true];
			(_this select 1) setVariable ["ace_w_bleed_add", (_this select 0) select 9, true];
			(_this select 1) setVariable ["ace_w_pain", (_this select 0) select 10, true];
			(_this select 1) setVariable ["ace_w_pain_add", (_this select 0) select 11, true];
			(_this select 1) setVariable ["ace_w_epi", (_this select 0) select 12, true];
			(_this select 1) setVariable ["ace_w_nextuncon", (_this select 0) select 13, true];
			(_this select 1) setVariable ["ace_w_unconlen", (_this select 0) select 14, true];
			(_this select 1) setVariable ["ace_w_stab", (_this select 0) select 15, true];
			(_this select 1) setVariable ["ace_w_revive", (_this select 0) select 16, true];
			(_this select 1) setVariable ["ace_w_wakeup", (_this select 0) select 17, true];
			
			/*    _this setVariable ["ace_w_hc", 0]; // heal count
				_this setVariable ["ace_w_healing", false];
				_this setVariable ["ace_w_healing_r", false];
				_this setVariable ["ace_w_stabilizing", false];
				_this setVariable ["ace_w_stabilizing_r", false];

				_this setVariable ["ace_w_falling", false];
				_this setVariable ["ace_w_check", false];
				_this setVariable ["ace_w_requested_help", false];
				_this setVariable ["ace_is_burning", false];
				_this setVariable ["ace_w_busy", false, true];
				
				_this setVariable ["ace_w_cat",false,true];
				_this setVariable ["ace_w_cat_time",0];
				_this setVariable ["ace_w_cat_marked",false,true];
				_this setVariable ["ace_w_cat_bleed_add_restore",0,true];*/
		};
	} // ACE Wounds
];








