// Create Delivery
private ["_request","_num","_object","_delivery","_wepsammo","_static","_other","_vehs","_array"];

_request = _this select 0;

//diag_log format["Request = %1", _request];

//Request might be just a single request, if so, put in array.
if (typeName (_request select 0) != "ARRAY") then {
	_request = [_request];
};

// Go through Request and bundle orders together (i.e. put all crates in 1 vehicle, put all static weapons in another, deliver defence supplies based on size)
_delivery = [];
_vehs = [];
_wepsammo = [];
_static = [];
_other = [];

{
	_num = _x select 0;
	_object = _x select 1;

	switch (true) do 
    {
		case ((_object iskindof "Plane") || (_object iskindof "Helicopter")) : 
        {
			for "_i" from 1 to _num do 
            {
				_delivery set [count _delivery, [_x select 1]];
			};
		};
		
		case ((_object iskindof "Car") || (_object iskindof "Tank") || (_object iskindof "Motorcycle")) : 
        {
			for "_i" from 1 to _num do 
            {
				_vehs set [count _vehs, _object];
			};
		}; 
		 
		case ((_object iskindof "StaticWeapon") || (_object iskindof "ReammoBox")): 
        {
			for "_i" from 1 to _num do 
            {
				_wepsammo set [count _wepsammo, _object];
			};
		};
		case ((_object iskindof "Static") && !(_object iskindof "ReammoBox")) : 
        {
			for "_i" from 1 to _num do 
            {
				_static set [count _static, _object];
			};
		};
		case default 
        {
			for "_i" from 1 to _num do 
            {
				_other set [count _other, _object];
			};
		};
	};
} foreach _request;


// Create delivery set
_array = [_vehs,_wepsammo,_static,_other];
{
	if  (count _x > 0) then {
		_delivery set [count _delivery, _x];
	};
} foreach _array;

if (mso_debug) then {
	diag_log ["Delivery - ", _delivery];
};

_delivery;