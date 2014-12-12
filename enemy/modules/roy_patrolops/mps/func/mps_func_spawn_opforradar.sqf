// Written by EightySix

if(!isServer) exitWith{};
private["_radarlocation","_site"];

if(isNil "mps_ambient_air") then {mps_ambient_air = false};

if(!mps_ambient_air) exitWith{};

_radarlocation = _this select 0;
_radarlocation = position _radarlocation;

if(mps_a2) then {
	_site = switch (SIDE_B select 0) do {
		case east : {"RadarSite1_RU"};
		case west : {"RadarSite1_US"};
		default     {"RadarSite1_RU"};
	};
};
if(mps_oa) then {
	_site = switch (SIDE_B select 0) do {
		case east : {"RadarSite1_TK_EP1"};
		case west : {"RadarSite1_TK_EP1"};
		default     {"RadarSite1_TK_EP1"};
	};
};


patrol_helo_radarlocations = nearestLocations [ [0,0], ["Name","NameCity","NameCityCapital","NameVillage","NameLocal"], 30000];

_newComp = [_radarlocation, random 360,_site] call BIS_fnc_dyno;

{ if(typeOf _x IN ["76n6ClamShell","76n6ClamShell_EP1","BASE_WarfareBAntiAirRadar"]) then {heli_radar = _x;}; }forEach _newcomp;

if(isNil "heli_radar") exitWith{};

if(mps_debug) then {
	_marker = createMarkerLocal ["masarkerh",_radarlocation];
	_marker setMarkerTypeLocal "mil_triangle";
	_marker setMarkerColorLocal "ColorRedAlpha";
	mission_sidechat = format["OPFOR Radar created at grid %1.",mapGridPosition _radarlocation]; publicVariable "mission_sidechat";
	[WEST,"HQ"] sideChat mission_sidechat;
};

_script = [] spawn {
	While { damage heli_radar < 1 } do{
		_groupgrp1 = createGroup east;

		_types = mps_opfor_atkh + mps_opfor_atkp;
		_helotype = _types call mps_getRandomElement;

		_helo1 = ([[(position heli_radar select 0)+10000,(position heli_radar select 1)+10000,100], 180, _helotype, _groupgrp1] call BIS_fnc_spawnVehicle) select 0;
//		_helo2 = ([[(position heli_radar select 0)+10100,(position heli_radar select 1)+10100,100], 180, _helotype, _groupgrp1] call BIS_fnc_spawnVehicle) select 0;

		sleep 10;
		_radarlocations = patrol_helo_radarlocations call mps_getArrayPermutation;
		{
			if(position _x distance getMarkerPos format["respawn_%1",(SIDE_A select 0)] > 3000) then {
				_wp = _groupgrp1 addWaypoint [position _x,100];
			};

		} foreach _radarlocations;
			_wp = _groupgrp1 addWaypoint [waypointPosition [_groupgrp1,0],100];
			_wp setWaypointType "CYCLE";

		while { damage _helo1 < 1 } do {sleep 30;};

		sleep 60;

		deleteVehicle _helo1;
		deletegroup _groupgrp1;

		sleep 300;
	};
};

While{ damage heli_radar < 1 } do { sleep 10 };

terminate _script;

mission_commandchat = "Enemy Radar Destroyed - Enemy can't call in further Air Support";
publicVariable "mission_commandchat";
player commandChat mission_commandchat;