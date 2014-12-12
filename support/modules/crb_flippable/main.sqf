if (isDedicated) exitWith{};

_flipvehs = ["ATV_Base_EP1", "Motorcycle"];
{
	_veh = _x;
	private ["_x"];
	if({_veh isKindOf _x} count _flipvehs > 0) then {
		_veh addAction ["Flip vehicle", CBA_fnc_actionargument_path, [0,{_target call flippable_fnc_vehicleFlip;}], -1];
	};
} forEach vehicles;