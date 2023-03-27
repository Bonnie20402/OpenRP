YCMD:abnotificacao(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=5000) {
        ShowPlayerTxdbNotification(playerid);
        SetPlayerTxdbNotifText(playerid,params,10);
    }
    return 1;
}