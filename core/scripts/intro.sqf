if(isDedicated) exitWith{};
sleep 1;
hint parsetext "<t size=2 align=left>MSO (FAQ)</t><t align=left><br/>
The Multi-Session Operation (MSO) is the ultimate in reality-based gameplay; it is a persistent mission simulating real-life warfare to the best of our capabilities.<br/><br/>
You have limited number of lives; after which you will be kicked from the server.<br/>Player status is persistent; upon reconnection, you will respawn with all your gear at the same position you were last time you played.<br/><br/>
<t size=2 align=left>What Now?</t><br/>Check your tasks and the notes section for after action reports, upcoming missions and recon information.<br/><br/>
<t size=2 align=left>Who with?</t><br/>Join our teamspeak 3 channel (ts.ausarma.org) to meet up with others on the map, or use the ingame VOIP. If you have skype, send your account name to an AAF/AEF member and you will be added to the MSO conversation.</t>";
sleep 10;
["Multi-Session","Operation"] call BIS_fnc_infoText;
["by the MSO", "Development Team"] call BIS_fnc_infoText;

