YCMD:playsound(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=1) {
        new Int:soundid;
        sscanf(params,"i",soundid);
        PlayerPlaySound(playerid,soundid,0.0,0.0,0.0);
        SendClientMessage(playerid,1,"Triiim triiim!");
    }
    else SendClientMessage(playerid,COLOR_RED,"Não pertences á staff!");
    return 1;
}