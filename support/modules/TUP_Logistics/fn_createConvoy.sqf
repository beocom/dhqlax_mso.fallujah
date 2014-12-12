#include "\x\cba\addons\main\script_macros_mission.hpp"

// Create convoy to deliver items
private ["_num","_vehArray"];

PARAMS_4(_request,_destpos,_player,_startpos);

// Set start position to a point on the ground (onmapclick returns a z value underground)
_startpos = [_startpos select 0, _startpos select 1, 0];

// Ensure final position is on a road
_destpos = position ((_destpos nearRoads 50) call BIS_fnc_selectRandom); 

_vehArray = [];

if (debug_mso) then {
	diag_log format["Req: %1, destPos: %2, Player: %3, Startpos: %4", _request,_destpos,_player,_startpos];
};

numOfDeliveryVehicles = {
	// Based on item type, delivery method, set capacity and therefore number of vehicles required
    private ["_type","_numVeh","_request"];
    _request = _this select 0;
	_type = _request select 0;
	switch (true) do
	{
		case ((_type iskindof "Car") || (_type iskindof "Tank") || (_type iskindof "Motorcycle")) :
		{
			_numVeh = count _request;
		};
		case default
		{
			// 8 items per Truck
			_numVeh = ceil((count _request) / 8);
		};
	};
	_numVeh;
};

// Work out how many trucks are needed for this delivery
_num = [_request] call numOfDeliveryVehicles;


// Create Vehicles, work out load per vehicle and wait for arrival to do delivery
for "_i" from 0 to (_num-1) do
{
	private ["_itemArray","_object","_v","_wp","_numItems","_y","_itemType","_item","_twat"];
	
	// Workout items split between vehicles
	_itemArray = [];
	_numItems = floor((count _request) / _num);
	for "_y" from (_i * _numItems) to ((_i * _numItems) + _numItems)-1 do
	{
		_itemArray set [count _itemArray, _request select _y];
	};
	
	// If item in delivery is not a vehicle, then create a supply truck
	_twat = _itemArray select 0;
	if ( (_twat iskindof "Car") || (_twat iskindof "Tank") || (_twat iskindof "Motorcycle") ) then {
		_item = _itemArray select 0;
	} else {
		_item = "WarfareSupplyTruck_USMC";
	};
	
	_v = [_item,_startpos] call logistics_fnc_SpawnVehicle;
	
	// Get vehicle on its way
	_wp = group _v addwaypoint [_destpos, 0];
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointFormation "FILE";
	_wp setWaypointCompletionRadius 30;
	_wp setWaypointCombatMode "BLUE";
	_v forceSpeed 8;
	
	_vehArray set [count _vehArray, _v];
	
	// Add items to vehicles and then wait for arrival at destpos
	[_v,_itemArray,_destpos, _player] spawn {
		private ["_wp","_msgObject","_v","_request","_pos","_player","_tmpgrp"];
		_v = _this select 0;
		_request = _this select 1;
		_pos = _this select 2;
		_player = _this select 3;
		
		if (debug_mso) then {
			diag_log format["Req: %1, Pos: %2, Player: %3, Veh: %4", _request,_pos,_player, _v];
		};
		
		if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: Vehicle is on its way.", time];};
		
		// If Supply Truck, then add items to truck using R3F else enable R3F on vehicle
		If (typeof _v == "WarfareSupplyTruck_USMC") then {
			private "_objectArray";
			_objectArray = [];
			{
				private ["_itemObj","_id","_name"];
				_itemObj = _x createVehicle [random 100, random 100,0];
				//// Enable R3F
				_itemObj setVariable ["R3F_LOG_disabled", false];
				
				// Enable PDB saving 
				_id = 1000 + ceil(random(9000));
				_name = format["mso_log_%1",_id];
				_itemObj setVariable ["pdb_save_name", _name, true];
				
				_objectArray set [count _objectArray, _itemObj];
			} foreach _request;
			
			if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: Objects Created %2", time, _objectArray];};
			
			// Load items into container (hope they fit!) using R3F
			[_v,_objectArray] call logistics_fnc_addItemsR3F;
			
		} else {
			private ["_id","_name"];
			//// Enable R3F
			_v setVariable ["R3F_LOG_disabled", false];
			
			// Enable PDB saving 
			_id = 1000 + ceil(random(9000));
			_name = format["mso_log_%1",_id];
			_v setVariable ["pdb_save_name", _name, true];
			
			if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: %3 pdb enabled %2", time, _name, typeof _v];};
		};
		
		waitUntil {sleep 120; !(_v call CBA_fnc_isAlive) || (damage _v > 0.6) || (_v distance _pos < 1000)};
		if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: Vehicle is 1km away.", time];};
		
		waitUntil {sleep 30; !(_v call CBA_fnc_isAlive) || (damage _v > 0.6) || (_v distance _pos < 60)};
		if (debug_mso) then {diag_log format["MSO-%1 Tup_Logistics: Vehicle is arriving.", time];};
		
		_tmpgrp = creategroup WEST;
		[_v] join _tmpgrp;
			
		// If its a vehicle being delivered, get the crew out and delete them
		if (typeof _v != "WarfareSupplyTruck_USMC") then {
			_wp = group _v addwaypoint [_pos, 20];
			_wp setWaypointType "GETOUT";
			_wp setWaypointTimeout [15,30,60];
			_wp setWaypointStatements ["true", "{deletevehicle _x} foreach crew (vehicle this);"];
		};
		
		if ((_v call CBA_fnc_isAlive) && (damage _v < 0.7)) then {
			[-1, {PAPABEAR sideChat _this}, format ["%1 this is PAPA BEAR. %2 items were delivered near position %3. Any supply trucks will RTB in 15 minutes. Over.", group _player, count _request, position _v]] call CBA_fnc_globalExecute;
		} else {
			_msgObject = getText(configFile >> 'CfgVehicles' >> typeof _v >> 'displayname');
			[-1, {PAPABEAR sideChat _this}, format ["%1 this is PAPA BEAR. %2 carrying %3 items is under attack and may have already been destroyed. Over.", group _player, _msgObject, count _request]] call CBA_fnc_globalExecute;
		};
		
		if (typeof _v == "WarfareSupplyTruck_USMC") then {
			
			sleep 900;
			
			_wp = group _v addwaypoint [[0,0,0], 50];
			_wp setWaypointBehaviour "CARELESS";
			_wp setWaypointCompletionRadius 10;

			sleep 120;
			
			deleteVehicle _v;
			deletegroup group _v;
			
		};
	};
};


_vehArray;


