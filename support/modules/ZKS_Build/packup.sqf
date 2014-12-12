//Script By Zonekiller -- http://zonekiller.ath.cx -- zonekiller@live.com.au

_Cargo = _this select 0;
_side = ((_this select 3) select 0);
_truck = [];
_tpos = [];

if (_side == "west") then
{
_truck = ["MTVR"];
_tpos = [-0.08,-2,.73];
};

if (_side == "east") then
{
_truck = ["KamazOpen"];
_tpos = [0,-1.2,.5];
};


_truckarray = (nearestObjects [_Cargo,_truck, 11]);
_Hauler = (_truckarray select 0);





_Cargo animate ["door_1_1", 1];
_Cargo animate ["door_1_2", 1];

sleep 3;



_Cargo attachTo [_Hauler,_tpos];
_MyCargo = true;
_Cargo setVariable ["MyCargo", _MyCargo, false];

sleep 2;

waituntil {sleep 0.5;(!(alive _Cargo) or !(alive _Hauler) or (((getposATL _Cargo) select 2) < 1))};
detach _Cargo;
_Cargo setpos [(getpos _Cargo select 0),(getpos _Cargo select 1), 0]; 
