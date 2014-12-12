#include <crbprofiler.hpp>

//#squint filter Unknown variable mso_core_fnc_findVehicleType
//#squint filter Unknown variable MSO_FACTIONS
//#squint filter Unknown variable mso_core_fnc_selectRandomBias
//#squint filter Unknown variable mso_core_fnc_initLocations
//#squint filter Unknown variable mso_core_fnc_randomGroup
//#squint filter Unknown variable CBA_fnc_randPos

private ["_debug","_strategic","_convoyLocs","_numconvoys"];
if(!isServer) exitWith{};

_debug = debug_mso;
if(isNil "crb_convoy_intensity")then{crb_convoy_intensity = 1;};

if(crb_convoy_intensity == 0) exitWith{};

waitUntil{!isNil "BIS_fnc_init"};
if(isNil "CRB_LOCS") then {
        CRB_LOCS = [] call mso_core_fnc_initLocations;
};

fAddVehicle = {
	private ["_type","_startposi","_startroads","_dire","_grop","_veh","_pos"];
	_startposi = _this select 0;
	_dire = _this select 1;
	_grop = _this select 2;
	_startroads = _startposi nearRoads 200;
	_pos = position ((_startroads) call BIS_fnc_selectRandom);
	if (count _this > 3) then {
		_type = ([0, MSO_FACTIONS, _this select 3] call mso_core_fnc_findVehicleType) call BIS_fnc_selectRandom;
	} else {
		_type = ([0, MSO_FACTIONS, "LandVehicle"] call mso_core_fnc_findVehicleType) call BIS_fnc_selectRandom;
	};
	if (debug_mso) then {
		diag_log format["Spawning %1", _type];
	};
    _veh = [_pos, _dire, _type, _grop] call BIS_fnc_spawnVehicle;
	_veh;
};

_strategic = ["StrongPoint","CityCenter","FlatAreaCity","Airport","NameCity","NameCityCapital","NameVillage","BorderCrossing"];
_convoyLocs = [];

// Search CRB_LOCs for suitable destinations
{
        if((type _x in _strategic) && (count ((position _x) nearRoads 300) > 3)) then {
                _convoyLocs set [count _convoyLocs, position _x];
        };
} forEach CRB_LOCS;

// Add suitable CQB and DEP LOCS
if (isnil "CQB_spawn") then {CQB_spawn = 10};
if (CQB_spawn > 0) then {
	waituntil {!(isnil "CQBpositionsStrat")};
	if (count CQBpositionsStrat > 0) then {
		{
			if(count ((position (_x select 0)) nearRoads 300) > 3) then {
					_convoyLocs set [count _convoyLocs, position (_x select 0)];
			};
		} forEach CQBpositionsStrat;
	};
};

if (isnil "rmm_dynamic") then {rmm_dynamic = 1};
if (rmm_dynamic == 2) then {
	waituntil {!(isnil "DEP_LOCS")};
	{
			if(count ((position (_x select 0)) nearRoads 300) > 3) then {
					_convoyLocs set [count _convoyLocs, position (_x select 0)];
			};
	} forEach DEP_LOCS;
};

if (count _convoyLocs == 0) exitwith {
	diag_log ["MSO-%1 Convoy: Exiting due to lack of destinations near roads.", time];
};

// Set the number of convoys
_numconvoys = crb_convoy_intensity;

if (_numconvoys > count _convoyLocs) then {
	_numconvoys = count _convoyLocs;
};

if (isNil "rmm_ep_safe_zone") then {rmm_ep_safe_zone = 2000;};

for "_j" from 1 to _numconvoys do {
	
        [_j, _convoyLocs, _debug] spawn {
                private ["_timeout","_startpos","_destpos","_endpos","_grp","_front","_facs","_wp","_j","_convoyLocs","_debug","_sleep","_type","_starttime"];
                _j = _this select 0;
                _convoyLocs = _this select 1;
                _debug = _this select 2;
                
                _timeout = if(_debug) then {[30, 30, 30];} else {[30, 120, 300];};
                
				while{crb_convoy_intensity > 0} do {
                        CRBPROFILERSTART("CRB Convoys")
						private ["_swag","_leader","_dir","_startroad"];
						// Select a start position outside of player safe zone and not near base
						while { 
							_startroad = ((_convoyLocs call BIS_fnc_selectRandom) nearRoads 300) call BIS_fnc_selectRandom; 
							((position _startroad distance getmarkerpos "ammo" < rmm_ep_safe_zone) && 
							(position _startroad  distance getmarkerpos "ammo_1" < rmm_ep_safe_zone))
						} do {};
                        
						_startpos =  position _startroad; 
                        _destpos = position (((_convoyLocs call BIS_fnc_selectRandom) nearRoads 300) call BIS_fnc_selectRandom); 
                        _endpos = position (((_convoyLocs call BIS_fnc_selectRandom) nearRoads 300) call BIS_fnc_selectRandom); 
						
						if (_debug) then {
							private ["_t","_c"];
							_t = format["convoy_%1", floor(random 10000)];
							_c = format["convoy_%1", floor(random 10000)];
							[_c, _startpos, "Icon", [1,1], "TYPE:", "Start", "TEXT:", _t,"GLOBAL", "PERSIST"] call CBA_fnc_createMarker;
							_c = format["convoy_%1", floor(random 10000)];
							[_c, _destpos, "Icon", [1,1], "TYPE:", "mil_pickup", "TEXT:", _t,"GLOBAL", "PERSIST"] call CBA_fnc_createMarker;
							_c = format["convoy_%1", floor(random 10000)];
							[_c, _endpos, "Icon", [1,1], "TYPE:", "End", "TEXT:", _t,"GLOBAL", "PERSIST"] call CBA_fnc_createMarker;
						};
						
                        _grp = nil;
                        _front = "";
                        while{isNil "_grp"} do {
                                _front = [["Motorized","Mechanized","Armored"],[16,4,1]] call mso_core_fnc_selectRandomBias;
                                _facs = MSO_FACTIONS;
                                _grp = [_startpos, _front, _facs] call mso_core_fnc_randomGroup;
                        };
                                                
						// Set direction so pointing towards destination
						_dir = getdir _startroad;
						
						_leader = leader _grp;
						_leader setdir _dir;
						_grp setFormation "FILE";
						
						// Give the leader some swag
						_swag = ["EvMoney","EvMap","EvPhoto","revolver_gold_EP1","kostey_map_case"];
						{
							if (random 1 > 0.5) then {_leader addweapon _x;};	
						} foreach _swag;
						
                        switch(_front) do {
                                case "Motorized": {
                                        for "_i" from 0 to (1 + floor(random 2)) do {
										private "_veh";
											_veh = [_startpos, _dir, _grp] call fAddVehicle;
                                        };
                                };
                                case "Mechanized": {
                                        for "_i" from 0 to (1 + floor(random 2)) do {
											private "_veh";
											_veh = [_startpos, _dir, _grp] call fAddVehicle;
                                        };
	                                    if(random 1 > 0.66) then {
											private "_veh";
											_veh = [_startpos, _dir, _grp] call fAddVehicle;
										};
                                };
                                case "Armored": {
                                        for "_i" from 0 to (1 + floor(random 2)) do {
											private "_veh";
											_veh = [_startpos, _dir, _grp] call fAddVehicle;
                                        };
                                        if(random 1 > 0.33) then {
											private "_veh";
											_veh = [_startpos, _dir, _grp] call fAddVehicle;
										};
                                };
                        };
                        
						// Add some trucks!
						if(random 1 > 0.25) then {
							for "_i" from 0 to (1 + ceil(random 2)) do {
								private "_veh";
								_veh = [_startpos, _dir, _grp, "Truck"] call fAddVehicle;
							};
						};
						
						diag_log format["MSO-%1 Convoy: #%2 %3 %4 %5 %6 units:%7", time, _j, _startpos, _destpos, _endpos, _front, count (units _grp)];
												
						_starttime = time;
						
                        {_x setSkill 0.2;} forEach units _grp;
                        
                        _wp = _grp addwaypoint [_startpos, 0];
                        _wp setWaypointFormation "FILE";
                        _wp setWaypointSpeed "LIMITED";
                        _wp setWaypointBehaviour "SAFE";
                        _wp setWaypointTimeout _timeout;
                        
                        _wp = _grp addwaypoint [_destpos, 0];
                        _wp setWaypointFormation "FILE";
                        _wp setWaypointSpeed "LIMITED";
                        _wp setWaypointBehaviour "SAFE";
                        _wp setWaypointTimeout _timeout;
                        
                        _wp = _grp addwaypoint [_endpos, 0];
                        _wp setWaypointFormation "FILE";
                        _wp setWaypointSpeed "LIMITED";
                        _wp setWaypointBehaviour "SAFE";
                        _wp setWaypointTimeout _timeout;
                        
                        _wp = _grp addwaypoint [_destpos, 0];
                        _wp setWaypointFormation "FILE";
                        _wp setWaypointSpeed "LIMITED";
                        _wp setWaypointBehaviour "SAFE";
                        _wp setWaypointTimeout _timeout;
                        
                        _wp = _grp addwaypoint [_startpos, 0];
                        _wp setWaypointFormation "FILE";
                        _wp setWaypointSpeed "LIMITED";
                        _wp setWaypointBehaviour "SAFE";
                        _wp setWaypointTimeout _timeout;
                        
                        _wp = _grp addwaypoint [_startpos, 0];
                        _wp setWaypointFormation "FILE";
                        _wp setWaypointSpeed "LIMITED";
                        _wp setWaypointBehaviour "SAFE";
                        _wp setWaypointType "CYCLE";
                                                                    
			CRBPROFILERSTOP

                        waitUntil{sleep 60; (!(_grp call CBA_fnc_isAlive) || (time > (_starttime + 3600)))};   
						
						// Delete convoy
						if (_debug) then {
							diag_log format["MSO-%1 Convoy: %3 deleting %2", time, _grp, _j];
						};
						{deleteVehicle (vehicle _x); deleteVehicle _x;} forEach units _grp;
						deletegroup _grp;

                        _sleep = if(_debug) then {30;} else {random 300;};
                        sleep _sleep;                
                };
        };
};

diag_log format["MSO-%1 Convoy: destinations(%2) convoys(%3)", time, count _convoyLocs, _numconvoys];

