
YCMD:trabalhar(playerid,params[],help)=atrabalhar;
YCMD:atrabalhar(playerid,params[],help) {
    new msg[256];
    if(IsValidStaff(playerid)) {
        if(IsStaffWorking(playerid)) {
            gAdmins[playerid][ADMININFO_WORKING]=0;
            SetPlayerHealth(playerid,100.0);
            format(msg,256,"O administrador %s está fora de serviço.",GetPlayerNameEx(playerid));
        }
        else {
            gAdmins[playerid][ADMININFO_WORKING]=1;
            SetPlayerHealth(playerid,98304);
            format(msg,256,"O administrador %s está em serviço.",GetPlayerNameEx(playerid));
        }
        SendClientMessageToAll(COLOR_AQUA,msg);
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Não pertences á staff!");
    return 1;
}