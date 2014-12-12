{
	lbAdd [1, _x];
	ctrlSetText [2, format ["%1/%2 %3 - ",(date select 2),(date select 1),([daytime] call BIS_fnc_timeToString)]];
} foreach RMM_jipmarkers_types;

{
	lbAdd [3, _x];
} foreach RMM_jipmarkers_colors;