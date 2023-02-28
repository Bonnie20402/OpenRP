

YCMD:ac(playerid,params[],help) {
    if(GetStaffLevel(playerid)) SendStaffMessage(playerid,params);
    else SendCleintMessage(playerid,COLOR_RED,"Não pertences á staff!");
    return 1;
}