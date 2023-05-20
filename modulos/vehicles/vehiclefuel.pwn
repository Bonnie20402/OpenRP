

public UpdateVehicleFuel(vehicleid) {
    new engine,lights,doors,alarm,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(engine&&gVehicleFuel[vehicleid]>0)gVehicleFuel[vehicleid]--;
    if(!gVehicleFuel[vehicleid])SetVehicleParamsEx(vehicleid,0,0,0,doors,bonnet,boot,objective);
    return 1;
}
public FuelVehicle(vehicleid) {
    SetVehicleFuel(vehicleid,100);
}
public SetVehicleFuel(vehicleid,fuel) {
    gVehicleFuel[vehicleid]=fuel;
}
public GetVehicleFuel(vehicleid) {
    return gVehicleFuel[vehicleid];
}

