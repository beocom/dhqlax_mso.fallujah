if(count mps_loc_towns < 1) exitWith{PAPABEAR sideChat format ["%1 this is PAPA BEAR. Mission Cancelled!", group player]};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK CAP_town.sqf"];

private["_location","_position","_taskid","_rmin","_rmax","_rplayers","_ra","_rb","_diffresult"];

_location = (mps_loc_towns call mps_getRandomElement);
while {_location == mps_loc_last } do {
    _location = (mps_loc_towns call mps_getRandomElement);
	sleep 0.1;
};
mps_loc_last = _location;

_position = [(position _location) select 0,(position _location) select 1, 0];
//_position = [_position,80,0.1,2] call mps_getFlatArea;

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];

_dirn = "NORTH"; if( (position CAPT2_target) select 1 < (position _location) select 1) then {_dirn = "SOUTH"};
_dire = "EAST"; if( (position CAPT2_target) select 0 < (position _location) select 0) then {_dire = "WEST"};
_distintel = (position CAPT2_target) distance (position _location);

mps_civilian_intel = [];
publicVariable "mps_civilian_intel";

[ format["TASK%1",_taskid],
	format["Capture %1", toUpper(text _location)],
	format["%1 is host to a large enemy force. Secure the town and drive out any hostiles.", toUpper(text _location)],
	true,
	[format["MARK%1",_taskid],(_position),"hd_objective","ColorRedAlpha"," Target"],
	"created",
	_position
] call mps_tasks_add;

[_position] call CREATE_OPFOR_ARMY; sleep 1;

_rmin = 0;
_rmax = 1;
_rplayers = 1 max (playersNumber (SIDE_A select 0));
_ra = (_rmax-_rmin)/(mps_ref_playercount-1);
_rb = _rmin - _ra;
_diffresult = round(_rplayers * _ra + _rb);

if( _diffresult > 0.14 ) then {
	[_position] spawn CREATE_OPFOR_SNIPERS;
};

if( _diffresult > 0.24 ) then {
	[_position] spawn CREATE_OPFOR_TOWER;
};

while{!ABORTTASK_PO && {alive _x && side _x == (SIDE_B select 0)} count nearestObjects[_position,["MAN","LandVehicle","Air"],300] > 3 } do { sleep 5 };

if(!ABORTTASK_PO) then {
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
}else{
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
};
