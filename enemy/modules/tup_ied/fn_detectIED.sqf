private ["_IED", "_radius"];

_IED = _this select 0;
_radius = _this select 1;
_players = _this select 2;

{
	[nil, _x, "loc", rHINT, format["IED detected within %1 meters.", floor(_x distance _IED)]] call RE;
	if (mps_ace_enabled && (currentWeapon _x in ['ACE_Minedetector_US','ACE_VMH3','ACE_VMM3'])) then {
		[-1, {_this say3D "ace_buzz_2"}, [_IED, _x]] call CBA_fnc_globalExecute;
	};

} foreach _players;


