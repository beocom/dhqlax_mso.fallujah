

_car = _this select 0;
_id = _this select 2; 
_myanimation = ((_this select 3) select 0);
_myphase = ((_this select 3) select 1);
_type = ((_this select 3) select 2);
_delay = 20;



_phase = 0;

{
if ((_x select 1) == _myphase) then {_phase = 0}else{_phase = 1};
_car animate [(_x select 0),_phase];
} foreach _myanimation;

