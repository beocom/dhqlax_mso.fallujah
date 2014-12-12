
private ["_name"];

if (isServer && !(isNull player)) then {
	hint "Loading available recruit information...";
	tup_recruit_classes = [0, faction player,"Man"] call mso_core_fnc_findVehicleType;
	hint "Recruit information loaded.";
};

{
	_name = format ["%1 (%2)", getText(configFile >> "CfgVehicles" >> _x >> "displayname"), str _x];
	lbAdd [1, _name];
} foreach tup_recruit_classes;
