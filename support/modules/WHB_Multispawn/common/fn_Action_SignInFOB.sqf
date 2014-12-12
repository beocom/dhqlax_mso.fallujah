// Calls MSO_fnc_playerSetSpawn method on the client machine, when triggered, updates myRespawnPoint to the object's location.
// Author: WobbleyheadedBob aka CptNoPants

private ["_hqObject","_returnMessage"];
_hqObject = _this select 0;

_returnMessage = [_hqObject] call MSO_fnc_playerSetSpawn;
{player sideChat _x} forEach _returnMessage;