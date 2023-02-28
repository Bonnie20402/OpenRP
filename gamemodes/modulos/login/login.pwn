
#include <YSI_Coding/y_hooks>
#include <YSI_Server/y_colours>
#include <bcrypt>

#define MAX_PASSWORD_LENGTH 64

/*
    DIALOGS
    */
enum Login:LOGINDIALOGS {
    LOGINDIALOG_LOGIN,
    LOGINDIALOG_REGISTER,
    LOGINDIALOG_PASSWORDCONFIRM,
    LOGINDIALOG_RECOVERPASSWORD
}


/*
    VARIAVEIS
                */
new Login:gLoggedIn[MAX_PLAYERS];
new Int:BCRYPT_COST = 12;
new gLoadingID[MAX_PLAYERS];
/*
    VARIAVEIS FICHEIRO
                        */
new static LoginTitulo[64];
new static LoginMsg[256];
new static RegisterTitulo[64];
new static RegisterMsg[256];

hook OnGameModeInit() {
    print("Sistema de login ligado!");
}
hook OnPlayerConnect@000(playerid){
    TogglePlayerSpectating(playerid,true);
    PrepareAccountCheck(playerid);
}


hook OnPlayerLogin(playerid) {
    new msg[128];
    format(msg,128,"O jogador %s logou",GetPlayerNameEx(playerid));
    SendClientMessageToAll(COLOR_BISQUE,msg);
}

/*
            LÓGICA DE REIGSTRO
            com encriptação bcrypt
                                */
forward Login:PrepareRegister(playerid,const username[], const password[]);
public Login:PrepareRegister(playerid,const username[], const password[]) {
    /*
        Verificar se a senha tem entre 0 e a constante MAX_PASSWORD_LENGTH carateres.
            */
    if(strlen(password)>MAX_PASSWORD_LENGTH||strlen(password)==0) {
        SendClientMessage(playerid,COLOR_RED,"A senha deve ter entre 0 e 64 carateres.");
        ShowPlayerDialog(playerid,LOGINDIALOG_REGISTER,DIALOG_STYLE_PASSWORD,RegisterTitulo,RegisterMsg,"Registrar","");
        return 1;
    }
    printf("[Register] A preparar a criação da conta de %s[%d]",username,playerid);
    SendClientMessage(playerid,COLOR_GREEN,"A criar a tua conta...");
    bcrypt_hash(password,BCRYPT_COST,"ContinueRegister","iss",playerid,username,password);
}
forward Login:ContinueRegister(playerid,const username[],const password[]);
public Login:ContinueRegister(playerid,const username[],const password[]) {
    new query[255];
    new hashPassword[BCRYPT_HASH_LENGTH];
    bcrypt_get_hash(hashPassword);
    SendClientMessage(playerid,COLOR_GREEN,"Está quase...");
    mysql_format(mysql,query,sizeof(query),"INSERT INTO `accounts` (username, password) VALUES ('%s', '%s')",username,hashPassword);
    mysql_pquery(mysql,query,"FinishRegister","i",playerid);
}
forward Login:FinishRegister(playerid);
public Login:FinishRegister(playerid) {
    printf("A conta de %s[%d] foi criada com sucesso",GetPlayerNameEx(playerid),playerid);
    SendClientMessage(playerid,COLOR_GREEN,"A tua conta foi criada!");
    PrepareAccountCheck(playerid);
}

/*
                PrepareLogin
            LÓGICA DE LOGIN
            com encriptação bcrypt
                                */

forward Login:PrepareLogin(playerid,const rawPassword[]);
public Login:PrepareLogin(playerid,const rawPassword[]) {
    SendClientMessage(playerid,COLOR_GREEN,"A iniciar sessão...");
    new query[BCRYPT_HASH_LENGTH+128];
    mysql_format(mysql,query,sizeof(query),"SELECT password FROM accounts WHERE username='%s'",GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query,"ContinueLogin","is",playerid,rawPassword);
}
forward Login:ContinueLogin(playerid,const rawPassword[]);
public Login:ContinueLogin(playerid,const rawPassword[]) {
    new hashPassword[256];
    cache_get_value_index(0,0,hashPassword);
    bcrypt_check(rawPassword,hashPassword,"FinishLogin","i",playerid);

}
forward Login:FinishLogin(playerid);
public Login:FinishLogin(playerid) {
    if(bcrypt_is_equal()) {
        SendClientMessage(playerid,COLOR_GREEN,"Sessão iniciada!");
        gLoggedIn[playerid]=1;
        Admin:PrepareAdminCheck(GetPlayerNameEx(playerid));
        OnPlayerLogin(playerid);
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Erro - senha incorreta!");
    ShowPlayerDialog(playerid,LOGINDIALOG_LOGIN,DIALOG_STYLE_PASSWORD,LoginTitulo,LoginMsg,"Iniciar sessão","");
}
/*
                AccountCheck
    VERIFICAÇÃO DA EXISTENCIA DE CONTA NA MYSQL DB
                                                */

forward Login:PrepareAccountCheck(playerid);
public Login:PrepareAccountCheck(playerid) {
    Login:gLoggedIn[playerid]=0;
    new query[256];
    mysql_format(mysql,query,sizeof(query),"SELECT COUNT(*) FROM `accounts` WHERE username = '%s'",GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query,"FinishAccountCheck","i",playerid);
}
forward Login:FinishAccountCheck(playerid);
public Login:FinishAccountCheck(playerid) {
    new accountName[MAX_PLAYER_NAME];
    accountName=GetPlayerNameEx(playerid);
    new isRegistered;
    /*
        O output é assim
        COUNT
            valor
        Então queremos o valor na coluna 0, na linha 0,  

        OUTPUT
        (pedimos com COUNT)
        1 se a conta existir
        0 se a conta não existir
    */
    cache_get_value_index_int(0,0,isRegistered);
    if(isRegistered) {
        format(LoginTitulo,64,"Iniciar sessão");
        format(LoginMsg,256,"Bem vindo de volta, %s!\nInsere a tua palavra-passe em baixo:",GetPlayerNameEx(playerid));
        ShowPlayerDialog(playerid,LOGINDIALOG_LOGIN,DIALOG_STYLE_PASSWORD,LoginTitulo,LoginMsg,"Iniciar sessão","");
        return 1;
    }
    format(RegisterTitulo,64,"Criação de conta");
    format(RegisterMsg,256,"Parece que não és registrado no servidor\nInsere a tua senha em baixo!");
    ShowPlayerDialog(playerid,LOGINDIALOG_REGISTER,DIALOG_STYLE_PASSWORD,RegisterTitulo,RegisterMsg,"Registrar","");

}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid==LOGINDIALOG_REGISTER) {
        PrepareRegister(playerid,GetPlayerNameEx(playerid),inputtext);
    }
    if(dialogid==LOGINDIALOG_LOGIN) {
        printf("Login para %d ID %d",playerid,LOGINDIALOG_LOGIN);
        PrepareLogin(playerid,inputtext);
    }
}

/*
    Restrições
    Ao jogador antes de estar com sessão iniciada

*/

hook OnPlayerText(playerid,text[]) {
    if(!Login:gLoggedIn[playerid]) {
        SendClientMessage(playerid,COLOR_RED,"Precisas de iniciar sessão para falar no chat!");
        return 0;
    }
    return 1;
}
hook OnPlayerCommandText(playerid,cmdtext[]) {
    if(!Login:gLoggedIn[playerid]) {
        SendClientMessage(playerid,COLOR_RED,"Precisas de iniciar sessão para falar no chat!");
        return 0;
    }
    return 1;
}

/*
    GETTERS e EVENTOS, para poderem ser utilizados em Hooks.
            */

forward OnPlayerLogin(playerid);
public OnPlayerLogin(playerid) {
    PlayerSpawn:PreparePlayerSpawn(playerid);
}
forward IsPlayerLoggedIn(playerid);
public IsPlayerLoggedIn(playerid) {
    return gLoggedIn[playerid];
}