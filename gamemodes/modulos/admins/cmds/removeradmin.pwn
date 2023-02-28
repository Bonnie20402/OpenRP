
YCMD:removeradmin(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=3000) {
        new String:staffname[MAX_PLAYER_NAME];
        if(!sscanf(params,"s[64]",staffname)) {
            printf("STAFF REMOVE %s",staffname);
            SendClientMessage(playerid,COLOR_AQUA,"A mandar o staff para a reforma...");
            Admin:PrepareDeleteAdmin(playerid,staffname);
            return 1;
        }
        SendClientMessage(playerid,COLOR_RED,"Uso correto: /removeradmin [nick]");
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Deves ser um membro da Staff nivel Dono ou superior para usares este comando!");
    return 1;
}