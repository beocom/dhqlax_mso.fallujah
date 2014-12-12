/**
 * Recherche périodiquement les nouveaux objets pour leur ajouter les fonctionnalités d'artillerie et de logistique si besoin
 * Script à faire tourner dans un fil d'exécution dédié
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "R3F_ARTY_disable_enable.sqf"
#include "R3F_LOG_disable_enable.sqf"

// Pending briefing late
sleep 0.1;

private ["_liste_objets_depl_heli_remorq_transp", "_known_vehicles_list", "_vehicles_list", "_vehicles_list_count", "_i", "_object"];

#ifdef R3F_LOG_enable
// Union tables of object types used in a isKindOf
_liste_objets_depl_heli_remorq_transp = R3F_LOG_CFG_objets_deplacables + R3F_LOG_CFG_objets_heliportables +	R3F_LOG_CFG_objets_remorquables + R3F_LOG_classes_objets_transportables;
#endif

// Contain the list of vehicles (and objects) already initialized
_known_vehicles_list = [];

while {true} do
{
	if !(isNull player) then
	{
		// Recovery of all new vehicles of the card and new objects derived from "Static" (box of ammo, flag, ...) close to the player
		_vehicles_list = (vehicles + nearestObjects [player, ["Static"], 80]) - _known_vehicles_list;
		_vehicles_list_count = count _vehicles_list;
		
		if (_vehicles_list_count > 0) then
		{
			// It goes through all the vehicles in the game in 18 seconds
			for [{_i = 0}, {_i < _vehicles_list_count}, {_i = _i + 1}] do
			{
				_object = _vehicles_list select _i;
				
				#ifdef R3F_LOG_enable
				// If the object is a movable / heli / towable / portable
				if ({_object isKindOf _x} count _liste_objets_depl_heli_remorq_transp > 0) then
				{
					[_object] spawn R3F_LOG_FNCT_object_init;
				};
				
				// If the object is a vehicle Helicarrier
				if ({_object isKindOf _x} count R3F_LOG_CFG_heliporteurs > 0) then
				{
					[_object] spawn R3F_LOG_FNCT_helicarrier_init;
				};
				
				// If the object is a tow vehicle
				if ({_object isKindOf _x} count R3F_LOG_CFG_remorqueurs > 0) then
				{
					[_object] spawn R3F_LOG_FNCT_tow_init;
				};
				
				// If the object is a tow vehicle
				if ({_object isKindOf _x} count R3F_LOG_classes_transporteurs > 0) then
				{
					[_object] spawn R3F_LOG_FNCT_transporter_init;
				};
				#endif
				
				#ifdef R3F_ARTY_enable
				// If the object is a piece of artillery from one type to manage
				if ({_object isKindOf _x} count R3F_ARTY_CFG_pieces_artillerie > 0) then
				{
					[_object] spawn R3F_ARTY_FNCT_piece_init;
				};
				
				// If the object is to provide a calculator of artillery from the inside
				if ({_object isKindOf _x} count R3F_ARTY_CFG_calculateur_interne > 0) then
				{
					_object addAction [("<t color=""#dddd00"">" + STR_R3F_ARTY_action_ouvrir_dlg_SM + "</t>"), "support\modules\R3F_logistics\R3F_ARTY\poste_commandement\ouvrir_dlg_saisie_mission.sqf", nil, 6, false, true, "", "vehicle player == _target"];
				};
				
				// If the object is to provide a calculator of artillery from the inside
				if ({_object isKindOf _x} count R3F_ARTY_CFG_calculateur_externe > 0) then
				{
					_object addAction [("<t color=""#dddd00"">" + STR_R3F_ARTY_action_ouvrir_dlg_SM + "</t>"), "support\modules\R3F_logistics\R3F_ARTY\poste_commandement\ouvrir_dlg_saisie_mission.sqf", nil, 6, true, true, "", "vehicle player == player"];
				};
				
				// If it's a calculator
				if (typeOf _object == "SatPhone") then
				{
					[_object] spawn R3F_ARTY_FNCT_calculateur_init;
				};
				#endif
				
				// Objects have been initialized, it stores them for no longer reset
				_known_vehicles_list set [count _known_vehicles_list,_object];
				sleep (18/_vehicles_list_count);
			};
		}
		else
		{
			sleep 18;
		};
	}
	else
	{
		sleep 2;
	};
};