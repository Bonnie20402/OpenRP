#include <YSI_Coding\y_hooks>
#define REMOVELOCATIONPICKUPDIALOG 5201


YCMD:removerlocationpickup(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=5000) {
        new String:msg[512],String:text[64];
        format(msg,512,"rowid\tpickupid\tlocationID\tlocationName\n");
        for(new i=0;i<sizeof(gLocationPickups);i++) {
            if(IsValidLocationPickup(i)) {
                if(!IsValidLocation(gLocationPickups[i][LOCATIONPICKUP_LOCATIONID]))format(text,64,"INVALIDO");
                else format(text,64,"%s",gLocations[gLocationPickups[i][LOCATIONPICKUP_LOCATIONID]][LOCATION_NAME]);
                format(msg,512,"%s%d\t %d\t %d\t %s\n",msg,gLocationPickups[i][LOCATIONPICKUP_ROWID],i,gLocationPickups[i][LOCATIONPICKUP_LOCATIONID],text);
            }
        }
        ShowPlayerDialog(playerid,REMOVELOCATIONPICKUPDIALOG,DIALOG_STYLE_TABLIST_HEADERS,"Remover locationPickup",msg,"Limpar","Cancelar");
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Precisas ser Programador para executar esse comando!");
    return 1;
}
YCMD:reloadpickups(playerid,params[],help) {
    PrepareLoadLocationPickups();
    return 1;
}

hook OnDialogResponse(playerid,dialogid,response,listitem,inputtext[]) {
    if(GetStaffLevel(playerid)&&dialogid==REMOVELOCATIONPICKUPDIALOG) {
        if(response) {
            new rowid;
            sscanf(inputtext,"i",rowid);
            PrepareRemoveLocationPickup(rowid);
            SendClientMessage(playerid,COLOR_AQUA,"A remover LocationPickup...");
            return 1;
        }
        SendClientMessage(playerid,COLOR_AQUA,"Operação remover LocationPickup cancelada!");
        return 1;
    }
    return 1;
}