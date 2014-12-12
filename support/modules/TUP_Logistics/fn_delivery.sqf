#include "\x\cba\addons\main\script_macros_mission.hpp"

private ["_debug","_delivery","_startpos","_grp","_convoyArray","_leadVeh","_leadVehType","_wp"];

// Run server side
// Receives requests from players
// Organises delivery of items
// Common types are bundled and delivered by the same vehicle
// Aircraft are always delivered to runways and helipads
// Vehicles can be delivered by para drop, airlift (sling) or convoy
// Tanks cannot be airlifted
// Defence supplies cannot be delivered via convoy.
// If delivery not selected Vehicles are delivered via convoy
// Crates & StaticWeapons can be delivered via any method
// If no delivery set they are delivered via guided para drop, if more than 4 crates, then airlift crates in container, if airlift not available, 5 crates in a vehicle
// Defense supplies - paradrop, airlift

_debug = debug_mso;

PARAMS_4(_destpos,_order,_prefDel,_player);

if (count _this > 4) then {
	_startpos = _this select 4;
};

//make sure pos is at ground level
_destpos = [(_destpos select 0), (_destpos select 1), 0];

// If no delivery method set, set it to paradrop
if (_prefDel == -1) then {
	_prefDel = 0;
};

if (_prefDel == 2) then { // If convoy establish protection vehicle
	_grp = creategroup (side _player);
	_leadVehType = ([0, faction _player,"Car"] call mso_core_fnc_findVehicleType) call BIS_fnc_selectRandom;
	_leadVeh = ([_startpos, 0, _leadVehType, _grp] call BIS_fnc_spawnVehicle) select 0;
	_leadVeh forceSpeed 8;
	[_leadVeh, _startpos] spawn {
		private ["_leadVeh","_pos"];
		_leadVeh = _this select 0;
		_pos = _this select 1;
		waitUntil {sleep 120; !(_leadVeh call CBA_fnc_isAlive) || (damage _leadVeh > 0.6) || (_leadVeh distance _pos < 100)};
		deleteVehicle _leadVeh;
		deletegroup group _leadVeh;
	};
};

_convoyArray = [];

diag_log format["MSO-%1 Tup_Logistics: Starting delivery of %2 to %3 from %4", time, _order, _destpos, _startpos];

// Turn order into set of deliveries
_delivery = [_order] call logistics_fnc_bundleDelivery;

// For each delivery, provision the items
{
    private ["_object","_request","_convoy"];
    // Check for Aircraft, Vehicle, Crates, Static, Support
    _request = _x;
    _object = _x select 0;
	_convoy = [];
    
    if (_debug) then {
        diag_log format["MSO-%1 Tup_Logistics: Delivering the following: %2", time, _request];
    };
    
    switch (true) do 
    {
        case ((_object iskindof "Plane") || (_object iskindof "Helicopter")): 
        {
            [_object, _destpos, _player] call logistics_fnc_deliverAircraft;
        };
		case (((_object iskindof "Car") || (_object iskindof "Tank") || (_object iskindof "Motorcycle")) && (_prefDel < 2)): 
        {
            [_request, _destpos, _player, _prefDel] call logistics_fnc_createAirDelivery;
        };
        default {
			// For non-aircraft/vehicles, deliver based on preferred delivery method
			switch (true) do
			{
				case (_prefDel < 2) : // Paradrop or Airlift
				{
					[_request, _destpos, _player, _prefDel] call logistics_fnc_createAirDelivery;
				};
				case (_prefDel == 2) : // Convoy
				{
					_convoy = [_request, _destpos, _player, _startpos] call logistics_fnc_createConvoy;
					_convoyArray = _convoyArray + _convoy;
				};
				case (_prefDel == 3) : // GPS guided paradrop
				{
					[_request, _destpos, _player, _prefDel] call logistics_fnc_createAirDelivery;
				};
			};
        };
    };
} foreach _delivery;

if (_prefDel == 2) then { // If road convoy get all vehicles moving together with protection vehicle

	_convoyArray join _grp;
	if (_debug) then {
		diag_log format["Sending %1 (%2) on its way... to %3", _grp, units _grp, _destpos];
	};
	_wp = _grp addwaypoint [_destpos, 0];
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointFormation "FILE";
	_wp setWaypointCompletionRadius 30;
	_wp setWaypointCombatMode "BLUE";
    [-1, {PAPABEAR sideChat _this}, format ["%1 this is PAPA BEAR. Your resupply convoy has entered the AO at %2 and is %3km away.", group _player, mapgridposition (leader _grp), round(((leader _grp) distance _destpos)/1000)]] call CBA_fnc_globalExecute;

};
