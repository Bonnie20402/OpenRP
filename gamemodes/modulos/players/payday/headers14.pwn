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
    payday.pwn
                */
