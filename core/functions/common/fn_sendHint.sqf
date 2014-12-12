#include "\x\cba\addons\main\script_macros_mission.hpp"

private ["_module","_message","_logText"];

// Send hint to player
_module = _this select 0;
_message = _this select 1;

_logText = "<br/>Multi-Session Operations<br/><br/><t color='#ffff00' size='1.0' shadow='1' shadowColor='#000000' align='center'>" + _module + "</t><br/><br/><t align='left'>" + _message + "</t><br/><br/>";
hint parseText (_logText);