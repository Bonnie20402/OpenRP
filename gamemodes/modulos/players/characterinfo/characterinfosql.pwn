

/*
    Hooks
            */
#include <YSI_Coding\y_hooks>
hook OnPlayerSpawn(playerid) {
    PrepareLoadPlayerCharacterInfo(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid,reason) {
    if(IsPlayerLoggedIn(playerid)) {
        PrepareSaveCharacterInfo(playerid);
    }
    return 1;

}
public PrepareCharacterInfoTable() {
    new query[255];
    mysql_format(mysql,query,255,"CREATE TABLE IF NOT EXISTS characterinfo (username VARCHAR(64) NOT NULL PRIMARY KEY,interiorid INT, skin INT,x FLOAT,y FLOAT,z FLOAT,hp FLOAT,armor FLOAT,wanted INT,money INT,virtualworld INT);");
    mysql_pquery(mysql,query);
    return 1;
}

public PrepareLoadPlayerCharacterInfo(playerid) {
    new query[255];
    mysql_format(mysql,query,255,"SELECT * FROM characterinfo WHERE username = '%s'",GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query,"FinishLoadCharacterInfo","i",playerid);
    return 1;
}

public FinishLoadCharacterInfo(playerid) {
    if(cache_num_rows()) {
        cache_get_value_index_int(0,1,gCharacterInfo[playerid][PLAYERINFO_INTERIORID]);
        cache_get_value_index_int(0,2,gCharacterInfo[playerid][PLAYERINFO_SKINID]);
        cache_get_value_index_float(0,3,gCharacterInfo[playerid][PLAYERINFO_COORDS][0]);
        cache_get_value_index_float(0,4,gCharacterInfo[playerid][PLAYERINFO_COORDS][1]);
        cache_get_value_index_float(0,5,gCharacterInfo[playerid][PLAYERINFO_COORDS][2]);
        cache_get_value_index_int(0,6,gCharacterInfo[playerid][PLAYERINFO_HP]);
        cache_get_value_index_int(0,7,gCharacterInfo[playerid][PLAYERINFO_ARMOR]);
        cache_get_value_index_int(0,8,gCharacterInfo[playerid][PLAYERINFO_WANTED]);
        cache_get_value_index_int(0,9,gCharacterInfo[playerid][PLAYERINFO_MONEY]);
        cache_get_value_index_int(0,10,gCharacterInfo[playerid][PLAYERINFO_VIRTUALWORLD]);
        OnCharacterInfoLoad(playerid);
        return 1;
    }
    //new player
    new query[255];
    new Float:x,Float:y,Float:z,Float:hp,Float:armor;
    GetPlayerHealth(playerid,hp);
    GetPlayerArmour(playerid,armor);
    GetPlayerPos(playerid,x,y,z);
    mysql_format(mysql,query,255,"INSERT INTO characterinfo (username,interiorid, skin, x, y, z, hp, armor, wanted, money, virtualworld)\
    VALUES ('%s',%d, %d, %f, %f, %f, %f, %f, %d, %d, %d)",GetPlayerNameEx(playerid),GetPlayerInterior(playerid),GetPlayerSkin(playerid),x,y,z,hp,armor,GetPlayerWantedLevel(playerid),GetPlayerMoney(playerid),GetPlayerVirtualWorld(playerid));
    print(query);
    mysql_pquery(mysql,query,"PrepareLoadCharacterInfo","i",playerid);
    return 1;
}


/*
    SaveCharacterInfo
    saves player data to the table
                            */


public PrepareSaveCharacterInfo(playerid) {
    new query[255];
    new Float:x,Float:y,Float:z,Float:hp,Float:armor;
    new skin,wanted,money,virtualworld;
    money = GetPlayerMoney(playerid);
    skin = GetPlayerSkin(playerid);
    virtualworld = GetPlayerVirtualWorld(playerid);
    wanted = GetPlayerWantedLevel(playerid);
    GetPlayerHealth(playerid,hp);
    GetPlayerArmour(playerid,armor);
    GetPlayerPos(playerid,x,y,z);
    mysql_format(mysql,query,255,"UPDATE characterinfo SET interiorid = %d, skin = %d, x = %f, y = %f, z = %f, hp = %f, armor = %f, wanted = %d, money = %d, virtualworld = %d WHERE username = '%s'",GetPlayerInterior(playerid),skin,x,y,z,hp,armor,wanted,money,virtualworld,GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query,"FinishSaveCharacterInfo","iss",playerid,GetPlayerNameEx(playerid),query);
}

public FinishSaveCharacterInfo(playerid,const username[],const query[]) {
    if(cache_affected_rows())return 1;
    else printf("[characterinfo.pwn] Error saving characteer info of %s!\nEis a query: %s",GetPlayerNameEx(playerid),query);
    return 0;
}