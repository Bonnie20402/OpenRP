#include <YSI_Coding\y_hooks>

#define GPSDIALOG_MAIN 6000
#define GPSDIALOG_GPS0 6001
#define GPSDIALOG_GPS1 6002
#define GPSDIALOG_GPS2 6003
#define GPSDIALOG_TURNOFF 6005
/*
    Clarifications
    In order to make the GPS dynamic, we will be using tags before the location names
    e.g GPS0_Name will  list all of the location that start with the GPS0_ location tag.
                  */
public ShowPlayerMainGPSDialog(playerid) {
    new msg[256];
    format(msg,256,"\
    Locais Importanntes\n\
    HQ de Empregos\n\
    HQ de organizações\n\
    Serviços Publicos\n\
    Outros\n\
    Desligar GPS");
    ShowPlayerDialog(playerid,GPSDIALOG_MAIN,DIALOG_STYLE_LIST,"GPS",msg,"Próximo","Sair");
    return 1;
}
// TODO move to playercmds
YCMD:gps(playerid,params[],help) {
    ShowPlayerMainGPSDialog(playerid);
    return 1;
}
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(response&&dialogid==GPSDIALOG_MAIN) {
        if(listitem==0) {
            new msg[256];
            format(msg,256,"Local\tDistancia\n");
            new Float:x,Float:y,Float:z,Float:distance;
            for(new i=0;i<sizeof(gLocations);i++) {
                if(strfind(gLocations[i][LOCATION_NAME],"GPS0_",true)!=-1) { 
                    GetLocationCoordsPointers(GetLocationIDFromName(gLocations[i][LOCATION_NAME]),x,y,z);
                    distance = GetPlayerDistanceFromPoint(playerid,x,y,z);
                    new String:destinationList[64];
                    strmid(destinationList,gLocations[i][LOCATION_NAME],5,strlen(gLocations[i][LOCATION_NAME]));
                    format(msg,256,"%s%s\t%.2f METROS\n",msg,destinationList,distance);
                }
            }
            ShowPlayerDialog(playerid,GPSDIALOG_GPS0,DIALOG_STYLE_TABLIST_HEADERS,"GPS",msg,"Marcar","Voltar");
        }
        if(listitem==5)  {// Sair 
            if(gGPS[playerid][GPS_LOCID]) {
                KillTimer(gGPS[playerid][GPS_TIMERID]);
                gGPS[playerid][GPS_TIMERID]=0;
                gGPS[playerid][GPS_LOCID]=0;
                DisablePlayerCheckpoint(playerid);
                PlayerTextDrawHide(playerid,txdGPS_distance[playerid]);
                PlayerTextDrawHide(playerid,txdGPS_background[playerid]);
                SendClientMessage(playerid,COLOR_YELLOW,"O teu GPS foi desligado!");
            }
            else SendClientMessage(playerid,COLOR_YELLOW,"O teu GPS não está ligado!");
        }
        return 1;
    }
    if(dialogid==GPSDIALOG_GPS0) {
        if(response) {
            new String:gpsDestination[64];
            format(gpsDestination,64,"%s%s","GPS0_",inputtext);
            CreateGPSTimer(playerid,GetLocationIDFromName(gpsDestination));
            print(gpsDestination);
            return 1;
        }
        else ShowPlayerMainGPSDialog(playerid);
    }
    return 1;
}

