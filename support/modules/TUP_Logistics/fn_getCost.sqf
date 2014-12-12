// fn_getCost

// Works out the cost of an item
// Vehicles usually have a cost, crates and stores don't

private ["_cost","_obj"];

_obj = _this select 0;

_cost = getNumber(configFile >> 'CfgVehicles' >> _obj >> 'cost');

if ((_cost == 0) || (_obj iskindof "Air") || (_obj iskindof "Tank")) then {

	switch (true) do {
		
		case (_obj iskindof "Air") : { // Aircraft adjustment - make them between 200k-400k - max budget per session is $800k
			_cost = _cost / 100;
		};
		
		case (_obj iskindof "Tank") : { // Tank adjustment - make them between 200k-400k - max budget per session is $800k
			_cost = _cost / 30;
		};
		
		case (_obj iskindof "ReammoBox") : { // Crates
			_cost = 7500;
		};
		
		case (_obj iskindof "StaticWeapon") : { // Support Weapons
			_cost = 5000;
		};
		
		case ((_obj iskindof "Static") && !(_obj iskindof "ReammoBox")) : { // Defence Stores
			_cost = 10000;
		};
		
		default {
			_cost = 5000;
		};
		
	};
};

_cost;