#define REMOVEATMDIALOG 2023

#include <YSI_Coding\y_hooks>

YCMD:removeratm(playerid,params[],text) {
    if(GetStaffLevel(playerid)>=5000) {
        new String:msg[255];
        format(msg,255,"rowID\tobjectID\n");
        for(new i=0;i<sizeof(gBankAtm);i++) {
            if(IsValidBankAtm(i)) {
                format(msg,255,"%s %d\t%d\n",msg,gBankAtm[i][ATMINFO_ROWID],gBankAtm[i][ATMINFO_OBJECTID]);
            }
        }
        ShowPlayerDialog(playerid,REMOVEATMDIALOG,DIALOG_STYLE_TABLIST_HEADERS,"Remover ATM",msg,"Eliminar","Cancelar");
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Não és um programador!");
    return 1;
}

hook OnDialogResponse(playerid,dialogid,response,listitem,inputtext[]) {
    if(GetStaffLevel(playerid)>=5000&&dialogid==REMOVEATMDIALOG) {
        if(!response) {
            SendClientMessage(playerid,COLOR_AQUA,"Remover atm CANCELADO");
            return 1;
        }
        SendStaffMessage(-1,"Um Programador está a remover um ATM!");
        new rowid;
        sscanf(inputtext,"i",rowid);
        PrepareRemoveBankAtm(rowid);
        return 1;
    }
}