// =========================================================================================================
// MPS - MultiPlayer Scripting Framework by [OCB]EightySix
// Version Release 1.02
   diag_log format ["###### %1 MPS.INIT ######", missionName];
   diag_log [diag_frameno, diag_ticktime, time, "Executing init_mps.sqf"];
// =========================================================================================================

// DeBuggint MPS
	if (isnil "debug_mso") then {debug_mso = false};
	if (debug_mso) then {mps_debug = true} else {mps_debug = false};
	
// Declare a mission name and credits
	mps_mission_name = "Patrol Ops 2";
	mps_credits = "Patrol Ops 2 By [OCB]EightySix";

// =========================================================================================================
//	Modify these configs per your preferences
// =========================================================================================================

// Enable A2, Arrowhead, AAW backpack
	mps_a2	= true;		// Set false to turn off A2 content
	mps_oa	= true;		// Set false to turn off OA content
	mps_aaw	= false;	// Set false to turn off AAW Backpack

// Set the sides
// NOTE: make sure side = faction type, e.g. [east,"BIS_US"] will result in US troops killing each other.
// Faction list can be found in the configuration files to choose from which ones to use.

	SIDE_A = [west,"BIS_US"];	// Player Side
        
    if(isNil "PO2_EFACTION") then {PO2_EFACTION = 0};
		PO2_EFACTION = switch(PO2_EFACTION) do {
			case 0: {
				"BIS_TK";
			};
			case 1: {
				"BIS_TK_GUE";
			};
			case 2: {
				"RU";
			};
            case 3: {
				"GUE";
			};
			case 4: {
				"cwr2_ru";
			};
            case 5: {
				"cwr2_fia";
			};
            case 6: {
				"tigerianne";
			};
	};
    
    if(isNil "PO2_IFACTION") then {PO2_IFACTION = 0};
		PO2_IFACTION = switch(PO2_IFACTION) do {
			case 0: {
				"BIS_TK_INS";
			};
            case 1: {
				"BIS_TK_GUE";
			};
			case 2: {
				"INS";
			};
            case 3: {
				"GUE";
			};
	};
        
	SIDE_B = [east,PO2_EFACTION];	// Enemy Side
	SIDE_C = [east,PO2_IFACTION];	// Insurgent Side

// Civillian Types
//	ALICE_MODULE =	["Alice2Manager"];	// Alice = Chernarus, Alice2 = Takistan

// Set total number of expected players
	mps_ref_playercount = 32;	// Max number of players

// =========================================================================================================
//	Only modify these configs if you know what you are doing **** Thanks BON!!!
// =========================================================================================================

	mps_params_armour	= [0,3];	// [min,max] number of armour	vs. player number
	mps_params_aa		= [0,3];	// [min,max] number of anti air	vs. player number
	mps_params_apc		= [0,4];	// [min,max] number of apcs	vs. player number
	mps_params_car		= [2,5];	// [min,max] number of light vehicles	vs. player number
	mps_params_inf		= [2,9];	// [min,max] number of infantry	vs. player number

	mps_params_muliply	= MISSIONDIFF;	// Difficulty Variable from parameters

// =========================================================================================================
//	DO NOT TOUCH CODE BELOW THIS LINE
// =========================================================================================================

// File path folder
	mps_path = PO_Path + "mps\";

// Load the Configruation Variables
	[] call compile preprocessFileLineNumbers (mps_path+"config\config_ammobox.sqf");
	[] call compile preprocessFileLineNumbers (mps_path+"config\config_units.sqf");
	[] call compile preprocessFileLineNumbers (mps_path+"config\config_vehicles.sqf");
	[] call compile preprocessFileLineNumbers (mps_path+"func\mps_func_functions.sqf");

// FUNCTIONS LISTS which are called when needed.
	mps_cleanup			= compile preprocessFileLineNumbers (mps_path+"func\mps_func_cleanup.sqf");
	mps_get_position		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_get_position.sqf");
	mps_getnearbylocation		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_nearbylocation.sqf");
	mps_getEnterableHouses 		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_getenterablehouses.sqf");
	mps_getRandomElement		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_getrandomarrayelement.sqf");
	mps_getArrayPermutation		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_getarraypermutation.sqf");
	mps_getFlatArea 		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_getflatarea.sqf");
	mps_getnearestroad		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_getnearestroad.sqf");
	mps_new_position		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_new_position.sqf");
	mps_object_c4only		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_c4only.sqf");
	mps_random_position		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_random_location.sqf");
	mps_adv_hint			= compile preprocessFileLineNumbers (mps_path+"func\mps_func_advhint.sqf");
	mps_tasks_init			= compile preprocessFileLineNumbers (mps_path+"func\mps_func_taskmaster.sqf");
	mps_patrol_init 		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_patrol_init.sqf");
	mps_spawn_vehicle 		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_spawn_vehicle.sqf");
	mps_object_offset		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_object_offset.sqf");
	mps_mission_sequence		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_mission_sequence.sqf");
    mps_replace_with_ace		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_replace_with_ace.sqf");
	CREATE_OPFOR_SQUAD		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_spawn_opforsquad.sqf");
	CREATE_OPFOR_ARMY		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_spawn_opforarmy.sqf");
	CREATE_OPFOR_STATIC		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_spawn_opforstatic.sqf");
	CREATE_OPFOR_SNIPERS		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_spawn_opforsnipers.sqf");
	CREATE_OPFOR_PARADROP		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_spawn_opforparadrop.sqf");
	CREATE_OPFOR_TOWER		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_spawn_opfortower.sqf");
	CREATE_OPFOR_PATROLS		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_spawn_opforpatrols.sqf");
	CREATE_OPFOR_AIRPATROLS		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_spawn_opforradar.sqf");
	CREATE_MOVEABLE_CONTAINER	= compile preprocessFileLineNumbers (mps_path+"func\mps_func_moveable_container.sqf");
	CREATE_MOVEABLE_TOWER		= compile preprocessFileLineNumbers (mps_path+"func\mps_func_moveable_tower.sqf");

// Dynamic BIS Object spawner
	BIS_fnc_dyno			= compile preprocessFileLineNumbers "ca\modules\dyno\data\scripts\objectMapper.sqf";

// Begin Task sytem by Shuko
	[] call mps_tasks_init;

// Initialise Client and Server to begin calling Functions
	[] execVM (mps_path+"init_mps_server.sqf");
	[] execVM (mps_path+"init_mps_client.sqf");

// Declare MPS initialised
	mps_init = true;
