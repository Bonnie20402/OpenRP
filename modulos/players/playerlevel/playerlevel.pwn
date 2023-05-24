



/*
    Player level module - SQL table
    Keeps track of how many hours players have been playing on the server, how much respect they have and
    their level which is done by a formula and adds a hourly compensation for the playing players
    Uses YSI inline sql functions  (it's so fucking time-saving I love you whoever made YSI!)
                   
                                                                                 */
                                                    

#include <YSI_Coding\y_hooks>
hook OnPlayerDisconnect(playerid,reason) {
    if(IsPlayerLoggedIn(playerid)) {
        PrepareSavePlayerLevel(playerid);
        DeletePlayerLevel(playerid);
    }
    return 1;
}
hook OnPlayerConnect(playerid) {
    DeletePlayerLevel(playerid);
    return 1;
}

public DeletePlayerLevel(playerid) {
    gPlayerLevel[playerid][PLAYERLEVEL_LEVEL]=0;
    gPlayerLevel[playerid][PLAYERLEVEL_RESPECT]=0;
    gPlayerLevel[playerid][PLAYERLEVEL_HOURS]=0;
    return 1;
}

stock Payday:IsPlayerLevelLoaded(playerid) {
    if(IsPlayerLoggedIn(playerid)&&!gPlayerLevel[playerid])return 0;
    return 1;
}

/* Returns the required respect to go to next level, by passing the current level.
 The formula for the required respect R, for the current level l is as follows:
    R(l) = 12l;
*/
stock Payday:CalculateRequiredLevelRespect(level) {
    return 12*level;
}

/* Returns the required playtime, in hours, to go to next level, by passing the current level.
 The formula for the required playtime P, for the current level l is as follows:
    P(l) = 3l;
*/
stock Payday:CalculateRequiredLevelHours(level) {
    return 3*level;
}

stock Payday:GetPlayerLevel(playerid) {
    if(!IsPlayerLoggedIn(playerid))return INVALID_LEVEL;
    return gPlayerLevel[playerid][PLAYERLEVEL_LEVEL];
}

stock Payday:GetPlayerLevelRespect(playerid) {
    return gPlayerLevel[playerid][PLAYERLEVEL_RESPECT];
}
stock Payday:GetPlayerLevelHours(playerid) {
    return gPlayerLevel[playerid][PLAYERLEVEL_HOURS];
}

stock Payday:CanPlayerLevelUp(playerid) {
    if(!IsPlayerLoggedIn(playerid))return 0;
    new level=GetPlayerLevel(playerid);
    if(GetPlayerLevelRespect(playerid) >= CalculateRequiredLevelRespect(level) && GetPlayerLevelHours(playerid) >= CalculateRequiredLevelHours(level)) {
        return 1;
    }
    return 0;
}

YCMD:levelup(playerid,params[],help) {
    ShowPlayerLevelLevelUpDialog(playerid);
    return 1;
}

stock Payday:SetPlayerLevelRespect(playerid,respect) {
    gPlayerLevel[playerid][PLAYERLEVEL_RESPECT]=respect;
    return 1;
}
stock Payday:SetPlayerLevelHours(playerid,hours) {
    gPlayerLevel[playerid][PLAYERLEVEL_HOURS]=hours;
    return 1;
}
stock Payday:ShowPlayerLevelLevelUpDialog(playerid) {
    new nextLevel=GetPlayerLevel(playerid);
    inline Response(response,listitem,String:input[]) {
        #pragma unused listitem,Stinput
        if(response) {
            if(!CanPlayerLevelUp(playerid))return Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Ups!","Não cumpres os requisitos para subir de nivel!","OK","");
            gPlayerLevel[playerid][PLAYERLEVEL_LEVEL]++;
            gPlayerLevel[playerid][PLAYERLEVEL_RESPECT]-=CalculateRequiredLevelRespect(nextLevel);
            SetPlayerScore(playerid,GetPlayerLevel(playerid));
            PrepareSavePlayerLevel(playerid);
            SendClientMessage(playerid,COLOR_AQUA,"Subiste de nivel, parabens!");
            GameTextForPlayer(playerid,"LEVEL UP!",3000,3);
        }
    }
    new requirmentMet[32] = "{00FF00}OK{FFFFFF}";
    new requirmentUnmet[32] = "{FF0000}INSUFICIENTE{FFFFFF}";
    new dBody[256];
    format(dBody,256,"{FFFFFF}\
    Requisitos para subir para o nivel {FFFF00}%d{FFFFFF}\n\n\
    Respeito: {00FF00}%d{FFFFFF} (%s)\n\
    Horas de  jogo: {00FF00}%d{FFFFFF} (%s)\n\n Continuar?",\
    nextLevel+1,CalculateRequiredLevelRespect(nextLevel),\
    //Ternary operation
    GetPlayerLevelRespect(playerid) >= CalculateRequiredLevelRespect(nextLevel) ? requirmentMet : requirmentUnmet,\
    CalculateRequiredLevelHours(nextLevel),\
    //Ternary operation
    GetPlayerLevelHours(playerid) >= CalculateRequiredLevelHours(nextLevel) ? requirmentMet : requirmentUnmet);
    Dialog_ShowCallback(playerid,using inline Response,DIALOG_STYLE_MSGBOX,"LEVEL UP!",dBody,"Level UP!","Cancelar");
    return 1;
}
