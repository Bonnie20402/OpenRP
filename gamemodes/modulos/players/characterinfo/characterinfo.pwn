
#include "modulos\players\characterinfo\characterinfosql.pwn"
stock OnCharacterInfoLoad(playerid) {
    //SetPlayerHealth(playerid,gCharacterInfo[playerid][PLAYERINFO_HP]);
    SetPlayerSkin(playerid,gCharacterInfo[playerid][PLAYERINFO_SKINID]);
    SetPlayerArmour(playerid,gCharacterInfo[playerid][PLAYERINFO_ARMOR]);
    GivePlayerMoney(playerid,gCharacterInfo[playerid][PLAYERINFO_MONEY]);
    SetPlayerWantedLevel(playerid,gCharacterInfo[playerid][PLAYERINFO_WANTED]);
    //SetPlayerInterior(playerid,gCharacterInfo[playerid][PLAYERINFO_INTERIORID]);
    //SetPlayerVirtualWorld(playerid,gCharacterInfo[playerid][PLAYERINFO_VIRTUALWORLD]);
    //SetPlayerPos(playerid,gCharacterInfo[playerid][PLAYERINFO_COORDS][0],gCharacterInfo[playerid][PLAYERINFO_COORDS][1],gCharacterInfo[playerid][PLAYERINFO_COORDS][2]);
    return 1;
}

/*
    Returns the player's gender 
    */
stock GetPlayerGender(playerid) {
    return gCharacterInfo[playerid][PLAYERINFO_GENDER];
}