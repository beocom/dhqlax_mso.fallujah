waitUntil{!isNil "BIS_fnc_init"};

CRB_fnc_packCamoNet = {
	_net = (nearestObjects [(position _this), ["Land_CamoNet_EAST","Land_CamoNet_NATO"], 3]) select 0;
	if(!isNil "_net") then {	
		_this setVariable ["camoNetObject", typeOf _net, true];
		deleteVehicle _net;
		_this removeAction (_this getVariable "camoNetActionId");
		_id = _this addAction ["Unpack CamoNet",  CBA_fnc_actionargument_path, [_this,{_this call CRB_fnc_unpackCamoNet}]];
		_this setVariable ["camoNetActionId", _id, true];
	} else {
		hint "There are no CamoNets close enough!";
	};
};

CRB_fnc_unpackCamoNet = {
	_net = _this getVariable "camoNetObject";
	if(!isNil "_net") then {
		_net = createVehicle [_net, position _this, [], 0, "NONE"];
		_net setDir (direction _this);
		_this setVariable ["camoNetObject", nil, true];

		_this removeAction (_this getVariable "camoNetActionId");
		_id = _this addAction ["Pack CamoNet",  CBA_fnc_actionargument_path, [_this,{_this call CRB_fnc_packCamoNet}]];
		_this setVariable ["camoNetActionId", _id, true];
	} else {
		hint "Hmmm, something has gone wrong...";
	};
};

_id = _this addAction ["Pack CamoNet",  CBA_fnc_actionargument_path, [_this,{_this call CRB_fnc_packCamoNet}]];
_this setVariable ["camoNetActionId", _id, true];