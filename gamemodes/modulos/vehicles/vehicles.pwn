
#include "modulos\vehicles\vehiclehud.pwn"
#include "modulos\vehicles\vehiclefuel.pwn"
#include "modulos\vehicles\vehicleshield.pwn"
#include "modulos\vehicles\vehicleengine.pwn"
#include "modulos\vehicles\citizenvehicles.pwn"
#include <YSI_Coding\y_hooks>

hook OnPlayerStateChange(playerid,newstate,oldstate) {
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
     {
          ShowPlayerSpeedMeter(playerid);
    }
    return 1;
}

public VehicleInit(vehicleid) {
    SetVehicleParamsEx(vehicleid,0,0,0,0,0,0,0);
    SetVehicleHealth(vehicleid,1000);
    SetVehicleFuel(vehicleid,100);
    SetTimerEx("UpdateVehicleFuel",120000,true,"i",vehicleid); // Two minutes per value.
    return 1;
}



                
