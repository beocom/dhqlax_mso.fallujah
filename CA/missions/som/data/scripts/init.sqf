/*
	File: init.sqf
	Author: Joris-Jan van 't Land

	Description:
	The first init script of the SecOp system.
	This script readies both the server and clients.

	Parameter(s):
	_this: the SecOp Manager unit which triggered this script.
*/

if (isServer) then {_this setVariable ["initDone", false, true]};

//startLoadingScreen ["SOM init","RscDisplayLoadMission"];
//sleep 0.01;

//Global variables.
BIS_SOM_CfgVehicles = configFile >> "CfgVehicles";
BIS_SOM_stdPath = "ca\missions\som\data\";

//"// - Comment to ensure the escape sequence above doesn not destroy syntax highlighting.

//Preprocess functions.
//Dealing with dynamic content.
BIS_SOM_cleanDynFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\cleanDyn.sqf"));
BIS_SOM_addDynFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\addDyn.sqf"));
BIS_SOM_transferDynFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\transferDyn.sqf"));
BIS_SOM_removeDynFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\removeDyn.sqf"));

//TODO: BIS_SOM_gaugeForceFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\gaugeForce.sqf"));
BIS_SOM_requestSecOpFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\requestSecOp.sqf"));
BIS_SOM_processSecOpPhaseFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\processSecOpPhase.sqf"));
BIS_SOM_returnSecOpScopeFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\returnSecOpScope.sqf"));
BIS_SOM_nextSecOpPhaseFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\nextSecOpPhase.sqf"));
BIS_SOM_isActiveSecOpFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\isActiveSecOp.sqf"));
BIS_SOM_returnEnemySideFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\returnEnemySide.sqf"));
BIS_SOM_registerTopicFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\registerTopic.sqf"));
BIS_SOM_unregisterTopicFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\unregisterTopic.sqf"));
BIS_SOM_isActiveTopicFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\isActiveTopic.sqf"));
BIS_SOM_manageSecOpPoolFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\manageSecOpPool.sqf"));
BIS_SOM_isAvailableSupportRequestFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\isAvailableSupportRequest.sqf"));
BIS_SOM_updateCommsMenuFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\updateCommsMenu.sqf"));
BIS_SOM_findArrayExtremeFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\findArrayExtreme.sqf"));
BIS_SOM_returnCfgSecOpsEntryFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\returnCfgSecOpsEntry.sqf"));
BIS_SOM_returnSOMFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\returnSOM.sqf"));
BIS_SOM_codeBurstFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\codeBurst.sqf"));
BIS_SOM_sendEventFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\sendEvent.sqf"));
BIS_SOM_terminateSecOpFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\terminateSecOp.sqf"));
BIS_SOM_returnGenericSentenceFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\returnGenericSentence.sqf"));

//Not part of the SOM itself.
BIS_SOM_objectMapperFunc = compile (preprocessFileLineNumbers "ca\modules\dyno\data\scripts\objectMapper.sqf");

//All client should have the Functions Manager initialized, to be sure.
if (isnil "BIS_functions_mainscope") then 
{
	(group _this) createUnit ["FunctionsManager", position _this, [], 0, "NONE"];
};

waitUntil {!(isnil "BIS_fnc_init")};

call BIS_fnc_commsMenuCreate; //Create the comms menu on all machines.

if (isServer) then 
{
	BIS_SOM_addSupportRequestFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\addSupportRequest.sqf"));
	BIS_SOM_addLeaderInstallFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\addLeaderInstall.sqf"));
	BIS_SOM_removeLeaderInstallFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\removeLeaderInstall.sqf"));
	BIS_SOM_sendCodeFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\sendCode.sqf"));
	BIS_SOM_processEventFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\processEvent.sqf"));
	BIS_SOM_addPhaseCodeFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\addPhaseCode.sqf"));
	BIS_SOM_removePhaseCodeFunc = compile (preprocessFileLineNumbers (BIS_SOM_stdPath + "scripts\functions\removePhaseCode.sqf"));
	
	//Check and store what content is available.
	BIS_SOM_a2Avail = false;
	if (configName(BIS_SOM_CfgVehicles >> "RU_Commander") != "") then {BIS_SOM_a2Avail = true};
	publicVariable "BIS_SOM_a2Avail";
        BIS_SOM_ahAvail = false;
	if (configName(BIS_SOM_CfgVehicles >> "TK_Soldier_Officer_EP1") != "") then {BIS_SOM_ahAvail = true};
	publicVariable "BIS_SOM_ahAvail"; //Clients need this toggle to select sentences
	
	//Piece of Code used to do a standard query / response between Team and H.Q.
	BIS_SOM_queryResponseRadioFunc = 
	{
		private ["_mainScope", "_lastContact", "_leader", "_hq", "_code"];
		_mainScope = _this select 0;
		_lastContact = _mainScope getVariable "lastContactHQ";
		
		//Only do a query + response if it's been longer than 30 seconds since last time we spoke to H.Q.
		if ((time - _lastContact) > 30) then 
		{		
			_leader = _mainScope getVariable "leader";
			_hq = _mainScope getVariable "hq";
			
			if ((_this select 1) == "H") then 
			{
				_hq kbTell [_leader, "mainHQ", ["query", "H"] call BIS_SOM_returnGenericSentenceFunc, ["HQ", "", _mainScope getVariable "callsignHQ", _mainScope getVariable "callsignHQSpeech"], ["Team", "", _mainScope getVariable "callsign", _mainScope getVariable "callsignSpeech"], ["PlayerReply", false, "", []], true];
	
				sleep 2;
				
				_code = 
				{
					private ["_mainScope"];
					_mainScope = _this select 0;
					_x kbTell [_mainScope getVariable "HQ", "mainHQ", ["response", "T"] call BIS_SOM_returnGenericSentenceFunc, ["HQ", "", _mainScope getVariable "callsignHQ", _mainScope getVariable "callsignHQSpeech"], ["Team", "", _mainScope getVariable "callsign", _mainScope getVariable "callsignSpeech"], true]
				};
				[[_leader], [_mainScope], _code] call BIS_SOM_sendCodeFunc;
			} 
			else 
			{
				_code = 
				{
					private ["_mainScope"];
					_mainScope = _this select 0;
					_x kbTell [_mainScope getVariable "HQ", "mainHQ", ["query", "T"] call BIS_SOM_returnGenericSentenceFunc, ["HQ", "", _mainScope getVariable "callsignHQ", _mainScope getVariable "callsignHQSpeech"], ["Team", "", _mainScope getVariable "callsign", _mainScope getVariable "callsignSpeech"], ["PlayerReply", false, "", []], true]
				};
				[[_leader], [_mainScope], _code] call BIS_SOM_sendCodeFunc;
				
				sleep 2;
				
				_hq kbTell [_leader, "mainHQ", ["response", "H"] call BIS_SOM_returnGenericSentenceFunc, ["HQ", "", _mainScope getVariable "callsignHQ", _mainScope getVariable "callsignHQSpeech"], ["Team", "", _mainScope getVariable "callsign", _mainScope getVariable "callsignSpeech"], ["PlayerReply", false, "", []], true];
			};
			
			//Update time when we last spoke to H.Q. -> now.
			_mainScope setVariable ["lastContactHQ", time];
			
			sleep 2;
		};
	};
	
	//Code which reacts to events from clients.
	"BIS_SOM_clientEvent" addPublicVariableEventHandler {call BIS_SOM_processEventFunc};
	
	//Initialize SOM (server).
	private ["_ok"]; 
	_ok = _this execVM "ca\missions\som\data\scripts\main.sqf";
} 
else 
{
	//TODO: verify bursts are complete?
	
	//Code which reacts to code burst from the SOM server.
	"BIS_SOM_codeBurst" addPublicVariableEventHandler {call BIS_SOM_codeBurstFunc};
};

//Allow for some sync time.
waitUntil {_this getVariable "initDone"};

//Run the leader FSM on all machines.
//TODO: Or only on machines belonging to squad members?
private ["_fsm1"];
_fsm1 = _this execFSM (BIS_SOM_stdPath + "fsms\leader.fsm");


//endLoadingScreen;

sleep 0.5;

if (_this getVariable "hqEnabled") then 
{
	private ["_hq"];
	_hq = _this getVariable "HQ";
	
	//Make everyone see the correct H.Q. identity, if enabled.
	_hq setGroupId [_this getVariable "callsignHQ", "SIX"];
	
	//Set up a good side for the H.Q.
	if ((_this getVariable "side") == west) then 
	{
		_hq setIdentity "SOMHQ_EN";
	} 
	else 
	{
		_hq setIdentity "SOMHQ_RU";
	};		
};

true