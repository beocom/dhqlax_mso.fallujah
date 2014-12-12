/**
 * Fait déplacer un objet par le joueur. Il garde l'objet tant qu'il ne le relâche pas ou ne meurt pas.
 * L'objet est relaché quand la variable R3F_LOG_joueur_deplace_objet passe à objNull ce qui terminera le script
 * 
 * Made move an object by the player. It keeps the subject until he releases it or not does not die.
 * The object is released when the variable passes R3F_LOG_joueur_deplace_objet objNull which will terminate the script
 *
 * @param 0 l'objet à déplacer
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

if (R3F_LOG_mutex_local_verrou) then
{
	player globalChat STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_verrou = true;
	
	R3F_LOG_objet_selectionne = objNull;
	
	private ["_object", "_is_calculator", "_main_weapon", "_action_menu", "_cannon_azimuth"];
	
	_object = _this select 0;
	
	// If the object is a calculator of artillery, the script is allowed to manage specialized
	_is_calculator = _object getVariable "R3F_ARTY_est_calculateur";
	if !(isNil "_is_calculator") then
	{
		R3F_LOG_mutex_local_verrou = false;
		[_object] execVM "support\modules\R3F_logistics\R3F_ARTY\poste_commandement\deplacer_calculateur.sqf";
	}
	else
	{
		_object setVariable ["R3F_LOG_est_deplace_par", player, true];
		
		R3F_LOG_joueur_deplace_objet = _object;
		
		// Backup and removal of the primary weapon
		_main_weapon = primaryWeapon player;
		if (_main_weapon != "") then
		{
			player playMove "AidlPercMstpSnonWnonDnon04";
			sleep 2;
			player removeWeapon _main_weapon;
		}
		else {sleep 0.5;};
		
		// If the player has died during sleep, it puts everything back as before
		if (!alive player) then
		{
			R3F_LOG_joueur_deplace_objet = objNull;
			_object setVariable ["R3F_LOG_est_deplace_par", objNull, true];
			// AttachTo because of "load" positions the object aloft:
			_object setPos [getPos _object select 0, getPos _object select 1, 0];
			_object setVelocity [0, 0, 0];
			
			R3F_LOG_mutex_local_verrou = false;
		}
		else
		{
			_object attachTo [player, [
				0,
				(((boundingBox _object select 1 select 1) max (-(boundingBox _object select 0 select 1))) max ((boundingBox _object select 1 select 0) max (-(boundingBox _object select 0 select 0)))) + 1,
				1]
			];
			
			if (count (weapons _object) > 0) then
			{
				// The gun must be pointing in front of us (if it seems to be impaled)
				_cannon_azimuth = ((_object weaponDirection (weapons _object select 0)) select 0) atan2 ((_object weaponDirection (weapons _object select 0)) select 1);
				
				// One is forced to ask the server to turn the barrel for us
				R3F_ARTY_AND_LOG_PUBVAR_setDir = [_object, (getDir _object)-_cannon_azimuth];
				if (isServer) then
				{
					["R3F_ARTY_AND_LOG_PUBVAR_setDir", R3F_ARTY_AND_LOG_PUBVAR_setDir] spawn R3F_ARTY_AND_LOG_FNCT_PUBVAR_setDir;
				}
				else
				{
					publicVariable "R3F_ARTY_AND_LOG_PUBVAR_setDir";
				};
			};
			
			R3F_LOG_mutex_local_verrou = false;
			
			_action_menu = player addAction [("<t color=""#dddd00"">" + STR_R3F_LOG_action_relacher_objet + "</t>"), "support\modules\R3F_logistics\R3F_LOG\object_movable\release.sqf", nil, 5, true, true];
			
			// It limits the speed of walking and is forbidden to ride in a vehicle until the object is brought
			while {!isNull R3F_LOG_joueur_deplace_objet && alive player} do
			{
				if (vehicle player != player) then
				{
					player globalChat STR_R3F_LOG_ne_pas_monter_dans_vehicule;
					player action ["eject", vehicle player];
					sleep 1;
				};
				
				if ([0,0,0] distance (velocity player) > 2.8) then
				{
					player globalChat STR_R3F_LOG_courir_trop_vite;
					player playMove "AmovPpneMstpSnonWnonDnon";
					sleep 1;
				};
				
				sleep 0.25;
			};
			
			// The object is no longer worn, it is based
			detach _object;
			_object setPos [getPos _object select 0, getPos _object select 1, 0];
			_object setVelocity [0, 0, 0];
			
			player removeAction _action_menu;
			R3F_LOG_joueur_deplace_objet = objNull;
			
			_object setVariable ["R3F_LOG_est_deplace_par", objNull, true];
			
			// Restoration of the primary weapon
			if (alive player && _main_weapon != "") then
			{
				player addWeapon _main_weapon;
				player selectWeapon _main_weapon;
				player selectWeapon (getArray (configFile >> "cfgWeapons" >> _main_weapon >> "muzzles") select 0);
			};
		};
	};
};