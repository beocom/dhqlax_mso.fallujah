private["_event","_keyCode","_return"];

_event = _this;
_keyCode = _event select 1;
_return = true;

#define FACTOR 50

switch (_keyCode) do
{
	case 1://ESC
	{
		call PXS_closeCamera;
	};
	case 2://1 normal view
	{
		[2] call PXS_adjustCamera;
	};
	case 3://2 night vision
	{
		[3] call PXS_adjustCamera;
	};
	case 4://3 white is hot
	{
		[4] call PXS_adjustCamera;
	};
	case 5://4 black is hot
	{
		[5] call PXS_adjustCamera;
	};
	default
	{
		_return = false;
	};
};
// key combo handling
if (!(_return)) then
{
	private["_pressedButtonArray"];
	_pressedButtonArray = [_keyCode];
	_return = true;

	// check for key actions
	switch (true) do
	{
		
		//case 17://W
		case ((({_x in _pressedButtonArray} count (actionKeys "MoveForward")) > 0) and ((PXS_SatelliteTarget distance player) < 2100)):
		{
			PXS_SatelliteNorthMovementDelta = 2.5;
			PXS_SatelliteTarget setPos [((getPos PXS_SatelliteTarget) select 0) - PXS_SatelliteNorthMovementDelta,((getPos PXS_SatelliteTarget) select 1) + PXS_SatelliteNorthMovementDelta,(getPos PXS_SatelliteTarget) select 2];
			call PXS_updateCamera;
			if ((PXS_SatelliteTarget distance player) > 2000) then 	{
										call PXS_closeCamera;
										hint "Satellite's alignment range is limited to 2000 mtrs";
										};
		};
		//case 31://S
		case ((({_x in _pressedButtonArray} count (actionKeys "MoveBack")) > 0) and ((PXS_SatelliteTarget distance player) < 2100)):
		{
			PXS_SatelliteSouthMovementDelta = 2.5;
			PXS_SatelliteTarget setPos [((getPos PXS_SatelliteTarget) select 0) + PXS_SatelliteSouthMovementDelta,((getPos PXS_SatelliteTarget) select 1) - PXS_SatelliteSouthMovementDelta,(getPos PXS_SatelliteTarget) select 2];
			call PXS_updateCamera;
			if ((PXS_SatelliteTarget distance player) > 2000) then 	{
										call PXS_closeCamera;
										hint "Satellite's alignment range is limited to 2000 mtrs";
										};
		};
		//case 30://A
		case ((({_x in _pressedButtonArray} count (actionKeys "TurnLeft")) > 0) and ((PXS_SatelliteTarget distance player) < 2000)):
		{
			PXS_SatelliteWestMovementDelta = 2.5;
			PXS_SatelliteTarget setPos [((getPos PXS_SatelliteTarget) select 0) - PXS_SatelliteWestMovementDelta,((getPos PXS_SatelliteTarget) select 1) - PXS_SatelliteWestMovementDelta,(getPos PXS_SatelliteTarget) select 2];
			call PXS_updateCamera;
			if ((PXS_SatelliteTarget distance player) > 2000) then 	{
										call PXS_closeCamera;
										hint "Satellite's alignment range is limited to 2000 mtrs";
										};
		};
		//case 32://D
		case ((({_x in _pressedButtonArray} count (actionKeys "TurnRight")) > 0) and ((PXS_SatelliteTarget distance player) < 2000)):
		{
			PXS_SatelliteEastMovementDelta = 2.5;
			PXS_SatelliteTarget setPos [((getPos PXS_SatelliteTarget) select 0) + PXS_SatelliteEastMovementDelta,((getPos PXS_SatelliteTarget) select 1) + PXS_SatelliteEastMovementDelta,(getPos PXS_SatelliteTarget) select 2];
			call PXS_updateCamera;
			if ((PXS_SatelliteTarget distance player) > 2000) then 	{
										call PXS_closeCamera;
										hint "Satellite's alignment range is limited to 2000 mtrs";
										};
		};

		//case 78://Num +
		case ((({_x in _pressedButtonArray} count (actionKeys "ZoomIn")) > 0) || (({_x in _pressedButtonArray} count (actionKeys "MoveDown")) > 0)):
		{
			if ((PXS_SatelliteZoom + (0.02 * FACTOR)) <= 27) then
			{
				PXS_SatelliteFOV = PXS_SatelliteFOV - (0.0005 * FACTOR);
				PXS_SatelliteZoom = PXS_SatelliteZoom + (0.02 * FACTOR);
				call PXS_updateCamera;
			};
		};
		//case 74://Num -
		case ((({_x in _pressedButtonArray} count (actionKeys "ZoomOut")) > 0) || (({_x in _pressedButtonArray} count (actionKeys "MoveUp")) > 0)):
		{
			if ((PXS_SatelliteZoom - (0.02 * FACTOR)) >= 0.1) then
			{
				PXS_SatelliteFOV = PXS_SatelliteFOV + (0.0005 * FACTOR);
				PXS_SatelliteZoom = PXS_SatelliteZoom - (0.02 * FACTOR);
				call PXS_updateCamera;
			};
		};
		//case 999://Exit
		case (((PXS_SatelliteTarget distance player) > 2000)):
		{
			call PXS_closeCamera;
		};
		default
		{
			_return = false;
		};
	};
};
_return;