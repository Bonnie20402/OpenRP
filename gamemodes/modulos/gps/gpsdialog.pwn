#include <YSI_Coding/y_hooks>

#define GPSDIALOG_MAIN 6000
#define GPSDIALOG_LOCAISIMPORTANTES 6001
#define GPSDIALOG_HQEMPREGOS 6002
#define GPSDIALOG_HQORGS 6003
stock ShowGPSMainDialog(playerid) {
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
YCMD:gps(playerid,params[],help) {
    ShowGPSMainDialog(playerid);
    return 1;
}
hook OnDialogResponse@004(playerid, dialogid, response, listitem, inputtext[]) {
    if(response&&dialogid==GPSDIALOG_MAIN) {
        new msg[256];
        format(msg,256,"\
        Spawn Civil\n\
        Agencia de Empregos\n\
        Caixinha\n\
        Mercado\
        ");
        ShowPlayerDialog(playerid,GPSDIALOG_LOCAISIMPORTANTES,DIALOG_STYLE_LIST,"GPS",msg,"Marcar","Sair");
    }
    if(response&&dialogid==GPSDIALOG_LOCAISIMPORTANTES) {
        CreateGPSTimer(playerid,GetLocationIDFromName(inputtext));
    }
}

