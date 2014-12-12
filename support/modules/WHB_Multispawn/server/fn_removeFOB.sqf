/* ----------------------------------------------------------------------------
Function: MSO_fnc_createFOB

Description:
Serverside call to turn a mobile vehicle into a static FOB
Should to be done Server-side just in case the client machine disconnects or crashes during the parameter defined delay.


Parameters:
- A vehicle object to be turned into an FOB [Object]

Returns:
Nothing

Examples:
(begin example)
// reassign objects to nearest cluster
[_mhqVehicle]  call MSO_fnc_createFOB;
(end)

See Also:
- <MSO_fnc_createFOB>

Author:
WobbleyheadedBob aka CptNoPants
---------------------------------------------------------------------------- */


private ["_fobHQ","_mhq","_mhqType","_locationHQ","_vectorHQ","_directionHQ"];
_fobHQ = _this select 0;
_locationHQ = position _fobHQ;
_vectorHQ = vectorUp _fobHQ;
_directionHQ = direction _fobHQ;
_mhqType = [_fobHQ] call MSO_fnc_getMHQType;

#ifdef RMM_JIPMARKERS
private ["_mkr"];
_mkr = _fobHQ getVariable "MHQ_jipmarker";
#endif

//Wait a while...
sleep undeployment_Time;

//Delete the FOBHQ and Remove from the list of active HQs
PV_hqArray = PV_hqArray - [_fobHQ];
deleteVehicle _fobHQ;

if (jipMarkers_enabled == 1) then
{
	RMM_jipmarkers = RMM_jipmarkers - [_mkr];
	deleteMarker _mkr;
	publicvariable "RMM_jipmarkers";
};

//Create new MHQ
_mhq = createVehicle [_mhqType, [0,0,0], [], 0, "NONE"];
_mhq setDir _directionHQ;
_mhq setVectorUp _vectorHQ;
_mhq setPos _locationHQ;
_mhq setVariable ["MHQState", 0, true];

//Add the new MHQ to the list of active HQ's and broadcast the PV
PV_hqArray set [count PV_hqArray, _mhq];
publicvariable "PV_hqArray";

//Broadcast the returnMessage and fn_addAction_HQ to all other clients
PV_client_syncHQState = [0, _mhq];
publicVariable "PV_client_syncHQState";

if !isDedicated then 
{
	[0, _mhq] call fn_client_syncHQState;
};