if !(isServer) exitwith {};
private ["_list","_j","_next","_script","_i"];

_list = switch (MISSIONTYPE_AIR) do {
	// Capture
    case 1: {["AIR_SEAD","AIR_strike","AIR_CAP","AIR_scud"]};

	default {["AIR_SEAD","AIR_strike","AIR_CAP","AIR_scud"]};
};

for "_i" from 1 to MISSIONCOUNT do {
	
    //reset missionstatus for everyone on new mission-startup
    runningmission_air = false;
    Publicvariable "runningmission_air";
    
	//activating Req Task option in comms for all localities, DeActivating Abort option in comms for all localities
    [0,[],{
    AIROPS_SUBMENU set [1, ["Request tasking", [2], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\checkin_air.sqf' "]], "1", "1"]];
    AIROPS_SUBMENU set [2, ["Abort operation", [3], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\abort_air.sqf' "]], "1", "0"]];
    }] call mso_core_fnc_ExMP;

    //wait for a player to check in
    waitUntil{sleep 1;runningmission_air};
    
    //Deactivating Request Task option in comms for all localities
    [0,[],{
    AIROPS_SUBMENU set [1, ["Request tasking", [2], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\checkin_air.sqf' "]], "1", "0"]];
    AIROPS_SUBMENU set [2, ["Abort operation", [3], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\abort_air.sqf' "]], "1", "1"]];
    }] call mso_core_fnc_ExMP;

  	//let mission-setup begin  
	_j = (count _list - 1) min (round random (count _list));
	_next = _list select _j;

	mps_mission_status = 1;
	_script = [] execVM format[PO_Path + "tasks\types\%1.sqf",_next];
	if (mps_debug) then {diag_log format ["MSO-%1 PO2: Launching %2 mission", time, _next];};
	runningmission_air = true;
    Publicvariable "runningmission_air";
	while {!(scriptdone _script)} do {sleep 5};
    runningmission_air = false;
    Publicvariable "runningmission_air";
	if (mps_debug) then {diag_log format ["MSO-%1 PO2: %2 mission finished.", time, _next];};
	
	switch (mps_mission_status) do {
		case 2 : {mps_mission_score = mps_mission_score + 1;};
		case 3 : {mps_mission_score = mps_mission_score - 1;};
		default {_i = _i - 1};
	};
	mps_mission_status = 0;
	publicvariable "mps_mission_score";
};
