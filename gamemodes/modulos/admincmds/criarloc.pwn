// Imprime a localização no printf

YCMD:criarloc(playerid,params[],help) {
    printf("%d",GetStaffLevel(playerid));
    if(GetStaffLevel(playerid)>=3000) {
        new float:x,float:y,float:z;
        new interiorid;
        GetPlayerPos(playerid,x,y,z);
        new msg[255];
        interiorid=GetPlayerInterior(playerid);
        format(msg,255,"\nCOORDS (%s): {%.2f,%.2f,%.2f};",params,x,y,z);
        print(msg);
        SendClientMessage(playerid,-1,msg);
        PrepareAddLocation(params,interiorid,x,y,z);
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Precisas de ser Dono ou superior para executares este comando!");
    return 1;
}