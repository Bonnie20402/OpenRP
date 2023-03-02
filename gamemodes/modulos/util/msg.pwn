#include "modulos/util/txdmsg.pwn"
#include <YSI_Coding/y_hooks>
new gscreenMsg[MAX_PLAYERS];

hook OnPlayerConnect@003@003(playerid) {
    gscreenMsg[playerid]=0;
}

/*
        Shows a message to the player
                                    */
stock ShowPlayerScreenMessage(playerid,time,const message[]) {
    if(PlayerHasScreenMessage(playerid))return 0;
    PlayerTextDrawSetString(playerid,txdscreenMsg[playerid],message);
    PlayerTextDrawShow(playerid,txdscreenMsg[playerid]);
    gscreenMsg[playerid]=1;
    SetTimerEx("DestroyPlayerScreenMessage",time,false,"i",playerid);
    return 1;
}

/*
                    Destroies the textdraw
                    (should not be used outside of here)            */
forward DestroyPlayerScreenMessage(playerid);
public DestroyPlayerScreenMessage(playerid) {
    gscreenMsg[playerid]=0;
    PlayerTextDrawHide(playerid,txdscreenMsg[playerid]);
}

/*
        Checks if the player has a screen messager
                                                    */
stock PlayerHasScreenMessage(playerid) {
    return gscreenMsg[playerid];
}