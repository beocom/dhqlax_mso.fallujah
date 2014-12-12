/**
 * Héliporte un objet avec un héliporteur
 *
 * An object with a helicopter Helicarrier
 * 
 * @param 0 l'héliporteur
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
	
	private ["_heliporteur", "_object"];
	
	_heliporteur = _this select 0;
	_object = nearestObjects [_heliporteur, R3F_LOG_CFG_objets_heliportables, 20];
	// Because an object can be Helicarrier heliportable
	_object = _object - [_heliporteur];
	
	if (count _object > 0) then
	{
		_object = _object select 0;
		
		if !(_object getVariable "R3F_LOG_disabled") then
		{
			if (isNull (_object getVariable "R3F_LOG_est_transporte_par")) then
			{
				if (count crew _object == 0) then
				{
					// If the object is not being moved by a player
					if (isNull (_object getVariable "R3F_LOG_est_deplace_par") || (!alive (_object getVariable "R3F_LOG_est_deplace_par"))) then
					{
						private ["_ne_remorque_pas", "_trailer"];
						// Not transported by helicopter towing something else
						_ne_remorque_pas = true;
						_trailer = _object getVariable "R3F_LOG_remorque";
						if !(isNil "_trailer") then
						{
							if !(isNull _trailer) then
							{
								_ne_remorque_pas = false;
							};
						};
						
						if (_ne_remorque_pas) then
						{
							// On mémorise sur le réseau que l'héliporteur remorque quelque chose
							_heliporteur setVariable ["R3F_LOG_heliporte", _object, true];
							// On mémorise aussi sur le réseau que l'objet est attaché à un véhicule
							_object setVariable ["R3F_LOG_est_transporte_par", _heliporteur, true];
							
							// Attacher sous l'héliporteur au ras du sol
							_object attachTo [_heliporteur, [
								0,
								0,
								(boundingBox _heliporteur select 0 select 2) - (boundingBox _object select 0 select 2) - (getPos _heliporteur select 2) + 0.5
							]];
							
							player globalChat format [STR_R3F_LOG_action_heliporter_fait, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
						}
						else
						{
							player globalChat format [STR_R3F_LOG_action_heliporter_objet_remorque, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
						};
					}
					else
					{
						player globalChat format [STR_R3F_LOG_action_heliporter_deplace_par_joueur, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
					};
				}
				else
				{
					player globalChat format [STR_R3F_LOG_action_heliporter_joueur_dans_objet, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
				};
			}
			else
			{
				player globalChat format [STR_R3F_LOG_action_heliporter_deja_transporte, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
			};
		};
	};
	
	R3F_LOG_mutex_local_verrou = false;
};