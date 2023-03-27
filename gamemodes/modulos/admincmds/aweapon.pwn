YCMD:aweapon(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=5000) {
        SetPlayerHealth(playerid,100.0);
        SetPlayerArmour(playerid,100.0);
        GivePlayerWeapon(playerid,WEAPON_DEAGLE,30);
    }
    else SendClientMessage(playerid,COLOR_RED,"Não és Programador!");
    return 1;
}