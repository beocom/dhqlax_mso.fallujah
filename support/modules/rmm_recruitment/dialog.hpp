class RMM_ui_recruitment { // by Tupolov
	idd = 80506;
	movingEnable = 1;
	enableSimulation = 1;
	onLoad = "0 spawn recruit_fnc_onload;";
	
	class controls {
		class Background : CUI_Frame {
			y = CUI_Row_Y(0);
			h = CUI_Row_DY(0,2);
			w = CUI_Box_W;
		};
		class Caption : CUI_Caption {
			text = "Recruitment";
			y = CUI_Row_Y(0);
			h = CUI_Row_DY(0,1);
			w = CUI_Box_W;
		};
		class Recruit : CUI_Combo {
			idc = 1;
			y = CUI_Row_Y(1);
			w = CUI_Box_W;
			h = CUI_Row_DY(0,1);
		};
		class Transmit : CUI_Button {
			text = "Request";
			w = CUI_Box_W;
			y = CUI_Row_Y(2);
			h = CUI_Row_DY(0,1);
			action = "if ({!isplayer _x} count (units player) < 6) then {(group player) createunit [tup_recruit_classes select (lbCurSel 1), [player, 50] call CBA_fnc_randPos, [], 0, ""FORM""];};";
		};
	};
};



