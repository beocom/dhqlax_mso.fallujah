if (isnil "MP_rights_list" || isnull player) exitwith {[]};

private ["_rights"];
_rights = [];
{
        if (_this == (_x select 0)) exitwith {
                _rights = _x select 1;
        };
} foreach MP_rights_list;
_rights;