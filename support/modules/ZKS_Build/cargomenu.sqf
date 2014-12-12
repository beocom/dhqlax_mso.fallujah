//Script By Zonekiller -- http://zonekiller.ath.cx -- zonekiller@live.com.au

sleep 2;



_Cargo = _this select 0;
_MyCargo = _this select 1;
_side  = _this select 2; 
_truck = [];

_Cargo animate ["door_1_1", 1];
_Cargo animate ["door_1_2", 1];
_Cargo animate ["door_2_1", 1];
_Cargo animate ["door_2_2", 1];



clearVehicleInit _Cargo;


if (isserver) then 
{
	if (_side == "west") then 
	{
	_Cargo setVehicleInit "0 = [this,'west'] execFSM 'support\modules\ZKS_Build\SpawnStd.fsm';";
	};

	if (_side == "east") then 
	{
	_Cargo setVehicleInit "0 = [this,'east'] execFSM 'support\modules\ZKS_Build\SpawnStd.fsm';";
	};

processInitCommands;
clearVehicleInit _Cargo;

};



if (_side == "west") then 
{
_truck = ["MTVR","MTVR_DES_EP1"];
};

if (_side == "east") then 
{
_truck = ["KamazOpen"];
};


_Cargo setVariable ["MyCargo", _MyCargo, false];

_Cargo addaction ["Pack up truck", "support\modules\ZKS_Build\packup.sqf", [_side], 808, true, true, "", "not (_target getVariable 'MyCargo') and (count (nearestObjects [_target," + str(_truck) + ", 10]) > 0) && (side _this == " + _side + ")  and (_target animationPhase 'door_1_2' > 0.5)"];

_Cargo addaction ["Unpack truck", "support\modules\ZKS_Build\deploy.sqf", [_side], 807, true, true, "", "(_target getVariable 'MyCargo') && (side _this == " + _side + ")"];

_Cargo addaction ["Open Workshop", "support\modules\ZKS_Build\coin.sqf", [], 807, true, true, "", "(side _this == " + _side + ") and ((_this iskindof 'USMC_SoldierS_Engineer') or (_this iskindof 'RU_Soldier_Officer')) and (((getposATL _target) select 2) < 1) and ((_this distance _target) < 7) and (_target animationPhase 'door_1_2' > 0.5)"];