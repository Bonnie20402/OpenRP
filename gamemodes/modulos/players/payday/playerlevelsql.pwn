
#include <YSI_Coding\y_hooks>


public PaydaySQL:PreparePlayerLevelTable() {
    new query[255];
    format(query,255,"CREATE TABLE IF NOT EXISTS playerlevel (\
    username varchar(64) PRIMARY KEY,\
    level INT NOT NULL,\
    respect INT NOT NULL,\
    hours INT NOT NULL)");
    mysql_pquery(mysql,query);
    
    return 1;
}

public PaydaySQL:PrepareLoadPlayerLevel(playerid) {
    if(!IsPlayerLoggedIn(playerid))return 1;
    new query[255];
    inline LoadPlayerLevel() {
        //If it's a new player
        if(!cache_num_rows()) {
            // username,leve,respect,hours
            mysql_format(mysql,query,255,"INSERT INTO playerlevel VALUES ('%s',%d,%d,%d)",GetPlayerNameEx(playerid),1,0,0);
            mysql_pquery(mysql,query,"PrepareLoadPlayerLevel","i",playerid);
            printf("[paydaysql.pwn] Creating level for %s....",GetPlayerNameEx(playerid));
            return 1;
        }
        else {
            cache_get_value_index_int(0,1,gPlayerLevel[playerid][PLAYERLEVEL_LEVEL]);
            cache_get_value_index_int(0,2,gPlayerLevel[playerid][PLAYERLEVEL_RESPECT]);
            cache_get_value_index_int(0,3,gPlayerLevel[playerid][PLAYERLEVEL_HOURS]);
            printf("[paydaysql.pwn] The level data of %s has been loaded",GetPlayerNameEx(playerid));
        }
    }
    printf("[paydaysql.pwn] Now loading level of %s...",GetPlayerNameEx(playerid));
    mysql_format(mysql,query,255,"SELECT * FROM playerlevel WHERE USERNAME = '%s'",GetPlayerNameEx(playerid));
    MySQL_PQueryInline(mysql,using inline LoadPlayerLevel,query);
    return 1;
}

public PaydaySQL:PrepareSavePlayerLevel(playerid) {
    inline SavePlayerLevel() {
        if(!cache_num_rows())printf("[paydaysql.pwn] WARN - no rows have been affected whole saving the level of %s[%d]",GetPlayerNameEx(playerid),playerid);
        else printf("[paydaysql.pwn] Saved the level of %s[%d]",GetPlayerNameEx(playerid),playerid);
        return 1;
    }
    new query[255];
    mysql_format(mysql,query,255,"UPDATE playerlevel SET level = %d, hours = %d, respect = %d WHERE username = '%s'",\
    gPlayerLevel[playerid][PLAYERLEVEL_LEVEL],gPlayerLevel[playerid][PLAYERLEVEL_HOURS],gPlayerLevel[playerid][PLAYERLEVEL_RESPECT],GetPlayerNameEx(playerid));
    MySQL_PQueryInline(mysql,using inline SavePlayerLevel,query);
    return 1;
}


