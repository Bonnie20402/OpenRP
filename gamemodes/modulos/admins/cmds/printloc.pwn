// Imprime a localização no printf

YCMD:printloc(playerid,params[],help) {
    if(GetStaffLevel(playerid)) {
        new float:x,float:y,float:z;
        GetPlayerPos(playerid,x,y,z);
        new msg[255];
        format(msg,255,"\nCOORDS (%s): {%.2f,%.2f,%.2f};",params,x,y,z);
        print(msg);
        SendClientMessage(playerid,-1,msg);
        PrepareAddLocation(params,x,y,z);
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Não pertences á staff!");
    return 1;
}