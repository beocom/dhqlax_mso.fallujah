// IED Detection and Disposal Mod
// 2011 by Reezo

if (!isServer) exitWith {
	_det = false;
	
	_det
};

private ["_ied","_pressure","_near","_det"];
_ied = _this select 0;
_pressure = _this select 1;

switch (true) do {
	case (_pressure == "infantry") : {
		_near = getPos _IED nearEntities [["Man", "Car", "Tank"], 5];
	};
	case (_pressure == "vehicle") : {
		_near = getPos _IED nearEntities [["Car", "Tank"], 10];
	};
};

//diag_log format["STUFF NEAR IED: %1",_near];

if ({vehicle _x in _near} count ([] call BIS_fnc_listPlayers) > 0) then {
	_det = true;
	//diag_log format["reezo_eod_fnc_pressureDetection - IED %1 DETONATING BECAUSE OF %2 BEING NEAR", _ied, _near select 0];
} else {
	_det = false;
	//diag_log format["reezo_eod_fnc_pressureDetection - IED %1 WAS CHECKED BUT HAS NO %2 TRIGGERING ITS PLATE", _ied, _pressure];
};

_det