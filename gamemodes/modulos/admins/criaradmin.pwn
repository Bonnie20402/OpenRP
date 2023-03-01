
YCMD:criaradmin(playerid,params[],help) {
    if(Getter:GetStaffLevel(playerid)>=3000) {
        new id,level;
        new String:role[256];
        if(!sscanf(params,"iis[64]",id,level,role)) {
            SendClientMessage(playerid,COLOR_AQUA,"Promoção pendente!");
            PrepareCreateAdmin(id,level,role);
            return 1;
        }
        SendClientMessage(playerid,COLOR_RED,"Uso correto: /criaradmin [id] [nivel] [função]");
    }
    else {
        SendClientMessage(playerid,COLOR_RED,"Deves ser um staff nivel Dono ou superior para executares este comando!");
        return 1;
    }
    return 1;
}