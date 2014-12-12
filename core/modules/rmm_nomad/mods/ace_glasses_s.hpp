{
	if (_this != "") then {
		if !(player hasWeapon _this) then {player addWeapon _this};
		[player, _this] execFSM '\x\ace\addons\sys_goggles\use_glasses.fsm';
	};
},
