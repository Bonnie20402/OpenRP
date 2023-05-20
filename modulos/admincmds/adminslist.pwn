
YCMD:admins(playerid,params[],help) {
    new j,qtdOnline;
    new String:adminRole[32],String:adminStatus[32];
    new String:dTitle[64],String:dBody[128];
    format(dBody,128,"Admin\tEstado\tFunção\n");
    for(j=0;j<MAX_PLAYERS;j++) {
        if(IsValidStaff(j)) {
            //adminStatus do admin
            if(IsStaffWorking(j))format(adminStatus,32,"Disponivel");
            else format(adminStatus,32,"A jogar");
            // Nivel admin
            format(adminRole,32,"%s",GetStaffLevelString(j));
            qtdOnline++;
            format(dBody,128,"%s %s[%s]\t%s\t%s\n",dBody,GetPlayerNameEx(j),adminRole,adminStatus,gAdmins[j][ADMININFO_ROLE]);
        }
    }
    format(dTitle,64,"{ffffff}Staff Online ({66ff66}%d{ffffff})",qtdOnline);
    ShowPlayerDialog(playerid,ADMINDIALOG_ADMINSLIST,DIALOG_STYLE_TABLIST_HEADERS,dTitle,dBody,"OK","");
    return 1;
}