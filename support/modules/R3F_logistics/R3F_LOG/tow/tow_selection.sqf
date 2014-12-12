/**
 * Remorque l'objet sélectionné (R3F_LOG_objet_selectionne) à un véhicule
 *
 * Trailer the selected object (R3F_LOG_objet_selectionne) of a vehicle
 * 
 * @param 0 le remorqueur
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
	
	private ["_objet", "_remorqueur"];
	
	_objet = R3F_LOG_objet_selectionne;
	_remorqueur = _this select 0;
	
	if (!(isNull _objet) && (alive _objet) && !(_objet getVariable "R3F_LOG_disabled")) then
	{
		if (isNull (_objet getVariable "R3F_LOG_est_transporte_par") && (isNull (_objet getVariable "R3F_LOG_est_deplace_par") || (!alive (_objet getVariable "R3F_LOG_est_deplace_par")))) then
		{
			if (_objet distance _remorqueur <= 30) then
			{
				// Is stored on the network that the vehicle trailer something
				_remorqueur setVariable ["R3F_LOG_remorque", _objet, true];
				// It also stores on the network that the barrel is attached to the trailer
				_objet setVariable ["R3F_LOG_est_transporte_par", _remorqueur, true];
				
				// It puts the player on the side of the vehicle, which helps prevent injury and makes the animation more realistic
				player attachTo [_remorqueur, [
					(boundingBox _remorqueur select 1 select 0),
					(boundingBox _remorqueur select 0 select 1) + 1,
					(boundingBox _remorqueur select 0 select 2) - (boundingBox player select 0 select 2)
				]];
				
				player setDir 270;
				player setPos (getPos player);
				
				player playMove "AinvPknlMstpSlayWrflDnon_medic";
				sleep 2;
				
				// Attached to the rear of the vehicle to the ground
				_objet attachTo [_remorqueur, [
					0,
					(boundingBox _remorqueur select 0 select 1) + (boundingBox _objet select 0 select 1) + 3,
					(boundingBox _remorqueur select 0 select 2) - (boundingBox _objet select 0 select 2)
				]];
				
				R3F_LOG_objet_selectionne = objNull;
				
				detach player;
				
				// If the object is a static weapon, the orientation is corrected depending on the direction of the barrel
				if (_objet isKindOf "StaticWeapon") then
				{
					private ["_azimut_canon"];
					
					_azimut_canon = ((_objet weaponDirection (weapons _objet select 0)) select 0) atan2 ((_objet weaponDirection (weapons _objet select 0)) select 1);
					
					// Only the D30 has the gun pointing to the vehicle
					if !(_objet isKindOf "D30_Base") then
					{
						_azimut_canon = _azimut_canon + 180;
					};
					
					// One is forced to ask the server to rotate the object for us
					R3F_ARTY_AND_LOG_PUBVAR_setDir = [_objet, (getDir _objet)-_azimut_canon];
					if (isServer) then
					{
						["R3F_ARTY_AND_LOG_PUBVAR_setDir", R3F_ARTY_AND_LOG_PUBVAR_setDir] spawn R3F_ARTY_AND_LOG_FNCT_PUBVAR_setDir;
					}
					else
					{
						publicVariable "R3F_ARTY_AND_LOG_PUBVAR_setDir";
					};
				};
				
				sleep 5;
			}
			else
			{
				player globalChat format [STR_R3F_LOG_action_remorquer_selection_trop_loin, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
			};
		}
		else
		{
			player globalChat format [STR_R3F_LOG_action_remorquer_selection_objet_transporte, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
		};
	};
	
	R3F_LOG_mutex_local_verrou = false;
};