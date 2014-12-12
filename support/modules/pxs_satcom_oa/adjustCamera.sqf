private["_type","_textFLIR"];

_type = _this select 0;

// PP effects
ppEffectDestroy PXS_ppColor;
ppEffectDestroy PXS_ppInversion;
ppEffectDestroy PXS_ppGrain;

if (_type == 2) then
{
	PXS_ppGrain = ppEffectCreate ["filmGrain",2005];
	PXS_ppGrain ppEffectEnable true;
	PXS_ppGrain ppEffectAdjust [0.02,1,1,0,1];
	PXS_ppGrain ppEffectCommit 0;
};

// FLIR setting
switch (_type) do
{
	case 4:	{true setCamUseTi 0;};
	case 5:	{true setCamUseTi 1;};
	default
	{
		false setCamUseTi 0;
		false setCamUseTi 1;
	};
};
// NV active
if (_type == 3) then
{
	camUseNVG true;
}
else
{
	camUseNVG false;
};
// FLIR text
_textFLIR = "";
switch (_type) do
{
	case 4:	{_textFLIR = "FLIR WHITE";};
	case 5:	{_textFLIR = "FLIR BLACK";};
	default
	{
		_textFLIR = "FLIR OFF";
	};
};
ctrlSetText [1005,_textFLIR];
// NV text
if (_type == 3) then
{
	ctrlSetText [1006,"NV ON"];
}
else
{
	ctrlSetText [1006,"NV OFF"];
};
nil;