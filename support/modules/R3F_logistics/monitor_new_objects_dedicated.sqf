/**
 * Recherche périodiquement les nouveaux objets pour leur ajouter les fonctionnalités d'artillerie et de logistique si besoin
 * Script à faire tourner dans un fil d'exécution dédié
 * Version allégée pour un serveur dédié uniquement
 *
 * Research periodically add new items to their functionality artillery and logistics if necessary
 * Script to run in a dedicated thread of execution
 * Light version for a dedicated server only
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "R3F_ARTY_disable_enable.sqf"

// Currently this thread of execution is only useful if the artillery is activated
#ifdef R3F_ARTY_enable

// Pending briefing late
sleep 0.1;

private ["_known_vehicles_list", "_vehicles_list", "_vehicles_list_count", "_i", "_object"];

// Contain the list of vehicles (and objects) already initialized
_known_vehicles_list = [];

while {true} do
{
	// Get all new vehicles of the card EXCEPT objects derived from "Static" is not recoverable by "vehicles"
	_vehicles_list = vehicles - _known_vehicles_list;
	_vehicles_list_count = count _vehicles_list;
	
	if (_vehicles_list_count > 0) then
	{
		// It goes through all the vehicles in the game in 18 seconds
		for [{_i = 0}, {_i < _vehicles_list_count}, {_i = _i + 1}] do
		{
			_object = _vehicles_list select _i;
			
			// #ifdef R3F_ARTY_enable / / Already present earlier in the current version
			// If the object is a piece of artillery from one type to manage
			if ({_object isKindOf _x} count R3F_ARTY_CFG_pieces_artillerie > 0) then
			{
				[_object] spawn R3F_ARTY_FNCT_piece_init_dedie;
			};
			//#endif
			
			// Objects have been initialized, it stores them for no longer reset
			_known_vehicles_list set [count _known_vehicles_list,_object];
			sleep (18/_vehicles_list_count);
		};
	}
	else
	{
		sleep 18;
	};
};

#endif