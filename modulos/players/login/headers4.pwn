/*
    loading.pwn
                    */
forward ShowLoadingScreen(playerid,String:message[]);
forward AddLoadingProgress(playerid);
forward IsPlayerLoaded(playerid);
forward OnPlayerLoad(playerid);
new gLoadingTimer[MAX_PLAYERS];

/*
    loadingtxd.pwn
                */
new PlayerText:txdloadingBackground1[MAX_PLAYERS];
new PlayerText:txdloadingTitle[MAX_PLAYERS];
new PlayerText:txdloadingBackground2[MAX_PLAYERS];
new PlayerText:txdloadingMessage[MAX_PLAYERS];
new PlayerText:txdloadingVersion[MAX_PLAYERS];
new PlayerBar:txdloadingProgress[MAX_PLAYERS];


/*
    LOGIN.pwn
                */
#define MAX_PASSWORD_LENGTH 64

enum LOGINDIALOGS {
    LOGINDIALOG_LOGIN,
    LOGINDIALOG_REGISTER,
    LOGINDIALOG_PASSWORDCONFIRM,
    LOGINDIALOG_RECOVERPASSWORD
}

new gLoggedIn[MAX_PLAYERS];
new gLoginTries[MAX_PLAYERS];
new Int:BCRYPT_COST = 12;
forward PrepareAccountsTable();

forward PrepareRegister(playerid,String:username[], String:password[]);
forward ContinueRegister(playerid,String:username[],String:password[]);
forward FinishRegister(playerid);

forward PrepareLogin(playerid,String:rawPassword[]);
forward ContinueLogin(playerid,String:rawPassword[]);
forward FinishLogin(playerid);

forward PrepareAccountCheck(playerid);
forward FinishAccountCheck(playerid);

forward OnPlayerAuth(playerid);
forward IsPlayerLoggedIn(playerid);

