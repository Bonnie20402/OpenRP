

YCMD:ac(playerid,params[],help) {
    if(IsValidStaff(playerid)&&!strlen(params))SendClientMessage(playerid,COLOR_RED,"Uso: /ac (msg)");
    else if(IsValidStaff(playerid))SendStaffMessage(playerid,params);
    else SendClientMessage(playerid,COLOR_RED,"Não pertences á staff!");
    return 1;
}