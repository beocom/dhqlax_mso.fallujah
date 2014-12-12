private ["_position","_object"];
_position = screentoworld [0.5,0.5];
_object = _position nearestobject "all";
if (isnull _object) exitwith {};
if !(_object distance _position < (sizeof (typeof _object))/2) exitwith {};
if !(_object in cnstrct_buildings) exitwith {};
private ["_selected"];
_selected = cnstrct_center getvariable "cnstrct_selected";
if (isnil "_selected") then {
	private ["_helper","_position"];
	_helper = "Sign_arrow_down_large_EP1" createvehiclelocal [0,0,0];
	cnstrct_center setvariable ["cnstrct_selected",[_object,_helper]];
	_position = _object modeltoworld [0,0,(((boundingBox _object) select 1) select 2) + 0.2];
	_helper setpos _position;
	_i = 1; _y = 1;
	while {not isnull _object} do {
		if (((cnstrct_center getvariable "cnstrct_selected") select 0) != _object) exitwith {};
		if (_i == 10) then {_y = -1};
		if (_i == 1) then {_y = 1};
		_i = _i + _y;
		_position set [2,(_position select 2) + (_y / 20)];
		_helper setpos _position;
		sleep 0.02;
	};
	deletevehicle _helper;
} else {
	if (_object == _selected select 0) then {
		private ["_type"];
		_type = typeof _object;
		{
			if ((_x select 0) == _type) exitwith {
				cnstrct_center setvariable ["cnstrct_supplies", (cnstrct_center getvariable "cnstrct_supplies") + (_x select 2),true];
				cnstrct_buildings = cnstrct_buildings - [_object];
				publicvariable "cnstrct_buildings";
				deletevehicle _object;
			};
		} foreach (cnstrct_center getvariable "cnstrct_items");
	} else {
		deletevehicle (_selected select 1);
	};
	cnstrct_center setvariable ["cnstrct_selected",nil];
};