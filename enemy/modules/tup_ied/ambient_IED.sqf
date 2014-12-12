// Ambient IED - create IED at location (could be EOD IED)
private ["_location","_twn","_debug","_numIEDs","_j","_size","_posloc"];

if !(isServer) exitWith {diag_log "Ambient IED Not running on server!";};

_location = _this select 0;
_size = _this select 1;

_debug = debug_mso;
_numIEDs = round ((_size / 50) * (tup_ied_threat / 100));

// Check for Enemy in vicinty - if so double IED count
if ({(side leader _x == east) && (getposATL leader _x in _location)} count (allgroups) > 0) then {
	_numIEDs = _numIEDs * 2;
	if (_numIEDs > 400) then {_numIEDs = 400;};
};

diag_log format ["MSO-%1 IED: creating %2 IEDs at %3 (size %4)", time, _numIEDs, mapgridposition  _location, _size];

// Find positions in area
_posloc = [];
_posloc = [_location, true, true, true, _size] call tup_ied_fnc_placeIED;
if (_debug) then {
	diag_log format ["MSO-%1 IED: Found %2 spots for IEDs",time, count _posloc];
};

for "_j" from 1 to _numIEDs do {
	private ["_IEDpos","_pos","_cen","_near"];
	// Select Position for IED and remove position used
	_index = round (random ((count _posloc) -1));
	_pos = _posloc select _index;
	_posloc set [_index, -1];
	_posloc = _posloc - [-1];
	// Find safe location - if no safe pos find random position within 6m
	_IEDpos = [_pos, 4, 20, 2, 0, 0, 0,[],[[((_pos select 0) - 6) + random 12, ((_pos select 1) - 6) + random 12, 0]]] call BIS_fnc_findSafePos;

	private ["_IEDskins","_IED","_near","_choice"];
	// Check no other IEDs nearby
	_near = nearestObjects [_IEDpos, ["Land_IED_v1_PMC","Land_IED_v2_PMC","Land_IED_v3_PMC","Land_IED_v4_PMC","Land_Misc_Rubble_EP1","Land_Misc_Garb_Heap_EP1","Garbage_container","Misc_TyreHeapEP1","Misc_TyreHeap","Garbage_can","Land_bags_EP1"], 10];
	if (count _near > 0) exitWith {diag_log format ["MSO-%1 IED: exiting as other IEDs found %2",time,_near];}; //Exit if other IEDs are found
	
	// Check not placed near a player
	if ({(getpos _x distance _IEDpos) < 75} count ([] call BIS_fnc_listPlayers) > 0) exitWith {diag_log format ["MSO-%1 IED: exiting as placement too close to player.",time];}; //Exit if position is too close to a player
	
	// Choose EOD or TUP_IED (50/50 chance)
	private "_choice";
	_choice = random 1;
	if ((isClass(configFile>>"CfgPatches">>"reezo_eod")) && (tup_ied_eod == 1) && (_choice > 0.4)) then {
		("reezo_eod_iedarea" createUnit [_IEDpos, group BIS_functions_mainscope,
			format["this setVariable ['reezo_eod_range',[0,%1]];
			this setVariable ['reezo_eod_probability',1];
			this setVariable ['reezo_eod_interval',1];",_size], 
			0, ""]);
	} else {
		// Create non-eod IED
		// Select type of IED
		if (isOnRoad _IEDpos) then {
			_IEDskins = ["Land_IED_v1_PMC","Land_IED_v2_PMC","Land_IED_v3_PMC","Land_IED_v4_PMC"];
		} else {
			_IEDskins =["Land_IED_v1_PMC","Land_IED_v2_PMC","Land_IED_v3_PMC","Land_IED_v4_PMC","Land_IED_v1_PMC","Land_IED_v2_PMC","Land_IED_v3_PMC","Land_IED_v4_PMC","Land_Misc_Rubble_EP1","Land_Misc_Garb_Heap_EP1","Garbage_container","Misc_TyreHeapEP1","Misc_TyreHeap","Garbage_can","Land_bags_EP1"];
		};
		_IED = createVehicle [_IEDskins call BIS_fnc_selectRandom,_IEDpos, [], 0, ""];
		// Choose IED or Fake IED
		if (random 1 < 0.80) then {
			[_IED, typeOf _IED] execvm "enemy\modules\tup_ied\arm_ied.sqf";
			_IED addeventhandler ["HandleDamage",{
				deletevehicle ((_this select 0) getvariable "Trigger");
				deletevehicle ((_this select 0) getvariable 'Det_Trigger');
				deletevehicle ((_this select 0) getvariable 'Detect_Trigger');
				if (_debug) then {
					diag_log format ["MSO-%1 IED: %2 explodes due to damage by %3", time, (_this select 0), (_this select 3)];
					[(_this select 0) getvariable "Marker"] call cba_fnc_deleteEntity;
				};
				"Sh_82_HE" createVehicle getposATL (_this select 0);
				deletevehicle (_this select 0);
			}];
		} else {
			if (_debug) then {
				diag_log format ["MSO-%1 IED: Planting fake IED (%2) at %3.", time, typeOf _IED, _IEDpos];
			};
		};
	};
};
