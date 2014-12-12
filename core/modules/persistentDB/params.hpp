class persistentDBHeader {
        title = "    Persistent DB (switch off NOMAD)"; 
        values[]= {1,0}; 
        texts[]= {"On","Off"}; 
        default = 1;
};
class mpdb_save_delay_server {
        title = "        Persistent Auto-Save (Server)"; 
        values[]= {120,300,600,1800,3600,7200,14400,0}; 
        texts[]= {"2 mins","5 mins","10 mins","30 mins","1 hour","2 hours","4 hours","Off"}; 
        default = 600;
};
class mpdb_save_delay_player {
        title = "        Persistent Auto-Save (Player)"; 
        values[]= {120,300,600,1800,3600,0}; 
        texts[]= {"2 mins","5 mins","10 mins","30 mins","1 hour","Off"}; 
        default = 300;
};
class mpdb_teleport_player {
        title = "        Teleport player to last saved position"; 
        values[]= {2,1,0}; 
        texts[]= {"Prompt Player","Auto","No"}; 
        default = 1;
};
class mpdb_date_enabled {
        title = "        Persistent Date"; 
        values[]= {1,0}; 
        texts[]= {"On","Off"}; 
        default = 1;
};
class mpdb_markers_enabled {
        title = "        Persistent Markers"; 
        values[]= {1,0}; 
        texts[]= {"On","Off"}; 
        default = 1;
};
class mpdb_weapons_enabled {
        title = "        Persistent Weapons"; 
        values[]= {1,0}; 
        texts[]= {"On","Off"}; 
        default = 1;
};
class mpdb_landvehicles_enabled {
        title = "        Persistent Vehicles"; 
        values[]= {1,0}; 
        texts[]= {"On","Off"}; 
        default = 1;
};
class mpdb_objects_enabled {
        title = "        Persistent Objects"; 
        values[]= {1,0}; 
        texts[]= {"On","Off"}; 
        default = 1;
};
class mpdb_objects_contents_enabled {
        title = "        Persistent Vehicle/Object Contents"; 
        values[]= {1,0}; 
        texts[]= {"On","Off"}; 
        default = 1;
};
class mpdb_locations_enabled {
        title = "        Persistent Locations"; 
        values[]= {1,0}; 
        texts[]= {"On","Off"}; 
        default = 1;
};
class mpdb_AAR_enabled {
        title = "        Persistent After Action Reports"; 
        values[]= {1,0}; 
        texts[]= {"On","Off"}; 
        default = 1;
};
class mpdb_tasks_enabled {
        title = "        Persistent Tasks/Objectives"; 
        values[]= {1,0}; 
        texts[]= {"On","Off"}; 
        default = 1;
};
class mpdb_killStats_enabled {
        title = "        Record Kill Stats"; 
        values[]= {1,0}; 
        texts[]= {"On","Off"}; 
        default = 1;
};
class mpdb_persistentScores_enabled {
        title = "        Persistent Scores"; 
        values[]= {1,0}; 
        texts[]= {"On","Off"}; 
        default = 1;
};
class mpdb_globalScores_enabled {
        title = "        Persistent All Time Scores"; 
        values[]= {1,0}; 
        texts[]= {"On","Off"}; 
        default = 1;
};
class mpdb_log_enabled {
        title = "        Enable Logging"; 
        values[]= {1,0}; 
        texts[]= {"On","Off"}; 
        default = 1;
};