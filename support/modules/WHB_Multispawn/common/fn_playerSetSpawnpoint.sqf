/* ----------------------------------------------------------------------------
Function: MSO_fnc_playerSetSpawnpoint

Description:
Sets the HQ object as the player's respawn location.

Parameters:
- None

Returns:
- Array of Error/Success Strings

Examples:
(begin example)
[_fobHQ] call MSO_fnc_playerSetSpawnpoint; 
(end)

See Also:
- <MSO_fnc_playerRespawn>

Author:
WobbleyheadedBob aka CptNoPants
---------------------------------------------------------------------------- */

// State No. 0 - Mobile/Undeployed
// State No. 1 - Deployed
// State No. 2 - Deploying
// State No. 3 - Undeploying/Packing up

private ["_fobHQ","_fobState","_returnMessage"];
_fobHQ = _this select 0;
_fobState = _fobHQ getVariable "MHQState";
_returnMessage = [];

// DEBUG - Check for null stateVariable
if (isNil "_fobState") exitWith
{
	_returnMessage = ["MHQState is null..."];
	_returnMessage;
};

switch (_fobState) do
{
//-------------------------------------------------------------------------------------------------
	case 0: // State No. 0 - Mobile/Undeployed
	{
		_returnMessage = ["You need to deploy the MHQ first!"];
	};
	
	case 1: // State No. 1 - Deployed
	{
		player setVariable ["playerRespawnPoint", _fobHQ, false];
		_returnMessage = ["You will spawn here if KIA"];
	};
	
	case 2: // State No. 2 - Deploying
	{
		_returnMessage = ["MHQ is currently deploying! You cannot Sign-in here until it has finnished setting up."];
	};
		
	case 3: // State No. 3 - Undeploying/Packing up
	{
		_returnMessage = ["MHQ is currently packing up, you cannot Sign-in here!"];
	};
	
	Default 
	{
		_returnMessage = ["Unrecognised MHQState"];
	};
};

_returnMessage