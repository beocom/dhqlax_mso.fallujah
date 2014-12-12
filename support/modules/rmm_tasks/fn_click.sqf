hint "Click on the map...";
onMapSingleClick "RMM_tasks_position = _pos; RMM_tasks_position set [2,0]; createDialog 'RMM_ui_tasks'; onMapSingleClick CRB_MAPCLICK; true";