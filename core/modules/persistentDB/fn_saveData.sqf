// Save Data to db
// [_data,_params,_procedure,_idparams] call persistent_fnc_saveData;

private ["_data", "_params", "_idparams", "_parameters", "_i", "_response", "_procedureName"];

_data = _this select 0;
_params = _this select 1;
_procedureName = _this select 2;
_idparams = _this select 3;

_parameters = "";
_i = 0;
{
	_parameters = _parameters + format["%1=%2,", _x, _data select _i];
	_i = _i + 1;
} foreach _params;

// Set final params used to find object in db
_parameters = _parameters + _idparams;

if (pdb_log_enabled) then {
	diag_log format["SERVER MSG: SQL output: %1", _parameters];
};
	
_response = [_procedureName,_parameters] call persistent_fnc_callDatabase;	

_response;
// END save data