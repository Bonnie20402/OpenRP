

/*
    Admin sub-modules
                        */
#include "modulos\admins\adminmsg.pwn"
#include "modulos\admins\adminauth.pwn"
#include "modulos\admins\adminteleport.pwn"
#include "modulos\admins\punish\kick.pwn"
#include "modulos\admins\helprequests\helprequests.pwn"
/*
        Admin commands
                                    */
#include "modulos\admincmds\criarloc.pwn"
#include "modulos\admincmds\removerloc.pwn"
#include "modulos\admincmds\criaradmin.pwn"
#include "modulos\admincmds\aa.pwn"
#include "modulos\admincmds\removeradmin.pwn"
#include "modulos\admincmds\ac.pwn"
#include "modulos\admincmds\beepboop.pwn"
#include "modulos\admincmds\atrabalhar.pwn"
#include "modulos\admincmds\av.pwn"
#include "modulos\admincmds\aveh.pwn"
#include "modulos\admincmds\adminslist.pwn"
#include "modulos\admincmds\criarcitizenvehicle.pwn"
#include "modulos\admincmds\removercitizenvehicle.pwn"
#include "modulos\admincmds\criarlocationpickup.pwn"
#include "modulos\admincmds\removerlocationpickup.pwn"
#include "modulos\admincmds\setarinterior.pwn"
#include "modulos\admincmds\irloc.pwn"
#include "modulos\admincmds\tp.pwn"
#include "modulos\admincmds\tph.pwn"
#include "modulos\admincmds\tppos.pwn"
#include "modulos\admincmds\amoney.pwn"
#include "modulos\admincmds\criaratm.pwn"
#include "modulos\admincmds\removeratm.pwn"
#include "modulos\admincmds\verpos.pwn"
#include "modulos\admincmds\printpos.pwn"
#include "modulos\admincmds\editobj.pwn"
#include "modulos\admincmds\criarcompany.pwn"
#include "modulos\admincmds\removercompany.pwn"
#include "modulos\admincmds\iremp.pwn"
#include "modulos\admincmds\printobj.pwn"
#include "modulos\admincmds\playsound.pwn"
#include "modulos\admincmds\aweapon.pwn"
#include "modulos\admincmds\abnotificacao.pwn"
#include "modulos\admincmds\akick.pwn"


/*
    HOOKS
                */


// db
#include <YSI_Coding\y_hooks>
hook dbInit() {
    new query[256];
    printf("[ADMINS] Carregado!");
    mysql_format(mysql,query,256,"CREATE TABLE IF NOT EXISTS admins(username varchar(64) PRIMARY KEY NOT NULL,level int(11) NOT NULL,role varchar(64) NOT NULL)");
    mysql_query(mysql,query,false);
    return 1;
}
forward Admin:PrepareAdminCheck(const username[]);
public Admin:PrepareAdminCheck(const username[]) {
    new query[256];
    mysql_format(mysql,query,sizeof(query),"SELECT * FROM `admins` WHERE username = '%s'",username);
    mysql_pquery(mysql,query,"FinishAdminCheck","s",username);
}
forward Login:FinishAdminCheck(const username[]);
public Login:FinishAdminCheck(const username[]) {
    new Int:IsStaff;
    cache_get_value_index_int(0,1,IsStaff);
    if(IsStaff) {
        for(new i =0;i<MAX_PLAYERS;i++) {
            if(IsPlayerConnected(i)&&!strcmp(username,GetPlayerNameEx(i))) {
                cache_get_value_index_int(0,1,gAdmins[i][ADMININFO_LEVEL]);
                cache_get_value_index(0,2,gAdmins[i][ADMININFO_ROLE],64);
                SendClientMessage(i,COLOR_AQUA,"Entraste no servidor como administrador");
                PrepareAdminAuth(GetPlayerIdFromName(username));
            }
        }
    }
    return 1;
}



/*
        CreateAdmin
    Inserts a new admin in the table

                                   */
stock Admin:PrepareCreateAdmin(playerid,Int:level,String:role[]) {
    new query[256];
    mysql_format(mysql,query,256,"INSERT INTO `admins`(`username`, `level`, `role`) VALUES ('%s','%d','%s') ON DUPLICATE KEY UPDATE level=%d,role='%s'",GetPlayerNameEx(playerid),level,role,level,role);
    mysql_pquery(mysql,query,"FinishCreateAdmin","iis",playerid,level,role);
    return 1;
}
forward Admin:FinishCreateAdmin(playerid,Int:level,const role[]);
public Admin:FinishCreateAdmin(playerid,Int:level,const role[]) {
    gAdmins[playerid][ADMININFO_LEVEL]=level;
    gAdmins[playerid][ADMININFO_WORKING]=1;
    format(gAdmins[playerid][ADMININFO_ROLE],64,"%s",role);
    new msg[256];
    format(msg,256,"Foste promovido a nivel %d de admin, a tua função é %s",level,role);
    SendClientMessage(playerid,COLOR_AQUA,msg);
    return 1;
}
/*
    DeleteAdmin
    Deletes an admin from the table
                                */

forward Admin:PreparteDeleteAdmin(playerid,const username[]);
public Admin:PrepareDeleteAdmin(playerid,const username[]) {
    new query[255];
    mysql_format(mysql,query,255,"DELETE FROM admins WHERE username = '%s'",username);
    mysql_pquery(mysql,query,"FinishDeleteAdmin","is",playerid,username);
    return 1;
}
public Admin:FinishDeleteAdmin(playerid,const username[]) {
    new String:msg[255];
    new Int:staffid;
    staffid=GetPlayerIdFromName(username);
    if(cache_affected_rows()) {
        format(msg,255,"O staff %s foi limpo.",username);
        SendClientMessage(playerid,COLOR_AQUA,msg);
        if(staffid!=-1&&IsPlayerConnected(staffid)) {
            SendClientMessage(playerid,COLOR_AQUA,"Os valores na RAM foram zerados.");
            SendClientMessage(staffid,COLOR_AQUA,"Já não fazes mais parte da equipa da staff do servidor! Volta a entrar!");
            gAdmins[staffid][ADMININFO_LEVEL]=0;
            gAdmins[staffid][ADMININFO_WORKING]=0;
            Kick(staffid);

        }
        return 1;
    }
    format(msg,255,"Esse jogador não consta na tabela de administradores.\
     Os valores na RAM relativamente ao playerid foram zerados se o ID for válido.");
    if(staffid!=-1)gAdmins[staffid][ADMININFO_LEVEL]=0;
    if(staffid!=-1)gAdmins[staffid][ADMININFO_WORKING]=0;
    SendClientMessage(playerid,COLOR_AQUA,msg);
    
    return 1;
}


/*
    Getterrs

    ESCLARECIMENTO

    A função IsValidStaff valida se o staff está logado e autenticado.
    A função GetStaffLevel valida tudo acima, e se o staff for nivel 3000+, se ele está a jogar ou A trabalhar.
    assim, comandos Staff no modo jogo devem usar o IsValidStaff para validação
                */

forward Getter:GetStaffLevel(playerid);
public Getter:GetStaffLevel(playerid) {
    if(IsPlayerLoggedIn(playerid)&&gAdmins[playerid][ADMININFO_LEVEL]&&gAdmins[playerid][ADMININFO_AUTH]) {
        if(gAdmins[playerid][ADMININFO_LEVEL]>=3000) return gAdmins[playerid][ADMININFO_LEVEL]; 
        else if(IsStaffWorking(playerid))return gAdmins[playerid][ADMININFO_LEVEL];
        else return 0; // Admin no modo jogo
    }
    else return 0;
}
forward Getter:GetStaffRole(playerid);
public Getter:GetStaffRole(playerid) {
    if(IsPlayerLoggedIn(playerid)) return gAdmins[playerid][ADMININFO_ROLE];
    return 0;

}

forward Getter:IsStaffWorking(playerid);
public Getter:IsStaffWorking(playerid) {
    if(IsPlayerLoggedIn(playerid))return gAdmins[playerid][ADMININFO_WORKING];
    return 0;
}

forward Getter:IsValidStaff(playerid);
public Getter:IsValidStaff(playerid) {
    if(IsPlayerLoggedIn(playerid)&&gAdmins[playerid][ADMININFO_LEVEL]&&gAdmins[playerid][ADMININFO_AUTH]) return 1;
    return 0;
}

/*
    Converte um nivel em string
*/
stock AdminUtil:GetStaffLevelString(playerid) {
    if(IsValidStaff(playerid)) {
        new role[32];
        switch(gAdmins[playerid][ADMININFO_LEVEL]) {
            case 1:
                format(role,32,"Aprendiz");
            case 2:
                format(role,32,"Moderador");
            case 3:
                format(role,32,"Admin");
            case 4:
                format(role,32,"Supervisor");
            case 1337:
                format(role,32,"Master");
            case 1338:
                format(role,32,"Gerente");
            case 3000:
                format(role,32,"Dono");
            case 5000:
                format(role,32,"Fundador");
        }
        return role;
    }
    new String:role[32];
    format(role,32,"Desconhecido");
    return role;
}
