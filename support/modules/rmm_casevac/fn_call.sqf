private ["_veh","_grp","_vehtype","_priority","_enemy","_patient","_equip","_startpos","_center","_mapsize","_chance","_debug","_armveh","_armvehtype","_speed","_behav","_cargo","_gunship","_invalid","_vehname","_hospital"];

_debug = debug_mso;

RMM_casevac_return = false;

_chance = 0;

PAPABEAR = [West,"HQ"];

// Check that all lines were submitted
for "_x" from 0 to 7 do
{
	if (lbCurSel _x < 0) then {
		_invalid = true;
	};
};

if (_invalid) exitWith {PAPABEAR sideChat format ["%1 this is PAPA BEAR. Invalid Request. Over.", group player];};

PAPABEAR sideChat format ["%1 this is PAPA BEAR. Request Received. Over.", group player];

// Get center of map
_center = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");

// Calculate size of map
_mapsize = ((_center select 0) * 2);

// Set CASEVAC request variables
_cargo = (call (RMM_casevac_lines select 4)) select (lbCurSel 4);
switch(_cargo) do 
{
    case "1": {
        _cargo = 1;
    };
    case "4": {
        _cargo = 4;
    };
	case "7": {
        _cargo = 7;
    };
	case "12": {
        _cargo = 12;
    };
   case "16": {
        _cargo = 16;
    };
	case "23": {
        _cargo = 23;
    };
};

_grp = creategroup (side player);
_priority = (call (RMM_casevac_lines select 2)) select (lbCurSel 2);
_patient = (call (RMM_casevac_lines select 7)) select (lbCurSel 7);
_enemy = (call (RMM_casevac_lines select 5)) select (lbCurSel 5);
_equip = (call (RMM_casevac_lines select 3)) select (lbCurSel 3);
rmm_casevac_marker = (call (RMM_casevac_lines select 6)) select (lbCurSel 6);

// Set startpos
if (str (markerPos "hospital") != "[0,0,0]") then { 
	_hospital = [markerpos "hospital", 0, 500, 15, 0, 0, 0, markerpos "hospital"] call BIS_fnc_findSafePos;
} else {
	_hospital = [markerpos "ammo", 0, 500, 15, 0, 0, 0,markerpos "ammo"] call BIS_fnc_findSafePos;
};
	
// Work out odds of CASEVAC attending and set response parameters
switch(_priority) do 
{
    case "Urgent": {
        _chance = _chance + 0.25;
		_startpos = _hospital;
		RMM_casevac_speed = "FULL";
    };
    case "Urgent Surgical": {
        _chance = _chance + 0.35;
		_startpos = _hospital;
		RMM_casevac_speed = "FULL";
		RMM_casevac_behav = "CARELESS";
    };
    case "Priority": {
        _chance = _chance + 0.25;
		_startpos = [_mapsize, RMM_casevac_flyinheight, _debug, format ["CASEVAC-%1",time], "ColorGreen", "Dot"] call mso_core_fnc_randomEdgePos;
		RMM_casevac_speed = "NORMAL";
		RMM_casevac_behav = "SAFE";
    };
    case "Routine": {
        _chance = _chance + 0.15;
		_startpos = [_mapsize, RMM_casevac_flyinheight, _debug, format ["CASEVAC-%1",time], "ColorGreen", "Dot"] call mso_core_fnc_randomEdgePos;
		RMM_casevac_speed = "NORMAL";
		RMM_casevac_behav = "AWARE";
    };
	case "Convenience": {
        _chance = _chance + 0.1;
		_startpos = [_mapsize, RMM_casevac_flyinheight, _debug, format ["CASEVAC-%1",time], "ColorGreen", "Dot"] call mso_core_fnc_randomEdgePos;
		RMM_casevac_speed = "NORMAL";
		RMM_casevac_behav = "AWARE";
    };
};

switch(_patient) do 
{
    case "BLUFOR Mil": {
        _chance = _chance + 0.3;
		RMM_casevac_speed = "FULL";
		RMM_casevac_behav = "CARELESS";
    };
    case "BLUFOR Civ": {
        _chance = _chance + 0.25;
		RMM_casevac_speed = "FULL";
    };
    case "Mil": {
        _chance = _chance + 0.2;
    };
    case "OPFOR": {
        _chance = _chance - 0.2;
    };
};

switch(_enemy) do 
{
    case "No Enemy": {
        _chance = _chance + 0.3;
		RMM_casevac_behav = "SAFE";
    };
    case "Possible Enemy": {
        _chance = _chance + 0.2;
		RMM_casevac_behav = "AWARE";
    };
    case "Enemy": {
        _chance = _chance + 0.1;
		RMM_casevac_behav = "COMBAT";
    };
    case "Heavy Enemy": {
        _chance = _chance - 0.2;
		RMM_casevac_behav = "STEALTH";
    };
};
	
// Check to see if the CASEVAC can be attended to
if ((random 1 < _chance) && !(RMM_casevac_active)) then 
{
	// Set casevac as active to prevent other calls for casevac
	RMM_casevac_active = true;
	
	// Create aircraft at startpos, based on helicopter chosen
	_vehtype = ([_cargo,faction player,"Helicopter"] call mso_core_fnc_findVehicleType) call BIS_fnc_selectRandom;
	// _startpos = [_startpos select 0, _startpos select 1, 1000];
	_veh = ([_startpos, 0, _vehtype, _grp] call BIS_fnc_spawnVehicle) select 0;
	
	_vehname = getText (configFile >> "CfgVehicles" >> _vehtype >> "displayname");
	
	_callsign = ceil(random 9);
	
	// Hint details of CASEVAC
	hint format ["%1 (Call Sign: PEDRO %9) requested to %2 by %3 for %4 CASEVAC of %5 personnel. %6 are expected. LZ will be marked with %7. Equipment requested: %8.", _vehname , (call (RMM_casevac_lines select 0)) select (lbCurSel 0), _grp, _priority, _patient, _enemy, (call (RMM_casevac_lines select 6)) select (lbCurSel 6), _equip, _callsign];
		
	// Log CASEVAC
	diag_log format ["MSO-%9 CASEVAC: %1 requested to %2 by %3 for %4 CASEVAC of %5 personnel. %6 are expected. LZ will be marked with %7. Equipment requested: %8.", _vehname , (call (RMM_casevac_lines select 0)) select (lbCurSel 0), _grp, _priority, _patient, _enemy, (call (RMM_casevac_lines select 6)) select (lbCurSel 6), _equip, time];
	
	// Confirm authorisation
	[] spawn {
		sleep (5+(random 5));
		PAPABEAR sideChat format ["%1 this is PAPA BEAR. Request Authorised. PEDRO dispatched. Over.", group player]; 
	};
	
	// Check if armed escort required, spawn
	if ((_enemy == "Heavy Enemy") || (_enemy == "Enemy" && ((random 1) > 0.5))) then 
	{
		_gunship = ["AH64D","BAF_Apache_AH1_D","AH1Z","AH64D_EP1","UH1Y","AW159_Lynx_BAF","AH6J_EP1"];
		_armvehtype = (_gunship) call BIS_fnc_selectRandom;
		_armveh = ([position _veh, 0, _armvehtype, group _veh] call BIS_fnc_spawnVehicle) select 0;
		_armavehname = getText (configFile >> "CfgVehicles" >> _armavehtype >> "displayname");
		diag_log format ["MSO-%1 CASEVAC: %2 providing armed escort", time, _armavehname];
		[2,_armveh,{_this flyinheight RMM_casevac_flyinheight - 100;}] call RMM_fnc_ExMP;
		[2,_armveh,{_this lockdriver true;}] call mso_core_fnc_ExMP;
		[2,_armveh,{
			_this spawn {			
				private ["_wp","_hospital","_destpos","_behav","_speed"];
				if (alive _this) then 
				{
					waitUntil {sleep 5;{isplayer _x} count (crew _this) == 0};
					(crew _this) join (createGroup (side (driver _this)));
					{
						_x setskill 0.8;
					} foreach (units (group _this));
					sleep 10;
					PAPABEAR sideChat format ["%1 this is PAPA BEAR. %2 will provide CAS for PEDRO. Over.", group player, _armavehname];
					_wp = (group _this) addwaypoint [position player,0];
					_wp setWaypointType "SAD";
					_wp setWaypointBehaviour RMM_casevac_behav;
					_wp setWaypointSpeed RMM_casevac_speed;
					
					waitUntil {sleep 3;(RMM_casevac_return) || !(alive _this)};
					_hospital = [markerpos "hospital", 0, 50, 15, 0, 0, 0,markerpos "hospital"] call BIS_fnc_findSafePos;
					_wp = (group _this) addwaypoint [_hospital,0];
					_wp setWaypointType "MOVE";
					_wp setWaypointBehaviour RMM_casevac_behav;
					_wp setWaypointSpeed RMM_casevac_speed;
					
					waitUntil {sleep 3;( _this distance _hospital < 200) || !(alive _this)};	
					(group _this) addwaypoint [[0,0,0],0];
					
					waitUntil {sleep 3;( _this distance player > 1500) || !(alive _this)};
					
					// Check for death of chopper
					if !(alive _this) then {
						hint format ["CASEVAC: Armed Escort has crashed!", typeof _this];
						diag_log format ["MSO-%2 CASEVAC: %1 has crashed!", typeof _this, time];
					};
					
					// Delete Chopper
					_this call CBA_fnc_deleteEntity;
				};
			};
		}] call mso_core_fnc_ExMP;
	};
	
	// Check for any additional equipment - WIP
	if (_equip != "None") then {
		// Load chopper with selected medical supplies
		// A2/OA - Field Hospital can be loaded in MSO
		// ACE - Medical supplies (chosen from CASEVAC drop down)?
	};
	
	// Set fly in height
	[2,_veh,{_this flyinheight RMM_casevac_flyinheight;}] call mso_core_fnc_ExMP;	

	// Lock driver of helicopter
	[2,_veh,{_this lockdriver true;}] call mso_core_fnc_ExMP;

	// Spawn vehicle and crew, set waypoint, do casevac
	[2,[_veh,_callsign],{
		_this spawn {
			private ["_lz","_wp","_hospital","_landend","_wounded","_medic","_destpos","_behav","_speed","_units","_mwp","_callsign","_unit"];
			_unit = _this select 0;
			_callsign = _this select 1;
			if (alive _unit) then 
			{
				//Ensure CASEVAC doesn't engage targets during rescue
				_unit disableAI "TARGET";
				_unit disableAI "AUTOTARGET";
					
				// Set endpos
				if (str (markerPos "hospital") != "[0,0,0]") then { 
					_hospital = [markerpos "hospital", 0, 100, 15, 0, 0, 0,markerpos "hospital"] call BIS_fnc_findSafePos;
				} else {
					_hospital = [markerpos "ammo", 0, 100, 15, 0, 0, 0,markerpos "ammo"] call BIS_fnc_findSafePos;
				};
				
				// Check no players are crew members?
				waitUntil {sleep 5;{isplayer _x} count (crew _unit) == 0};
				(crew _unit) join (createGroup (side (driver _unit)));
				{
					_x setskill 0.8;
				} foreach (units (group _unit));
				
				// Send Casevac to player's position or other location?
				_destpos = [position player, 0, 50, 15, 0, 0, 0, position player] call BIS_fnc_findSafePos;
				_wp = (group _unit) addwaypoint [_destpos,10];
				_wp setWaypointBehaviour RMM_casevac_behav;
				_wp setWaypointSpeed RMM_casevac_speed;
				
				// Check for LZ marker	
				waitUntil {sleep 3;( _unit distance position player <= 600) || !(alive _unit) || damage _unit > 0.3};
				if (alive _unit && damage _unit < 0.3) then {
					_unit sideChat format ["%1 this is Pedro %2. 600 meters out. Over.", group player, _callsign];
					diag_log format ["MSO-%1 CASEVAC: Looking for LZ marker: %2", time, rmm_casevac_marker];
					if (rmm_casevac_marker != "Nothing") then {
						_unit sideChat format ["%1 this is Pedro %3. Mark LZ now with %2. Over.", group player, rmm_casevac_marker, _callsign];
						//Check for LZ marker and land near it - WIP
						// Update _destpos based on location of marker
						// Case statement for each looking for nearestobject
					};
				};
				
				// Setup Heli landing
				_landEnd = "HeliHEmpty" createVehicle _destpos;
				_unit land "GET IN";
					
				// Wait for helicopter landing
				waitUntil {sleep 3;((position _unit) select 2 <= 3) || !(alive _unit) || damage _unit > 0.3};
				
				if (alive _unit && damage _unit < 0.3) then 
				{
					_unit sideChat format ["%1 this is Pedro %2. Touchdown. Over.", group player, _callsign];
					
					// Check for wounded (cannot stand) within 100m
					_wounded = [];
					_units = [_destpos, 100] call mso_core_fnc_getUnitsInArea;
					{
						if (!(canStand _x) && (faction _x == faction player)) then {
							_wounded set [count _wounded, _x];
						};
					} foreach _units;
					
					if (count _wounded > 0) then {_unit sideChat format ["%1 this is Pedro %3. Load the %2 wounded. Over.", group player, count _wounded, _callsign];};
					
					/*
					// Crewman go pickup each wounded person (not already in helicopter) and put in helicopter
					if (count _wounded > 0) then {
						_this sideChat format ["%1 this is Pedro One. I count %2 casualties requiring assistance. Sending one of my crewman to help. Over.", group player, count _wounded];
						if (count crew _this > 1) then {
							_medic = crew _this select 1;
						} else {
							_medic = driver _this;
						};
						
						diag_log format ["MSO-%1 CASEVAC: %2 is the medic", time, typeof _medic];
						
						{ //STILL WIP 
							if !(_x in _this) then {
								doGetOut _medic;
								
								_medic disableAI "TARGET";
								_medic disableAI "AUTOTARGET";
								
								diag_log format ["MSO-%1 CASEVAC: %2 moving to %3", time, typeof _medic, name _x];
								while {((_medic distance _x) > 3) && (alive _medic)} do
								{
									_medic moveTo (position _x);
								};
								
								private ["_pos_th"];
								_pos_th =  _x modelToWorld [0,0,0];

								dostop _medic;
								_medic doMove  [(_pos_th  select 0)-0.5*sin (getDir _x), (_pos_th  select 1)-0.5*cos (getDir _x), _pos_th  select 2];
								
								// Disable wounded player
								[0,_x,{_this playmove "ainjppnemstpsnonwrfldb_still"}] call mso_core_fnc_ExMP;
								sleep 0.1;
					
								// Check wounded
								//_medic playmove "AinvPknlMstpSnonWrflDr_medic4";
								//sleep 15;

								// Carry wounded
								_medic playmove "AcinPercMstpSrasWrflDnon";
								sleep 8;

								//attach wounded unit
								_x attachTo [_medic,  [-0,-0.1,-1.2], "RightShoulder"];
								sleep 0.1;
								
								//orientation
								[0,_x,{_this setdir 180}] call mso_core_fnc_ExMP;
								
								//unconscious unit assumes carrying posture
								[0,_x,{_this playmove "AinjPfalMstpSnonWrflDnon_carried_still"}] call mso_core_fnc_ExMP;
								sleep 0.1;
								
								diag_log format ["MSO-%1 CASEVAC: %2 carrying %3", time, typeof _medic, typeof _x];
												
								// Get medic moving
								_medic playmove "AcinPercMrunSrasWrflDf";
								_medic moveTo (position _this);
								
								diag_log format ["MSO-%1 CASEVAC: %2 moving to %3", time, typeof _medic, typeof _this];
								
								// Get AI to drag/carry wounded to copter
								
								while {((_medic distance _this) > 5) && (alive _medic)} do
								{
									_medic moveTo (position _this);
								};
								
								waitUntil {sleep 3;((_medic distance _this) < 10) || !(alive _medic)};
								//detach
								detach _x;
								detach _medic;

								_medic playaction "released";
								sleep 1;
							
								[0,_x,{_this playaction "agonystart"}] call mso_core_fnc_ExMP;
								sleep 3;
								
								_medic switchmove "";
													
								_x moveInCargo _this;
							};
						} foreach _wounded;
						
						_this sideChat format ["%1 this is Pedro One. Wounded are loaded. Over.", group player];
						
						[_medic] orderGetIn true;
						
					};*/
					
					// Waituntil wounded loaded then give the players 30 seconds to get in helicopter
					if (count _wounded > 0) then {
						waitUntil {sleep 3;{!(_x in _unit)} count _wounded == 0};
						_unit sideChat format ["%1 this is Pedro %2. Wounded now onboard. Over.", group player, _callsign];
					};
					
					if (alive _unit) then {
						_unit sideChat format ["%1 this is Pedro %2. 30 seconds to dustoff. Over.", group player, _callsign];
						sleep 30;
						deleteVehicle _landEnd;
					};
				};
				
				// Return to base
				
				_wp = (group _unit) addwaypoint [_hospital,0];
				_wp setWaypointBehaviour RMM_casevac_behav;
				_wp setWaypointSpeed RMM_casevac_speed;
				RMM_casevac_return = true;
				waitUntil {sleep 3;( _unit distance _hospital <= 600) || !(alive _unit) || damage _unit > 0.3};
				
				// Setup Heli landing
				_landEnd = "HeliHEmpty" createVehicle _hospital;
				_unit land "GET OUT";
				
				waitUntil {sleep 3;((position _unit) select 2 <= 3) || !(alive _unit) || damage _unit > 0.3};
				if (alive _unit && damage _unit < 0.3) then {
					
					_unit sideChat format ["%1 this is Pedro %2. Arrived at Field Hospital. Over.", group player, _callsign];
					
					/*
					// Get Out, carry wounded to hospital
					if (count _wounded > 0) then {
						doGetOut _medic;
						{ //STILL WIP (medic animations/actions don't work)
							if (_x in _this) then {
								doGetOut _x;
								[0,_x,{_this switchmove "ainjppnemstpsnonwrfldb_still"}] call mso_core_fnc_ExMP;
								_medic moveTo position _x;
								waitUntil {sleep 3;(_medic distance _x < 3) || !(alive _medic)};
								_x attachto [_medic, [0.1, 1.01, 0]];
								sleep 0.1;
								//orientation
								[0,_x,{_this setdir 180}] call mso_core_fnc_ExMP;
								_medic moveTo _hospital;
								waitUntil {sleep 3;(_medic distance _hospital < 5) || !(alive _medic)};
								detach _x;
								detach _medic;
							};
						} foreach _wounded;
						[_medic] orderGetIn true;
						
					};*/
				
					// Wait for any players to getout
					waitUntil {sleep 5;{(_x in _unit)} count _wounded == 0};
					_unit sideChat format ["%1 this is Pedro %2. Wounded have been moved to the field hospital. We are RTB. Over.", group player, _callsign];
					waitUntil {sleep 5;{isplayer _x} count (crew _unit) == 0};
					
					deleteVehicle _landEnd;
				};
				
				// Fly away
				(group _unit) addwaypoint [[0,0,0],0];
				waitUntil {sleep 5;( _unit distance player > 1500) || !(alive _unit) || damage _unit > 0.3};
				
				// Check for death of chopper
				if !(alive _unit || damage _unit > 0.3) then {
					hint format ["CASEVAC: PEDRO %1 has crashed!", _callsign];
					diag_log format ["MSO-%2 CASEVAC: %1 has crashed!", typeof _unit, time];
				};
				
				// Delete Chopper
				_unit call CBA_fnc_deleteEntity;
				RMM_casevac_active = false;
			};
		};
	}] call mso_core_fnc_ExMP;
	
} else {
	[] spawn {
		sleep (5+(random 5));
		PAPABEAR sideChat format ["%1 this is PAPA BEAR. Request Not-Authorised. Sorry guys, we're real busy, try later. Over.", group player]; 
	};
    
};