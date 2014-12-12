if(!isServer) exitWith {};
private["_count"];
_count = 0;
{
        private["_pos"];
        if(_x != leader _this && !("Driver" in assignedVehicleRole _x)) then {
                _x disableAI "TARGET";
                _x disableAI "AUTOTARGET";
                _x disableAI "MOVE";
                _x disableAI "ANIM";
                _x disableAI "FSM";
                
                _x enableSimulation false;
                _x allowDamage false;
		if (vehicle _x == _x) then {
	                _pos = getPosATL _x;
        	        _pos set [2, -100];
	                _x setPosATL _pos;
		};
                _count = _count + 1;
	} else {
                _x allowDamage true;
                _x enableSimulation true;
                
                _x enableAI "TARGET";
                _x enableAI "AUTOTARGET";
                _x enableAI "MOVE";
                _x enableAI "ANIM";
                _x enableAI "FSM";
        };
} forEach units _this;

if(_count > 0) then {
	private["_c","_t"];
	_c = {!(simulationEnabled _x)} count allUnits;
	_t = count allUnits;
	diag_log format["MSO-%1 NOUJAY Cached(cached): %2/%3 %4%5", time, _c, _t, floor((_c/_t) * 100),"%"];
};
