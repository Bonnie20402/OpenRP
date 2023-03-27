/*
    loading.pwn
                    */
forward ShowLoadingScreen(playerid,const message[]);
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
new Int:BCRYPT_COST = 12;
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

