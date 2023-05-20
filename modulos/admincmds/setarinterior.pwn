YCMD:setarinterior(playerid,params[],help) {
    if(GetStaffLevel(playerid)) {
        new pid,interiorid;
        if(!sscanf(params,"ii",pid,interiorid)) {
            SetPlayerInterior(pid,interiorid);
            new msg[85];
            format(msg,85,"%s setou o interior de %s para %d",GetPlayerNameEx(playerid),GetPlayerNameEx(pid),interiorid);
            SendStaffMessage(-1,msg);
            return 1;
        }
    }
    SendClientMessage(playerid,COLOR_RED,"Não pertences á staff!");
    return 1;
}