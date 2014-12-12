PXS_SatelliteActive = true;

//set view distance
PXS_ViewDistance = viewDistance;
setViewDistance 10000;

//view dialog interference
PXS_SatelliteDialog = createDialog "PXS_RscSatellite";

//start functions
[] spawn PXS_keyMain;
[] spawn PXS_timeView;
[] spawn PXS_coordinatesView;

//start view satellite
PXS_SatelliteCamera = "camera" camCreate [0,0,0];
PXS_SatelliteCamera cameraEffect ["internal","back"];
call PXS_updateCamera;

showCinemaBorder false;

ppEffectDestroy PXS_ppColor;
ppEffectDestroy PXS_ppInversion;
ppEffectDestroy PXS_ppGrain;

PXS_ppGrain = ppEffectCreate ["filmGrain",2005];
PXS_ppGrain ppEffectEnable true;
PXS_ppGrain ppEffectAdjust [0.02,1,1,0,1];
PXS_ppGrain ppEffectCommit 0;

nil;