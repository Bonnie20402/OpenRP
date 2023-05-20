YCMD:verpos(playerid,params[],help) {
    if(GetStaffLevel(playerid)) {
        new Float:x,Float:y,Float:z,Float:rX,Float:rY,Float:rZ;
        GetPlayerPos(playerid,x,y,z);
        new msg[255];
        format(msg,255,"Coords: {%f,%f,%f}",x,y,z);
        SendClientMessage(playerid,-1,msg);
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Não pertences á staff!");
    return 1;
}