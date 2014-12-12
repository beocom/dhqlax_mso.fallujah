/**
 * Script principal qui initialise les systèmes d'artillerie réaliste et de logistique
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

/*
 * Nouveau fil d'exécution pour assurer une compatibilité ascendante (v1.0 à v1.2).
 * Ces versions préconisaient un #include plutôt que execVM pour appeler ce script.
 * A partir de la v1.3 l'exécution par execVM prend l'avantage pour 3 raisons :
 *     - permettre des appels conditionnels optimisés (ex : seulement pour des slots particuliers)
 *     - l'execVM est mieux connu et compris par l'éditeur de mission
 *     - l'init client de l'arty devient bloquant : il attend une PUBVAR du serveur (le point d'attache)
 *
* New thread to ensure backward compatibility (v1.0 to v1.2).  
* These versions advocated a # include execVM rather than to call this script.  
* From the v1.3 performance by taking advantage execVM for three reasons:  
*	- Allow conditional appeals optimized (eg only for private slots)  
*	- The execVM is better known and understood by the mission editor  
*	- Init the client becomes the arty blocking: it expects a PUBVAR server (the base)
*/
 
[] call
{
	#include "config.sqf"
	#include "R3F_ARTY_disable_enable.sqf"
	#include "R3F_LOG_disable_enable.sqf"
	
	// Loading the language file
	call compile preprocessFile format ["support\modules\R3F_logistics\%1_strings_lang.sqf", R3F_ARTY_AND_LOG_CFG_langage];
	
	if (isServer) then
	{
		// Provided by the server: a direct object (as setDir argument is local)
		R3F_ARTY_AND_LOG_FNCT_PUBVAR_setDir =
		{
			private ["_object", "_direction"];
			_object = _this select 1 select 0;
			_direction = _this select 1 select 1;
			
			// Direct the broadcaster object and effect
			_object setDir _direction;
			_object setPos (getPos _object);
		};
		"R3F_ARTY_AND_LOG_PUBVAR_setDir" addPublicVariableEventHandler R3F_ARTY_AND_LOG_FNCT_PUBVAR_setDir;
	};
	
	#ifdef R3F_ARTY_enable
		#include "R3F_ARTY\init.sqf"
		R3F_ARTY_active = true;
	#endif
	
	#ifdef R3F_LOG_enable
		#include "R3F_LOG\init.sqf"
		R3F_LOG_active = true;
	#else
		// For the actions of PC arti
		R3F_LOG_joueur_deplace_object = objNull;
	#endif
	
	// Auto-detection of permanent objects on the game
	if !(isServer && isDedicated) then
	{
		execVM "support\modules\R3F_logistics\monitor_new_objects.sqf";
	}
	// Light version for the dedicated server
	else
	{
		execVM "support\modules\R3F_logistics\monitor_new_objects_dedicated.sqf";
	};
};