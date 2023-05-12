
#include "modulos\players\payday\paydaysql.pwn"
#include "modulos\players\payday\paydaytimers.pwn"


/*
    Payday system module - SQL table
    Keeps track of how many hours players have been playing on the server, how much respect they have and
    their level which is done by a formula and adds a hourly compensation for the playing players
    Uses YSI inline sql functions  (it's so fucking time-saving I love you whoever made YSI!)
                   
                                                                                 */
                                                    

stock Payday:IsPlayerLevelLoaded(playerid) {
    if(IsPlayerLoggedIn(playerid)&&!gPlayerLevel[playerid])return 0;
    return 1;
}

/* Returns the required respect to go to next level, by passing the current level.
 The formula for the required respect R, for the current level l is as follows:
    R(l) = 12l;
*/
stock Payday:CalculateRequiredLevelRespect(level) {
    return 12*level;
}

/* Returns the required playtime, in hours, to go to next level, by passing the current level.
 The formula for the required playtime P, for the current level l is as follows:
    P(l) = 3l;
*/
stock Payday:CalculateRequiredLevelHours(level) {
    return 3*level;
}

stock Payday:GetPlayerLevel(playerid) {
    if(!IsPlayerLoggedIn(playerid))return INVALID_LEVEL;
    return gPlayerLevel[playerid][PLAYERLEVEL_LEVEL];
}

stock Payday:GetPlayerLevelRespect(playerid) {
    return gPlayerLevel[playerid][PLAYERLEVEL_RESPECT];
}
stock Payday:GetPlayerLevelHours(playerid) {
    return gPlayerLevel[playerid][PLAYERLEVEL_HOURS];
}