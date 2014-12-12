// IED Detection and Disposal Mod
// 2011 by Reezo

private ["_caller","_range","_rangeMin","_rangeMax","_probability","_interval","_object","_id"];
_caller = _this select 1;
if !(local _caller) exitWith{diag_log "EOD script not running locally on caller machine. Exiting";};
_object = _this select 0;
_id = _this select 2;
_range = (_this select 3) select 1;
if (count _range != 2) exitWith{diag_log "EOD script range is incorrect. Exiting";};
_rangeMin = _range select 0;
_rangeMax = _range select 1;
_probability = (_this select 3) select 2;
_interval = (_this select 3) select 3;

_object = vehicle _object;

if (_object getvariable ["LoudspeakerInUse",false]) exitwith {hint "Loudspeaker is currently in use."}; 

diag_log format["EOD CLIENT: OBJECT:%1, CALLER:%2, RANGE:%3, PROBABILITY:%4, INTERVAL:%5",_object,_caller,_range,_probability,_interval];		

_object setvariable ["LoudspeakerInUse",true,true];

private ["_rnd"];
_rnd = random 1;
if (_rnd < 0.5) then {
	[_object, "reezo_eod_sound_evacuate"] call CBA_fnc_globalSay3d;
} else {
	[_object, "reezo_eod_sound_evacuate02"] call CBA_fnc_globalSay3d;
};

_object removeaction _id;
_object removeaction (_id - 1);

// Call evacuate script on server
[0, {[_this select 0, _this select 1, _this select 2] execVM "x\eod\addons\eod\tup_eod_fnc_evacuate_server.sqf"}, [_range,_probability,_object]] call CBA_fnc_globalExecute;

sleep _interval;

_object setvariable ["LoudspeakerInUse",false,true];

waitUntil {!(isNull _caller)};
waitUntil {_caller == _caller};
waitUntil {alive _caller};

nul0 = [_object,_range,_probability,_interval] execVM "x\eod\addons\eod\reezo_eod_action_add_loudspeaker.sqf";

if (true) exitWith{};