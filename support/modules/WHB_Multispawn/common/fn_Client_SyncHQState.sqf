// Determine what actions to take based on changes to PV_client_syncHQState
// Author: WobbleyheadedBob aka CptNoPants

private ["_mhqState","_mhqObject"];
_mhqState = _this select 0;
_mhqObject = _this select 1;

switch (_mhqState) do
{
	case 0: // State No. 0 - Mobile/Undeployed
	{
		PV_client_syncHQState = [99, ""];
		[_mhqObject] call fn_addAction_HQ;
		player sideChat format ["FOB has been packed up."];
	};
	//-------------------------------------------------------------------------------------------------
	case 1: // State No. 1 - Deployed
	{
		PV_client_syncHQState = [99, ""];
		[_mhqObject] call fn_addAction_HQ;
		player sideChat format ["FOB has been deployed."];
	};
	//-------------------------------------------------------------------------------------------------
	case 2: // State No. 2 - Deploying
	{
		PV_client_syncHQState = [99, ""];
		player sideChat format ["State 2 has started on PV_client_syncHQState"];
	};
	//-------------------------------------------------------------------------------------------------
	case 3: // State No. 3 - Undeploying/Packing up
	{
		PV_client_syncHQState = [99, ""];
		player sideChat format ["State 3 has started on PV_client_syncHQState"];
	};
	//-------------------------------------------------------------------------------------------------
	Default 
	{
		PV_client_syncHQState = [99, ""];
	};
};