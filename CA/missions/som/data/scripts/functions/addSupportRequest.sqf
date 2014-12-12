/*
	File: addSupportRequest.sqf
	Author: Joris-Jan van 't Land

	Description:
	Adds one or more support request for the SOM's team.
	In case you pass a Number, its value determines the amount of random Support Requests added.

	Parameter(s):
	_this select 0: name of the support request (String, Array of Strings or Number)
	_this select 1: SOM main scope reference (Object)
	_this select 2: (optional) parameters (Array)
	_this select 3: (optional) never expire toggle (Boolean - default: false)
*/

//Validate parameter count.
if (isNil "_this") exitWith {debugLog "Log: [addSupportRequest] Function requires 2 parameters!"; false};
if ((count _this) < 2) exitWith {debugLog "Log: [addSupportRequest] Function requires 2 parameters!"; false};
if (({isNil "_x"} count _this) != 0) exitWith {debugLog "Log: [addSupportRequest] Function requires all parameters to be defined values!"; false};

private ["_supReqs", "_mainScope", "_supReqName"];
_supReqs = _this select 0;
_mainScope = (_this select 1) call BIS_SOM_returnSOMFunc;

//Fetch optional parameters.
private ["_paramsNew", "_neverExpire"];

//Convert single name to array with 1 element.
if ((typeName _supReqs) == (typeName "")) then 
{
	_supReqs = [_supReqs];
};

//Convert number to selection of random requests.
if ((typeName _supReqs) == (typeName 0)) then 
{
	private ["_supReqsTmp", "_availReq"];
	_supReqsTmp = [];
	
	//TODO: Not all Supports work well in Arrowhead at the moment.
	_availReq = ["aerial_reconnaissance", "tactical_airstrike"];
	//if (BIS_SOM_a2Avail) then {_availReq = _availReq + ["transport", "supply_drop", "artillery_barrage"]};
	if (BIS_SOM_ahAvail) then {_availReq = _availReq + ["gunship_run"]};
	
	// http://forums.bistudio.com/showthread.php?132307-Multi-Session-Operations-v4-2-released&p=2136015&viewfull=1#post2136015
	for "_i" from 0 to (count _availReq - 1) do 
	{
		_supReqsTmp = _supReqsTmp + [_availReq call BIS_fnc_selectRandom];
		if (BIS_SOM_a2Avail) then {};
	};
	_supReqs = +_supReqsTmp;
	_supReqsTmp = nil;
};

if ((count _this) > 2) then
{
	_paramsNew = _this select 2;
};

//No parameters were passed, so generate a big enough list of empty parameters.
if (isNil "_paramsNew") then {_paramsNew = []};

//Make sure there are enough parameter lists.
if ((count _supReqs) > (count _paramsNew)) then  
{
	for "_i" from (count _paramsNew) to ((count _supReqs) - 1) do 
	{
		_paramsNew = _paramsNew + [[]];	
	};	
};

if ((count _paramsNew) < (count _supReqs)) exitWith {debugLog "Log: [addSupportRequest] The number of parameter lists (2) should match the number of support requests (0)!"; false};


if ((count _this) > 3) then 
{
	_neverExpire = _this select 3;
};

if (isNil "_neverExpire") then {_neverExpire = []};

if ((count _supReqs) > (count _neverExpire)) then  
{
	for "_i" from (count _neverExpire) to ((count _supReqs) - 1) do 
	{
		_neverExpire = _neverExpire + [false];
	};	
};


private ["_addedMsg"];
_addedMsg = "";

for "_i" from 0 to ((count _supReqs) - 1) do 
{
	_supReqName = _supReqs select _i;
	
	//Check to see this request exists.
	if (([_supReqName, "supportRequest"] call BIS_SOM_returnCfgSecOpsEntryFunc) == 1) then 
	{	
		//Remove obsolete gain times.
		[_supReqName, _mainScope] call BIS_SOM_isAvailableSupportRequestFunc;
		
		//Fixed count of availability of each support request.
		private ["_maxCount"];
		_maxCount = [_supReqName, "maxCount"] call BIS_SOM_returnCfgSecOpsEntryFunc;
		
		//Fetch this request's gain times and parameters or add new lists.
		private ["_varName", "_gainTimes", "_varNameParams", "_params"];
		_varName = "gainTimes_" + _supReqName;
		_varNameParams = "params_" + _supReqName;
		_gainTimes = _mainScope getVariable _varName;
		if (isNil "_gainTimes") then 
		{
			_gainTimes = [];
			_params = [];
		} 
		else 
		{
			_params = _mainScope getVariable _varNameParams;
		};
		
		//Some requests should never expire.
		private ["_newGainTime"];
		if (_neverExpire select _i) then {_newGainTime = -1} else {_newGainTime = time};
		
		//Add if the maximum count was not exceeded.
		if ((count _gainTimes) < _maxCount) then 
		{
			_gainTimes = _gainTimes + [_newGainTime];
			_params = _params + [_paramsNew select _i];
		} 
		else 
		{
			//Replace the earliest gain time.
			if ((count _gainTimes) > 0) then 
			{
				private ["_arrayExtreme"];
				_arrayExtreme = ([_gainTimes, 0] call BIS_SOM_findArrayExtremeFunc) select 0;
				_gainTimes set [_arrayExtreme, _newGainTime];
				_params set [_arrayExtreme, _paramsNew select _i];
			};
		};
		
		//Update the list of gain times and parameters with the new request.
		_mainScope setVariable [_varName, _gainTimes, true];
		_mainScope setVariable [_varNameParams, _params, true];
		
		private ["_title"];
		_title = [_supReqName, "title"] call BIS_SOM_returnCfgSecOpsEntryFunc;
		_addedMsg = _addedMsg + "\n" + _title;
		
		["supreq", _mainScope] call BIS_SOM_updateCommsMenuFunc;
	} 
	else 
	{
		debugLog (format ["Log: [addSupportRequest] This support request (%1) does not exist!", _supReqName]);
	};
};

//Alert the leader the new requests were added, if they were.
if (isNil "BIS_WF_Client") then
{//disabled hint when in WF (we have right side indications instead)
  if (_addedMsg != "") then 
  {
  	private ["_msg"];
  	_msg = (localize "STR_SOM_SUPPORT_REQUEST_ADDED") + _addedMsg;
  	
  	[[_mainScope getVariable "leader"], [_msg], {hint (_this select 0)}, {player == _x}] call BIS_SOM_sendCodeFunc;
  };
};

true