/*
    Payday timer system
                        */


#define PAYDAYDEFAULT_H 0
#define PAYDAYDEFAULT_M 0
#define PAYDAYDEFAULT_S 20
#define PAYDAYDEFAULT_PAYCHECK_MAX 1500
#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid) {
    DeletePlayerPaydayTimer(playerid);
    return 1;
}
hook OnPlayerDisconnect(playerid, reason) {
    if(IsPlayerLoggedIn(playerid))DeletePlayerPaydayTimer(playerid);
    return 1;
}

enum PAYDAYTIMER {
    PAYDAYTIMER_ACTIVE,
    PAYDAYTIMER_H,
    PAYDAYTIMER_M,
    PAYDAYTIMER_S
}

new gPaydayTimer[MAX_PLAYERS][PAYDAYTIMER];


stock Payday:DeletePlayerPaydayTimer(playerid) {
    gPaydayTimer[playerid][PAYDAYTIMER_ACTIVE] = 0;
    gPaydayTimer[playerid][PAYDAYTIMER_H] = 0; 
    gPaydayTimer[playerid][PAYDAYTIMER_M] = 0; 
    gPaydayTimer[playerid][PAYDAYTIMER_S] = 0; 
}


stock Payday:ResetPlayerPaydayTimer(playerid) {
    gPaydayTimer[playerid][PAYDAYTIMER_ACTIVE] = 1;
    gPaydayTimer[playerid][PAYDAYTIMER_H] = PAYDAYDEFAULT_H; 
    gPaydayTimer[playerid][PAYDAYTIMER_M] = PAYDAYDEFAULT_M; 
    gPaydayTimer[playerid][PAYDAYTIMER_S] = PAYDAYDEFAULT_S; 
    SetPreciseTimer("RunPlayerPaydayTimer",1000,false,"i",playerid);
}

stock Payday:IsPlayerPaydayTimerActive(playerid) {
    return gPaydayTimer[playerid][PAYDAYTIMER_ACTIVE];
}
YCMD:payday(playerid,params[],help) {
    ResetPlayerPaydayTimer(playerid);
    return 1;
}
YCMD:paydaytime(playerid,params[],help) {
    SendClientMessage(playerid,-1,"beep!");
    SendClientMessagef(playerid,-1,"Tempo até salario: %s",GetTimeFormatted(gPaydayTimer[playerid][PAYDAYTIMER_H],gPaydayTimer[playerid][PAYDAYTIMER_M],gPaydayTimer[playerid][PAYDAYTIMER_S]));
    return 1;
}
stock Payday:GivePlayerPaydayCheck(playerid) {
    gPlayerLevel[playerid][PLAYERLEVEL_RESPECT]++;
    gPlayerLevel[playerid][PLAYERLEVEL_HOURS]++;
    new dBody[512];
    format(dBody,512,"É hora do salário!\nRecebeste o ordebnado yay");
    Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Payday!",dBody,"OK","");
    return 1;
}
forward Payday:RunPlayerPaydayTimer(playerid);
public Payday:RunPlayerPaydayTimer(playerid) {
    if(IsPlayerPaydayTimerActive(playerid)) {
        if(!gPaydayTimer[playerid][PAYDAYTIMER_S]) {
            if(!gPaydayTimer[playerid][PAYDAYTIMER_M]) {
                if(!gPaydayTimer[playerid][PAYDAYTIMER_H]) {
                    //TODO add bonus paycheck stuff yay
                    GivePlayerPaydayCheck(playerid);
                    ResetPlayerPaydayTimer(playerid);
                    return 1; // avoid timer duplicate
                }
                else {
                    gPaydayTimer[playerid][PAYDAYTIMER_H]--;
                    gPaydayTimer[playerid][PAYDAYTIMER_M]=59;
                }
            }
            else {
                gPaydayTimer[playerid][PAYDAYTIMER_M]--;
                gPaydayTimer[playerid][PAYDAYTIMER_S]=59;
            }
        }
        else gPaydayTimer[playerid][PAYDAYTIMER_S]--;
        SetPreciseTimer("RunPlayerPaydayTimer",1000,false,"i",playerid);
        return 1;
    }
}
