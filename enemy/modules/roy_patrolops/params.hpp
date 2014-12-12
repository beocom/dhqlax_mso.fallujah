class PO2_ON {
	title = "    OCB Patrol Ops 2"; 
	values[]= {1, 0}; 
	texts[]= {"On","Off"}; 
	default = 1;
};
class MISSIONTYPE_PO { // MISSION TYPE
	title= "        Mission Type Patrol Ops";
	values[]={0,1,2,3,4,5,6,7,8};
	default=7;
	texts[]={"Off","Domination","Reconstruction","Search and Rescue","Mix Standard","Mix Hard","Target Capture","MSO Auto (needs RMM_Enpop)","MSO Sniper Operations"};
};
class MISSIONTYPE_AIR { // MISSION TYPE
	title= "        Mission Type Air Ops";
	values[]={0,1};
	default=0;
	texts[]={"Off","Experimental"};
};
class MISSIONCOUNT { // MISSION COUNT
	title="        Number of Missions";
	values[]={1,3,5,7,9,15,20,9999};
	default=9999;
	texts[]={"1","3","5","7","9","15","20","unlimited"};
};
class PO2_EFACTION { // ENEMY FACTION
	title="        Enemy Faction";
	values[]={0,1,2,3,4,5,6};
	default=0;
	texts[]={"Takistani Army","Takistani Guerillas","Russia","Guerillas","CWR2 RU","CWR2 FIA","Tigerianne"};
};
class PO2_IFACTION { // INS FACTION
	title="        Insurgents Faction";
	values[]={0,1,2,3};
	default=0;
	texts[]={"Takistani Insurgents","Takistani Guerillas","European Insurgents","Guerillas"};
};
class MISSIONDIFF { // MISSION Difficulty
	title="        Difficulty";
	values[]={1,2,3,4};
	default=2;
	texts[]={"Easy","Medium","Hard","Experienced"};
};
class AMBAIRPARTOLS { // AMBiENT Air Patrols
	title="        Ambient Air Patrols";
	values[]={0,1};
	default=0;
	texts[]={"Off","On"};
};

