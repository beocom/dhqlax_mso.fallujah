private ["_debug","_msg"];

_debug = debug_mso;

PAPABEAR = [West,"HQ"];

openmap true;

onMapSingleClick {
		if (tup_logistics_delivery_sel == 2) then {
			tup_logistics_startpos = _pos;
			tup_logistics_destpos = position player;
		} else {
			tup_logistics_startpos = position player;
			tup_logistics_destpos = _pos;
		};
        onMapSingleClick "";
		openmap false;
		["Logistics Request",format["%1 your order is now being processed",name player]] call mso_core_fnc_sendHint;
		[-1, {PAPABEAR sideChat _this}, format ["%1 this is PAPA BEAR. Logistics Request Received from %2 and being processed. Over.", group player, name player]] call CBA_fnc_globalExecute;
		// Send request to Server
		TUP_LOGISTICS_REQUEST = [tup_logistics_destpos, tup_logistics_order, tup_logistics_delivery_sel, player, tup_logistics_startpos];
		PublicVariableServer "TUP_LOGISTICS_REQUEST";
};

if (tup_logistics_delivery_sel == 2) then {
	
	hintc "Warning! We've had a number of ambushes lately. Brigade wants you to be extremely vigilant. Please acknowledge that we are putting the onus on you to select the START point for the convoy. Indicate by clicking on the map, where you want the convoy to enter the AO. Please select a road position a few 100m inside the AO.";

	_msg = "Click on Map to choose start location for road convoy. This is likely to be an APOD or road at the edge of the map.<br/><br/>The convoy will deliver to your current location."
} else {
	_msg = "Click on Map to choose delivery location. Helicopters and MV22 require a helipad within 500m. Other aircraft will land at nearest runway.<br/><br/> Paradrop is a highly inaccurate delivery method. Expect items to land anywhere from 100m-750m from the chosen destination position.<br/><br/>Airlift does not require a helipad or runway, but please ensure a secure open space is chosen for the landing zone.<br/><br/>GPS guided para-drop should land within 100m of your chosen position."
};

["Logistics Request",_msg] call mso_core_fnc_sendHint;
