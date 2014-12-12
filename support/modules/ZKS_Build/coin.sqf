//Script By Zonekiller -- http://zonekiller.ath.cx -- zonekiller@live.com.au


_Cargo = _this select 0;
_caller = _this select 1;
_id = _this select 2;
_side = (side _caller);

_desk = createVehicle ["Desk", [0,0,0], [], 1, "NONE"];
_chair = createVehicle ["FoldChair", [0,0,0], [], 1, "NONE"];
_laptop = createVehicle ["Notebook", [0,0,0], [], 1, "NONE"];
_board = createVehicle ["Notice_board_EP1", [0,0,0], [], 1, "NONE"];
_radio = createVehicle ["Radio", [0,0,0], [], 1, "NONE"];

_desk attachTo [_Cargo,[0,2.5,-.8]];
_chair attachTo [_Cargo,[.7,1.2,-.6]];
_laptop attachTo [_Cargo,[0,2.5,-.2]]; 
_board attachTo [_Cargo,[.8,0,-.2]]; 
_radio attachTo [_Cargo,[0.5,2.5,-.3]];  

_desk setdir 180;
_chair setdir 135;
_laptop setdir 180;
_board setdir 90;


_Cargo animate ["door_1_1", 0];
_Cargo animate ["door_1_2", 0];


_grp = createGroup _side;


_coin = _grp createunit ["ConstructionManager", [0,0,1],[], 0,"none"];


titletext[format ["%1","Loading Construction Action Menu!"], "Plain" , 1];


_coin setPos (getpos _Cargo);

_coin setvariable ["BIS_coin_rules",[_caller],true];
_coin setvariable ["BIS_coin_categories",["Base", "Defence", "Fortifications", "Vehicles"],true]; 
_coin setvariable ["BIS_coin_areasize",[400,400],true];
_coin setvariable ["BIS_COIN_onSell",{+1},true];


if (_side == west) then {
_coin setvariable ["BIS_COIN_onConstruct",{if (((_this select 1) iskindof "AllVehicles") && !((_this select 1) iskindof "Man")) then {(_this select 1) setVehicleInit "_nil = [this,west,1,'westMK',0] execFSM 'FSM\Vehicle\AI_Driver_Start.fsm';";processInitCommands;clearVehicleInit (_this select 1);};},true];
};

if (_side == east) then {
_coin setvariable ["BIS_COIN_onConstruct",{if (((_this select 1) iskindof "AllVehicles") && !((_this select 1) iskindof "Man")) then {(_this select 1) setVehicleInit "_nil = [this,east,1,'eastMK',0] execFSM 'FSM\Vehicle\AI_Driver_Start.fsm';";processInitCommands;clearVehicleInit (_this select 1);}},true];
};

if(_side == west) then {

_coin setvariable ["BIS_coin_items", [
	
//--- Class, Category, Cost or [fundsID,Cost], (display name)
["USMC_WarfareBFieldhHospital","Base",[0,0], "Field Hospital"],
["USMC_WarfareBVehicleServicePoint","Base",[0,0], "Service Point"],
["USMC_WarfareBBarracks","Base",[0,0], "Barracks"],
["HeliH","Base",[0,0], "Heli Pad"],
["USMC_WarfareBUAVterminal","Base",[0,0], "UAV Terminal"],
["USMC_WarfareBArtilleryRadar","Base",[0,0], "Artillery"],

["SearchLight","Defence",[0,0], "SearchLight"],
["M2StaticMG","Defence",[0,0], "M2 Machine Gun"],
["MK19_TriPod","Defence",[0,0], "Mk19 Minitripod"],
["M252","Defence",[0,0], "M252 81mm Mortar"],
["TOW_TriPod","Defence",[0,0], "TOW Tripod"],
["Stinger_Pod","Defence",[0,0], "AA Pod"],
["USMC_WarfareBMGNest_M240","Defence",[0,0], "MG Nest (M240)"],
["M119","Defence",[0,0], "M119"],

["Land_fortified_nest_big","Fortifications",[0,0], "Fortified Nest"],
["Fort_RazorWire","Fortifications",[0,0], "Razorwire"],
["Land_Fort_Watchtower","Fortifications",[0,0], "Watchtower"],
["Land_CamoNet_NATO","Fortifications",[0,0], "CamoNet"],
["Land_fort_bagfence_long","Fortifications",[0,0], "Sandbags"],
["Land_HBarrier_large","Fortifications",[0,0], "HBarrier (Large)"],
["Land_HBarrier5","Fortifications",[0,0], "HBarrier (Small)"],
["Land_HBarrier1","Fortifications",[0,0], "HBarrier (Cube)"],

["C130J","Vehicles",[0,0], "C130J"]
		
],true];

};


if(_side == east) then {

_coin setvariable ["BIS_coin_items", [
	
//--- Class, Category, Cost or [fundsID,Cost], (display name)
["RU_WarfareBFieldhHospital","Base",[0,0], "Field Hospital"],
["RU_WarfareBVehicleServicePoint","Base",[0,0], "Service Point"],
["RU_WarfareBBarracks","Base",[0,0], "Barracks"],
["HeliH","Base",[0,0], "Heli Pad"],
["RU_WarfareBUAVterminal","Base",[0,0], "UAV Terminal"],
["RU_WarfareBArtilleryRadar","Base",[0,0], "Artillery"],

["SearchLight","Defence",[0,0], "SearchLight"],
["DSHKM_Ins","Defence",[0,0], "DSHKM Machine Gun"],
["AGS_RU","Defence",[0,0], "Grenade Launcher"],
["2b14_82mm","Defence",[0,0], "2b14 82mm Mortar"],
["Metis","Defence",[0,0], "Metis Tripod"],
["Stinger_Pod","Defence",[0,0], "AA Pod"],
["RU_WarfareBMGNest_PK","Defence",[0,0], "MG Nest (PK)"],
["D30_RU","Defence",[0,0], "D30"],

["Land_fortified_nest_big","Fortifications",[0,0], "Fortified Nest"],
["Fort_RazorWire","Fortifications",[0,0], "Razorwire"],
["Land_Fort_Watchtower","Fortifications",[0,0], "Watchtower"],
["Land_CamoNet_NATO","Fortifications",[0,0], "CamoNet"],
["Land_fort_bagfence_long","Fortifications",[0,0], "Sandbags"],
["Land_HBarrier_large","Fortifications",[0,0], "HBarrier (Large)"],
["Land_HBarrier5","Fortifications",[0,0], "HBarrier (Small)"],
["Land_HBarrier1","Fortifications",[0,0], "HBarrier (Cube)"],

["Mi24_V","Defence",[0,0], "Mi24_V"]
		
],true];

};

[_Cargo,_caller,_coin,_grp,_desk,_chair,_laptop,_board,_radio] execVM "support\modules\ZKS_Build\end.sqf";


