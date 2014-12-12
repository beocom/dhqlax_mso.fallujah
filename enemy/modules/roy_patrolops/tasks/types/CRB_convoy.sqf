//
//NOTE: THIS MISSION IS ONLY COMPATIBLE WITH MSO CORE LOADED!
//

if(!isServer) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK CRB_convoy.sqf"];
private["_taskid","_grp","_debug","_strategic","_spawnpoints","_convoydest","_numconvoys"];

_debug = debug_mso;
if(isNil "crb_convoy_intensity")then{crb_convoy_intensity = 1;};
crb_convoy_intensity = switch(crb_convoy_intensity) do {
	case 0: {
		0;
	};
	case 1: {
		0.5;
	};
	case 2: {
		1;
	};
};


waitUntil{!isNil "BIS_fnc_init"};
if(isNil "CRB_LOCS") then {
        CRB_LOCS = [] call mso_core_fnc_initLocations;
};

_strategic = ["StrongPoint","CityCenter","FlatAreaCity","Airport","NameCity","NameCityCapital","NameVillage"];
_spawnpoints = [];
_convoydest = [];
{
        private["_t","_m"];
        if(type _x == "BorderCrossing") then {
                _spawnpoints set [count _spawnpoints, position _x];
                if (_debug) then {
                        _t = format["convoy_s%1", floor(random 10000)];
                        _m = [_t, position _x, "Icon", [1,1], "TYPE:", "Destroy", "GLOBAL", "PERSIST"] call CBA_fnc_createMarker;
                };
        };
        if(type _x in _strategic) then {
                _convoydest set [count _convoydest, position _x];
                if (_debug) then {
                        _t = format["convoy_d%1", floor(random 10000)];
                        _m = [_t, position _x, "Icon", [1,1], "TYPE:", "Dot", "COLOR:", "ColorOrange", "GLOBAL", "PERSIST"] call CBA_fnc_createMarker;
                };
        };
} forEach CRB_LOCS;

if(count _spawnpoints == 0) then {_spawnpoints = _convoydest;};

//_numconvoys = ceil((count _convoydest) * crb_convoy_intensity / 25);
_numconvoys = 1;
diag_log format["MSO-%1 Convoy: destinations(%2) spawns(%3) convoys(%4)", time, count _convoydest, count _spawnpoints, _numconvoys];

stopscript = false;

for "_j" from 1 to _numconvoys do {
        [_j, _spawnpoints, _convoydest, _debug] spawn {
                private ["_timeout","_startpos","_destpos","_endpos","_grp","_front","_facs","_wp","_cid","_t","_j","_spawnpoints","_convoydest","_debug","_sleep","_strnone","_strlittle","_strgood","_type"];
                _j = _this select 0;
                _spawnpoints = _this select 1;
                _convoydest = _this select 2;
                _debug = _this select 3;
                
                _timeout = if(_debug) then {[30, 30, 30];} else {[30, 120, 300];};
                        
                        // _startpos = ((_spawnpoints call BIS_fnc_selectRandom) nearRoads 200) call BIS_fnc_selectRandom; 
						_startpos = _spawnpoints call BIS_fnc_selectRandom;
                        _startpos = [_startpos, 0, 50, 0, 0, 10, 0] call BIS_fnc_findSafePos;
                        _destpos = (_convoydest call BIS_fnc_selectRandom);
                        _destpos = [_destpos, 0, 100, 10, 0, 10, 0] call BIS_fnc_findSafePos;
                        _endpos = _spawnpoints call BIS_fnc_selectRandom;
                        _endpos = [_endpos, 0, 50, 0, 0, 10, 0] call BIS_fnc_findSafePos;
                        _grp = nil;
                        _front = "";
                        _taskid = format["%1%2%3",round (_destpos select 0),round (_destpos select 1),(round random 999)];
                                               
                        while{isNil "_grp"} do {
                                _front = [["Motorized","Mechanized","Armored"],[4,2,1]] call mso_core_fnc_selectRandomBias;
                                _facs = MSO_FACTIONS;
                                _grp = [_startpos, _front, _facs] call mso_core_fnc_randomGroup;
                        };
                        diag_log format["MSO-%1 Convoy: #%2 %3 %4 %5 %6", time, _j, _startpos, _destpos, _endpos, _front];
                        
                        switch(_front) do {
                                case "Motorized": {
                                        for "_i" from 0 to floor(random 2) do {
                                                _type = ([0, MSO_FACTIONS] call mso_core_fnc_findVehicleType) call BIS_fnc_selectRandom;
                                                if(_type isKindOf "Air") then {_startpos set [2, 500];};
                                                [[_startpos, 50] call CBA_fnc_randPos, 0, _type, _grp] call BIS_fnc_spawnVehicle;
                                        };
                                };
                                case "Mechanized": {
                                        for "_i" from 0 to (1 + floor(random 2)) do {
                                                _type = ([0, MSO_FACTIONS] call mso_core_fnc_findVehicleType) call BIS_fnc_selectRandom;
                                                if(_type isKindOf "Air") then {_startpos set [2, 500];};
                                                [[_startpos, 50] call CBA_fnc_randPos, 0, _type, _grp] call BIS_fnc_spawnVehicle;
                                        };
                                        if(random 1 > 0.5) then {[[_startpos, 50] call CBA_fnc_randPos, 0, ([0, MSO_FACTIONS] call mso_core_fnc_findVehicleType) call BIS_fnc_selectRandom, _grp] call BIS_fnc_spawnVehicle;};
                                };
                                case "Armored": {
                                        for "_i" from 0 to (2 + floor(random 1)) do {
                                                _type = ([0, MSO_FACTIONS] call mso_core_fnc_findVehicleType) call BIS_fnc_selectRandom;
                                                if(_type isKindOf "Air") then {_startpos set [2, 500];};

                                                [[_startpos, 50] call CBA_fnc_randPos, 0, _type, _grp] call BIS_fnc_spawnVehicle;
                                        };
                                        _type = ([0, MSO_FACTIONS] call mso_core_fnc_findVehicleType) call BIS_fnc_selectRandom;
                                        if(_type isKindOf "Air") then {_startpos set [2, 500];};
                                        [[_startpos, 50] call CBA_fnc_randPos, 0, ([0, MSO_FACTIONS] call mso_core_fnc_findVehicleType) call BIS_fnc_selectRandom, _grp] call BIS_fnc_spawnVehicle;
                                };
                        };
                        
                        
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
                        
                        _cid = floor(random 10000);
                        _t = format["s%1",_cid];
                        [_t, _startpos, "Icon", [1,1], "TEXT:", _t, "TYPE:", "Start", "COLOR:", "ColorGreen", "GLOBAL", "PERSIST"] call CBA_fnc_createMarker;
                        
                        _t = format["d%1",_cid];
                        [_t, _destpos, "Icon", [1,1], "TEXT:", _t, "TYPE:", "Pickup", "COLOR:", "ColorYellow", "GLOBAL", "PERSIST"] call CBA_fnc_createMarker;
                        
                        _t = format["e%1",_cid];
                        [_t, _endpos, "Icon", [1,1], "TEXT:", _t, "TYPE:", "End", "COLOR:", "ColorRed", "GLOBAL", "PERSIST"] call CBA_fnc_createMarker;
                        
                        {
                        	_x setSkill 0.9;
                        	_x setVariable ["CEP_disableCache", true, true];
                        } forEach units _grp;
                        
                        _grp setVariable ["rmm_gtk_exclude", true];
                        
                        //KIERANS ADDITION - task addition
                        
                        //declare private task vars
                        private ["_taskname","_tasktitle","_taskmessage","_taskhud","_taskarmor", "_taskintel","_tr"];
                        //get a random number, if 1 or 2, intel is provided, if 0, no intel
                        _taskintel = floor(random(3));
                        
                        //detect what type of units will be there if intel is avaliable
                        _strnone = "There is no Intel on the strength of this patrol.";
                        _strlittle = "Avaliable intel reports indicate little or no armored units in the convoy.";
                        _strgood = "Avaliable intel reports indicate a good chance of armored units in the convoy.";
                        if (_taskintel != 0) then {
                                switch (_front) do {
                                        case "Motorized": {
                                                //report limited armor (motor or mech)
                                                _taskarmor = _strlittle;
                                        }; //end case
                                        
                                        case "Mechanized": {
                                                //chance of either report (motor, mech or heavy)
                                                _tr = floor(random(2));
                                                if (_tr != 1) then {
                                                        _taskarmor = _strlittle;
                                                } else {
                                                        _taskarmor = _strgood;
                                                }; //end if-else
                                        }; //end case
                                        
                                        case "Armored": {
                                                //report armor (mech or heavy)
                                                _taskarmor = _strgood;
                                        }; //end case
                                        
                                }; //end switch
                                
                        } else{
                                _taskarmor = _strnone;
                        }; //end if-else
                        
                        //DEBUG
                        if(_debug) then {diag_log format["MSO-%1 Convoy %2 Type: %3, Intel: %4", time, _cid, _front, _taskarmor];};
                        
                        //setup text for task
                        _taskname = format["convoy_ambush_%1",_cid];
                        _tasktitle = format["Ambush Convoy #%1", _cid];
                        _taskmessage = format["An enemy convoy (ID #%1) has been sighted entering the AO at <marker name='s%1'>S%1</marker>, travelling to <marker name='d%1'>D%1</marker> and halting at <marker name='e%1'>E%1</marker> before it returns.<br/><br/>Your task is to destroy this convoy, noone must be left alive.<br/><br/>%2", _cid, _taskarmor];
                        _taskhud = _tasktitle;
                        
                        //setup task                                                
                             [ 	format["TASK%1",_taskid],
								_tasktitle,
								_taskmessage,
								(SIDE_A select 0),
								[format["MARK%1",_taskid],(_destpos),"hd_objective","ColorRedAlpha","Target"],
								"created",
								_destpos
							] call mps_tasks_add;
                    
                        //DEBUG
                        if(_debug) then {diag_log format["MSO-%1 Convoy %2 Task Info - NAME: %3, TITLE: %4, MESS: %5, HUD: %6", time, _cid, _taskname, _tasktitle, _taskmessage, _taskhud];};
                  
                        //DEBUG
                        if(_debug) then {diag_log format["MSO-%1 Convoy %2 Task ID: %3", time, _cid, _taskid];};
                        
                        //END KIERANS ADDITION	   
                       
                        while {(!ABORTTASK_PO) && (_grp call CBA_fnc_isAlive)} do {
                            sleep 5;
                            {
                        		if (vehicle _x == _x) then {deletevehicle _x};
                            } foreach units _grp;
                        };
                        
                        //alert the players
                        
                        if(!ABORTTASK_PO && !(_grp call CBA_fnc_isAlive)) then {
						[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
						mps_mission_status = 2;
						}else{
						[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
						mps_mission_status = 3;
						};
                        
                        stopscript = true;
                        
                        //END KIERANS ADDITION
                        
                        deletegroup _grp;
                        _t = format["s%1",_cid];
                        deleteMarker _t;
                        
                        _t = format["d%1",_cid];
                        deleteMarker _t;
                        
                        _t = format["e%1",_cid];
                        deleteMarker _t;
       };
};

diag_log format["MSO-%1 Convoys # %2", time, _numconvoys];

while {!ABORTTASK_PO && !stopscript} do {
    if (_debug) then {diag_log [diag_frameno, diag_ticktime, time, "waiting..."]};
    sleep 5;
};





