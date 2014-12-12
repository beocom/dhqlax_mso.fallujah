// Disarm IED - ran on client only

private ["_debug","_IED","_caller","_wire","_success","_selectedWire","_ID"];

if (isServer) exitWith {diag_log "disarmIED running on server!";};
_debug = debug_mso;

_IED = _this select 0;
_caller = _this select 1;
_ID = _this select 2;

_IED removeAction _ID;

_IEDskins = ["Land_IED_v1_PMC","Land_IED_v2_PMC","Land_IED_v3_PMC","Land_IED_v4_PMC"];

//Display timer for IED disarm
hint "Disarming IED…";
// timer graphic hint?

// Get disarming unit to do something (choose red wire or blue wire). Chance that device is new and therefore requires disarmer to guess how to disarm
if (random 1 > 0.7) then {

	if (random 1 > 0.5) then {
		_wire = "blue"; 
	} else {
		_wire = "red";
	};

	tup_ied_wire = "";

	// Ask question about which wire
	_tup_iedPrompt = createDialog "tup_ied_DisarmPrompt";
	noesckey = (findDisplay 1600) displayAddEventHandler ["KeyDown", "if ((_this select 1) == 1) then { true }"]; 
	waitUntil {tup_ied_wire != ""};
	
	// Accept input
	_selectedWire = tup_ied_wire;

	// Check success
	if (_selectedWire == _wire) then {
		_success = true;
	} else {
		_success = false;
	};

	If  !(_success) then {
		// Failure to disarm results in detonation
		"Sh_82_HE" createVehicle getposATL _IED;
	} else {
		hint "You guessed correct! IED is disarmed and safely removed from the area.";
	};

} else {
	// Tell unit that IED is disarmed
 	hint "IED is disarmed and safely removed from the area.";
};

// Clean up
diag_log format ["ied = %1, trigger = %2, det_trigger = %3, detect = %4", _IED, _IED getvariable "Trigger",_IED getvariable "Det_Trigger",_IED getvariable "Detect_Trigger"];
deletevehicle (_IED getvariable "Trigger");
deletevehicle (_IED getvariable "Det_Trigger");
deletevehicle (_IED getvariable "Detect_Trigger");
if (typeof _IED in _IEDskins) then {
	deletevehicle _IED;
};


