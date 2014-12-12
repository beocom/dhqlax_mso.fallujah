class tup_ied_header{
        title = "    Ambient IEDs and Suicide Bombers"; 
        values[]= {0,1}; 
        texts[]= {"Off","On"}; 
        default = 1;
};
class tup_ied_enemy {
        title = "        Towns with IEDs"; 
        values[]= {0,1}; 
        texts[]= {"Random","Enemy Occupied Only"}; 
        default = 0;
};
class tup_ied_threat {
        title = "        Ambient IED Threat"; 
        values[]= {0,50,100,200,350}; 
        texts[]= {"None","Low","Med","High","Extreme"}; 
        default = 50;
};
class tup_suicide_threat {
        title = "        Ambient Suicide Bomber Threat"; 
        values[]= {0,10,20,30,50}; 
        texts[]= {"None","Low","Med","High","Extreme"}; 
        default = 10;
};
class tup_vbied_threat {
        title = "        Ambient VB-IEDs"; 
        values[]= {0,5,10,15,30}; 
        texts[]= {"None","Low","Med","High","Extreme"}; 
        default = 5;
};
class tup_ied_eod{
        title = "        Integrate with EOD Add-on (if available)"; 
        values[]= {0,1}; 
        texts[]= {"Off","On"}; 
        default = 1;
};
