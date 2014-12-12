// Create trigger for IED detonation
private ["_IED","_trg","_type","_shell","_proximity","_debug"];

if !(isServer) exitWith {diag_log "ArmIED Not running on server!";};
_debug = debug_mso;

_IED = _this select 0;
_type = _this select 1;

if (count _this > 2) then {
	_shell = _this select 2;
} else {
	_shell = [["Grenade","Sh_82_HE","Sh_105_HE","Sh_120_HE","Sh_125_HE"],[4,8,2,1,1]] call mso_core_fnc_selectRandomBias;
};

_proximity = 2 + floor(random 10);

if (_debug) then {
	private "_iedm";
	diag_log format ["MSO-%1 IED: arming IED at %2 of %3 as %4 with proximity of %5",time, getposATL _IED,_type,_shell,_proximity];
	//Mark IED position
	_t = format["ied_r%1", floor (random 1000)];
	_iedm = [_t, position _IED, "Icon", [1,1], "TEXT:", "IED", "TYPE:", "Dot", "COLOR:", "ColorRed", "GLOBAL"] call CBA_fnc_createMarker;
	_IED setvariable ["Marker", _iedm];
};

// Add Action to IED for disarm
// only show action when unit is within 4m.
[nil, _IED, "per", rADDACTION, "<t color='#ff0000'>Disarm IED</t>", "enemy\modules\tup_ied\fn_disarmIED.sqf", [], 6, false, true, "", "(_target distance _this) < 4"] call RE;

// Create Detonation Trigger
_trg = createTrigger["EmptyDetector", getposATL _IED]; 
_trg setTriggerArea[_proximity,_proximity,0,false];
_trg setTriggerActivation["WEST","PRESENT",false];
_trg setTriggerStatements["this && ({(vehicle _x in thisList) && ((getposATL  vehicle _x) select 2 < 8) && !(_x hasWeapon 'SR5_THOR3') && !(_x hasWeapon 'SR5_THOR3_MAR') && !(_x hasWeapon 'SR5_THOR3_ACU') && (getText (configFile >> 'cfgVehicles' >> typeof _x >> 'displayName') != 'Engineer') && ([vehicleVarName _x,'EOD'] call CBA_fnc_find == -1)} count ([] call BIS_fnc_listPlayers) > 0)", format["_bomb = nearestObject [getposATL (thisTrigger), '%1']; deletevehicle (_bomb getvariable 'Detect_Trigger'); deletevehicle (_bomb getvariable 'Det_Trigger'); boom = '%2' createVehicle getposATL _bomb; deletevehicle _bomb;",_type,_shell], ""]; 

_IED setvariable ["Trigger", _trg, true];

if !(typeof _IED == _type) then {
	// Attach trigger to moving vehicle/person
	_trg attachTo [_IED,[0,0,-0.5]];
};

// Create Detection Trigger - if Engineer or person with ACE_Minedetector or THOR III gets near IED
_trg1 = createTrigger["EmptyDetector", getposATL _IED]; 
_trg1 setTriggerArea[_proximity+5,_proximity+5,0,false];
_trg1 setTriggerActivation["WEST","PRESENT",true];
_trg1 setTriggerStatements["this && ({(vehicle _x in thisList) && ((getposATL  vehicle _x) select 2 < 8) && ((currentWeapon _x in ['ACE_Minedetector_US','ACE_VMH3','ACE_VMM3']) || (_x hasWeapon 'SR5_THOR3') || (_x hasWeapon 'SR5_THOR3_MAR') || (_x hasWeapon 'SR5_THOR3_ACU') || (getText (configFile >> 'cfgVehicles' >> typeof _x >> 'displayName') == 'Engineer') || ([vehicleVarName _x,'EOD'] call CBA_fnc_find != -1))} count ([] call BIS_fnc_listPlayers) > 0)", format["_bomb = nearestObject [getposATL (thisTrigger), '%1']; [_bomb, %2, thislist] execvm 'enemy\modules\tup_ied\fn_detectIED.sqf';", _type, _proximity], ""]; 

_IED setvariable ["Detect_Trigger", _trg1, true];

if !(typeof _IED == _type) then {
	// Attach trigger to moving vehicle/person
	_trg1 attachTo [_IED,[0,0,-0.5]];
};

// Create Disarm Detonation Trigger - if Engineer or person with THOR III step on IED
_trg2 = createTrigger["EmptyDetector", getposATL _IED]; 
_trg2 setTriggerArea[2,2,0,false];
_trg2 setTriggerActivation["WEST","PRESENT",false];
_trg2 setTriggerStatements["this && ({(vehicle _x in thisList) && ((getposATL  vehicle _x) select 2 < 8)} count ([] call BIS_fnc_listPlayers) > 0)", format["_bomb = nearestObject [getposATL (thisTrigger), '%1']; deletevehicle (_bomb getvariable 'Detect_Trigger'); deletevehicle (_bomb getvariable 'Trigger'); boom = '%2' createVehicle getposATL _bomb; deletevehicle _bomb;",_type,_shell], ""]; 

_IED setvariable ["Det_Trigger", _trg2, true];

if !(typeof _IED == _type) then {
	// Attach trigger to moving vehicle/person
	_trg2 attachTo [_IED,[0,0,-0.5]];
};
  