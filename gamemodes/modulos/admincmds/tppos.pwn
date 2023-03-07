YCMD:tppos(playerid,params[],help) {
    if(GetStaffLevel(playerid)) {
        new Float:x,Float:y,Float:z;
        if(!sscanf(params,"fff",x,y,z)) {
            SetPlayerPos(playerid,x,y,z);
            return 1;
        }
        SendClientMessage(playerid,COLOR_RED,"Uso correto: /tppos (x) (y) (z)");
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Não pertences á staff!");
    return 1;
}