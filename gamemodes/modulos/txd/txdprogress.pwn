
/*
    Textdraw name: Progress
    Description: Shows a message with a progress bar in the bottom left of the screen
    Adapted for mobile: Yes
    Author: Bonnie20402
    Open-Source: Yes
                                                                                            */
#include <YSI_Coding\y_hooks>

new PlayerText:txdProgress_msg[MAX_PLAYERS];
new PlayerBar:txdProgress_progressbar[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
    txdProgress_msg[playerid] = CreatePlayerTextDraw(playerid, 8.000000, 379.000000, "Hackeando 100%");
    PlayerTextDrawFont(playerid, txdProgress_msg[playerid], 1);
    PlayerTextDrawLetterSize(playerid, txdProgress_msg[playerid], 0.554166, 1.450000);
    PlayerTextDrawTextSize(playerid, txdProgress_msg[playerid], 171.000000, -452.500000);
    PlayerTextDrawSetOutline(playerid, txdProgress_msg[playerid], 0);
    PlayerTextDrawSetShadow(playerid, txdProgress_msg[playerid], 1);
    PlayerTextDrawAlignment(playerid, txdProgress_msg[playerid], 1);
    PlayerTextDrawColor(playerid, txdProgress_msg[playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, txdProgress_msg[playerid], 160);
    PlayerTextDrawBoxColor(playerid, txdProgress_msg[playerid], 50);
    PlayerTextDrawUseBox(playerid, txdProgress_msg[playerid], 1);
    PlayerTextDrawSetProportional(playerid, txdProgress_msg[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, txdProgress_msg[playerid], 0);

    //Progress bar
    txdProgress_progressbar[playerid] = CreatePlayerProgressBar(playerid, 8.000000, 378.000000, 169.000000, 18.000000, -121, 100.000000, 0);
    SetPlayerProgressBarValue(playerid, txdProgress_progressbar[playerid], 50.000000);
    print("[txdprogress.pwn] The textdraw: Progress has been loaded!");
    return 1;
}

hook OnPlayerDisconnect(playerid,reason) {
    DestroyPlayerTxdProgress(playerid);
    return 1;
}

/*
    Script-friendly callbacks
                                */
stock ShowPlayerTxdProgress(playerid) {
    PlayerTextDrawShow(playerid,txdProgress_progressbar[playerid]);
    PlayerTextDrawShow(playerid,txdProgress_msg[playerid]);
    ShowPlayerProgressBar(playerid,txdProgress_progressbar[playerid]);
    return 1;
}
stock SetPlayerTxdProgressText(playerid,const message[]) {
    PlayerTextDrawSetString(playerid,txdProgress_msg[playerid],message);
    return 1;
}
stock SetPlayerTxdProgressProgress(playerid,Float:newprogress) {
    SetPlayerProgressBarValue(playerid,txdProgress_progressbar[playerid],newprogress);
    return 1;
}
stock HidePlayerTxdProgress(playerid) {
    PlayerTextDrawHide(playerid,txdProgress_progressbar[playerid]);
    PlayerTextDrawHide(playerid,txdProgress_msg[playerid]);
    HidePlayerProgressBar(playerid,txdProgress_progressbar[playerid]);
    return 1;
}
stock DestroyPlayerTxdProgress(playerid) {
    PlayerTextDrawDestroy(playerid,txdProgress_progressbar[playerid]);
    PlayerTextDrawDestroy(playerid,txdProgress_msg[playerid]);
    DestroyPlayerProgressBar(playerid,txdProgress_progressbar[playerid]);
    return 1;
}
