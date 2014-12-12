{
        player setVariable ["ACE_WeaponOnBack", _this];
        player addWeapon _this;
        [player, _this] call ACE_fnc_PutWeaponOnBack;
},
{
        if (_this != "") then {
                // add backpack
                player addWeapon _this;
                [player, "ALL"] call ACE_fnc_RemoveGear;
        };
},
{
        // add backpack magazines
        {
                [player, _x select 0, _x select 1] call ACE_fnc_PackMagazine;
        } forEach _this;
},
{
        // add backpack weapons
        {
                [player, _x select 0, _x select 1] call ACE_fnc_PackWeapon;
        } forEach _this;
},
