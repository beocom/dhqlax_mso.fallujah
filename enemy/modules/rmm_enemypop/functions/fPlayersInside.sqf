
        private["_pos","_dist"];
        _pos = _this select 0;
        _dist = _this select 1;
        ({_pos distance _x < _dist} count ([] call BIS_fnc_listPlayers) > 0);
