class TUP_ui_logistics {

	idd = 80600;
	movingEnable = 1;
	enableSimulation = 1;
	onLoad = "0 spawn logistics_fnc_onload";

	class controls {
		class LogFormFrame: CUI_Frame
		{
			idc = 1800;
			text = "MSO Logistics Request Form";
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.55 * safezoneH;
		};
		class LogFormOKButton: CUI_Button
		{
			idc = 1600;
			text = "OK";
			x = 0.661133 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.0322266 * safezoneW;
			h = 0.0275 * safezoneH;
			action = "0 call logistics_fnc_validateOrder;";
		};
		class LogFormCancelButton: CUI_Button
		{
			idc = 1601;
			text = "Cancel";
			x = 0.306641 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.0386719 * safezoneW;
			h = 0.0275 * safezoneH;
			action = "closeDialog 0;";
		};
		class LogFormOrderCapacity: CUI_Caption
		{
			idc = 2001;
			text = "Order Capacity: ";
			x = 0.616 * safezoneW + safezoneX;
			y = 0.67875 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormOrderBox: CUI_List
		{
			idc = 10;
			x = 0.306641 * safezoneW + safezoneX;
			y = 0.48625 * safezoneH + safezoneY;
			w = 0.13 * safezoneW;
			h = 0.22 * safezoneH;
		};
		class LogFormAirVehDrop: CUI_Combo
		{
			idc = 5;
			x = 0.416211 * safezoneW + safezoneX;
			y = 0.2525 * safezoneH + safezoneY;
			w = 0.225586 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormLandVehDrop: CUI_Combo
		{
			idc = 6;
			x = 0.416211 * safezoneW + safezoneX;
			y = 0.29375 * safezoneH + safezoneY;
			w = 0.225586 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormCrateDrop: CUI_Combo
		{
			idc = 7;
			x = 0.416211 * safezoneW + safezoneX;
			y = 0.335 * safezoneH + safezoneY;
			w = 0.225586 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormStaticVehDrop: CUI_Combo
		{
			idc = 8;
			x = 0.416211 * safezoneW + safezoneX;
			y = 0.37625 * safezoneH + safezoneY;
			w = 0.225586 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormDefSupDrop: CUI_Combo
		{
			idc = 9;
			x = 0.416211 * safezoneW + safezoneX;
			y = 0.4175 * safezoneH + safezoneY;
			w = 0.225586 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormAirVehNum: CUI_Combo
		{
			idc = 0;
			x = 0.358203 * safezoneW + safezoneX;
			y = 0.2525 * safezoneH + safezoneY;
			w = 0.0386719 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormLandVehNum: CUI_Combo
		{
			idc = 1;
			x = 0.358203 * safezoneW + safezoneX;
			y = 0.29375 * safezoneH + safezoneY;
			w = 0.0386719 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormCrateNum: CUI_Combo
		{
			idc = 2;
			x = 0.358203 * safezoneW + safezoneX;
			y = 0.335 * safezoneH + safezoneY;
			w = 0.0386719 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormStaticVehNum: CUI_Combo
		{
			idc = 3;
			x = 0.358203 * safezoneW + safezoneX;
			y = 0.37625 * safezoneH + safezoneY;
			w = 0.0386719 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormDefSupNum: CUI_Combo
		{
			idc = 4;
			x = 0.358203 * safezoneW + safezoneX;
			y = 0.4175 * safezoneH + safezoneY;
			w = 0.0386719 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormAirAdd: CUI_Button
		{
			idc = 1602;
			text = "Add";
			x = 0.661133 * safezoneW + safezoneX;
			y = 0.2525 * safezoneH + safezoneY;
			w = 0.0322266 * safezoneW;
			h = 0.0275 * safezoneH;
			action = "[0,5,'air'] call logistics_fnc_formAddItem;";
		};
		class LogFormLandAdd: CUI_Button
		{
			idc = 1603;
			text = "Add";
			x = 0.661133 * safezoneW + safezoneX;
			y = 0.29375 * safezoneH + safezoneY;
			w = 0.0322266 * safezoneW;
			h = 0.0275 * safezoneH;
			action = "[1,6,'land'] call logistics_fnc_formAddItem;";
		};
		class LogFormCrateAdd: CUI_Button
		{
			idc = 1604;
			text = "Add";
			x = 0.661133 * safezoneW + safezoneX;
			y = 0.335 * safezoneH + safezoneY;
			w = 0.0322266 * safezoneW;
			h = 0.0275 * safezoneH;
			action = "[2,7,'crate'] call logistics_fnc_formAddItem;";
		};
		class LogFormStaticAdd: CUI_Button
		{
			idc = 1605;
			text = "Add";
			x = 0.661133 * safezoneW + safezoneX;
			y = 0.37625 * safezoneH + safezoneY;
			w = 0.0322266 * safezoneW;
			h = 0.0275 * safezoneH;
			action = "[3,8,'static'] call logistics_fnc_formAddItem;";
		};
		class LogFormDefSupAdd: CUI_Button
		{
			idc = 1606;
			text = "Add";
			x = 0.661133 * safezoneW + safezoneX;
			y = 0.4175 * safezoneH + safezoneY;
			w = 0.0322266 * safezoneW;
			h = 0.0275 * safezoneH;
			action = "[4,9,'defence'] call logistics_fnc_formAddItem;";
		};
		class LogFormRemoveSel: CUI_Button
		{
			idc = 1607;
			text = "Remove Selected";
			x = 0.38 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.0275 * safezoneH;
			action = "0 call logistics_fnc_formRemoveItem;";
		};
		class LogFormAirText: CUI_Caption
		{
			idc = 1000;
			text = "Aircraft";
			x = 0.306641 * safezoneW + safezoneX;
			y = 0.2525 * safezoneH + safezoneY;
			w = 0.0386719 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormLandText: CUI_Caption
		{
			idc = 1001;
			text = "Vehicles";
			x = 0.306641 * safezoneW + safezoneX;
			y = 0.29375 * safezoneH + safezoneY;
			w = 0.0386719 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormCrateText: CUI_Caption
		{
			idc = 1002;
			text = "Crates";
			x = 0.306641 * safezoneW + safezoneX;
			y = 0.335 * safezoneH + safezoneY;
			w = 0.0386719 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormStaticText: CUI_Caption
		{
			idc = 1003;
			text = "Support";
			x = 0.306641 * safezoneW + safezoneX;
			y = 0.37625 * safezoneH + safezoneY;
			w = 0.0386719 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormDefSupText: CUI_Caption
		{
			idc = 1004;
			text = "Defence";
			x = 0.306641 * safezoneW + safezoneX;
			y = 0.4175 * safezoneH + safezoneY;
			w = 0.0386719 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormOrderBoxText: CUI_Caption
		{
			idc = 1005;
			text = "Current Order";
			x = 0.306641 * safezoneW + safezoneX;
			y = 0.45875 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormDeliveryText: CUI_Caption
		{
			idc = 1006;
			text = "Delivery Method:";
			x = 0.416211 * safezoneW + safezoneX;
			y = 0.45875 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormDeliveryDrop: CUI_Combo
		{
			idc = 11;
			x = 0.51000 * safezoneW + safezoneX;
			y = 0.45875 * safezoneH + safezoneY;
			w = 0.13 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class LogFormReplenDem: CUI_Button
		{
			idc = 1007;
			text = "Order Replen";
			x = 0.51 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.0275 * safezoneH;
			action = "0 call logistics_fnc_formAddReplen;";
		};
	};
};

