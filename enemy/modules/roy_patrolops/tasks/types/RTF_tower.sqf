if(count mps_loc_hills < 1) exitWith{PAPABEAR sideChat format ["%1 this is PAPA BEAR. We have had to postpone the mission due to logistical issues.", group player];};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK RTF_tower.sqf"];

private["_location","_position","_taskid","_container"];

_location = (mps_loc_hills call mps_getRandomElement);
mps_loc_hills = mps_loc_hills - [_location];

_position = [(position _location) select 0,(position _location) select 1, 0];
_position = [_position,50,0.1,2] call mps_getFlatArea;

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];

_grp = [_position,"INF",(5 + random 5),50,"patrol" ] call CREATE_OPFOR_SQUAD;

_container = [format["return_point_%1",(SIDE_A select 0)]] call CREATE_MOVEABLE_TOWER;

[format["TASK%1",_taskid],
	format["Deploy Communications Tower", name _location],
	format["Enemy have destroyed communications for %1. A hill nearby is ideal to deploy a Comms Tower to reconnect the locals.<br/><br/> Move the container at base to the location, unload it and deploy the comms tower.", text _location],
	true,
	[format["MARK%1",_taskid],(_position),"hd_objective","ColorRedAlpha"," Target"],
	"created",
	_position
] call mps_tasks_add;

while {!ABORTTASK_PO && count nearestObjects[ _position, ["Land_Vysilac_FM"], 80] == 0 && damage _container < 1} do { sleep 5 };

sleep 2;

if(!ABORTTASK_PO && count nearestObjects[ _position, ["Land_Vysilac_FM"], 80] > 0) then {
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
}else{
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
};

sleep 60;

deleteVehicle _container;
deleteVehicle (nearestObjects[ _position, ["Land_Vysilac_FM"], 80] select 0);