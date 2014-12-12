// Remove Ambient Bomber
private ["_suic","_location","_debug"];

_debug = debug_mso;

if !(isServer) exitWith {diag_log "RemoveBomber Not running on server!";};

_location = _this select 0;

	if ((isClass(configFile>>"CfgPatches">>"reezo_eod")) && (tup_ied_eod == 1)) then {
		_suic = nearestobject [_location,"reezo_eod_suicarea"];
		if (_debug) then {
			diag_log format ["Deleting %1", _suic];
		};
		deletevehicle _suic;
	} else {
		// Ambient bomber is deleted automatically when time runs out or dies
	};
	
