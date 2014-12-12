// Add items to order
private ["_lb","_alb","_type","_cap","_var","_cost"];
_lb = _this select 0;
_alb = _this select 1;
_type = _this select 2;

call compile format["_var = tup_logistics_%1",_type];

_cost = [_var select (lbCurSel _alb)] call logistics_fnc_getCost;

if ((lbCurSel _lb > 0) && (lbCurSel _alb > -1)) then 
{
	lbAdd [10, format['%1 x %2', lbCurSel _lb, getText(configFile >> 'CfgVehicles' >> _var select (lbCurSel _alb) >> 'displayname')]];
	tup_logistics_order set [ count tup_logistics_order, [lbCurSel _lb, _var select (lbCurSel _alb)] ];
};

tup_logistics_curordersize = tup_logistics_curordersize + ((lbCurSel _lb) * _cost);

// Update Order capacity
_cap = ceil((tup_logistics_curordersize / tup_logistics_curorderlimit) * 100);
if (_cap > 100) then {
	_cap = "Err";
};
ctrlSetText [2001, format["Order Capacity: %1%2",_cap,"%"]];
