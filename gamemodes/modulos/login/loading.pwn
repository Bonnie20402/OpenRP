/*
    Connect
Handles player connection logic
                */
#include "modulos\login\loadingtxd.pwn"
#include "modulos\login\login.pwn"

new gLoadingTimer[MAX_PLAYERS];

/*
        Does the loading logic
                            */
#include <YSI_Coding\y_hooks>
hook OnPlayerConnect(playerid) {
    new msg[255];
    format(msg,255,"Ultima update: %s",LASTEST_UPDATE);
    gLoadingTimer[playerid]=-1;
    TogglePlayerSpectating(playerid,true);
    ShowLoadingScreen(playerid,msg);
    return 1;
}


public ShowLoadingScreen(playerid,const message[]) { 
    PlayerTextDrawShow(playerid,txdloadingBackground1[playerid]);
    PlayerTextDrawShow(playerid,txdloadingBackground2[playerid]);
    PlayerTextDrawShow(playerid,txdloadingVersion[playerid]);
    PlayerTextDrawShow(playerid,txdloadingTitle[playerid]);
    SetPlayerProgressBarValue(playerid,txdloadingProgress[playerid],0.0);
    ShowPlayerProgressBar(playerid,txdloadingProgress[playerid]);
    PlayerTextDrawSetString(playerid,txdloadingMessage[playerid],message);
    PlayerTextDrawShow(playerid,txdloadingMessage[playerid]);
    gLoadingTimer[playerid]=SetTimerEx("AddLoadingProgress",100,true,"i", playerid);
}




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
        OnPlayerLoad(playerid);
        return 1;
    }
    return 1;
}

public IsPlayerLoaded(playerid) {
    if(gLoadingTimer[playerid]==-1)return 0;
    return 1;
}

public OnPlayerLoad(playerid) {
    PrepareAccountCheck(playerid);
    return 1;
}
