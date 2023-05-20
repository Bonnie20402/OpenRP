YCMD:iremp(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=3) {
        new rowid;
        sscanf(params,"i",rowid);
        if(IsValidCompany(rowid))SetPlayerPosCompany(playerid,rowid,false,false);
        else SendClientMessage(playerid,COLOR_YELLOW,"ID da empresa inválido!");
    }
    else SendClientMessage(playerid,COLOR_RED,"Não és da Staff!");
    return 1;
}