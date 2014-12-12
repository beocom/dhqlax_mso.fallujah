if(!isServer) exitWith{ waitUntil{!isNil "mps_recruit_unittypes"}; };

mps_class_commander = [];
mps_class_tl = [];
mps_class_mg = [];
mps_class_at = [];
mps_class_aa = [];
mps_class_crew = [];
mps_class_pilot = [];
mps_class_eng = [];
mps_class_sniper = [];
mps_opfor_inf = [];
mps_opfor_ins = [];
mps_opfor_leader = [];
mps_opfor_armor = [];
mps_opfor_apc = [];
mps_opfor_aa = [];
mps_opfor_car = [];
mps_opfor_atkh = [];
mps_opfor_atkp = [];
mps_opfor_ncov = [];
mps_opfor_ncoh = [];
mps_ammo_loadable_veh = [];
mps_repair_vehicles = [];
mps_liftchoppers = [];
mps_liftable = [];
mps_transports = [];
mps_transportable_containers = [];
mps_loadable_objects = [];
mps_recruit_unittypes = [];

{
	switch ((_x select 1)) do {
		case "at": { mps_class_at set [count mps_class_at, (_x select 2)]};
		case "cr": { mps_class_crew set [count mps_class_crew, (_x select 2)]};
		case "en": { mps_class_eng set [count mps_class_eng, (_x select 2)]};
		case "mg": { mps_class_mg set [count mps_class_mg, (_x select 2)]};
		case "pi": { mps_class_pilot set [count mps_class_pilot, (_x select 2)]};
		case "sn": { mps_class_sniper set [count mps_class_sniper, (_x select 2)]};
	//	case "so": {  };
		default    {  };
	};

	if( (_x select 0) == (SIDE_A select 1) ) then {
		mps_recruit_unittypes set [count mps_recruit_unittypes, (_x select 2)];
		if( (_x select 1) == "tl") then { mps_blufor_leader set [count mps_blufor_leader, (_x select 2)]; };
	};
	if( (_x select 0) == (SIDE_B select 1) && (_x select 1) in ["aa","at","en","mg","sn","so","tl","na"] ) then {
		mps_opfor_inf set [count mps_opfor_inf, (_x select 2)];
		if( (_x select 1) == "tl") then { mps_opfor_leader set [count mps_opfor_leader, (_x select 2)]; };
	};
	if( (_x select 0) == (SIDE_C select 1) && (_x select 1) in ["aa","at","en","mg","sn","so","tl","na"] ) then {
		mps_opfor_ins set [count mps_opfor_ins, (_x select 2)];
	};
} forEach mps_config_units;

{
	_faction = (_x select 0);
	_class = (_x select 1);

	if( (_x select 0) == (SIDE_B select 1) ) then {
		switch ((_x select 1)) do {
			case "tank": { mps_opfor_armor set [count mps_opfor_armor, (_x select 2)]};
			case "apc": { mps_opfor_apc set [count mps_opfor_apc, (_x select 2)]};
			case "mobiaa": { mps_opfor_aa set [count mps_opfor_aa, (_x select 2)]};
			case "attakc": { mps_opfor_car set [count mps_opfor_car, (_x select 2)]};
			case "attakh": { mps_opfor_atkh set [count mps_opfor_atkh, (_x select 2)]};
			case "attakp": { mps_opfor_atkp set [count mps_opfor_atkp, (_x select 2)]};
			case "cargoc": { mps_opfor_ncov set [count mps_opfor_ncov, (_x select 2)]};
			case "cargoh": { mps_opfor_ncoh set [count mps_opfor_ncoh, (_x select 2)]};
		//	case "cargop": {  };
			default    {  };
		};
	};

	if( (_x select 3) > 0) then { mps_ammo_loadable_veh set [count mps_ammo_loadable_veh, (_x select 2)]};
	if( (_x select 4) > 0) then { mps_repair_vehicles set [count mps_repair_vehicles, (_x select 2)]};
	if( (_x select 5) > 0 && (_x select 2) isKindof "AIR") then {
		mps_liftchoppers set [count mps_liftchoppers, (_x select 2)];
	}else{
		if( (_x select 5) > 0) then { mps_liftable set [count mps_liftable, (_x select 2)]};
	};
	if( (_x select 6) > 0) then { mps_transports set [count mps_transports, (_x select 2)]};
	if( (_x select 7) > 20) then { mps_transportable_containers = mps_transportable_containers + [[(_x select 2),(_x select 7)]]};
	if( (_x select 7) > 0 && (_x select 7) <= 20 && (_x select 1) == "item") then { mps_loadable_objects = mps_loadable_objects + [[(_x select 2),(_x select 7)]]};
} forEach mps_config_vehicles;


publicVariable "mps_class_commander";
publicVariable "mps_class_tl";
publicVariable "mps_class_mg";
publicVariable "mps_class_at";
publicVariable "mps_class_aa";
publicVariable "mps_class_crew";
publicVariable "mps_class_pilot";
publicVariable "mps_class_eng";
publicVariable "mps_class_sniper";
publicVariable "mps_opfor_inf";
publicVariable "mps_opfor_ins";
publicVariable "mps_opfor_leader";
publicVariable "mps_opfor_armor";
publicVariable "mps_opfor_apc";
publicVariable "mps_opfor_aa";
publicVariable "mps_opfor_car";
publicVariable "mps_opfor_atkh";
publicVariable "mps_opfor_atkp";
publicVariable "mps_opfor_ncov";
publicVariable "mps_opfor_ncoh";
publicVariable "mps_ammo_loadable_veh";
publicVariable "mps_repair_vehicles";
publicVariable "mps_liftchoppers";
publicVariable "mps_liftable";
publicVariable "mps_transports";
publicVariable "mps_transportable_containers";
publicVariable "mps_loadable_objects";
publicVariable "mps_recruit_unittypes";