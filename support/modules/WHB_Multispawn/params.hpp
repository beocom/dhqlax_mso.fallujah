class mobileHQHeader {
        title = "    Mobile HQ"; 
        values[]= {0}; 
        texts[]= {" "}; 
        default = 0;
};
class deployment_Time {	
	title="        Deployment Delay"; 
	values[] = {5,300,600,1800}; 
	texts[] = {"Debug","5 minutes","10 minutes","30 minutes"}; 
	default = 300; 
};

class undeployment_Time {
	title="        Pack up Delay"; 
	values[] = {5,300,600,1800}; 
	texts[] = {"Debug","5 minutes","10 minutes","30 minutes"}; 
	default = 300; 
};

class jipMarkers_enabled {
	title="        Create JIP Marker when deployed?"; 
	values[] = {1,0}; 
	texts[] = {"Yes","No"}; 
	default = 1; 
};