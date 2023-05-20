
#include <YSI_Coding\y_hooks>

new gPrintObj[MAX_PLAYERS];
YCMD:printobj(playerid,params[],help) {
    new objectid;
    if(GetStaffLevel(playerid)>=5000) {
        if(!sscanf(params,"i",objectid)) {
            new Float:x,Float:y,Float:z;
            GetPlayerPos(playerid,x,y,z);
            gPrintObj[playerid]=CreateDynamicObject(objectid,x,y+2.0,z,0.0,0.0,0.0);
            EditDynamicObject(playerid,gPrintObj[playerid]);
            SendClientMessage(playerid,COLOR_AQUA,"A editar objeto...");
        }
        else SendClientMessage(playerid,COLOR_RED,"Uso: /printobj (id)");
    }
    else SendClientMessage(playerid,COLOR_RED,"Não és programador!");
    return 1;
}

hook OnPlayerDisconnect(playerid,reason) {
    gPrintObj[playerid]=0;
    return 1;
}

hook OnPlayerEditDynObject(playerid,  objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    if(response==EDIT_RESPONSE_CANCEL&&gPrintObj[playerid]==objectid) {
        DestroyDynamicObject(objectid);
        gPrintObj[playerid]=0;
        SendClientMessage(playerid,-1,"Cancelado!");
    }
    if(response==EDIT_RESPONSE_FINAL&&gPrintObj[playerid]==objectid) {
        DestroyDynamicObject(objectid);
        gPrintObj[playerid]=0;
        printf("[printobj.pwn] {%d,%f,%f,%f,%f,%f,%f}",objectid,x,y,z,rx,ry,rz);
        printf("[printobj.pwn] INTERIORID: %d VIRTUALWORLD: %d",GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid));
        SendClientMessage(playerid,-1,"Coordenadas na consola!");
    }
    return 1;
}