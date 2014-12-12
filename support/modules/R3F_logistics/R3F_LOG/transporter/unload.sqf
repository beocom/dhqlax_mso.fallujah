/**
 * Décharger un objet d'un transporteur - appelé deuis l'interface listant le contenu du transporteur
 * 
 * Unload an object of a carrier - called deuis interface that lists the content of the carrier
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
	
	#include "dlg_constants.h"
	private ["_transporter", "_object_loads", "_object_type_has_unload", "_object_to_unload", "_i"];
	
	_transporter = uiNamespace getVariable "R3F_LOG_dlg_CV_transporteur";
	_object_loads = _transporter getVariable "R3F_LOG_objets_charges";
	
	_object_type_has_unload = lbData [R3F_LOG_IDC_dlg_CV_liste_contenu, lbCurSel R3F_LOG_IDC_dlg_CV_liste_contenu];
	
	closeDialog 0;
	
	// Search for an object type called
	_object_to_unload = objNull;
	for [{_i = 0}, {_i < count _object_loads}, {_i = _i + 1}] do
	{
		if (typeOf (_object_loads select _i) == _object_type_has_unload) exitWith
		{
			_object_to_unload = _object_loads select _i;
		};
	};
	
	if !(isNull _object_to_unload) then
	{
		// Is stored on the network the new content of the carrier (ie with this object in hand)
		_object_loads = _object_loads - [_object_to_unload];
		_transporter setVariable ["R3F_LOG_objets_charges", _object_loads, true];
		
		detach _object_to_unload;
		
		if ({_object_to_unload isKindOf _x} count R3F_LOG_CFG_objets_deplacables > 0) then
		{
			[_object_to_unload] execVM "support\modules\R3F_logistics\R3F_LOG\object_movable\move.sqf";
		}
		else
		{
			private ["_dimension_max"];
			_dimension_max = (((boundingBox _object_to_unload select 1 select 1) max (-(boundingBox _object_to_unload select 0 select 1))) max ((boundingBox _object_to_unload select 1 select 0) max (-(boundingBox _object_to_unload select 0 select 0))));
			
			player globalChat STR_R3F_LOG_action_decharger_en_cours;
			
			sleep 2;
			
			// The object is placed at random towards the rear of the carrier
			_object_to_unload setPos [
				(getPos _transporter select 0) - ((_dimension_max+5+(random 10)-(boundingBox _transporter select 0 select 1))*sin (getDir _transporter - 90+random 180)),
				(getPos _transporter select 1) - ((_dimension_max+5+(random 10)-(boundingBox _transporter select 0 select 1))*cos (getDir _transporter - 90+random 180)),
				0
			];
			_object_to_unload setVelocity [0, 0, 0];
			
			player globalChat STR_R3F_LOG_action_decharger_fait;
		};
	}
	else
	{
		player globalChat STR_R3F_LOG_action_decharger_deja_fait;
	};
	
	R3F_LOG_mutex_local_verrou = false;
};