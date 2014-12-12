private ["_locs"];
if(isNil "TownManager")then{TownManager = 1;};
if (TownManager == 0 || !isServer) exitWith{};

if (isNil "bis_functions_mainscope") exitWith{};

CRB_TownMgr_debug = false;

if(isNil "twnmgr_status")then{twnmgr_status = 1;};
if(isNil "twnmgr_civ")then{twnmgr_civ = 1;};
if(isNil "twnmgr_detected")then{twnmgr_detected = 1;};
if(isNil "twnmgr_seized")then{twnmgr_seized = 1;};
//if(isNil "twnmgr_tasks")then{twnmgr_tasks = 1;};

diag_log format["MSO-%1 Town Manager - Starting", time];

// Manage/provide intel on each town/area with a city center
_locs = bis_functions_mainscope getvariable "locations";
diag_log format["MSO-%1 Town Manager - Locations: %2", time, count _locs];

CRB_whichSideText = {
        switch(_this) do {
                case west: {"BLUFOR";};
                case east: {"OPFOR";};
                case resistance: {"Guerrilla";};
                case civilian: {"Civilian";};
        };
        
};

CRB_whichSideTrigger = {
        switch(_this) do {
                case resistance: {"GUER";};
                case civilian: {"CIV";};
                default {str _this};
        };
        
};



CRB_updateDetectedMarker = {
        private ["_name","_pos","_detector","_detected","_color","_detectorTxt","_globalmsg"];
        _name = _this select 0;
        _pos = _this select 1;
        _detector = _this select 2;
        _detectorTxt = switch(_detector) do {
			case civilian: {"civilian"};
			case resistance: {"resistance"};
			default {str _detector};
		};
        _detected = _this select 3;
        _color = _this select 4;
 
	if(_detector == civilian) then {
		_globalmsg = format["%3 HUMINT reports %4 movement at %1 (%5)", _name, _detectorTxt, (_detector call CRB_whichSideText), (_detected call CRB_whichSideText), (mapGridPosition _pos)];
		format["""%1_mgr"" setMarkerColor ""%2""; GLOBAL_MESSAGE = [%3, ""%4""]; publicVariable ""GLOBAL_MESSAGE"";", _name, _color, playerSide, _globalmsg];     
	} else {
		_globalmsg = format["%2 HUMINT reports %4 movement at %1 (%5)", _name, _detectorTxt, (_detector call CRB_whichSideText), (_detected call CRB_whichSideText), (mapGridPosition _pos)];
		format["""%1_mgr"" setMarkerColor ""%2""; GLOBAL_MESSAGE = [%3, ""%4""]; publicVariable ""GLOBAL_MESSAGE"";", _name, _color, _detectorTxt, _globalmsg];   

	};		
};

CRB_updateSeizedMarker = {
        private ["_name","_detector","_color","_detectorTxt","_globalmsg"];
        _name = _this select 0;
        _detector = _this select 1;
        _detectorTxt = switch(_detector) do {
			case civilian: {"civilian"};
			case resistance: {"resistance"};
			default {str _detector};
		};
        _color = _this select 2;
     	_globalmsg = format["SIGINT suggests %1 has been secured by %2 forces", _name, (_detector call CRB_whichSideText)];
		format["""%1_mgr"" setMarkerColor ""%2""; GLOBAL_MESSAGE = [%3, ""%4""]; publicVariable ""GLOBAL_MESSAGE"";", _name, _color, _detectorTxt, _globalmsg];   

};

CRB_createDetectTrigger = {
        private ["_detected","_detector","_size","_color","_pos","_name","_trg","_cond"];
        _name = _this select 0;
        _pos = _this select 1;
        _size = _this select 2;
	if(_size < 250) then {_size = 250;};
        _detected = _this select 3;
        _detector = _this select 4;
        _color = _this select 5;
		
        _cond = switch(_detector) do {
                case civilian: {
                        format["this && (str playerSide != ""%1"")", _detected];
                };
                default {
                        format["this && (str playerSide == ""%1"")", _detector];
                };
        };
        
        // Create the detect trigger 
        _trg = [_pos, "AREA:", [_size, _size, 0, false], "ACT:", [(_detected call CRB_whichSideTrigger), format["%1 D", _detector call CRB_whichSideTrigger], true], "STATE:",  [_cond, [_name,_pos,_detector, _detected, _color] call CRB_updateDetectedMarker, ""]] call CBA_fnc_createTrigger;
        if(!CRB_TownMgr_debug) then {
                _trg = _trg select 0;
                if(_detector == civilian) then {
                        _trg setTriggerTimeout [180, 540, 900, false];
                } else {
                        _trg setTriggerTimeout [30, 90, 150, false];
                };
        } else {
                diag_log format["MSO-%1 Town Manager - %2", time, _trg];
        };
};

CRB_createSeizedTrigger = {
        private ["_detector","_size","_color","_pos","_name","_trg","_cond"];
        _name = _this select 0; 
        _pos = _this select 1;
        _size = _this select 2;
	if(_size < 250) then {_size = 250;};
        _detector = _this select 3;
        _color = _this select 4;

        _cond = switch(_detector) do {
                default {
                        format["this && (getMarkerColor ""%1_mgr"" != ""%2"") && (str playerSide == ""%3"")", _name, _color, _detector]
                        //format["this"];
                };
        };
			
        // Create the seized trigger 
        _trg = [_pos, "AREA:", [_size, _size, 0, false], "ACT:", [format["%1 SEIZED", _detector call CRB_whichSideTrigger], "PRESENT", true], "STATE:",  [_cond, [_name,_detector, _color] call CRB_updateSeizedMarker,""]] call CBA_fnc_createTrigger;
        //_trg = [_pos, "AREA:", [_size, _size, 0, false], "ACT:", [format["%1 SEIZED", _detector call CRB_whichSideTrigger], "PRESENT", true], "STATE:",  [_cond, [_name,_detector, _color] call CRB_updateSeizedMarker, format["[playerSide, ""HQ""] sideChat ""SIGINT suggests %1 is no longer under the control of %2 forces"";", _name, _detector call CRB_whichSideText]]] call CBA_fnc_createTrigger;
        
        if(!CRB_TownMgr_debug) then {
                _trg = _trg select 0;
				_trg setTriggerTimeout [120, 210, 300, true];
        } else {
                diag_log format["MSO-%1 Town Manager - %2", time, _trg];
        };
};        



// Setup Trigger for map

// Satellite Intel Trigger for OPFOR and BLUFOR

// End Game Trigger? Check to see if 1 side has seized all locations?

// Setup triggers per location
{
        private ["_size","_name", "_pos","_trg","_type","_loc","_colour"];
        _pos = position _x;
        _name = _x getVariable "name";
		if !(isnil "bis_alice_mainscope") then {
            _size = _x getVariable ["ALICE_townsize", bis_alice_mainscope getVariable "ALICE_townsize"];	
        } else {
            _size = 250; // so it doesnt need alice to be running anymore
		};
        
	// Get location object nearest each CityCenter (City Centers typically don't have text friendly names)
        _loc = (nearestLocations [_pos, ["NameCityCapital","NameCity","NameVillage","Airport","Strategic","VegetationVineyard","NameLocal"], _size]) select 0;
        if(!isNil {text _loc}) then {_name = text _loc;};

        if(twnmgr_status == 1) then {
                _type = "ELLIPSE";
        } else {
                _type = "ICON";
        };

	_colour = "ColorWhite";
        //_side = _x getVariable "crb_twnmgr_side";
        //if(!isNil "_side") then {
        //        switch (_side) do {
	//		case civilian: {_colour = "ColorWhite";};
	//		case resistance: {_colour = "ColorGreen";};
	//		case west: {_colour = "ColorBlue";};
	//		case east: {_colour = "ColorRed";};
	//	};
        //};
        [format["%1_mgr", _name], _pos, _type, [_size, _size], "COLOR:", _colour, "BRUSH:", "Cross", "PERSIST"] call CBA_fnc_createMarker;
		
		if (twnmgr_detected == 1) then {
			//////////////////////////////////////////
			// BLUFOR DETECT Triggers
			//////////////////////////////////////////        

			// Create the BLUFOR detect EAST trigger 
			[_name, _pos, _size, east, west, "ColorRed"] call CRB_createDetectTrigger;
			// Create the BLUFOR detect GUER trigger 
			[_name, _pos, _size, resistance, west, "ColorGreen"] call CRB_createDetectTrigger;

			//////////////////////////////////////////
			// GUER DETECT Triggers
			//////////////////////////////////////////        
			
			// Create the GUER detect BLUFOR trigger 
			[_name, _pos, _size, west, resistance, "ColorBlue"] call CRB_createDetectTrigger;
			// Create the GUER detect EAST trigger 
			[_name, _pos, _size, east, resistance, "ColorRed"] call CRB_createDetectTrigger;
			
			//////////////////////////////////////////
			// OPFOR DETECT Triggers
			//////////////////////////////////////////        

			// Create the EAST detect BLUFOR trigger 
			[_name, _pos, _size, west, east, "ColorBlue"] call CRB_createDetectTrigger;
			// Create the EAST detect GUER trigger 
			[_name, _pos, _size, resistance, east, "ColorGreen"] call CRB_createDetectTrigger;      
		};
		
		if (twnmgr_seized == 1) then {
			//////////////////////////////////////////
			// BLUFOR SEIZED Triggers
			//////////////////////////////////////////        
			
			[_name, _pos, _size, west, "ColorBlue"] call CRB_createSeizedTrigger;

			//////////////////////////////////////////
			// GUER SEIZED Triggers
			//////////////////////////////////////////        
			
			[_name, _pos, _size, resistance, "ColorGreen"] call CRB_createSeizedTrigger;
			
			//////////////////////////////////////////
			// OPFOR SEIZED Triggers
			//////////////////////////////////////////        

			[_name, _pos, _size, east, "ColorRed"] call CRB_createSeizedTrigger;
		};
		
		if (twnmgr_civ == 1) then {
			//////////////////////////////////////////
			// CIVILIAN DETECT Triggers
			//////////////////////////////////////////        
			
			// Create the CIVILIAN detect BLUFOR trigger  
			[_name, _pos, _size, west, civilian, "ColorBlue"] call CRB_createDetectTrigger;

			// Create the CIVILIAN detect OPFOR trigger  
			[_name, _pos, _size, east, civilian, "ColorRed"] call CRB_createDetectTrigger;

			// Create the CIVILIAN detect GUER trigger  
			[_name, _pos, _size, resistance, civilian, "ColorGreen"] call CRB_createDetectTrigger;
        };
		
} forEach _locs;
