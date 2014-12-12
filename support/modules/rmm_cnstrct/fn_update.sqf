#define COLOR_GREEN "#(argb,8,8,3)color(0,1,0,0.3,ca)"
#define COLOR_GRAY 	"#(argb,8,8,3)color(0,0,0,0.3,ca)"

private ["_supplies"];
_supplies = cnstrct_center getvariable "cnstrct_supplies";
((uinamespace getvariable "BIS_CONTROL_CAM_DISPLAY") displayctrl 112224) ctrlsetstructuredtext (parsetext format["<t size='2'>S%1</t>",_supplies]);
switch (tolower(typename cnstrct_params)) do {
case "scalar" : {
		//open menu
		private ["_i"];
		_i = 0;
		{
			private ["_category"];
			_category = _x;
			if (_i == cnstrct_params) exitwith {
				private ["_types","_names","_enabled"];
				_types = []; _names = []; _enabled = [];
				{
					if (_category == (_x select 1)) then {
						private ["_type","_cost"];
						_type = _x select 0;
						_cost = _x select 2;
						_types set [count _types, _type];
						_names set [count _names, ((gettext (configfile >> "CfgVehicles" >> _type >> "displayName")) + format ["	%1", _cost])];
						_enabled set [count _enabled, if (_supplies - _cost >= 0) then {1} else {0}];
					};
				} foreach (cnstrct_center getvariable "cnstrct_items");
				[[_category,true],"cnstrct_menu2",[_types,_names,_enabled],"","cnstrct_params = '%1'; showcommandingmenu ''"] call BIS_fnc_createmenu;
			};
			_i = _i + 1;
		} foreach (cnstrct_center getvariable "cnstrct_categories");
		showcommandingmenu "#USER:cnstrct_menu2_0";
	};
case "string" : {
		//create preview
		private ["_class","_position"];
		_class = cnstrct_params;
		cnstrct_params = false;
		showcommandingmenu "";
		if (_class == "") exitwith {};
		_position = screentoworld [0.5,0.5];
		if (_position distance cnstrct_center > (cnstrct_center getvariable "cnstrct_radius")) exitwith {};
		private ["_camera","_ghost"];
		_camera = cnstrct_center getvariable "cnstrct_camera";
		
		_ghost = gettext (configfile >> "CfgVehicles" >> _class >> "ghostpreview");
		if (_ghost == "") then {_ghost = "Land_fortified_nest_smallPreview"};
		cnstrct_preview = _ghost createvehiclelocal _position;
		cnstrct_preview setvariable ["cnstrct_type",_class];
		cnstrct_preview setobjecttexture [0,COLOR_GRAY];
		_camera camsettarget cnstrct_preview;
		_camera camcommit 0;
		((uinamespace getvariable "bis_control_cam_display") displayctrl 112214) ctrlsetstructuredtext (parsetext format["<t size='2'>%1</t>",gettext (configfile >> "cfgvehicles" >> _class >> "displayname")]);
		while {not isnull cnstrct_preview} do {
			private ["_color","_position"];
			_position = getpos cnstrct_preview;
			_color = if (/*count (_position isflatempty [(sizeof _class) / 4,0,0.8,(sizeof _class),0,false,cnstrct_preview]) > 0*/ true) then {COLOR_GREEN} else {COLOR_GRAY};
			cnstrct_preview setobjecttexture [0,_color];
			if (_position distance cnstrct_center > (cnstrct_center getvariable "cnstrct_radius")) exitwith {
				deletevehicle cnstrct_preview;
				[] call cnstrct_fnc_refresh;
			};
			cnstrct_preview setvariable ["cnstrct_color",_color];
			sleep 0.2;
		};
		((uinamespace getvariable "bis_control_cam_display") displayctrl 112214) ctrlsetstructuredtext (parsetext "");
	};
	default {
		[] call cnstrct_fnc_refresh;
	};
};