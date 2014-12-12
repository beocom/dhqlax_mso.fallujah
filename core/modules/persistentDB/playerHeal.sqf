/* 
 * Filename:
 * playerHeal.sqf 
 *
 * Description:
 * Called from init.sqf
 * 
 * Created by [KH]Jman
 * Creation date: 15/12/2010
 * Email: jman@kellys-heroes.eu
 * Web: http://www.kellys-heroes.eu
 * 
 * */

// ====================================================================================
// MAIN

//	 diag_log["playerHeal: ", _this];
	 
		_player = _this select 0;                              
		_anim = _this select 1;

	
		// healing animations...
		if ((((((((((
			(_anim == "amovppnemstpsraswrfldnon_healed") || 
			(_anim == "ainvpknlmstpslaywrfldnon_healed") ||
			(_anim == "AmovPpneMstpSnonWnonDnon_healed") ||
			(_anim == "AinvPknlMstpSnonWnonDnon_healed_2") ||
			(_anim == "AinvPknlMstpSnonWnonDnon_healed_1") ||
			(_anim == "AinvPknlMstpSlayWrflDnon_healed2") ||
			(_anim == "AmovPpneMstpSrasWrflDnon_healed") ||
			(_anim == "AmovPpneMstpSrasWpstDnon_healed") ||
			(_anim == "AinvPknlMstpSlayWrflDnon_healed") ||
			(_anim == "ainvpknlmstpslaywrfldnon_medic")
		)))))))))) then {
			_player setVariable ["damage", 0, true];
			_player setVariable ["head_hit", 0, true];
			_player setVariable ["body", 0, true];
			_player setVariable ["hands", 0, true];
			_player setVariable ["legs", 0, true];
			
			if (pdb_ace_enabled) then {
				[player,"Player being healed."] call PDB_FNC_ACE_WOUNDS;
			};
		};

// ====================================================================================