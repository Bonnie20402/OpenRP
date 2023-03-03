/*
    LOGIN.pwn
                */
forward PrepareAccountsTable();

forward PrepareRegister(playerid,const username[], const password[]);
forward ContinueRegister(playerid,const username[],const password[]);
forward FinishRegister(playerid);

forward PrepareLogin(playerid,const rawPassword[]);
forward ContinueLogin(playerid,const rawPassword[]);
forward FinishLogin(playerid);

forward PrepareAccountCheck(playerid);
forward FinishAccountCheck(playerid);

forward OnPlayerAuth(playerid);
forward IsPlayerLoggedIn(playerid);

/*
    loading.pwn
                    */
forward ShowLoadingScreen(playerid,const message[]);
forward AddLoadingProgress(playerid);

forward IsPlayerLoaded(playerid);
forward OnPlayerLoad(playerid);