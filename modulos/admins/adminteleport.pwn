#include <YSI_Coding\y_hooks>

hook OnPlayerClickMap(playerid,Float:fX,Float:fY,Float:fZ) {
    if(GetStaffLevel(playerid)>0) {
        SetPlayerPosFindZ(playerid,fX,fY+5.0,fZ);
        SendClientMessage(playerid,COLOR_AQUA,"Foste puxado para o ponto do mapa marcado!");
    }
    return 1;
}