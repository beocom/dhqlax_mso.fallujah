// Written by EightySix
// Inspired by Xeno

private["_position","_tower","_type","_grp","_timer"];

_position = (_this select 0) call mps_get_position;

_type = ["Land_Vysilac_FM","Land_telek1"] call mps_getRandomElement;
_tower = _type createVehicle _position;
[_tower] spawn mps_object_c4only;

_grp = [_position,"INF",(2 + random 3),50] call CREATE_OPFOR_SQUAD;
(_grp addWaypoint [_position,20]) setWaypointType "HOLD";
_grp setFormation "DIAMOND";

[_position,_tower,_grp] spawn {
	private["_pos","_tower","_spawnpos","_regrp"];
	_pos = _this select 0;
	_tower = _this select 1;
	_observer = leader (_this select 2);
	_spawnpos = format["respawn_%1",(SIDE_B select 0)];

	while{ alive _tower && alive _observer} do {
		if( !(toupper (behaviour _observer) IN ["CARELESS","SAFE","AWARE"]) ) then {
			_regrp = [_spawnpos,"INF",(8 + random 4),50] call CREATE_OPFOR_SQUAD;
			[_regrp,_spawnpos,_pos,true] spawn CREATE_OPFOR_PARADROP;

			mission_commandchat = "An Enemy Observer has requested reinforcements"; publicVariable "mission_commandchat";
			[(SIDE_A select 0),"HQ"] commandChat mission_commandchat;

			_timer = 42;
			while{ alive _tower && alive _observer && _timer > 0 } do { sleep 10; _timer = _timer - 1;};
		};
		sleep 10;
	};
	if(!alive _observer) then {
		mission_commandchat = "Enemy Radio Operator Killed - Now they can't call in further Support"; publicVariable "mission_commandchat";
		[(SIDE_A select 0),"HQ"] commandChat mission_commandchat;
	};
};

//	mission_commandchat = format["Enemy Radio Tower spotted near target area.",mapGridPosition _position]; publicVariable "mission_commandchat";
//	[(SIDE_A select 0),"HQ"] commandChat mission_commandchat;

While{ damage _tower < 1 && mps_mission_status == 1} do {
	_marker = createMarker [format["tower_marker_%1%2",round (_position select 0),round (_position select 1)],_position];
	_marker setMarkerType "mil_triangle";
	_marker setMarkerColor "ColorBlack";
	_marker setMarkerText " Comms Tower";
	_marker setMarkerSize [0.6,0.6];
	sleep 10;
	deleteMarker _marker;
};

if(damage _tower >= 1) then {
	mission_commandchat = "Enemy Tower Destroyed - Now they can't call in further Support"; publicVariable "mission_commandchat";
	[(SIDE_A select 0),"HQ"] commandChat mission_commandchat;
};

sleep 10;
deleteVehicle _tower;
deleteMarker _marker;