//Script By Zonekiller -- http://zonekiller.ath.cx -- zonekiller@live.com.au

_Cargo = _this select 0;
_side = ((_this select 3) select 0);
_truck = [];

_Cargo animate ["door_1_1", 1];
_Cargo animate ["door_1_2", 1];


if (_side == "west") then 
{
_truck = ["MTVR","MTVR_DES_EP1"];
};

if (_side == "east") then 
{
_truck = ["KamazOpen"];
};


_tpos = [0,-7,-.8];

_truckarray = (nearestObjects [_Cargo,_truck, 5]);
_Hauler = (_truckarray select 0);

detach _Cargo;

sleep 2.5;

_Cargo attachTo [_Hauler,_tpos]; 


sleep .1;
detach _Cargo;
_Cargo setpos [(getpos _Cargo select 0),(getpos _Cargo select 1), 0]; 

_MyCargo = false;
_Cargo setVariable ["MyCargo", _MyCargo, false];


