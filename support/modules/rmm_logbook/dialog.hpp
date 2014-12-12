class RMM_ui_logbook {
	idd = 80504;
	movingEnable = 1;
	enableSimulation = 1;
	
	class controls {
		class Background : CUI_Frame {
			x = CUI_Box_X(1);
			y = CUI_Box_Row(0,0);
			w = CUI_Box_W * 2;
			h = CUI_Row_DY(0,10);
		};
		class WindowCaption : CUI_Caption {
			x = CUI_Box_X(1);
			y = CUI_Box_Row(0,0);
			w = CUI_Box_W * 2;
			text = "Log Book";
		};
		class SText : CUI_Text {
			x = CUI_Box_X(1);
			y = CUI_Box_Row(0,1);
			w = CUI_Box_W;
			text = "Log Entries ()";
		};
		class LogList : CUI_List {
			idc = 1;
			x = CUI_Box_X(1);
			y = CUI_Box_Row(0,2);
			w = CUI_Box_W;
			h = CUI_Row_DY(1,10);
			onLBSelChanged = "ctrlSetText [2, (((player getvariable ""RMM_logbook_target"") getvariable ""RMM_logbook"") select (_this select 1)) select 2];";
		};
		class LogEntry : CUI_Edit {
			idc = 2;
			x = CUI_Box_X(2);
			y = CUI_Box_Row(0,1);
			h = CUI_Row_DY(1,9);
			w = CUI_Box_W;
			autocomplete = "text";
		};
		class SaveEntry : CUI_Button {
			text = "SaveEntry";
			x = CUI_Box_X(2);
			w = CUI_Box_W;
			y = CUI_Row_Y(9);
			h = CUI_Row_DY(9,10);
			action = "[player getvariable ""RMM_logbook_target"",""RMM_logbook"",[[name player,[daytime] call BIS_fnc_timeToString,ctrlText 2]],true] call BIS_fnc_variableSpaceAdd; closedialog 0;";
			default = true;
		};
	};
};