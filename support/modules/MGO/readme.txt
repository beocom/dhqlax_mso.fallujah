INSTALLATION

Place the Require CBA module in your mission (through the editor), if not already present.

Move the mgo folder into your mission (alongside your init.sqf) and add this line to your init.sqf:
call compile preprocessFileLineNumbers "mgo\main\init.sqf";

For mission parameters, add this line within class Params in description.ext:
#include "mgo\main\script_params.hpp"