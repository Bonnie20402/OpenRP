YCMD:tph(playerid,params[],help) {
    if(GetStaffLevel(playerid)) {
        new targetid;
        if(!sscanf(params,"i",targetid)) {
            if(IsPlayerConnected(targetid)) {
                new Float:x1,Float:y1,Float:z1;
                GetPlayerPos(targetid,x1,y1,z1);
                SetPlayerPos(playerid,x1,y1,z1);
                SetPlayerInterior(targetid,GetPlayerInterior(targetid));
                new msg[255];
                format(msg,255,"%s[%d] puxou %s[%d]",GetPlayerNameEx(playerid),playerid,GetPlayerNameEx(targetid),targetid);
                SendStaffMessage(-1,msg);
                return 1;
            }
            SendClientMessage(playerid,COLOR_RED,"Não pertences á staff!");
            return 1;
        }
    }
}