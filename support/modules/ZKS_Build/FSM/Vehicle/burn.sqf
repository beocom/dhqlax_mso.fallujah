//Script By Zonekiller -- http://zonekiller.ath.cx -- zonekiller@live.com.au


_ai = _this select 0;

if (_ai in burning) exitwith {}; 

burning set [count burning, _ai];

_fire = position _ai;

_sounds = ["scream1","scream2","scream3","scream4","scream5","scream6"];

sleep 0.1;

_ai disableAI "AUTOTARGET";
_ai disableAI "TARGET";
_ai setSpeedMode "FULL";
_pos = [(getPos _ai select 0) + random 500 ,(getPos _ai select 1) + random 500 ,(getPos _ai select 2)];
_ai setBehaviour "CARELESS";
_ai allowFleeing 1;
_ai setCombatMode "BLUE";



//Fire 

_flame = "#particlesource" createVehicleLocal getpos _ai;
_flame setParticleRandom [0.5, [.0, .0, 0.5], [1, 1, 1], 0.2, .05, [0, 0, 0, 0], 0, 0];
_flame setParticleParams [["\ca\Data\ParticleEffects\Universal\Universal", 16, 10, 32], "", "Billboard", .1, .1, [0, 0, 0], [0, 0, 0.5], 1, 1, 0.9, 0.3, [1], [[1, 0.7, 0.7, 0.5]], [1], 0, 10, "", "", _ai];
_flame setDropInterval 0.005;




_a = 0;
_b = 0;
_dis = random 55;
_dis = _dis + 35;
_timeout = time;
_ran = 0;
_rolling = 0;
_ai domove _pos;
_ai removeEventHandler ["Dammaged", 0];


	if (_ai isKindOf "man") then 
	{
	_sound = _sounds select (floor (random (count _sounds)));
	[_ai,(side _ai),_sound] execFSM "FSM\Sounds\Sounds_Say.fsm";

	};

	while {_a < 300} do
	{
		if (_ai distance _fire > _dis) then 
		{

		if (_rolling == 0) then 
		{
		_rolling = 1;
		_ai playmove "ainjppnemstpsnonwrfldnon_rolltofront";
		sleep 1.5;
		};


		_ai playmove "AmovPpneMstpSnonWnonDnon_AmovPpneMevaSnonWnonDr";
		sleep 1.5;
		_ai playmove "AmovPpneMstpSnonWnonDnon_AmovPpneMevaSnonWnonDl";

	
			if ((random 100 < 30) and (_ai isKindOf "man")) exitwith 
			{
			_sound = _sounds select (floor (random (count _sounds)));
			[_ai,(side _ai),_sound] execFSM "FSM\Sounds\Sounds_Say.fsm";

			sleep 8;
			deletevehicle _flame;
			_a = 300;
			_ai enableAI "AUTOTARGET";
			_ai enableAI "TARGET";
			_ai allowFleeing 0;
			_ai setCombatMode "red";
			burning = burning - [_ai];
			};

		_ai setdammage _b;
		_b = _b + random 0.5;
		_a = _a + 10;
		sleep 0.1;
			
		}
		else
		{

			if ((time > _timeout + 6 + random 5) and (_ai isKindOf "man")) then 
			{
			_sound = _sounds select (floor (random (count _sounds)));
			[_ai,(side _ai),_sound] execFSM "FSM\Sounds\Sounds_Say.fsm";
			_ai domove _pos;
			
			_timeout = time;
			};


		_ai setdammage _b;
		_b = _b + random 0.01;
		_a = _a + 1;
		sleep 0.1;

		};
	
	if ((isplayer _ai) && !(alive _ai)) exitwith {deletevehicle _flame;burning = burning - [_ai]}; 

	};

burning = burning - [_ai];

deletevehicle _flame;



