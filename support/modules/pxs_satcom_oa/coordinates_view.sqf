while {true} do
{
	if (!(PXS_SatelliteActive)) exitWith {};

	ctrlSetText [1002,format ["LAT  %1",(round (10 * (getPos PXS_SatelliteTarget select 0)))/10]];
	ctrlSetText [1003,format ["LON  %1",(round (10 * (getPos PXS_SatelliteTarget select 1)))/10]];
	ctrlSetText [1004,format ["ZOOM %1",(round (100 * (PXS_SatelliteZoom)))/100]];

	sleep 0.1;
};