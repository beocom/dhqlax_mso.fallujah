// Create AA Position by Tupolov for MSO
// [position,type,number of units] call mso_core_fnc_spawnAA
// type = static, mobile, mixed

if(!isServer) exitWith{};

if(rmm_ep_aa == 0) exitWith{};

private ["_choice","_aa","_pos","_number","_type","_aa","_veh","_debug","_aatypes","_id"];

_debug = debug_mso;
_pos = _this select 0;
_type = _this select 1;
if (count _this > 2) then {
	_number = _this select 2;
} else {
	_number = 1;
};

_aa = [];
_aatypes = ["2S6M_Tunguska","Ural_ZU23_Gue","Ural_ZU23_INS","ZSU_INS","Ural_ZU23_TK_EP1","ZSU_TK_EP1","ACE_Ural_ZU23_RU","ACE_ZSU_RU","Igla_AA_pod_EAST","Igla_AA_pod_TK_EP1","ZU23_Gue","ZU23_Ins","ZU23_TK_EP1","ZU23_TK_INS_EP1","ZU23_TK_GUE_EP1"];

// Check to ensure there is no other AA site nearby
if (count (nearestobjects [_pos,_aatypes,200]) > 0) exitWith {};

// Spawn mobile AA
if (_type == "mobile" || _type == "mixed") then {
	if ( (rmm_ep_aa == 1) && (random 1 > 0.5) && ("RU" in MSO_FACTIONS) ) then {_aa = ["2S6M_Tunguska"]};
	if ("RU" in MSO_FACTIONS || "cwr2_ru" in MSO_FACTIONS) then { _aa = _aa + ["Ural_ZU23_Gue"]};
	if ("GUE" in MSO_FACTIONS || "tigerianne" in MSO_FACTIONS) then { _aa = _aa + ["Ural_ZU23_Gue"]};
	if ("INS" in MSO_FACTIONS || "cwr2_fia" in MSO_FACTIONS) then { _aa = _aa + ["Ural_ZU23_INS","ZSU_INS"]};
	if ("BIS_TK" in MSO_FACTIONS) then { _aa = _aa + ["Ural_ZU23_TK_EP1","ZSU_TK_EP1"]};
	if ("BIS_TK_GUE" in MSO_FACTIONS) then { _aa = _aa + ["Ural_ZU23_TK_GUE_EP1"]};
	if (mps_ace_enabled && ("RU" in MSO_FACTIONS || "cwr2_ru" in MSO_FACTIONS)) then {
			_aa = _aa + ["ACE_Ural_ZU23_RU","ACE_ZSU_RU"];
	};
};

// Spawn static AA
if (_type == "static" || _type == "mixed") then {

	if ( (rmm_ep_aa == 1) && (random 1 > 0.5) && ("RU" in MSO_FACTIONS) ) then {_aa = ["Igla_AA_pod_EAST"]};
	if ( (rmm_ep_aa == 1) && (random 1 > 0.5) && ("BIS_TK" in MSO_FACTIONS) ) then {_aa = ["Igla_AA_pod_TK_EP1"]};
	if ("RU" in MSO_FACTIONS || "cwr2_ru" in MSO_FACTIONS) then { _aa = _aa + ["ZU23_Gue"]};
	if ("GUE" in MSO_FACTIONS || "tigerianne" in MSO_FACTIONS) then { _aa = _aa + ["ZU23_Gue"]};
	if ("INS" in MSO_FACTIONS || "cwr2_fia" in MSO_FACTIONS) then { _aa = _aa + ["ZU23_Ins"]};
	if ("BIS_TK" in MSO_FACTIONS) then { _aa = _aa + ["ZU23_TK_EP1"]};
	if ("BIS_TK_INS" in MSO_FACTIONS) then { _aa = _aa + ["ZU23_TK_INS_EP1"]};
	if ("BIS_TK_GUE" in MSO_FACTIONS) then { _aa = _aa + ["ZU23_TK_GUE_EP1"]};
	
	// Spawn Fortification
	if (random 1 > 0.33 || _type == "static") then {
		_camp = [];
		if("RU" in MSO_FACTIONS) then {_camp = _camp + ["anti-air_ru1","camp_ru1","camp_ru2","mediumtentcamp2_ru","mediumtentcamp3_ru","mediumtentcamp_ru","radar_site_ru1"]};
		if("BIS_TK" in MSO_FACTIONS) then { _camp = _camp + ["anti-air_tk1","camp_tk1","camp_tk2","mediumtentcamp2_tk","mediumtentcamp3_tk","mediumtentcamp_tk","radar_site_tk1"]};
		if("RU" in MSO_FACTIONS || "INS" in MSO_FACTIONS || "GUE" in MSO_FACTIONS || "cwr2_ru" in MSO_FACTIONS || "cwr2_fia" in MSO_FACTIONS || "tigerianne" in MSO_FACTIONS) then {
				_camp = _camp + ["bunkerMedium01","bunkerMedium02","bunkerMedium03","bunkerMedium04","bunkerSmall01"];
				f_builder2 = mso_core_fnc_createComposition;
		};
		if("BIS_TK" in MSO_FACTIONS || "BIS_TK_INS" in MSO_FACTIONS || "BIS_TK_GUE" in MSO_FACTIONS) then {
				_camp = _camp + ["bunkerMedium01","bunkerMedium02","bunkerMedium03","bunkerMedium04","bunkerSmall01"];
				f_builder2 = mso_core_fnc_createCompositionE;
		};
		if (count _camp > 0) then {
			_camp = _camp call BIS_fnc_selectRandom;
			_pos = [_pos, 0, 50, 10, 0, 2, 0] call bis_fnc_findSafePos;
			[_camp, random 360, _pos] call f_builder2;
			if (_debug) then {
				diag_log format ["MSO-%1 Enemy Population - Anti Air Camp created at %2 (%3)", time, _pos, text _loc]; 
				
			};
		} else {
			if (_debug) then {diag_log format ["MSO-%1 Enemy Population - Did not find AA camp for factions.", time];};
		};
	};
};

if (count _aa == 0) exitWith {diag_log format ["MSO-%1 Enemy Population - Did not find AA unit for factions.", time];};

// Create vehicle
_choice = _aa call BIS_fnc_selectRandom;
for "_i" from 1 to _number do {
    _altpos =  [_pos, 20] call CBA_fnc_randPos;
    _safepos = [_pos,0,20,5,0,1,0,[],[_altpos]] call BIS_fnc_findSafePos;
	_veh = [_safepos, random 360, _choice, EAST] call BIS_fnc_spawnVehicle;
	if (_debug) then {
		diag_log format["MSO-%1 Enemy Population - deploying AA asset %2 at %3", time, _choice, position (_veh select 0)];
	};
	(_veh select 2) setSpeedMode "LIMITED";
    (_veh select 2) setFormation "DIAMOND";
	[(_veh select 2)] call CBA_fnc_taskDefend;
};

_id = floor (random 1000);

if (_debug) then {
	[format["AA_%1", _id], _pos, "Icon", [1,1], "TYPE:", "Dot", "TEXT:", "AA",  "GLOBAL", "PERSIST"] call CBA_fnc_createMarker;
};