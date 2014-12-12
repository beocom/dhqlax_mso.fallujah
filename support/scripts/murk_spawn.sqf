//    File: murk_spawn.sqf
//	Function: To allow for simple trigger based spawning using editor placed units and waypoints.
//		    The script deletes all units when the mission start and the recreate them on command.
//    Parameters: 
//			_this select 0: OBJECT - unit name (this) 
//			_this select 1: OBJECT - trigger name
//			_this select 2: STRING - spawn type ("once","repeated","wave" and "reset")
//			_this select 3 (optional): NUMBER - spawn lives (the amount of time the unit respawns, or wave number)
//			_this select 4 (optional): NUMBER - spawn delay
//			_this select 5 (optional): STRING - init string called for the leader of the group
//			_this select 6 (optional): NUMBER - delay before body removal
//			_this select 7 (optional): NUMBER - probability of presence for the unit to actually spawn using the script. The in-game editor prob of presence appears to not work with the script in its current form. Only applies to the 'once' spawn type at the moment.
//	
//	Usage: 
//		Example trigger: Anybody Once (or whatever you want), onActivation: this setVariable ["murk_spawn",true,true];
//		Unit (leader of group):	nul = [this,triggername,"once"] exec "murk_spawn.sqf"; 
//		init.sqf: triggername setVariable ["murk_spawn",false,false]; 
//

// V5c (c for chappy)
// Added parameter (_this select 7) for probability of presence. Currently only done for the 'once' method of the script. As i figure if people want waves and repeats they probably want the unit to spawn in the first place every time. 
// V5
// - Change: Removed group and function scripts, everything done in a single file
// - Change: Spawn trigger variable is now a setVariable of the trigger instead of a global variable
// - Add: Option to enable removal of dead units, eventhandler attached to everyone spawning
// - Fix: Should now work in multiplayer on a dedicated server (only tested on a local dedicated/join setup however)
// - Fix: Performance issues with helos from V4 resolved, was a mistake on the example mission and not the script
// - Fix: Some minor bugs with the optional parameters
// - Fix: Now properly support crews in turrets-on-turrets (had to bring in some BIS made functions)
// V4
// - Change: No longer requires the BIS functions module
// - Add (again): Like V2, it saves the weapons and magazines and restore them
// - Fix: squad leader init is now fired after the creation of the entire group, can manipulate squad members with init
// - Change: Removed the external paradrop script, its down with a [] spawn in the waypoint. Just trying out different things :)
// V3
// - See older versions

// This script is serverside
if(!isServer) exitWith {};

// -------------------  Init  ----------------------- //
_bodyRemovalTime = 400;
_bodyRemoval = false;
_spawnLives = 1;
_spawnDelay = 0.1;
_waitingPeriod = 1; // Change this for the default waiting period
_resetPeriod = 1; // Change this for the reset mode paus
_initString = "";
_countThis = count _this;
_unitprob = 10;

// ----------------  Parameters  -------------------- //
_unit = _this select 0;
_trigger = _this select 1;
_spawntype = _this select 2;
if (_countThis >= 4) then { _spawnlives = _this select 3; }; // Optional
if (_countThis >= 5) then { _spawndelay = _this select 4; }; // Optional
if (_countThis >= 6) then { _initString = _this select 5; }; // Optional
if (_countThis >= 7) then { _bodyRemovalTime = _this select 6; _bodyRemoval = true; }; // Optional
if (_countThis >= 8) then { _unitprob = _this select 7; }; // Optional

// --  Delete the unit (this is always done ASAP)  -- //

// Check if its a vehicle
_vehicle = false;
if (_unit isKindOf "LandVehicle" OR _unit isKindOf "Air") then { _vehicle = true; };

// Unit information arrays
_unitPosArray = [];
_unitTypeArray = [];
_unitSkillArray = [];
_unitNameArray = [];
_unitRankArray = [];
_unitMagArray = [];
_unitWeaponArray = [];
_unitCrew = [];
_unitsInGroupAdd = [];
_unitGroup = group _unit;
_unitsInGroup = units _unitGroup;
_unitOrigDir = getDir _unit;

// Save the vehicle types, positions and skills for the group
if (_vehicle) then { 
	{
		_vcl = vehicle _x;
		if (!(_vcl in _unitsInGroupAdd) AND (typeOf _vcl != "")) then {
			_crew = crew _vcl;
			_unitCrewTemp = [];
			{ _unitCrewTemp set [count _unitCrewTemp, typeOf _x]; } forEach _crew;
			_unitCrew set [count _unitCrew, _unitCrewTemp];
			_unitTypeArray set [count _unitTypeArray, typeOf _vcl]; 
			_unitPosArray set [count _unitPosArray, getPos _vcl];
			_unitSkillArray set [count _unitSkillArray, skill _vcl];
			_unitNameArray set [count _unitNameArray, vehiclevarName _vcl];
			_unitRankArray set [count _unitRankArray, rank _vcl];
			_unitsInGroupAdd set [count _unitsInGroupAdd, _vcl];
			_unitMagArray set [count _unitMagArray, magazines _vcl];
			_unitWeaponArray set [count _unitWeaponArray, weapons _vcl];
			{ // Delete the crew and vehicle
				deleteVehicle _x;
			} forEach _crew;
			deleteVehicle _vcl;
		};
		sleep 0.01; // Need this or it all f**k up
	} forEach _unitsInGroup;
}
// Save the infantry types, etc
else { 
	{
		_unitTypeArray set [count _unitTypeArray, typeOf _x]; 
		_unitPosArray set [count _unitPosArray, getPos _x];
		_unitSkillArray set [count _unitSkillArray, skill _x];
		_unitNameArray set [count _unitNameArray, vehiclevarName _x];
		_unitRankArray set [count _unitRankArray, rank _x];
		_unitMagArray set [count _unitMagArray, magazines _x];
		_unitWeaponArray set [count _unitWeaponArray, weapons _x];
		deleteVehicle _x;
		sleep 0.01; // Same as with vehicles
	} forEach _unitsInGroup;
};

// -----------------  Functions  -------------------- //

// *WARNING* BIS FUNCTION RIPOFF - Taken from fn_returnConfigEntry as its needed for turrets and shortened a bit
_fnc_returnConfigEntry = {
	private ["_config", "_entryName","_entry", "_value"];
	_config = _this select 0;
	_entryName = _this select 1;
	_entry = _config >> _entryName;

	//If the entry is not found and we are not yet at the config root, explore the class' parent.
	if (((configName (_config >> _entryName)) == "") && (!((configName _config) in ["CfgVehicles", "CfgWeapons", ""]))) then {
		[inheritsFrom _config, _entryName] call _fnc_returnConfigEntry;
	}
	else { if (isNumber _entry) then { _value = getNumber _entry; } else { if (isText _entry) then { _value = getText _entry; }; }; };
	//Make sure returning 'nil' works.
	if (isNil "_value") exitWith {nil};
	_value;
};

// *WARNING* BIS FUNCTION RIPOFF - Taken from fn_fnc_returnVehicleTurrets and shortened a bit
_fnc_returnVehicleTurrets = {
	private ["_entry","_turrets", "_turretIndex"];
	_entry = _this select 0;
	_turrets = [];
	_turretIndex = 0;

	//Explore all turrets and sub-turrets recursively.
	for "_i" from 0 to ((count _entry) - 1) do {
		private ["_subEntry"];
		_subEntry = _entry select _i;
	
		if (isClass _subEntry) then {
			private ["_hasGunner"];
			_hasGunner = [_subEntry, "hasGunner"] call _fnc_returnConfigEntry;
			//Make sure the entry was found.
			if (!(isNil "_hasGunner")) then {
				if (_hasGunner == 1) then {
					_turrets set [count _turrets, _turretIndex];		
					//Include sub-turrets, if present.
					if (isClass (_subEntry >> "Turrets")) then { _turrets set [count _turrets, [_subEntry >> "Turrets"] call _fnc_returnVehicleTurrets]; } 
					else { _turrets set [count _turrets, []]; };
				};
			};
			_turretIndex = _turretIndex + 1;
		};
	};
	_turrets;
};

// Eventhandler for removal of dead units
_fnc_removeBodyEH = { 
	(_this select 0) addEventHandler ["killed", {
		[_this select 0] spawn { 
			_unit = _this select 0;
			_origPos = getPos _unit;
			_z = _origPos select 2;
			_desiredPosZ = (_origPos select 2) - 3;
			if (_unit iskindOf "Man") then { _desiredPosZ = (_origPos select 2) - 0.6; }; // Dont need to sink so far if its infantry
			_sleep = _unit getVariable "murk_bodyremovaltime";
			sleep _sleep; 
			if ( vehicle _unit == _unit) then {
				_unit enableSimulation false;
				while { _z > _desiredPosZ } do { 
					_z = _z - 0.01;
					_unit setPos [_origPos select 0, _origPos select 1, _z];
					sleep 0.1;
				};
			};
			deleteVehicle _unit; 
		};
	} ]; };

// This is spawned as an independant function if wave or reset mode is used
_fnc_deleteGroup = {
	
	_group = _this select 0;
	_unitsGroup = units _group; 
	while { ({alive _x} count _unitsGroup) > 0 } do { sleep 5; };
	deleteGroup _group;
};

// This function spawns/respawns the unit
_fnc_spawnUnit = {
	
	// We need to pass the old group so we can copy waypoints from it, the rest we already know
	_oldGroup = _this select 0;
	
	_newGroup = createGroup (side _oldGroup);
	_newGroup copyWaypoints _oldGroup;

	// Since "wave" and "reset" mode may still have the old unit alive, we cannot delete their group directly
	if (_spawnType == "once" OR _spawnType == "repeated") then { deleteGroup _oldGroup; }
	else { [_oldGroup] spawn _fnc_deleteGroup; };

	if (_vehicle) then {
		
		for [{ _loop = 0 },{ _loop < count _unitTypeArray},{ _loop = _loop + 1}] do {
			_spawnUnit = Object;
			if ((_unitPosArray select _loop) select 2 >= 10) then { 
				_spawnUnit = createVehicle [(_unitTypeArray select _loop),(_unitPosArray select _loop), [], 0, "FLY"]; 
				
				//Set a good velocity in the correct direction (taken from BIS functions)
				_spawnUnit setVelocity [50 * (sin _unitOrigDir), 50 * (cos _unitOrigDir), 0];
			}
			else { _spawnUnit = (_unitTypeArray select _loop) createVehicle (_unitPosArray select _loop); }; 
			_spawnUnit setDir _unitOrigdir;
			_seatLoop = 0;
			
			// Need a little sleep or units may spawn on top of the vehicle
			sleep 0.1;
	      
	      	_crew = [];

	      	// Create the entire crew
	      	{ _unit = _newGroup createUnit [_x,(_unitPosArray select _loop), [], 0, "NONE"]; _crew set [count _crew, _unit]; } forEach (_unitCrew select _loop);
	      	
	      	// We assume that all vehicles have a driver, the first one of the crew
	      	(_crew select 0) moveInDriver _spawnUnit; _currentCrewMember = 1;
	      
     	      	// Count the turrets	      	
	      	_entry = configFile >> "CfgVehicles" >> (_unitTypeArray select _loop);
	      	_turrets = [_entry >> "turrets"] call _fnc_returnVehicleTurrets;
	      
	      	// Move the rest of the crew into turrets
	      	_funcMoveInTurrets = {	
	      		private ["_turrets","_path","_i"];
				_turrets = _this select 0;
				_path = _this select 1;
	      		_i = 0;
	      
	      		while {_i < (count _turrets)} do { 
	      			_turretIndex = _turrets select _i;
					_thisTurret = _path + [_turretIndex];
					//Move unit into turret, if empty.
					if (isNull (_spawnUnit turretUnit _thisTurret)) then { 
						(_crew select _currentCrewMember) moveInTurret [_spawnUnit, _thisTurret]; _currentCrewMember = _currentCrewMember + 1;
					};
					//Spawn units into subturrets.
					[_turrets select (_i + 1), _thisTurret] call _funcMoveInTurrets;
					_i = _i + 2;
				};
			};
			
			[_turrets, []] call _funcMoveInTurrets;
	      	
		     	_newGroup addVehicle _spawnUnit;
	      
			_spawnUnit setSkill (_unitSkillArray select _loop);
			_spawnUnit setUnitRank (_unitRankArray select _loop);
		
			// Set the unit name
			if (_spawntype == "once" OR _spawntype == "repeated") then { 
				_spawnUnit setVehicleVarName (_unitNameArray select _loop);
				if (vehiclevarname _spawnUnit != "") then { _spawnUnit setVehicleInit format["%1=this;",_unitNameArray select _loop]; processInitCommands; };
			};
			
			// Add dead body removal eventhandler
			if (_bodyRemoval) then { 
				_spawnUnit setVariable ["murk_bodyRemovalTime", _bodyRemovalTime, false]; nul = [_spawnUnit] call _fnc_removeBodyEH;
				{ _x setVariable ["murk_bodyRemovalTime", _bodyRemovalTime, false]; nul = [_x] call _fnc_removeBodyEH; } forEach _crew;
			};
		};
	}
	else {	
		for [{ _loop = 0 },{ _loop < count _unitTypeArray},{ _loop = _loop + 1}] do {
			(_unitTypeArray select _loop) createUnit [_unitPosArray select _loop,_newGroup];
		
			_unitsGroup = units _newGroup;
			_spawnUnit = (_unitsGroup select _loop); // We know that the current unit being worked on is the latest unit added to the group
			if (_spawnUnit == leader _newGroup) then { _spawnUnit setDir _unitOrigDir };
			_spawnUnit setSkill (_unitSkillArray select _loop);
			_spawnUnit setRank (_unitRankArray select _loop);
			removeAllWeapons _spawnUnit;
			{_spawnUnit removeMagazine _x} forEach magazines _spawnUnit;
			removeAllItems _spawnUnit;
			{_spawnUnit addMagazine _x} forEach (_unitMagArray select _loop);
			{_spawnUnit addWeapon _x} forEach (_unitWeaponArray select _loop);
			_spawnUnit selectWeapon (primaryWeapon _spawnUnit);
			sleep 0.1;
		
			// Set the unit name
			if (_spawntype == "once" OR _spawntype == "repeated") then { 
				_spawnUnit setVehicleVarName (_unitNameArray select _loop);
				if (vehiclevarname _spawnUnit != "") then { _spawnUnit setVehicleInit format["%1=this;",_unitNameArray select _loop]; processInitCommands; };
			};
			
			// Add dead body removal eventhandler
			if (_bodyRemoval) then { _spawnUnit setVariable ["murk_bodyRemovalTime", _bodyRemovalTime, false]; nul = [_spawnUnit] call _fnc_removeBodyEH; };
		};
	};

	// setting the leaders init
	(vehicle (leader _newGroup)) setVehicleInit _initString; processInitCommands;
	
	// Have to return the new group
	_newGroup;
}; 

// --------------  Waiting period  ------------------ //
while { !(_trigger getVariable "murk_spawn") } do { sleep _waitingPeriod; };






// ---------------  Spawn Modes  ------------------- //
// REPEAT MODE, ie basic respawn based on lives
if (_spawntype == "repeated") then {
	while { _spawnlives > 0 } do {
		_unitGroup = [_unitGroup] call _fnc_spawnUnit;
		_spawnLives = _spawnLives - 1;
		_unitsGroup = units _unitGroup;	
		while { ({alive _x} count _unitsGroup) > 0 } do { sleep 2; };
		sleep _spawndelay;
	};
};

// WAVE MODE, this is fairly simple, just sleep a while then respawn. Spawnlives in this case is number of waves
if (_spawntype == "wave") then {
	while { _spawnlives > 0 } do {
		_unitGroup = [_unitGroup] call _fnc_spawnUnit;
		_spawnLives = _spawnLives - 1;
		sleep _spawndelay;
	};
};

// RESET MODE, sleep a while then set the variable to false (even if you set it like 50 times over). Spawn lives is used to tick how many times its possible to reset.
//probability of presence by chappy.
// Allows the player to incorporate a probability of presence in the array to the 
//script as _this select 7. Default value is 10 ie 100% presence. //Effective values are currently 1, 2, 3/4 , 5+. 
//This calculates //spawns based on the most common probabilities people like to //use.


if (_spawntype == "reset") then 
{
	
	
	while { _spawnlives > 0 } do 
	{
		
			if (_unitprob == 10) then 
			{
			_unitGroup = [_unitGroup] call _fnc_spawnUnit;
			_spawnLives = _spawnLives - 1;
			sleep _resetPeriod;
			_trigger setVariable ["murk_spawn",false,false];
			while { !(_trigger getVariable "murk_spawn") } do { sleep _waitingPeriod; };
		
			};
	
			if (_unitprob != 10) then 
			{
				
				if (_unitprob >= 5) then
				{

					_rnumber = floor(random 2);
	


					if (_rnumber == 0) then 
					{ 
						_unitGroup = [_unitGroup] call _fnc_spawnUnit;
						_spawnLives = _spawnLives - 1;
						sleep _resetPeriod;
						_trigger setVariable ["murk_spawn",false,false];
						while { !(_trigger getVariable "murk_spawn") } do { sleep _waitingPeriod; };
					};
				};
				
				if ((_unitprob == 3) || (_unitprob == 4)) then
				{
		
					_rnumber = floor(random 3);
		
					if (_rnumber == 0) then 
					{ 
						_unitGroup = [_unitGroup] call _fnc_spawnUnit;
						_spawnLives = _spawnLives - 1;
						sleep _resetPeriod;
						_trigger setVariable ["murk_spawn",false,false];
						while { !(_trigger getVariable "murk_spawn") } do { sleep _waitingPeriod; };					
					};

				};
				
				if (_unitprob == 2) then
				{
		
					_rnumber = floor(random 5);
	
					if (_rnumber == 0) then 
					{ 
						_unitGroup = [_unitGroup] call _fnc_spawnUnit;
						_spawnLives = _spawnLives - 1;
						sleep _resetPeriod;
						_trigger setVariable ["murk_spawn",false,false];
						while { !(_trigger getVariable "murk_spawn") } do { sleep _waitingPeriod; };		
					};

				};
				if (_unitprob == 1) then
				{
		
					_rnumber = floor(random 10);

					if (_rnumber == 0) then 
					{ 
						_unitGroup = [_unitGroup] call _fnc_spawnUnit;
						_spawnLives = _spawnLives - 1;
						sleep _resetPeriod;
						_trigger setVariable ["murk_spawn",false,false];
						while { !(_trigger getVariable "murk_spawn") } do { sleep _waitingPeriod; };					};

					};	
				};
		};
};

// ONCE MODE  
//-----------Probability of Presence (by chappy)---------//
// Allows the player to incorporate a probability of presence in the array to the 
//script as _this select 7. Default value is 10 ie 100% presence. //Effective values are currently 1, 2, 3/4 , 5+. 
//This calculates //spawns based on the most common probabilities people like to //use.
 
if (_spawntype == "once") then 
{


if (_unitprob == 10) then 
	{
	
	_unitGroup = [_unitGroup] call _fnc_spawnUnit; 
	};

	if (_unitprob != 10) then 
	{



	if (_unitprob >= 5) then
		{

		_rnumber = floor(random 2);
	


		if (_rnumber == 0) then 
			{ 
			_unitGroup = [_unitGroup] call _fnc_spawnUnit; 
			};
		};
	if ((_unitprob == 3) || (_unitprob == 4)) then
		{
		
		_rnumber = floor(random 3);
		
		if (_rnumber == 0) then 
			{ 
			_unitGroup = [_unitGroup] call _fnc_spawnUnit; 
			};

		};
	if (_unitprob == 2) then
		{
		
		_rnumber = floor(random 5);
	
		if (_rnumber == 0) then 
			{ 
			_unitGroup = [_unitGroup] call _fnc_spawnUnit; 
			};

		};
	if (_unitprob == 1) then
		{
		
		_rnumber = floor(random 10);

		if (_rnumber == 0) then 
			{ 
			_unitGroup = [_unitGroup] call _fnc_spawnUnit; 
			};

		};	


	};
};

