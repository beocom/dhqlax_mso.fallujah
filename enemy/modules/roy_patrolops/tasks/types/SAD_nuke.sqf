if(count mps_loc_towns < 1) exitWith {diag_log [diag_frameno, diag_ticktime, time, "No Towns found - exiting PO2 Task"];};
diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK SAD_nuke.sqf"];

_debug = debug_mso;
DISARM_NUKE = false;
Publicvariable "DISARM_NUKE";

_location01 = (mps_loc_towns call mps_getRandomElement);

while {_location01 == mps_loc_last} do {
	_location01 = (mps_loc_towns call mps_getRandomElement); 
    sleep 0.1;
};

mps_loc_last = _location01;

_location02 = (mps_loc_towns call mps_getRandomElement);

while {_location02 == mps_loc_last} do {
	_location02 = (mps_loc_towns call mps_getRandomElement); 
    sleep 0.1;
};

mps_loc_last = _location02;

_location03 = (mps_loc_towns call mps_getRandomElement);

while {_location03 == mps_loc_last} do {
	_location03 = (mps_loc_towns call mps_getRandomElement); 
    sleep 0.1;
};

mps_loc_last = _location03;

if (_debug) then {diag_log format["MSO-%1 PO2 Task Nuke: Location 1: (%2) Location 2: (%3) Location 3: (%4)", time, position _location01, position _location02, position _location03]};

_position01 = [(position _location01) select 0,(position _location01) select 1, 0];
_cachelocs01 = [_position01,300] call mps_getEnterableHouses;
if (_debug) then {diag_log format["MSO-%1 PO2 Task Nuke: Houses found %2", time, count _cachelocs01]};

sleep 1;

_position02 = [(position _location02) select 0,(position _location02) select 1, 0];
_cachelocs02 = [_position02,300] call mps_getEnterableHouses;
if (_debug) then {diag_log format["MSO-%1 PO2 Task Nuke: Houses found %2", time, count _cachelocs02]};

sleep 1;

_position03 = [(position _location03) select 0,(position _location03) select 1, 0];
_cachelocs03 = [_position03,300] call mps_getEnterableHouses;
if (_debug) then {diag_log format["MSO-%1 PO2 Task Nuke: Houses found %2", time, count _cachelocs03]};

sleep 1;

_cachelocs = _cachelocs01 + _cachelocs02 + _cachelocs03;

if (_debug) then {diag_log format["MSO-%1 PO2 Task Nuke: Houses found total %2", time, count _cachelocs]};

_taskid = format["%1%2%3",round (_position01 select 0),round (_position01 select 1),(round random 999)];

_bombtype = "SkeetMachine";

_bomb = _bombtype createvehicle (_position02);

_hideout = [];
_Enemies = [];

	for "_i" from 1 to 10000 do {
		_house = _cachelocs call mps_getRandomElement;
		_cachelocs = _cachelocs - [_house];
		_buildingpos = round random (_house select 1);
		_house = _house select 0;
		_hideout = (_house buildingPos _buildingpos);
		if(count (_hideout - [0]) > 0) exitWith{};
		_hideout = [(getPos _cache1 select 0) + _size - random (2*_size),(getPos _cache1 select 1) + _size - random (2*_size),0];
	};
	_bomb setPos _hideout;
	
	[2,[_bomb],{
           DISARMACTION = (_this select 0) addAction ["Disarm Nuclear Bomb", "enemy\modules\roy_patrolops\mps\action\rmm_disarm_nuke.sqf", "", 1, false, true, "", "(player distance _target < 2) && !(DISARM_NUKE)"];
	}] call mso_core_fnc_ExMP;

	if (_debug) then {diag_log format["MSO-%1 PO2 Task Nuke: Bomb set at %2", time, _hideout]};

if(_debug) then {
	_marker = createMarkerLocal [format["Debug1%1",_taskid],position _bomb];
	_marker setMarkerTypeLocal "mil_dot";
	_marker setMarkerColorLocal "ColorGreen"; sleep 1;
};

_rmin = 0;
_rmax = 1;
_rplayers = 1 max (playersNumber (SIDE_A select 0));
_ra = (_rmax-_rmin)/(mps_ref_playercount-1);
_rb = _rmin - _ra;
_diffresult = round(_rplayers * _ra + _rb);

_b = (2 max (round (random (playersNumber (SIDE_A select 0) / 3)))) * MISSIONDIFF;

_position = _position01;
_stance = ["patrol","hide"] call mps_getRandomElement;
_grp = [_position,"INF",(5 + random 5),50,_stance ] call CREATE_OPFOR_SQUAD;
if( _diffresult > 0.18 ) then { [_position] spawn CREATE_OPFOR_SNIPERS };

sleep 0.3;

_position = _position02;
_stance = ["patrol","hide"] call mps_getRandomElement;
_grp = [_position,"INF",(5 + random 5),50,_stance ] call CREATE_OPFOR_SQUAD;
if( _diffresult > 0.18 ) then { [_position] spawn CREATE_OPFOR_SNIPERS };

sleep 0.3;

_position = _position03;
_stance = ["patrol","hide"] call mps_getRandomElement;
_grp = [_position,"INF",(5 + random 5),50,_stance ] call CREATE_OPFOR_SQUAD;
if( _diffresult > 0.18 ) then { [_position] spawn CREATE_OPFOR_SNIPERS };

sleep 0.3;

[format["TASK%1",_taskid],
	"Nuclear Threat!",
	format["We just received HUMINT of a nuclear threat! We know of 3 towns where Insurgents could hide a nuclear bomb and need to search the following areas: %1, %2 or %3. If you find the bomb in time disarm it as quickly as you possible. Afterwards, return to base for decontamination immediatly!", text _location01, text _location02, text _location03],
	true,
	[format["MARK%1",_taskid],(_position01),"hd_objective","ColorRedAlpha"," Target"],
	"created",
	_position01
] call mps_tasks_add;

bombalive = true;
_nuketime = 0;
While {!ABORTTASK_PO AND bombalive AND (_nuketime < 1800)} do {
    									if (damage _bomb < 1 AND (!DISARM_NUKE)) then {bombalive = true} else {bombalive = false};
    									sleep (10);
                                        _nuketime = _nuketime + 10;
                                        if (_debug) then {diag_log format["MSO-%1 PO2 Task Nuke: waiting until timeout! Time: %2...", time, _nuketime]};
                                        };

if (!bombalive) then {
    [format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	mps_mission_status = 2;
} else {
    [format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
	mps_mission_status = 3;
    [position _bomb] spawn {
        _sleep = 120 + floor(random 200);
        [2,[_sleep],{
           PAPABEAR sideChat format ["%1 this is PAPA BEAR. Nuke countdown started! You have about %2 minutes to clear the area!", group player, floor((_this select 0) / 60)];
		}] call mso_core_fnc_ExMP;
        sleep 30;
        _sleep = _sleep - 30;
		[2,[_sleep],{
           PAPABEAR sideChat format ["%1 this is PAPA BEAR. I repeat! You have %2 minutes to clear the area!", group player, floor((_this select 0) / 60)];
		}] call mso_core_fnc_ExMP;
        if (_debug) then {diag_log format["MSO-%1 PO2 Task Nuke: Nuke countdown startet: %2 seconds!", time, _sleep]};
        sleep _sleep;
        [_this select 0] execvm "scripts\nuke\nuke.sqf";
    };
};