
new gCitizenVehicles[MAX_VEHICLES];


forward PrepareCitizenVehicles();

forward PrepareLoadCitizenVehicles();
forward FinishLoadCitizenVehicles();

forward PrepareRemoveCitizenVehicle(rowid);
forward FinishRemoveCitizenVehicle(rowid);

forward PrepareAddCitizenVehicle(type,color1,color2,Float:x,Float:y,Float:z);
forward FinishAddCitizenVehicle();

forward IsCitizenVehicle(vehicleid);