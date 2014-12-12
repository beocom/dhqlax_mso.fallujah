waitUntil{!isNil "bis_fnc_init"};

_this addAction ["Construction",CBA_fnc_actionargument_path, [_this,{_this call cnstrct_fnc_open}],-1,false,true,"","vehicle _this == _this"];
