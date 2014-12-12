class RMM_ui_debug { // by Rommel
	idd = 80509;
	movingEnable = 1;
	enableSimulation = 1;
	onLoad = "[] spawn {if (not isnil ""RMM_ui_debug"") then {CtrlSetText [1,RMM_ui_debug select 0]; CtrlSetText [2,RMM_ui_debug select 1]}; lbAdd [4,""All""]; lbAdd [4,""Server""]; lbAdd [4,""Clients""]; lbAdd [4,""Local""]; lbSetCurSel [4,3]; private [""_params"",""_code""]; while {dialog} do {_code = ctrlText 2; _params = ctrlText 1;}; if (not isnil ""_code"") then {RMM_ui_debug = [_params,_code]}};";

	class controls {
		class Background : CUI_Frame {
			y = CUI_Row_Y(0);
			h = CUI_Row_DY(0,30);
			w = CUI_Box_W * 2;
		};
		class ParamsCaption : CUI_Caption {
			text = "Parameters";
			y = CUI_Row_Y(0);
			w = CUI_Box_W * 2;
		};
		class Params : CUI_Edit {
			idc = 1;
			y = CUI_Row_Y(1);
			w = CUI_Box_W * 2;
			h = CUI_Row_DY(1,3);
			autocomplete = "scripting";
		};
		class CodeCaption : CUI_Caption {
			text = "Code";
			y = CUI_Row_Y(3);
			w = CUI_Box_W * 2;
		};
		class Code : CUI_Edit {
			idc = 2;
			y = CUI_Row_Y(4);
			h = CUI_Row_DY(4,27);
			w = CUI_Box_W * 2;
			autocomplete = "scripting";
		};
		class ReturnCaption : CUI_Caption {
			text = "Return";
			y = CUI_Row_Y(27);
			w = CUI_Box_W * 2;
		};
		class Return : CUI_Edit {
			idc = 3;
			y = CUI_Row_Y(28);
			h = CUI_Row_DY(28,30);
			w = CUI_Box_W * 2;
		};
		class Exec : CUI_Button {
			text = "Execute";
			w = CUI_Box_W * 5/3;
			y = CUI_Row_Y(30);
			action = "CtrlSetText [3, format[""%1"",([(lbCurSel 4),call compile (ctrlText 1),compile (ctrlText 2)] call mso_core_fnc_ExMP)]];";
			default = true;
		};
		class Locality : CUI_Combo {
			idc = 4;
			x = CUI_Box_X(1) + (CUI_Box_W * (2/3));
			y = CUI_Row_Y(30);
			w = CUI_Box_W * 1/3;
		};
		/* 
			DEBUG PANEL EXTRAS 
		*/
		#include <dpanel.hpp>
	};
};