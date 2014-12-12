// Used in Conjunction with Vehilce respawn Script
// Sets the AddAction on Respawned Vehicles
// 0 = [this, 43200, 9999999, 0, FALSE, FALSE, "[this] execVM 'support\scripts\respawnMHQ.sqf'"]  execVM "support\scripts\vehicle.sqf"
private ["_mhq"];
_mhq = _this select 0;

_mhq setVariable ["MHQState", 0, true];
PV_hqArray set [count PV_hqArray, _mhq];
publicvariable "PV_hqArray";

if !isDedicated then {
	[_mhq] call fn_addAction_HQ;
};