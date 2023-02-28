/*
    AdminMsg
    Sends a message to all admins on server
    If the playerid is -1, then it's the server sending the message.
                                            */

forward SendStaffMessage(playerid,const message[]);
public SendStaffMessage(playerid,const message[]) {
    new String:msg[256];
    if(playerid== -1)format(msg,256,"{FF3333}[Aviso para a STAFF] %s",message);
    else format(msg,256,"{FF3333}[Staff Chat] (%s) %s[%d]:%s",GetStaffLevelString(playerid),GetPlayerNameEx(playerid),playerid,message);
    for(new i=0;i<MAX_PLAYERS;i++) if(GetStaffLevel(i))SendClientMessage(i,-1,msg);
    return 1;
}