/**
 * Larguer un objet en train d'être héliporté
 *
 * Depositing an object being helicopter
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
	
	private ["_helicarrier", "_object"];
	
	_helicarrier = _this select 0;
	_object = _helicarrier getVariable "R3F_LOG_heliporte";
	
	// Is stored on the network that the vehicle does nothing helicopter
	_helicarrier setVariable ["R3F_LOG_heliporte", objNull, true];
	// Is stored on the network also that the object is no longer attached
	_object setVariable ["R3F_LOG_est_transporte_par", objNull, true];
	
	detach _object;
	
	_object setPos [getPos _object select 0, getPos _object select 1, 0];
	_object setVelocity [0, 0, 0];
	
	player globalChat format [STR_R3F_LOG_action_heliport_larguer_fait, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
	
	R3F_LOG_mutex_local_verrou = false;
};