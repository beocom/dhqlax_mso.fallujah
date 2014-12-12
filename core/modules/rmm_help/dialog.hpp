class RMM_ui_help { // by Rommel
	idd = 80599;
	movingEnable = 1;
	enableSimulation = 1;
	onLoad = "0 spawn help_fnc_onload;";
	

	class controls {
		class Background : CUI_Frame {
			y = CUI_Row_Y(0);
			h = safeH;
			w = safeW;
		};
		class Group : CUI_ControlGroup {
			y = CUI_Row_Y(0);
			w = safeW;
			h = safeH;
			class controls {
				class Page : CUI_StructText {
					idc = 1;
					text = "Error";
					x = 0;
					y = 0;
					w = safeW * 2;
					h = safeH * 4;
				};
			};
		};
	};
};