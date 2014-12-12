private ["_currentDate"];

waitUntil{!isNil "bis_fnc_init"};

CRB_timeSync = {
        private ["_timeSync","_update","_sdate","_cdate","_syr","_smt","_sdy","_shr","_smn","_cyr","_cmt","_cdy","_chr","_cmn"];
        _sdate = _this;
        _cdate = date;
        
        _syr = _sdate select 0;
        _smt = _sdate select 1;
        _sdy = _sdate select 2;
        _shr = _sdate select 3;
        _smn = _sdate select 4;
        
        _cyr = _cdate select 0;
        _cmt = _cdate select 1;
        _cdy = _cdate select 2;
        _chr = _cdate select 3;
        _cmn = _cdate select 4;
        
        _update = false;
        _timeSync = timeSync;
        
        
        // Do any of the MAJOR date values differ?
        if(
                _syr != _cyr ||
                _smt != _cmt ||
                _sdy != _cdy ||
                _shr != _chr
        ) then {
                // We'll need setDate to sync
                _timeSync = 2;
                _update = true;
        };
        
        // Do just the minutes differ?
        if(_smn != _cmn) then {
                _update = true;
        };
        
        // Do we need to sync?
        if(_update) then {
                switch (_timeSync) do {
                        // Monitor only
                        case 0: {
                                diag_log format["MSO-%1 Time Sync: Monitor S %2 C %3", time, _sdate, _cdate];
                        };
                        // Use skipTime if possible
                        case 1: {
                                skipTime ((_smn - _cmn) / 60);
                                diag_log format["MSO-%1 Time Sync: skipTime S %2 C %3 N %4", time, _sdate, _cdate, date];
                        };
                        // Use setDate
                        case 2: {
                                setDate _sdate;
                                diag_log format["MSO-%1 Time Sync: setDate S %2 C %3 N %4", time, _sdate, _cdate, date];
                        };
                };
        };
};

if (isserver) then {        
        if(isNil "timeSync") then {
                timeSync = 2;
        };
        
        if(isNil "timeOptions") then {
                timeOptions = 0;
        };
        
        if(isNil "timeSeasons") then {
                timeSeasons = 3;
        };
        
        if(isNil "timeHour") then {
                timeHour = 8;
        };
        
        if(isNil "timeMinute") then {
                timeMinute = 0;
        };
        
        // Set server time if required
        switch (timeOptions) do {
                // Original
                case 0: {
                };
                // Random
                case 1: {
                        _currentDate = date;
                        _currentDate set [1, [12,3,6,9] call BIS_fnc_selectRandom];
                        _currentDate set [2, 22];
                        _currentDate set [3, floor(random 24)];
                        _currentDate set [4, floor(random 60)];
                        setDate _currentDate;
                };
                // Custom
                case 2: {
                        _currentDate = date;
                        _currentDate set [1, timeSeasons];
                        _currentDate set [2, 22];
                        _currentDate set [3, timeHour];
                        _currentDate set [4, timeMinute];
                        setDate _currentDate;
                };
        };

	// Time sync off
	if (timeSync == 3) then {
	    diag_log format["MSO-%1 Time Sync off: Date %2", time, date];
	} else {       
	        timeSync spawn {
        	        private ["_delay"];
                	_delay = 1;
                	waitUntil{
                        	CRB_TIME = date;
	                        publicvariable "CRB_TIME";
        	                sleep _delay;
                	        false;
	                };
        	};
        };
};

if(!isDedicated && timeSync != 3) then {
        "CRB_TIME" addPublicVariableEventHandler {CRB_TIME call CRB_timeSync;};
        
        waitUntil{!isNil "CRB_TIME"};
        
        setDate CRB_TIME;
};
