/* ----------------------------------------------------------------------------
Function: MSO_fnc_undeployHQ

Description:
Packs the static structure up back into a mobile vehicle.

Parameters:
- An HQ object to be turned into an MHQ [Object]

Returns:
- Array of Error/Success Strings

Examples:
(begin example)
[hqObject] call MSO_fnc_undeployHQ;
(end)

See Also:
- <MSO_fnc_deployHQ>

Author:
WobbleyheadedBob aka CptNoPants
---------------------------------------------------------------------------- */

// State No. 0 - Mobile/Undeployed
// State No. 1 - Deployed
// State No. 2 - Deploying
// State No. 3 - Undeploying/Packing up

private ["_fobHQ","_returnMessage","_fobHQState"];

_fobHQ = _this select 0;
_fobHQState = _fobHQ getVariable "MHQState";
_returnMessage = [];

// DEBUG - Check for null stateVariable
if (isNil "_fobHQState") exitWith
{
	_returnMessage = ["MHQState is null..."];
	_returnMessage;
};

switch (_fobHQState) do
{
	case 0: // State No. 0 - Mobile/Undeployed
	{
		_returnMessage = ["MHQ is already Mobile!"];
	};
	//-------------------------------------------------------------------------------------------------
	case 1: // State No. 1 - Deployed
	{
		//Set state to packing up 
		_fobHQ setVariable ["MHQState", 3, true];
		_returnMessage = ["Packing up FOB HQ now..."];
		
		//Use createFOB locally if you're a hosting player else, use PV service bus
		if isServer then {
			[_fobHQ] spawn 
			{
				private ["_fobHQ"];
				_fobHQ = _this select 0;
				[_fobHQ] call fn_removeFOB;
			};
		} else {
			PV_server_syncHQState = [3, _fobHQ];
			publicvariable "PV_server_syncHQState";
		};
	};
	//-------------------------------------------------------------------------------------------------
	case 2: // State No. 2 - Deploying
	{
		_returnMessage = ["MHQ is currently deploying!"];
	};
	//-------------------------------------------------------------------------------------------------
	case 3: // State No. 3 - Undeploying/Packing up
	{
		_returnMessage = ["MHQ is already packing up!"];
	};
	//-------------------------------------------------------------------------------------------------
	Default 
	{
		_returnMessage = ["Unrecognised MHQState"];
	};
};

_returnMessage