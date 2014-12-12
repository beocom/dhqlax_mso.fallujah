#include <crbprofiler.hpp>

//#squint filter Unknown variable MSO_FACTIONS
//#squint filter Unknown variable mso_core_fnc_initLocations
//#squint filter Unknown variable mso_core_fnc_selectRandomBias
//#squint filter Unknown variable mso_core_fnc_randomGroup
//#squint filter Unknown variable mso_core_fnc_createComposition
//#squint filter Unknown variable mso_core_fnc_createCompositionE
//#squint filter Careful - string searches using 'in' are case-sensitive


private ["_debug","_d","_camp","_flag"];
if !(isServer) exitWith {};

_debug = debug_mso;
if (isnil "rmm_dynamic") then {rmm_dynamic = 2};
if (isNil "rmm_ep_intensity") then {rmm_ep_intensity = 3;};
if (isNil "rmm_ep_spawn_dist") then {rmm_ep_spawn_dist = 2000;};
if (isNil "rmm_ep_safe_zone") then {rmm_ep_safe_zone = 2000;};
if (isNil "rmm_ep_inf") then {rmm_ep_inf = 4;};
if (isNil "rmm_ep_mot") then {rmm_ep_mot = 3;};
if (isNil "rmm_ep_mec") then {rmm_ep_mec = 2;};
if (isNil "rmm_ep_arm") then {rmm_ep_arm = 1;};
if (isNil "rmm_ep_aa") then {rmm_ep_aa = 2;};
if (isNil "DEP_ACTIVE_LOCS") then {DEP_ACTIVE_LOCS = 40;};
if (isNil "DEP_DENSITY") then {DEP_DENSITY = 1000;};
if (isNil "pdb_locations_enabled") then {pdb_locations_enabled = false;};


if ((rmm_dynamic == 2) || (pdb_locations_enabled)) exitWith {call compile preprocessfilelinenumbers "enemy\modules\rmm_enemypop\main_pdb.sqf"};
if (rmm_dynamic == 1) exitWith {call compile preprocessfilelinenumbers "enemy\modules\rmm_enemypop\main_dynamic.sqf"};
if (rmm_ep_intensity == 0) exitWith{diag_log format ["MSO-%1 Enemy Populator Disabled - Exiting.",time];};

ep_groups = [];
ep_total = 0;
ep_campprob = 0.25;

rmm_ep_getFlatArea = {
        // Written by BON_IF
        
        private ["_position","_radius","_pos","_maxgradient","_gradientarea"];
        _position = _this select 0;
        if(count _this > 1) then {_radius = _this select 1;} else {_radius = 2;};
        if(count _this > 2) then {_maxgradient = _this select 2} else {_maxgradient = 0.1};   // in [0,1]
        if(count _this > 3) then {_gradientarea = _this select 3} else {_gradientarea = 5};   // in metres
        
        for "_i" from 1 to 10000 do {
                _pos = [(_position select 0) + _radius - random (2*_radius),(_position select 1) + _radius - random (2*_radius),0];
                _pos = 	_pos isflatempty [
                        20,				//--- Minimal distance from another object
                        1,				//--- If 0, just check position. If >0, select new one
                        _maxgradient,			//--- Max gradient
                        _gradientarea,			//--- Gradient area
                        0,				//--- 0 for restricted water, 2 for required water,
                        false,				//--- True if some water can be in 25m radius
                        ObjNull				//--- Ignored object
                ];
                if(
                        if(count _pos > 0) then {
                                _pos set [2,0];
                                if(count (_pos nearRoads 20) == 0) then {
                                        true;
                                } else	{
                                        false;
                                }
                        } else {
                                false;
                        }
                ) exitWith	{if (_debug) then {diag_log format["MSO-%1 RMM GETFLATAREA attempts: %3 - found pos: %2", time, _pos, _i];}
        };
};
if(count _pos == 0) then{_pos = _position;
if (_debug) then {diag_log format["MSO-%1 RMM GETFLATAREA defaulting to original pos after 10000 trys: %2", time, _pos]};
};

_pos;
};

waitUntil{!isNil "BIS_fnc_init"};
if(isNil "CRB_LOCS") then {
        CRB_LOCS = [] call mso_core_fnc_initLocations;
};

diag_log format["MSO-%1 Enemy Population (static) initLocations %2", time, count CRB_LOCS];
if(_debug) then {hint format["MSO-%1 Enemy Population (static) initLocations %2", time, count CRB_LOCS];};

BIN_fnc_taskDefend = compile preprocessFileLineNumbers "enemy\scripts\BIN_taskDefend.sqf";

fPlayersInside = {
        private["_pos","_dist"];
        _pos = _this select 0;
        _dist = _this select 1;
        ({_pos distance _x < _dist} count ([] call BIS_fnc_listPlayers) > 0);
};

for "_i" from 0 to ((count CRB_LOCS) -1) step rmm_ep_intensity do {
        if(_i >= count CRB_LOCS) exitWith{};
        private ["_loc","_group","_pos","_type"];
        _loc = CRB_LOCS select _i;
        _group = grpNull;
        _type = "";
        _pos = [];
        if ( !([position _loc, rmm_ep_safe_zone] call fPlayersInside) && (position _loc distance getmarkerpos "ammo" > rmm_ep_safe_zone) && (position _loc distance getmarkerpos "ammo_1" > rmm_ep_safe_zone) ) then {
                if (type _loc == "Hill") then {
                        if (random 1 > 0.33) then {
                                ep_total = ep_total + 1;
                                _pos = [position _loc, 0, 30, 1, 0, 5, 0] call bis_fnc_findSafePos;
                                //_pos = [position _loc,30,0.1,5] call rmm_ep_getFlatArea; 
                                _flag = random 1;
                                if(_flag < ep_campprob) then {
                                        _camp = [];
                                        if("RU" in MSO_FACTIONS) then {
                                                _camp = _camp + ["anti-air_ru1","camp_ru1","camp_ru2","firebase_ru1","heli_park_ru1","mediumtentcamp2_ru","mediumtentcamp3_ru","mediumtentcamp_ru","radar_site_ru1"];
                                        };
                                        if("INS" in MSO_FACTIONS) then {
                                                _camp = _camp + ["camp_ins1","camp_ins2"];
                                        };
                                        if("GUE" in MSO_FACTIONS || "tigerianne" in MSO_FACTIONS) then {
                                                _camp = _camp + ["MediumTentCamp_napa","SmallTentCamp2_napa","SmallTentCamp_napa"];
                                        };
                                        if("BIS_TK" in MSO_FACTIONS) then {
                                                _camp = _camp + ["anti-air_tk1","camp_tk1","camp_tk2","firebase_tk1","heli_park_tk1","mediumtentcamp2_tk","mediumtentcamp3_tk","mediumtentcamp_tk","radar_site_tk1"];
                                        };
                                        if("BIS_TK_INS" in MSO_FACTIONS) then {
                                                _camp = _camp + ["camp_militia1","camp_militia2"];
                                        };
                                        if("BIS_TK_GUE" in MSO_FACTIONS) then {
                                                _camp = _camp + ["MediumTentCamp_local","SmallTentCamp2_local","SmallTentCamp_local"];
                                        };
                                        if("RU" in MSO_FACTIONS || "INS" in MSO_FACTIONS || "GUE" in MSO_FACTIONS || "cwr2_ru" in MSO_FACTIONS || "cwr2_fia" in MSO_FACTIONS || "tigerianne" in MSO_FACTIONS) then {
                                                _camp = _camp + ["bunkerMedium01","bunkerMedium02","bunkerMedium03","bunkerMedium04","bunkerSmall01","guardpost4","guardpost5","guardpost6","guardpost7","guardpost8"];
                                                f_builder = mso_core_fnc_createComposition;
                                        };
                                        if("BIS_TK" in MSO_FACTIONS || "BIS_TK_INS" in MSO_FACTIONS || "BIS_TK_GUE" in MSO_FACTIONS) then {
                                                _camp = _camp + ["bunkerMedium01","bunkerMedium02","bunkerMedium03","bunkerMedium04","bunkerSmall01","guardpost4","guardpost5","guardpost6","guardpost7","guardpost8"];
                                                f_builder = mso_core_fnc_createCompositionE;
                                        };
                                        if (count _camp == 0) then {
                                                _camp = _camp + ["anti-air_ru1","camp_ru1","camp_ru2","firebase_ru1","heli_park_ru1","mediumtentcamp2_ru","mediumtentcamp3_ru","mediumtentcamp_ru","radar_site_ru1"];
                                                f_builder = mso_core_fnc_createComposition;
                                        };
                                        if (count _camp > 0) then {
                                                _camp = _camp call BIS_fnc_selectRandom;
                                                //_pos = [_pos, 0, 50, 10, 0, 2, 0] call bis_fnc_findSafePos;
                                                _pos = [_pos,200,0.15,5] call rmm_ep_getFlatArea; 
                                                [_camp, [_pos, position _loc] call BIS_fnc_dirTo, _pos] call f_builder;
                                                if (_debug) then {diag_log format ["Camp created at %1 (%2)", _pos, _loc];}; 
                                        };
                                };
                                
                                _type = [["Infantry", "Motorized", "Mechanized", "Armored"],[rmm_ep_inf,rmm_ep_mot,rmm_ep_mec,rmm_ep_arm]] call mso_core_fnc_selectRandomBias;
                                
                                [_pos, _flag, _type] spawn {
                                        private ["_pos","_pos2","_flag","_group","_grp2","_type","_debug"];
                                        _pos = _this select 0;
                                        _flag = _this select 1;
                                        _type = _this select 2;
                                        _debug = debug_mso;
                                        waitUntil{sleep 3; ([_pos, rmm_ep_spawn_dist] call fPlayersInside)};
                                        _group = nil;
                                        _pos2 = [_pos, 0, 50, 10, 0, 5, 0] call bis_fnc_findSafePos;
                                        while{isNil "_group"} do {
                                                _group = [_pos2, _type, MSO_FACTIONS] call mso_core_fnc_randomGroup;
                                        };
                                        (leader _group) setBehaviour "AWARE";
                                        _group setSpeedMode "LIMITED";
                                        _group setFormation "STAG COLUMN";
                                        if(_flag >= ep_campprob || count units _group <= 2) then {
                                                [_group,_group,800,4 + random 6, "MOVE", "AWARE", "RED", "LIMITED", "STAG COLUMN", "if (dayTime < 18 or dayTime > 6) then {this setbehaviour ""STEALTH""}", [120,200,280]] call CBA_fnc_taskPatrol;
                                        };
                                        if(_flag < ep_campprob && _type == "Infantry") then {
                                                leader _group setPos _pos;
                                                [_group] call BIN_fnc_taskDefend;
                                        };
                                        if(_flag < ep_campprob && _type != "Infantry") then {
                                                [_group,_group,100,4 + random 6, "MOVE", "AWARE", "RED", "LIMITED", "STAG COLUMN", "if (dayTime < 18 or dayTime > 6) then {this setbehaviour ""STEALTH""}", [120,200,280]] call CBA_fnc_taskPatrol;
                                                _grp2 = grpNull;
                                                while{count units _grp2 <= 2} do {
                                                        {deleteVehicle _x} count units _grp2;
                                                        _grp2 = [_pos, "Infantry", MSO_FACTIONS] call mso_core_fnc_randomGroup;
                                                };
                                                [_grp2] call BIN_fnc_taskDefend;
                                                ep_groups set [count ep_groups, _grp2];
                                        };
                                        // Check to see if Enemy sets up AA site
                                        if ((random 1 > 0.5) || _debug) then {
                                                [_pos, "static", 1 + random 1] execVM "enemy\scripts\TUP_spawnAA.sqf";
                                        };
                                        ep_groups set [count ep_groups, _group];
                                };
                        };
                };
			if (type _loc in ["Strategic","StrongpointArea","Airport","HQ","FOB","Heliport","Artillery","AntiAir","City","Strongpoint","Depot","Storage","PlayerTrail","WarfareStart"]) then {
					if (random 1 > 0.5) then {
							ep_total = ep_total + 1;
							_d = 500;
							//_pos = [position _loc,_d / 2 + random _d,0.1,5] call rmm_ep_getFlatArea;		
							_pos = [position _loc, 0,_d / 2 + random _d, 1, 0, 5, 0] call bis_fnc_findSafePos;
							_flag = random 1;
							if(_flag < ep_campprob) then {
									_camp = [];
									if("RU" in MSO_FACTIONS) then {
											_camp = _camp + ["anti-air_ru1","camp_ru1","camp_ru2","firebase_ru1","heli_park_ru1","mediumtentcamp2_ru","mediumtentcamp3_ru","mediumtentcamp_ru","radar_site_ru1","fuel_dump_ru1","vehicle_park_ru1","weapon_store_ru1"];
									};
									if("BIS_TK" in MSO_FACTIONS) then {
											_camp = _camp + ["anti-air_tk1","camp_tk1","camp_tk2","firebase_tk1","heli_park_tk1","mediumtentcamp2_tk","mediumtentcamp3_tk","mediumtentcamp_tk","radar_site_tk1","fuel_dump_tk1","vehicle_park_tk1","weapon_store_tk1"];
									};
									if("RU" in MSO_FACTIONS || "INS" in MSO_FACTIONS || "GUE" in MSO_FACTIONS || "cwr2_ru" in MSO_FACTIONS || "cwr2_fia" in MSO_FACTIONS || "tigerianne" in MSO_FACTIONS) then {
											_camp = _camp + ["bunkerMedium01","bunkerMedium02","bunkerMedium03","bunkerMedium04","bunkerSmall01","guardpost4","guardpost5","guardpost6","guardpost7","guardpost8","citybase01","cityBase02","cityBase03","cityBase04"];
											f_builder = mso_core_fnc_createComposition;
									};
									if("BIS_TK" in MSO_FACTIONS || "BIS_TK_INS" in MSO_FACTIONS || "BIS_TK_GUE" in MSO_FACTIONS) then {
											_camp = _camp + ["bunkerMedium01","bunkerMedium02","bunkerMedium03","bunkerMedium04","bunkerSmall01","guardpost4","guardpost5","guardpost6","guardpost7","guardpost8","citybase01","cityBase02","cityBase03","cityBase04"];
											f_builder = mso_core_fnc_createCompositionE;
									};
									if("RU" in MSO_FACTIONS && type _loc == "Airport") then {
											_camp = ["airplane_park_ru1"];
									};
									if("BIS_TK" in MSO_FACTIONS && type _loc == "Airport") then {
											_camp = ["airplane_park_tk1"];
									};
									if (count _camp == 0) then {
											_camp = _camp + ["anti-air_ru1","camp_ru1","camp_ru2","firebase_ru1","heli_park_ru1","mediumtentcamp2_ru","mediumtentcamp3_ru","mediumtentcamp_ru","radar_site_ru1"];
											f_builder = mso_core_fnc_createComposition;
									};
									_camp = _camp call BIS_fnc_selectRandom;
									//_pos = [_pos, 0, 50, 10, 0, 2, 0] call bis_fnc_findSafePos;
									_pos = [_pos,500,0.15,5] call rmm_ep_getFlatArea;
									[_camp, [_pos, position _loc] call BIS_fnc_dirTo, _pos] call f_builder;
									if (_debug) then {diag_log format ["Camp created at %1 (%2)", _pos, _loc];}; 
							};
							
							_type = [["Infantry", "Motorized", "Mechanized", "Armored"],[rmm_ep_inf,rmm_ep_mot,rmm_ep_mec,rmm_ep_arm]] call mso_core_fnc_selectRandomBias;
							
							[_pos, _flag, _type] spawn {
									private ["_pos","_pos2","_flag","_group","_grp2","_type","_debug"];
									_pos = _this select 0;
									_flag = _this select 1;
									_type = _this select 2;
									_debug = debug_mso;
									waitUntil{sleep 3; ([_pos, rmm_ep_spawn_dist] call fPlayersInside)};
									_group = nil;
									_pos2 = [_pos, 0, 50, 10, 0, 5, 0] call bis_fnc_findSafePos;
									while{isNil "_group"} do {
											_group = [_pos2, _type, MSO_FACTIONS] call mso_core_fnc_randomGroup;
									};
									(leader _group) setBehaviour "COMBAT";
									_group setSpeedMode "LIMITED";
									_group setFormation "DIAMOND";
									if(_flag >= ep_campprob || count units _group <= 2) then {
											[_group,_group,800,4 + random 4, "MOVE", "COMBAT", "RED", "LIMITED", "DIAMOND", "if (dayTime < 18 or dayTime > 6) then {this setbehaviour ""STEALTH""}", [240,400,560]] call CBA_fnc_taskPatrol;
									};
									if(_flag < ep_campprob && _type == "Infantry") then {
											leader _group setPos _pos;
											[_group] call BIN_fnc_taskDefend;
									};
									if(_flag < ep_campprob && _type != "Infantry") then {
											[_group,_group,100,4 + random 6, "MOVE", "AWARE", "RED", "LIMITED", "STAG COLUMN", "if (dayTime < 18 or dayTime > 6) then {this setbehaviour ""STEALTH""}", [120,200,280]] call CBA_fnc_taskPatrol;
											_grp2 = grpNull;
											while{count units _grp2 <= 2} do {
													{deleteVehicle _x} count units _grp2;
													_grp2 = [_pos, "Infantry", MSO_FACTIONS] call mso_core_fnc_randomGroup;
											};
											[_grp2] call BIN_fnc_taskDefend;
											ep_groups set [count ep_groups, _grp2];
									};
									// Check to see if Enemy sets up AA defense
									if ((random 1 > 0.6) || _debug) then {
											[_pos, "mixed", 1 + random 2] execVM "enemy\scripts\TUP_spawnAA.sqf";
									};
									ep_groups set [count ep_groups, _group];
							};
					};
			};
			if (type _loc in ["FlatArea", "FlatAreaCity","FlatAreaCitySmall","CityCenter","NameMarine","NameCityCapital","NameCity","NameVillage","NameLocal","fakeTown"]) then {
					if (random 1 > 0.6) then {
							ep_total = ep_total + 1;
							//_pos = [position _loc,250,0.1,5] call rmm_ep_getFlatArea;
							_pos = [position _loc, 0,250, 1, 0, 5, 0] call bis_fnc_findSafePos;			
							_flag = random 1;
							if(_flag < ep_campprob) then {
									_camp = [];
									if("RU" in MSO_FACTIONS) then {
											_camp = _camp + ["anti-air_ru1","camp_ru1","camp_ru2","firebase_ru1","heli_park_ru1","mediumtentcamp2_ru","mediumtentcamp3_ru","mediumtentcamp_ru","radar_site_ru1"];
									};
									if("INS" in MSO_FACTIONS) then {
											_camp = _camp + ["camp_ins1","camp_ins2"];
									};
									if("GUE" in MSO_FACTIONS || "tigerianne" in MSO_FACTIONS) then {
											_camp = _camp + ["MediumTentCamp_napa","SmallTentCamp2_napa","SmallTentCamp_napa"];
									};
									if("BIS_TK" in MSO_FACTIONS) then {
											_camp = _camp + ["anti-air_tk1","camp_tk1","camp_tk2","firebase_tk1","heli_park_tk1","mediumtentcamp2_tk","mediumtentcamp3_tk","mediumtentcamp_tk","radar_site_tk1"];
									};
									if("BIS_TK_INS" in MSO_FACTIONS) then {
											_camp = _camp + ["camp_militia1","camp_militia2"];
									};
									if("BIS_TK_GUE" in MSO_FACTIONS) then {
											_camp = _camp + ["MediumTentCamp_local","SmallTentCamp2_local","SmallTentCamp_local"];
									};
									if("RU" in MSO_FACTIONS || "INS" in MSO_FACTIONS || "GUE" in MSO_FACTIONS || "cwr2_ru" in MSO_FACTIONS || "cwr2_fia" in MSO_FACTIONS || "tigerianne" in MSO_FACTIONS) then {
											_camp = _camp + ["bunkerMedium01","bunkerMedium02","bunkerMedium03","bunkerMedium04","bunkerSmall01","guardpost4","guardpost5","guardpost6","guardpost7","guardpost8","citybase01","cityBase02","cityBase03","cityBase04"];
											f_builder = mso_core_fnc_createComposition;
									};
									if("BIS_TK" in MSO_FACTIONS || "BIS_TK_INS" in MSO_FACTIONS || "BIS_TK_GUE" in MSO_FACTIONS) then {
											_camp = _camp + ["bunkerMedium01","bunkerMedium02","bunkerMedium03","bunkerMedium04","bunkerSmall01","guardpost4","guardpost5","guardpost6","guardpost7","guardpost8","citybase01","cityBase02","cityBase03","cityBase04"];
											f_builder = mso_core_fnc_createCompositionE;
									};
									if (count _camp == 0) then {
											_camp = _camp + ["anti-air_ru1","camp_ru1","camp_ru2","firebase_ru1","heli_park_ru1","mediumtentcamp2_ru","mediumtentcamp3_ru","mediumtentcamp_ru","radar_site_ru1"];
											f_builder = mso_core_fnc_createComposition;
									};
									if (count _camp > 0) then {
											_camp = _camp call BIS_fnc_selectRandom;
											//_pos = [_pos, 0, 50, 10, 0, 2, 0] call bis_fnc_findSafePos;
											_pos = [_pos,300,0.15,5] call rmm_ep_getFlatArea;
											[_camp, [_pos, position _loc] call BIS_fnc_dirTo, _pos] call f_builder;
											if (_debug) then {diag_log format ["Camp created at %1 (%2)", _pos, _loc];}; 
									};
							};
							
							_type = [["Infantry", "Motorized", "Mechanized", "Armored"],[rmm_ep_inf,rmm_ep_mot,rmm_ep_mec,rmm_ep_arm]] call mso_core_fnc_selectRandomBias;
							
							[_pos, _flag, _type] spawn {
									private ["_pos","_pos2","_flag","_group","_grp2","_type","_debug"];
									_pos = _this select 0;
									_flag = _this select 1;
									_type= _this select 2;
									_debug = debug_mso;
									waitUntil{sleep 3; ([_pos, rmm_ep_spawn_dist] call fPlayersInside)};
									_group = nil;
									_pos2 = [_pos, 0, 50, 10, 0, 5, 0] call bis_fnc_findSafePos;
									while{isNil "_group"} do {
											_group = [_pos2, _type, MSO_FACTIONS] call mso_core_fnc_randomGroup;
									};
									(leader _group) setBehaviour "COMBAT";
									_group setSpeedMode "LIMITED";
									_group setFormation "DIAMOND";
									if(_flag >= ep_campprob || count units _group <= 2 ) then {
											if (count (nearestObjects [_pos, ["Building"], 500]) > 2) then {
													if (_debug) then {
															diag_log format["MSO-%1 Enemy Population - %3 is patrolling buildings near %2", time, _pos2, leader _group];
													};
													[leader _group, 500, true, 240 + random 360] execVM "support\scripts\crb_scripts\crB_HousePos.sqf";	
											} else {
													[_group,_group,400,4 + random 4, "MOVE", "COMBAT", "RED", "LIMITED", "DIAMOND", "if (dayTime < 18 or dayTime > 6) then {this setbehaviour ""STEALTH""}", [360,520,680]] call CBA_fnc_taskPatrol;
											};  
									};
									if(_flag < ep_campprob && _type == "Infantry") then {
											leader _group setPos _pos;
											[_group] call BIN_fnc_taskDefend;
									};
									if(_flag < ep_campprob && _type != "Infantry") then {
											[_group,_group,100,4 + random 6, "MOVE", "AWARE", "RED", "LIMITED", "STAG COLUMN", "if (dayTime < 18 or dayTime > 6) then {this setbehaviour ""STEALTH""}", [120,200,280]] call CBA_fnc_taskPatrol;
											_grp2 = grpNull;
											while{count units _grp2 <= 2} do {
													{deleteVehicle _x} count units _grp2;
													_grp2 = [_pos, "Infantry", MSO_FACTIONS] call mso_core_fnc_randomGroup;
											};
											[_grp2] call BIN_fnc_taskDefend;
											ep_groups set [count ep_groups, _grp2];
									};
									// Check to see if Enemy sets up roadblock
									if (((random 1 > 0.5) && (count (_pos nearRoads 500) > 0)) ) then {
											if (_debug) then {
													diag_log format["MSO-%1 Enemy Population - Attempted to Deploy Road Block near %2", time, _pos2];
											};
											[_group, _pos] execVM "enemy\scripts\TUP_deployRoadBlock.sqf";	
									};
									ep_groups set [count ep_groups, _group];
							};
					};
			};
			if (type _loc in ["ViewPoint","RockArea","VegetationBroadleaf","VegetationFir","VegetationPalm","VegetationVineyard"]) then {
					if (random 1 > 0.75) then {
							ep_total = ep_total + 1;
							_d = 200;
							//_pos = [position _loc,_d / 2 + random _d,0.1,5] call rmm_ep_getFlatArea;
							_pos = [position _loc, 0,_d / 2 + random _d, 1, 0, 5, 0] call bis_fnc_findSafePos;
							_flag = random 1;
							if(_flag < ep_campprob) then {
									_camp = [];
									if("RU" in MSO_FACTIONS) then {
											_camp = _camp + ["camp_ru1","camp_ru2"];
									};
									if("INS" in MSO_FACTIONS) then {
											_camp = _camp + ["camp_ins1","camp_ins2"];
									};
									if("GUE" in MSO_FACTIONS || "tigerianne" in MSO_FACTIONS) then {
											_camp = _camp + ["MediumTentCamp_napa","SmallTentCamp2_napa","SmallTentCamp_napa"];
									};
									if("BIS_TK" in MSO_FACTIONS) then {
											_camp = _camp + ["camp_tk1","camp_tk2"];
									};
									if("BIS_TK_INS" in MSO_FACTIONS) then {
											_camp = _camp + ["camp_militia1","camp_militia2"];
									};
									if("BIS_TK_GUE" in MSO_FACTIONS) then {
											_camp = _camp + ["MediumTentCamp_local","SmallTentCamp2_local","SmallTentCamp_local"];
									};
									if("RU" in MSO_FACTIONS || "INS" in MSO_FACTIONS || "GUE" in MSO_FACTIONS || "cwr2_ru" in MSO_FACTIONS || "cwr2_fia" in MSO_FACTIONS || "tigerianne" in MSO_FACTIONS) then {
											f_builder = mso_core_fnc_createComposition;
									};
									if("BIS_TK" in MSO_FACTIONS || "BIS_TK_INS" in MSO_FACTIONS || "BIS_TK_GUE" in MSO_FACTIONS) then {
											f_builder = mso_core_fnc_createCompositionE;
									};
									if (count _camp == 0) then {
											_camp = _camp + ["anti-air_ru1","camp_ru1","camp_ru2","firebase_ru1","heli_park_ru1","mediumtentcamp2_ru","mediumtentcamp3_ru","mediumtentcamp_ru","radar_site_ru1"];
											f_builder = mso_core_fnc_createComposition;
									};
									if (count _camp > 0) then {
											_camp = _camp call BIS_fnc_selectRandom;
											//_pos = [_pos, 0, 50, 10, 0, 2, 0] call bis_fnc_findSafePos;
											_pos = [_pos,500,0.15,5] call rmm_ep_getFlatArea;
											[_camp, [_pos, position _loc] call BIS_fnc_dirTo, _pos] call f_builder;
											if (_debug) then {diag_log format ["Camp created at %1 (%2)", _pos, _loc];}; 
									};
							};
							
							_type = [["Infantry", "Motorized", "Mechanized", "Armored"],[rmm_ep_inf,rmm_ep_mot,rmm_ep_mec,rmm_ep_arm]] call mso_core_fnc_selectRandomBias;
							
							[_pos, _flag, _type] spawn {
									private ["_pos","_pos2","_flag","_group","_grp2","_type"];
									_pos = _this select 0;
									_flag = _this select 1;
									_type= _this select 2;
									waitUntil{sleep 3; ([_pos, rmm_ep_spawn_dist] call fPlayersInside)};
									_group = nil;
									_pos2 = [_pos, 0, 50, 10, 0, 5, 0] call bis_fnc_findSafePos;
									while{isNil "_group"} do {
											_group = [_pos2, _type, MSO_FACTIONS] call mso_core_fnc_randomGroup;
									};
									(leader _group) setBehaviour "STEALTH";
									_group setSpeedMode "LIMITED";
									_group setFormation "DIAMOND";
									if(_flag >= ep_campprob || count units _group <= 2) then {
											[_group,_group,100,4 + random 4, "MOVE", "STEALTH", "RED", "LIMITED", "DIAMOND", "", [480,800,1120]] call CBA_fnc_taskPatrol;
									};
									if(_flag < ep_campprob && _type == "Infantry") then {
											leader _group setPos _pos;
											[_group] call BIN_fnc_taskDefend;
									};
									if(_flag < ep_campprob && _type != "Infantry") then {
											[_group,_group,100,4 + random 6, "MOVE", "AWARE", "RED", "LIMITED", "STAG COLUMN", "if (dayTime < 18 or dayTime > 6) then {this setbehaviour ""STEALTH""}", [120,200,280]] call CBA_fnc_taskPatrol;
											_grp2 = grpNull;
											while{count units _grp2 <= 2} do {
													{deleteVehicle _x} count units _grp2;
													_grp2 = [_pos, "Infantry", MSO_FACTIONS] call mso_core_fnc_randomGroup;
											};
											[_grp2] call BIN_fnc_taskDefend;
											ep_groups set [count ep_groups, _grp2];
									};
									ep_groups set [count ep_groups, _group];
							};
					};
			};
		};
        if (count _pos != 0) then {
                if(ep_total mod 10 == 0) then {
                        diag_log format["MSO-%1 Enemy Population # %2", time, ep_total];
                        if(_debug) then {hint format["MSO-%1 Enemy Population # %2", time, ep_total];};
                };
                if(_debug) then {
                        private["_t","_m"];
                        _t = format["op%1",floor(random 10000)];
                        if(isNil "_type") then {_type = "";};
                        _m = [_t, _pos, "Icon", [1,1], "TYPE:", "Dot", "TEXT:", _type, "GLOBAL", "PERSIST"] call CBA_fnc_createMarker;
                };
        };
};

diag_log format["MSO-%1 Enemy Population # %2", time, ep_total];
if(_debug)then{hint format["MSO-%1 Enemy Population # %2", time, ep_total];};
