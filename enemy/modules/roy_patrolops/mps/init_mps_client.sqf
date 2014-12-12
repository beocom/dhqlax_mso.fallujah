// Detect ACRE
	[] call compile preprocessFileLineNumbers (mps_path+"func\mps_func_detect_acre.sqf");

waitUntil {!(isNull player)};



