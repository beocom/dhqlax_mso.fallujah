// IED Detection and Disposal Mod
// 2011 by Reezo

if (!isServer) exitWith{};

private ["_IED"];
_IED = _this select 0;

_IED removeAllEventHandlers "HandleDamage";
_IED removeAllEventHandlers "Hit";
_IED removeAllEventHandlers "MPHit";
_IED removeAllEventHandlers "Killed";
_IED removeAllEventHandlers "MPKilled";

private ["_shell"];
_shell = [["Grenade","Sh_82_HE","Sh_105_HE","Sh_120_HE","Sh_125_HE"],[4,8,2,1,1]] call mso_core_fnc_selectRandomBias;

_shell createVehicle getPos _IED;

//diag_log format["reezo_eod_fnc_detonation - %1 DETONATES WITH POWER %2", _IED, _power];

deleteVehicle _IED;