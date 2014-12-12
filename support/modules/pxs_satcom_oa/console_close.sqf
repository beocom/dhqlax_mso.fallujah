//init
//call PXS_cameraTerminate;

//return distance
setViewDistance PXS_ViewDistance;

//terminate camera
[1] call PXS_adjustCamera;

PXS_ConsoleCamera cameraEffect ["terminate","back"];
camDestroy PXS_ConsoleCamera;

//terminate interface
closeDialog 1000;

nil;