
// Remover uma localização
#define REMOVERLOCDIALOG 5004


YCMD:removerloc(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=3000) {
        new locId;
        new dBody[256];
        format(dBody,256,"ID\tNome\tCoords\n");
        if(!sscanf(params,"i",locId))PrepareRemoveLocation(playerid,locId);
        else {
            for(new i=0;i<sizeof(gLocations);i++) {
                if(strlen(gLocations[i][LOCATION_NAME]))format(dBody,256,"%s%d\t%s\t(%.2f,%.2f,%.2f)\n",dBody,i,gLocations[i][LOCATION_NAME],gLocations[i][LOCATION_COORDS][0],gLocations[i][LOCATION_COORDS][1],gLocations[i][LOCATION_COORDS][2]);
            }
            ShowPlayerDialog(playerid,REMOVERLOCDIALOG,DIALOG_STYLE_TABLIST_HEADERS,"Localizações",dBody,"Limpar","Cancelar");
        }
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Precisas de ser Dono ou superior para executares este comando!");
    return 1;
}
#include <YSI_Coding\y_hooks>
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(GetStaffLevel(playerid)&&dialogid==REMOVERLOCDIALOG) {
        if(!response) {
            ShowPlayerScreenMessage(playerid,700,"Operacao cancelada!");
            return 0;
        }
        new locId;
        sscanf(inputtext,"i",locId);
        PrepareRemoveLocation(playerid,locId);
    }
    return 1;
}