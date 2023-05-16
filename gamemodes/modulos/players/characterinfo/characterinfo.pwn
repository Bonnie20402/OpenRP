
#include "modulos\players\characterinfo\characterinfosql.pwn"
stock OnCharacterInfoLoad(playerid) {
    SetPlayerHealth(playerid,gCharacterInfo[playerid][PLAYERINFO_HP]);
    SetPlayerSkin(playerid,gCharacterInfo[playerid][PLAYERINFO_SKINID]);
    SetPlayerArmour(playerid,gCharacterInfo[playerid][PLAYERINFO_ARMOR]);
    GivePlayerMoney(playerid,gCharacterInfo[playerid][PLAYERINFO_MONEY]);
    SetPlayerInterior(playerid,gCharacterInfo[playerid][PLAYERINFO_INTERIORID]);
    SetPlayerVirtualWorld(playerid,gCharacterInfo[playerid][PLAYERINFO_VIRTUALWORLD]);
    SetPlayerWantedLevel(playerid,gCharacterInfo[playerid][PLAYERINFO_WANTED]);
    return 1;
}