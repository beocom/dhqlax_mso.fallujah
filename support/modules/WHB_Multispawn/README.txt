[WHB] FOB Respawn : Forward Operations Base Respawn Script
--------------------------------------------------------------------------------------
This script allows a player to setup multiple forward bases which can be used as respawn 
points. To try an break away from this just being another respawn script, the attempt is 
to make things a little tougher on the player. There is no teleportation or respawn selection 
menu, to respawn at a delpoyed FOB you will first need to travel there and "Sign In".

Feel free to give your feedback on Dev-Heaven : https://dev-heaven.net/projects/mso-logistics

	Copyright (C) 2010 Wobbleyheadedbib [WHB]
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.

Usage:
WHB_Multispawn provides multiple spawn locations at a deployable MHQ. Players have to ‘sign in’
to move their spawn point. The default HQ vehicles and buildings for Arma 2 and Operation 
Arrowhead have been included but others can be added to the switch statement in:
 ..\support\modules\WHB_FOBspawn\server\fn_getMHQType.sqf

You can also make any object into a ‘Set Spawn Point’ by putting in the following in the Init line: 
this addAction [("<t color=""#dddd00"">" + "Set Spawn" + "</t>"), "support\modules\WHB_Multispawn\common\fn_Action_SignInFOB.sqf"];
this setVariable ["MHQState",1,true];

To ensure the MHQ vehicle respawns at base, add the follwoing to the init line in the map editor:
0 = [this, 10, 9999999, 0, FALSE, FALSE, "[this] execVM 'support\scripts\respawnMHQ.sqf'"]  execVM "support\scripts\vehicle.sqf"