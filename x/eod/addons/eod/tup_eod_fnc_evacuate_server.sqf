if !(isServer) exitwith {diag_log "EOD script not running on server. Exiting";};
private ["_range","_rangeMin","_rangeMax","_probability","_object"];

_range = _this select 0;
_probability = _this select 1;
_object = _this select 2;
_object = vehicle _object;

if (count _range != 2) exitWith{};
_rangeMin = _range select 0;
_rangeMax = _range select 1;

private ["_nearMen", "_i","_thisMan","_civGroup","_segno","_posX","_posY","_evacuatePos"];
_nearMen = (getPos _object) nearEntities ["Man",_rangeMin];
  for "_y" from 0 to (count _nearMen - 1) do {
	
	_thisMan = _nearMen select _y;
    _civGroup = group _thisMan;
	
	if (side _thisMan == CIVILIAN && _thisMan == leader (group _thisMan) && isNil {_thisMan getVariable "reezo_ied_triggerman"} && isNil {_thisMan getVariable "reezo_ied_trigger"}) then {
		
		_rnd = random 1;
		
		if (_rnd < _probability) then {		

			{
				_x setUnitPos "UP";
				_x playmove "AmovPercMstpSsurWnonDnon";
				_x disableAI "ANIM";
				_x setSkill 0;
			} forEach (units _civGroup);
			
			_segno = random 1;
			if (_segno < 0.5) then { _posX = ((position _thisMan) select 0) + (_rangeMin + _rangeMax)} else { _posX = ((position _thisMan) select 0) - (_rangeMin + _rangeMax) };
			_segno = random 1;
			if (_segno < 0.5) then { _posY = ((position _thisMan) select 1) + (_rangeMin + _rangeMax) } else { _posY = ((position _thisMan) select 1) - (_rangeMin + _rangeMax) };
			
			_evacuatePos = [_posX,_posY];
			
			diag_log format["EOD Server: %1, %2, %3, %4, %5",_object, _thisMan,_civGroup,_evacuatePos];	
			
			{ deleteWaypoint _x } forEach (waypoints _civGroup);
			
			_civGroup addWaypoint [_evacuatePos, 1];
			[_civGroup, 1] setWaypointType "MOVE";
			[_civGroup, 1] setWaypointBehaviour "CARELESS";
			[_civGroup, 1] setWaypointSpeed "FULL";   

			sleep 3;
			
			{
				_x enableAI "ANIM";
			} forEach (units _civGroup);
					
		};
	};
};