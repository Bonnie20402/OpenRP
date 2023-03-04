/*
    playerinfo.pwn
                    */
enum PLAYERINFO {
    Int:PLAYERINFO_SKIN,
    Float:PLAYERINFO_COORDS[3],

    Int:PLAYERINFO_HP,
    Int:PLAYERINFO_ARMOR,
    Int:PLAYERINFO_WANTED,
    Int:PLAYERINFO_MONEY
}

new gPlayerInfo[MAX_PLAYERS][PLAYERINFO];

forward PrepareLoadPlayerInfo(playerid);
forward FinishLoadPlayerInfo(playerid);

forward InsertPlayerInfo(playerid);

forward PrepareSavePlayerInfo(playerid);
forward FinishSavePlayerInfo(playerid,const username[]);
/*
    playerspawn.pwn
                    */
forward PreparePlayerSpawn(playerid);