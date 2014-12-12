//data = [_player, _typeofdata] call persistent_fnc_getData
private ["_player","_thistype","_thisdata","_thisClientData"];

_player = _this select 0;
_thistype = _this select 1;

_thisDataArray = [];
{
	private "_code";
	
	// Get data on client side object
	_code = _x;
	_thisdata = [_player] call (_code);

	// Convert Data from SQF to String
	_thisdata = [_thisdata, "write"] call persistent_fnc_convertFormat;

	// Log Data
	if (pdb_log_enabled) then {	
		diag_log format["SERVER MSG: Got %1 - data: %2", name _player, _thisdata];
	};
	
	// Insert into client array ready to be stored
	_thisDataArray set [ count _thisDataArray, _thisData];
	
} foreach _thistype;

_thisDataArray;