private ["_i","_name","_logisticType"];
_i = 0;

tup_logistics_order = [];
tup_logistics_curordersize = 1;

/*if (!(isNil "tup_logistics_nextorder") && (tup_logistics_nextorder > date)) then {
	tup_logistics_curorderlimit = tup_logistics_orderlimit;
};*/

{
	{
		lbAdd [_i, _x];
	} foreach (call _x);
	_i = _i + 1;
} foreach TUP_logistics_lines;


{
	lbAdd [11,_x];
} foreach TUP_logistics_delivery;

_logisticType = [tup_logistics_air,tup_logistics_land,tup_logistics_crate,tup_logistics_static,tup_logistics_defence];
_i = 5;
{
	{
		_name = format ["%1 (%2)", getText(configFile >> "CfgVehicles" >> _x >> "displayname"), str _x];
		lbAdd [_i, _name];
	} foreach _x;
	_i = _i + 1;
} foreach _logisticType;

["Logistics Request","Select the number and items you wish using the form, click add to add to your current order.<br/><br/>Select a line from order and use Remove Selected to remove items if you change your mind.<br/><br/>For Airlifts and Paradrops, you must select the location where the items will be dropped. For convoys you must select the point at which the convoy will enter the AO (i.e. a road by the edge of the AO) or an APOD. Convoys will be delivered to your current location.<br/><br/>Once finished click Ok and then select the appropriate location on the map screen."] call mso_core_fnc_sendHint;

