if (isnil "PXS_SatelliteActive") then {PXS_SatelliteActive = false};

while {true} do
{
	if (!(PXS_SatelliteActive)) exitWith {};

	ctrlSetText [1001,format ["%1",call PXS_timeFunction]];

	sleep 0.1;
};