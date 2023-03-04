#include <YSI_Coding\y_hooks>
YCMD:aveh(playerid,params[],help) {
    if(GetStaffLevel(playerid)) {
        new Float:x,Float:y,Float:z;
        new vehid;
        GetPlayerPos(playerid,x,y,z);
        vehid=CreateVehicle(477,x,y,z,200,147,147,-1,1);
        PutPlayerInVehicle(playerid,vehid,0);
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Não pertences á staff!");
    return 1;
}
//TODO: AdminVehicles
hook OnPlayerExitVehicle(playerid, vehicleid)
{
    if(IsValidStaff(playerid)) {
        new model = GetVehicleModel(vehicleid);
        if(model == 477) {
            DestroyVehicle(vehicleid);
        }
    }
}