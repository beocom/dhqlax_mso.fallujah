private ["_unit","_status"];

_status = _this select 0;

if (_status == "ON") then 
{
    PXSsatcomACTIVE = true;
};

if (_status == "OFF") then  
{
    PXSsatcomACTIVE = false;
	call PXS_closeCamera;
};

Publicvariable "PXSsatcomACTIVE";