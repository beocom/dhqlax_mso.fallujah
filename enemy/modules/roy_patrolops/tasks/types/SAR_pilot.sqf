if(count mps_loc_towns < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK SAR_pilot.sqf"];

_location = (mps_loc_towns call mps_getRandomElement);

while {_location == mps_loc_last} do {
	_location = (mps_loc_towns call mps_getRandomElement); 
    sleep 0.1;
};

mps_loc_last = _location;

_position = [(position _location) select 0,(position _location) select 1, 0];
_position = [_position,1500,0.2,3] call mps_getFlatArea;

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];

	_pilotype = "USMC_Soldier_Pilot";
	_choptype = "UH1Y";
	if(mps_oa) then {
		_pilotype = "US_Pilot_Light_EP1";
		_choptype = "AH6X_EP1";
	};

	_crashchopper = _choptype createvehicle (_position);
	_crashchopper setDamage 0.9;
	_crashchopper setFuel 0;
	_crashchopper lock true;
	[_crashchopper] spawn mps_object_c4only;

	_pilotgrp = createGroup west;
	_pilot1 = _pilotgrp createUnit [_pilotype,_position,[],0,"FORM"];
	_pilot1 setPos getPos (nearestObjects [_position,["House"],150] select 0);
	_pilot1 setRank "private";
	_pilot1 allowFleeing 0;
	_pilot1 setDamage 0.5;
	_pilot1 setCaptive true;
	removeAllWeapons _pilot1;
	[nil, _pilot1, "per", rADDACTION, (format ["<t color=""#00FFFF"">Rescue %1</t>",name _pilot1]),(mps_path+"action\mps_unit_join.sqf"), [], 1, true, true, "", ""] call RE;

	(_pilotgrp addWaypoint [position _pilot1,0]) setWaypointType "HOLD";

diag_log format ["SAR_pilot.sqf debug. TaskID: %1, Position: %2",_taskid,_position];

[format["TASK%1",_taskid],
	"URGENT! Rescue Pilot, Destroy Wreckage",
	"A reconnaissance chopper has been shot down after doing surveillance of possible insurgent weapons factories. Search the area, rescue the pilot and use C4 to destroy the wreckage to prevent it falling into enemy hands.<br /> - The pilots may have evacuated to a nearby building for shelter until he can be rescued.",
	true,
	[format["MARK%1",_taskid],(_position),"hd_objective","ColorBlue"," Downed Chopper"],
	"created",
	_position
] call mps_tasks_add;

mps_civilian_intel = []; publicVariable "mps_civilian_intel";

While{!ABORTTASK_PO && _pilot1 distance getMarkerPos format["return_point_%1",(SIDE_A select 0)] > 100 && alive _pilot1 } do {sleep 1};

if(!ABORTTASK_PO && alive _pilot1 && !alive _crashchopper) then {
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
}else{
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
};

	sleep 5;
    deletevehicle _pilot1;
	deleteGroup _pilotgrp;