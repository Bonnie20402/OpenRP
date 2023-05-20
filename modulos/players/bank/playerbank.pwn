#include "modulos\players\bank\bankatm.pwn"
#include "modulos\players\bank\playerbankdialog.pwn"
#include <YSI_Coding\y_hooks>

hook OnScriptInit() {
    for(new i=0;i<MAX_PLAYERS;i++) {
        gBankAccount[i]=-1;
    }
    return 1;
}
hook OnPlayerDisconnect(playerid,reason) {
    if(IsPlayerLoggedIn(playerid))PrepareSavePlayerBankAccount(playerid);
    return 1;
}
/*
    Player bank accounts
                        */



public PreparePlayerBankAccountsTable() {
    new query[255];
    mysql_format(mysql,query,255,"CREATE TABLE IF NOT EXISTS bank (username VARCHAR(64) PRIMARY KEY,money INT DEFAULT 0)");
    mysql_query(mysql,query,false);
    return 1;
}


public PrepareLoadPlayerBankAccount(playerid) {
    new query[255];
    mysql_format(mysql,query,255,"SELECT money FROM bank WHERE username = '%s'",GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query,"FinishLoadPlayerBankAccount","i",playerid);
    return 1;
}


public FinishLoadPlayerBankAccount(playerid) {
    if(cache_num_rows()) {
        cache_get_value_index_int(0,0,gBankAccount[playerid]);
        printf("[playerbank.pwn] The account of %s[%d] has been loaded %d$.",GetPlayerNameEx(playerid),playerid,gBankAccount[playerid]);
        return 1;
    }
    printf("[playerbank.pwn] The account of %s[%d] has been created.",GetPlayerNameEx(playerid),playerid);
    new query[255];
    mysql_format(mysql,query,255,"INSERT INTO bank(username,money) VALUES ('%s', %d)",GetPlayerNameEx(playerid),0);
    mysql_pquery(mysql,query,"PrepareLoadPlayerAccount","i",playerid);
    return 1;
}


public PrepareSavePlayerBankAccount(playerid) {
    new query[255];
    mysql_format(mysql,query,255,"UPDATE bank SET money = %d WHERE username = '%s'",gBankAccount[playerid],GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query,"FinishSavePlayerBankAccount","is",playerid,GetPlayerNameEx(playerid));
    return 1;
}

public FinishSavePlayerankAccount(playerid,const username[]) {
    printf("[playerbank.pwn] The account of %s[%d] has been saved!",username,playerid);
    gBankAccount[playerid]=-1;
    return 1;
}


public IsPlayerBankAccountLoaded(playerid) {
    if(gBankAccount[playerid]==-1)return 0;
    return 1;
}



public GetPlayerBankAccount(playerid) {
    return gBankAccount[playerid];
}


// Sets player bank account money. Saves to MYSQL.
public SetPlayerBankAccountMoney(playerid,money) {
    gBankAccount[playerid]=money;
    PrepareSavePlayerBankAccount(playerid);
    return 1;
}


