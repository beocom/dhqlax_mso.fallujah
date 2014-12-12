/* 
	DEBUG PANEL EXTRAS 
*/
class DPanel : CUI_Frame {
	y = CUI_Row_Y(0);
	x = CUI_Box_X(2);
	h = CUI_Row_DY(0,25);
	w = CUI_Box_W / 1.4;
};
class DPanelCaption : CUI_Caption {
	text = "DPanel";
	x = CUI_Box_X(2);
	y = CUI_Row_Y(0);
	w = CUI_Box_W / 1.4;
};
class DPanelTxt : CUI_Edit {
	idc = 55;
	x = CUI_Box_X(2);
	y = CUI_Row_Y(1);
	h = CUI_Row_DY(1,7);
	w = CUI_Box_W / 1.4;
	autocomplete = "scripting";
};
class DPanelCaptionH : CUI_Caption {
	text = "Statistics";
	x = CUI_Box_X(2);
	y = CUI_Row_Y(7);
	w = CUI_Box_W / 1.4;
};
class DPanelOwnID : CUI_Button {
	text = "OwnID";
	x = CUI_Box_X(2);
	w = CUI_Box_W / 1.4;
	y = CUI_Row_Y(8);
	action = "CtrlSetText [55, (getPlayerUID player)]";
};
class DPanelPlayable : DPanelOwnID {
	text = "PlayableUnits";
	y = CUI_Row_Y(9);
	action = "CtrlSetText [55,str playableunits];";
};
class DPanelCount : DPanelOwnID {
	text = "Count AllUnits";
	y = CUI_Row_Y(10);
	action = "CtrlSetText [55,str [west,west countside allunits,east,east countside allunits,resistance,resistance countside allunits,civilian,civilian countside allunits]];";
};
class DPanelCaptionP : CUI_Caption {
	text = "Parameters";
	x = CUI_Box_X(2);
	y = CUI_Row_Y(11);
	w = CUI_Box_W / 1.4;
};
class DPanelScreenPos : DPanelOwnID {
	text = "ScreenPos";
	y = CUI_Row_Y(12);
	action = "CtrlSetText [1,str (screenToWorld [0.5,0.5])];";
};
class DPanelCursorTarget : DPanelOwnID {
	text = "cursorTarget";
	y = CUI_Row_Y(13);
	action = "CtrlSetText [55,str cursorTarget]; CtrlSetText [1,""cursorTarget""];";
};
class DPanelNearest : DPanelOwnID {
	text = "NearestCursor";
	y = CUI_Row_Y(14);
	action = "CtrlSetText [55,str (nearestObject screenToWorld [0.5,0.5])]; CtrlSetText [1,""nearestObject screenToWorld [0.5,0.5]""];";
};
class DPanelCaptionC : CUI_Caption {
	text = "Code";
	x = CUI_Box_X(2);
	y = CUI_Row_Y(15);
	w = CUI_Box_W / 1.4;
};
class DPanelAIGrpMake : DPanelOwnID {
	text = "spawnGroup";
	y = CUI_Row_Y(16);
	action = "CtrlSetText [2,""_group = [_this, <SIDE>, <GROUP_NAME>] call BIS_fnc_SpawnGroup; _group""];";
};
class DPanelCreateVehicle : DPanelOwnID {
	text = "createVehicle";
	y = CUI_Row_Y(17);
	action = "CtrlSetText [2,""_vehicle = createvehicle ['<TYPE>',_this,[],0,'']; _vehicle""];";
};
class DPanelCaptionL : CUI_Caption {
	text = "Lists";
	x = CUI_Box_X(2);
	y = CUI_Row_Y(18);
	w = CUI_Box_W / 1.4;
};
class DPanelListBox : CUI_Combo {
	idc = 995;
	x = CUI_Box_X(2) + CUI_Row_H;
	w = (CUI_Box_W / 1.4) - CUI_Row_H;
	y = CUI_Row_Y(19);
};
class DPanelCopyToClipboard : CUI_Button {
	text = "^C";
	x = CUI_Box_X(2);
	y = CUI_Row_Y(19);
	w = CUI_Row_H;
	action = "copytoclipboard (lbText [995, lbCurSel 995]);";
};
class DPanelCfgVehicles : DPanelOwnID {
	text = "CfgVehicles";
	y = CUI_Row_Y(20);
	action = "lbClear 995; _l = configFile >> ""CfgVehicles"";for ""_i"" from 0 to ((count _l) - 1) do {lbAdd [995, configName (_l select _i)];};";
};
class DPanelCfgWeapons : DPanelOwnID {
	text = "CfgWeapons";
	y = CUI_Row_Y(21);
	action = "lbClear 995; _l = configFile >> ""CfgWeapons"";for ""_i"" from 0 to ((count _l) - 1) do {lbAdd [995, configName (_l select _i)];};";
};
class DPanelCfgMagazines : DPanelOwnID {
	text = "CfgMagazines";
	y = CUI_Row_Y(22);
	action = "lbClear 995; _l = configFile >> ""CfgMagazines"";for ""_i"" from 0 to ((count _l) - 1) do {lbAdd [995, configName (_l select _i)];};";
};
class DPanelCfgAmmo : DPanelOwnID {
	text = "CfgAmmo";
	y = CUI_Row_Y(23);
	action = "lbClear 995; _l = configFile >> ""CfgAmmo"";for ""_i"" from 0 to ((count _l) - 1) do {lbAdd [995, configName (_l select _i)];};";
};
class DPanelCaptionM : CUI_Caption {
	text = "Misc";
	x = CUI_Box_X(2);
	y = CUI_Row_Y(24);
	w = CUI_Box_W / 1.4;
};
class DPanelCamera : DPanelOwnID {
	text = "Camera";
	y = CUI_Row_Y(25);
	action = "player exec ""camera.sqs""";
};
