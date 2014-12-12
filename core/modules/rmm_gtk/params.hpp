class gtk_cache_header {
	title = "    AI Caching";
//	values[]= {0,1,2,3}; 
//	texts[]= {"Off","NOUJAY","CEP","OSOM"}; 
	values[]= {0,1,2};
	texts[]= {"Off","NOUJAY","CEP"}; 
	default = 0; 
};
class gtk_cache_distance {
	title = "        Distance caching activates";
	values[]= {1000,1500,2000,3000}; 
	texts[]= {"1000m","1500m","2000m","3000m"}; 
	default = 1500; 
};
class gtk_cache_interval {
	title = "        Delay between checks";
	values[]= {1,2,3,5}; 
	texts[]= {"1 sec","2 sec","3 sec","5 sec"}; 
	default = 3;
};
