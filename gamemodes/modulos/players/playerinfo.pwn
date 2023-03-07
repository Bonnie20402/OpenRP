
/*
    Hooks
            */
#include <YSI_Coding\y_hooks>
hook OnPlayerSpawn(playerid) {
    PrepareLoadPlayerInfo(playerid);
}

hook OnPlayerDisconnect(playerid,reason) {
    if(IsPlayerLoggedIn(playerid)) {
        PrepareSavePlayerInfo(playerid);
    }
    return 1;

}
public PreparePlayerInfoTable() {
    new query[255];
    mysql_format(mysql,query,255,"CREATE TABLE IF NOT EXISTS playerinfo (username VARCHAR(64) NOT NULL PRIMARY KEY,interiorid INT, skin INT,x FLOAT,y FLOAT,z FLOAT,hp FLOAT,armor FLOAT,wanted INT,money INT);");
    mysql_query(mysql,query,false);
}
/*
    load player info
    Loads player's db info to their enum in ram
    also creates player's data row if it doesn't exist
    TODO: RESTORE PLAYER STUFF USING THEIR VALUES IN TABLE
                    */
public PrepareLoadPlayerInfo(playerid) {
    new query[255];
    mysql_format(mysql,query,255,"SELECT * FROM playerinfo WHERE username = '%s'",GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query,"FinishLoadPlayerInfo","i",playerid);
}

public FinishLoadPlayerInfo(playerid) {
    new hasInfo;
    cache_get_row_count(hasInfo);
    if(hasInfo) {
        cache_get_value_index_int(0,1,gPlayerInfo[playerid][PLAYERINFO_ARMOR]);
        cache_get_value_index_float(0,2,gPlayerInfo[playerid][PLAYERINFO_COORDS][0]);
        cache_get_value_index_float(0,3,gPlayerInfo[playerid][PLAYERINFO_COORDS][1]);
        cache_get_value_index_float(0,4,gPlayerInfo[playerid][PLAYERINFO_COORDS][2]);
        cache_get_value_index_int(0,5,gPlayerInfo[playerid][PLAYERINFO_HP]);
        cache_get_value_index_int(0,6,gPlayerInfo[playerid][PLAYERINFO_ARMOR]);
        cache_get_value_index_int(0,7,gPlayerInfo[playerid][PLAYERINFO_WANTED]);
        cache_get_value_index_int(0,8,gPlayerInfo[playerid][PLAYERINFO_MONEY]);
        ShowPlayerScreenMessage(playerid,2000,"Os teus dados foram carregados!");
        return 1;
    }
    new query[255];
    new Float:x,Float:y,Float:z,Float:hp,Float:armor;
    GetPlayerHealth(playerid,hp);
    GetPlayerArmour(playerid,armor);
    GetPlayerPos(playerid,x,y,z);
    mysql_format(mysql,query,255,"INSERT INTO playerinfo (username,interiorid, skin, x, y, z, hp, armor, wanted, money)\
    VALUES ('%s',%d, %d, %f, %f, %f, %f, %f, %d, %d)",GetPlayerNameEx(playerid),GetPlayerInterior(playerid),GetPlayerSkin(playerid),x,y,z,hp,armor,GetPlayerWantedLevel(playerid),GetPlayerMoney(playerid));
    mysql_pquery(mysql,query,"InsertPlayerInfo","i",playerid);
    return 1;
}

public InsertPlayerInfo(playerid) {
    printf("[playerinfo.pwn] Dados novos do jogador %s[%d] registados!",GetPlayerNameEx(playerid),playerid);
}

/*
    SavePlayerInfo
    saves player data to the table
                            */


public PrepareSavePlayerInfo(playerid) {
    new query[255];
    new Float:x,Float:y,Float:z,Float:hp,Float:armor;
    new skin,wanted,money;
    money = GetPlayerMoney(playerid);
    skin = GetPlayerSkin(playerid);
    wanted = GetPlayerWantedLevel(playerid);
    GetPlayerHealth(playerid,hp);
    GetPlayerArmour(playerid,armor);
    GetPlayerPos(playerid,x,y,z);
    mysql_format(mysql,query,255,"UPDATE playerinfo SET interiorid = %d, skin = %d, x = %f, y = %f, z = %f, hp = %f, armor = %f, wanted = %d, money = %d WHERE username = '%s'",GetPlayerInterior(playerid),skin,x,y,z,hp,armor,wanted,money,GetPlayerNameEx(playerid));
    print(query);
    mysql_pquery(mysql,query,"FinishSavePlayerInfo","iss",playerid,GetPlayerNameEx(playerid),query);
}

public FinishSavePlayerInfo(playerid,const username[],const query[]) {
    if(cache_affected_rows())return 1;
    else printf("[playerinfo.pwn] Erro ao salvar os dados de %s!\nEis a query: %s",GetPlayerNameEx(playerid),query);
    return 0;
}