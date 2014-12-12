    private ["_pos","_x","_y"];
    
 	_pos = getPosATL _this; 
 	_x = _pos select 0;
 	_y = _pos select 1;
 	_x = _x - (_x % 100); 
 	_y = _y - (_y % 100);
	[_x + 50, _y + 50, 0];