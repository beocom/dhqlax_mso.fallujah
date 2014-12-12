/**
 * Vérifie régulièrement des conditions portant sur l'objet pointé par l'arme du joueur
 * Permet de diminuer la fréquence des vérifications des conditions normalement faites dans les addAction (~60Hz)
 * La justification de ce système est que les conditions sont très complexes (count, nearestObjects)
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
private ["_object_point"];

while {true} do
{
	R3F_LOG_object_addAction = objNull;
	
	_object_point = cursorTarget;
	
	if !(isNull _object_point) then
	{
		if (player distance _object_point < 13) then
		{
			R3F_LOG_object_addAction = _object_point;
			
			// Note: the terms of conditions are not factored to keep the clarity (already it is not really that) (and the gain would be minimal)
			
			// If the object is a movable object
			if ({_object_point isKindOf _x} count R3F_LOG_CFG_objets_deplacables > 0) then
			{
				// Condition Action deplacer_objet
				R3F_LOG_action_deplacer_objet_valide = (vehicle player == player && (count crew _object_point == 0) && (isNull R3F_LOG_joueur_deplace_objet) &&
					(isNull (_object_point getVariable "R3F_LOG_est_deplace_par") || (!alive (_object_point getVariable "R3F_LOG_est_deplace_par"))) &&
					isNull (_object_point getVariable "R3F_LOG_est_transporte_par") && !(_object_point getVariable "R3F_LOG_disabled"));
			};
			
			// If the object is an object towable
			if ({_object_point isKindOf _x} count R3F_LOG_CFG_objets_remorquables > 0) then
			{
				// And is movable
				if ({_object_point isKindOf _x} count R3F_LOG_CFG_objets_deplacables > 0) then
				{
					// Condition Action remorquer_deplace
					R3F_LOG_action_remorquer_deplace_valide = (vehicle player == player && (alive R3F_LOG_joueur_deplace_objet) &&
						(count crew _object_point == 0) && (R3F_LOG_joueur_deplace_objet == _object_point) &&
						({_x != _object_point && alive _x && isNull (_x getVariable "R3F_LOG_remorque") && ([0,0,0] distance velocity _x < 6) && (getPos _x select 2 < 2) && !(_x getVariable "R3F_LOG_disabled")} count (nearestObjects [_object_point, R3F_LOG_CFG_remorqueurs, 18])) > 0 &&
						!(_object_point getVariable "R3F_LOG_disabled"));
				};
				
				// Condition Action selectionner_objet_remorque
				R3F_LOG_action_selectionner_objet_remorque_valide = (vehicle player == player && (alive _object_point) && (count crew _object_point == 0) &&
					isNull R3F_LOG_joueur_deplace_objet && isNull (_object_point getVariable "R3F_LOG_est_transporte_par") &&
					(isNull (_object_point getVariable "R3F_LOG_est_deplace_par") || (!alive (_object_point getVariable "R3F_LOG_est_deplace_par"))) &&
					!(_object_point getVariable "R3F_LOG_disabled"));
				
				// Condition Action detach
				R3F_LOG_action_detacher_valide = (vehicle player == player && (isNull R3F_LOG_joueur_deplace_objet) &&
					!isNull (_object_point getVariable "R3F_LOG_est_transporte_par") && !(_object_point getVariable "R3F_LOG_disabled"));
			};
			
			// If the object is an object transportable
			if ({_object_point isKindOf _x} count R3F_LOG_classes_objets_transportables > 0) then
			{
				// And is movable
				if ({_object_point isKindOf _x} count R3F_LOG_CFG_objets_deplacables > 0) then
				{
					// Condition Action charger_deplace
					R3F_LOG_action_charger_deplace_valide = (vehicle player == player && (count crew _object_point == 0) && (R3F_LOG_joueur_deplace_objet == _object_point) &&
						{_x != _object_point && alive _x && ([0,0,0] distance velocity _x < 6) && (getPos _x select 2 < 2) &&
						!(_x getVariable "R3F_LOG_disabled")} count (nearestObjects [_object_point, R3F_LOG_classes_transporteurs, 18]) > 0 &&
						!(_object_point getVariable "R3F_LOG_disabled"));
				};
				
				// Condition Action selectionner_objet_charge
				R3F_LOG_action_selectionner_objet_charge_valide = (vehicle player == player && (count crew _object_point == 0) &&
					isNull R3F_LOG_joueur_deplace_objet && isNull (_object_point getVariable "R3F_LOG_est_transporte_par") &&
					(isNull (_object_point getVariable "R3F_LOG_est_deplace_par") || (!alive (_object_point getVariable "R3F_LOG_est_deplace_par"))) &&
					!(_object_point getVariable "R3F_LOG_disabled"));
			};
			
			// If the object is a towing vehicle
			if ({_object_point isKindOf _x} count R3F_LOG_CFG_remorqueurs > 0) then
			{
				// Condition Action remorquer_deplace
				R3F_LOG_action_remorquer_deplace_valide = (vehicle player == player && (alive _object_point) && (!isNull R3F_LOG_joueur_deplace_objet) &&
					(alive R3F_LOG_joueur_deplace_objet) && !(R3F_LOG_joueur_deplace_objet getVariable "R3F_LOG_disabled") &&
					({R3F_LOG_joueur_deplace_objet isKindOf _x} count R3F_LOG_CFG_objets_remorquables > 0) &&
					isNull (_object_point getVariable "R3F_LOG_remorque") && ([0,0,0] distance velocity _object_point < 6) &&
					(getPos _object_point select 2 < 2) && !(_object_point getVariable "R3F_LOG_disabled"));
				
				// Condition Action remorquer_selection
				R3F_LOG_action_remorquer_selection_valide = (vehicle player == player && (alive _object_point) && (isNull R3F_LOG_joueur_deplace_objet) &&
					(!isNull R3F_LOG_objet_selectionne) && (R3F_LOG_objet_selectionne != _object_point) &&
					!(R3F_LOG_objet_selectionne getVariable "R3F_LOG_disabled") &&
					({R3F_LOG_objet_selectionne isKindOf _x} count R3F_LOG_CFG_objets_remorquables > 0) &&
					isNull (_object_point getVariable "R3F_LOG_remorque") && ([0,0,0] distance velocity _object_point < 6) &&
					(getPos _object_point select 2 < 2) && !(_object_point getVariable "R3F_LOG_disabled"));
			};
			
			// If the object is a vehicle carrier
			if ({_object_point isKindOf _x} count R3F_LOG_classes_transporteurs > 0) then
			{
				// Condition Action charger_deplace
				R3F_LOG_action_charger_deplace_valide = (alive _object_point && (vehicle player == player) && (!isNull R3F_LOG_joueur_deplace_objet) &&
					!(R3F_LOG_joueur_deplace_objet getVariable "R3F_LOG_disabled") &&
					({R3F_LOG_joueur_deplace_objet isKindOf _x} count R3F_LOG_classes_objets_transportables > 0) &&
					([0,0,0] distance velocity _object_point < 6) && (getPos _object_point select 2 < 2) && !(_object_point getVariable "R3F_LOG_disabled"));
				
				// Condition Action charger_selection
				R3F_LOG_action_charger_selection_valide = (alive _object_point && (vehicle player == player) && (isNull R3F_LOG_joueur_deplace_objet) &&
					(!isNull R3F_LOG_objet_selectionne) && (R3F_LOG_objet_selectionne != _object_point) &&
					!(R3F_LOG_objet_selectionne getVariable "R3F_LOG_disabled") &&
					({R3F_LOG_objet_selectionne isKindOf _x} count R3F_LOG_classes_objets_transportables > 0) &&
					([0,0,0] distance velocity _object_point < 6) && (getPos _object_point select 2 < 2) && !(_object_point getVariable "R3F_LOG_disabled"));
				
				// Condition Action contenu_vehicule
				R3F_LOG_action_contenu_vehicule_valide = (alive _object_point && (vehicle player == player) && (isNull R3F_LOG_joueur_deplace_objet) &&
					([0,0,0] distance velocity _object_point < 6) && (getPos _object_point select 2 < 2) && !(_object_point getVariable "R3F_LOG_disabled"));
			};
		};
	};
	
	// For héliportation, the object is no longer pointed, but it is in
	// If the player is in a Helicarrier
	if ({(vehicle player) isKindOf _x} count R3F_LOG_CFG_heliporteurs > 0) then
	{
		R3F_LOG_object_addAction = vehicle player;
		
		// We are in the vehicle, it shows no options for carrier and tow
		R3F_LOG_action_charger_deplace_valide = false;
		R3F_LOG_action_charger_selection_valide = false;
		R3F_LOG_action_contenu_vehicule_valide = false;
		R3F_LOG_action_remorquer_deplace_valide = false;
		R3F_LOG_action_remorquer_selection_valide = false;
		
		// Condition Action transported by helicopter
		R3F_LOG_action_heliporter_valide = (driver R3F_LOG_object_addAction == player &&
			({_x != R3F_LOG_object_addAction && !(_x getVariable "R3F_LOG_disabled")} count (nearestObjects [R3F_LOG_object_addAction, R3F_LOG_CFG_objets_heliportables, 15]) > 0) &&
			isNull (R3F_LOG_object_addAction getVariable "R3F_LOG_heliporte") && ([0,0,0] distance velocity R3F_LOG_object_addAction < 6) && (getPos R3F_LOG_object_addAction select 2 > 1) &&
			!(R3F_LOG_object_addAction getVariable "R3F_LOG_disabled"));
		
		// Condition Action heliport_larguer
		R3F_LOG_action_heliport_larguer_valide = (driver R3F_LOG_object_addAction == player && !isNull (R3F_LOG_object_addAction getVariable "R3F_LOG_heliporte") &&
			([0,0,0] distance velocity R3F_LOG_object_addAction < 15) && (getPos R3F_LOG_object_addAction select 2 < 40) && !(R3F_LOG_object_addAction getVariable "R3F_LOG_disabled"));
	};
	
	sleep 0.3;
};