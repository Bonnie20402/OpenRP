/*
    bankatm.pwn
                */
enum ATMINFO {
    Int:ATMINFO_ROWID,
    Int:ATMINFO_OBJECTID,
    Float:ATMINFO_COORDS[3],
    Text3D:ATMINFO_TEXT
}
new gBankAtm[MAX_OBJECTS][ATMINFO];

forward PrepareBankAtmTable();
forward PrepareLoadBankAtm();
forward FinishLoadBankAtm();
forward PrepareAddBankAtm(Float:x,Float:y,Float:z,Float:rX,Float:rY,Float:rZ);
forward FinishAddBankAtm();
forward PrepareRemoveBankAtm(rowid);

forward FinishRemoveBankAtm(rowid);

forward IsValidBankAtm(objectid);
forward GetBankAtmCoordsPointers(objectid,&Float:x,&Float:y,&Float:z);

/*
        playerbank.pwn
                        */
forward PreparePlayerBankAccountsTable();
forward PrepareLoadPlayerBankAccount(playerid);
forward FinishLoadPlayerBankAccount(playerid);
forward PrepareSavePlayerBankAccount(playerid);
forward FinishSavePlayerankAccount(playerid,const username[]);

forward IsPlayerBankAccountLoaded(playerid);
forward GetPlayerBankAccount(playerid);
