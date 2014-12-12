private ["_cname", "_cidx", "_cpos", "_i"];
_cname = "";
_cidx = 0;
_cpos = [0,0,0];
_i=0;
{
	if ((_x select 1) distance RMM_jipmarkers_position < _cpos distance RMM_jipmarkers_position &&
		playerSide == (_x select 4)) then{
		_cname = _x select 0;
		_cpos = _x select 1;
		_cidx = _i;
	};
	_i=_i+1;
} foreach RMM_jipmarkers;
deleteMarker _cname;
RMM_jipmarkers set [_cidx, objnull];
RMM_jipmarkers = RMM_jipmarkers - [objnull];
publicvariable "RMM_jipmarkers";