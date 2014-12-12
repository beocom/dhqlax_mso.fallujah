/**
 * Détacher un objet d'un véhicule
 *
 * Remove an object from a vehicle
 * 
 * @param 0 l'objet à détacher
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
	
	private ["_tow", "_object"];
	
	_object = _this select 0;
	_tow = _object getVariable "R3F_LOG_est_transporte_par";
	
	// Do not allow to land a helicopter object if it is worn
	if ({_tow isKindOf _x} count R3F_LOG_CFG_remorqueurs > 0) then
	{
		// Is stored on the network that the vehicle trailer something
		_tow setVariable ["R3F_LOG_remorque", objNull, true];
		// It also stores network object that is attached to the trailer
		_object setVariable ["R3F_LOG_est_transporte_par", objNull, true];
		
		detach _object;
		_object setVelocity [0, 0, 0];
		
		player playMove "AinvPknlMstpSlayWrflDnon_medic";
		sleep 7;
		
		if ({_object isKindOf _x} count R3F_LOG_CFG_objets_deplacables > 0) then
		{
			// If no one has been re-tow during sleep 7
			if (isNull (_tow getVariable "R3F_LOG_remorque") &&
				(isNull (_object getVariable "R3F_LOG_est_transporte_par")) &&
				(isNull (_object getVariable "R3F_LOG_est_deplace_par"))
			) then
			{
				[_object] execVM "support\modules\R3F_logistics\R3F_LOG\object_movable\move.sqf";
			};
		}
		else
		{
			player globalChat STR_R3F_LOG_action_detacher_fait;
		};
	}
	else
	{
		player globalChat STR_R3F_LOG_action_detacher_impossible_pour_ce_vehicule;
	};
	
	R3F_LOG_mutex_local_verrou = false;
};