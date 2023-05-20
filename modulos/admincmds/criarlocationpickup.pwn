
YCMD:criarlocationpickup(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=5000) {
        new String:text[64];
        new locationid,model,interiorid;
        new Float:x,Float:y,Float:z;
        GetPlayerPos(playerid,x,y,z);
        if(!sscanf(params,"iis[64]",model,locationid,text)) {
            SendClientMessage(playerid,-1,"A criar lpickup...");
            if(!IsValidLocation(locationid)) {
                SendClientMessage(playerid,-1,"AVISO: locationid inválido - a usar interior do jogador!");
                interiorid=GetPlayerInterior(playerid);
            }
            else interiorid=GetLocationInterior(locationid);
            PrepareAddLocationPickup(model,interiorid,locationid,text,x,y,z);
            return 1;
        }
        SendClientMessage(playerid,COLOR_RED,"Uso: /criarlocationpickup (modelid) (locationid) (texto)");
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Precisas ser Programador para executar esse comando!");
    return 1;
}
