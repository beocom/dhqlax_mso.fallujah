/**
 * Initialise un véhicule remorqueur
 *
 * Initializes a tow vehicle
 * 
 * @param 0 le remorqueur
 */

private ["_tow", "_is_disabled", "_trailer"];

_tow = _this select 0;

_is_disabled = _tow getVariable "R3F_LOG_disabled";
if (isNil "_is_disabled") then
{
	_tow setVariable ["R3F_LOG_disabled", false];
};

// Local definition of the variable if it is not defined on the network
_trailer = _tow getVariable "R3F_LOG_remorque";
if (isNil "_trailer") then
{
	_tow setVariable ["R3F_LOG_remorque", objNull, false];
};

_tow addAction [("<t color=""#dddd00"">" + STR_R3F_LOG_action_remorquer_deplace + "</t>"), "support\modules\R3F_logistics\R3F_LOG\tow\tow_move.sqf", nil, 6, true, true, "", "R3F_LOG_object_addAction == _target && R3F_LOG_action_remorquer_deplace_valide"];

_tow addAction [("<t color=""#eeeeee"">" + STR_R3F_LOG_action_remorquer_selection + "</t>"), "support\modules\R3F_logistics\R3F_LOG\tow\tow_selection.sqf", nil, 6, true, true, "", "R3F_LOG_object_addAction == _target && R3F_LOG_action_remorquer_selection_valide"];