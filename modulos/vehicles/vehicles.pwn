
#include "modulos\vehicles\vehiclehud.pwn"
#include "modulos\vehicles\vehiclefuel.pwn"
#include "modulos\vehicles\vehicleshield.pwn"
#include "modulos\vehicles\vehicleengine.pwn"
#include "modulos\vehicles\vehiclesql.pwn"
#include <YSI_Coding\y_hooks>

new Task:tskVehicleLoad;

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

stock Vehicle:GetLoadedVehicleRowId(vehicleid) {
    for(new i;i<MAX_VEHICLES;i++) {
        if(gVehicles[i][VEHICLEINFO_VEHICLEID]==vehicleid) return gVehicles[i][VEHICLEINFO_ROWID];
    }
    return 0;
}
stock Vehicle:GetLoadedVehicleIndex(vehicleid) {
    for(new i;i<MAX_VEHICLES;i++) {
        if(gVehicles[i][VEHICLEINFO_VEHICLEID]==vehicleid) return i;
    }
    return 0;
}
stock Vehicle:IsValidLoadedVehicle(vehicleid) {
    for(new i;i<MAX_VEHICLES;i++) {
        if(gVehicles[i][VEHICLEINFO_VEHICLEID]==vehicleid && GetVehicleModel(vehicleid)) return 1;
    }
    return 0;
}
stock Vehicle:SpawnLoadedVehicles() {
    DestroyLoadedVehicles();
    if(!task_valid(tskVehicleLoad))tskVehicleLoad=task_new();
    for(new i;i<LoadedVehicleCount;i++) {
        // if it should resapwn make it so
        if(gVehicles[i][VEHICLEINFO_FLAG_RESPAWN]) {
            gVehicles[i][VEHICLEINFO_VEHICLEID]=AddStaticVehicleEx(gVehicles[i][VEHICLEINFO_MODELID],gVehicles[i][VEHICLEINFO_COORDS][0],gVehicles[i][VEHICLEINFO_COORDS][1],gVehicles[i][VEHICLEINFO_COORDS][2],gVehicles[i][VEHICLEINFO_ANGLE],gVehicles[i][VEHICLEINFO_COLOR1],gVehicles[i][VEHICLEINFO_COLOR2],gVehicles[i][VEHICLEINFO_RESPAWNTIME]);
        }
        else {
            gVehicles[i][VEHICLEINFO_VEHICLEID]=AddStaticVehicle(gVehicles[i][VEHICLEINFO_MODELID],gVehicles[i][VEHICLEINFO_COORDS][0],gVehicles[i][VEHICLEINFO_COORDS][1],gVehicles[i][VEHICLEINFO_COORDS][2],gVehicles[i][VEHICLEINFO_ANGLE],gVehicles[i][VEHICLEINFO_COLOR1],gVehicles[i][VEHICLEINFO_COLOR2]);
        }
        VehicleInit(gVehicles[i][VEHICLEINFO_VEHICLEID]);
        SetupLoadedVehicle3DText(gVehicles[i][VEHICLEINFO_VEHICLEID]);
        new engine,lights,alarm,doors,bonnet,boot,objective;
        GetVehicleParamsEx(gVehicles[i][VEHICLEINFO_LOCKED],engine,lights,alarm,doors,bonnet,boot,objective);
        
        // Lock vehicle if supposed to.
        SetVehicleParamsEx(gVehicles[i][VEHICLEINFO_LOCKED],engine,lights,alarm,gVehicles[i][VEHICLEINFO_LOCKED],bonnet,boot,objective);
        SetVehicleFuel(gVehicles[i][VEHICLEINFO_VEHICLEID],gVehicles[i][VEHICLEINFO_FUEL]);
        SetVehicleShield(gVehicles[i][VEHICLEINFO_VEHICLEID],gVehicles[i][VEHICLEINFO_SHIELD]);
        SetVehicleHealth(gVehicles[i][VEHICLEINFO_VEHICLEID],float(gVehicles[i][VEHICLEINFO_HP]));
    }
    task_set_result(tskVehicleLoad,1);
    return 1;
}
/*
    Destroies the current spawned vehicles and clears the values from ram.
                                            */
stock Vehicle:DestroyLoadedVehicles() {
	for(new i;i<MAX_VEHICLES;i++) {
		if(gVehicles[i][VEHICLEINFO_VEHICLEID]) {
            if(IsValid3DTextLabel(gVehicles[i][VEHICLEINFO_TEXT3D])) {
                DestroyDynamic3DTextLabel(gVehicles[i][VEHICLEINFO_TEXT3D]);
                gVehicles[i][VEHICLEINFO_TEXT3D]= INVALID_3DTEXT_ID;
            }
			DestroyVehicle(gVehicles[i][VEHICLEINFO_VEHICLEID]);
			gVehicles[i][VEHICLEINFO_VEHICLEID]=0;
		}
	}
    return 1;
}
/*
    Destrtoies the passed vehicleid and clears it's value from RAM.
*/

stock Vehicle:DestroyLoadedVehicle(vehicleid) {
    if(IsValidLoadedVehicle(vehicleid)) {
        new index = GetLoadedVehicleIndex(vehicleid);
        DestroyVehicle(gVehicles[index][VEHICLEINFO_VEHICLEID]);
		gVehicles[index][VEHICLEINFO_VEHICLEID]=0;
    }
    return 1;
}
/*
    Checks if VEHICLEINFO_FLAG_PUBLIC of passed vehicleid is true or not
                                                                            */
stock Vehicle:IsPublicVehicle(vehicleid) {
    new index = GetLoadedVehicleIndex(vehicleid);
    return gVehicles[index][VEHICLEINFO_FLAG_PUBLIC];
}

stock Vehicle:SetupLoadedVehicle3DText(vehicleid) {
    new index = GetLoadedVehicleIndex(vehicleid);
    new text[255];
    switch(IsPublicVehicle(vehicleid)) {
        case 1:
            format(text,255,"{FFFFFF}-= Veiculo Civil ({FF00FF}%d{FFFFFF}) =-",vehicleid);
    }
    gVehicles[index][VEHICLEINFO_TEXT3D] = CreateDynamic3DTextLabel(text,-1,0.0,0.0,0.0,15.0,INVALID_PLAYER_ID,vehicleid);
    //TODO attach text based on ownertype
    return 1;
}


                
