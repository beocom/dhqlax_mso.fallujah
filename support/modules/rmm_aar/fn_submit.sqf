player createDiaryRecord ["Diary", [
	format ["%1/%2 %3 - AAR %4", (_this select 10),(_this select 11),(_this select 12), call (RMM_aar_lines select 1) select (_this select 1)],
	format [
		"Callsign: %1<br/>" +
		"Category: %2<br/>" +
		"Type: %3<br/>" +
		"<br/>" +
		(if (_this select 3 != "") then {"Enemy KIA: %4<br/>"} else {""}) +
		(if (_this select 4 != "") then {"Friendly KIA: %5<br/>"} else {""}) +
		(if (_this select 5 != "") then {"Civilian KIA: %6<br/>"} else {""}) +
		"<br/>" +
		(if (_this select 6 != "") then {"Enemy WIA: %7<br/>"} else {""}) +
		(if (_this select 7 != "") then {"Friendly WIA: %8<br/>"} else {""}) +
		(if (_this select 8 != "") then {"Civilian WIA: %9<br/>"} else {""}) +
		"<br/>" +
		"<br/>%10<br/>",
		call (RMM_aar_lines select 0) select (_this select 0),
		call (RMM_aar_lines select 1) select (_this select 1),
		call (RMM_aar_lines select 2) select (_this select 2),
		_this select 3,
		_this select 4,
		_this select 5,
		_this select 6,
		_this select 7,
		_this select 8,
		_this select 9
	]
]];