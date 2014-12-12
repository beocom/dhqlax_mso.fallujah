// Add standard replen dem to order
private ["_cap"];

if (count tup_logistics_replendem > 0) then {
	{
		lbAdd [10, format['%1 x %2', _x select 0, getText(configFile >> 'CfgVehicles' >> _x select 1 >> 'displayname')]]; 
		_cost = [_x select 1] call logistics_fnc_getCost;
		tup_logistics_curordersize = tup_logistics_curordersize + ((_x select 0) * _cost);
		_cap = ceil((tup_logistics_curordersize / tup_logistics_curorderlimit) * 100);
		if (_cap > 100) then {
			_cap = "Err";
		};
		ctrlSetText [2001, format["Order Capacity: %1%2",_cap,"%"]];

		tup_logistics_order set [count tup_logistics_order, _x];
	} foreach tup_logistics_replendem;
};

