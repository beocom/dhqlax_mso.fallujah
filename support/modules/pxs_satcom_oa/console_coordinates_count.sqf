//console - count of coordinates
//variables: [<type>,<start string>,<time>,<count_time>]
//<type> - "zoom+" or "zoom-" or "lon+" or "lon-" or "lat+" or "lat-"
//<start string> - number
//<time> - duration of camera (10p = 1s)
//<count_time> - count type
private ["_fstring","_time","_loop","_eloop","_count"];

_type = _this select 0;
_fstring = _this select 1;
_time = _this select 2;
_count = _this select 3;
_loop = 1;
_eloop = 0;

switch (_type) do {
  
	case "zoom+": 
	{
		while {_loop == 1} do {
		
		if (_eloop == _time) exitWith {};
		_fstring = _fstring + _count;
		ctrlSetText [1004,format ["ZOOM %1",(round (100 * (_fstring)))/100]];
		_eloop = _eloop + 1;
		sleep 0.1;
		};
	};
  
  case "zoom-": 
   {
		while {_loop == 1} do {
		
		if (_eloop == _time) exitWith {};
		_fstring = _fstring - _count;
		ctrlSetText [1004,format ["ZOOM %1",(round (100 * (_fstring)))/100]];
		_eloop = _eloop + 1;
		sleep 0.1;
		};
	};
	
	case "lon+": 
	{
		while {_loop == 1} do {
		
		if (_eloop == _time) exitWith {};
		_fstring = _fstring + _count;
		ctrlSetText [1003,format ["LON  %1",(round (10 * (_fstring)))/10]];
		_eloop = _eloop + 1;
		sleep 0.1;
		};
	};
	
	case "lon-": 
	{
		while {_loop == 1} do {
		
		if (_eloop == _time) exitWith {};
		_fstring = _fstring - _count;
		ctrlSetText [1003,format ["LON  %1",(round (10 * (_fstring)))/10]];
		_eloop = _eloop + 1;
		sleep 0.1;
		};
	};
	
	case "lat+": 
	{
		while {_loop == 1} do {
		
		if (_eloop == _time) exitWith {};
		_fstring = _fstring + _count;
		ctrlSetText [1002,format ["LAT  %1",(round (10 * (_fstring)))/10]];
		_eloop = _eloop + 1;
		sleep 0.1;
		};
	};
	
	case "lat-": 
	{
		while {_loop == 1} do {
		
		if (_eloop == _time) exitWith {};
		_fstring = _fstring - _count;
		ctrlSetText [1002,format ["LAT  %1",(round (10 * (_fstring)))/10]];
		_eloop = _eloop + 1;
		sleep 0.1;
		};
	};
  
  default {};
}; 