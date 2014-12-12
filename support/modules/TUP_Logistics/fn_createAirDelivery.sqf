#include "\x\cba\addons\main\script_macros_mission.hpp"

// Create vehicles for air delivery
private ["_num","_type"];

PARAMS_4(_request,_pos,_player,_prefDel);

if (debug_mso) then {
	diag_log format["Req: %1, Pos: %2, Player: %3, PrefDel: %4", _request,_pos,_player,_prefDel];
};

numOfDeliveryVehicles = {
	// Based on item type, delivery method, set capacity and therefore number of vehicles required
    private ["_type","_numVeh"];
    PARAMS_2(_request,_prefDel);
	_type = _request select 0;
	switch (true) do
	{
		case ((_type in tup_logistics_defence) || (_type iskindof "Car") || (_type iskindof "Tank") || (_type iskindof "Motorcycle")) :
		{
			if (_prefDel == 0) then {
				// 4 vehicles or fortifications per c130
				_numVeh = ceil((count _request) / 4);
			} else {
				// 1 vehicle or fortification per helo
				_numVeh = count _request;
			};
		};
		case default
		{
			// 24 items per C130 or 8 container
			
			_numVeh = ceil((count _request) / 8);
		};
	};
	_numVeh;
};
		
_num = [_request,_prefDel] call numOfDeliveryVehicles;

switch (_prefDel) do {
	case 0 : {
		_type = "C130J";
	};
	case 1 : {
		_type = "CH_47F_EP1";
	};
	case 3 : {
		_type = "C130J";
	};
};

// Create Vehicles and deliver goods
for "_i" from 0 to (_num-1) do
{
	private ["_itemArray","_object","_v","_grp","_wp","_numItems","_y","_itemType","_container"];
	
	_v = [_type,_pos] call logistics_fnc_SpawnVehicle;
	_grp = group _v;
	_wp = _grp addwaypoint [_pos, 75];
	_wp setWaypointBehaviour "CARELESS";
	_wp setWaypointCompletionRadius 50;
	_wp setWaypointCombatMode "BLUE";
	
	// Workout items split between vehicles
	_itemArray = [];
	_numItems = floor((count _request) / _num);
	for "_y" from (_i * _numItems) to ((_i * _numItems) + _numItems)-1 do
	{
		_itemArray set [count _itemArray, _request select _y];
	};
	
	// Select random container 
	if (count _itemArray > 5) then {
		_container = "Misc_Cargo1B_military";
	} else {
		_container = (tup_logistics_container) call BIS_fnc_selectRandom;
	};

	
	if (_prefDel == 1) then { // Setup Airlift object
		 // if vehicle or defense supply - sling that
		 // else sling container with items in
		 _itemType = _request select 0;
		 if ((_itemType in tup_logistics_defence) || (_itemType iskindof "Car") || (_itemType iskindof "Tank") || (_itemType iskindof "Motorcycle")) then {
			_object = (_itemArray select 0) createVehicle [0,0,0];
		 } else {
			 _object = _container createVehicle [0,0,0];
		 };
		_v setVariable ["R3F_LOG_heliporte", _object, true];
		_object setVariable ["R3F_LOG_est_transporte_par", _v, true];

		// Attach the item to the helo
		_object attachTo [_v, [0,0,(boundingBox _v select 0 select 2) - (boundingBox _object select 0 select 2) - 20 + 0.5]];
		
	} else {
		_object = ObjNull;
	};
	
	if (_prefDel == 3) then { // Setup GPS paradrop
		_object =  createVehicle ["Misc_cargo_cont_net1",[0,0,0],[],0,"CAN_COLLIDE"];
		 _v FlyInHeight 600;
	};
	
	[_v,_itemArray,_pos, _player, _prefDel,_object] spawn {
		private ["_grp","_wp","_msgObject","_v","_request","_pos","_player","_prefDel","_object"];
		_v = _this select 0;
		_request = _this select 1;
		_pos = _this select 2;
		_player = _this select 3;
		_prefDel = _this select 4;
		_object = _this select 5;
		_grp = group _v;
		
		if (debug_mso) then {
			diag_log format["Req: %1, Pos: %2, Player: %3, PrefDel: %4, Veh: %5, Obj: %6", _request,_pos,_player,_prefDel, _v, _object];
		};
		
		if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: Aircraft is on its way.", time];};
		
        waitUntil {sleep 20; !(_grp call CBA_fnc_isAlive) || (damage _v > 0.6) || (_v distance _pos < 2000)};
		if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: Aircraft is 2km away.", time];};
		
		if (_prefDel != 3) then { // Flyin low for paradrop and airlift, for gps guided drop stay high
			_v FlyInHeight (150 + (random 100)); 
		} else {
			_v FlyInHeight (450 + (random 100)); 
		};
		
        waitUntil {sleep 5; !(_grp call CBA_fnc_isAlive) || (damage _v > 0.6) || (_v distance _pos < 600)};
		if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: Aircraft is 600m away.", time];};
		
		if ((_grp call CBA_fnc_isAlive) && (damage _v < 0.7)) then {
			switch (_prefDel) do {
				case 0 : {
					if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: calling dodrop", time];};
					[_request, _v] call logistics_fnc_DoDrop;
				};
				case 1 : {
					if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: calling dolift", time];};
					[_request, _v, _pos, _object] call logistics_fnc_DoLift;
				};
				case 3 : {
					if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: calling doGPSdrop", time];};
					[_request, _v,_pos, _object] call logistics_fnc_DoGPSDrop;
				};
			};

			[-1, {PAPABEAR sideChat _this}, format ["%1 this is PAPA BEAR. %2 items were delivered near position %3. Over.", group _player, count _request, position _v]] call CBA_fnc_globalExecute;
		} else {
			_msgObject = getText(configFile >> 'CfgVehicles' >> typeof _v >> 'displayname');
			[-1, {PAPABEAR sideChat _this}, format ["%1 this is PAPA BEAR. %2 carrying %3 items has disappeared off our radar, likely destroyed. Over.", group _player, _msgObject, count _request]] call CBA_fnc_globalExecute;
		};
		
		_wp = _grp addwaypoint [[0,0,0], 50];
		_wp setWaypointBehaviour "CARELESS";
		_wp setWaypointCompletionRadius 10;
		sleep (120 + (random 60));
		
		deleteVehicle _v;
		deletegroup _grp;
	};
};

