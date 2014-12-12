class CfgPatches
{
	class PXS_SATCOM
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.100000;
		requiredAddons[] = {"CAData","CAWeapons","CACharacters"};
	};
};

class CfgVehicles
{
	class Bag_Base_EP1;
	class PXS_SATCOM_Terminal_Pack : Bag_Base_EP1
	{
		scope = 2;
		displayName = "$STR_PXS_BAG";
		picture = "\ca\weapons_e\data\icons\backpack_US_ASSAULT_CA.paa";
		icon = "\ca\weapons_e\data\icons\mapIcon_backpack_CA.paa";
		mapSize = 2;
		model = "\ca\weapons_e\AmmoBoxes\backpack_us_AUV";
		transportMaxWeapons = 0;
		transportMaxMagazines = 0;
	};
	
	class US_Delta_Force_EP1;
	class PXS_Delta_Force_SATCOM_Operator: US_Delta_Force_EP1
	{
	accuracy = 3.9;
	backpack = "PXS_SATCOM_Terminal_Pack";
	canCarryBackPack = 1;
	camouflage = 0.6;
	displayname = "$STR_PXS_OPERATOR";
	identitytypes[] = {"Language_EN_EP1", "Head_USMC"};
	magazines[] = {"20rnd_762x51_SB_SCAR", "20rnd_762x51_SB_SCAR", "20rnd_762x51_SB_SCAR", "20rnd_762x51_SB_SCAR", "20rnd_762x51_SB_SCAR", "20rnd_762x51_SB_SCAR", "20rnd_762x51_SB_SCAR", "20rnd_762x51_SB_SCAR", "SmokeShellRed", "SmokeShellPurple", "15Rnd_9x19_M9SD", "15Rnd_9x19_M9SD", "15Rnd_9x19_M9SD", "15Rnd_9x19_M9SD"};
	model = "\ca\characters_e\Delta\Delta1.p3d";
	respawnmagazines[] = {"20rnd_762x51_SB_SCAR", "20rnd_762x51_SB_SCAR", "20rnd_762x51_SB_SCAR", "20rnd_762x51_SB_SCAR", "SmokeShellPurple", "15Rnd_9x19_M9SD", "15Rnd_9x19_M9SD"};
	respawnweapons[] = {"SCAR_H_CQC_CCO_SD", "NVGoggles", "Throw", "Put", "ItemMap", "ItemCompass", "ItemWatch", "ItemRadio", "itemGPS", "M9SD"};
	scope = 2;
	faction = BIS_US;
	vehicleclass = "MenDeltaForce";
	weapons[] = {"SCAR_H_CQC_CCO_SD", "NVGoggles", "Throw", "Put", "ItemMap", "ItemCompass", "ItemWatch", "ItemRadio", "itemGPS", "M9SD"};
	class EventHandlers 
	{
		init = "_PXS_sai = [(_this select 0), ""ON""] execVM ""support\modules\pxs_satcom_oa\init_satellite.sqf""";
	};
	};
};

#include "\support\modules\pxs_satcom_oa\init_interference.hpp"