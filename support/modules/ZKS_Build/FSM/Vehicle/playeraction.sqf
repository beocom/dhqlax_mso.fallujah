// add to player
//player addAction ["Request Pickup", "FSM\Vehicle\playeraction.sqf",[],0,false,false,"", "(isplayer _this)"];



_player = _this select 0;
_id = _this select 2; 


[_player,_id] execFSM "FSM\Vehicle\AI_Driver_Pickup.fsm";





