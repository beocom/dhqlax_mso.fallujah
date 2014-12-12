/* 
 * Filename:
 * playerDamage.sqf 
 *
 * Description:
 * Called from init.sqf
 * 
 * Created by [KH]Jman
 * Creation date: 15/12/2010
 * Email: jman@kellys-heroes.eu
 * Web: http://www.kellys-heroes.eu
 * 
 * This script is a workaround until https://dev-heaven.net/issues/27682
 *
 * */
// ====================================================================================
// MAIN

	//	 diag_log["playerDamage: ", _this];
/*		
# unit: Object - Object the event handler is assigned to 
# selectionName: String - Name of the selection where the unit was damaged
# damage: Number - Resulting level of damage
*/



		_player = _this select 0;                              
		_selectionName = _this select 1;
		_damage = _this select 2;


			if (player != _player) exitWith { };
			
	//		 diag_log["playerDamage: ", _this];
			 
			// convert damage to string
			_damageSTR = str(_damage);
			
			switch (_selectionName) do
			{
			   case "": 
				{
				// add the over-all structural damage value
				_player setVariable ["damage", _damageSTR, true];
				};
			   case "head_hit": 
			   {	   
				// add the head_hit damage value
				_player setVariable ["head_hit", _damageSTR, true];
			   }; 
			   case "body":  
			   {
				// add the body damage value 
				_player setVariable ["body", _damageSTR, true];
			   }; 
			   case "hands": 
			   {
				// add the hands damage value
				_player setVariable ["hands", _damageSTR, true];
			   }; 
			   case "legs":  
			   {
			   	// add the legs damage value
				_player setVariable ["legs", _damageSTR, true];
			   }; 
			}; 
			
					_damage; // return damage to engine to process.
     

// ====================================================================================