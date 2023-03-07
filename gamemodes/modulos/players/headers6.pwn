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
forward PreparePlayerInfoTable();
forward PrepareLoadPlayerInfo(playerid);
forward FinishLoadPlayerInfo(playerid);

forward InsertPlayerInfo(playerid);

forward PrepareSavePlayerInfo(playerid);
forward FinishSavePlayerInfo(playerid,const username[],const query[]);
/*
    playerspawn.pwn
                    */
forward PreparePlayerSpawn(playerid);

/*
    playerbank.pwn
                    */
new gBankAccount[MAX_PLAYERS];

forward PreparePlayerBankAccountsTable();
forward PrepareLoadPlayerBankAccount(playerid);
forward FinishLoadPlayerBankAccount(playerid);
forward PrepareSavePlayerBankAccount(playerid);
forward FinishSavePlayerankAccount(playerid,const username[]);
forward PrepareLoadPlayerBankAccount(playerid);

forward IsPlayerBankAccountLoaded(playerid);
forward GetPlayerBankAccount(playerid);