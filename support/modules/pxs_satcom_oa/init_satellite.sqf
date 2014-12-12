if(isNil "EnablePXSsatcom") then {EnablePXSsatcom = 1;};
if (EnablePXSsatcom == 0) exitwith {diag_log format["MSO-%1 PXS SATCOMs turned off! Exiting...", time]};

private["_unit","_switch"];

//init: [unitName, activeStatus] execVM "support\modules\pxs_satcom_oa\init_satellite.sqf";
//activeStatus: "ON" ; "OFF"
_switch = _this select 0;

//start functions
PXS_timeFunction = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\time_function.sqf";
PXS_timeView = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\time_view.sqf";
PXS_coordinatesView = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\coordinates_view.sqf";
PXS_adjustCamera = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\adjustCamera.sqf";
PXS_updateCamera = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\updateCamera.sqf";
PXS_closeCamera = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\closeCamera.sqf";
PXS_viewSatellite = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\view_satellite.sqf";
PXS_keyEventFunction = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\key_function.sqf";
PXS_mouseZChanged = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\mouseZChanged.sqf";
PXS_keyMain = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\key_main.sqf";
PXS_switcher = compile preprocessFileLineNumbers "support\modules\pxs_satcom_oa\switcher.sqf";

if (isserver) then {
    //switch on or off globally (can be disabled for all with this switch)
	[_switch] call PXS_switcher;
};
//create menu item
["player", [mso_interaction_key], -9398, ["support\modules\pxs_satcom_oa\fn_menuDef.sqf", "main"]] call CBA_ui_fnc_add;
