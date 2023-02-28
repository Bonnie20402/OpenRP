
YCMD:av(playerid,params[]) {
    if(Getter:GetStaffLevel(playerid)) {
        if(IsStaffWorking(playerid)) {
            new msg[256];
            format(msg,256,"{FF66FF}%s, %s: %s",GetStaffLevelString(playerid),GetPlayerNameEx(playerid),params);
            SendClientMessageToAll(-1,"{FFFFFF}**** AVISO DA EQUIPA DA STAFF ****");
            SendClientMessageToAll(-1,msg);   
            return 1;
        }
        SendClientMessage(playerid,COLOR_RED,"Estás fora de serviço, não podes usar este comando!");
        return 1;        
    }
    return 1;
}