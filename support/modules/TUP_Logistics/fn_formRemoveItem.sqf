// Remove Item


private ["_cap","_cost"];

_cost = [(tup_logistics_order select lbCurSel 10) select 1] call logistics_fnc_getCost;

tup_logistics_curordersize = tup_logistics_curordersize - ( ((tup_logistics_order select lbCurSel 10) select 0) * _cost);

if (tup_logistics_curordersize < 1) then {
	tup_logistics_curordersize = 1;
};
_cap = ceil((tup_logistics_curordersize / tup_logistics_curorderlimit) * 100);
if (_cap > 100) then {
	_cap = "Err";
};
ctrlSetText [2001, format["Order Capacity: %1%2",_cap,"%"]];

lbDelete [10, lbCurSel 10]; 
tup_logistics_order set [lbCurSel 10, -1]; 
tup_logistics_order = tup_logistics_order - [-1];


