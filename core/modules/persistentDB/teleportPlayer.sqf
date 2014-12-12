/* 
 * Filename:
 * teleportPlayer.sqf 
 *
 * Description:
 * Called from pdbTeleportPrompt dialog
 * 
 * Created by [KH]Jman
 * Creation date: 11/05/2012
 * Email: jman@kellys-heroes.eu
 * Web: http://www.kellys-heroes.eu
 * 
 * */

// ====================================================================================
// MAIN


	_player =  _this select 0;                
	_teleportToLocation = _this select 1;                     

		if (player != _player) exitWith { };

				_thisPosition = player getVariable "pPosition";	
				_thispside = player getVariable "playerSide";	
				_thispdirection = player getVariable "pdirection";	
				_thispstance = player getVariable "pstance";	
				_thispvehicle = player getVariable "pvehicle";	
				_thispseat = player getVariable "pseat";	


	diag_log ["PersistentDB: (teleportPlayer) _player:", _player, typeName _player];			
    diag_log ["PersistentDB: (teleportPlayer) teleportToLocation:", _teleportToLocation, typeName _teleportToLocation];

	
	if (_teleportToLocation == 1) then {
					
						if ((count _thisPosition) >0) then {	
								if (str(playerside) == _thispside) then { player setPosATL _thisPosition; };
						//		player sideChat format["Player, %1 teleported to coords %2", _thispname, _thisPosition];
						};
							
						if (_thispdirection != -1) then {
								if (str(playerside) == _thispside) then { player setDir _thispdirection; };
						//		player sideChat format["Player, %1 direction restored to %2", _thispname, _thispdirection];
						};
							
						if (_thispstance != "Stand") then {
								if (str(playerside) == _thispside) then {  player playAction _thispstance;  };
						//		player sideChat format["Player, %1 stance restored to %2", _thispname, _thispstance];
						};	
					
				
					if (_thispvehicle != "") then {	
						//	player sideChat format["Player, %1 entered vehicle %2", _thispname, _thispvehicle];
				 				{
				 					if ( str(_x) == _thispvehicle) exitWith {
				 				//		diag_log ["_x: ",  _x, typeName _x];
				 				//		diag_log ["player: ",  player, typeName player];
									 			if (_thispseat != "") then {	
												//	player sideChat format["Player, %1 entered vehicle position  %2", _thispname, _thispseat];	
															switch (_thispseat) do
															{
															   case "driver":
																{
											//				   diag_log ["player is driver"];
																   player assignAsDriver _x;
						                                           player moveInDriver _x;	
																};
															   case "gunner":
																{
												//					diag_log ["player is gunner"];
																	player assignAsGunner _x;
						                                        	player moveInGunner _x;
						
																};
															   case "commander":
																{
													//				diag_log ["player is commander"];
																    player assignAsCommander _x;	
						                                        	player moveInCommander _x;
																};
															};
												} else {
													  player assignAsCargo _x;
					                         		  player moveInCargo _x;	
												};								
				 					};
				 				} forEach vehicles; 		
					};
					
					
	};
		
// ====================================================================================