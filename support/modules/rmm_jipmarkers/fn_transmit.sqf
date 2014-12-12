_string = (ctrlText 2);
_name = "mkr" + str(random time + 1);
_mkr = createMarkerLocal [_name, RMM_jipmarkers_position];
_mkr setmarkertypeLocal (RMM_jipmarkers_types select (lbCurSel 1));
_mkr setmarkertextLocal _string;
_mkr setmarkercolorLocal (RMM_jipmarkers_colors select (lbCurSel 3));
RMM_jipmarkers set [count RMM_jipmarkers, [_name, getMarkerPos _mkr, getMarkerType _mkr, _string, playerSide, getMarkerColor _mkr]];
publicvariable "RMM_jipmarkers";