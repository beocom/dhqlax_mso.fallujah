switch (toUpper(_this)) do {
	case "CEP" : { // Coop Essentials Pack Caching
		[
			{allGroups},
			nil,
			{_this call cep_fnc_cache},
			{_this call cep_fnc_uncache},
			{allGroups}
		]
	};
	case "NOUJAY" : { // NouberNou's and Jaynus' Caching
		[
			{allGroups},
			{_this call noujay_fnc_sync},
			{_this call noujay_fnc_cache},
			{_this call noujay_fnc_uncache},
			{allGroups}
		]
	};
	case "OSOM" : { // Outta Sight Outta Mind
		[
			{_this call OSOM_fnc_init},
			{_this call OSOM_fnc_sync},
			{_this call OSOM_fnc_inactive},
			{_this call OSOM_fnc_active},
			nil
		]
	};
	case "OSL" : { // Outta Sight Light
		[
			{_this call OSL_fnc_init},
			nil,
			{_this call OSL_fnc_inactive},
			{_this call OSL_fnc_active},
			nil
		]
	};
	case "DEBUG" : {
		[
			{hint "GTK Initialising";_this;},
			{hintSilent format["GTK Syncing - %1", _this getvariable "rmm_gtk_cached"];},
			{hint "GTK Caching";},
			{hint "GTK Uncaching";},
			{hint "GTK Refreshing";}
		]
	};
	Default {
		[
			nil,
			nil,
			nil,
			nil,
			nil
		]
	};
};
