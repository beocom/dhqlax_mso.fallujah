#include <crbprofiler.hpp>
if(!isServer) exitWith{};

private ["_mapsize","_helidest","_planedest","_destinations"];

tup_airtraffic_debug = false;

if (isNil "tup_airtraffic_factions") then {tup_airtraffic_factions = 0;};
if (tup_airtraffic_factions == 2) exitWith{};
if (isNil "tup_airtraffic_intensity") then {tup_airtraffic_intensity = 0;};
if (isNil "tup_airtraffic_ROE") then {tup_airtraffic_ROE = 2;};

switch(tup_airtraffic_ROE) do {
	case 1: {
		tup_airtraffic_combatMode = "BLUE";
	};
	case 2: {
		tup_airtraffic_combatMode = "GREEN";
	};
	case 3: {
		tup_airtraffic_combatMode = "WHITE";
	};
	case 4: {
		tup_airtraffic_combatMode = "YELLOW";
	};
	case 5: {
		tup_airtraffic_combatMode = "RED";
	};
};

if(isNil "TUP_CIVFACS") then {
	TUP_CIVFACS = [civilian] call mso_core_fnc_getFactions;
};

switch toLower(worldName) do {		
	case "chernarus": {
		// Clear taxi way in NW airfield
		{hideobject _x;} forEach nearestObjects [[4659.2949,10425.214], ["Building"], 30];
		{hideobject _x;} forEach nearestObjects [[4715.2759,10321.276], ["Building"], 30];
		hideobject ([4740.1904,10224.742] nearestObject "Land_Lampa_sidl");
	};
	case "takistan": {
	};
	case "utes": {
	};
	case "zargabad": {
	};
	default {};
};

waitUntil{!isNil "BIS_fnc_init"};

// Calculate size of map
tup_airtraffic_getMapSize = {
	private ["_center","_mapsize"];
	// Get center of map
	_center = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
	// Calculate size of map
	_mapsize = ((_center select 0) max (_center select 1)) * 1.2;
	if (tup_airtraffic_debug) then {
		diag_log format ["MSO-%1 Air Traffic: Mapsize is %2", time, _mapsize];
		["tup_airtraffic_mapSize", _center, "Rectangle", [_mapsize,_mapsize], "BRUSH:", "Border", "GLOBAL"] call CBA_fnc_createMarker;
	};
	_mapsize;
};

// Define airports-hangars-Helipads from the Map
// Find airport locations
tup_airtraffic_getAirports = {
	private ["_airports"];
	_airports = ["Airport"];
	([_airports,tup_airtraffic_debug,"ColorGreen","airport"] call mso_core_fnc_findLocationsByType);
};

//Find hangars at airport locations
tup_airtraffic_getHangars = {
	private ["_destairfield","_planelandings"];
	_destairfield = _this select 0;
	_planelandings = ["Land_SS_hangar","Land_SS_hangarD","Land_Mil_hangar_EP1","ED102_Hangar","ED102_HangarOffice"];
	([_planelandings, _destairfield, 1000,tup_airtraffic_debug,"ColorGreen","Airport"] call mso_core_fnc_findObjectsByType);
};

// Find helipads on the map
tup_airtraffic_getHeliports = {
	private ["_mapsize","_helilandings"];
	_mapsize = _this select 0;
	_helilandings = ["HeliH","HeliHRescue","HeliHCivil"];
	([_helilandings, [], _mapsize * 1.4, tup_airtraffic_debug,"ColorBlack","heliport"] call mso_core_fnc_findObjectsByType);
};

_mapsize = call tup_airtraffic_getMapSize;
_planedest = [call tup_airtraffic_getAirports] call tup_airtraffic_getHangars;
_helidest = [_mapsize] call tup_airtraffic_getHeliports;
// Total number of landing points - hangars and helipads
_destinations = count _planedest + count _helidest;
// Check there are some hangars or helipads, if not exit
if (_destinations < 1) exitWith {
	diag_log format ["MSO-%1 Air Traffic: Cannot find any air landing objects. Exiting.", time];
};

// Get the factions for the controlling side and count their units (check to see if landing at LHD)
tup_airtraffic_getFactions = {
	private ["_factions","_currentairfield","_airfieldside","_LHDobject"];
	_currentairfield = _this select 0;
	_factions = [];
	
	_airfieldside = [_currentairfield, 1000, "", false] call mso_core_fnc_getDominantSide;
	
	// Get the factions for the controlling side and count their units (check to see if landing at LHD)
	_LHDobject = (position _currentairfield) nearObjects ["Land_LHD_1",100];
	if (count _LHDobject > 0) then {
		_factions = ["USMC"];
	} else {
		// Work out side that controls destination (based on unit numbers)
		if (tup_airtraffic_factions == 1) then {
			_factions = TUP_CIVFACS;
			_airfieldside = civilian;
		} else {
			_factions = [_airfieldside, _currentairfield, 1000,"factions",false,""] call mso_core_fnc_getFactions;
		};
	};
	
	[_factions,_airfieldside];
};

// Create aircraft 
tup_airtraffic_createAircraft = {
	private ["_factions","_aircraftClass","_airfieldside","_currentairfield","_j","_isPlane","_vehiclelist","_aircraft","_startpos","_aircraftVehicle","_aircraftCrew","_vehicletype","_tmp"];
	_j = _this select 1;
	_currentairfield = _this select 1;
	_startpos = _this select 2;
	_isPlane = _this select 3;
	
	_tmp = [_currentairfield] call tup_airtraffic_getFactions;
	_airfieldside = _tmp select 1;
	_factions = _tmp select 0;
	
	// Check to see if we need a plane or helicopter
	if (_isPlane) then {
		_vehicletype = "Plane";
	} else {
		_vehicletype = "Helicopter";
	};
	
	// Select the faction based on unit count bias and get a list of possible vehicles
	_vehiclelist = [0, _factions,_vehicletype] call mso_core_fnc_findVehicleType; 
	_aircraftClass = "";
	
	// Select a vehicle from the list - if no valid vehicle selet a civilian aircraft
	if (count _vehiclelist > 0) then {
		if (tup_airtraffic_debug) then {
			diag_log format ["MSO-%1 Air Traffic: %4 %2 Faction: %5 Vehicle list: %3", time, _j, _vehiclelist, _currentairfield, _factions];
		};
		_aircraftClass = (_vehiclelist) call BIS_fnc_selectRandom;
	} else {
		_aircraftClass = ([0, TUP_CIVFACS,_vehicletype] call mso_core_fnc_findVehicleType) call BIS_fnc_selectRandom;
		_airfieldside = civilian;
		if (tup_airtraffic_debug) then {
			diag_log format ["MSO-%1 Air Traffic: %4 %2 Could not find suitable military aircraft, civilian aircraft found: %3", time, _j, _aircraftClass, _currentairfield];
		};
	};
	
	if (tup_airtraffic_debug) then {
		diag_log format ["MSO-%1 Air Traffic: %4 %2 Found Aircraft %3", time, _j, _aircraftClass, _currentairfield];
	};
	
	// Create aircraft
	_aircraft = [[_startpos, 10] call CBA_fnc_randPos, 0,_aircraftClass, _airfieldside] call BIS_fnc_spawnVehicle;
	_aircraftVehicle = _aircraft select 0;
	_aircraftCrew = _aircraft select 1;
	{_x setSkill 0.1;} forEach _aircraftCrew;
	if (tup_airtraffic_combatMode == "BLUE") then {
		{_x disableAI "AUTOTARGET"} foreach _aircraftCrew;
		{_x disableAI "TARGET"} foreach _aircraftCrew;
				_aircraftVehicle setVehicleAmmo 0;
				if (tup_airtraffic_debug) then {
					diag_log format ["MSO-%1 Air Traffic: %4 %2 Removed weapons for Aircraft %3", time, _j, _aircraftClass, _currentairfield];
				};
	};
	
	_aircraftVehicle;
};

// Spawn a process for each destination (each hangar and each helipad)
for "_j" from 0 to (_destinations-1) do {
	[_j, _helidest, _planedest, _mapsize] spawn {
		private ["_destination","_aircraftVehicle","_startpos","_destpos","_endpos","_grp","_wp","_j","_mapsize","_currentairfield","_landEnd","_planedest","_helidest","_isPlane","_startHeight","_controltowers","_controltw","_mv22pos","_maxdist","_t","_scrambleTime","_controlTowerTypes","_LHDobject"];
		_j = _this select 0;
		_helidest = _this select 1;
		_planedest = _this select 2;
		_mapsize = _this select 3;
		_maxdist = 3000;
		
		_isPlane = false;
		_startHeight = 500 + (random 200);
		
		// Work out if current destination is for a plane or helicopter
		if (_j < count _planedest) then {
			_currentairfield = _planedest select _j;
			_isPlane = true;
		} else {
			_currentairfield = _helidest select (_j - count _planedest);
			_isPlane = false;
		};
				
		//Loop continuously and create aircraft for the destination		
		while {true} do {
			// Wait a random amount of time before starting
			waitUntil{
				sleep (90 + random 90);
				({(_x distance _currentairfield < _maxdist)} count ([] call BIS_fnc_listPlayers) > 0) &&
				(random 4 > (3 - tup_airtraffic_intensity))
			};
			
			CRBPROFILERSTART("TUP Air Traffic")
			
			////////////////////////
			// Define Positions
			////////////////////////
			
			//Create a random spawn point along the edge of the map				
			_startpos = [_mapsize * 2,_startHeight,false,"","",""] call mso_core_fnc_randomEdgePos;
			
			_destpos = position _currentairfield;
			// Set a safe destination point at airfield and destination type for debugging.
			If (_isPlane) then {
				_destination = "Hangar";
				if (tup_airtraffic_debug) then {diag_log format ["MSO-%1 Air Traffic: %2 has %3 objects", time, _j, {(_x iskindof "Plane")} count (_destpos nearObjects 30)];};
				waitUntil{sleep (30 + random 30);{(_x iskindof "Plane")} count (_destpos nearObjects 30) == 0};
			} else {
				_destination = "HeliPad";
				if (tup_airtraffic_debug) then {diag_log format ["MSO-%1 Air Traffic: %2 has %3 objects", time, _j, {(_x iskindof "Helicopter")} count (_destpos nearObjects 7)];};
				waitUntil{sleep (30 + random 30);{(_x iskindof "Helicopter")} count (_destpos nearObjects 7) == 0};
			};
			
			// Define a random place at the edge of the map to fly to
			_endpos = [_mapsize * 2,_startheight,false,"","",""] call mso_core_fnc_randomEdgePos;
			
			if (tup_airtraffic_debug) then {
				private ["_t","_m"];
				_t = format["AirTraffic_s%1", _j];
				_m = [_t, _startpos, "Icon", [0.5,0.5], "TEXT:", str _j, "TYPE:", "hd_start", "GLOBAL"] call CBA_fnc_createMarker;
				_t = format["AirTraffic_d%1", _j];
				_m = [_t, _destpos, "Icon", [0.5,0.5], "TYPE:", "hd_pickup", "GLOBAL"] call CBA_fnc_createMarker;
				_t = format["AirTraffic_e%1", _j];
				_m = [_t, _endpos, "Icon", [0.5,0.5], "TEXT:", str _j, "TYPE:", "hd_end", "GLOBAL"] call CBA_fnc_createMarker;
			};

				
			// Create aircraft 
			_aircraftVehicle = [_j, _currentairfield, _startpos, _isPlane] call tup_airtraffic_createAircraft;
			diag_log format["MSO-%1 Air Traffic: #%2, Vehicle: %6 Start: %3 Landing: %4 End: %5", time, _j, _startpos, _currentairfield, _endpos, typeOf _aircraftVehicle];
			
			
			// Make sure MV22 lands near hangar and not on runway as it doesn't taxi
			_landEnd = objNull;
			if (typeof _aircraftVehicle == "MV22") then {
				_mv22pos = [_destpos, 0, 45, 15, 0, 0, 0] call BIS_fnc_findSafePos;
				_landEnd = "HeliHEmpty" createVehicle _mv22pos;
			};
			
			////////////////////////
			// Set aircraft waypoints
			////////////////////////
			
			// Destination Waypoint
			_grp = group _aircraftVehicle;
			_wp = _grp addwaypoint [_destpos, 50];
			_wp setWaypointCombatMode tup_airtraffic_combatMode;
			_wp setWaypointBehaviour "CARELESS";
			_wp setWaypointStatements ["true", "if(typeOf vehicle this != ""MV22"")then{vehicle this action [""Land"", vehicle this]};"];
			_wp setWaypointCompletionRadius 3000;

			// Check to see if aircraft is near Control Tower, if so, crew may get out and go for a chat
			_controlTowerTypes = ["Land_Mil_ControlTower","Land_Mil_ControlTower_EP1"];
			_controltowers = nearestObjects [position _currentairfield, _controlTowerTypes, 200]; 
			if (tup_airtraffic_debug) then {diag_log format ["MSO-%1 Air Traffic: %5 %2 %3 Found ControlTowers: %4", time, _j, typeOf _aircraftVehicle, count _controltowers, _currentairfield];};
			
			if (!_isPlane || typeOf _aircraftVehicle == "MV22") then {
				
				// Check to see if landing area is LHD, use Mand Heliroute to land
				_LHDobject = _destpos nearObjects ["Land_LHD_6",100];
				if (count _LHDobject > 0) then {
					if (tup_airtraffic_debug) then {diag_log format ["MSO-%1 Air Traffic: %4 %2 %3 is attempting to land on the LHD", time, _j, typeOf _aircraftVehicle, _destpos];};
					_wp = _grp addwaypoint [(_LHDobject select 0), 0];
						_wp setWaypointType "MOVE";
					_wp setWaypointTimeout [10,10,10];
					
					_wp = _grp addwaypoint [(_LHDobject select 0), 0];
					_wp setWaypointType "MOVE";
					_wp setWaypointSpeed "LIMITED";
					_wp setWaypointStatements ["true", format["[vehicle this, [%1], 9, false, %2] execVM ""ambience\modules\tup_airtraffic\mando_heliroute_arma.sqf"";", (_LHDobject select 0) modelToWorld [0,0,16], 60 + random 120]];
					
					_wp = _grp addwaypoint [(_LHDobject select 0), 0];
					_wp setWaypointType "HOLD";
				} else {
					// Get Crew out of vehicle
					_wp = _grp addwaypoint [_destpos, 0];
					_wp setWaypointType "GETOUT";
					_wp setWaypointTimeout [60, 120, 180];
				};
			};
			
			If (count _controltowers > 0 && !_isPlane) then {
				if (random 1 > 0.5) then {
					// Set time for pilots to leave
					_scrambleTime = 150 + random 150;
					if (tup_airtraffic_debug) then {diag_log format ["MSO-%1 Air Traffic: %4 %2 %3 is stopping for breakfast!", time, _j, typeOf _aircraftVehicle, _destination];};
					
					// Move crew to Control Tower room
					_controltw = _controltowers call BIS_fnc_selectRandom;
					_wp = _grp addwaypoint [position _controltw, 0];
					_wp setWayPointType "MOVE";
					_wp setWaypointHousePosition 1;
					// Get crew to chat once at controltower
					_wp setWayPointStatements ["true","{_x playMove 'AidlPercSnonWnonDnon_talk1'} foreach crew (vehicle this);"];
					_wp setWaypointTimeout [_scrambleTime,_scrambleTime,_scrambleTime];
				};
			}; 
				
			if (!_isPlane || typeOf _aircraftVehicle == "MV22") then {
				// Get Crew out of vehicle
				// Pause then send the crew back to the vehicle
				_wp = _grp addwaypoint [_destpos, 0];
				_wp setWayPointType "GETIN";
			};

			// Create end position waypoint
			_wp = _grp addwaypoint [_endpos, 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointSpeed "NORMAL";
			
			_wp = _grp addwaypoint [_startpos, 0];
			_wp setWaypointType "MOVE";
			
			_wp = _grp addwaypoint [_startpos, 0];
			_wp setWaypointType "CYCLE";
			
			CRBPROFILERSTOP
			
			// Check to see if vehicle was killed/died/crashed
			if (!(_grp call CBA_fnc_isAlive) && (tup_airtraffic_debug)) then {
				diag_log format["MSO-%1 Air Traffic: %3 %4, %2 Died!", time, TypeOf _aircraftVehicle, _destination, _j];
			};
				
			// if all players are 1.2 * maxdist away from airfield or vehicle, delete and restart
			waitUntil{
				sleep 60;
				_players = [] call BIS_fnc_listPlayers;
				(({(_x distance _currentairfield < _maxdist * 1.2)} count _players == 0)
					&& ({_x distance _aircraftVehicle < _maxdist * 1.2} count _players == 0)) ||
				(damage _aircraftVehicle > 0.3) ||
				(_aircraftVehicle distance _endpos < 200) ||
				!(_grp call CBA_fnc_isAlive)
			};

			deleteVehicle _landEnd;
			
			// Remove aircraft and crew
			if (tup_airtraffic_debug) then {
				diag_log format["MSO-%1 Air Traffic: %3 %4 deleting %2", time, TypeOf _aircraftVehicle, _destination, _j];
			};
			{ deleteVehicle _x } forEach units _grp;
			deleteVehicle _aircraftVehicle;
			deletegroup _grp;

			// Pause before creating another aircraft for destination
			_sleep = if(tup_airtraffic_debug) then {10;} else {random 300;};
			sleep _sleep;

			// Remove aircraft and crew
			if (tup_airtraffic_debug) then {
				_t = format["AirTraffic_s%1", _j];
				deleteMarker _t;
				_t = format["AirTraffic_d%1", _j];
				deleteMarker _t;
				_t = format["AirTraffic_e%1", _j];
				deleteMarker _t;
			};
		};
	};
};
