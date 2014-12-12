//#define DEBUG_MODE_FULL
#include "script_component.hpp"
#include "\ca\editor\Data\Scripts\dikCodes.h"

private ["_menuDef", "_menuName", "_menuRsc", "_menus"];

PARAMS_2(_target,_params);

_menuName = "";
_menuRsc = "popup";

if (typeName _params == typeName []) then {
	if (count _params < 1) exitWith {diag_log format["Error: Invalid params: %1, %2", _this, __FILE__]};
	_menuName = _params select 0;
	_menuRsc = if (count _params > 1) then {_params select 1} else {_menuRsc};
} else {
	_menuName = _params;
};
//-----------------------------------------------------------------------------
_menus = [];
//-----------------------------------------------------------------------------
if (_menuName == "main") then {
	private ["_set_n"];
	_set_n = GVAR(weplist) getVariable (currentWeapon player);

	_menus set [count _menus,
		[
			["main"],
			[
				["Attach >", "", "", "",
					["support\modules\mgo\attach\menuDef.sqf", "wepalt", 1],
					-1, true, !isNil "_set_n"]
			]
		]
	];
};
//-----------------------------------------------------------------------------
if (_menuName == "wepalt") then {
	private ["_wep", "_set_n", "_wep_h"];

	_wep = currentWeapon player;
	_set_n = GVAR(weplist) getVariable _wep;

	if (!isNil "_set_n") then {
		_wep_h = GVAR(weapons) getVariable _set_n;
	};

	if (!isNil "_wep_h") then {
		private ["_wep_ary", "_fnc_wep_pop"];
		_wep_ary = [];
		_fnc_wep_pop = {
			private ["_item"];
			if (_value != "hidden") then {
				_item = [_value, compile format["player addWeapon ""%1""; player removeWeapon ""%2""", _key, _wep], "", "", "", -1, _key != _wep];
				_wep_ary set [count _wep_ary, _item];
			};
		};
		[_wep_h, _fnc_wep_pop] call CBA_fnc_hashEachPair;
		_menus set [count _menus,
			[
				["wepalt", "Change to", _menuRsc],
				_wep_ary
			]
		];
	} else {
		_menus set [count _menus,
			[
				["wepalt", "Change to", _menuRsc],
				[["Unavailable", "", "", "", "", -1, false]]
			]
		];
	};
};
//-----------------------------------------------------------------------------
_menuDef = [];
{
	if (_x select 0 select 0 == _menuName) exitWith {_menuDef = _x};
} forEach _menus;

if (count _menuDef == 0) then {
	hintC format ["Error: Menu not found: %1\n%2\n%3", str _menuName, if (_menuName == "") then {_this} else {""}, __FILE__];
	diag_log format ["Error: Menu not found: %1, %2, %3", str _menuName, _params, __FILE__];
};

_menuDef
