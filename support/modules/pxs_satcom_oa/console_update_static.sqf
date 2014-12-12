//init
//[camPrepareTarget, camPreparePos, Zoom] call PXS_cameraStatic;
//camPrepareTarget = [0,0,0] ; camPreparePos [0,0,0]
//Zoom = camPrepareFOV

private ["_lon","_lat","_zoom","_cpt","_cpp","_fov"];

_cpt = _this select 0;
_cpp = _this select 1;
_fov = _this select 2;

//update camera
PXS_ConsoleCamera camPrepareTarget _cpt;
PXS_ConsoleCamera camPreparePos [(_cpp select 0), (_cpp select 1), 500];
PXS_ConsoleCamera camPrepareFOV _fov;
PXS_ConsoleCamera camCommitPrepared 0;

//update coordinates
_lon = _cpp select 0;
_lat = _cpp select 1;
_zoom = 3.94 / _fov;

PXS_consoleLON = _lon;
PXS_consoleLAT = _lat;
PXS_consoleZOM = _zoom;

ctrlSetText [1003,format ["LON  %1",(round (10 * (_lon)))/10]];
ctrlSetText [1002,format ["LAT  %1",(round (10 * (_lat)))/10]];
ctrlSetText [1004,format ["ZOOM %1",(round (100 * (_zoom)))/100]];

nil;