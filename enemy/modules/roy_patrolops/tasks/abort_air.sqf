PAPABEAR = [West,"HQ"];

if !(rank player in PO_ranks) exitwith {
    PAPABEAR sideChat format ["%1 this is PAPA BEAR. Your current rank is not authorized to abort an operation!", group player];
};

if (!(vehicle player isKindof "Air") && !(call mso_fnc_hasRadio)) exitwith {
    PAPABEAR sideChat format ["%1 this is PAPA BEAR. You need to be seated in an aircraft or equiped with radio to confirm abortion!", group player];
};

if (runningmission_air) then {
	ABORTTASK_AIR = true;
	Publicvariable "ABORTTASK_AIR";
    PAPABEAR sideChat format ["%1 this is PAPA BEAR. Abortion confirmed...", group player];
} else {
    PAPABEAR sideChat format ["%1 this is PAPA BEAR. There is no active operation to abort...", group player];
};
