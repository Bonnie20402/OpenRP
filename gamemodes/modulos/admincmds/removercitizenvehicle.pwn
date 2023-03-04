#include <YSI_Coding\y_hooks>
#define REMOVEVEHICLEDIALOG 5010
YCMD:removercitizenvehicle(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=3000) {
        new String:msg[255];
        format(msg,255,"rowid \t vehicleid\n");
        for(new i=0;i<sizeof(gCitizenVehicles);i++) {
            if(gCitizenVehicles[i])format(msg,255,"%s %d\t%d\n",msg,i,gCitizenVehicles[i]);
        }
        ShowPlayerDialog(playerid,REMOVEVEHICLEDIALOG,DIALOG_STYLE_TABLIST_HEADERS,"Remover CitizenVehicle",msg,"Eliminar","Cancelar");
    }
}

hook OnDialogResponse(playerid,dialogid,response,listitem,inputtext[]) {
    if(dialogid==REMOVEVEHICLEDIALOG) {
        if(response) {
            new rowid,vehicleid;
            sscanf(inputtext,"i",rowid);
            PrepareRemoveCitizenVehicle(rowid);
            SendClientMessage(playerid,COLOR_AQUA,"A remover o CitizenVehicle...");
            return 1;
        }
        SendClientMessage(playerid,-1,"Operação cancelada!");
    }
    return 1;
}