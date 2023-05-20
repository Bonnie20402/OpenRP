#include <YSI_Coding\y_hooks>
new gCreatingATM[MAX_PLAYERS];

YCMD:criaratm(playerid,params[],help) {
    if(GetStaffLevel(playerid)>4999) {
        if(!gCreatingATM[playerid]) {
            new Float:x,Float:y,Float:z,Float:rX,Float:rY,Float:rZ;
            GetPlayerPos(playerid,x,y,z);
            rX=0.0;
            rY=0.0;
            rZ=0.0;
            SendClientMessage(playerid,COLOR_RED,"Sessão de edit iniciada - ajusta a posição, depois salva!");
            gCreatingATM[playerid] = CreateDynamicObject(19324,x,y,z,rX,rY,rZ,-1,-1,playerid);
            EditDynamicObject(playerid,gCreatingATM[playerid]);
            SendStaffMessage(-1,"Um Programadar está a criar um ATM!");
        }
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Não és Programador!");
    return 1;
}

hook OnPlayerEditDynamicObject(playerid,objectid,response,Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz) {
    if(response==EDIT_RESPONSE_FINAL&&gCreatingATM[playerid]==objectid) {
        DestroyDynamicObject(gCreatingATM[playerid]);
        gCreatingATM[playerid]=0;
        PrepareAddBankAtm(x,y,z,rx,ry,rz);
        SendClientMessage(playerid,COLOR_RED,"ATM adicionado!");
        return 1;
    }
    if(response==EDIT_RESPONSE_CANCEL&&gCreatingATM[playerid]==objectid) {
        DestroyDynamicObject(gCreatingATM[playerid]);
        SendClientMessage(playerid,COLOR_RED,"Operação cancelada!");
        gCreatingATM[playerid]=0;
        return 1;
    }
    return 1;
}

hook OnPlayerDisconnect(playerid,reason) {
    gCreatingATM[playerid]=0;
    return 1;
}