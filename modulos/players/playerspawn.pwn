/*
    DEPRECATED
    Prepare player spawn
    Description: After logged in, it prepares the players initial spawn
*/

#include <YSI_Coding\y_hooks>

/*
    LOCALIZAÇÕES
                */
new Float:LOC_SpawnCivil[3] = {1154.1556,-1768.5778,16.5938}; // temporario

public PreparePlayerSpawn(playerid) {
    TogglePlayerSpectating(playerid,false);
    SetPlayerTxdbNotifText(playerid,"Open RP\nBem-vindo!",10);
    ShowPlayerTxdbNotification(playerid);
    return 1;
}
hook OnPlayerRequestClass(playerid,classid) {
    SetSpawnInfo(playerid,0,0,LOC_SpawnCivil[0],LOC_SpawnCivil[1],LOC_SpawnCivil[2],90,0,0,0,0,0,0);
}