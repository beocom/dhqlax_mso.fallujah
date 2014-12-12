#define COLOR_GREEN "#(argb,8,8,3)color(0,1,0,0.3,ca)"

if ((cnstrct_preview getvariable "cnstrct_color") != COLOR_GREEN) exitwith {};
private ["_class"];
_class = cnstrct_preview getvariable "cnstrct_type";
{
	if ((_x select 0) == _class) exitwith {
		private ["_supplies"];
		_supplies = cnstrct_center getvariable "cnstrct_supplies";
		if (_supplies - (_x select 2) >= 0) then {
			cnstrct_center setvariable ["cnstrct_supplies", _supplies - (_x select 2),true];
			private ["_direction","_position","_object"];
			_direction = getdir cnstrct_preview;
			_position = screentoworld [0.5,0.5];
			_object = createvehicle [_class,_position,[],0,"NONE"];
			_object setdir _direction;
			_object setpos _position;
			cnstrct_buildings set [count cnstrct_buildings, _object];
			publicvariable "cnstrct_buildings";
		};
		deletevehicle cnstrct_preview;
	};
} foreach (cnstrct_center getvariable "cnstrct_items");