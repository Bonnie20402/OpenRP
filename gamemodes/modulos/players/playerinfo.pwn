

enum PLAYERINFO {
    Int:PLAYERINFO_SKIN,
    Float:PLAYERINFO_COORDS[3],

    Int:PLAYERINFO_HP,
    Int:PLAYERINFO_ARMOR,
    Int:PLAYERINFO_WANTED,
    Int:PLAYERINFO_MONEY,

    //Weapons
}


new gPlayerInfo[MAX_PLAYERS][PLAYERINFO];
/*
    Hooks
            */
#include <YSI_Coding\y_hooks>
hook dbInit() {
    new query[255];
    mysql_format(mysql,query,255,"CREATE TABLE IF NOT EXISTS playerinfo (username VARCHAR(64) NOT NULL PRIMARY KEY,skin INT,x DECIMAL(10, 8),y DECIMAL(10, 8),z DECIMAL(10, 8),hp DECIMAL(10, 8),armor DECIMAL(10, 8),wanted INT,money INT);");
    mysql_query(mysql,query,false);
}
hook OnPlayerAuth(playerid) {
    SendClientMessage(playerid,COLOR_AQUA,"A carregar os teus dados...");
    PrepareLoadPlayerInfo(playerid);
    return 1;
}                  
hook OnPlayerDisconnect(playerid,reason) {
    PrepareSavePlayerInfo(playerid);
    return 1;
}
/*
    load player info
    Loads player's db info to their enum in ram
    also creates player's data row if it doesn't exist
    TODO: RESTORE PLAYER STUFF USING THEIR VALUES IN TABLE
                    */
stock PrepareLoadPlayerInfo(playerid) {
    new query[255];
    mysql_format(mysql,query,255,"SELECT * FROM playerinfo WHERE username = '%s'",GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query,"FinishLoadPlayerInfo","i",playerid);
}
forward FinishLoadPlayerInfo(playerid);
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
    mysql_format(mysql,query,255,"INSERT INTO playerinfo (username, skin, x, y, z, hp, armor, wanted, money)\
    VALUES ('%s', %d, %f, %f, %f, %f, %f, %d, %d)",GetPlayerNameEx(playerid),GetPlayerSkin(playerid),x,y,z,hp,armor,GetPlayerWantedLevel(playerid),GetPlayerMoney(playerid));
    mysql_pquery(mysql,query,"InsertPlayerInfo","i",playerid);
    return 1;
}
forward InsertPlayerInfo(playerid);
public InsertPlayerInfo(playerid) {
    printf("Dados novos do jogador %s[%d] registados!",GetPlayerNameEx(playerid),playerid);
}

/*
    SavePlayerInfo
    saves player data to the table
                            */

forward PrepareSavePlayerInfo(playerid);
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
    mysql_format(mysql,query,255,"UPDATE playerinfo SET skin = %d, x = %f, y = %f, z = %f, hp = %f, armor = %f, wanted = %d, money = %d WHERE username = '%s'",skin,x,y,z,hp,armor,wanted,money,GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query,"FinishSavePlayerInfo","is",playerid,GetPlayerNameEx(playerid));
}
forward FinishSavePlayerInfo(playerid,const username[]);
public FinishSavePlayerInfo(playerid,const username[]) {
    if(cache_affected_rows()) printf("Os dados de %s foram salvos!",username);
    else printf("Erro ao salvar os dados de %s!",GetPlayerNameEx(playerid));
}