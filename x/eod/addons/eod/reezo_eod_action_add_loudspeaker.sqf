// IED Detection and Disposal Mod
// 2011 by Reezo

private ["_soldier","_range","_probability","_interval","_reezo_eod_action_loudspeaker"];
_soldier = _this select 0;
/* if !(local _soldier) exitWith {
	//player globalChat "SOLDIER NOT LOCAL, EXITING";
};*/
_range = _this select 1;
_probability = _this select 2;
_interval = _this select 3;

waitUntil {!(isNull _soldier)};
waitUntil {_soldier == _soldier};
waitUntil {alive _soldier};

_reezo_eod_action_loudspeaker = _soldier addAction ['<t color="#FF9900">'+"Loudspeaker (Evacuate Civilians)"+'</t>', "x\eod\addons\eod\reezo_eod_action_loudspeaker_evacuate.sqf", [_soldier,_range,_probability,_interval], 0, false, true, "",""];

if (true) exitWith{};