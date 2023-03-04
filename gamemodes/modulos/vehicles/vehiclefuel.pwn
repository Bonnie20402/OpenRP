
#include <YSI_Coding\y_hooks>

hook OnScriptInit() {
    for(new i;i<sizeof(gVehicleFuel);i++)gVehicleFuel[i]=100;
    return 1;
}
public UpdateVehicleFuel(vehicleid) {
    new engine,lights,doors,alarm,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(engine&&gVehicleFuel[vehicleid]>0)gVehicleFuel[vehicleid]--;
    if(!gVehicleFuel[vehicleid])SetVehicleParamsEx(vehicleid,0,0,0,doors,bonnet,boot,objective);
    return 1;
}

public GetVehicleFuel(vehicleid) {
    return gVehicleFuel[vehicleid];
}

