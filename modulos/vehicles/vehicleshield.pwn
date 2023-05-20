
public OnVehicleDamageStatusUpdate(vehicleid, playerid) {
    new Float:health;
    GetVehicleHealth(vehicleid,health);
    if(gVehicleShield[vehicleid]) {
        gVehicleShield[vehicleid] = -1 - random(15) + gVehicleShield[vehicleid];
        RepairVehicle(vehicleid);
        if(gVehicleShield[vehicleid]<0)gVehicleShield[vehicleid]=0;
    }
    if(health<250) {
        new engine, lights, alarm, doors, bonnet, boot, objective;
        GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleHealth(vehicleid,250.0);
        SetVehicleParamsEx(vehicleid,0,0,0,doors,bonnet,boot,objective);
    }
    return 1;
}
public ShieldVehicle(vehicleid) {
    SetVehicleShield(vehicleid,100);
    return 1;
}
public SetVehicleShield(vehicleid,shield) {
    gVehicleShield[vehicleid]=shield;
    return 1;
}
public GetVehicleShield(vehicleid) {
    return gVehicleShield[vehicleid];
}

