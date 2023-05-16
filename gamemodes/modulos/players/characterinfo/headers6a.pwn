/*
    characterinfo.pwn
                    */
enum PLAYERINFO {
    Int:PLAYERINFO_SKINID,
    Float:PLAYERINFO_COORDS[3],
    Int:PLAYERINFO_HP,
    Int:PLAYERINFO_ARMOR,
    Int:PLAYERINFO_WANTED,
    Int:PLAYERINFO_MONEY,
    Int:PLAYERINFO_INTERIORID,
    Int:PLAYERINFO_VIRTUALWORLD
}

new gCharacterInfo[MAX_PLAYERS][PLAYERINFO];
forward PrepareCharacterInfoTable();
forward PrepareLoadPlayerCharacterInfo(playerid);
forward FinishLoadCharacterInfo(playerid);

forward InsertCharacterInfo(playerid);

forward PrepareSaveCharacterInfo(playerid);
forward FinishSaveCharacterInfo(playerid,const username[],const query[]);