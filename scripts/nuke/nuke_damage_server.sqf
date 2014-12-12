if !(isserver) exitwith {};

private ["_array","_buildings","_center"];
_nukepos = _this select 0;
_fallouttime = _this select 1;

[_nukepos, 800, 1138, [], true] call bis_fnc_destroyCity; //compile preprocessFileLineNumbers "ambience\modules\crb_destroycity\fn_destroyCity.sqf";

sleep 0.9;
_array = nearestObjects [_nukepos, [], 800];
sleep 0.1;
{_x setdamage 1} forEach _array;
sleep 0.1;

_array = _nukepos nearentities ["Man", 1200];
{_x setdamage 0.5} forEach _array;
sleep 0.1;
_array = _nukepos nearentities ["Man", 1500];
{_x setdamage 0.3} forEach _array;
sleep 0.1;
//

_array = _nukepos nearentities [["Land","Ship","Car","Air","Tank","Static","Strategic","NonStrategic"], 1000];
{_x setdammage ((getdammage _x) + 0.4)} forEach _array;
sleep 0.1;

_array = (nearestObjects [_nukepos,[], 300]) - ((_nukepos) nearObjects 300);
{_x hideobject true} forEach _array;
{_x setdammage 1.0} forEach _array;

[_nukepos,_fallouttime] execvm "scripts\nuke\nuke_radzone_server.sqf";

/*
[_nukepos, 40] spawn
	{
		for "_i" from 1 to 3 do 
		{
			Sleep 2;
			[_this select 0, _this select 1, _i] spawn echo_nuke_fnc_fallout;
		};
	};
*/
