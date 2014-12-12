/* ----------------------------------------------------------------------------
Function: MSO_fnc_DeployHQ

Description:
Deploys the vehicle into a static structure that allows players to choose to spawn there when they die.

Parameters:
- An MHQ object to be turned into an HQ [Object]

Returns:
- Array of Error/Success Strings

Examples:
(begin example)
[mhqObject] call MSO_fnc_deployHQ; 
(end)

See Also:
- <MSO_fnc_undeployHQ>

Author:
WobbleyheadedBob aka CptNoPants
---------------------------------------------------------------------------- */

// State No. 0 - Mobile/Undeployed
// State No. 1 - Deployed
// State No. 2 - Deploying
// State No. 3 - Undeploying/Packing up

private ["_mhq","_locationHQ","_vectorHQ","_camotype","_camo","_returnMessage","_validSpeed","_validLocation","_isEmpty","_mhqState"];

_mhq = _this select 0;
_mhqState = _mhq getVariable "MHQState";
_returnMessage = [];

// DEBUG - Check for null stateVariable
if (isNil "_mhqState") exitWith
{
	_returnMessage = ["MHQState is null..."];
	_returnMessage;
};

switch (_mhqState) do
{
	case 0: // State No. 0 - Mobile/Undeployed
	{
		// Check that MHQ is NOT moving
		if (speed _mhq > 0) then {
			_validSpeed = false;
			_returnMessage set [count _returnMessage, "MHQ must be stationary to deploy!"];
		} else {
			_validSpeed = true;
		};

		// Check MHQ is NOT on the Water
		_locationHQ = position _mhq;
		if (surfaceIsWater _locationHQ) then {
			_validLocation = false;
			_returnMessage set [count _returnMessage, "You cannot setup an HQ in the water!"];
		} else {
			_validLocation = true;
		};

		//Check MHQ is Empty
		if (count (crew _mhq) > 0) then {
			_isEmpty = false;
			_returnMessage set [count _returnMessage,"All crew must exit the vehicle first!"];
		} else {
			_isEmpty = true;
		};

		// Check validation and perfom required actions if it passes.
		if (_validSpeed && _validLocation && _isEmpty) then {
			//Empty the fuel & Set state to deploying
			_mhq setVariable ["MHQState", 2, true];
			_mhq setFuel 0;
			_vectorHQ = vectorUp _mhq;
			
			if (side player == WEST) then {
				_camotype = "Land_CamoNetB_NATO";
			} else {
				_camotype = "Land_CamoNetB_EAST";
			};
			
			//Create the Cammo Net
			_camo = createVehicle [_camotype, [0,0,0], [], 0, "NONE"];
			_camo setDir direction _mhq;
			_camo setVectorUp _vectorHQ;
			_camo setPos _locationHQ;
			_camo allowDamage false;
			_mhq setVariable ["camo", _camo, true];
			
			_returnMessage = ["Setting up FOB HQ now..."];
			
			//Use createFOB locally if you're a hosting player else, use PV service bus
			if (isServer) then {
				[_mhq] spawn 
				{
					private ["_mhq"];
					_mhq = _this select 0;
					[_mhq] call fn_createFOB;
				};
			} else {
				PV_server_syncHQState = [2, _mhq];
				publicvariable "PV_server_syncHQState";
			};
		};
	};
	//-------------------------------------------------------------------------------------------------
	case 1: // State No. 1 - Deployed
	{
		_returnMessage = ["MHQ is already deployed!"];
	};
	//-------------------------------------------------------------------------------------------------
	case 2: // State No. 2 - Deploying
	{
		_returnMessage = ["MHQ is already deploying!"];
	};
	//-------------------------------------------------------------------------------------------------
	case 3: // State No. 3 - Undeploying/Packing up
	{
		_returnMessage = ["MHQ is currently packing up, you cannot start deployment yet!"];
	};
	//-------------------------------------------------------------------------------------------------
	Default 
	{
		_returnMessage = ["Unrecognised MHQState"];
	};
};

_returnMessage