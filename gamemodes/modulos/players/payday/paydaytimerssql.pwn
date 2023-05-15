


forward PaydaySQL:PreparePlayerPaydayTimerTable();
public PaydaySQL:PreparePlayerPaydayTimerTable() {
    new query[255];
    mysql_format(mysql,query,255,"CREATE TABLE IF NOT EXISTS paydaytimer (\
    username varchar(64) PRIMARY KEY,\
    hours INT NOT NULL,\
    minutes INT NOT NULL,\
    seconds INT NOT NULL);");
    mysql_pquery(mysql,query);
    return 1;
}
forward PaydaySQL:PrepareLoadPlayerPaydayTimer(playerid);
public PaydaySQL:PrepareLoadPlayerPaydayTimer(playerid) {
    new query[255];
    inline LoadPlayerPaydayTimer() {
        //if its new player
        if(!cache_num_rows()) {
            mysql_format(mysql,query,255,"INSERT INTO paydaytimer VALUES ('%s',%d,%d,%d)",GetPlayerNameEx(playerid),PAYDAYDEFAULT_H,PAYDAYDEFAULT_M,PAYDAYDEFAULT_S);
            mysql_pquery(mysql,query,"PrepareLoadPlayerPaydayTimer","i",playerid);
        }
        else {
            //activate the timer
            ResetPlayerPaydayTimer(playerid);
            //pass values to ram
            cache_get_value_index_int(0,1,gPaydayTimer[playerid][PAYDAYTIMER_H]);
            cache_get_value_index_int(0,2,gPaydayTimer[playerid][PAYDAYTIMER_M]);
            cache_get_value_index_int(0,3,gPaydayTimer[playerid][PAYDAYTIMER_S]);

            //change tablist score
            SetPlayerScore(playerid,GetPlayerLevel(playerid));
        }
    }
    mysql_format(mysql,query,255,"SELECT * FROM paydaytimer WHERE username = '%s'",GetPlayerNameEx(playerid));
    MySQL_PQueryInline(mysql,using inline LoadPlayerPaydayTimer,query);
    return 1;
}

forward PaydaySQL:PrepareSavePlayerPaydayTimer(playerid);
public PaydaySQL:PrepareSavePlayerPaydayTimer(playerid) {
    new query[255];
    mysql_format(mysql,query,255,"UPDATE paydaytimer SET hours = %d, minutes = %d, seconds = %d WHERE username = '%s'",\
    gPaydayTimer[playerid][PAYDAYTIMER_H],gPaydayTimer[playerid][PAYDAYTIMER_M],gPaydayTimer[playerid][PAYDAYTIMER_S],\
    GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query);
    return 1;
}