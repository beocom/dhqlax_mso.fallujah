//Script By Zonekiller -- http://zonekiller.ath.cx -- zonekiller@live.com.au

_Cargo = _this select 0;
_caller = _this select 1;
_coin = _this select 2;
_grp = _this select 3;
_desk = _this select 4;
_chair = _this select 5;
_laptop = _this select 6;
_board = _this select 7;
_radio = _this select 8;

sleep 3;

waituntil {sleep 0.5;(((_caller distance _Cargo) > 7) or !(alive _caller) or !(alive _Cargo) or (_Cargo animationPhase "door_1_2" > 0.5) or (((getposATL _Cargo) select 2) > 1))};


deletevehicle _coin;
deleteGroup _grp;

_Cargo animate ["door_1_1", 1];
_Cargo animate ["door_1_2", 1];


//waituntil {(((getposATL _Cargo) select 2) > 1)};


deletevehicle _desk; 
deletevehicle _chair;
deletevehicle _laptop;
deletevehicle _board;
deletevehicle _radio;