


#include <YSI_Coding\y_hooks>



/*
            PrepareAccountsTable
            Creates the accounts table if it doesn't exist
                                */

public PrepareAccountsTable() {
    new accountsTable[128];
	mysql_format(mysql,accountsTable,128,"CREATE TABLE IF NOT EXISTS ACCOUNTS (account_id INT(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,username VARCHAR(32),password VARCHAR(256))");
	mysql_query(mysql,accountsTable,false);
}
/*
    PrepareRegister
    Attempts to register a player, encrypting their password.
                                */
public PrepareRegister(playerid,const username[], const password[]) {
    /*
        Verificar se a senha tem entre 0 e a constante MAX_PASSWORD_LENGTH carateres.
            */
    if(strlen(password)>MAX_PASSWORD_LENGTH||strlen(password)==0) {
        SendClientMessage(playerid,COLOR_RED,"A senha deve ter entre 0 e 64 carateres.");
        ShowPlayerDialog(playerid,LOGINDIALOG_REGISTER,DIALOG_STYLE_PASSWORD,dRegisterTitle,dRegisterMsg,"Registrar","");
        return 1;
    }
    printf("[Register] A preparar a criação da conta de %s[%d]",username,playerid);
    SendClientMessage(playerid,COLOR_GREEN,"A criar a tua conta...");
    bcrypt_hash(password,BCRYPT_COST,"ContinueRegister","iss",playerid,username,password);
}

public ContinueRegister(playerid,const username[],const password[]) {
    new query[255];
    new hashPassword[BCRYPT_HASH_LENGTH];
    bcrypt_get_hash(hashPassword);
    SendClientMessage(playerid,COLOR_GREEN,"Está quase...");
    mysql_format(mysql,query,sizeof(query),"INSERT INTO `accounts` (username, password) VALUES ('%s', '%s')",username,hashPassword);
    print(query);
    mysql_pquery(mysql,query,"FinishRegister","i",playerid);
}

public FinishRegister(playerid) {
    printf("A conta de %s[%d] foi criada com sucesso",GetPlayerNameEx(playerid),playerid);
    SendClientMessage(playerid,COLOR_GREEN,"A tua conta foi criada!");
    PrepareAccountCheck(playerid);
}

/*
                PrepareLogin
                Validades login password.
                Calls OnPlayerAuth() if succeds.
                                */


public PrepareLogin(playerid,const rawPassword[]) {
    SendClientMessage(playerid,COLOR_GREEN,"A iniciar sessão...");
    new query[BCRYPT_HASH_LENGTH+128];
    mysql_format(mysql,query,sizeof(query),"SELECT password FROM accounts WHERE username='%s'",GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query,"ContinueLogin","is",playerid,rawPassword);
}

public ContinueLogin(playerid,const rawPassword[]) {
    new hashPassword[256];
    cache_get_value_index(0,0,hashPassword);
    bcrypt_check(rawPassword,hashPassword,"FinishLogin","i",playerid);

}

public FinishLogin(playerid) {
    if(bcrypt_is_equal()) {
        SendClientMessage(playerid,COLOR_GREEN,"Sessão iniciada!");
        gLoggedIn[playerid]=1;
        PrepareAdminCheck(GetPlayerNameEx(playerid));
        OnPlayerAuth(playerid);
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Erro - senha incorreta!");
    ShowPlayerDialog(playerid,LOGINDIALOG_LOGIN,DIALOG_STYLE_PASSWORD,dLoginTitle,dLoginMsg,"Iniciar sessão","");
}
/*
                AccountCheck
    Checks if the given playerid's name has an account
                                                */


public PrepareAccountCheck(playerid) {
    gLoggedIn[playerid]=0;
    new query[256];
    mysql_format(mysql,query,sizeof(query),"SELECT COUNT(*) FROM `accounts` WHERE username = '%s'",GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query,"FinishAccountCheck","i",playerid);
}

public FinishAccountCheck(playerid) {
    new accountName[MAX_PLAYER_NAME];
    accountName=GetPlayerNameEx(playerid);
    new isRegistered;
    cache_get_value_index_int(0,0,isRegistered);
    if(isRegistered) {
        format(dLoginTitle,64,"Iniciar sessão");
        format(dLoginMsg,256,"{FFFFFF}Bem vindo de volta, %s!\
        \nInsere a tua palavra-passe em baixo:",GetPlayerNameEx(playerid));
        ShowPlayerDialog(playerid,LOGINDIALOG_LOGIN,DIALOG_STYLE_PASSWORD,dLoginTitle,dLoginMsg,"Iniciar sessão","");
        return 1;
    }
    format(dRegisterTitle,64,"Criação de conta");
    format(dRegisterMsg,256,"{ffffff}Parece que não és registrado!\
    \nDesde já, damos-te as nossas boas-vindas\
    \nInsere a tua senha em baixo!");
    ShowPlayerDialog(playerid,LOGINDIALOG_REGISTER,DIALOG_STYLE_PASSWORD,dRegisterTitle,dRegisterMsg,"Registrar","");
    return 1;

}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid==LOGINDIALOG_REGISTER) {
        PrepareRegister(playerid,GetPlayerNameEx(playerid),inputtext);
    }
    if(dialogid==LOGINDIALOG_LOGIN) {
        PrepareLogin(playerid,inputtext);
    }
    return 1;
}




//Prevent player from chatting before logged in
hook OnPlayerText(playerid,text[]) {
    if(!IsPlayerLoggedIn(playerid)) {
        SendClientMessage(playerid,COLOR_RED,"Precisas de iniciar sessão para falar no chat!");
        return 0;
    }
    return 1;
}
//Set player logged in to false when they leave MOVED   
hook OnPlayerDisconnect(playerid,reason) {
    /*
        Moved to roleplay.pwn to make sure all hooks on OnPlayerDisconnect that needs
        the player to be logged in (e.g saving playerinfo) work propely

    gLoggedIn[playerid]=0;
                                */
    return 1;
}

/*
    Events
            */

public OnPlayerAuth(playerid) {
    PlayerTextDrawHide(playerid,txdloadingBackground1[playerid]);
    PlayerTextDrawHide(playerid,txdloadingBackground2[playerid]);
    PlayerTextDrawHide(playerid,txdloadingVersion[playerid]);
    PlayerTextDrawHide(playerid,txdloadingTitle[playerid]);
    PreparePlayerSpawn(playerid);
    PrepareLoadPlayerBankAccount(playerid);
    return 1;
}
/*
    IsPlayerLoggedIn
    Returns true if player is logged in, otherwhise false
                                                        */

public IsPlayerLoggedIn(playerid) {
    return gLoggedIn[playerid];
} 