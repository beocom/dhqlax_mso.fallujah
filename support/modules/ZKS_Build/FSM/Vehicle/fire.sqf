//Script By Zonekiller -- http://zonekiller.ath.cx -- zonekiller@live.com.au

_veh = _this select 0;

if ((damage _veh > 0.6) && (random 100 < 50))  then 
{
_initCode = 
sleep (random 3);
{_x setVehicleInit "[this] execVM 'FSM\Vehicle\Burn.sqf';";unassignVehicle _x} foreach crew _veh;
processInitCommands;
clearVehicleInit _veh;
};

