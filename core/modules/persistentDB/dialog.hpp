// ====================================================================================
// DEFINES
#define CT_STRUCTURED_TEXT	13 
#define ST_LEFT				0
// ====================================================================================


///////////////////////////////////////////////////////////////////////////
/// Base Dialog Classes
///////////////////////////////////////////////////////////////////////////

class RscPDBButton
{
	access = 0;
	type = 1;
	text = "";
	colorText[] = {0.8784,0.8471,0.651,1};
	colorDisabled[] = {0.4,0.4,0.4,1};
	colorBackground[] = {1,0.537,0,0.5};
	colorBackgroundDisabled[] = {0.95,0.95,0.95,1};
	colorBackgroundActive[] = {1,0.537,0,1};
	colorFocused[] = {0.4,0.6,0.3,1};
	colorShadow[] = {0.023529,0,0.0313725,1};
	colorBorder[] = {0.023529,0,0.0313725,1};
	soundEnter[] = {"\ca\ui\data\sound\onover",0.09,1};
	soundPush[] = {"\ca\ui\data\sound\new1",0,0};
	soundClick[] = {"\ca\ui\data\sound\onclick",0.07,1};
	soundEscape[] = {"\ca\ui\data\sound\onescape",0.09,1};
	style = 2;
	x = 0;
	y = 0;
	w = 0.095589;
	h = 0.039216;
	shadow = 2;
	font = "Zeppelin32";
	sizeEx = 0.03921;
	offsetX = 0.003;
	offsetY = 0.003;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	borderSize = 0;
};


class RscPDBStructuredText
{
	access = 0;
	type = 13;
	idc = -1;
	style = 0;
	colorText[] = {0.8784,0.8471,0.651,1};
	class Attributes
	{
		font = "Zeppelin32";
		color = "#e0d8a6";
		align = "center";
		shadow = 1;
	};
	x = 0;
	y = 0;
	h = 0.035;
	w = 0.1;
	text = "";
	size = 0.03921;
	shadow = 2;
};


class RscPDBText
{
	type = 0;
	idc = -1;
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	style = 0x100; 
	font = Zeppelin32;
	SizeEx = 0.03921;
	colorText[] = {1,1,1,1};
	colorBackground[] = {0, 0, 0, 0};
	linespacing = 1;
};
class RscPDBPicture
{
	access=0;
	type=0;
	idc=-1;
	style=48;
	colorBackground[]={0,0,0,0};
	colorText[]={1,1,1,1};
	font="TahomaB";
	sizeEx=0;
	lineSpacing=0;
	text="";
};

class RscPDBLoadingText : RscPDBText
{
	style = 2;
	x = 0.323532;
	y = 0.666672;
	w = 0.352944;
	h = 0.039216;
	sizeEx = 0.03921;
	colorText[] = {0.543,0.5742,0.4102,1.0};
};
class RscPDBProgress
{
	x = 0.344;
	y = 0.619;
	w = 0.313726;
	h = 0.0261438;
	texture = "\ca\ui\data\loadscreen_progressbar_ca.paa";
	colorFrame[] = {0,0,0,0};
	colorBar[] = {1,1,1,1};
};
class RscPDBProgressNotFreeze
{
	idc = -1;
	type = 45;
	style = 0;
	x = 0.022059;
	y = 0.911772;
	w = 0.029412;
	h = 0.039216;
	texture = "#(argb,8,8,3)color(0,0,0,0)";
};



///////////////////////////////////////////////////////////////////////////
/// PDB Class Dialogs
///////////////////////////////////////////////////////////////////////////


class pdbTeleportPrompt
{

	idd = 1599;                    
	movingEnable = 0;           
	enableSimulation = 1;   
	
	class Controls
	{
				class pdbTextbox: RscPDBStructuredText
				{
					idc = 1100;
					text = "Teleport to your last saved position?";
					x = 0.335938 * safezoneW + safezoneX;
					y = 0.419183 * safezoneH + safezoneY;
					w = 0.329693 * safezoneW;
					h = 0.0350661 * safezoneH;
					colorText[] = {0.4,0.6,0.3,1};
					colorBackground[] = {-1,-1,-1,0};
					colorBackgroundActive[] = {-1,-1,-1,0};
				};
				class pdbButtonYes: RscPDBButton
				{
					idc = 1600;
					text = "Yes";
					x = 0.393943 * safezoneW + safezoneX;
					y = 0.483572 * safezoneH + safezoneY;
					w = 0.0699643 * safezoneW;
					h = 0.0352834 * safezoneH;
					colorText[] = {0.8,0.7,0.5,1};
					colorBackground[] = {0.4,0.6,0.3,1};
					colorBackgroundActive[] = {0.4,0.7,0.3,1};
					onButtonClick = "[player,1] execVM ""core\modules\persistentDB\teleportPlayer.sqf""; (ctrlParent (_this select 0)) displayRemoveEventHandler [""KeyDown"", noesckey];   ((ctrlParent (_this select 0)) closeDisplay 1599);";
				};
				class pdb_ButtonNo: RscPDBButton
				{
					idc = 1601;
					text = "No";
					x = 0.537661 * safezoneW + safezoneX;
					y = 0.482259 * safezoneH + safezoneY;
					w = 0.0699643 * safezoneW;
					h = 0.0352834 * safezoneH;
					colorText[] = {0.8,0.7,0.5,1};
					colorBackground[] = {0.4,0.6,0.3,1};
					colorBackgroundActive[] = {0.4,0.7,0.3,1};
					onButtonClick = "[player,0] execVM ""core\modules\persistentDB\teleportPlayer.sqf""; (ctrlParent (_this select 0)) displayRemoveEventHandler [""KeyDown"", noesckey]; ((ctrlParent (_this select 0)) closeDisplay 1599);";
				};
	};

};

	class PDB_loadingScreen
	{ 
			idd = -1;
			duration = 10e10;
			fadein = 0;
			fadeout = 0;
			name = "loading screen";
			class controlsBackground
			{
				class blackBG : RscPDBText
				{
					x = safezoneX;
					y = safezoneY;
					w = safezoneW;
					h = safezoneH;
					text = "";
					colorText[] = {0,0,0,0};
					colorBackground[] = {0,0,0,1};
				};
				class nicePic : RscPDBPicture
				{
					style = 48 + 0x800; // ST_PICTURE + ST_KEEP_ASPECT_RATIO
					x = safezoneX + safezoneW/2 - 0.25;
					y = safezoneY + safezoneH/2 - 0.2;
					w = 0.5;
					h = 0.4;
					text = "core\modules\persistentDB\persistentdb.paa";
				};
			};
			class controls
			{
				class Title1 : RscPDBLoadingText
				{
				//	text = "$STR_LOADING"; // "Loading" text in the middle of the screen
				text = ""; // "Loading" text in the middle of the screen
				};
				class CA_Progress : RscPDBProgress // progress bar, has to have idc 104
				{
					idc = 104;
					type = 8; // CT_PROGRESS
					style = 0; // ST_SINGLE
					texture = "\ca\ui\data\loadscreen_progressbar_ca.paa";
				};
				class CA_Progress2 : RscPDBProgressNotFreeze // progress bar that will go reverse
				{
					idc = 103;
				};
				class Name2: RscPDBText // the text 
				{
					idc = 101;
				//	x = 0.323532;
				//	y = 0.766672;
					x = 0;
					y = 0;
					w = 0.9;
					h = 0.04902;
					text = "";
					sizeEx = 0.05;
					colorText[] = {0.543,0.5742,0.4102,1.0};
				};
			};
};



// ====================================================================================	


