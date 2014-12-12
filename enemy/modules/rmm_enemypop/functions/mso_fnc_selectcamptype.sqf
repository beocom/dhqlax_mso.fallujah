
    private ["_camp"];
    
	_camp = [];
	if("RU" in MSO_FACTIONS) then {
		_camp = _camp + ["anti-air_ru1","camp_ru1","camp_ru2","firebase_ru1","heli_park_ru1","mediumtentcamp2_ru","mediumtentcamp3_ru","mediumtentcamp_ru","radar_site_ru1"];
	};
	if("INS" in MSO_FACTIONS) then {
		_camp = _camp + ["camp_ins1","camp_ins2"];
	};
	if("GUE" in MSO_FACTIONS || "tigerianne" in MSO_FACTIONS) then {
		_camp = _camp + ["MediumTentCamp_napa","SmallTentCamp2_napa","SmallTentCamp_napa"];
	};
	if("BIS_TK" in MSO_FACTIONS) then {
		_camp = _camp + ["anti-air_tk1","camp_tk1","camp_tk2","firebase_tk1","heli_park_tk1","mediumtentcamp2_tk","mediumtentcamp3_tk","mediumtentcamp_tk","radar_site_tk1"];
									};
	if("BIS_TK_INS" in MSO_FACTIONS) then {
		_camp = _camp + ["camp_militia1","camp_militia2"];
	};
	if("BIS_TK_GUE" in MSO_FACTIONS) then {
		_camp = _camp + ["MediumTentCamp_local","SmallTentCamp2_local","SmallTentCamp_local"];
	};
	if("RU" in MSO_FACTIONS || "INS" in MSO_FACTIONS || "GUE" in MSO_FACTIONS || "cwr2_ru" in MSO_FACTIONS || "cwr2_fia" in MSO_FACTIONS || "tigerianne" in MSO_FACTIONS) then {
		_camp = _camp + ["bunkerMedium01","bunkerMedium02","bunkerMedium03","bunkerMedium04","bunkerSmall01","guardpost4","guardpost5","guardpost6","guardpost7","guardpost8","citybase01","cityBase02","cityBase03","cityBase04"];
	};
	if("BIS_TK" in MSO_FACTIONS || "BIS_TK_INS" in MSO_FACTIONS || "BIS_TK_GUE" in MSO_FACTIONS) then {
		_camp = _camp + ["bunkerMedium01","bunkerMedium02","bunkerMedium03","bunkerMedium04","bunkerSmall01","guardpost4","guardpost5","guardpost6","guardpost7","guardpost8","citybase01","cityBase02","cityBase03","cityBase04"];
	};
	if (count _camp == 0) then {
		_camp = _camp + ["anti-air_ru1","camp_ru1","camp_ru2","firebase_ru1","heli_park_ru1","mediumtentcamp2_ru","mediumtentcamp3_ru","mediumtentcamp_ru","radar_site_ru1"];
	};
	if (count _camp > 0) then {
		_camp = _camp call BIS_fnc_selectRandom;
    };
    _camp;
