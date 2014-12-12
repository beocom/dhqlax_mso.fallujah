//#define DEBUG_MODE_FULL
#include "script_component.hpp"

if (!isDedicated) then {
	private ["_data_h", "_fnc_sets"];

	GVAR(logit) = "ACE_Logic";
	_data_h = ["support\modules\mgo\attach\weapons.yml"] call CBA_fnc_parseYAML;

	GVAR(weapons) = GVAR(logit) createVehicleLocal [0,0,0];
	GVAR(weplist) = GVAR(logit) createVehicleLocal [0,0,0];

	_fnc_sets = {
		private ["_set", "_weps", "_fnc_weps"];
		_set = _key;
		_weps = _value;

		GVAR(weapons) setVariable [_set, _weps];

		_fnc_weps = {
			private ["_wep", "_nam"];
			_wep = _key;
			_nam = _value;

			GVAR(weplist) setVariable [_wep, _set];
		};
		[_weps, _fnc_weps] call CBA_fnc_hashEachPair;
	};
	[_data_h, _fnc_sets] call CBA_fnc_hashEachPair;

	if (! isNil "ace_sys_interaction_key") then {["MtvrReammo_base", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["USBasicAmmunitionBox", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["USBasicAmmunitionBox_EP1", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["UNBasicAmmunitionBox_EP1", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["BAF_BasicAmmunitionBox", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["RUBasicAmmunitionBox", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["TKBasicAmmunitionBox_EP1", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["USBasicWeaponsBox", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["USSpecialWeaponsBox", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["USSpecialWeapons_EP1", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["USBasicWeapons_EP1", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["CZBasicWeapons_EP1", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["GERBasicWeapons_EP1", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["UNBasicWeapons_EP1", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["BAF_BasicWeapons", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["TKBasicWeapons_EP1", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["TKSpecialWeapons_EP1", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["UNBasicWeapons_EP1", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["Ammobox_PMC", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["RUBasicWeaponsBox", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["RUSpecialWeaponsBox", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
	if (! isNil "ace_sys_interaction_key") then {["LocalBasicWeaponsBox", [ace_sys_interaction_key], -80, ["support\modules\mgo\attach\menuDef.sqf", "main"]] call CBA_ui_fnc_add};
};
