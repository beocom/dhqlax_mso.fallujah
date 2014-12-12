//init variables
PXS_SatelliteInitialHeight = 500;
PXS_SatelliteFOV = 0.2;
PXS_SatelliteZoom = 19.7;
PXS_SatelliteNorthMovementDelta = 0;
PXS_SatelliteSouthMovementDelta = 0;
PXS_SatelliteEastMovementDelta = 0;
PXS_SatelliteWestMovementDelta = 0;
PXS_ViewDistance = 0;

onMapSingleClick
{
	PXS_SatelliteTarget = "Logic" createVehicleLocal _pos;//PXS_SATCOM_Logic
	PXS_SatelliteTarget setDir 0;
	call PXS_viewSatellite;
};
hint localize "STR_PXS_HINT";
openMap true;