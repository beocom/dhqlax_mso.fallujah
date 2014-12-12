/**
 * Ouvre la boîte de dialogue du contenu du véhicule et la prérempli en fonction de véhicule
 *
 * Open the dialog box contents of the vehicle and the pre-filled based on vehicle
 * 
 * @param 0 le véhicule dont il faut afficher le contenu
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

disableSerialization; // Because of displayCtrl

if (R3F_LOG_mutex_local_verrou) then
{
	player globalChat STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_verrou = true;
	
	private ["_transporter", "_chargement_actuel", "_chargement_maxi", "_contenu", "_tab_contenu_regroupe"];
	private ["_objects_tab", "_tab_quantite", "_i", "_j", "_dlg_contenu_vehicule"];
	
	_transporter = _this select 0;
	
	uiNamespace setVariable ["R3F_LOG_dlg_CV_transporteur", _transporter];
	
	createDialog "R3F_LOG_dlg_contenu_vehicule";
	
	_contenu = _transporter getVariable "R3F_LOG_objets_charges";
	
	/** List of class names of objects contained in the vehicle without duplicate */
	_objects_tab = [];
	/** Associated quantity (by index) in the class names _objects_tab */
	_tab_quantite = [];
	
	_chargement_actuel = 0;
	
	// Preparing the list of contents and quantities associated with objects
	for [{_i = 0}, {_i < count _contenu}, {_i = _i + 1}] do
	{
		private ["_objet"];
		_objet = _contenu select _i;
		
		if !((typeOf _objet) in _objects_tab) then
		{
			_objects_tab set [count _objects_tab, typeOf _objet];
			_tab_quantite = _tab_quantite + [1];
		}
		else
		{
			private ["_idx_objet"];
			_idx_objet = _objects_tab find (typeOf _objet);
			_tab_quantite set [_idx_objet, ((_tab_quantite select _idx_objet) + 1)];
		};
		
		// Addition of the subject of the current loading
		for [{_j = 0}, {_j < count R3F_LOG_CFG_objets_transportables}, {_j = _j + 1}] do
		{
			if (_objet isKindOf (R3F_LOG_CFG_objets_transportables select _j select 0)) exitWith
			{
				_chargement_actuel = _chargement_actuel + (R3F_LOG_CFG_objets_transportables select _j select 1);
			};
		};
	};
	
	// Finding the maximum capacity of the carrier
	_chargement_maxi = 0;
	for [{_i = 0}, {_i < count R3F_LOG_CFG_transporteurs}, {_i = _i + 1}] do
	{
		if (_transporter isKindOf (R3F_LOG_CFG_transporteurs select _i select 0)) exitWith
		{
			_chargement_maxi = (R3F_LOG_CFG_transporteurs select _i select 1);
		};
	};
	
	
	// Display content in the interface
	#include "dlg_constants.h"
	private ["_ctrl_liste"];
	
	_dlg_contenu_vehicule = findDisplay R3F_LOG_IDD_dlg_contenu_vehicule;
	
	/**** START translations of labels ****/
	(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_titre) ctrlSetText STR_R3F_LOG_dlg_CV_titre;
	(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_credits) ctrlSetText STR_R3F_ARTY_LOG_nom_produit;
	(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_btn_decharger) ctrlSetText STR_R3F_LOG_dlg_CV_btn_decharger;
	(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_btn_fermer) ctrlSetText STR_R3F_LOG_dlg_CV_btn_fermer;
	/**** END translations of labels ****/
	
	(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_capacite_vehicule) ctrlSetText (format [STR_R3F_LOG_dlg_CV_capacite_vehicule, _chargement_actuel, _chargement_maxi]);
	
	_ctrl_liste = _dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_liste_contenu;
	
	if (count _objects_tab == 0) then
	{
		(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_btn_decharger) ctrlEnable false;
	}
	else
	{
		// Insertion of each type of objects in the list
		for [{_i = 0}, {_i < count _objects_tab}, {_i = _i + 1}] do
		{
			private ["_index", "_icone"];
			
			_icone = getText (configFile >> "CfgVehicles" >> (_objects_tab select _i) >> "icon");
			
			// If the icon is valid
			if (toString ([toArray _icone select 0]) == "\") then
			{
				_index = _ctrl_liste lbAdd (getText (configFile >> "CfgVehicles" >> (_objects_tab select _i) >> "displayName") + format [" (%1x)", _tab_quantite select _i]);
				_ctrl_liste lbSetPicture [_index, _icone];
			}
			else
			{
				// If the satellite phone to a PC is used artillery
				if (!(isNil "R3F_ARTY_active") && (_objects_tab select _i) == "SatPhone") then
				{
					_index = _ctrl_liste lbAdd ("     " + STR_R3F_LOG_nom_pc_arti + format [" (%1x)", _tab_quantite select _i]);
				}
				else
				{
					_index = _ctrl_liste lbAdd ("     " + getText (configFile >> "CfgVehicles" >> (_objects_tab select _i) >> "displayName") + format [" (%1x)", _tab_quantite select _i]);
				};
			};
			
			_ctrl_liste lbSetData [_index, _objects_tab select _i];
		};
	};
	
	waitUntil (uiNamespace getVariable "R3F_LOG_dlg_contenu_vehicule");
	R3F_LOG_mutex_local_verrou = false;
};