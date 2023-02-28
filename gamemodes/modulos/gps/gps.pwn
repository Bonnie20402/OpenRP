
#include <YSI_Coding/y_hooks>
#include <YSI_Visual/y_commands>

enum GPSDIALOG:GPSLIST{
    GPSDIALOG_INICIO,
    GPSDIALOG_LS,
    GPSDIALOG_EMPRESASINT,
    GPSDIALOG_EMPRESAS,
    GPSDIALOG_HQORGS,
    GPSDIALOG_HQEMPREGOS,
    GPSDIALOG_TUNNINGS,
    GPSDIALOG_TERRITORIOS   
}
hook OnPlayerConnect(playerid) {
    GPS:CreateGPSIcons(playerid);
}
YCMD:gps(playerid,params[],help) {
    // TODO melhorar meenu
    ShowPlayerDialog(playerid,GPSDIALOG_INICIO,DIALOG_STYLE_LIST,"G  P  S","Geral(Los Santos)\nEmpresas\nHQ Orgs\nHQ Empregos\nTunnings\nTerritorios","Proximo","");
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid==GPSDIALOG_INICIO) {
        //TODO compeltar gps
            if(listitem==0) printf("LS");
            if(listitem==3) ShowPlayerDialog(playerid,94,DIALOG_STYLE_LIST,"G  P  S - Empregos","Advogados\nCaminhoneiros\nSeguran�as\nMotoristas de �nibus\nFazendeiros\nLixeiro LS\nAgente Penitenci�rio\nCoveiros\nCarteiros\nPizzaboys","Marcar","");
    }
}