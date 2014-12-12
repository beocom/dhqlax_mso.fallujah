if (RMM_cas_lastTime + RMM_cas_frequency < time) then {
	RMM_cas_lastTime = time;
	RMM_cas_lastDaytime = daytime;
	publicvariable "RMM_cas_lastTime";
	private ["_veh","_selection"];
	_selection = (call (RMM_cas_lines select 2)) select (lbCurSel 2);
	
	If ( _selection == "C130J" || _selection == "MQ9PredatorB") then {
		If (_selection == "C130J") then {
			// Call AI AC130
			_nul = execVM "support\modules\rmm_cas\LDL_ac130\Actions\ac130_action_map_AI.sqf";
		} else {
			// Call AI UAV
			_nul = execVM "support\modules\rmm_cas\LDL_ac130\Actions\uav_action_map.sqf";
		};
	} else {
        
        if (str(markerpos "CAS_spawn") == "[0,0,0]") then {
            _veh = ([[-1000,-1000,1000], 0, _selection, group player] call BIS_fnc_spawnVehicle) select 0;
        } else {
			_veh = ([[(markerpos "CAS_spawn") select 0, (markerpos "CAS_spawn") select 1,1000], 0, _selection, group player] call BIS_fnc_spawnVehicle) select 0;
        };
        
		[2,_veh,{_this flyinheight RMM_cas_flyinheight;}] call RMM_fnc_ExMP;
		hint format ["%1 requested to %2 by %3", (call (RMM_cas_lines select 2)) select (lbCurSel 2), (call (RMM_cas_lines select 0)) select (lbCurSel 0), (call (RMM_cas_lines select 1)) select (lbCurSel 1)];
		[2,_veh,{_this lockdriver true;}] call mso_core_fnc_ExMP;
			
		// Spawn CAS mission
		[2,_veh,{
			[_this] execvm "support\modules\rmm_cas\cas.sqf";
		}] call mso_core_fnc_ExMP;
	};
} else {
	hint format["CAS not available until %1", [RMM_cas_lastDaytime + (RMM_cas_frequency / 60 / 60)] call BIS_fnc_timeToString];
};