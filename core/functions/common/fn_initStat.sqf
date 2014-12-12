private["_stage"];
_stage = format["Initialising: %1", _this];
player createDiaryRecord ["msoPage", ["Initialisation", 
	_stage
]]; 
titleText [_stage, "BLACK FADED"];

if ((!isServer) || (!isdedicated)) then {
	if  (_this == "Completed") then {
		player setVariable ["mso_initcomplete", 1, false];
	};
};

if ((isServer) || (isdedicated)) then {
	if  (_this == "Completed") then {
		missionNameSpace setVariable ["server_initcomplete", 1];
		[] execVM "core\modules\persistentDB\lobby_onConnected.sqf"; 
	};
};
