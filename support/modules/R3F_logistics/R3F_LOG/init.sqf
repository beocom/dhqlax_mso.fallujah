/**
 * Script principal qui initialise le système de logistique
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "config.sqf"

if (isServer) then
{
	// It creates the point of attachment to be used for attachTo for objects to be loaded into vehicles virtually
	R3F_LOG_PUBVAR_point_attache = "HeliHEmpty" createVehicle [0, 0, 0];
	publicVariable "R3F_LOG_PUBVAR_point_attache";
};

// A dedicated server does not need
if !(isServer && isDedicated) then
{
	// The client waits for the server I created and published the reference of the object serving as the attachment point
	waitUntil {!isNil "R3F_LOG_PUBVAR_point_attache"};
	
	/** Indicates which object the player is currently moving, though no objNull */
	R3F_LOG_joueur_deplace_objet = objNull;
	
	/** Pseudo-mutex allowing one run script object handling both (true: locked) */
	R3F_LOG_mutex_local_verrou = false;
	
	/** Currently selected object to be loaded/towed */
	R3F_LOG_objet_selectionne = objNull;
	
	// We construct the list of classes of carriers in the quantities involved (for nearestObjects, isKindOf count, ...)
	R3F_LOG_classes_transporteurs = [];
	
	{
		R3F_LOG_classes_transporteurs set [count R3F_LOG_classes_transporteurs, _x select 0];
	} forEach R3F_LOG_CFG_transporteurs;
	
	// We construct the list of classes of transportable in quantities associated (for nearestObjects, isKindOf count, ...)
	R3F_LOG_classes_objets_transportables = [];
	
	{
		R3F_LOG_classes_objets_transportables set [count R3F_LOG_classes_objets_transportables, _x select 0];
	} forEach R3F_LOG_CFG_objets_transportables;
	
	R3F_LOG_FNCT_object_init = compile preprocessFile "support\modules\R3F_logistics\R3F_LOG\object_init.sqf";
	R3F_LOG_FNCT_helicarrier_init = compile preprocessFile "support\modules\R3F_logistics\R3F_LOG\helicarrier\helicarrier_init.sqf";
	R3F_LOG_FNCT_tow_init = compile preprocessFile "support\modules\R3F_logistics\R3F_LOG\tow\tow_init.sqf";
	R3F_LOG_FNCT_transporter_init = compile preprocessFile "support\modules\R3F_logistics\R3F_LOG\transporter\transporter_init.sqf";
	
	/** Shows what is the object affected by the actions of variables addAction */
	R3F_LOG_object_addAction = objNull;
	
	// List of variables or not activating the menu actions
	R3F_LOG_action_charger_deplace_valide = false;
	R3F_LOG_action_charger_selection_valide = false;
	R3F_LOG_action_contenu_vehicule_valide = false;
	
	R3F_LOG_action_remorquer_deplace_valide = false;
	R3F_LOG_action_remorquer_selection_valide = false;
	
	R3F_LOG_action_heliporter_valide = false;
	R3F_LOG_action_heliport_larguer_valide = false;
	
	R3F_LOG_action_deplacer_objet_valide = false;
	R3F_LOG_action_remorquer_deplace_valide = false;
	R3F_LOG_action_selectionner_objet_remorque_valide = false;
	R3F_LOG_action_detacher_valide = false;
	R3F_LOG_action_charger_deplace_valide = false;
	R3F_LOG_action_selectionner_objet_charge_valide = false;
	
	/** This thread of execution can reduce the frequency of audit conditions normally made in addAction (~ 60Hz) */
	execVM "support\modules\R3F_logistics\R3F_LOG\monitor_conditions_actions_menu.sqf";
};