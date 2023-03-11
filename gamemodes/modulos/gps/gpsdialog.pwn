#include <YSI_Coding\y_hooks>

#define GPSDIALOG_MAIN 6000
#define GPSDIALOG_GPS0 6001
#define GPSDIALOG_GPS1 6002
#define GPSDIALOG_GPS2 6003
public ShowPlayerMainGPSDialog(playerid) {
    new msg[256];
    format(msg,256,"\
    Locais Importanntes\n\
    HQ de Empregos\n\
    HQ de organizações\n\
    Serviços Publicos\
    Outros");
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
        new msg[256];
        format(msg,256,"Local\tDistancia\n");
        new Float:x,Float:y,Float:z,Float:distance;
        for(new i=0;i<sizeof(gLocations);i++) {
            //TODO make distance work
            if(strfind(gLocations[i][LOCATION_NAME],"GPS0_",true)!=-1) { // GPS0 -> Locais Importantes
                GetLocationCoordsPointers(GetLocationIDFromName(gLocations[i][LOCATION_NAME]),x,y,z);
                distance = GetPlayerDistanceFromPoint(playerid,x,y,z);
                new String:destinationList[64];
                strmid(destinationList,gLocations[i][LOCATION_NAME],5,strlen(gLocations[i][LOCATION_NAME]));
                format(msg,256,"%s%s\t%.2f METROS\n",msg,destinationList,distance);
            }
        }
        ShowPlayerDialog(playerid,GPSDIALOG_GPS0,DIALOG_STYLE_TABLIST_HEADERS,"GPS",msg,"Marcar","Sair");
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

