// IED Detection and Disposal Mod
// 2011 by Reezo

if (!isServer) exitWith{};

private ["_soldier", "_rangeMin", "_rangeMax"];
_soldier = _this select 0;

if ((getPos _soldier) select 2 > 5) exitWith {};

private ["_nearCivs"];
_nearCivs = [];

_rangeMin = (_this select 1) select 0;
_rangeMax = (_this select 1) select 1;

//Tell me how many "Men" are near the soldier between _RangeMIN and _RangeMAX
private ["_near", "_i"];
_near = [];
_near = (getPos _soldier) nearEntities ["Man", _rangeMax];
if (_soldier in _near) then { _near = _near - [_soldier] };

//Tell me how many civilians are among the near men
if (count _near > 0) then
{
	for "_i" from 0 to (count _near - 1) do
	{
		private ["_thisNear"];
		_thisNear = _near select _i;
		
		if (_thisNear getVariable "reezo_eod_trigger" == "suicide") exitWith
		{
			//player globalChat "SUICIDE BOMBER FOUND IN THE AREA. NOT SPAWNING ANOTHER ONE";
		}; //If a suicide bomber is already in the area, exit
		
		if (_thisNear distance _soldier > _rangeMin && side _thisNear == CIVILIAN) then
		{
			_nearCivs set [count _nearCivs, _thisNear]; //Create an array made only of nearby civilians
		};
	};
};

//Pick one of the existing civilians if found in a suitable area
if (count _nearCivs > 0) exitWith
{
	private ["_bomber"];
	_bomber = _nearCivs select (floor (random (count _nearCivs)));
	waitUntil {!isNull _bomber};
	_bomber setVariable ["reezo_eod_trigger","suicide"];
	waitUntil { !isNil {_bomber getVariable "reezo_eod_trigger"} };
	
	_soldier setVariable ["reezo_eod_avail",false];
	nul0 = [_soldier, _bomber, _rangeMax] execVM "x\eod\addons\eod\reezo_eod_suicidebomber.sqf";
	diag_log format ["SUIC (existing civ) created at %1",position _bomber];
};

//At this point no suitable civilian was found and we are going to spawn one, specifically to make it a suicide bomber
private ["_grp","_skins","_bomber"];
_grp = createGroup CIVILIAN;
_skins = ["TK_CIV_Takistani01_EP1","TK_CIV_Takistani02_EP1","TK_CIV_Takistani03_EP1","TK_CIV_Takistani04_EP1","TK_CIV_Takistani05_EP1","TK_CIV_Takistani06_EP1","TK_CIV_Worker01_EP1","TK_CIV_Worker02_EP1"];
_bomber = _grp createUnit [_skins call BIS_fnc_selectRandom, position _soldier, [], _rangeMax, "NONE"];
waitUntil {!isNull _bomber};
_bomber setVariable ["reezo_eod_trigger","suicide"];
waitUntil { !isNil {_bomber getVariable "reezo_eod_trigger"} };

diag_log format ["SUIC created at %1",position _bomber];

//Let's run the Suicide Bomber behaviour script and then exit
_soldier setVariable ["reezo_eod_avail",false];
nul0 = [_soldier, _bomber, _rangeMax] execVM "x\eod\addons\eod\reezo_eod_suicidebomber.sqf";