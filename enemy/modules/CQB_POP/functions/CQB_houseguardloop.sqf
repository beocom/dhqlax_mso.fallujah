_pos = _this select 0;
_group = _this select 1;
_house = _this select 2;
_bldgpos = _this select 3;
_despawn = _this select 4;
_debug = debug_mso;
  
_cleared = false;
_suspended = false;
_patrol = false;
_movehome = false;
_breakouttimer = 0;

while {!(_cleared) && !(_suspended) && (_breakouttimer < 20)} do {
sleep 2;
	if ({_pos distance _x < 2500} count ([] call BIS_fnc_listPlayers) < 1) then {_breakouttimer = _breakouttimer + 2} else {_breakouttimer = 0};   
	_near = ({_pos distance _x < _despawn} count ([] call BIS_fnc_listPlayers) > 0);
    
    if ((_near) && !(_patrol)) then {
        if (_debug) then {diag_log format["MSO-%1 CQB Population: Telling group %2 to guard house...", time, _group]};
        
        {
        	_x setUnitPos "AUTO";
        	_x setbehaviour "AWARE";
        	dostop _x;
            
           private["_fsm","_hdl"];
           _fsm = "enemy\modules\CQB_POP\functions\HousePatrol.fsm";
           _hdl = [_x, 100, true, 120,false,_pos,_bldgpos] execFSM _fsm;
           _x setVariable ["FSM", [_hdl,_fsm]];
            //0 = [_x, 50, true, 300, _pos,_despawn] spawn MSO_fnc_CQBhousepos;
        } foreach units _group;

        _patrol = true;
        _movehome = false;
    };
    
    if (!(_near) && !(_movehome)) then {
        _patrol = false;
        _movehome = true;
        
        if (_debug) then {diag_log format["MSO-%1 CQB Population: Sending group %2 home...", time, _group]};
        while {(count (waypoints (_group))) > 0} do {deleteWaypoint ((waypoints (_group)) select 0);};
		_endpos = _bldgpos select floor(random count _bldgpos);

        {
            _hdlOut = (_x getvariable "FSM") select 0;
            _hdlOut setFSMVariable ["_abort",true];           
            _x domove _endpos;
		} foreach units _group;
    };
    
	if (_movehome) then {
		{
			if (_x distance _endpos < 4) then {
        	    _x setdamage 1;
       			deletevehicle _x;
      		};
    	} foreach units _group;
    };
if ((count (units _group) == 0) && (_patrol)) then {_house setvariable ["c", true, true]; _cleared = true};
if ((count (units _group) == 0) && (_movehome)) then {_suspended = true};
};
