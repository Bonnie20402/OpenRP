

/*
    playerlevel.pwn
                        */
#define INVALID_LEVEL 0
enum PLAYERLEVEL {
    PLAYERLEVEL_LEVEL,
    PLAYERLEVEL_RESPECT,
    PLAYERLEVEL_HOURS
}

new gPlayerLevel[MAX_PLAYERS][PLAYERLEVEL];

forward PaydaySQL:PreparePlayerLevelTable();
forward PaydaySQL:PrepareLoadPlayerLevel(playerid);
forward DeletePlayerLevel(playerid);

/*
    paydaytimers.pwn
                    */
#define PAYDAYDEFAULT_H 0
#define PAYDAYDEFAULT_M 5
#define PAYDAYDEFAULT_S 0
#define PAYDAYDEFAULT_PAYCHECK_MAX 1500
enum PAYDAYTIMER {
    PAYDAYTIMER_ACTIVE,
    PAYDAYTIMER_H,
    PAYDAYTIMER_M,
    PAYDAYTIMER_S
}

new gPaydayTimer[MAX_PLAYERS][PAYDAYTIMER];
