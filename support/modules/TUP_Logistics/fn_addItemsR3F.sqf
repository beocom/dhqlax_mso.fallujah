/*
[vehicleName, [array of items]] execVM "addItems.sqf";

example:
[myTruck, [sandbag1, sandbag2, tent]] execVM "addItems.sqf";

*/

// Code by Raptor[VRC]

// LOG module needs to be running for this to work
waitUntil {!isNil "R3F_LOG_PUBVAR_point_attache"};

private ["_objectArray", "_vehicle", "_currentItems"];

// Parameters
_vehicle = _this select 0;
_objectArray = _this select 1;

// Add items to the vehicle
_currentItems = [];
_currentItems = _vehicle getVariable "R3F_LOG_objets_charges";
if (isNil "_currentItems") then {_currentItems = []};
_currentItems = _currentItems + _objectArray;

_vehicle setVariable ["R3F_LOG_objets_charges", _currentItems, true];

// This block of code comes from R3F_ARTY_AND_LOG\R3F_LOG\transporteur\charger_deplace.sqf
// Absolutely all credit goes to R3F and madbull
{
    private ["_position_attache", "_nb_tirage_pos"];
    _position_attache = [random 3000, random 3000, (10000 + (random 3000))];
    _nb_tirage_pos = 1;
    while {(!isNull (nearestObject _position_attache)) && (_nb_tirage_pos < 25)} do
    {
        _position_attache = [random 3000, random 3000, (10000 + (random 3000))];
        _nb_tirage_pos = _nb_tirage_pos + 1;
    };
    
    _x attachTo [R3F_LOG_PUBVAR_point_attache, _position_attache];
} forEach _objectArray;