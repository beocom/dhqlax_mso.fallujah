mps_loc_towns = [];
mps_loc_hills = [];
mps_loc_airports = [];
mps_loc_viewpoints = [];
mps_loc_passes = [];
mps_mission_score = 0;

private ["_location"];
//_locations = nearestLocations [[0,0],["Name","NameLocal","NameVillage","NameCity","NameCityCapital","Hill","Airport","ViewPoint"],30000];

{	if( position _x distance getMarkerPos format["respawn_%1",(SIDE_A select 0)] > 1500 ) then {
		switch (type _x) do {
			case "Name": {mps_loc_passes set [count mps_loc_passes, _x];};
			case "NameLocal": {mps_loc_passes set [count mps_loc_passes, _x];};
			case "NameVillage": {mps_loc_towns set [count mps_loc_towns, _x];};
			case "NameCity": {mps_loc_towns set [count mps_loc_towns, _x];};
			case "NameCityCapital": {mps_loc_towns set [count mps_loc_towns, _x];};
			case "Hill": {mps_loc_hills set [count mps_loc_hills, _x];};
			case "Airport": {mps_loc_airports set [count mps_loc_airports, _x];};
			case "ViewPoint": {mps_loc_viewpoints set [count mps_loc_viewpoints, _x];};
		};
	};
} foreach CRB_LOCS;

if(count mps_loc_hills > 0) then {
	_location = (mps_loc_hills call mps_getRandomElement);
	mps_loc_hills = mps_loc_hills - [_location];
	[_location] spawn CREATE_OPFOR_AIRPATROLS;
};

mps_loc_last = mps_loc_towns select 0;

//Adding Comms (off by default)
PO_SUBMENU =
[
["Patrol Ops Menu",false],
["Request tasking", [2], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\checkin_po.sqf' "]], "1", "1"],
["Abort operation", [3], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\abort_po.sqf' "]], "1", "1"]
];

AIROPS_SUBMENU =
[
["Air Ops Menu",false],
["Request tasking", [2], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\checkin_air.sqf' "]], "1", "1"],
["Abort operation", [3], "", -5, [["expression","[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\abort_air.sqf' "]], "1", "1"]
];

OPERATIONS_MAINMENU =
[
["Operations Menu",false],
["Patrol Operations", [2], "#USER:PO_SUBMENU", -5, [["expression", ""]], "0", "1"],
["Air Operations", [3], "#USER:AIROPS_SUBMENU", -5, [["expression", ""]], "0", "1"]
];

//waituntil {!isnil "BIS_MENU_GroupCommunication"};
[BIS_MENU_GroupCommunication, ["Operations Menu",[11],"#USER:OPERATIONS_MAINMENU",-5,[["expression",""]],"1","1"]] call BIS_fnc_arrayPush;

//Check on running tasks for JIP and activate/deactivate comms accordingly
if (isnil "runningmission_po") then {runningmission_po = false};
if (isnil "runningmission_air") then {runningmission_air = false};
if !(runningmission_po) then {
    PO_SUBMENU set [2, ["Abort operation", [3], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\abort_po.sqf' "]], "1", "0"]];
    PO_SUBMENU set [1, ["Request tasking", [2], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\checkin_po.sqf' "]], "1", "1"]];
  
};
if !(runningmission_air) then {
    AIROPS_SUBMENU set [2, ["Abort operation", [3], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\abort_air.sqf' "]], "1", "0"]];
    AIROPS_SUBMENU set [1, ["Request tasking", [2], "", -5, [["expression", "[] call compile preprocessFileLineNumbers 'enemy\modules\roy_patrolops\tasks\checkin_air.sqf' "]], "1", "1"]];
};

//Adding Switches and interaction Menu item
skipPO = false;
switch (MISSIONTYPE_PO) do {
	case 0: {skipPO = true;};
};
if (!skipPO) then {
    //Start Patrol Ops
    ["patrol_ops"] spawn mps_mission_sequence;
    
    //Add Interaction Menu item
    if !(isdedicated) then {["player", [mso_interaction_key], -9408, ["enemy\modules\roy_patrolops\fn_menuDef_patrolops.sqf", "main"]] call CBA_ui_fnc_add;};
	
    //Switch on Comms Menu item
    OPERATIONS_MAINMENU set [1, ["Patrol Operations", [2], "#USER:PO_SUBMENU", -5, [["expression", ""]], "1", "1"]];
};

skipAIR = false;
switch (MISSIONTYPE_AIR) do {
	case 0: {skipAIR = true};
};
if (!skipAIR) then {
    //Start Air Ops
    ["air_ops"] spawn mps_mission_sequence;
    
    //Add Interaction Menu item
    if !(isdedicated) then {["player", [mso_interaction_key], -9407, ["enemy\modules\roy_patrolops\fn_menuDef_airops.sqf", "main"]] call CBA_ui_fnc_add};
	
    //Switch on Comms Menu item
    OPERATIONS_MAINMENU set [2, ["Air Operations", [3], "#USER:AIROPS_SUBMENU", -5, [["expression", ""]], "1", "1"]];
};
