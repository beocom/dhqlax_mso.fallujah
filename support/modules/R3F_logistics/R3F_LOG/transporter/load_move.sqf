/**
 * Charger l'objet d�plac� par le joueur dans un transporteur
 *
 * Load the object moved by the player in a carrier
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
	
	private ["_objet", "_classes_transporteurs", "_transporteur", "_i"];
	
	_objet = R3F_LOG_joueur_deplace_objet;
	
	_transporteur = nearestObjects [_objet, R3F_LOG_classes_transporteurs, 22];
	// Because the carrier may be a portable object
	_transporteur = _transporteur - [_objet];
	
	if (count _transporteur > 0) then
	{
		_transporteur = _transporteur select 0;
		
		if (alive _transporteur && ([0,0,0] distance velocity _transporteur < 6) && (getPos _transporteur select 2 < 2) && !(_transporteur getVariable "R3F_LOG_disabled")) then
		{
			private ["_objets_charges", "_chargement_actuel", "_cout_capacite_objet", "_chargement_maxi"];
			
			_objets_charges = _transporteur getVariable "R3F_LOG_objets_charges";
			
			// Calculation of the load current
			_chargement_actuel = 0;
			{
				for [{_i = 0}, {_i < count R3F_LOG_CFG_objets_transportables}, {_i = _i + 1}] do
				{
					if (_x isKindOf (R3F_LOG_CFG_objets_transportables select _i select 0)) exitWith
					{
						_chargement_actuel = _chargement_actuel + (R3F_LOG_CFG_objets_transportables select _i select 1);
					};
				};
			} forEach _objets_charges;
			
			// Search of the capacity of the object
			_cout_capacite_objet = 99999;
			for [{_i = 0}, {_i < count R3F_LOG_CFG_objets_transportables}, {_i = _i + 1}] do
			{
				if (_objet isKindOf (R3F_LOG_CFG_objets_transportables select _i select 0)) exitWith
				{
					_cout_capacite_objet = (R3F_LOG_CFG_objets_transportables select _i select 1);
				};
			};
			
			// Finding the maximum capacity of the carrier
			_chargement_maxi = 0;
			for [{_i = 0}, {_i < count R3F_LOG_CFG_transporteurs}, {_i = _i + 1}] do
			{
				if (_transporteur isKindOf (R3F_LOG_CFG_transporteurs select _i select 0)) exitWith
				{
					_chargement_maxi = (R3F_LOG_CFG_transporteurs select _i select 1);
				};
			};
			
			// If the object is housed in the vehicle
			if (_chargement_actuel + _cout_capacite_objet <= _chargement_maxi) then
			{
				// Is stored on the network the new contents of the vehicle
				_objets_charges set [count _objets_charges, _objet];
				_transporteur setVariable ["R3F_LOG_objets_charges", _objets_charges, true];
				
				player globalChat STR_R3F_LOG_action_charger_deplace_en_cours;
				
				// Make releasing the object to the player (if he has it in "hands")
				R3F_LOG_joueur_deplace_objet = objNull;
				sleep 2;
				
				// Choose a disengaged position (sphere of radius 50m) in the sky in a cube of 3 ^ 9km
				private ["_nb_tirage_pos", "_position_attache"];
				_position_attache = [random 3000, random 3000, (10000 + (random 3000))];
				_nb_tirage_pos = 1;
				while {(!isNull (nearestObject _position_attache)) && (_nb_tirage_pos < 25)} do
				{
					_position_attache = [random 3000, random 3000, (10000 + (random 3000))];
					_nb_tirage_pos = _nb_tirage_pos + 1;
				};
				
				_objet attachTo [R3F_LOG_PUBVAR_point_attache, _position_attache];
				
				player globalChat format [STR_R3F_LOG_action_charger_deplace_fait, getText (configFile >> "CfgVehicles" >> (typeOf _transporteur) >> "displayName")];
			}
			else
			{
				player globalChat STR_R3F_LOG_action_charger_deplace_pas_assez_de_place;
			};
		};
	};
	
	R3F_LOG_mutex_local_verrou = false;
};