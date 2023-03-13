/*
    GPS
    Server GPS System, based on Locations
                                        */
#include "modulos\gps\icons.pwn"
#include "modulos\gps\gpstxd.pwn"
#include "modulos\gps\gpsdialog.pwn"
#include <YSI_Coding\y_hooks>


// TODO: Completar GPS


/*
    STOCKS
                    */

public CreateGPSTimer(playerid,locationid) {
    if(!IsValidLocation(locationid)) {
        SendClientMessage(playerid,COLOR_RED,"[GPS] Localização inválida!");
        return 0;
    }
    new String:msg[64];
    format(msg,64,"GPS a apontar para %s",gLocations[locationid][LOCATION_NAME]);
    SetPlayerCheckpoint(playerid,GetLocationX(locationid),GetLocationY(locationid),GetLocationZ(locationid),5);
    ShowPlayerScreenMessage(playerid,3000,msg);
    gGPS[playerid][GPS_LOCID]=locationid;
    gGPS[playerid][GPS_TIMERID]=SetTimerEx("UpdateGPSDistance",500,true,"i",playerid);
    PlayerTextDrawShow(playerid,txdGPS_distance[playerid]);
    PlayerTextDrawShow(playerid,txdGPS_background[playerid]);
    return 1;
}
public UpdateGPSDistance(playerid) {
    new locationid,String:distanceText[64];
    locationid=gGPS[playerid][GPS_LOCID];
    gGPS[playerid][GPS_DIST]=GetPlayerDistanceFromPoint(playerid,GetLocationX(locationid),GetLocationY(locationid),GetLocationZ(locationid));
    format(distanceText,64,"%.1fM",gGPS[playerid][GPS_DIST]-5);
    PlayerTextDrawSetString(playerid,txdGPS_distance[playerid],distanceText);
    return 1;
}

/*
    Hooks
                    */
#include <YSI_Coding\y_hooks>
hook OnPlayerEnterCheckpoint(playerid) {
    if(gGPS[playerid][GPS_LOCID]) {
        gGPS[playerid][GPS_LOCID]=0;
        KillTimer(gGPS[playerid][GPS_TIMERID]);
        gGPS[playerid][GPS_TIMERID]=0;
        DisablePlayerCheckpoint(playerid);
        ShowPlayerScreenMessage(playerid,3000,"Chegaste ao teu destino!");
        PlayerTextDrawHide(playerid,txdGPS_distance[playerid]);
        PlayerTextDrawHide(playerid,txdGPS_background[playerid]);
    }
    return 1;
}


