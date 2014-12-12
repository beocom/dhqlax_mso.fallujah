class RscLine2
{
	type = 0;
	idc = -1;
	style = 512;
	ColorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	font = "Zeppelin32";
	SizeEx = 0.025;
};
class PXS_RscSatellite
{
	idd = 1000;
	movingEnable = 0;
	class Controls
	{
		//center
		class time: RscLine2
		{
			idc = 1001;
			x = 0.5;
			y = "safeZoneY + 0.1";
			w = 0.2;
			h = 0.1;
			text = "15:00:00";
		};
		//top left
		class nav: RscLine2
		{
			x = "(10/100)	* SafeZoneW + SafeZoneX";
			y = "(10/100)	* SafeZoneH + SafeZoneY";
			w = "(10/100)	* SafeZoneW";
			h = "(10/100)	* SafeZoneH";
			text = "NAV>";
		};
		class uhf: RscLine2
		{
			x = "(10/100)	* SafeZoneW + SafeZoneX";
			y = "(12/100)	* SafeZoneH + SafeZoneY";
			w = "(10/100)	* SafeZoneW";
			h = "(10/100)	* SafeZoneH";
			text = "UHF ACTIVE";
		};
		class nvs: RscLine2
		{
			x = "(10/100)	* SafeZoneW + SafeZoneX";
			y = "(14/100)	* SafeZoneH + SafeZoneY";
			w = "(11/100)	* SafeZoneW";
			h = "(10/100)	* SafeZoneH";
			text = "CORRECTIONS AUTO";
		};
		class calib: RscLine2
		{
			x = "(10/100)	* SafeZoneW + SafeZoneX";
			y = "(16/100)	* SafeZoneH + SafeZoneY";
			w = "(10/100)	* SafeZoneW";
			h = "(10/100)	* SafeZoneH";
			text = "CALIBRATION OK";
		};
		//top right
		class cx: RscLine2
		{
			idc = 1002;
			x = "(80/100)	* SafeZoneW + SafeZoneX";
			y = "(10/100)	* SafeZoneH + SafeZoneY";
			w = "(10/100)	* SafeZoneW";
			h = "(10/100)	* SafeZoneH";
			text = "LAT";
		};
		class cy: RscLine2
		{
			idc = 1003;
			x = "(80/100)	* SafeZoneW + SafeZoneX";
			y = "(12/100)	* SafeZoneH + SafeZoneY";
			w = "(10/100)	* SafeZoneW";
			h = "(10/100)	* SafeZoneH";
			text = "LON";
		};
		class cz: RscLine2
		{
			idc = 1004;
			x = "(80/100)	* SafeZoneW + SafeZoneX";
			y = "(14/100)	* SafeZoneH + SafeZoneY";
			w = "(10/100)	* SafeZoneW";
			h = "(10/100)	* SafeZoneH";
			text = "ZOOM";
		};
		//top left
		class nv2: RscLine2
		{
			idc = 1006;
			x = "(10/100)	* SafeZoneW + SafeZoneX";
			y = "(88/100)	* SafeZoneH + SafeZoneY";
			w = "(10/100)	* SafeZoneW";
			h = "(10/100)	* SafeZoneH";
			text = "NV OFF";
		};
		class nv: RscLine2
		{
			idc = 1005;
			x = "(10/100)	* SafeZoneW + SafeZoneX";
			y = "(90/100)	* SafeZoneH + SafeZoneY";
			w = "(10/100)	* SafeZoneW";
			h = "(10/100)	* SafeZoneH";
			text = "FLIR OFF";
		};
		//bottom right
		class msat2: RscLine2
		{
			x = "(80/100)	* SafeZoneW + SafeZoneX";
			y = "(88/100)	* SafeZoneH + SafeZoneY";
			w = "(10/100)	* SafeZoneW";
			h = "(10/100)	* SafeZoneH";
			text = "NTS>185-MILSAT";
		};
		class msat: RscLine2
		{
			x = "(80/100)	* SafeZoneW + SafeZoneX";
			y = "(90/100)	* SafeZoneH + SafeZoneY";
			w = "(10/100)	* SafeZoneW";
			h = "(10/100)	* SafeZoneH";
			text = "NTW>>928-1e5";
		};
		//crosshair
		class cross1: RscLine2
		{
			x = 0.42;
			y = 0.5;
			w = 0.05;
			h = 0.002;
			ColorBackground[] = {1,1,1,1};
			text = "";
		};
		class cross1_2: RscLine2
		{
			x = 0.53;
			y = 0.5;
			w = 0.05;
			h = 0.002;
			ColorBackground[] = {1,1,1,1};
			text = "";
		};
		class cross2: RscLine2
		{
			x = 0.5;
			y = 0.42;
			w = 0.002;
			h = 0.05;
			ColorBackground[] = {1,1,1,1};
			text = "";
		};
		class cross2_2: RscLine2
		{
			x = 0.5;
			y = 0.53;
			w = 0.002;
			h = 0.05;
			ColorBackground[] = {1,1,1,1};
			text = "";
		};
	};
};