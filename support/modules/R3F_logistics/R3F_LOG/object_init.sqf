/**
 * Initialise un objet déplaçable/héliportable/remorquable/transportable
 * 
 * @param 0 l'objet
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

private ["_object", "_is_disabled", "_is_transported_by", "_is_displaced_by"];

_object = _this select 0;

_is_disabled = _object getVariable "R3F_LOG_disabled";
if (isNil "_is_disabled") then
{
	_object setVariable ["R3F_LOG_disabled", false];
};

// Local definition of the variable if it is not defined on the network
_is_transported_by = _object getVariable "R3F_LOG_est_transporte_par";
if (isNil "_is_transported_by") then
{
	_object setVariable ["R3F_LOG_est_transporte_par", objNull, false];
};

// Local definition of the variable if it is not defined on the network
_is_displaced_by = _object getVariable "R3F_LOG_est_deplace_par";
if (isNil "_is_displaced_by") then
{
	_object setVariable ["R3F_LOG_est_deplace_par", objNull, false];
};

// Do not get into a vehicle is in transit
_object addEventHandler ["GetIn",
{
	if (_this select 2 == player) then
	{
		_this spawn
		{
			if ((!(isNull (_this select 0 getVariable "R3F_LOG_est_deplace_par")) && (alive (_this select 0 getVariable "R3F_LOG_est_deplace_par"))) || !(isNull (_this select 0 getVariable "R3F_LOG_est_transporte_par"))) then
			{
				player action ["eject", _this select 0];
				player globalChat STR_R3F_LOG_transport_en_cours;
			};
		};
	};
}];

if ({_object isKindOf _x} count R3F_LOG_CFG_objets_deplacables > 0) then
{
	_object addAction [("<t color=""#dddd00"">" + STR_R3F_LOG_action_deplacer_objet + "</t>"), "support\modules\R3F_logistics\R3F_LOG\object_movable\move.sqf", nil, 5, false, true, "", "R3F_LOG_object_addAction == _target && R3F_LOG_action_deplacer_objet_valide"];
};

if ({_object isKindOf _x} count R3F_LOG_CFG_objets_remorquables > 0) then
{
	if ({_object isKindOf _x} count R3F_LOG_CFG_objets_deplacables > 0) then
	{
		_object addAction [("<t color=""#dddd00"">" + STR_R3F_LOG_action_remorquer_deplace + "</t>"), "support\modules\R3F_logistics\R3F_LOG\tow\tow_move.sqf", nil, 6, true, true, "", "R3F_LOG_object_addAction == _target && R3F_LOG_action_remorquer_deplace_valide"];
	};
	
	_object addAction [("<t color=""#dddd00"">" + STR_R3F_LOG_action_selectionner_objet_remorque + "</t>"), "support\modules\R3F_logistics\R3F_LOG\tow\select_object.sqf", nil, 5, false, true, "", "R3F_LOG_object_addAction == _target && R3F_LOG_action_selectionner_objet_remorque_valide"];
	
	_object addAction [("<t color=""#dddd00"">" + STR_R3F_LOG_action_detacher + "</t>"), "support\modules\R3F_logistics\R3F_LOG\tow\detach.sqf", nil, 6, true, true, "", "R3F_LOG_object_addAction == _target && R3F_LOG_action_detacher_valide"];
};

if ({_object isKindOf _x} count R3F_LOG_classes_objets_transportables > 0) then
{
	if ({_object isKindOf _x} count R3F_LOG_CFG_objets_deplacables > 0) then
	{
		_object addAction [("<t color=""#dddd00"">" + STR_R3F_LOG_action_charger_deplace + "</t>"), "support\modules\R3F_logistics\R3F_LOG\transporter\load_move.sqf", nil, 6, true, true, "", "R3F_LOG_object_addAction == _target && R3F_LOG_action_charger_deplace_valide"];
	};
	
	_object addAction [("<t color=""#dddd00"">" + STR_R3F_LOG_action_selectionner_objet_charge + "</t>"), "support\modules\R3F_logistics\R3F_LOG\transporter\select_object.sqf", nil, 5, false, true, "", "R3F_LOG_object_addAction == _target && R3F_LOG_action_selectionner_objet_charge_valide"];
};