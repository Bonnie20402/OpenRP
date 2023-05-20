
#include <YSI_Coding\y_hooks>
new gPrintingObject[MAX_PLAYERS];
YCMD:editobj(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=5000) {
        new objectid;
        if(!sscanf(params,"i",objectid)) {
            new Float:x,Float:y,Float:z;
            GetPlayerPos(playerid,x,y,z);
            gPrintingObject[playerid]=CreateDynamicObject(objectid,x,y,z,0,0,0,-1,-1,playerid);
            EditDynamicObject(playerid,gPrintingObject[playerid]);
            return 1;
        }
        SendClientMessage(playerid,COLOR_RED,"Formato correto: /editobj (id)");
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Não és Programador!");
    return 1;
}

hook OnPlayerEditDynObject(playerid,objectid,response,Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz) {
    if(gPrintingObject[playerid]&&objectid==gPrintingObject[playerid]&&response==EDIT_RESPONSE_FINAL) {
        gPrintingObject[playerid]=0;
        new Float:pX,Float:pY,Float:pZ;
        GetPlayerPos(playerid,pX,pY,pZ);
        x-=pX;
        y-=pY;
        z-=pZ;
        printf("[PrintObj] %d,%f,%f,%f,%f,%f,%f",x,y,z,rx,ry,rz);
        SendClientMessage(playerid,COLOR_RED,"Coordenadas na consola!");
    }
    if(gPrintingObject[playerid]&&objectid==gPrintingObject[playerid]&&response==EDIT_RESPONSE_CANCEL) {
        gPrintingObject[playerid]=0;
        SendClientMessage(playerid,COLOR_RED,"Operação cancelada!");
    }
    return 1;
}

YCMD:test(playerid,params[],help) {
    SetPlayerAttachedObject(playerid,1,1265,0,0.098632,-0.30000,-0.247495,32.700004,-0.000000,-11.300004);
    return 1;
}