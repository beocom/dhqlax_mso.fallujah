if (isdedicated) exitwith {};

RMM_jipmarkers_types = [
	"mil_objective",
	"mil_marker",
	"mil_flag",
	"mil_ambush",
	"mil_destroy",
	"mil_start",
	"mil_end",
	"mil_pickup",
	"mil_join",
	"mil_warning",
	"mil_unknown"
];

RMM_jipmarkers_colors = [
    "Default",
    "ColorBlack",
    "ColorRed",
    "ColorRedAlpha",
    "ColorGreen",
    "ColorGreenAlpha",
    "ColorBlue",
    "ColorYellow",
    "ColorOrange",
    "ColorWhite",
    "ColorPink",
    "ColorBrown",
    "ColorKhaki" 
];

[] spawn {

	if (persistentDBHeader == 1) then {
		
		waitUntil{MISSIONDATA_LOADED == "true"};
		
		if (pdb_markers_enabled) then {
			waitUntil{!isNil "RMM_jipmarkers"};
			if (debug) then {
				diag_log format["Loaded RMM Jipmarkers, %1, %2", RMM_jipmarkers, count RMM_jipmarkers];
			};
		};
	};

	if (isnil "RMM_jipmarkers") then {
		RMM_jipmarkers = [];
		publicvariable "RMM_jipmarkers";
	} else {
		{
			if(playerSide == (_x select 4)) then {
				private "_mkr";
				_mkr = createMarkerLocal [(_x select 0),(_x select 1)];
				_mkr setmarkertypelocal (_x select 2);
				_mkr setmarkertextlocal (_x select 3);
				_mkr setmarkercolorlocal (_x select 5);
			};
		} foreach RMM_jipmarkers;
	};

	["player", [mso_interaction_key], -9403, ["support\modules\rmm_jipmarkers\fn_menuDef.sqf", "main"]] call CBA_ui_fnc_add;

	CRB_MAPCLICK = CRB_MAPCLICK + "if (!_shift && _alt) then {RMM_jipmarkers_position = _pos; createDialog ""RMM_ui_jipmarkers"";};";
	onMapSingleClick CRB_MAPCLICK;

	"RMM_jipmarkers" addPublicVariableEventHandler {
		{
			if(str (markerPos (_x select 0)) == "[0,0,0]" && playerSide == (_x select 4)) then {
				private "_mkr";
				_mkr = createMarkerLocal [(_x select 0),(_x select 1)];
				_mkr setmarkertypelocal (_x select 2);
				_mkr setmarkertextlocal (_x select 3);
				_mkr setmarkercolorlocal (_x select 5);
			};
		} forEach (_this select 1);
	};
};
