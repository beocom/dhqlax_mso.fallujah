if(count mps_loc_towns < 1) exitWith{};
diag_log [diag_frameno, diag_ticktime, time, "MISSION TASK SAD_bombcar.sqf"];

private["_location","_position","_taskid","_positionS","_locationE","_positionE","_positionE1","_car","_killtasktime","_SuicideBomberType"];

// added failsafe timeout
_killtasktime = 0;

// regular task inits
_location = (mps_loc_towns call mps_getRandomElement);
while {_location == mps_loc_last } do {
    _location = (mps_loc_towns call mps_getRandomElement);
	sleep 0.1;
};

mps_loc_last = _location;

while { _locationE = (mps_loc_towns call mps_getRandomElement); _locationE == mps_loc_last } do {
	sleep 0.1;
};
mps_loc_last = _locationE;
_position = [(position _location) select 0,(position _location) select 1, 0];
_positionE = [(position _locationE) select 0,(position _locationE) select 1, 0];
_taskid = format["%1%2%3",round (_position select 0),round (_position select 1),(round random 999)];



//switched _position and _positionE
[ format["TASK%1",_taskid],
	format["Eliminate car bomber moving from %1 to %2", text _location, text _LocationE],
	format["We got HUMINT of a car bomber transporting a chemical bomb moving from %1 to %2! Instantly intercept the car and take out the passengers before they reach %2 by all means possible! You have be accurate and quick since the bomb must not explode and it's very likely they will blow it up if harmed or near potential victims!", text _location, text _LocationE],
	(SIDE_A select 0),
	[format["MARK%1",_taskid],(_position),"hd_objective","ColorRedAlpha","Target"],
	"created",
	_positionE
] call mps_tasks_add;

// getting safe start and end positions (and be sure he drives in the center of a town)
_positionS = [_position,0,100,10,0,50,0] call BIS_fnc_findSafePos;
_positionE1 = position nearestlocation [_positionE, "CityCenter"];

//checking if next citycenter is too far away
if (_positionE1 distance _positionE > 500) then {
    				_positionE = [_positionE,0,50,10,0,20,0] call BIS_fnc_findSafePos;
} else {
    				_positionE = [_positionE1,0,50,10,0,20,0] call BIS_fnc_findSafePos;
};

// base position just in case
_positionB = getmarkerpos "Respawn_UK";

// selecting car and bomberman type randomly
_carType = ["Lada1_TK_CIV_EP1","Lada2_TK_CIV_EP1","LandRover_TK_CIV_EP1","hilux1_civil_3_open_EP1"] call mps_getRandomElement;
_SuicideBomberType = ["TK_CIV_Takistani03_EP1","TK_CIV_Takistani04_EP1","TK_CIV_Takistani02_EP1","TK_CIV_Takistani05_EP1","TK_CIV_Takistani01_EP1","TK_CIV_Takistani06_EP1"] call mps_getRandomElement;                             				
					
                    
// start the spawning and moving                    
                    SuicideBomberG = CreateGroup East;
                    SuicideBomberV = createVehicle [_carType, [(_positionS select 0), (_positionS select 1), 0], [], 180, "FLY"];
					SuicideBomberD = SuicideBomberG createUnit [_SuicideBomberType, [(_positionS select 0)+5, (_positionS select 1), 0], [], 180, "CAN_COLLIDE"];
					SuicideBomberC1 = SuicideBomberG createUnit ["TK_INS_Soldier_EP1", [(_positionS select 0)+3, (_positionS select 1), 0], [], 180, "CAN_COLLIDE"];
                    SuicideBomberG setVariable ["rmm_gtk_exclude", true];
                    
					SuicideBomberD assignasDriver SuicideBomberV;
                    SuicideBomberD moveInDriver SuicideBomberV;
					SuicideBomberC1 moveInCargo SuicideBomberV;
                    
					SuicideBomberV setdir 180;
					SuicideBomberV setpos [(_positionS select 0),(_positionS select 1),0];
					SuicideBomberG setspeedmode "NORMAL";
					SuicideBomberG setbehaviour "SAFE";
					SuicideBomberG move _positionE;

//now waiting for some conditions to be met and else move 'em along, just check not too often					                    
while {	!ABORTTASK_PO and
		(_killtasktime < 1800) and
        (alive SuicideBomberD) and
        (damage SuicideBomberV < 0.3) and
        (damage SuicideBomberD < 0.4) and
        !({side _x == WEST} count nearestObjects [position SuicideBomberV,["Man","Car","Tank"],20] > 0) and
		(SuicideBomberD distance _positionE > 150)
      } do {
    	SuicideBomberG move _positionE;
        _killtasktime = _killtasktime + 2;
        sleep 2;                                           
};

//after one condition has been met instantly check whats going finishing the task

if (!ABORTTASK_PO && (!(alive SuicideBomberD)) and (damage SuicideBomberV < 0.4)) then {
	[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
	{deletevehicle _x} foreach units SuicideBomberG;
    deletevehicle SuicideBomberV;
    mps_mission_status = 2;
}else{
    if (
    (SuicideBomberV distance _positionE < 200) or 
    (damage SuicideBomberD > 0.4) or 
    (damage SuicideBomberV > 0.29) or
    ({side _x == WEST} count nearestObjects [position SuicideBomberV,["Man","Car","Tank"],20] > 0)
    ) then {
    _explode = "Bo_GBU12_LGB" createVehicle getPos SuicideBomberV};
	[format["TASK%1",_taskid],"failed"] call mps_tasks_upd;
    {deletevehicle _x} foreach units SuicideBomberG;
    deletevehicle SuicideBomberV;
	mps_mission_status = 3;
};

/*
// Spawn Squad
 _grp = [_position,"INF",(5 + random 5),50] call CREATE_OPFOR_SQUAD;
// or
// _grp = [_position,"INF",(5 + random 5),50,"standby"] call CREATE_OPFOR_SQUAD;
// _grp = [_position,"INF",(5 + random 5),50,"patrol"] call CREATE_OPFOR_SQUAD;
// _grp = [_position,"INF",(5 + random 5),50,"hide"] call CREATE_OPFOR_SQUAD;
//
 while{ {alive _x} count (units _grp) > 2 } do { sleep 5 };

// Spawn scaleable Army
// [_position] call CREATE_OPFOR_ARMY; sleep 1;
// while{ {alive _x && side _x == (SIDE_B select 0)} count nearestObjects[_position,["MAN","LandVehicle","Air"],250] > 3 } do { sleep 5 };

// Spawn Static Weapon
// [_position] call CREATE_OPFOR_STATIC;

// Spawn snipers around AO
// _snipers = [_position] call CREATE_OPFOR_SNIPERS;
// while{ {alive _x} count _snipers > 0 } do { sleep 5 };

// Spawn ParaDrop
// _grp = [_position,"INF",(5 + random 5),50] call CREATE_OPFOR_SQUAD;
// [_grp,format["respawn_%1",(SIDE_B select 0)],_position] spawn CREATE_OPFOR_PARADROP;
// or
// [_position] spawn CREATE_OPFOR_TOWER;

// Spawn Moveable Container
 _container = [format["return_point_%1",(SIDE_A select 0)]] call CREATE_MOVEABLE_CONTAINER;
// while { damage _container < 1 && count nearestObjects[_position,["Land_Misc_Cargo1E_EP1"],20] == 0 } do { sleep 5 };

// Spawn Deployable Tower
 _container = [_position] call CREATE_MOVEABLE_TOWER;
// while { count nearestObjects[ _position, ["Land_Vysilac_FM"], 80] == 0 && alive _container} do { sleep 5 };

// Spawn Moveable Deployable FOB
 _container = [format["return_point_%1",(SIDE_A select 0)]] call CREATE_MOVEABLE_FOB;
 while { damage _container < 1 && count nearestObjects[_position,["Land_Misc_Cargo1E_EP1"],20] == 0 } do { sleep 5 };

// Spawn Scud with Fire Sequence
// _scudgrp = createGroup east; _vehtype = "MAZ_543_SCUD_TK_EP1"; _scud1 = ([_position,0,_vehtype,_scudgrp] call BIS_fnc_spawnVehicle) select 0;
// scudcount = 0; fired = false;
// 
// while { damage _scud1 < 1 && (scudState _scud1) < 3 && scudcount < 300} do {
//	sleep 1;scudcount = scudcount + 1;
//	switch (scudcount) do {
//		case 15 : { fire = _scud1 action ["scudLaunch",_scud1]; };
//		case 30 : { fire = _scud1 action ["scudStart",_scud1]; };
//	};
// };

// Spawn destroyable Blackhawk usin C4 only
// _chopper = "UH60M_EP1" createvehicle (_position);
// _chopper setDamage 0.9;
// _chopper setFuel 0;
// _chopper lock true;
// [_chopper] spawn mps_object_c4only;
// While{ damage _chopper < 1 } do { sleep 5 };

//_newComp = [_position,random 360,"BunkerMedium09_EP1"] call BIS_fnc_dyno;

sleep 10;

[format["TASK%1",_taskid],"succeeded"] call mps_tasks_upd;
mps_mission_status = 2;
*/
