//Point at target, press button, named veh/obj will be stored in DB on next mission save.
private ["_object","_varName","_psn","_vvn","_id"];

_object = cursorTarget; if (!(alive _object) || (isnull _object) || (cursortarget iskindof "Man")) exitwith {player sidechat "This asset cannot be tracked!"};
_psn = _object getvariable "pdb_save_name";

if ((isNil vehicleVarName _object) && {isnil "_psn"}) then {
	_id = format["%1",str(floor((position _object) select 0)) + str(floor((position _object) select 1))];
	_varName = format["mso_magic_%1",_id];
	_object setVariable ["pdb_save_name",_varName,true];
	waituntil {_psn = _object getvariable "pdb_save_name"; !(isnil "_psn")};
	player sidechat format["Indent sent to the stores. Asset ID %1 will now be tracked by the Quartermaster.",_id]
} else {
	player sidechat format["Asset ID %1(%2) is already persistet!",vehicleVarName _object,_psn];
};