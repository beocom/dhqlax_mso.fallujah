// Calls MSO_fnc_DeployHQ method on the client machine
// Author: WobbleyheadedBob aka CptNoPants

private ["_hqObject","_returnMessage"];
_hqObject = _this select 0;

_returnMessage = [_hqObject] call MSO_fnc_DeployHQ;
{player sideChat _x} forEach _returnMessage;