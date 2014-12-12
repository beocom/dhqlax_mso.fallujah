if(count ep_locations < 1) exitWith{};
diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK SNI_HVT.sqf"];

private["_killtasktime","_AO","_location","_taskid","_position","_types","_unittypes","_unittype","_HVTgrp","_HVT","_cleared"];

_AO = (ep_locations call mps_getRandomElement);
_AOtype = _AO select 0;
while {!((_AOtype == "Camp") or (_AOtype == "AA") or (_AOtype == "RB"))} do {
    _AO = (ep_locations call mps_getRandomElement);
    _AOtype = _AO select 0;
    sleep 0.1;
};
_position = _AO select 1;
_HVTgrp = nil;
_HVT = nil;
_killtasktime = 0;

_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];

sleep 1;
_di = 1000; 
_neartwns = nearestLocations [_position, ["NameVillage","NameCity","NameCityCapital","NameLocal"], _di];
while {count _neartwns < 1} do {
    _di = _di + 500;
    _neartwns = nearestLocations [_position, ["NameVillage","NameCity","NameCityCapital","NameLocal"], _di];
};
_nearesttwn = _neartwns select 0;

switch (_AOtype) do {
    
    case "Camp": {

		_obj = "FoldTable" createVehicle _position;
		_obj setdir 0;
		_objSat = "SatPhone" createVehicle getPos _obj;
		_objSat attachto [_obj,[0,0,0.6]];
        
        _HVTgrp = creategroup EAST;
		"RU_Functionary1" createUnit [_position, _HVTgrp];
        _HVT = leader _HVTgrp;
        _HVT setformdir 0;
		_HVT setpos [getpos _obj select 0,(getpos _obj select 1)-0.7,0];

		_HVTgrp2 = creategroup EAST;
		"RU_Functionary1" createUnit [getpos _obj, _HVTgrp2];
		_HVT2 = leader _HVTgrp2;
		_HVT2 setformdir 180;
		_HVT2 setpos [getpos _obj select 0,(getpos _obj select 1)+0.7,0];

		[_HVT,_HVT2] spawn {

			_HVT = _this select 0;
			_HVT2 = _this select 1;

			while {alive _HVT} do {
				_HVT playmove "ActsPercSnonWnonDnon_tableSupport_TalkA";
				sleep 60;
				_HVT2 playmove "ActsPercSnonWnonDnon_tableSupport_TalkB";
				sleep 60;
			};
		};

        _chkdist = 200;
        
		[
        	format["TASK%1",_taskid],
			format["Eliminate High Value Target!", _taskid],
			format["We received HUMINT of an High Value Target (HVT) near %1! Eliminate the target as quickly as possible!", text _nearesttwn],
			true,
			[format["MARK%1",_taskid],(_position),"hd_objective","ColorRedAlpha","Target"],
			"created",
			_position
		] call mps_tasks_add;
	};
    case "AA": {
        _chkdist = 200;
        
        [
        	format["TASK%1",_taskid],
			format["Take out AAA placement near %1!",text _nearesttwn],
			format["An hostile AAA camp was revealed in the area of %1! Take out all surrounding enemies!",text _nearesttwn],
			true,
			[format["MARK%1",_taskid],(_position),"hd_objective","ColorRedAlpha","Target"],
			"created",
			_position
		] call mps_tasks_add;

    };
    case "RB": {
        _chkdist = 150;
        
        [
        	format["TASK%1",_taskid],
			format["Clear enemy roadblock in %1!",text _nearesttwn],
			format["We received HUMINT about a roadblock in the vicinity of %1! Recon the area and eliminate all enemies at the reported site!",text _nearesttwn],
			true,
			[format["MARK%1",_taskid],(_position),"hd_objective","ColorRedAlpha","Target"],
			"created",
			_position
		] call mps_tasks_add;
    };
};

_cleared = false;
_cntr = 0;                                                                                 		                    
while {!(ABORTTASK_PO) && (_killtasktime < 7200) && !(_cleared)} do {
    if ([_position, rmm_ep_spawn_dist] call fPlayersInside) then {
        sleep 2;
        _EnemyCnt = {(str(side _x) != "west") && (str(side _x) != "Civilian") && alive _x} count (nearestObjects [_position, ["CAManBase","Tank"], 500]);
        if (_EnemyCnt == 0) then {
            if (_cntr > 20) then {_cleared = true};
            _cntr = _cntr + 2;
        } else {
            _cntr = 0;
        };
        if !(isnil "_HVT") then {if !(alive _HVT) then {_cleared = true};};
	} else {
        _killtasktime = _killtasktime + 2;
        _cntr = 0;
    	sleep 2;	
    };
};

if (!ABORTTASK_PO && _cleared) then {
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	{deletevehicle _x} foreach _units;
    {deletevehicle _x} foreach (units _HVTgrp);
    {deletevehicle _x} foreach (units _HVTgrp2);
    deletegroup _HVTgrp;
    deletegroup _HVTgrp2;

    _idx = [ep_locations, _AO] call BIS_fnc_arrayFindDeep;
    if (typename _idx == "ARRAY") then {
    	_idx = _idx select 0;
    	ep_locations set [_idx, ">REMOVE<"];
   		ep_locations = ep_locations - [">REMOVE<"];
    };

    mps_mission_status = 2;
} else {
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
    {deletevehicle _x} foreach (units _HVTgrp);
    {deletevehicle _x} foreach (units _HVTgrp2);
    deletegroup _HVTgrp;
    deletegroup _HVTgrp2;
    
    _idx = [ep_locations, _AO] call BIS_fnc_arrayFindDeep;
    _idx = _idx select 0;
    ep_locations set [_idx, ">REMOVE<"];
    ep_locations = ep_locations - [">REMOVE<"];
    
    mps_mission_status = 3;
};