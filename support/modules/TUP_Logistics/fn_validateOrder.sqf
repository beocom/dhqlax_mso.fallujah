#include "\x\cba\addons\main\script_macros_mission.hpp"

private ["_invalid","_total"];

// Validate logistics order
_invalid = false;

// Count total items in order
_total = 0;
{
	private "_num";
	_num = _x select 0;
	_total = _total + _num;
} foreach tup_logistics_order;


if (count tup_logistics_order > 0) then {
	
	tup_logistics_delivery_sel = lbCurSel 11; 
	
	if (tup_logistics_curordersize > tup_logistics_curorderlimit) then {
		["Logistics Request",format["Your order exceeds the limit allowed in the current time period of %2 hours.<br/><br/>Try reducing the number of items ordered.", tup_logistics_frequency]] call mso_core_fnc_sendHint;
		_invalid = true;
	};
	
/*	if (!(isNil "tup_logistics_nextorder") && (date < tup_logistics_nextorder)) then {
		["Logistics Request",format["You have already sent a logistics demand in the last %1 hours. Try again after %2.",tup_logistics_frequency, tup_logistics_nextorder]] call mso_core_fnc_sendHint;
		_invalid = true;
};*/
	
	if ( (({(_x select 1) iskindof "Tank"} count tup_logistics_order) > 0) && (tup_logistics_delivery_sel == 1) ) then {
		// Tank cannot be airlifted
		["Logistics Request","Tanks cannot be airlifted. Select paradrop or convoy, or remove items from your order."] call mso_core_fnc_sendHint;
		_invalid = true;
	};
	
	if ( (({!((_x select 1) iskindof "ReammoBox" || (_x select 1) iskindof "StaticWeapon")} count tup_logistics_order) > 0) && (tup_logistics_delivery_sel == 3) ) then {
		// Only crates and support weapons can be GPS guided paradrop
		["Logistics Request","Only crates or support weapons can be delivered via GPS paradrop. Select paradrop, convoy or airlift instead, or remove items from your order."] call mso_core_fnc_sendHint;
		_invalid = true;
	};
	
	if (_total > 8 && (tup_logistics_delivery_sel == 3)) then {
		["Logistics Request","Too many items have been ordered. Select a different delivery method, or remove items from your order."] call mso_core_fnc_sendHint;
		_invalid = true;
	};
	
	if ( (({(_x select 1) in tup_logistics_defense} count tup_logistics_order) > 0) && (tup_logistics_delivery_sel == 2) ) then {
		// Defense supplies cannot be delivered by convoy
		["Logistics Request","Defense Supplies cannot be delivered via convoy. Select paradrop or airlift, or remove items from your order."] call mso_core_fnc_sendHint;
		_invalid = true;
	};
	
	if !(_invalid) then {
//		tup_logistics_nextorder = date + (tup_logistics_frequency * 60);
		tup_logistics_curorderlimit = tup_logistics_curorderlimit - tup_logistics_curordersize;
		publicvariable "tup_logistics_curorderlimit";
//		publicvariable "tup_logistics_nextorder";
		closedialog 0;
		0 call logistics_fnc_call;
	};

} else {
	["Logistics Request","You need to add items to your order to proceed."] call mso_core_fnc_sendHint;
};

