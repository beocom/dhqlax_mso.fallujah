// IED Detection and Disposal Mod
// 2011 by Reezo

if (!isServer) exitWith{};

private ["_soldier", "_rangeMin", "_rangeMax","_debug"];
_soldier = _this select 0;
_debug = debug_mso;

if ((getPos _soldier) select 2 > 5) exitWith {};

// spacer..
// spacer..

_rangeMin = (_this select 1) select 0;
_rangeMax = (_this select 1) select 1;

/* REMOVED FOR MSO IMPLEMENTATION AS USING TUP_IED TO SELECT POSITION
//Check for other IEDs in the area
private ["_near"];
_near = nearestObjects [_soldier, ["Land_IED_v1_PMC","Land_IED_v2_PMC","Land_IED_v3_PMC","Land_IED_v4_PMC"], 12];

if (count _near > 0) exitWith {diag_log format ["MSO-%1 EOD IED: exiting as other IEDs found %2",time,_near];}; //Exit if other IEDs are found


//CHECK HOW MANY ROADS ARE IN THE AREA
private ["_nearRoads","_goodSpots","_nearRoads"];
_goodSpots = []; 
_nearRoads = (getPos _soldier) nearRoads _rangeMax;

//FIND SUITABLE SPOTS AT LEAST 2/3 OF THE SOLDIER POSITION
private ["_i"];
for "_i" from 0 to (count _nearRoads - 1) do {
	if ((getPos (_nearRoads select _i)) distance getPos _soldier > _rangeMin && (getPos (_nearRoads select _i)) distance getPos _soldier < _rangeMax) then {
		_goodSpots set [count _goodSpots,getPos (_nearRoads select _i)];
	};
};

_goodSpots = _goodSpots + ([getpos _soldier,false,true,true,_rangeMax] call tup_ied_fnc_placeIED);

if (_debug) then {diag_log format ["Found %1 goodspots for IED",count _goodspots];};

if (count _goodSpots == 0) exitWith {if (_debug) then {diag_log format["MSO-%1 EOD IED: exiting as no suitable positions found.",time];};}; //Exit if no good spots are found
*/

private ["_IEDpos","_IEDskins","_IED"];

//PICK A PLACE AND MAKE SURE NOONE IS NEAR IT
_IEDpos = getpos _soldier;
_IEDpos = [_IEDpos select 0, _IEDpos select 1, 0];
if (_debug) then {diag_log format ["MSO-%1 EOD IED: IED position = %2", time, _IEDpos];};
private ["_nearBodies"];
_nearBodies = _IEDpos nearEntities [["Man","Car","Motorcycle","Tank"],10];
if (count _nearBodies > 0) exitWith {if (_debug) then {diag_log format ["MSO-%1 EOD IED: exiting as near objects found %2",time,_nearBodies];};}; //Exit if bodies are near (this way the IED does not auto-explode on spawn)

//IF IT IS ALL GOOD, SPAWN THE IED
_soldier setVariable ["reezo_eod_avail",false];
if (isOnRoad _IEDpos) then {
	_IEDskins = ["Land_IED_v1_PMC","Land_IED_v2_PMC","Land_IED_v3_PMC","Land_IED_v4_PMC"];
} else {
	_IEDskins =["Land_IED_v1_PMC","Land_IED_v2_PMC","Land_IED_v3_PMC","Land_IED_v4_PMC","Land_IED_v1_PMC","Land_IED_v2_PMC","Land_IED_v3_PMC","Land_IED_v4_PMC","Land_Misc_Rubble_EP1","Land_Misc_Garb_Heap_EP1","Garbage_container","Misc_TyreHeapEP1","Misc_TyreHeap","Garbage_can","Land_bags_EP1","Paleta2"];
};
_IED = createVehicle [_IEDskins select (floor (random (count _IEDskins))),_IEDpos, [], 5 + random 5, "NONE"];
_IED setDir (random 360);

if (_debug) then {
	diag_log format ["MSO-%1 EOD IED: arming IED at %2 of %3",time, position _IED, typeOf _IED];
	//Mark IED position
	_t = format["ied_r%1", floor (random 1000)];
	_tcrm = [_t, position _IED, "Icon", [1,1], "TEXT:", "EOD_IED", "TYPE:", "Dot", "COLOR:", "ColorBlue", "GLOBAL"] call CBA_fnc_createMarker;
	_IED setvariable ["Marker", _tcrm];
};

if (true) exitWith{ nul0 = [_soldier, _IED, _rangeMax] execVM "x\eod\addons\eod\IED_postServerInit.sqf" };