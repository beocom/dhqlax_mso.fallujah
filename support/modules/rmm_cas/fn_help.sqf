
private ["_display","_string"];
disableserialization;

_display = findDisplay 80512;
_string = switch (_this select 0) do {
	case (_display displayCtrl 0) : {
		"<t size='1.5'>Location</t><br/>6 Digit GRID COORDINATE";
	};
	case (_display displayCtrl 1) : {
		"<t size='1.5'>Call Sign</t><br/>Call Sign that will be used by the ground unit. You should know this information before every operation";
	};
	case (_display displayCtrl 2) : {
		"<t size='1.5'>Support Type</t><br/>Type of support to request";
	};
	default {""};
};
hint parseText _string;