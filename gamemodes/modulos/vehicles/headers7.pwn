/*
    vehicles.pwn
                    */
forward OnVehicleSpawn(vehicleid);
forward VehicleInit(vehicleid);
/*
    citizenvehicles.pwn
                        */
new gCitizenVehicles[MAX_VEHICLES];

forward PrepareCitizenVehicles();

forward PrepareLoadCitizenVehicles();
forward FinishLoadCitizenVehicles();

forward PrepareRemoveCitizenVehicle(rowid);
forward FinishRemoveCitizenVehicle(rowid);

forward PrepareAddCitizenVehicle(type,color1,color2,Float:x,Float:y,Float:z);
forward FinishAddCitizenVehicle();

forward IsCitizenVehicle(vehicleid);
/*
    vehiclehud.pwn
                    */
new txdVehicleHud[6];
new txdVehicleHudPlayer[5][MAX_PLAYERS];
new gVehicleTimer[MAX_PLAYERS];

forward ShowPlayerSpeedMeter(playerid);
forward UpdateVehicleSpeedMeter(playerid);

/*
    vehiclefuel.pwn
                    */
new gVehicleFuel[MAX_VEHICLES];
forward UpdateVehicleFuel(vehicleid);
forward GetVehicleFuel(vehicleid);
