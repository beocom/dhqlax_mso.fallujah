if !(isServer) exitwith {};
private ["_list","_j","_next","_script","_i"];

_list = switch (MISSIONTYPE_PO) do {
	// Town Capture
    case 1: {["SAD_Nuke"]};
	// RTF Tasks
	case 2: {["CAP_target","SAD_camp","SAD_chemical","SAD_depot","SAD_radar","RTF_tower","SAD_bombcar","CRB_convoy"]};
	// Search and Rescue
	case 3: {["SAR_pilot","SAR_pow"]};
	// Mix Easy
	case 4: {["CAP_target","CAP_town","CAP_vehicle","SAD_cache","SAD_camp","SAD_chemical","SAD_depot","SAD_radar","CRB_convoy","SAD_scud","SAD_tower","SAR_pilot","SAD_bombcar"]};
	// Mix Hard
	case 5: {["CAP_target_2","CAP_town","CAP_vehicle","RTF_tower","SAD_camp","SAD_chemical","SAD_depot","SAD_radar","SAD_scud","SAD_tower","SAR_pow","SAD_bombcar","CRB_convoy"]};
	// Capture
	case 6: {["CAP_target","CAP_target_2","CAP_town","CAP_vehicle","SAD_bombcar","CRB_convoy"]};
	// MSO Autotasking
    case 7: {["MSO_Auto"]};
    // MSO Sniper Ops
    case 8: {["SNI_HVT"]};
    
   	default {["CAP_target","CAP_target_2","CAP_town","CAP_vehicle","RTF_tower","SAD_cache","SAD_camp","SAD_chemical","SAD_depot","SAD_radar","SAD_scud","SAR_pilot","SAR_pow","SAD_bombcar","CRB_convoy"]};
};

for "_i" from 1 to MISSIONCOUNT do {
	
    //reset Check-In for everyone and remove action from MHQ again to be sure it's not doubled!
    runningmission_po = false;
    Publicvariable "runningmission_po";
    
    //Activating Request Task option in comms for all localities, Deactivating Abort Task option in comms for all localities 
    [0,[],{
    PO_SUBMENU set [2, ["Abort operation", [3], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\abort_po.sqf' "]], "1", "0"]];
    PO_SUBMENU set [1, ["Request tasking", [2], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\checkin_po.sqf' "]], "1", "1"]];
    }] call mso_core_fnc_ExMP;
      
    //wait for a player to check in
    waitUntil{sleep 1;runningmission_po};
    
    //ok checked in - Deactivating Request Task option in comms for all localities
    [0,[],{
    PO_SUBMENU set [1, ["Request tasking", [2], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\checkin_po.sqf' "]], "1", "0"]];
    PO_SUBMENU set [2, ["Abort operation", [3], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\abort_po.sqf' "]], "1", "1"]];
    }] call mso_core_fnc_ExMP;

    //let mission-setup begin
	_j = (count _list - 1) min (round random (count _list));
	_next = _list select _j;

	mps_mission_status = 1;
	_script = [] execVM format[PO_Path + "tasks\types\%1.sqf",_next];
	if (mps_debug) then {diag_log format ["MSO-%1 PO2: Launching %2 mission", time, _next];};
	runningmission_po = true;
    Publicvariable "runningmission_po";
	while {!(scriptdone _script)} do {sleep 5};
    runningmission_po = false;
    Publicvariable "runningmission_po";
	if (mps_debug) then {diag_log format ["MSO-%1 PO2: %2 mission finished.", time, _next];};
	
	switch (mps_mission_status) do {
		case 2 : {mps_mission_score = mps_mission_score + 1;};
		case 3 : {mps_mission_score = mps_mission_score - 1;};
		default {_i = _i - 1};
	};
	mps_mission_status = 0;
	publicvariable "mps_mission_score";
};