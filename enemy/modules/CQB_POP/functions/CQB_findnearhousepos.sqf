private ["_pos","_radius"];

_pos = _this select 0;
_radius = _this select 1;
_bldgpos = [];

_nearbldgs = nearestObjects [_pos, ["House"], _radius];

{
	private["_housepos", "_poscount","_i","_y"];
    _poscount = 0;
    _i = 0;
	_housepos = _x buildingPos _poscount;
    _y = _x buildingPos _i;
	
    while {format["%1", _housepos] != "[0,0,0]"} do {
        _poscount = _poscount + 1;
        _housepos = _x buildingPos _poscount;
        
    }; 
    
    if (_poscount > 2) then {
    		for "_z" from 0 to (_poscount - 2) do {
				if ((_y select 2 < 3) && (_i > 0)) then {
					_bldgpos set [count _bldgpos, _y];
				};
				_i = _i + 1;
				_y = _x buildingPos _i;
			};
    };
} forEach _nearbldgs;
_bldgpos;