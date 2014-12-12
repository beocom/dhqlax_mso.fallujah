//init
//[camPrepareTarget, camPreparePos, Zoom, Time] call PXS_cameraDynamic;
//camPrepareTarget = [0,0,0] ; camPreparePos [0,0,0]
//Zoom = camPrepareFOV
//Time = duration of the move camera

private ["_lon","_lat","_zoom","_countLON","_countLAT","_countZOM","_time","_countTime","_cpt","_cpp","_fov"];

_cpt = _this select 0;
_cpp = _this select 1;
_fov = _this select 2;
_time = _this select 3;

//update camera
PXS_ConsoleCamera camPrepareTarget _cpt;
PXS_ConsoleCamera camPreparePos [(_cpp select 0), (_cpp select 1), 500];
PXS_ConsoleCamera camPrepareFOV _fov;
PXS_ConsoleCamera camCommitPrepared _time;

//update coordinates
_lon = _cpp select 0;
_lat = _cpp select 1;
_zoom = 3.94 / _fov;

//transform time to points
_time = (_time * PXS_consoleFACTOR);

PXS_consoleLONold = PXS_consoleLON;
PXS_consoleLATold = PXS_consoleLAT;
PXS_consoleZOMold = PXS_consoleZOM;
	
PXS_consoleLON = _lon;
PXS_consoleLAT = _lat;
PXS_consoleZOM = _zoom;
	
_countLON = PXS_consoleLONold - PXS_consoleLON;
_countLAT = PXS_consoleLATold - PXS_consoleLAT;
_countZOM = PXS_consoleZOMold - PXS_consoleZOM;
	
//LON
if (_countLON > 0) then {
		
		_countTime = _countLON / _time;
		nul = ["lon-",PXS_consoleLONold,_time,_countTime] execVM "support\modules\pxs_satcom_oa\console_coordinates_count.sqf";
		
};
	
if (_countLON < 0) then {
		
		_countTime = (abs _countLON) / _time;
		nul = ["lon+",PXS_consoleLONold,_time,_countTime] execVM "support\modules\pxs_satcom_oa\console_coordinates_count.sqf";
		
};
	
//LAT
if (_countLAT > 0) then {
		
		_countTime = _countLAT / _time;
		nul = ["lat-",PXS_consoleLATold,_time,_countTime] execVM "support\modules\pxs_satcom_oa\console_coordinates_count.sqf";
		
};
	
if (_countLAT < 0) then {
		
		_countTime = (abs _countLAT) / _time;
		nul = ["lat+",PXS_consoleLATold,_time,_countTime] execVM "support\modules\pxs_satcom_oa\console_coordinates_count.sqf";
		
};
	
//ZOM
if (_countZOM > 0) then {
		
		_countTime = _countZOM / _time;
		nul = ["zoom-",PXS_consoleZOMold,_time,_countTime] execVM "support\modules\pxs_satcom_oa\console_coordinates_count.sqf";
		
};
	
if (_countZOM < 0) then {
		
		_countTime = (abs _countZOM) / _time;
		nul = ["zoom+",PXS_consoleZOMold,_time,_countTime] execVM "support\modules\pxs_satcom_oa\console_coordinates_count.sqf";
		
};

nil;	