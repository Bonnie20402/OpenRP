YCMD:printpos(playerid,params[],help) {
    if(GetStaffLevel(playerid)) {
        new Float:x,Float:y,Float:z,Float:angle;
        GetPlayerPos(playerid,x,y,z);
        GetPlayerFacingAngle(angle);
        new String:msg[255];
        format(msg,255,"Position: {%.2f,%.2f,%.2f} Angle: %.2f",x,y,z,angle);
        print(msg);
        SendClientMessage(playerid,-1,msg);
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Não pertencas á Staff!");
    return 1;
}