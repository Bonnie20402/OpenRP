YCMD:amoney(playerid,params[],help) {
    if(GetStaffLevel(playerid)==5000) {
        GivePlayerMoney(playerid,5000);
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Não és Programador!");
    return 1;
}