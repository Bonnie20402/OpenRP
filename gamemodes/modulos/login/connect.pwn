/*
    Connect
Handles player connection logic
                */
#include "modulos/login/connecttxd.pwn"
#include "modulos/login/login.pwn"
#include <YSI_Coding/y_hooks>

new gLoadingTimer[MAX_PLAYERS];

/*
        Does the loading logic
                            */
hook OnPlayerConnect@004(playerid) {
    gLoadingTimer[playerid]=-1;
    TogglePlayerSpectating(playerid,true);
    ShowLoadingScreen(playerid,"A carregar...");
}

stock ShowLoadingScreen(playerid,const message[]) { 
    PlayerTextDrawShow(playerid,txdloadingBackground1[playerid]);
    PlayerTextDrawShow(playerid,txdloadingBackground2[playerid]);
    PlayerTextDrawShow(playerid,txdloadingVersion[playerid]);
    PlayerTextDrawShow(playerid,txdloadingTitle[playerid]);
    SetPlayerProgressBarValue(playerid,txdloadingProgress[playerid],0.0);
    ShowPlayerProgressBar(playerid,txdloadingProgress[playerid]);
    PlayerTextDrawSetString(playerid,txdloadingMessage[playerid],message);
    PlayerTextDrawShow(playerid,txdloadingMessage[playerid]);
    gLoadingTimer[playerid]=SetTimerEx("AddLoadingProgress",1,true,"i", playerid);
}

forward AddLoadingProgress(playerid);
public AddLoadingProgress(playerid) {
    //Se ainda não estiver carregado
    if(gLoadingTimer[playerid]!=-1) {
        new Float:currentProgress;
        currentProgress=GetPlayerProgressBarValue(playerid,txdloadingProgress[playerid]);
        if(currentProgress < 100.0) {
            new Float:newProgress;
            newProgress = currentProgress + 1.5;
            SetPlayerProgressBarValue(playerid,txdloadingProgress[playerid],newProgress);
            return 1;
        }
        //Se já estiver carregado
        HidePlayerProgressBar(playerid,txdloadingProgress[playerid]);
        PlayerTextDrawHide(playerid,txdloadingMessage[playerid]);
        KillTimer(gLoadingTimer[playerid]);
        gLoadingTimer[playerid]=-1;
        PrepareAccountCheck(playerid);
        SendClientMessage(playerid,-1,"Fim");
    }
}
