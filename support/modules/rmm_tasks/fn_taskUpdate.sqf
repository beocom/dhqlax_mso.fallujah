/*
states
* none
* created
* assigned
* succeeded
* failed
* canceled
*/

private ["_task","_state"];

_task = _this select 0;
_state = _this select 1;

if (taskstate _task != _state) then {
        _task settaskstate _state;
        _task call tasks_fnc_taskHint;
};