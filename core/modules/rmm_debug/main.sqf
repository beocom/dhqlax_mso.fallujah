private ["_t","_pm"];

DEBUG_CHECK = {
	if (ismultiplayer) then {
		((servercommandavailable '#kick') && ((getPlayerUID player) in MSO_R_Admin));
	} else {
		true;
	};
};

if (!isdedicated) then {
        ["player", [mso_interaction_key], -9401, ["core\modules\rmm_debug\fn_menuDef.sqf", "main"]] call CBA_ui_fnc_add;
        ["Debug","if ([] call DEBUG_CHECK) then {createDialog 'RMM_ui_debug'} else {player sidechat 'You need to be logged in as administrator!'}"] call mso_core_fnc_updateMenu;
};

if (debug_mso) then {
        // Mark all enemy units with a red dot
        [] execVM "enemy\scripts\mark_enemy.sqf";
        
        // Show player spawn distance
        if !(isnull player) then {
            	if (isnil "rmm_ep_spawn_dist") then {rmm_ep_spawn_dist = 1500;};
                _t = format["player_%1", player];
                _pm = [_t, position player, "ELLIPSE", [rmm_ep_spawn_dist,rmm_ep_spawn_dist], "TEXT:", _t, "BRUSH:", "Border", "COLOR:", "ColorGreen"] call CBA_fnc_createMarker;	
                [_pm] spawn {
                        private ["_pm"];
                        _pm = _this select 0;
                        while {true} do {
                                _pm  setmarkerpos position player;
                                sleep 0.3;
                        };
                };
        };
};

displayStats = {
        private ["_avgF","_minF","_maxU","_avgU","_curU"];
        _avgF = _this select 0;
        _minF = _this select 1;
        _maxU = _this select 2;
        _avgU = _this select 3;
        _curU = _this select 4;
        hint format["Server FPS(Avg/Min): %1/%2\nUnits(Max/Avg/Cur): %3/%4/%5\nGroups: %6", _avgF, _minF, _maxU, _avgU, _curU, count allGroups];
        diag_log format["CRBSERVERFPS,%1,%2,%3,%4,%5,%6,%7", time, _avgF, _minF, _maxU, _avgU, _curU, count allGroups];
};	

if(isNil "debug_serverfps") then {debug_serverfps = 0;};

if(isServer && debug_serverfps != 0) then{
        waitUntil{!isNil "bis_fnc_init"};
        diag_log "CRBSERVERFPS,Time,FPSAvg,FPSMin,UnitsMax,UnitsAvg,UnitsCur,allGroups";
        [] spawn {
                private ["_testTime","_fpsmin","_FPSminArray","_currFrameNo","_maxU","_startTime","_startFrameNo","_endTime","_endFrameNo","_serverfps","_fpsavg","_allunits","_avgU","_i"];
                _i = 0;
                _fpsavg = 0;
                _maxU = 0;
                _avgU = 0;
                while{true} do {
                        
                        //test length - time in seconds taken as first record in argument
                        _testTime = debug_serverfps;
                        
                        if (isnil ("_testTime")) then {_testTime=60;};
                        
                        //minimal fps is calculated from worst frame time only
                        _fpsmin = 1000;
                        
                        _startTime = diag_tickTime;
                        _startFrameNo = diag_frameno;
                        
                        _currFrameNo = diag_frameno;
                        
                        _FPSminArray = [];
                        
                        while {diag_tickTime < (_startTime + _testTime)} do
                        {
                                while {(_currFrameNo + 16) > diag_frameno;} do {Sleep(0.001);}; //we want to call diag_fpsmin with all frames (diag_fpsmin uses last 16 frames)
                                //player globalChat format["%1", diag_frameno];
                                if (_fpsmin > diag_fpsmin) then {_fpsmin = diag_fpsmin};
                                
                                _FPSminArray = [diag_fpsmin] + _FPSminArray;
                                _currFrameNo = diag_frameno;
                        };
                        
                        _endTime = diag_tickTime;
                        _endFrameNo = diag_frameno;
                        
                        private ["_testTimeAct","_frameCnt"];
                        _testTimeAct = (_endTime - _startTime);
                        _frameCnt = (_endFrameNo - _startFrameNo);
                        
                        _serverfps = _frameCnt / _testTimeAct;
                        _fpsavg = (_fpsavg *  _i + _serverfps) / (_i + 1);
                        _allunits = count allUnits;
                        if (_maxU < _allunits) then {_maxU = _allunits};
                        _avgU = (_avgU *  _i + _allunits) / (_i + 1);
                        _i = _i + 1;
                        
                        [0, [_fpsavg, _fpsmin, _maxU, _avgU, _allunits], displayStats] call mso_core_fnc_ExMP;
                };
        };
};
