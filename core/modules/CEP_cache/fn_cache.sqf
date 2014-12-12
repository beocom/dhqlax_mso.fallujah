private ["_count","_cep_typearray"];
if(!isServer) exitWith {};
_count = 0;
_cep_typearray = [];
{
        private["_pos","_cep_vehpos"];
        _cep_vehpos = assignedVehicleRole _x;
        if(_x != leader _this && !("Driver" in _cep_vehpos)) then {
                _cep_typearray set [count _cep_typearray, [
                        typeof _x,
                        weapons _x,
                        magazines _x,
                        typeof (unitbackpack _x),
                        getmagazinecargo (unitbackpack _x),
                        getweaponcargo (unitbackpack _x),
                        rank _x,
                        (leader _x) worldtomodel (position _x),
                        assignedVehicle _x,
                        _cep_vehpos
                ]];
                
                unassignVehicle _x;
                _x setPosATL (position _x);
                deletevehicle _x;
                _x = objNull;
                
                _count = _count + 1;
        };
} forEach units _this;

if (debug_mso) then {
	diag_log format["MSO-%1 CEP Cached: %2 of group:%3 leader:%4", time, _count, _this, typeof leader _this];
};
		
_this setVariable ["CEP_Array", _cep_typearray];

if(_count > 0) then {
        private["_c","_t","_tmp"];
        _c = 0;
        {
                _tmp = _x getVariable "CEP_Array";
                if(!isNil "_tmp") then {
                        _c = _c + count _tmp;
                };
        } forEach allGroups;
        _t = count allUnits;
        diag_log format["MSO-%1 CEP Cached: %2/%3 %4%5", time, _c, _t+_c, floor((_c/(_t+_c)) * 100),"%"];
};
