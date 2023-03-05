#include <YSI_Coding\y_hooks>

#define GPSDIALOG_MAIN 6000
#define GPSDIALOG_LOCAISIMPORTANTES 6001
#define GPSDIALOG_HQEMPREGOS 6002
#define GPSDIALOG_HQORGS 6003
public ShowGPSMainDialog(playerid) {
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
//TODO melhorar gps mais para a frente
// TODO move to playercmds
YCMD:gps(playerid,params[],help) {
    ShowGPSMainDialog(playerid);
    return 1;
}
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(response&&dialogid==GPSDIALOG_MAIN) {
        new msg[256];
        format(msg,256,"\
        Spawn Civil\n\
        Agencia de Empregos\n\
        Caixinha\n\
        Mercado\
        ");
        ShowPlayerDialog(playerid,GPSDIALOG_LOCAISIMPORTANTES,DIALOG_STYLE_LIST,"GPS",msg,"Marcar","Sair");
        return 1;
    }
    if(response&&dialogid==GPSDIALOG_LOCAISIMPORTANTES) {
        print(inputtext);
        CreateGPSTimer(playerid,GetLocationIDFromName(inputtext));
    }
    return 1;
}

