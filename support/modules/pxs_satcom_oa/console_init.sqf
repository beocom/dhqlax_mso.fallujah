private [];

//init functions
PXS_timeFunction = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\time_function.sqf";
PXS_timeView = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\time_view.sqf";
PXS_cameraStatic = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\console_update_static.sqf";
PXS_cameraDynamic = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\console_update.sqf";
PXS_showInterface = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\console_interface_show.sqf";
PXS_adjustCamera = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\adjustCamera.sqf";
PXS_cameraTerminate = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\console_close.sqf";

//init variables
PXS_consoleLON = 0;
PXS_consoleLAT = 0;
PXS_consoleZOM = 0;
PXS_consoleFACTOR = 9.5;

//start functions
[] call PXS_timeView;