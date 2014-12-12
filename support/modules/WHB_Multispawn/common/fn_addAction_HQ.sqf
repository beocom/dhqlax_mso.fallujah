// Function used to Add all the necessary actions to HQs that are active on the server
// Author: WobbleyheadedBob aka CptNoPants

private ["_hqObject"];
_hqObject = _this select 0;

_hqObject addAction [("<t color=""#dddd00"">" + "Deploy FOB HQ" + "</t>"), "support\modules\WHB_Multispawn\common\fn_Action_Deploy.sqf"]; 
_hqObject addAction [("<t color=""#dddd00"">" + "Sign in at FOB" + "</t>"), "support\modules\WHB_Multispawn\common\fn_Action_SignInFOB.sqf"];
_hqObject addAction [("<t color=""#dddd00"">" + "Pack up FOB HQ" + "</t>"), "support\modules\WHB_Multispawn\common\fn_Action_unDeploy.sqf"];