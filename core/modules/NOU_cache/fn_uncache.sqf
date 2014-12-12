if(!isServer) exitWith {};
private ["_count"];
_count = 0;
{
        if(_x != leader _this && !("Driver" in assignedVehicleRole _x)) then {
		if (vehicle _x == _x) then {
	                _x setPosATL (formationPosition _x);
		};
                _x allowDamage true;
                _x enableSimulation true;
                
                _x enableAI "TARGET";
                _x enableAI "AUTOTARGET";
                _x enableAI "MOVE";
                _x enableAI "ANIM";
                _x enableAI "FSM";
                
                _count = _count + 1;
        };
} forEach units _this;

if(_count > 0) then {
	private["_c","_t"];
	_c = {!(simulationEnabled _x)} count allUnits;
	_t = count allUnits;
	diag_log format["MSO-%1 NOUJAY Cached(uncache): %2/%3 %4%5", time, _c, _t, floor((_c/_t) * 100),"%"];
};
