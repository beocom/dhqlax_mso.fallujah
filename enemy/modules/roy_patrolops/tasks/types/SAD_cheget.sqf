if(count mps_loc_towns < 1) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK SAD_cheget.sqf"];

private["_location","_position","_taskid","_object","_grp"];

_location = (mps_loc_towns call mps_getRandomElement);

while {_location == mps_loc_last} do {
	_location = (mps_loc_towns call mps_getRandomElement); 
    sleep 0.1;
};

mps_loc_last = _location;

_position = [(position _location) select 0,(position _location) select 1, 0];

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];

_football_location = _position;
_radius = 1000;

While{!ABORTTASK_PO && _position distance getmarkerpos format["respawn_%1",(SIDE_A select 0)] < 3000} do {
	_radius = _radius + 100;
	_position = [position _location,random 360,_radius,false,2] call mps_new_position;
};

football_device = "SatPhone" createVehicle _position;

_houses = [_position,1000] call mps_getEnterableHouses;
	_hideout = [];
	if(count _houses > 0) then {
		for "_i" from 1 to 10000 do {
			_house = _houses call mps_getRandomElement;
			_buildingpos = round random (_house select 1);
			_house = _house select 0;
			_hideout = (_house buildingPos _buildingpos);
			if(count (_hideout - [0]) > 0) exitWith{};
			_hideout = [(getPos football_device select 0) + _size - random (2*_size),(getPos football_device select 1) + _size - random (2*_size),0];
		};
		football_device setPos _hideout;
	} else {
		for "_i" from 1 to 10000 do {
			_randompos = [(_pos select 0) + _size - random (2*_size),(_pos select 1) + _size - random (2*_size),0];
			_isFlat = _randompos isflatempty [(sizeof typeof football_device) / 2,0,0.3,(sizeof typeof football_device),0,false,football_device];
			if(
				if(count _isFlat > 0) then{
					if(count (_isFlat nearRoads 20) == 0) then{_isFlat set [2,0]; true} else {false}
				} else{false}
			) exitWith{};
		};
		if(count _isFlat == 0) then {_isFlat = _randompos};
//		_newComp = [_isFlat,random 360, east_enemy_camp] call BIS_fnc_dyno;
		football_device setPos _isFlat;
	};

	football_location = position football_device;
	football_intel = 0;
	football_marker = [];

	if(mps_debug) then {
		_marker = createMarkerLocal [format["TASK%1",_taskid],position football_device];
		_marker setMarkerTypeLocal "mil_dot";
		_marker setMarkerColorLocal "ColorGreen";
	};

	FOOTBALL_INTEL_KILLED = {
		if(side _this == (SIDE_B select 0) && random 2 < 1) then {
			_this addEventHandler ["Killed",{
				_unit = _this select 0;
				_pos = [(getPos _unit select 0) + 1 - random 2,(getPos _unit select 1) + 1 - random 2,0];
				_ev = (["EvMap","EvMoscow","EvPhoto"] call getRandomElement) createvehicle _pos;
				_ev setPosATL _pos;
				_ev spawn {
					while{!ABORTTASK_PO && not isNil "football_device" && {isPlayer _x && side _x == friendly_side} count nearestObjects[position _this,["All"],3] == 0} do {sleep 3};
					if(isNil "football_device") exitWith {deleteVehicle _this};
					deleteVehicle _this;
					mission_sidechat = "Gained new intel about the footballs possible location.";
					publicVariable "mission_sidechat";
					player sideChat mission_sidechat;
	
					football_intel = football_intel + 150;
	
					_markername = format["football_int_%1",football_intel];
					_markeraccuracy = 50 max (1000 - football_intel);
					_markerpos = [football_location,random 360,random _markeraccuracy,false,2] call SHK_pos;
	
					football_marker set [count football_marker, _markername];
	
					While{!ABORTTASK_PO && not isNil "football_device"} do {
						_marker = createMarker [_markername,_markerpos];
						_marker setMarkerType "hd_unknown";
						_marker setMarkerSize [0.75,0.75];
						_marker setMarkerText format[" %1",_markeraccuracy];
						sleep 60;
						deleteMarker _marker;
					};
				};
			}];
		};
	};

{_x spawn FOOTBALL_INTEL_KILLED;} foreach nearestObjects [_position,["Man"],500];

[format["TASK%1",_taskid],
	"Search and Destroy: Cheget",
	"A russian nuclear briefcase, known as a cheget, is belived to be in enemy possession somewhere in %1. Locate the cheget by engaging enemy forces in towns and collect the intel they drop. Once located, destroy the cheget!",
	true,
	[],
	"created"
] call mps_tasks_add;

While {!ABORTTASK_PO && alive football_device && timercount < 360} do { sleep 10; timercount = timercount + 1; };

if (!ABORTTASK_PO && !alive football_device) then {
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
}else{
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
};

{deleteMarker _x} foreach football_marker;
football_marker = nil;
football_device = nil;
football_intel = nil;
football_location = nil;
FOOTBALL_INTEL_KILLED = nil;
