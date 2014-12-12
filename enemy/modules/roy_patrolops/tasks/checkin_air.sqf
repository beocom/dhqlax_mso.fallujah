PAPABEAR = [West,"HQ"];

if !(rank player in PO_ranks) exitwith {
    PAPABEAR sideChat format ["%1 this is PAPA BEAR. Your current rank is not authorized to sign in!", group player];
};

if (!(vehicle player isKindof "Air")) exitwith {
    PAPABEAR sideChat format ["%1 this is PAPA BEAR. You need to be seated in an aircraft for data transmission!", group player];
};

if !(runningmission_air) then {
	PAPABEAR sideChat format ["%1 this is PAPA BEAR. Request Authorised. Transmitting INTEL!", group player];
    runningmission_air = true;
    Publicvariable "runningmission_air";
    ABORTTASK_AIR = false;
    Publicvariable "ABORTTASK_AIR";
    } else {
    PAPABEAR sideChat format ["%1 this is PAPA BEAR. You are already assigned. Follow your orders!", group player];
};