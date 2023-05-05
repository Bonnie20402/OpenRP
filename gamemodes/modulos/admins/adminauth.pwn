/*

        AdminAuth
    Reaiza a autenticação de admins
                            */
#include <YSI_Coding\y_hooks>

#define ADMINLOGINDIALOG 5005



hook OnPlayerCommandText(playerid) {
    if(GetStaffLevel(playerid)&&!gAdmins[playerid][ADMININFO_AUTH]) {
        SendClientMessage(playerid,COLOR_ORANGE,"Não podes executar comandos até te autenticares");
        return 0;
    }
    return 1;
}

stock PrepareAdminAuth(playerid) {
    new String:dMessage[128];
    format(dMessage,128,"Bem-vindo, %s\n\
    Parece que és um administrador nivel %d\n\
    Por favor, insere a senha da staff em baixo",GetPlayerNameEx(playerid),gAdmins[playerid][ADMININFO_LEVEL]);
    if(!gAdmins[playerid][ADMININFO_AUTH]) {
        ShowPlayerDialog(playerid,ADMINLOGINDIALOG,DIALOG_STYLE_PASSWORD,"Autenticação Staff",dMessage,"Autenticar","");
    }
    else SendClientMessage(playerid,COLOR_ORANGE,"[Staff Login] - Já estás autenticado!");
    return 1;
}
#include <YSI_Coding\y_hooks>
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    new String:aviso[255];
    if(dialogid==ADMINLOGINDIALOG) {
        new String:adminpassword[256];
        format(adminpassword,256,"coxinha123");
        if(!strcmp(inputtext,adminpassword)) {
            gAdmins[playerid][ADMININFO_AUTH]=1;
            format(aviso,255,"O admin %s entrou!",GetPlayerNameEx(playerid));
            SendStaffMessage(-1,aviso);
            return 1;
            }
        else {
            ShowPlayerDialog(playerid,ADMINLOGINDIALOG,DIALOG_STYLE_PASSWORD,"Senha incorreta","Tenta outra vez","Autenticar","");
            format(aviso,255,"O admin %s errou a senha da staff!",GetPlayerNameEx(playerid));
            SendStaffMessage(-1,aviso);
        }
    }
        return 1;
}

hook OnPlayerDisconnect(playerid,reason) {
    gAdmins[playerid][ADMININFO_AUTH]=0;
    return 1;
}