YCMD:irloc(playerid,params[],help) {
    if(GetStaffLevel(playerid)) {
        if(GetLocationIDFromName(params)) {
            new locid,Float:x,Float:y,Float:z;
            locid=GetLocationIDFromName(params);
            GetLocationCoordsPointers(locid,x,y,z);
            SetPlayerPos(playerid,x,y,z);
            new String:msg[255];
            format(msg,255,"%s foi até a localização %s[%d]",GetPlayerNameEx(playerid),params,locid);
            SendStaffMessage(-1,msg);
            return 1;
        }
    }
    SendClientMessage(playerid,COLOR_RED,"Não pertences á staff!");
    return 1;
}