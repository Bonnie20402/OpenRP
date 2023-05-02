
#include <YSI_Coding\y_hooks>

#define CHAT_DISTANCE 75.0

hook OnPlayerText(playerid, text[]) {
    new isHelped,isAdminHelping;
    for(new i;i<MAX_HELP_REQUESTS;i++) {
        if(IsValidHelpRequest(i)&&gHelpRequests[i][HELPHANDLER_ADMINID]==playerid)isAdminHelping=1;
    }
    isHelped=GetPlayerHelpRequestIndex(playerid);
    if(!isAdminHelping && isHelped == -1 && IsPlayerLoggedIn(playerid)) {
        new Float:x,Float:y,Float:z;
        GetPlayerPos(playerid,x,y,z);
        new outputMessageA[128],outputMessageB[128];
        // If size is too big split the string
        if(strlen(text)>128) {
            strmid(outputMessageA,text,0,128,sizeof(outputMessageA));
            strmid(outputMessageB,text,129,sizeof(outputMessageB));
        }
        else format(outputMessageA,128,"%s",text);
        for(new i;i<MAX_PLAYERS;i++) {
            if(GetPlayerDistanceToPointEx(i,x,y,z) <= CHAT_DISTANCE) {
                if(IsValidStaff(playerid)) {
                    SendClientMessagef(i,COLOR_RED,"%s %s[%d] diz %s",GetStaffLevelString(playerid),GetPlayerNameEx(playerid),playerid,outputMessageA);
                    if(strlen(outputMessageB))SendClientMessagef(i,COLOR_RED,"(...) %s",outputMessageB);
                }
                else {
                    SendClientMessagef(i,COLOR_WHITE,"%s[%d] diz %s",GetPlayerNameEx(playerid),playerid,outputMessageA);
                    if(strlen(outputMessageB))SendClientMessagef(i,COLOR_WHITE,"(...) %s",outputMessageB);
                }
            }
        }
    }
    return 0;
}