/*
    Loading
Handles player connection logic
                */

#include "modulos\login\login.pwn"

#include <YSI_Coding\y_hooks>

/*
        Does the loading logic
                            */
hook OnPlayerConnect(playerid) {
    PlayAudioStreamForPlayer(playerid,"https://www.dropbox.com/s/9j4s4for2y0ymx5/VSImpostor_DLOW.mp3?dl=1");
    ClearPlayerChat(playerid);
    SendClientMessage(playerid,COLOR_AQUA,"Bem-vindo!");
    SendClientMessage(playerid,COLOR_AQUA,"A carregar informações do SQL, aguarda...");
    gLoadingTimer[playerid]=-1;
    TogglePlayerSpectating(playerid,true);
    gLoadingTimer[playerid]=SetPreciseTimer("AddLoadingProgress",120,true,"i", playerid);
    SetPlayerTxdLoadingProgress(playerid,0.0);
    ShowPlayerTxdLoading(playerid,0);
    return 1;
}



forward AddLoadingProgress(playerid);
public AddLoadingProgress(playerid) {
    if(gLoadingTimer[playerid]!=-1) {
        new Float:currentProgress;
        currentProgress=GetPlayerTxdLoadingProgress(playerid);
        if(currentProgress < 100.0) {
            new Float:newProgress;
            newProgress = currentProgress + 2;
            SetPlayerTxdLoadingProgress(playerid,newProgress);
            return 1;
        }
        //Se já estiver carregado
        DeletePreciseTimer(gLoadingTimer[playerid]);
        gLoadingTimer[playerid]=-1;
        SendClientMessage(playerid,COLOR_AQUA,"Concluido, carrega no botão JOGAR para iniciares essão!");
        ShowPlayerTxdLoading(playerid,1);
        return 1;
    }
    return 1;
}

public IsPlayerLoaded(playerid) {
    if(gLoadingTimer[playerid]==-1)return 0;
    return 1;
}

public OnPlayerLoad(playerid) {
    ShowCreditsDialog(playerid);
    return 1;
}
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
    if(playertextid==txdLoading_btn0[playerid]) { // Jogar
        CancelSelectTextDraw(playerid);
        OnPlayerLoad(playerid);
    }
    if(playertextid==txdLoading_btn1[playerid]) { // Channgelog TODO Changelog
        CancelSelectTextDraw(playerid);
        OnPlayerLoad(playerid);
    }
    if(playertextid==txdLoading_btn2[playerid]) { // Sair
        CancelSelectTextDraw(playerid);
        Kick(playerid);
    }
    return 1;
}
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid==CREDITSDIALOG&&!IsPlayerLoggedIn(playerid)) {
        PrepareAccountCheck(playerid);
    }
    return 1;
}
