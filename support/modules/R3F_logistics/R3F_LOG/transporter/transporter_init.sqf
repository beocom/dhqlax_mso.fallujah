/**
 * Initialise un véhicule transporteur
 *
 * Initializes a vehicle transporter
 * 
 * @param 0 le transporteur
 */

private ["_transporteur", "_est_desactive", "_objets_charges"];

_transporteur = _this select 0;

_est_desactive = _transporteur getVariable "R3F_LOG_disabled";
if (isNil "_est_desactive") then
{
	_transporteur setVariable ["R3F_LOG_disabled", false];
};

// Local definition of the variable if it is not defined on the network
_objets_charges = _transporteur getVariable "R3F_LOG_objets_charges";
if (isNil "_objets_charges") then
{
	_transporteur setVariable ["R3F_LOG_objets_charges", [], false];
};

_transporteur addAction [("<t color=""#dddd00"">" + STR_R3F_LOG_action_charger_deplace + "</t>"), "support\modules\R3F_logistics\R3F_LOG\transporter\load_move.sqf", nil, 6, true, true, "", "R3F_LOG_object_addAction == _target && R3F_LOG_action_charger_deplace_valide"];

_transporteur addAction [("<t color=""#eeeeee"">" + STR_R3F_LOG_action_charger_selection + "</t>"), "support\modules\R3F_logistics\R3F_LOG\transporter\load_selection.sqf", nil, 6, true, true, "", "R3F_LOG_object_addAction == _target && R3F_LOG_action_charger_selection_valide"];

_transporteur addAction [("<t color=""#dddd00"">" + STR_R3F_LOG_action_contenu_vehicule + "</t>"), "support\modules\R3F_logistics\R3F_LOG\transporter\see_vehicle_contents.sqf", nil, 5, false, true, "", "R3F_LOG_object_addAction == _target && R3F_LOG_action_contenu_vehicule_valide"];