waitUntil{!isNil "bis_fnc_init"};

_this addAction ["Open Logbook",CBA_fnc_actionargument_path, [_this,{[_this] call logbook_fnc_open}]];
