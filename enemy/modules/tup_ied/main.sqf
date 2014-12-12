// Simple script to set up triggers at each location to spawn IED and Suicide Bombers

#include <crbprofiler.hpp>

private ["_debug"];

_debug = debug_mso;

if (isNil "tup_ied_header")then{tup_ied_header = 1;};
if ((!isServer) || (tup_ied_header == 0)) exitWith{};
if (isNil "tup_ied_enemy")then{tup_ied_enemy = 0;};
if (isNil "tup_ied_eod")then{tup_ied_eod = 1;};
if (isNil "tup_ied_threat")then{tup_ied_threat = 50;};
if (isNil "tup_suicide_threat")then{tup_suicide_threat = 10;};

// Set up Bombers and IEDs at each location (except any player starting location)
{
	private ["_fate","_pos","_trg","_twn"];
	_pos = getposATL _x;
	//_twn = (nearestLocations [_pos, ["NameCityCapital","NameCity","NameVillage","Strategic","VegetationVineyard","NameLocal"], 200]) select 0;
	_twn = nearestLocation [_pos, ""];
	_size = (size _twn) select 0;
	if (_size < 250) then {_size = 250;};
	if (_debug) then {
		diag_log format ["town is %1 at %2. %3m in size and type %4", text _twn, position _twn, _size, type _twn];
	};

	if (({(getpos _x distance _pos) < _size} count ([] call BIS_fnc_listPlayers) == 0) && ((_pos distance getmarkerpos "ammo") > 250) && ((_pos distance getmarkerpos "ammo_1") > 250)) then {		
		_fate = random 100;
		if (_fate < tup_suicide_threat && ambientCivs == 1) then {
			// Place Suicide Bomber trigger
			_trg = createTrigger["EmptyDetector",getpos _twn]; 
			_trg setTriggerArea[(_size+250),(_size+250),0,false];
			_trg setTriggerActivation["WEST","PRESENT",true];
			_trg setTriggerStatements["this && ({(vehicle _x in thisList) && ((getposATL _x) select 2 < 25)} count ([] call BIS_fnc_listPlayers) > 0)", format ["null = [getpos (thisTrigger), thisList, %1] execvm 'enemy\modules\tup_ied\Ambient_Bomber.sqf';",_size], "null = [getposATL (thisTrigger)] execvm 'enemy\modules\tup_ied\Remove_Bomber.sqf';"]; 
		
			 if (_debug) then {
				_t = format["suic_t%1", random 1000];
				diag_log format ["MSO-%1 Suicide Bomber Trigger: created at %2 (%3)", time, text _twn, mapgridposition  _x];
				[_t, getpos _twn, "Ellipse", [_size+250,_size+250], "TEXT:", text _twn, "COLOR:", "ColorOrange", "BRUSH:", "Border", "GLOBAL","PERSIST"] call CBA_fnc_createMarker;
			};
		};

		if (_fate < tup_ied_threat) then {
			// Place IED trigger
			_trg = createTrigger["EmptyDetector",getpos _twn]; 
			_trg setTriggerArea[(_size+250), (_size+250),0,false];
			if (tup_ied_enemy == 1) then {
				_trg setTriggerActivation["ANY","PRESENT",false]; // true = repeated
				_trg setTriggerStatements["this && ({(vehicle _x in thisList) && ((getposATL _x) select 2 < 75)} count ([] call BIS_fnc_listPlayers) > 0)",	format ["null = [getpos (thisTrigger),%1] execvm 'enemy\modules\tup_ied\Ambient_IED.sqf'",_size], ""]; // for repeated = format ["null = [getposATL (thisTrigger),%1] execvm 'enemy\modules\tup_ied\Remove_IED.sqf';"
			} else {
				_trg setTriggerActivation["WEST","PRESENT",false]; // true = repeated
				_trg setTriggerStatements["this && ({(vehicle _x in thisList) && ((getposATL _x) select 2 < 75)} count ([] call BIS_fnc_listPlayers) > 0)", format ["null = [getpos (thisTrigger),%1] execvm 'enemy\modules\tup_ied\Ambient_IED.sqf'",_size], ""]; // for repeated = format ["null = [getposATL (thisTrigger),%1] execvm 'enemy\modules\tup_ied\Remove_IED.sqf';"
			};

			if (_debug) then {
				_t = format["ied_t%1", random 1000];
				diag_log format ["MSO-%1 IED Trigger: created at %2 (%3)", time, text _twn, mapgridposition  _x];
				[_t, getpos _twn, "Ellipse", [_size+245,_size+245], "TEXT:", text _twn, "COLOR:", "ColorYellow", "BRUSH:", "Border", "GLOBAL","PERSIST"] call CBA_fnc_createMarker;
			};
		};
	};
} foreach (bis_functions_mainscope getvariable "locations");



