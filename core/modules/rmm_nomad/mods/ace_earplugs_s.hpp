{
	if (_this) then {
		if !(player hasWeapon "ACE_Earplugs") then {player addWeapon "ACE_Earplugs"};
		[player] execFSM '\x\ace\addons\sys_goggles\use_earplug.fsm';
	};
},
