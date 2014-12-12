hint parsetext format ["<t size='1.25'>CONSTRUCTION MODULE</t><br/>Note: %1 to demolish", keyName ((actionKeys "Compass") select 0)];

if (isnil {_this getvariable "cnstrct_radius"}) then {
	if (isnil {_this getvariable "cnstrct_supplies"}) then {
		_this setvariable ["cnstrct_supplies",0,true];
	};
	if (isnil {_this getvariable "cnstrct_radius"}) then {
		_this setvariable ["cnstrct_radius",100];
	};
	if (isnil "cnstrct_buildings") then {
		cnstrct_buildings = [];
		publicvariable "cnstrct_buildings";
	};
	//List of items, fixed for OA
	if (isnil {_this getvariable "cnstrct_categories"}) then {
		_this setvariable ["cnstrct_categories",["Barriers","Sandbags","HESCO","Bunkers","Trenches","Netting","Misc"]];
	};
	if (isnil {_this getvariable "cnstrct_items"}) then {
		_this setvariable ["cnstrct_items",[
			["Fort_RazorWire","Barriers",150],
			["Hedgehog_EP1","Barriers",250],
			["Land_fort_bagfence_long","Sandbags",100],
			["Land_fort_bagfence_round","Sandbags",300],
			["Land_HBarrier1","HESCO",100],
			["Land_HBarrier3","HESCO",300],
			["Land_HBarrier5","HESCO",500],
			["Land_HBarrier_large","HESCO",1000],
			["Land_fortified_nest_small_EP1","Bunkers",800],
			["Land_fortified_nest_big_EP1","Bunkers",1800],
			["Land_Fort_Watchtower_EP1","Bunkers",2000],
			["Fort_EnvelopeSmall_EP1","Trenches",0],
			["Fort_EnvelopeBig_EP1","Trenches",0],
			["Land_CamoNetVar_NATO_EP1","Netting",400],
			["Land_CamoNetB_NATO_EP1","Netting",800],
			["Land_CamoNet_NATO_EP1","Netting",300],
			["CampEast_EP1","Misc",800],
			["MASH_EP1","Misc",1400],
			["HeliH","Misc",200],
			["Land_GuardShed","Misc",600],
			["Land_Antenna","Misc",400],
			["Misc_cargo_cont_net1","Misc",1000],
			["Misc_cargo_cont_net2","Misc",3000],
			["Misc_cargo_cont_net3","Misc",7000]
		]];
	};
	_this setvariable ["cnstrct_usenvg",false];
};

disableserialization;

private ["_position","_viewdistance"];
_position = getpos _this;
_viewdistance = viewdistance;
setviewdistance ((_this getvariable "cnstrct_radius") max 50);

_camera = "camconstruct" camcreate [_position select 0, _position select 1, 5];
_camera cameraeffect ["internal","back"];
_camera campreparefov 0.900;
_camera campreparefocus [-1,-1];
_camera camcommitprepared 0;
cameraeffectenablehud true;
_camera camConstuctionSetParams ([_position] + [_this getvariable "cnstrct_radius",10]);
BIS_CONTROL_CAM = _camera;

showcinemaborder false;
1122 cutrsc ["constructioninterface","plain"];

cnstrct_center = _this;
cnstrct_params = "";
cnstrct_preview = objnull;
cnstrct_center setvariable ["cnstrct_camera",_camera];
cnstrct_center setvariable ["cnstrct_usenvg",false];

private ["_display"];
_display = findDisplay 46;

private ["_keydown","_keyup","_mousedown"];
_keydown = _display displayaddeventhandler ["KeyDown","0 = _this spawn cnstrct_fnc_handler;"];
_keyup = _display displayaddeventhandler ["KeyUp","0 = _this spawn cnstrct_fnc_handler;"];
_mousedown = _display displayaddeventhandler ["MouseButtonDown","0 = _this spawn cnstrct_fnc_handler;"];

[["Categories",true],"cnstrct_menu",_this getvariable "cnstrct_categories","","cnstrct_params = %2"] call BIS_fnc_createmenu;
[] call cnstrct_fnc_refresh;
	
while {not isnil "cnstrct_center"} do {
	[] call cnstrct_fnc_update;
	sleep 0.2;
};

if (not isnil {_this getvariable "cnstrct_selected"}) then {
	deletevehicle ((_this getvariable "cnstrct_selected") select 1);
	_this setvariable ["cnstrct_selected",nil];
};
_camera cameraeffect ["terminate","back"];
camdestroy _camera;
1122 cuttext ["","plain"];
BIS_CONTROL_CAM = nil;
showcommandingmenu "";

setviewdistance _viewdistance;

_display displayremoveeventhandler ["KeyDown",_keydown];
_display displayremoveeventhandler ["KeyUp",_keyup];
_display displayremoveeventhandler ["MouseButtonDown",_mousedown];