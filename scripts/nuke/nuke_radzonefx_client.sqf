private ["_nukepos","_fallouttime"];

_nukepos = _this select 0;
_fallouttime = _this select 1;

_nuclearrain = false;

for "_i" from 0 to (_fallouttime / 30) do {
    if ((player distance _nukepos) < (1400 + (random 100))) then {
        windv = true;
        player spawn fnc_nuke_wind;
        player spawn fnc_nuke_envi;
        if !(_nuclearrain) then {25 setovercast 1; _nuclearrain = true;};
        player spawn fnc_nuke_ash;
  	} else {
        player spawn fnc_nuke_envi_off;
        fnc_nuke_ash_on = false;
        fnc_nuke_envi_on = false;
        windv = false;
        deletevehicle snow;
        if (_nuclearrain) then {25 setovercast 0.2; _nuclearrain = false;};
    };
	sleep 30;
};

player spawn fnc_nuke_envi_off;
fnc_nuke_ash_on = false;
fnc_nuke_envi_on = false;
windv = false;
deletevehicle snow;