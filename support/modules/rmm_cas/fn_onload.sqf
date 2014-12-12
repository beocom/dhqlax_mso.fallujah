
private "_i";
_i = 0;
{
	{
		lbAdd [_i, _x];
	} foreach (call _x);
	_i = _i + 1;
} foreach RMM_cas_lines;

