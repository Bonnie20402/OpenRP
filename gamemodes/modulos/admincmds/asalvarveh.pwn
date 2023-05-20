YCMD:asalvarveh(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=5000) {
        PrepareSaveLoadedVehicles();
        new message[256];
        format(message,256,"%s %s[%d] guardou todos os veiculos da gm!",GetStaffLevelString(playerid),GetPlayerNameEx(playerid),playerid);
        SendStaffMessage(-1,message);
    }
    return 1;
}