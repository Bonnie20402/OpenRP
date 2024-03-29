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
    Int:PLAYERINFO_VIRTUALWORLD,
    Int:PLAYERINFO_GENDER
}

new gCharacterInfo[MAX_PLAYERS][PLAYERINFO];
forward PrepareCharacterInfoTable();
forward PrepareLoadPlayerCharacterInfo(playerid);
forward FinishLoadCharacterInfo(playerid);

forward InsertCharacterInfo(playerid);

forward PrepareSaveCharacterInfo(playerid);
forward FinishSaveCharacterInfo(playerid,String:username[],String:query[]);