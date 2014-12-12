//init
//call PXS_showInterface;

//set distance
PXS_ViewDistance = viewDistance;
setViewDistance 10000;

//create camera of satellite view
PXS_ConsoleCamera = "camera" camcreate [0,0,0];
PXS_ConsoleCamera cameraEffect ["internal","back"];

//show interface
showCinemaBorder false;
[2] call PXS_adjustCamera;
createDialog "PXS_RscSatellite";

nil;