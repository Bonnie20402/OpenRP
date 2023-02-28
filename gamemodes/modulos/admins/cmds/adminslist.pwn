#include <YSI_Coding/y_hooks>
YCMD:admins(playerid,params[],help) {
    new j,qtdOnline;
    new String:role[32],String:estado[32];
    new String:titulo[64],String:corpo[128];
    format(corpo,128,"Admin\tEstado\tFunção\n");
    for(j=0;j<MAX_PLAYERS;j++) {
        if(Getter:GetStaffLevel(j)) {
            //Estado do admin
            if(Getter:IsStaffWorking(playerid))format(estado,32,"Em serviço");
            else format(estado,32,"A jogar");
            // Nivel admin
            format(role,32,"%s",GetStaffLevelString(playerid));
            qtdOnline++;
            format(corpo,128,"%s %s[%s]\t%s\t%s\n",corpo,GetPlayerNameEx(j),role,estado,gAdmins[j][ADMININFO_ROLE]);
        }
    }
    format(titulo,64,"{ffffff}Staff Online ({66ff66}%d{ffffff})",qtdOnline);
    ShowPlayerDialog(playerid,ADMINDIALOG_ADMINSLIST,DIALOG_STYLE_TABLIST_HEADERS,titulo,corpo,"OK","");
    return 1;
}