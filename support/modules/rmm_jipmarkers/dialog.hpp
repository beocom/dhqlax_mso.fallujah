class RMM_ui_jipmarkers { // by Rommel
	idd = 80511;
	movingEnable = 1;
	enableSimulation = 1;
	onLoad = "0 spawn jipmarkers_fnc_onload";

	class controls {
		class Background : CUI_Frame {
			y = CUI_Row_Y(0);
			h = CUI_Row_DY(0,6);
			w = CUI_Box_W;
		};
		class Caption : CUI_Caption {
			text = "Team Markers";
			y = CUI_Row_Y(0);
			h = CUI_Row_DY(0,1);
			w = CUI_Box_W;
		};
		class LblType : CUI_Text {
			y = CUI_Row_Y(1);
			text = "Icon:";
		};
		class MLb : CUI_Combo {
			idc = 1;
			x = CUI_Box_X(1/4);
			y = CUI_Row_Y(1);
			w = CUI_Box_W * 3/4;
		};
		class LblText : CUI_Text {
			y = CUI_Row_Y(2);
			text = "Text:";
		};
		class MarkerText : CUI_Edit {
			idc = 2;
			x = CUI_Box_X(1/4);
			y = CUI_Row_Y(2);
			w = CUI_Box_W * 3/4;
		};
		class LblColor : CUI_Text {
			y = CUI_Row_Y(3);
			text = "Color:";
		};
		class MarkerColor : CUI_Combo {
			idc = 3;
			x = CUI_Box_X(1/4);
			y = CUI_Row_Y(3);
			w = CUI_Box_W * 3/4;
		};
		class Transmit : CUI_Button {
			text = "Transmit";
			w = CUI_Box_W;
			y = CUI_Row_Y(4);
			action = "if ((lbCurSel 1) > -1) then {0 call jipmarkers_fnc_transmit; closeDialog 0;};";
		};
		class Delete : CUI_Button {
			text = "Delete Nearest";
			w = CUI_Box_W;
			y = CUI_Row_Y(5);
			action = "if (count RMM_jipmarkers > 0) then {0 call jipmarkers_fnc_deletenearest; closeDialog 0;};";
		};
	};
};