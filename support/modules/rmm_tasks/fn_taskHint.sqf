if (typename _this != "task") exitwith {};

private ["_taskdescription", "_taskdestination", "_taskstatus", "_taskparams"];

_taskdescription = (taskdescription _this) select 1;
_taskdestination = mapgridposition (taskdestination _this);
_taskstatus	= tolower(taskstate _this);

_taskparams = switch (tolower(_taskstatus)) do {
        case "created": {
                [format["NEW TASK ASSIGNED: \n%1 (GR: %2)", _taskdescription, _taskdestination], [1,1,1,1], "tasknew"]
        };
        case "assigned": {
                [format["ASSIGNED TASK: \n%1 (GR: %2)", _taskdescription, _taskdestination], [0.4,0.4,0.8,1], "taskcurrent"]
        };
        case "succeeded": {
                [format["TASK ACCOMPLISHED: \n%1 (GR: %2)", _taskdescription, _taskdestination], [0.4,0.8,0.4,1], "taskdone"]
        };
        case "failed": {
                [format["TASK FAILED: \n%1 (GR: %2)", _taskdescription, _taskdestination], [1,0,0,1], "taskfailed"]
        };
        case "canceled": {
                [format["TASK CANCELED: \n%1 (GR: %2)", _taskdescription, _taskdestination], [0.6,0.6,0.6,1], "taskdone"]
        };
};
taskhint _taskparams;