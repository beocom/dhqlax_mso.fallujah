private ["_terminate"];
_terminate = false;

private ["_keyscancel","_keysnvg","_keyssell"];
_keyscancel	= (actionKeys "MenuBack") + [1];
_keysnvg = actionKeys "NightVision";
_keyssell = actionKeys "Compass";

private ["_key","_shift","_ctrl","_alt"];
_key = _this select 1;
if (count _this > 5) then {
	//mouse
	//_shift = _this select 4;
	_ctrl = _this select 5;
	//_alt = _this select 6;
} else {
	//keyboard
	//_shift = _this select 2;
	_ctrl = _this select 3;
	//_alt = _this select 4;
};
if !(isnil {cnstrct_center getvariable "cnstrct_busy"}) exitwith {
	sleep 0.2;
	cnstrct_center setvariable ["cnstrct_busy",nil];
};
cnstrct_center setvariable ["cnstrct_busy",true];		

////////////////////////////////
if ((_key == 0) and (not isnull cnstrct_preview) and (not _ctrl)) then {
	[] call cnstrct_fnc_create;
	[] call cnstrct_fnc_refresh;
} else {
	if (_key in _keyscancel) then {
		switch (tolower(typename cnstrct_params)) do {
		case "scalar" : {
				[] call cnstrct_fnc_refresh;
			};
		case "string" : {
				deletevehicle cnstrct_preview;
				
			};
			default {
				if (not isnull cnstrct_preview) then {
					[] call cnstrct_fnc_refresh;
					deletevehicle cnstrct_preview;
				} else {
					_terminate = true;
				};
			};
		};
	};
	if (_key in _keyssell) then {
		[] call cnstrct_fnc_sell;
	};
	if (_key in _keysnvg) then {
		if (player hasweapon "NVGoggles") then {
			private ["_bool"];
			_bool = not (cnstrct_center getvariable "cnstrct_usenvg");
			cnstrct_center setvariable ["cnstrct_usenvg",_bool];
			camusenvg _bool;
		};
	};
};
if (_terminate) then {
	if (not isnull cnstrct_preview) then {
		deletevehicle cnstrct_preview;
	};
	cnstrct_center = nil;
	cnstrct_preview = nil;
};