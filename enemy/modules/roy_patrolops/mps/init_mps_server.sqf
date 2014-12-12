if(!isServer) exitWith {};

_rtp = markerpos "respawn_west"; 
if !(str(_rtp) == "[0,0,0]") then {
	_rtp = [(markerpos "respawn_west" select 0), (markerpos "respawn_west" select 1),0];
} else {
	_rtp = [(markerpos "respawn_east" select 0), (markerpos "respawn_east" select 1),0];
};
_rtp = [_rtp,2,50,2,0,2,0] call BIS_fnc_findSafePos;

return_point_west = createmarkerlocal ["return_point_west",[(_rtp select 0),(_rtp select 1)]];
return_point_west setmarkershapelocal "ICON";
return_point_west setmarkercolorlocal "ColorBlue";
"return_point_west" setMarkerTypelocal "WAYPOINT";
 