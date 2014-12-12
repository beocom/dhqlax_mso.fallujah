// Written by BON_IF
// Adpated by EightySix

if(!isServer) exitWith{};

private["_position","_allunits","_sniper","_snipers","_heights","_locationheight","_group","_helih"];

_position = _this select 0;

_allunits = call compile format["mps_opfor_inf"];
_snipers = [];
_sniperlist = [];

{
	_camouflage = getnumber (configfile >> "CfgVehicles" >> _x >> "camouflage");
	if(_camouflage < 1) then{_snipers set [count _snipers, _x]};
} foreach _allunits;
if(count _snipers == 0) exitWith{};

_heights = nearestLocations [_position,["Mount"],500];

_helih = "Can_small" createVehicleLocal _position;
_locationheight = (getposASL _helih) select 2;
{
	_helih setpos position _x;
	_heightasl = (getposASL _helih) select 2;

	if(_heightasl - _locationheight > 20 && random 2 < 1.25) then {
		_group = createGroup (SIDE_B select 0);
		_sniper = _group createUnit [_snipers call mps_getRandomElement,_position,[],0,"NONE"];

		_group setBehaviour "COMBAT";
		(_group addWaypoint [position _helih,0]) setWaypointType "HOLD";

		_group spawn {
			while{count units _this > 0} do {sleep 60};
			deletegroup _this;
		};
		_sniperlist set [count _sniperlist, _sniper];
	};
} foreach _heights;

deleteVehicle _helih;

_sniperlist;