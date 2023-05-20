
#include <YSI_Coding\y_hooks>
static gDeletingVehicle[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
    gDeletingVehicle[playerid]=0;
    return 1;
}
YCMD:aremoverveh(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=5000) {
        new vehicleid,rowid,index;
        new dBody[1024];
        inline ConfirmDeleteVehicle(responseB,listitemB,String:inputtextB[]) {
            #pragma unused listitemB,StinputtextB
            if(responseB) {
                SendClientMessage(playerid,-1,"Removido com sucesso!");
                PrepareDeleteVehicle(gDeletingVehicle[playerid]);
            }
            gDeletingVehicle[playerid]=0;
        }
        inline DeleteVehicle(response,listitem,String:inputtext[]) {
            #pragma unused listitem
            if(!response)return Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Cancelado","Operação cancelada","OK","");
            sscanf(Stinputtext,"i",vehicleid);
            gDeletingVehicle[playerid]=vehicleid;
            new index = GetLoadedVehicleIndex(vehicleid);
            format(dBody,1024,\
            "rowid\t%d\n\
            vehid\t%d\n\
            modelid\t%d\n\
            XYZ\t %.2f %.2f %.2f\n\
            color1\t%d\n\
            color2\t%d\n\
            FLAG_RESPAWN\t%d\n\
            respawntime\t%d\n\
            FLAG_PUBLIC\t%d\n\
            ownertype\t%d\n\
            owner\t%d",\
            GetLoadedVehicleRowId(vehicleid),vehicleid,gVehicles[index][VEHICLEINFO_MODELID],\
            gVehicles[index][VEHICLEINFO_COORDS][0],gVehicles[index][VEHICLEINFO_COORDS][1],gVehicles[index][VEHICLEINFO_COORDS][2],\
            gVehicles[index][VEHICLEINFO_COLOR1],gVehicles[index][VEHICLEINFO_COLOR2],gVehicles[index][VEHICLEINFO_FLAG_RESPAWN],\
            gVehicles[index][VEHICLEINFO_RESPAWNTIME],gVehicles[index][VEHICLEINFO_FLAG_PUBLIC],gVehicles[index][VEHICLEINFO_OWNERTYPE],\
            gVehicles[index][VEHICLEINFO_OWNERID]);
            Dialog_ShowCallback(playerid,using inline ConfirmDeleteVehicle,DIALOG_STYLE_TABLIST,"Confirmar...",dBody,"Remover","Cancelar");
        }
        format(dBody,1024,"vehicleid\trowid\tmodelid\tXYZ");
        for(new i;i<MAX_VEHICLES;i++) {
            if(IsValidLoadedVehicle(i)) {
                vehicleid=i;
                index = GetLoadedVehicleIndex(vehicleid);
                rowid = GetLoadedVehicleRowId(vehicleid);
                format(dBody,1024,"%s\n%d\t%d\t%d\t(%.2f,%.2f,%.2f)",dBody,vehicleid,rowid,gVehicles[index][VEHICLEINFO_MODELID],\
                gVehicles[index][VEHICLEINFO_COORDS][0],gVehicles[index][VEHICLEINFO_COORDS][1],gVehicles[index][VEHICLEINFO_COORDS][2]);
            }
        }
        Dialog_ShowCallback(playerid,using inline DeleteVehicle,DIALOG_STYLE_TABLIST_HEADERS,"Seleciona o veiculo a REMOVER",dBody,"Selecionar","Cancelar");
    }
    return 1;
}