#include <crbprofiler.hpp>

private ["_server_file","_update_rate"];
_server_file = "\mso\mso_uids.txt"; //File path relative to ArmA2 directory
_update_rate = 30; //minimum 30 seconds

// do not edit below this

if (isserver) then {       
        {
                if (_x iskindof "Air") then {
                        _x addEventhandler ["GetIn", {[_this,{MSO_R_Air}] execFSM "core\modules\rmm_mp_rights\vehicledrivercheck.fsm"}];
                };
                if (_x iskindof "Tank") then {
                        _x addEventhandler ["GetIn", {[_this,{MSO_R_Crew}] execFSM "core\modules\rmm_mp_rights\vehicledrivercheck.fsm"}];
                };
        } foreach vehicles;
        
        [_server_file, _update_rate] spawn {
                private ["_uid","_server_file","_update_rate","_contents"];
                _server_file = _this select 0;
                _update_rate = _this select 1;
                while{true} do {
                        CRBPROFILERSTART("MP Rights")
                        
                        _contents = call compile preprocessFileLineNumbers _server_file;
                        if(isNil "_contents") exitWith {
                                MSO_R_Admin = [""];
                                MSO_R_Leader = [""];
                                MSO_R_Officer = [""];
                                MSO_R_Air = [""];
                                MSO_R_Crew = [""];
                        };
                        
                        if (!([_contents, MP_rights_list] call BIS_fnc_areEqual)) then {
                                MP_rights_list = _contents;
                                MSO_R_Admin = [];
                                MSO_R_Leader = [];
                                MSO_R_Officer = [];
                                MSO_R_Air = [];
                                MSO_R_Crew = [];
                                {
                                        _uid = _x select 0;
                                        MSO_R = _x select 2;
                                        if ("admin" in MSO_R) then {
                                                MSO_R_Admin set [count MSO_R_Admin, _uid];
                                        } else {
                                                MSO_R_Admin = MSO_R_Admin  - [_uid];
                                        };
                                        if (toUpper(_x select 1) in ["CORPORAL","SERGEANT","LIEUTENANT"] || "admin" in MSO_R) then {
                                                MSO_R_Leader set [count MSO_R_Leader, _uid];
                                        } else {
                                                MSO_R_Leader = MSO_R_Leader  - [_uid];
                                        };
                                        if (toUpper(_x select 1) == "LIEUTENANT" || "admin" in MSO_R) then {
                                                MSO_R_Officer set [count MSO_R_Officer, _uid];
                                        } else {
                                                MSO_R_Officer = MSO_R_Officer  - [_uid];
                                        };
                                        if ("pilot" in MSO_R || "admin" in MSO_R) then {
                                                MSO_R_Air set [count MSO_R_Air, _uid];
                                        } else {
                                                MSO_R_Air = MSO_R_Air  - [_uid];
                                        };
                                        if ("crew" in MSO_R || "admin" in MSO_R) then {
                                                MSO_R_Crew set [count MSO_R_Crew, _uid];
                                        } else {
                                                MSO_R_Crew = MSO_R_Crew  - [_uid];
                                        };
                                } foreach MP_rights_list;
                                publicVariable "MSO_R_Admin";
                                publicVariable "MSO_R_Leader";
                                publicVariable "MSO_R_Officer";
                                publicVariable "MSO_R_Air";
                                publicVariable "MSO_R_Crew";
                                
                        };                
                        CRBPROFILERSTOP
                        sleep _update_rate;
                };
        };
};

true;
