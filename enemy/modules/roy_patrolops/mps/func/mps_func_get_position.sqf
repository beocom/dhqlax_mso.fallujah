// Written by BON_IF
// Adapted by EightySix

private["_pos"];
_pos = _this;
	_position = switch (toupper(typename _pos)) do {
		case "OBJECT": { position _pos };
		case "STRING": { getMarkerPos _pos };
		default { _pos };
	};
_position;