/*
    Payday timer system
                        */

#include <YSI_Coding\y_hooks>

#define REWARD_DEFAULT_RESPECT 1
#define REWARD_DEFAULT_HOURS 1
#define REWARD_DEFAULT_MONEY_MIN 1000
#define REWARD_DEFAULT_MONEY_MAX 2500

hook OnPlayerConnect(playerid) {
    DeletePlayerPaydayTimer(playerid);
    return 1;
}
hook OnPlayerDisconnect(playerid, reason) {
    if(IsPlayerLoggedIn(playerid)) {
        PrepareSavePlayerPaydayTimer(playerid);
        DeletePlayerPaydayTimer(playerid);
    }
    return 1;
}

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

YCMD:paydaytime(playerid,params[],help) {
    gPaydayTimer[playerid][PAYDAYTIMER_H]=0;
    gPaydayTimer[playerid][PAYDAYTIMER_M]=0;
    gPaydayTimer[playerid][PAYDAYTIMER_S]=3;
    SendClientMessagef(playerid,-1,"Tempo até salario: %s",GetTimeFormatted(gPaydayTimer[playerid][PAYDAYTIMER_H],gPaydayTimer[playerid][PAYDAYTIMER_M],gPaydayTimer[playerid][PAYDAYTIMER_S]));
    return 1;
}

stock Payday:GivePlayerPaydayCheck(playerid) {
    // Rewards
    new respectReward = REWARD_DEFAULT_RESPECT;
    new moneyReward = REWARD_DEFAULT_MONEY_MIN + random(REWARD_DEFAULT_MONEY_MAX);
    new hoursReward = REWARD_DEFAULT_HOURS;
    new currentLevel = GetPlayerLevel(playerid);
    gPlayerLevel[playerid][PLAYERLEVEL_RESPECT]+=respectReward;
    gPlayerLevel[playerid][PLAYERLEVEL_HOURS]+=hoursReward;
    GivePlayerMoney(playerid,moneyReward);
    new outputMessage[6][120];
    format(outputMessage[0],120,"|_________| HORA DO SALÁRIO |________|");
    format(outputMessage[1],120,"Respeito {00FF00}+%d{FFFFFF} ({00FF00}%d/%d{FFFFFF})",respectReward,GetPlayerLevelRespect(playerid),CalculateRequiredLevelRespect(currentLevel));
    format(outputMessage[2],120,"Horas {00FF00}+%d{FFFFFF} ({00FF00}%d/%d{FFFFFF})",hoursReward,GetPlayerLevelHours(playerid),CalculateRequiredLevelHours(currentLevel));
    format(outputMessage[3],120,"Salário +R${00FF00}%d{FFFFFF} (R${00FF00}%d{FFFFFF})",moneyReward,GetPlayerMoney(playerid));
    format(outputMessage[4],120,"Para obteres uma caixa supresa, escreve {FFFF00}/caixinha{FFFFFF}");
    format(outputMessage[5],120,"Boa continuação de jogo!");
    for(new i;i<sizeof(outputMessage);i++)SendClientMessage(playerid,-1,outputMessage[i]);
    if(CanPlayerLevelUp(playerid))SendClientMessage(playerid,-1,"Já cumpres os requisitos para subires de nivel, escreve {FFFF00}/levelup{FFFFFF}!");
    PrepareSavePlayerLevel(playerid);
    return 1;
}
forward Payday:RunPlayerPaydayTimer(playerid);
public Payday:RunPlayerPaydayTimer(playerid) {
    if(IsPlayerPaydayTimerActive(playerid)) {
        if(!gPaydayTimer[playerid][PAYDAYTIMER_S]) {
            if(!gPaydayTimer[playerid][PAYDAYTIMER_M]) {
                if(!gPaydayTimer[playerid][PAYDAYTIMER_H]) {
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
