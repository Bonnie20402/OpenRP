#include <YSI_Coding\y_hooks>
#define REMOVECOMPANYDIALOG 556
YCMD:removercompany(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=5000) {
        new String:text[255];
        format(text,255,"rowid\tnome\n");
        for(new i;i<sizeof(gCompanies);i++) {
            if(IsValidCompany(gCompanies[i][COMPANY_ROWID]))format(text,255,"%s%d\t%s\n",text,gCompanies[i][COMPANY_ROWID],gCompanies[i][COMPANY_NAME]);
        }
        ShowPlayerDialog(playerid,REMOVECOMPANYDIALOG,DIALOG_STYLE_TABLIST_HEADERS,"Remover Company",text,"Remover","Cancelar");
    }
    SendClientMessage(playerid,COLOR_RED,"Não és programador");
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid==REMOVECOMPANYDIALOG) {
        if(response) {
            new rowid;
            SendStaffMessage(-1,"Um programador está a remover uma company");
            sscanf(inputtext,"i",rowid);
            PrepareRemoveCompany(rowid);
            return 1;
        }
        SendClientMessage(playerid,COLOR_AQUA,"Operação cancelada");
    }

    return 1;
}