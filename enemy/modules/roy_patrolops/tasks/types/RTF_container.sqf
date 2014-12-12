if(count mps_loc_towns < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK RTF_container.sqf"];

private["_location","_position","_taskid","_cont1","_cont2"];

_location = (mps_loc_towns call mps_getRandomElement);
while {_location == mps_loc_last } do {
    _location = (mps_loc_towns call mps_getRandomElement);
	sleep 0.1;
};
mps_loc_last = _location;

_position = [(position _location) select 0,(position _location) select 1, 0];
_position = position ([_position] call mps_getnearestroad);

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];

_cont1 = [format["return_point_%1",(SIDE_A select 0)]] call CREATE_MOVEABLE_CONTAINER;
_cont2 = [format["return_point_%1",(SIDE_A select 0)]] call CREATE_MOVEABLE_CONTAINER;

_grp = [_position,"INS",(5 + random 5),50,"patrol" ] call CREATE_OPFOR_SQUAD;

[format["TASK%1",_taskid],
	format["Deliver Supplies to %1", text _location],
	format["Two Shipping Containers full of supplies have been delivered to the Base. Transport them safely by truck to %1.<br/><br/>To Transport: move a truck close to the containers and you will get the option to load them. Beware when unloading as Containers will unload right side of the truck and can crush you.", text _location],
	true,
	[format["MARK%1",_taskid],(_position),"hd_objective","ColorRedAlpha"," Target"],
	"created",
	_position
] call mps_tasks_add;

while {!ABORTTASK_PO && damage _cont1 < 1 && damage _cont2 < 1 && count nearestObjects[_position,["Land_Misc_Cargo1E_EP1","Misc_Cargo1B_military"],30] < 2 } do { sleep 5 };

if(damage _cont1 >= 1 || damage _cont2 >= 1 || ABORTTASK_PO) then {
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
}else{
    [format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
};

sleep 2;

detach _cont1;
detach _cont2;
deleteVehicle _cont1;
deleteVehicle _cont2;