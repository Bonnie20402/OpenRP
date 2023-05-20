
/*
    Textdraw name: Progress
    Description: Shows a message with a progress bar in the bottom left of the screen
    Adapted for mobile: NO, BROKEN TODO fix for mobile
    Author: Bonnie20402
    Open-Source: Yes
                                                                                            */
#include <YSI_Coding\y_hooks>

enum BNOTIFICATION {
    BNOTIFICATION_TIMERID,
    Float:BNOTIFICATION_PROGRESS,
    BNOTIFICATION_INTERVAL
}
new PlayerText:txdNotification_message[MAX_PLAYERS];
new PlayerText:txdNotification_bg[MAX_PLAYERS];
new PlayerText:txdNotification_leftbar[MAX_PLAYERS];
new PlayerText:txdNotification_sprite[MAX_PLAYERS];
new PlayerText:txdNotification_time[MAX_PLAYERS];
new PlayerText:txdNotification_spriteicon[MAX_PLAYERS];


hook OnPlayerConnect(playerid) {
    
    //PlayerTextDraws
    txdNotification_message[playerid] = CreatePlayerTextDraw(playerid,473.000000, 150.000000, "Titulo~n~Corpo da mensagem");
    PlayerTextDrawFont(playerid,txdNotification_message[playerid], 1);
    PlayerTextDrawLetterSize(playerid,txdNotification_message[playerid], 0.241665, 1.350000);
    PlayerTextDrawTextSize(playerid,txdNotification_message[playerid], 608.500000, 9.000000);
    PlayerTextDrawSetOutline(playerid,txdNotification_message[playerid], 0);
    PlayerTextDrawSetShadow(playerid,txdNotification_message[playerid], 0);
    PlayerTextDrawAlignment(playerid,txdNotification_message[playerid], 1);
    PlayerTextDrawColor(playerid,txdNotification_message[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid,txdNotification_message[playerid], 255);
    PlayerTextDrawBoxColor(playerid,txdNotification_message[playerid], -1727987888);
    PlayerTextDrawUseBox(playerid,txdNotification_message[playerid], 0);
    PlayerTextDrawSetProportional(playerid,txdNotification_message[playerid], 1);
    PlayerTextDrawSetSelectable(playerid,txdNotification_message[playerid], 0);

    //Player PlayerTextDraws
    txdNotification_bg[playerid] = CreatePlayerTextDraw(playerid, 522.000000, 146.000000, "_");
    PlayerTextDrawFont(playerid, txdNotification_bg[playerid], 1);
    PlayerTextDrawLetterSize(playerid, txdNotification_bg[playerid], 0.183332, 4.850001);
    PlayerTextDrawTextSize(playerid, txdNotification_bg[playerid], 273.500000, 170.000000);
    PlayerTextDrawSetOutline(playerid, txdNotification_bg[playerid], 1);
    PlayerTextDrawSetShadow(playerid, txdNotification_bg[playerid], 0);
    PlayerTextDrawAlignment(playerid, txdNotification_bg[playerid], 2);
    PlayerTextDrawColor(playerid, txdNotification_bg[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, txdNotification_bg[playerid], 1296911871);
    PlayerTextDrawBoxColor(playerid, txdNotification_bg[playerid], 1296911871);
    PlayerTextDrawUseBox(playerid, txdNotification_bg[playerid], 1);
    PlayerTextDrawSetProportional(playerid, txdNotification_bg[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, txdNotification_bg[playerid], 0);

    txdNotification_leftbar[playerid] = CreatePlayerTextDraw(playerid, 435.000000, 146.000000, "_");
    PlayerTextDrawFont(playerid, txdNotification_leftbar[playerid], 1);
    PlayerTextDrawLetterSize(playerid, txdNotification_leftbar[playerid], 0.600000, 4.850001);
    PlayerTextDrawTextSize(playerid, txdNotification_leftbar[playerid], 298.500000, -1.000000);
    PlayerTextDrawSetOutline(playerid, txdNotification_leftbar[playerid], 1);
    PlayerTextDrawSetShadow(playerid, txdNotification_leftbar[playerid], 0);
    PlayerTextDrawAlignment(playerid, txdNotification_leftbar[playerid], 2);
    PlayerTextDrawColor(playerid, txdNotification_leftbar[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, txdNotification_leftbar[playerid], -1962934017);
    PlayerTextDrawBoxColor(playerid, txdNotification_leftbar[playerid], -2016478465);
    PlayerTextDrawUseBox(playerid, txdNotification_leftbar[playerid], 1);
    PlayerTextDrawSetProportional(playerid, txdNotification_leftbar[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, txdNotification_leftbar[playerid], 0);

    txdNotification_sprite[playerid] = CreatePlayerTextDraw(playerid, 438.000000, 142.000000, "ld_beat:chit");
    PlayerTextDrawFont(playerid, txdNotification_sprite[playerid], 4);
    PlayerTextDrawLetterSize(playerid, txdNotification_sprite[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, txdNotification_sprite[playerid], 35.000000, 43.500000);
    PlayerTextDrawSetOutline(playerid, txdNotification_sprite[playerid], 1);
    PlayerTextDrawSetShadow(playerid, txdNotification_sprite[playerid], 0);
    PlayerTextDrawAlignment(playerid, txdNotification_sprite[playerid], 1);
    PlayerTextDrawColor(playerid, txdNotification_sprite[playerid], -2016478465);
    PlayerTextDrawBackgroundColor(playerid, txdNotification_sprite[playerid], 255);
    PlayerTextDrawBoxColor(playerid, txdNotification_sprite[playerid], 50);
    PlayerTextDrawUseBox(playerid, txdNotification_sprite[playerid], 1);
    PlayerTextDrawSetProportional(playerid, txdNotification_sprite[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, txdNotification_sprite[playerid], 0);

    txdNotification_time[playerid] = CreatePlayerTextDraw(playerid, 581.000000, 178.000000, "00:00");
    PlayerTextDrawFont(playerid, txdNotification_time[playerid], 1);
    PlayerTextDrawLetterSize(playerid, txdNotification_time[playerid], 0.241665, 1.350000);
    PlayerTextDrawTextSize(playerid, txdNotification_time[playerid], 608.500000, 9.000000);
    PlayerTextDrawSetOutline(playerid, txdNotification_time[playerid], 0);
    PlayerTextDrawSetShadow(playerid, txdNotification_time[playerid], 0);
    PlayerTextDrawAlignment(playerid, txdNotification_time[playerid], 1);
    PlayerTextDrawColor(playerid, txdNotification_time[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, txdNotification_time[playerid], 255);
    PlayerTextDrawBoxColor(playerid, txdNotification_time[playerid], -1727987888);
    PlayerTextDrawUseBox(playerid, txdNotification_time[playerid], 0);
    PlayerTextDrawSetProportional(playerid, txdNotification_time[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, txdNotification_time[playerid], 0);

    txdNotification_spriteicon[playerid] = CreatePlayerTextDraw(playerid, 453.000000, 144.000000, "i");
    PlayerTextDrawFont(playerid, txdNotification_spriteicon[playerid], 1);
    PlayerTextDrawLetterSize(playerid, txdNotification_spriteicon[playerid], 0.608332, 3.799998);
    PlayerTextDrawTextSize(playerid, txdNotification_spriteicon[playerid], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, txdNotification_spriteicon[playerid], 0);
    PlayerTextDrawSetShadow(playerid, txdNotification_spriteicon[playerid], 0);
    PlayerTextDrawAlignment(playerid, txdNotification_spriteicon[playerid], 1);
    PlayerTextDrawColor(playerid, txdNotification_spriteicon[playerid], 1296911871);
    PlayerTextDrawBackgroundColor(playerid, txdNotification_spriteicon[playerid], 255);
    PlayerTextDrawBoxColor(playerid, txdNotification_spriteicon[playerid], 50);
    PlayerTextDrawUseBox(playerid, txdNotification_spriteicon[playerid], 0);
    PlayerTextDrawSetProportional(playerid, txdNotification_spriteicon[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, txdNotification_spriteicon[playerid], 0);

    return 1;
}

hook OnPlayerDisconnect(playerid,reason) {
    DestroyPlayerTxdbNotification(playerid);
    return 1;
}

/*
    Script-friendly callbacks
                                */
stock ShowPlayerTxdbNotification(playerid) {
    PlayerTextDrawShow(playerid,txdNotification_bg[playerid]);
    PlayerTextDrawShow(playerid,txdNotification_spriteicon[playerid]);
    PlayerTextDrawShow(playerid,txdNotification_leftbar[playerid]);
    PlayerTextDrawShow(playerid,txdNotification_message[playerid]);
    PlayerTextDrawShow(playerid,txdNotification_sprite[playerid]);
    PlayerTextDrawShow(playerid,txdNotification_spriteicon[playerid]);
    PlayerTextDrawShow(playerid,txdNotification_time[playerid]);
    return 1;
}
/*
    Display the message, interval to destroy in seconds
                    */
stock SetPlayerTxdbNotifText(playerid,String:message[],seconds) {
    new interval;
    interval=seconds*1000;
    PlayerTextDrawSetString(playerid,txdNotification_message[playerid],message);
    SetPreciseTimer("HidePlayerTxdbNotification",interval,false,"i",playerid);
    return 1;
}
/*
    Using this function outside txdbnotification.pwn is not encouraged
                                                                        */
                                                                        
forward HidePlayerTxdbNotification(playerid);
public HidePlayerTxdbNotification(playerid) {
    PlayerTextDrawHide(playerid,txdNotification_bg[playerid]);
    PlayerTextDrawHide(playerid,txdNotification_spriteicon[playerid]);
    PlayerTextDrawHide(playerid,txdNotification_leftbar[playerid]);
    PlayerTextDrawHide(playerid,txdNotification_message[playerid]);
    PlayerTextDrawHide(playerid,txdNotification_sprite[playerid]);
    PlayerTextDrawHide(playerid,txdNotification_spriteicon[playerid]);
    PlayerTextDrawHide(playerid,txdNotification_time[playerid]);
    return 1;
}
stock DestroyPlayerTxdbNotification(playerid) {
    PlayerTextDrawDestroy(playerid,txdNotification_bg[playerid]);
    PlayerTextDrawDestroy(playerid,txdNotification_spriteicon[playerid]);
    PlayerTextDrawDestroy(playerid,txdNotification_leftbar[playerid]);
    PlayerTextDrawDestroy(playerid,txdNotification_message[playerid]);
    PlayerTextDrawDestroy(playerid,txdNotification_sprite[playerid]);
    PlayerTextDrawDestroy(playerid,txdNotification_spriteicon[playerid]);
    PlayerTextDrawDestroy(playerid,txdNotification_time[playerid]);
    return 1;
}
