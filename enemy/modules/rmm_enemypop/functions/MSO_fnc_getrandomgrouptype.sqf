
private ["_type","_fac","_facs","_sidex","_side","_grpx","_grps","_grouptype","_grp","_fx","_facx","_s","_spawnGrp","_wp","_nonConfigs"];

_type = _this select 0;
_fac = nil;

if (rmm_ep_aa > 1) then {
	_nonConfigs = ["TK_InfantrySectionAA","RU_InfSection_AA","INS_InfSection_AA","TK_INS_AATeam","ACE_RU_InfSection_AA_D","TK_GUE_AATeam"];
} else {
	_nonConfigs = [""];
};

if (count _this > 1) then { _fac = _this select 1; };
if (isNil "_fac") then { _fac = east; };

waitUntil {!isNil "bis_fnc_init"}; 

_facs = [];
_side = nil;

if(isNil "CRB_ALLFACS") then {
	CRB_ALLFACS = [] call BIS_fnc_getFactions;

};

if(typeName _fac == "ANY" || typeName _fac == "SIDE") then {
        if(typeName _fac == "SIDE") then {
                _side = _fac;
        };
        
        switch(_side) do {
                case east: {
                        _sidex = 0;
                };
                case west: {
                        _sidex = 1;
                };
                case resistance: {
                        _sidex = 2;
                };
                case civilian: {
                        _sidex = 3;
                };
        };
        
        {
                _fx = getNumber(configFile >> "CfgFactionClasses" >> _x >> "side");
                if (_fx == _sidex) then {
                        _facs set [count _facs, _x];
                };
        } forEach CRB_ALLFACS;
        _fac = nil;
} else {
        switch(toUpper(typeName _fac)) do {
                case "STRING": {
                        _facs = [_fac];
                };
                case "ARRAY": {
                        _facs = _fac;
                };
        };
        _fac = nil;
};

if(!isNil "_facs") then {
        _facx = [];
        {
                _s = switch(_x) do {
                        case resistance: {"Guerrila";};
                        case civilian: {"Civilian";};
                        default {str _x;};
                };
                
                private ["_x"];
                {
                        _grpx = count(configFile >> "CfgGroups" >> _s >> _x >> _type);
                        for "_y" from 1 to _grpx - 1 do {
                                if (!(_x in _facx)) then { 
                                        _facx set [count _facx, _x];
                                };
                        };
                } forEach _facs;
        } forEach [west,east,resistance,civilian];
        
        _facs = _facx;
};

if (count _facs == 0) exitwith {};

_fac = _facs select floor(random count _facs);
if(isNil "_side") then {
        _sidex = getNumber(configFile >> "CfgFactionClasses" >> _fac >> "side");
        _side = nil;
        switch(_sidex) do {
                case 0: {
                        _side = east;
                };
                case 1: {
                        _side = west;
                };
                case 2: {
                        _side = resistance;
                };
                case 3: {
                        _side = civilian;
                };
        };
};
_grps = [];
_s = switch(_side) do {
        case resistance: {"Guerrila";};
        case civilian: {"Civilian";};
        default {str _side;};
};

_grpx = count(configFile >> "CfgGroups" >> _s >> _fac >> _type);
for "_y" from 1 to _grpx - 1 do {
		private "_cx";
		_cx = configName ((configFile >> "CfgGroups" >> _s >> _fac >> _type) select _y);
		if ( {(_cx == _x)} count _nonConfigs == 0 ) then {	
			_grps set [count _grps, (configFile >> "CfgGroups" >> _s >> _fac >> _type) select _y];			
		};	
};

if (count _grps > 0) then {
	_grp = _grps select floor(random count _grps);
} else {
	_grp = 2 + floor(random 8);
};

_grouptype = [_side, _grp];
_grouptype;
