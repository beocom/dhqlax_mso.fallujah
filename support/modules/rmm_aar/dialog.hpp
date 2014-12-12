class RMM_ui_aar { // by Rommel
	idd = 80515;
	movingEnable = 1;
	enableSimulation = 1;
	onLoad = "0 spawn aar_fnc_onload;";

	class controls {
		class Background : CUI_Frame {
			y = CUI_Row_Y(0);
			h = CUI_Row_DY(0,20);
			w = CUI_Box_W * 2;
		};
		class Caption : CUI_Caption {
			text = "After Action Report";
			y = CUI_Row_Y(0);
			w = CUI_Box_W * 2;
		};
		class Lb0 : CUI_Combo {
			idc = 0;
			x = CUI_Box_X(2 * 1/4);
			y = CUI_Row_Y(1);
			w = CUI_Box_W * 1/2;
			onLBSelChanged = "";
		};
		class Lb1 : Lb0 {idc = 1; x = CUI_Box_X(2 * 2/4);};
		class Lb2 : Lb0 {idc = 2; x = CUI_Box_X(2 * 3/4); w = CUI_Box_W * 1/2;};
		class LblEN : CUI_Text {
			x = CUI_Box_X(2 * 1/4);
			y = CUI_Row_Y(2);
			text = "Enemy";
		};
		class LblFR : LblEN {
			x = CUI_Box_X(2 * 2/4);
			text = "Friend";
		};
		class LblCIV : LblEN {
			x = CUI_Box_X(2 * 3/4);
			text = "Civilian";
		};
		class LblWIA : CUI_Text {
			y = CUI_Row_Y(3);
			text = "KIA:";
		};
		class TF1 : CUI_Edit {idc = 3; x = CUI_Box_X(2 * 1/4); w = CUI_Box_W * 1/2; y = CUI_Row_Y(3);text = "0";};
		class TF2 : TF1 {idc = 4; x = CUI_Box_X(2 * 2/4);text = "0";};
		class TF3 : TF1 {idc = 5; x = CUI_Box_X(2 * 3/4);text = "0";};
		class LblKIA : CUI_Text {
			y = CUI_Row_Y(4);
			text = "WIA:";
		};
		class TF4 : TF1 {idc = 6; x = CUI_Box_X(2 * 1/4); y = CUI_Row_Y(4);text = "0";};
		class TF5 : TF4 {idc = 7; x = CUI_Box_X(2 * 2/4);text = "0";};
		class TF6 : TF4 {idc = 8; x = CUI_Box_X(2 * 3/4);text = "0";};
		class Report : CUI_Edit {
			idc = 9;
			y = CUI_Row_Y(5);
			h = CUI_Row_DY(5,20);
			w = CUI_Box_W * 2 - CUI_Row_H;
			text = "Report: ";
		};
		class Time : CUI_Button {
			text = "T";
			x = CUI_Box_X(2) - CUI_Row_H;
			y = CUI_Row_Y(5);
			w = CUI_Row_H;
			action = "CtrlSetText [9,(ctrlText 9) + ([daytime] call BIS_fnc_timeToString)];";
			default = true;
		};
		class LineBreak : CUI_Button {
			text = "\N";
			x = CUI_Box_X(2) - CUI_Row_H;
			y = CUI_Row_Y(6);
			w = CUI_Row_H;
			action = "CtrlSetText [9,(ctrlText 9) + ""<br/>""];";
		};
		class Submit : CUI_Button {
			text = "Submit";
			w = CUI_Box_W * 2;
			y = CUI_Row_Y(20);
			action = "if (lbCurSel 0 > -1 && lbCurSel 1 > -1 && lbCurSel 2 > -1) then {[2,RMM_aar] call aar_fnc_broadcast; closeDialog 0; RMM_aars set [count RMM_aars, RMM_aar]; publicvariable ""RMM_aars""; RMM_aar = nil;};";
		};
	};
};