/**
 * English and French comments
 * Commentaires anglais et français
 * 
 * This file contains the configuration variables of the logistics system.
 * Fichier contenant les variables de configuration du système de logistique.
 * 
 * Important note : All the classes names which inherits from the ones used in configuration variables will be also available.
 * Note importante : Tous les noms de classes dérivant de celles utilisées dans les variables de configuration seront aussi valables.
 *
 * Usefull links / Liens utiles :
 * - http://community.bistudio.com/wiki/ArmA_2:_CfgVehicles
 * - http://www.armatechsquad.com/ArmA2Class/
 */

/*
 * There are two ways to manage new objects with the logistics system. The first is to add these objects in the
 * following appropriate lists. The second is to create a new external file in the /addons_config/ directory,
 * according to the same scheme as the existing ones, and to add a #include at the end of this current file.
 * 
 * Deux moyens existent pour gérer de nouveaux objets avec le système logistique. Le premier consiste à ajouter
 * ces objets dans les listes appropriées ci-dessous. Le deuxième est de créer un fichier externe dans le répertoire
 * /addons_config/ selon le même schéma que ceux qui existent déjà, et d'ajouter un #include à la fin de ce présent fichier.
 */

/****** TOW WITH VEHICLE / REMORQUER AVEC VEHICULE ******/

/**
 * List of class names of (ground or air) vehicles which can tow towables objects.
 * Liste des noms de classes des véhicules terrestres pouvant remorquer des objets remorquables.
 */
 
 //beware to check for duplicates when removing vehicles
R3F_LOG_CFG_remorqueurs =
[
	// e.g. : "MyTowingVehicleClassName1", "MyTowingVehicleClassName2"
	"Wheeled_APC",
	"HMMWV_Base",
	"TowingTractor",
	"tractor",
	"Kamaz_Base",
	"MTVR",
	"GRAD_Base",
	"Ural_Base",
	"Ural_ZU23_Base",
	"V3S_Civ",
	"UAZ_Base",
	"BRDM2_Base",
	"BTR90_Base",
	"GAZ_Vodnik_HMG",
	"LAV25_Base",
	"MLRS",
	"LandRover_Base"
];

/**
 * List of class names of towables objects.
 * Liste des noms de classes des objets remorquables.
 */
R3F_LOG_CFG_objets_remorquables =
[
	// e.g. : "MyTowableObjectClassName1", "MyTowableObjectClassName2"
	"Car",
	"StaticCannon",
	"RubberBoat"
];


/****** LIFT WITH VEHICLE / HELIPORTER AVEC VEHICULE ******/

/**
 * List of class names of air vehicles which can lift liftables objects.
 * Liste des noms de classes des véhicules aériens pouvant héliporter des objets héliportables.
 */
R3F_LOG_CFG_heliporteurs =
[
	// e.g. : "MyLifterVehicleClassName1", "MyLifterVehicleClassName2"
	"BAF_Merlin_HC3_D",
	"CH_47F_EP1",
	"AAW_CH47"
];

/**
 * List of class names of liftables objects.
 * Liste des noms de classes des objets héliportables.
 */
R3F_LOG_CFG_objets_heliportables =
[
	// e.g. : "MyLiftableObjectClassName1", "MyLiftableObjectClassName2"
	"BAF_Jackal2_BASE_D",
	"StaticCannon",
	"Car",
	"Ship",
	"ReammoBox",
	"MLRS",
	
	"Land_Misc_Cargo1Ao",
	"Land_Misc_Cargo1B",
	"Land_Misc_Cargo1Bo",
	"Land_Misc_Cargo1C",
	"Land_Misc_Cargo1D",
	"Land_Misc_Cargo1E",
	"Land_Misc_Cargo1F",
	"Land_Misc_Cargo1G",
	"Base_WarfareBContructionSite",
	"Misc_cargo_cont_net1",
	"Misc_cargo_cont_net2",
	"Misc_cargo_cont_net3",
	"Misc_cargo_cont_small",
	"Misc_cargo_cont_small2",
	"Misc_cargo_cont_tiny",
	"Land_Misc_Cargo1E_EP1"
];


/****** LOAD IN VEHICLE / CHARGER DANS LE VEHICULE ******/

/*
 * This section use a quantification of the volume and/or weight of the objets.
 * The arbitrary referencial used is : an ammo box of type USVehicleBox "weights" 12 units.
 * 
 * Cette section utilise une quantification du volume et/ou poids des objets.
 * Le référentiel arbitraire utilisé est : une caisse de munition de type USVehicleBox "pèse" 12 unités.
 * 
 * Note : the priority of a declaration of capacity to another corresponds to their order in the tables.
 *   For example : the "Truck" class is in the "Car" class (see http://community.bistudio.com/wiki/ArmA_2:_CfgVehicles).
 *   If "Truck" is declared with a capacity of 140 before "Car". And if "Car" is declared after "Truck" with a capacity of 40,
 *   Then all the sub-classes in "Truck" will have a capacity of 140. And all the sub-classes of "Car", excepted the ones
 *   in "Truck", will have a capacity of 40.
 * 
 * Note : la priorité d'une déclaration de capacité sur une autre correspond à leur ordre dans les tableaux.
 *   Par exemple : la classe "Truck" appartient à la classe "Car" (voir http://community.bistudio.com/wiki/ArmA_2:_CfgVehicles).
 *   Si "Truck" est déclaré avec une capacité de 140 avant "Car". Et que "Car" est déclaré après "Truck" avec une capacité de 40,
 *   Alors toutes les sous-classes appartenant à "Truck" auront une capacité de 140. Et toutes les sous-classes appartenant
 *   à "Car", exceptées celles de "Truck", auront une capacité de 40.
 */

/**
 * List of class names of (ground or air) vehicles which can transport transportables objects.
 * The second element of the arrays is the load capacity (in relation with the capacity cost of the objects).
 * 
 * Liste des noms de classes des véhicules (terrestres ou aériens) pouvant transporter des objets transportables.
 * Le deuxième élément des tableaux est la capacité de chargement (en relation avec le coût de capacité des objets).
 */
R3F_LOG_CFG_transporteurs =
[
	// e.g. : ["MyTransporterClassName1", itsCapacity], ["MyTransporterClassName2", itsCapacity]
	["BAF_Jackal2_BASE_D", 15],
	["CH_47F_EP1", 50],
	["AW159_Lynx_BAF", 15],

	["AAW_CH47", 50],
	["AAW_s70bh_mg",25],
	["AAW_s70",25],
	
	["aawBushmaster_ECM", 13],
	["aawBushmaster_pws_ECM", 12],
	["aawBushmaster", 15],
	
	["ATV_US_EP1", 10],

	["hilux1_civil_1_open", 10],
	["HMMWV_Base", 12],
	["Ikarus", 40],
	["Lada_base", 6],
	["SkodaBase", 6],
	["TowingTractor", 5],
	["tractor", 2],
	["Motorcycle", 1],
	["KamazRefuel", 5],
	["Kamaz_Base", 40],
	["MtvrRefuel", 5],
	["MTVR", 110],
	["GRAD_Base", 2],
	["Ural_Base", 40],
	["ACE_Truck5tMG", 40],
	["V3S_Civ", 25],
	["UAZ_Base", 10],
	["VWGolf", 6],
	["BRDM2_Base", 25],
	["BTR90_Base", 25],
	["GAZ_Vodnik_HMG", 25],
	["LAV25_Base", 25],
	["AAV", 10],
	["BMP2_Base", 8],
	["BMP3", 8],
	
	["Mi17_base", 50],
	["Mi24_Base", 40],
	["UH1Y", 15],
	["UH60_Base", 25],
	["C130J", 150],
	["MV22", 90],
	
	["RHIB", 12],
	["RubberBoat", 5],
	["Fishing_Boat", 18],
	["Smallboat_1", 6],
	
	["Land_Misc_Cargo1E_EP1", 100],

	["Land_Misc_Cargo1Ao", 100],
	["Land_Misc_Cargo1B", 100],
	["Land_Misc_Cargo1Bo", 100],
	["Land_Misc_Cargo1C", 100],
	["Land_Misc_Cargo1D", 100],
	["Land_Misc_Cargo1E", 100],
	["Land_Misc_Cargo1F", 100],
	["Land_Misc_Cargo1G", 100],
	["Base_WarfareBContructionSite", 50],
	["Misc_cargo_cont_net1", 9],
	["Misc_cargo_cont_net2", 18],
	["Misc_cargo_cont_net3", 30],
	["Misc_cargo_cont_small", 20],
	["Misc_cargo_cont_small2", 16],
	["Misc_cargo_cont_tiny", 12]
];

/**
 * List of class names of transportables objects.
 * The second element of the arrays is the cost capacity (in relation with the capacity of the vehicles).
 * 
 * Liste des noms de classes des objets transportables.
 * Le deuxième élément des tableaux est le coût de capacité (en relation avec la capacité des véhicules).
 */
R3F_LOG_CFG_objets_transportables =
[
	// e.g. : ["MyTransportableObjectClassName1", itsCost], ["MyTransportableObjectClassName2", itsCost]
	
	["aawWpnsBox_F88SA2", 6],
	["aawWpnsBox_F88_1", 6],
	["aawWpnsBox_LMG", 8],
	["aawWpnsBox_AA_D", 8],
	
	["Land_Pneu", 2],
	["Land_fort_bagfence_long", 3],
	["Land_fort_bagfence_corner", 3],
	["Land_fort_bagfence_round", 3],
	["Fort_RazorWire", 3],
	["Hedgehog_EP1", 3],
	["Land_fortified_nest_small_EP1", 6],
	["Land_fort_artillery_nest_EP1", 12],
	["Land_fortified_nest_big_EP1", 12],
	["MASH_EP1", 5],
	["Land_CamoNet_NATO_EP1", 4],
	["Land_CamoNetB_NATO_EP1", 5],
	["Land_CamoNetVar_NATO_EP1", 3],
	["ATV_US_EP1", 25],

	["SatPhone", 20], // Needed for the R3F_ARTY module (arty HQ) (nécessaire pour le module R3F_ARTY (PC d'arti))
	["StaticAAWeapon", 7],
	["StaticATWeapon", 5],
	["StaticGrenadeLauncher", 3],
	["StaticMGWeapon", 3],
	["StaticMortar", 3],
	["StaticSEARCHLight", 2],
	
	["Motorcycle", 4],
	["Truck", 140],
	["Car", 50],
	
	["RubberBoat", 22],
	
	["FlagCarrierSmall", 0.1],
	
	["RoadBarrier_light", 1],
	["FlagCarrierCore", 0.2],
	["Hedgehog", 1],
	["Hhedgehog_concrete", 2],
	["Hhedgehog_concreteBig", 3],
	["Land_fortified_nest_small", 5],
	["Land_fortified_nest_big", 10],
	["Land_Fort_Watchtower", 15],
	["Fort_Barracks_USMC", 15],
	["Land_fort_rampart", 10],
	["Land_fort_artillery_nest", 15],

	["Land_fort_bagfence_long", 2],
	["Land_fort_bagfence_round", 2],
	["Fort_Barricade", 55],
	["Land_CamoNet_NATO", 4],
	["Land_fort_bagfence_corner", 2],
	["Fort_RazorWire", 1],
	
	["Land_HBarrier1", 1],
	["Land_HBarrier3", 3],
	["Land_HBarrier5", 5],
	["Land_HBarrier_large", 5],
	["Base_WarfareBBarrier5x", 5],
	["Land_Misc_deerstand", 10],
	["Misc_Cargo1B_military", 55],
	["Land_Misc_Cargo1Ao", 55],
	["Land_Misc_Cargo1B", 55],
	["Land_Misc_Cargo1Bo", 55],
	["Land_Misc_Cargo1C", 55],
	["Land_Misc_Cargo1D", 55],
	["Land_Misc_Cargo1E", 55],
	["Land_Misc_Cargo1F", 55],
	["Land_Misc_Cargo1G", 55],
	["Base_WarfareBContructionSite", 55],
	["Misc_cargo_cont_net1", 13],
	["Misc_cargo_cont_net2", 23],
	["Misc_cargo_cont_net3", 35],
	["Misc_cargo_cont_small", 25],
	["Misc_cargo_cont_small2", 20],
	["Misc_cargo_cont_tiny", 15],
	
	["ACamp", 1.5],
	["Camp", 8],
	["CampEast", 8],
	["MASH", 8],
	
	["SpecialWeaponsBox", 3],
	["GuerillaCacheBox", 2],
	["LocalBasicWeaponsBox", 4],
	["LocalBasicAmmunitionBox", 2],
	["RULaunchersBox", 3],
	["RUOrdnanceBox", 3],
	["RUBasicWeaponsBox", 5],
	["RUSpecialWeaponsBox", 6],
	["RUVehicleBox", 16],
	["RUBasicAmmunitionBox", 2],
	["USLaunchersBox", 3],
	["USOrdnanceBox", 3],
	["USBasicWeaponsBox", 5],
	["USSpecialWeaponsBox", 6],
	["USVehicleBox", 16],
	["USBasicAmmunitionBox", 2],
	
	["TargetE", 1],
	["TargetEpopUp", 1],
	["TargetPopUpTarget", 1],
	
	["ACRE_OE_303", 10],
	
	["FoldChair", 0.5],
	["FoldTable", 0.5],
	["Barrels", 6],
	["Wooden_barrels", 6],
	["BarrelBase", 2],
	["Fuel_can", 1],
	["Notice_board", 0.5],
	["Pallets_comlumn", 2],
	["Unwrapped_sleeping_bag", 2],
	["Wheel_barrow", 2],
	["RoadCone", 0.2],
	["Sign_1L_Border", 0.2],
	["Sign_Danger", 0.2],
	["Suitcase", 0.2],
	["SmallTable", 0.2],

/****** Arrowhead ******/

	["Sign_Checkpoint_US_EP1", 1],
	["Land_fort_rampart_EP1", 10],
	["Land_Fort_Watchtower_EP1", 20],
	["Land_fortified_nest_small_EP1", 5],
	["Land_fortified_nest_big_EP1", 10],
	["Sign_Checkpoint_US_EP1", 1],
	["Sign_Checkpoint_US_EP1", 1],
	["USBasicWeapons_EP1", 5],
	["USBasicAmmunitionBox_EP1", 5],
	["USLaunchers_EP1", 5],
	["USOrdnanceBox_EP1", 5],
	["USVehicleBox_EP1", 10],
	["USSpecialWeapons_EP1", 10]

];

/****** MOVABLE-BY-PLAYER OBJECTS / OBJETS DEPLACABLES PAR LE JOUEUR ******/

/**
 * List of class names of objects moveables by player.
 * Liste des noms de classes des objets transportables par le joueur.
 */
R3F_LOG_CFG_objets_deplacables =
[
	// e.g. : "MyMovableObjectClassName1", "MyMovableObjectClassName2"
	"Land_Pneu",
	"SatPhone", // Needed for the R3F_ARTY module (arty HQ) (nécessaire pour le module R3F_ARTY (PC d'arti))
	"StaticWeapon",
	
	"aawWpnsBox_F88SA2",
	"aawWpnsBox_F88_1",
	"aawWpnsBox_LMG",
	"aawWpnsBox_AA_D",
	
	
	"RubberBoat",
	
	"FlagCarrierSmall",
	
	"Land_BagFenceCorner",
	"RoadBarrier_light",
	"FlagCarrierCore",
	"Hedgehog",
	"Hhedgehog_concrete",
	"Hhedgehog_concreteBig",
	"Land_fortified_nest_small",
	"Land_fortified_nest_big",
	"Land_Fort_Watchtower",
	"Fort_Barracks_USMC",
	"Land_fort_rampart",
	"Land_fort_artillery_nest",

	"Land_fort_bagfence_long",
	"Land_fort_bagfence_corner",
	"Land_fort_bagfence_round",
	"Fort_Barricade",
	"Land_CamoNet_NATO",
	"Fort_RazorWire",
	"Hedgehog_EP1",
	"Camp_base",
	"ReammoBox",
	
	"TargetE",
	"TargetEpopUp",
	"TargetPopUpTarget",
	
	"ACRE_OE_303",
	"Land_Misc_deerstand",
	
	"FoldChair",
	"FoldTable",
	"BarrelBase",
	"Fuel_can",
	"Notice_board",
	"Pallets_comlumn",
	"Unwrapped_sleeping_bag",
	"Wheel_barrow",
	"RoadCone",
	"Sign_1L_Border",
	"Sign_Danger",
	"Suitcase",
	"SmallTable",
	
	"Land_HBarrier1",
	"Land_HBarrier3",
	"Land_HBarrier5",
	"Base_WarfareBBarrier5x",
	"Land_HBarrier_large",

	"MASH",
	
	"Sign_Checkpoint_US_EP1",
	"Land_fort_rampart_EP1",
	"Land_Fort_Watchtower_EP1",
	"Land_fortified_nest_small_EP1",
	"Land_fort_artillery_nest_EP1",
	"Land_fortified_nest_big_EP1",
	"MASH_EP1",
	"Land_CamoNet_NATO_EP1",
	"Land_CamoNetB_NATO_EP1",
	"Land_CamoNetVar_NATO_EP1",
	"Sign_Checkpoint_US_EP1",
	"Sign_Checkpoint_US_EP1",
	"USBasicWeapons_EP1",
	"USBasicAmmunitionBox_EP1",
	"USLaunchers_EP1",
	"USOrdnanceBox_EP1",
	"USVehicleBox_EP1",
	"USSpecialWeapons_EP1"
];

/*
 * List of files adding objects in the arrays of logistics configuration (e.g. R3F_LOG_CFG_remorqueurs)
 * Add an include to the new file here if you want to use the logistics with a new addon.
 * 
 * Liste des fichiers ajoutant des objets dans les tableaux de fonctionnalités logistiques (ex : R3F_LOG_CFG_remorqueurs)
 * Ajoutez une inclusion vers votre nouveau fichier ici si vous souhaitez utilisez la logistique avec un nouvel addon.
 */
 
 
 //ARMA CO Config (beware to check for duplicates when removing vehicles)
 
R3F_LOG_CFG_remorqueurs = R3F_LOG_CFG_remorqueurs +
[
	"TowingTractor",
	"Tractor",
	"Kamaz_Base",
	"MTVR",
	"GRAD_Base",
	"Ural_Base",
	"V3S_Base",
	"BRDM2_Base",
	"BTR90_Base",
	"GAZ_Vodnik_HMG",
	"LAV25_Base",
	"StrykerBase_EP1",
	"M2A2_Base",
	"MLRS"
];

R3F_LOG_CFG_objets_remorquables = R3F_LOG_CFG_objets_remorquables +
[
	"M119",
	"D30_base",
	"ZU23_base",
	"A10",
	"A10_US_EP1"
];

R3F_LOG_CFG_heliporteurs = R3F_LOG_CFG_heliporteurs +
[
	"CH47_base_EP1",
	"AW159_Lynx_BAF",
	"Mi17_base",
	"Mi24_Base",
	"UH1H_base",
	"UH1_Base",
	"UH60_Base",
	"MV22"
];


R3F_LOG_CFG_objets_heliportables = R3F_LOG_CFG_objets_heliportables +
[
	"ReammoBox",
	"ATV_Base_EP1",
	"HMMWV_Base",
	"Ikarus_TK_CIV_EP1",
	"Lada_base",
	"LandRover_Base",
	"Offroad_DSHKM_base",
	"Pickup_PK_base",
	"S1203_TK_CIV_EP1",
	"SUV_Base_EP1",
	"SkodaBase",
	"TowingTractor",
	"Tractor",
	"Kamaz_Base",
	"MTVR",
	"GRAD_Base",
	"Ural_Base",
	"Ural_ZU23_Base",
	"V3S_Base",
	"UAZ_Base",
	"VWGolf",
	"Volha_TK_CIV_Base_EP1",
	"BTR40_MG_base_EP1",
	"hilux1_civil_1_open",
	"hilux1_civil_3_open_EP1",
	"D30_base",
	"M119",
	"ZU23_base",
	"Boat",
	"Fishing_Boat",
	"SeaFox",
	"Smallboat_1",
	"Land_Misc_Cargo1A_EP1",
	"Land_Misc_Cargo1B",
	"Land_Misc_Cargo1B_EP1",
	"Land_Misc_Cargo1C",
	"Land_Misc_Cargo1C_EP1",
	"Land_Misc_Cargo1D",
	"Land_Misc_Cargo1D_EP1",
	"Land_Misc_Cargo1E",
	"Land_Misc_Cargo1E_EP1",
	"Land_Misc_Cargo1Eo_EP1",
	"Land_Misc_Cargo1F",
	"Land_Misc_Cargo1G",
	"Land_Misc_Cargo2A_EP1",
	"Land_Misc_Cargo2B",
	"Land_Misc_Cargo2B_EP1",
	"Land_Misc_Cargo2C",
	"Land_Misc_Cargo2C_EP1",
	"Land_Misc_Cargo2D",
	"Land_Misc_Cargo2D_EP1",
	"Land_Misc_Cargo2E",
	"Land_Misc_Cargo2E_EP1",
	"Base_WarfareBContructionSite",
	"Misc_cargo_cont_net1",
	"Misc_cargo_cont_net2",
	"Misc_cargo_cont_net3",
	"Misc_cargo_cont_small",
	"Misc_cargo_cont_small2",
	"Misc_cargo_cont_tiny"
];

R3F_LOG_CFG_transporteurs = R3F_LOG_CFG_transporteurs +
[
	["CH47_base_EP1", 120],
	["AW159_Lynx_BAF", 35],
	["AH6_Base_EP1", 25],
	["Mi17_base", 60],
	["Mi24_Base", 50],
	["UH1H_base", 35],
	["UH1_Base", 30],
	["UH60_Base", 40],
	["An2_Base_EP1", 40],
	["C130J", 150],
	["MV22", 80],
	["ATV_Base_EP1", 5],
	["HMMWV_Avenger", 5],
	["HMMWV_M998A2_SOV_DES_EP1", 12],
	["HMMWV_Base", 18],
	["Ikarus", 50],
	["Lada_base", 10],
	["LandRover_Base", 15],
	["Offroad_DSHKM_base", 15],
	["Pickup_PK_base", 15],
	["S1203_TK_CIV_EP1", 20],
	["SUV_Base_EP1", 15],
	["SkodaBase", 10],
	["TowingTractor", 5],
	["Tractor", 5],
	["KamazRefuel", 10],
	["Kamaz", 50],
	["Kamaz_Base", 35],
	["MAZ_543_SCUD_Base_EP1", 10],
	["MtvrReammo", 35],
	["MtvrRepair", 35],
	["MtvrRefuel", 10],
	["MTVR", 120],
	["GRAD_Base", 10],
	["Ural_ZU23_Base", 12],
	["Ural_CDF", 50],
	["Ural_INS", 50],
	["UralRefuel_Base", 10],
	["Ural_Base", 35],
	["V3S_Refuel_TK_GUE_EP1", 10],
	["V3S_Civ", 35],
	["V3S_Base_EP1", 50],
	["UAZ_Base", 10],
	["VWGolf", 8],
	["Volha_TK_CIV_Base_EP1", 8],
	["BRDM2_Base", 15],
	["BTR40_MG_base_EP1", 15],
	["BTR90_Base", 25],
	["GAZ_Vodnik_HMG", 25],
	["LAV25_Base", 25],
	["StrykerBase_EP1", 25],
	["hilux1_civil_1_open", 12],
	["hilux1_civil_3_open_EP1", 12],
	["Motorcycle", 3],
	["2S6M_Tunguska", 10],
	["M113_Base", 12],
	["M1A1", 5],
	["M2A2_Base", 15],
	["MLRS", 8],
	["T34", 5],
	["T55_Base", 5],
	["T72_Base", 5],
	["T90", 5],
	["AAV", 12],
	["BMP2_Base", 7],
	["BMP3", 7],
	["ZSU_Base", 5],
	["RHIB", 10],
	["RubberBoat", 5],
	["Fishing_Boat", 10],
	["SeaFox", 5],
	["Smallboat_1", 8],
	["Fort_Crate_wood", 5],
	["Land_Misc_Cargo1A_EP1", 100],
	["Land_Misc_Cargo1B", 100],
	["Misc_Cargo1B_military", 100],
	["Land_Misc_Cargo1B_EP1", 100],
	["Land_Misc_Cargo1C", 100],
	["Land_Misc_Cargo1C_EP1", 100],
	["Land_Misc_Cargo1D", 100],
	["Land_Misc_Cargo1D_EP1", 100],
	["Land_Misc_Cargo1E", 100],
	["Land_Misc_Cargo1E_EP1", 100],
	["Land_Misc_Cargo1Eo_EP1", 100],
	["Land_Misc_Cargo1F", 100],
	["Land_Misc_Cargo1G", 100],
	["Land_Misc_Cargo2A_EP1", 200],
	["Land_Misc_Cargo2B", 200],
	["Land_Misc_Cargo2B_EP1", 200],
	["Land_Misc_Cargo2C", 200],
	["Land_Misc_Cargo2C_EP1", 200],
	["Land_Misc_Cargo2D", 200],
	["Land_Misc_Cargo2D_EP1", 200],
	["Land_Misc_Cargo2E", 200],
	["Land_Misc_Cargo2E_EP1", 200],
	["Base_WarfareBContructionSite", 100],
	["Misc_cargo_cont_net1", 18],
	["Misc_cargo_cont_net2", 36],
	["Misc_cargo_cont_net3", 60],
	["Misc_cargo_cont_small", 50],
	["Misc_cargo_cont_small2", 40],
	["Misc_cargo_cont_tiny", 35]
];

R3F_LOG_CFG_objets_transportables = R3F_LOG_CFG_objets_transportables +
[
	["SatPhone", 1], // Needed for the R3F_ARTY module (arty HQ) (nécessaire pour le module R3F_ARTY (PC d'arti))
	["Pchela1T", 15],
	["ATV_Base_EP1", 20],
	["FoldChair_with_Cargo", 1],
	["MMT_base", 1],
	["Old_bike_base_EP1", 1],
	["M1030", 5],
	["Old_moto_base", 5],
	["TT650_Base", 5],
	["Igla_AA_pod_East", 7],
	["Stinger_Pod_base", 7],
	["Metis", 4],
	["SPG9_base", 4],
	["TOW_TriPod", 5],
	["TOW_TriPod_Base", 5],
	["AGS_base", 4],
	["MK19_TriPod", 4],
	["DSHKM_base", 4],
	["KORD_Base", 5],
	["M2StaticMG_base", 4],
	["WarfareBMGNest_M240_base", 10],
	["WarfareBMGNest_PK_Base", 10],
	["2b14_82mm", 4],
	["M252", 4],
	["Warfare2b14_82mm_Base", 4],
	["StaticSEARCHLight", 4],
	["FlagCarrierSmall", 1],
	["Fort_Crate_wood", 2],
	["Fort_RazorWire", 2],
	["Gunrack1", 3],
	["Base_WarfareBBarrier10xTall", 10],
	["Base_WarfareBBarrier10x", 7],
	["Base_WarfareBBarrier5x", 5],
	["Fort_EnvelopeBig", 1],
	["Fort_EnvelopeSmall", 1],
	["Land_A_tent", 2],
	["Land_Antenna", 4],
	["Land_Fire_barrel", 1],
	["Land_GuardShed", 3],
	["Land_Misc_Cargo1A_EP1", 110],
	["Land_Misc_Cargo1B", 110],
	["Misc_Cargo1B_military", 110],
	["Land_Misc_Cargo1B_EP1", 110],
	["Land_Misc_Cargo1C", 110],
	["Land_Misc_Cargo1C_EP1", 110],
	["Land_Misc_Cargo1D", 110],
	["Land_Misc_Cargo1D_EP1", 110],
	["Land_Misc_Cargo1E", 110],
	["Land_Misc_Cargo1E_EP1", 110],
	["Land_Misc_Cargo1F", 110],
	["Land_Misc_Cargo1G", 110],
	["Land_Misc_Cargo2A_EP1", 220],
	["Land_Misc_Cargo2B", 220],
	["Land_Misc_Cargo2B_EP1", 220],
	["Land_Misc_Cargo2C", 220],
	["Land_Misc_Cargo2C_EP1", 220],
	["Land_Misc_Cargo2D", 220],
	["Land_Misc_Cargo2D_EP1", 220],
	["Land_Misc_Cargo2E", 220],
	["Land_Misc_Cargo2E_EP1", 220],
	["Land_fort_bagfence_corner", 2],
	["Land_fort_bagfence_long", 2],
	["Land_fort_bagfence_round", 3],
	["Land_fortified_nest_small", 6],
	["Land_tent_east", 6],
	["Land_BagFenceCorner", 2],
	["Land_HBarrier_large", 3],
	["Land_Toilet", 3],
	["RoadBarrier_light", 2],
	["WarfareBunkerSign", 1],
	["Base_WarfareBContructionSite", 110],
	["ACamp", 3],
	["Camp", 5],
	["CampEast", 6],
	["MASH", 5],
	["FlagCarrier", 1],
	["FlagCarrierChecked", 1],
	["Hedgehog", 3],
	["Hhedgehog_concrete", 6],
	["Hhedgehog_concreteBig", 9],
	["AmmoCrate_NoInteractive_Base_EP1", 5],
	["Misc_cargo_cont_net1", 40],
	["Misc_cargo_cont_net2", 50],
	["Misc_cargo_cont_net3", 100],
	["Misc_cargo_cont_small", 55],
	["Misc_cargo_cont_small2", 50],
	["Misc_cargo_cont_tiny", 40],
	["RUVehicleBox", 12],
	["TKVehicleBox_EP1", 12],
	["USVehicleBox_EP1", 12],
	["USVehicleBox", 12],
	["ReammoBox", 5],
	["TargetE", 2],
	["TargetEpopup", 2],
	["TargetPopUpTarget", 2],
	["Desk", 1],
	["FoldChair", 1],
	["FoldTable", 1],
	["Land_Barrel_empty", 1],
	["Land_Barrel_sand", 1],
	["Land_Barrel_water", 1],
	["Land_arrows_yellow_L", 1],
	["Land_arrows_yellow_R", 1],
	["Land_coneLight", 1],
	["BarrelBase", 2],
	["Fuel_can", 1],
	["Notice_board", 1],
	["Pallets_comlumn", 1],
	["Unwrapped_sleeping_bag", 1],
	["Wheel_barrow", 1],
	["RoadCone", 1],
	["Sign_1L_Border", 1],
	["Sign_Danger", 1],
	["SmallTable", 1],
	["EvPhoto", 1],
	["MetalBucket", 1],
	["Notebook", 1],
	["Radio", 1],
	["SmallTV", 1],
	["Land_Chair_EP1", 1],
	["Suitcase", 1],
	["WeaponBagBase_EP1", 3]
];


R3F_LOG_CFG_objets_deplacables = R3F_LOG_CFG_objets_deplacables +
[
	"SatPhone", // Needed for the R3F_ARTY module (arty HQ) (nécessaire pour le module R3F_ARTY (PC d'arti))
	"FoldChair_with_Cargo",
	"StaticWeapon",
	"FlagCarrierSmall",
	"Fort_Crate_wood",
	"Fort_RazorWire",
	"Gunrack1",
	"Base_WarfareBBarrier5x",
	"Fort_EnvelopeBig",
	"Fort_EnvelopeSmall",
	"Land_A_tent",
	"Land_Antenna",
	"Land_Fire_barrel",
	"Land_GuardShed",
	"Land_fort_bagfence_corner",
	"Land_fort_bagfence_long",
	"Land_fort_bagfence_round",
	"Land_fortified_nest_small",
	"Land_tent_east",
	"Land_HBarrier_large",
	"Land_Toilet",
	"RoadBarrier_light",
	"WarfareBunkerSign",
	"ACamp",
	"Camp",
	"CampEast",
	"MASH",
	"FlagCarrier",
	"FlagCarrierChecked",
	"Hedgehog",
	"Hhedgehog_concrete",
	"Hhedgehog_concreteBig",
	"AmmoCrate_NoInteractive_Base_EP1",
	"ReammoBox",
	"TargetE",
	"TargetEpopup",
	"TargetPopUpTarget",
	"Desk",
	"FoldChair",
	"FoldTable",
	"Land_Barrel_empty",
	"Land_Barrel_sand",
	"Land_Barrel_water",
	"Land_arrows_yellow_L",
	"Land_arrows_yellow_R",
	"Land_coneLight",
	"BarrelBase",
	"Fuel_can",
	"Notice_board",
	"Pallets_comlumn",
	"Unwrapped_sleeping_bag",
	"Wheel_barrow",
	"RoadCone",
	"Sign_1L_Border",
	"Sign_Danger",
	"SmallTable",
	"EvPhoto",
	"MetalBucket",
	"Notebook",
	"Radio",
	"SmallTV",
	"Land_Chair_EP1",
	"Suitcase",
	"WeaponBagBase_EP1"
];
 
 
// BAF content

R3F_LOG_CFG_remorqueurs = R3F_LOG_CFG_remorqueurs +
[
	"BAF_Jackal2_Base",
	"BAF_Offroad_Base"
];

R3F_LOG_CFG_objets_remorquables = R3F_LOG_CFG_objets_remorquables +
[
	"BAF_Jackal2_Base",
	"BAF_Offroad_Base"	
];

R3F_LOG_CFG_heliporteurs = R3F_LOG_CFG_heliporteurs +
[
	"BAF_Merlin_HC3_D"	
];

R3F_LOG_CFG_objets_heliportables = R3F_LOG_CFG_objets_heliportables +
[
	"BAF_Jackal2_Base",
	"BAF_Offroad_Base"	
];

R3F_LOG_CFG_transporteurs = R3F_LOG_CFG_transporteurs +
[
	["BAF_Merlin_HC3_D", 50],
	["BAF_Jackal2_Base", 15],
	["BAF_Offroad_Base", 15]
];

R3F_LOG_CFG_objets_transportables = R3F_LOG_CFG_objets_transportables +
[
	["BAF_GMG_Tripod_D", 4]
];

R3F_LOG_CFG_objets_deplacables = R3F_LOG_CFG_objets_deplacables +
[
	
]; 
 

// ACE OA est-il présent ? (is ACE OA activated ?)
if (isClass (configFile >> "CfgVehicles" >> "ACE_Required_Logic")) then
{

	R3F_LOG_CFG_remorqueurs = R3F_LOG_CFG_remorqueurs +
	[
		"ACE_Truck5tMG_Base"
	];

	R3F_LOG_CFG_objets_remorquables = R3F_LOG_CFG_objets_remorquables +
	[
		"ACE_EASA_Vehicle"
	];
	

	R3F_LOG_CFG_heliporteurs = R3F_LOG_CFG_heliporteurs +
	[
		// Aucun lifteur fourni par ACE OA
	];
	

	R3F_LOG_CFG_objets_heliportables = R3F_LOG_CFG_objets_heliportables +
	[
		"ACE_Truck5tMG_Base",
		"ACE_Lifeboat",
		"ACE_EASA_Vehicle"
	];

	R3F_LOG_CFG_transporteurs = R3F_LOG_CFG_transporteurs +
	[
		["ACE_Truck5tRepair", 35],
		["ACE_Truck5tRepair_Base", 35],
		["ACE_Truck5tReammo", 35],
		["ACE_Truck5tReammo_Base", 35],
		["ACE_Truck5tRefuel", 10],
		["ACE_Truck5tRefuel_Base", 10],
		["ACE_Truck5tMG_Base", 120],
		["ACE_UralReammo_TK_EP1", 35],
		["ACE_UralRefuel_TK_EP1", 10],
		["ACE_UralRepair_TK_EP1", 35],
		["ACE_V3S_Reammo_TK_GUE_EP1", 35],
		["ACE_V3S_Refuel_TK_GUE_EP1", 10],
		["ACE_V3S_Repair_TK_GUE_EP1", 35],
		["ACE_Lifeboat", 5]
	];
	
	R3F_LOG_CFG_objets_transportables = R3F_LOG_CFG_objets_transportables +
	[
		["ACE_Stretcher", 2],
		["ACE_KonkursTripod_NoGeo", 5],
		["ACE_M3Tripod", 3],
		["ACE_Konkurs", 7],
		["ACE_SpottingScope", 3],
		["ACE_Lifeboat", 7],
		["ACE_Sandbag_NoGeo", 1],
		["ACE_BandageBoxWest", 4],
		["ACE_CSW_Box_Base", 12],
		["ACE_RuckBox_East", 12],
		["ACE_RuckBox_Ind", 12],
		["ACE_RUCK_Box_Base", 35],
		["ACE_Rope_Box_Base", 35],
		["ACE_SandBox", 35],
		["ACE_GuerillaCacheBox", 9],
		["ACE_RUBasicAmmunitionBox", 5],
		["ACE_RUOrdnanceBox", 9],
		["ACE_RUVehicleBox", 40],
		["ACE_RUBasicWeaponsBox", 15],
		["ACE_RULaunchers", 9],
		["ACE_RULaunchersBox", 9],
		["ACE_RUSpecialWeaponsBox", 15],
		["ACE_LocalBasicAmmunitionBox", 5],
		["ACE_LocalBasicWeaponsBox", 10],
		["ACE_EmptyBox", 5],
		["ACE_HuntIRBox", 4],
		["ACE_KnicklichtBox", 4],
		["ACE_USBasicAmmunitionBox", 4],
		["ACE_USOrdnanceBox", 4],
		["ACE_USVehicleBox", 35],
		["ACE_USVehicleBox_EP1", 35],
		["ACE_USBasicWeaponsBox", 12],
		["ACE_USLaunchersBox", 9],
		["ACE_SpecialWeaponsBox", 12],
		["ACE_USSpecialWeaponsBox", 12],
		["ACE_TargetBase", 2],
		["ACE_UsedTubes", 2],
		["ACE_MS2000_STROBE_OBJECT", 1]
	];
	
	R3F_LOG_CFG_objets_deplacables = R3F_LOG_CFG_objets_deplacables +
	[
		"ACE_Stretcher",
		"ACE_Lifeboat",
		"ACE_Sandbag_NoGeo",
		"ACE_TargetBase",
		"ACE_UsedTubes",
		"ACE_MS2000_STROBE_OBJECT"
	];
};