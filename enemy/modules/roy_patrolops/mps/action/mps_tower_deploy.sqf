// Written by EightySix

	_object = _this select 0;
	_position = position _object;
	_dir = direction _object;

	hint "Deploying Tower";
	player playMove "ActsPercSnonWnonDnon_carFixing2";
	sleep 5;
	if (!alive _object || !alive player) exitWith {player playMoveNow "AmovPercMstpSlowWrflDnon";};
	sleep 5;
	if (!alive _object || !alive player) exitWith {player playMoveNow "AmovPercMstpSlowWrflDnon";};
	sleep 5;
	if (!alive _object || !alive player) exitWith {player playMoveNow "AmovPercMstpSlowWrflDnon";};
	sleep 5;
	if (!alive _object || !alive player) exitWith {player playMoveNow "AmovPercMstpSlowWrflDnon";};
	detach _object;
	deleteVehicle _object;
	sleep 1;
	_tower = "Land_Vysilac_FM" createVehicle [_position select 0, _position select 1, 0];

	[nil, _tower, "per", rADDACTION, "Pack Tower", (mps_path+"action\mps_tower_pack.sqf"), [], 1, true, true, "", ""] call RE;

	player addRating 50;

if (true) exitWith {player playMoveNow "AmovPercMstpSlowWrflDnon";};