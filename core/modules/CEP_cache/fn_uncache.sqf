private ["_count","_cep_unit_init","_cep_unit_weap","_cep_unit_mags","_cep_unit_offset","_cep_unit_veh","_cep_unit_vehpos","_cep_bkp","_cep_bmg","_cep_bwp","_cep_rnk","_cep_unit_pos","_cep_leader","_cep_myunit","_cep_typearray","_tp"];
if(!isServer) exitWith {};
_cep_typearray = _this getVariable "CEP_Array";
if(isNil "_cep_typearray") exitWith {};
_count = 0;
_cep_leader = leader _this;
{
        _cep_unit_init = _x select 0;
        _cep_unit_weap = _x select 1;
        _cep_unit_mags = _x select 2;
        _cep_bkp = _x select 3;
        _cep_bmg = _x select 4;
        _cep_bwp = _x select 5;
        _cep_rnk = _x select 6;
        _cep_unit_offset = _x select 7;
        _cep_unit_veh = _x select 8;
        _cep_unit_vehpos = _x select 9;
        
        _cep_unit_pos = _cep_leader modeltoworld _cep_unit_offset;
        _cep_myunit = (group _cep_leader) createUnit [_cep_unit_init, _cep_unit_pos, [], 0, "NONE"];
        
        removeallweapons _cep_myunit;
        removeAllItems _cep_myunit;
        {
                _cep_myunit addmagazine _x;
        } foreach _cep_unit_mags;
        {
                _cep_myunit addweapon _x;
        } foreach _cep_unit_weap;
        
        if (_cep_bkp != "") then {
                _cep_myunit addbackpack _cep_bkp;
                clearweaponcargo (unitbackpack _cep_myunit);
                clearmagazinecargo (unitbackpack _cep_myunit);
        };
        
        for "_i" from 0 to ((count (_cep_bmg select 0))-1) do {
                (unitbackpack _cep_myunit) addmagazinecargo [(_cep_bmg select 0) select _i,(_cep_bmg select 1) select _i];
        };
        
        for "_i" from 0 to ((count (_cep_bwp select 0))-1) do {
                (unitbackpack _cep_myunit) addweaponcargo [(_cep_bwp select 0) select _i,(_cep_bwp select 1) select _i];
        };
        
        _cep_myunit setunitrank _cep_rnk;
        if (count _cep_unit_vehpos != 0) then {
                switch(_cep_unit_vehpos select 0) do {
                        case "Driver": {
                                _cep_myunit moveInDriver _cep_unit_veh;
                                _cep_myunit assignAsDriver _cep_unit_veh;
                        };
                        case "Cargo": {
                                _cep_myunit moveInCargo _cep_unit_veh;
                                _cep_myunit assignAsCargo _cep_unit_veh;
                        };
                        case "Turret": {
                                _tp = _cep_unit_vehpos select 1;
                                _cep_myunit moveInTurret [_cep_unit_veh, _tp];
                                _cep_myunit assignAsGunner _cep_unit_veh;
                        };
                };
        };
        
        _count = _count + 1;
} forEach _cep_typearray;

if (debug_mso) then {
	diag_log format["MSO-%1 CEP uncached: %2 of group:%3 leader:%4", time, _count, _this, typeof leader _this];
};

_this setVariable ["CEP_Array", nil];

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
