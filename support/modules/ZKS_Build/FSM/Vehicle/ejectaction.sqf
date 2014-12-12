

_car = _this select 0;
_id = _this select 2; 
_mydooranimation = ((_this select 3) select 0);
_cargotroops = [];
_cargotroops = assignedCargo _car;


_myphase = 1;

_phase = 0;

{
if ((_x select 1) == _myphase) then {_phase = 0}else{_phase = 1};
_car animate [(_x select 0),_phase];
} foreach _mydooranimation;

sleep 1.5;


while {(count _cargotroops > 0)} do
{
(_cargotroops select 0) action ["EJECT", _car];
unassignVehicle (_cargotroops select 0);
_cargotroops = _cargotroops - [(_cargotroops select 0)];
sleep .5;
};


sleep 1.5;
_myphase = 0;
_phase = 0;

{
if ((_x select 1) == _myphase) then {_phase = 0}else{_phase = 1};
_car animate [(_x select 0),_phase];
} foreach _mydooranimation;

