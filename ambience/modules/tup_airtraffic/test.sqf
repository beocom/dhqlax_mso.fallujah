private ["_new","_obj"];
for "_i" from 123400 to 123499 do {
        _obj = (position player) nearestObject _i;
        switch {str _obj} do {
                case (str _i + ": heli_h.p3d"): {     
                        _new = createVehicle ["HeliH", position _obj, [],0,'NONE'];     
                        _new setDir (direction _obj);
                };    
                case (str _i + ": heli_h_army.p3d"): {     
                        _new = createVehicle ["HeliH", position _obj, [],0,'NONE'];     
                        _new setDir (direction _obj);    
                };    
                case (str _i + ": heli_h_rescue.p3d"): {     
                        _new = createVehicle ["HeliHRescue", position _obj, [],0,'NONE'];     
                        _new setDir (direction _obj);    
                };    
                case (str _i + ": heli_h_civil.p3d"): {     
                        _new = createVehicle ["HeliHCivil", position _obj, [],0,'NONE'];     
                        _new setDir (direction _obj);    
                }; 
        }; 
};