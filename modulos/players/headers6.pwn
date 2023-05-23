
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
forward FinishSavePlayerankAccount(playerid,String:username[]);
forward PrepareLoadPlayerBankAccount(playerid);

forward IsPlayerBankAccountLoaded(playerid);
forward GetPlayerBankAccount(playerid);