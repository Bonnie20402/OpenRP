YCMD:kick(playerid,params[],help) = akick;
YCMD:expulsar(playerid,params[],help) = akick;
YCMD:aexpulsar(playerid,params[],help) = akick;
YCMD:akick(playerid,params[],help) {
    if(GetStaffLevel(playerid)&&IsPlayerLoggedIn(playerid)) {
        if(!strlen(params)) {
            SendClientMessage(playerid,COLOR_AQUA,"Uso: /kick (id) (motivo)");
            return 1;
        }
        new outputMessage[255];
        new targetid=INVALID_PLAYER_ID,reason[255];
        sscanf(params,"is[255]",targetid,reason);
        if(GetStaffLevel(targetid)>GetStaffLevel(playerid)) {
            format(outputMessage,255,"O admin %s tentou kickar o admin superior %s",GetPlayerNameEx(playerid),GetPlayerNameEx(targetid));
            SendStaffMessage(-1,outputMessage);
            return 1;
        }
        else if(targetid!=INVALID_PLAYER_ID) {
            SendClientMessage(playerid,COLOR_AQUA,"Kickado!");
            StaffPunishKick(playerid,targetid,reason);
            return 1;
        }
        else {
            SendClientMessage(playerid,COLOR_AQUA,"ID inválido!");
            return 1;
        }
    }
    else {
        SendClientMessage(playerid,COLOR_RED,"Não pertences á Staff!");
        return 1;
    }
    return 1;
}