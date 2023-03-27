/*
    Company Rob System
                        */
#include <YSI_Coding\y_hooks>
enum SAFESTATUS {
    SAFE_STATUS_WAITING,
    SAFE_STATUS_PLANTING,
    SAFE_STATUS_DRILLING,
    SAFE_STATUS_DRILLERROR,
    SAFE_STATUS_DRILLFIX,
    SAFE_STATUS_ROBBED
}

enum DOORSTATUS {
    DOOR_STATUS_WAITING,
    DOOR_STATUS_EXPLODING,
    DOOR_STATUS_EXPLODED
}
enum LASERSTATUS {
    LASER_STATUS_WAITING,
    LASER_STATUS_HACKING,
    LASER_STATUS_ALARM,
    LASER_STATUS_OFF
}

enum COMPANYDOOR {
    Float:COMPANYDOOR_COORDS[3], // coords 
    Text3D:COMPANYDOOR_TEXT,
    COMPANYDOOR_OBJECTID,
    COMPANYDOOR_PROGRESS,
    COMPANYDOOR_TIMERID,
    DOOR_STATUS
}
enum COMPANYSAFE {
    Float:COMPANYSAFE_COORDS[3],
    Text3D:COMPANYSAFE_TEXT,
    COMPANYSAFE_OBJECTID,
    COMPANYSAFE_PROGRESS,
    COMPANYSAFE_RPROGRESS, // Drill repair progress in order to save the drill progress.
    COMPANYSAFE_TIMERID,
    SAFE_STATUS
}
enum COMPANYLASER {
    Float:COMPANYLASER_COORDS[3], // The location of the numpad + z rotation
    Text3D:COMPANYLASER_TEXT,
    COMPANYLASER_OBJECTID,
    COMPANYLASER_AREAID,
    COMPANYLASER_PROGRESS,
    COMPANYLASER_TIMERID,
    LASER_STATUS
}
enum COMPANYEXIT {
    Float:COMPANYEXIT_COORDS[3],
    Text3D:COMPANYEXIT_TEXT,
    COMPANYEXIT_PICKUPID
}
new gCompanySafe_EXIT[sizeof(gCompanies)][COMPANYEXIT];
new gCompanySafe_DOOR[sizeof(gCompanies)][COMPANYDOOR];
new gCompanySafe_SAFE[sizeof(gCompanies)][COMPANYSAFE];
new gCompanySafe_LASER[sizeof(gCompanies)][COMPANYLASER]; // Laser and keypad!
new gCompanySafe_staticLASER[sizeof(gCompanies)][3]; // Used to remember the laser list
new gPlayer_CompanySafe[MAX_PLAYERS]; // To check if player has entered a company's safe interior or not
#define ROBBERY_INTERIOR_ID 1
#define ROBBERYDIALOG_SAFE 900
#define ROBBERYDIALOG_DOOR 901
#define ROBBERYDIALOG_LASER 902


//Rob sucesss rewards

#define ROBMONEY_COMPANY 25 // Percentagem of the cash deleted from the company
#define ROBMONEY_SERVERMIN 25000 // Server-generated min money
#define ROBMONEY_SERVERMAX 50000 // Server-generated max money
//minMax for drill percentage, delay between percentage (in ms), and error chance (x in 100)
#define DRILLPROGRESS_MIN 1
#define DRILLPROGRESS_MAX 4
#define DRILLPROGRESS_DELAY 500
#define DRILLPROGRESS_ERRRORCHANCE 2

// minMax for drill repairing
#define DRILLREPAIRPROGRESS_MIN 1
#define DRILLREPAIRPROGRESS_MAX 4

//minMax for planting drill on safe
#define SAFEPROGRESS_MIN 1
#define SAFEPROGRESS_MAX 2

// minMax for laser hacka
#define LASERPROGRESS_MIN 1
#define LASERPROGRESS_MAX 4

//minMax for door explosive plant
#define DOORPROGRESS_MIN 1
#define DOORPROGRESS_MAX 3

forward CompanyLaserHackProgress(playerid,rowid);

stock CompanySafeInit() {
    new Float:x,Float:y,Float:z;
    //Static Doors, no need to remember their ID
    CreateDynamicObject(2634,2147.756103,1604.791992,1006.597656,0.000000,0.000000,-178.199981,-1,ROBBERY_INTERIOR_ID);
    CreateDynamicObject(2634,2148.258056,1604.833984,1002.467712,0.000000,0.000000,179.69981,-1,ROBBERY_INTERIOR_ID);
    CreateDynamicObject(2634, 2150.013916,1602.849731,1002.458068,0.000000,0.000000,89.700057,-1,ROBBERY_INTERIOR_ID);
    for(new i=0;i<sizeof(gCompanies);i++) {
        if(IsValidCompany(i)) {
            //Create exit pickup
            gCompanySafe_EXIT[i][COMPANYEXIT_COORDS][0] =2147.7861;
            gCompanySafe_EXIT[i][COMPANYEXIT_COORDS][1] =1602.9135;
            gCompanySafe_EXIT[i][COMPANYEXIT_COORDS][2] =1006.1677;
            gCompanySafe_EXIT[i][COMPANYEXIT_PICKUPID] = CreateDynamicPickup(19133,1,gCompanySafe_EXIT[i][COMPANYEXIT_COORDS][0],gCompanySafe_EXIT[i][COMPANYEXIT_COORDS][1],gCompanySafe_EXIT[i][COMPANYEXIT_COORDS][2],i,ROBBERY_INTERIOR_ID);
            gCompanySafe_EXIT[i][COMPANYEXIT_TEXT] = CreateDynamic3DTextLabel("Saida\nAperte Y para sair",-1,gCompanySafe_EXIT[i][COMPANYEXIT_COORDS][0],gCompanySafe_EXIT[i][COMPANYEXIT_COORDS][1],gCompanySafe_EXIT[i][COMPANYEXIT_COORDS][2],15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,i,ROBBERY_INTERIOR_ID);
            
            //Setup lasers
            gCompanySafe_staticLASER[i][0]=CreateDynamicObject(18643,2141.766601,1606.728759,993.548034,0.0,0.0,0.0,i,ROBBERY_INTERIOR_ID);
            gCompanySafe_staticLASER[i][1]=CreateDynamicObject(18643,2141.926269,1606.677001,994.108398,0.0,0.0,0.0,i,ROBBERY_INTERIOR_ID);
            gCompanySafe_staticLASER[i][2]=CreateDynamicObject(18643,2141.370117,1606.693237,994.598083,0.0,0.0,0.0,i,ROBBERY_INTERIOR_ID);
            
            //Setup laser controller keypad (2886) + laser alarm area
            gCompanySafe_LASER[i][COMPANYLASER_COORDS][0] = 2146.122558;
            gCompanySafe_LASER[i][COMPANYLASER_COORDS][1] = 1605.751220;
            gCompanySafe_LASER[i][COMPANYLASER_COORDS][2] = 993.927917;
            gCompanySafe_LASER[i][COMPANYLASER_OBJECTID] = CreateDynamicObject(2886,gCompanySafe_LASER[i][COMPANYLASER_COORDS][0],gCompanySafe_LASER[i][COMPANYLASER_COORDS][1],gCompanySafe_LASER[i][COMPANYLASER_COORDS][2],0.0,0.0,-90.39,i,ROBBERY_INTERIOR_ID);
            gCompanySafe_LASER[i][COMPANYLASER_TEXT] = CreateDynamic3DTextLabel("A carregar...",-1,gCompanySafe_LASER[i][COMPANYLASER_COORDS][0],gCompanySafe_LASER[i][COMPANYLASER_COORDS][1],gCompanySafe_LASER[i][COMPANYLASER_COORDS][2],10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,i,ROBBERY_INTERIOR_ID);
            gCompanySafe_LASER[i][COMPANYLASER_AREAID] = CreateDynamicCube(2129.266845,1606.640625,992.557739,2158.259521,1609.094482,997.408386,i,ROBBERY_INTERIOR_ID);
            //Door to explode
            gCompanySafe_DOOR[i][COMPANYDOOR_COORDS][0] = 2144.206787;
            gCompanySafe_DOOR[i][COMPANYDOOR_COORDS][1] = 1627.017944;
            gCompanySafe_DOOR[i][COMPANYDOOR_COORDS][2] = 994.238342;
            gCompanySafe_DOOR[i][COMPANYDOOR_OBJECTID] = CreateDynamicObject(2634,gCompanySafe_DOOR[i][COMPANYDOOR_COORDS][0],gCompanySafe_DOOR[i][COMPANYDOOR_COORDS][1],gCompanySafe_DOOR[i][COMPANYDOOR_COORDS][2],0.0,0.0,179.899902,i,ROBBERY_INTERIOR_ID);
            gCompanySafe_DOOR[i][COMPANYDOOR_TEXT] = CreateDynamic3DTextLabel("A carregar...",-1,gCompanySafe_DOOR[i][COMPANYDOOR_COORDS][0],gCompanySafe_DOOR[i][COMPANYDOOR_COORDS][1],gCompanySafe_DOOR[i][COMPANYDOOR_COORDS][2],10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,i,ROBBERY_INTERIOR_ID);

            //The Safe
            gCompanySafe_SAFE[i][COMPANYSAFE_COORDS][0] = 2144.416015;
            gCompanySafe_SAFE[i][COMPANYSAFE_COORDS][1]= 1642.654907;
            gCompanySafe_SAFE[i][COMPANYSAFE_COORDS][2] = 993.035644;
            gCompanySafe_SAFE[i][COMPANYSAFE_OBJECTID] = CreateDynamicObject(2332,gCompanySafe_SAFE[i][COMPANYSAFE_COORDS][0],gCompanySafe_SAFE[i][COMPANYSAFE_COORDS][1],gCompanySafe_SAFE[i][COMPANYSAFE_COORDS][2],0.0,0.0,0.0,i,ROBBERY_INTERIOR_ID);
            gCompanySafe_SAFE[i][COMPANYDOOR_TEXT] = CreateDynamic3DTextLabel("A carregar...",-1,gCompanySafe_SAFE[i][COMPANYSAFE_COORDS][0],gCompanySafe_SAFE[i][COMPANYSAFE_COORDS][1],gCompanySafe_SAFE[i][COMPANYSAFE_COORDS][2],10.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,i,ROBBERY_INTERIOR_ID);
            
            //Text init
            UpdateCompanySafeDOORText(i);
            UpdateCompanySafeSAFEText(i);
            UpdateCompanySafeLASERText(i);
        }
    }
    print("[compansafe.pwn] CompanySafe module loaded!");
    return 1;
}

/*
    Laser evasion handle
    If lasers are on or currently getting hacked, activ8 alarm
    If lasers are OFF, or already on dont do anything  */
hook OnPlayerEnterDynamicArea(p, a) {
    if(IsPlayerInCompanySafe(p)) {
        new rowid,playerid;
        playerid=p;
        rowid=GetPlayerVirtualWorld(p);
        if(a==gCompanySafe_LASER[rowid][COMPANYLASER_AREAID]) { 
            if(gCompanySafe_LASER[rowid][LASER_STATUS] == LASER_STATUS_WAITING || gCompanySafe_LASER[rowid][LASER_STATUS] == LASER_STATUS_HACKING) {
                //TODO Check if player is cop, if so, dont play alarm!
                UpdateCompanySafeLASERText(rowid);
                new msg[255];
                format(msg,255,"[ALERTA] O alarme foi ancionado porque %s foi antigido pelo laser de segurança!",GetPlayerNameEx(playerid));
                SendVirtualWorldMessage(rowid,COLOR_YELLOW,msg);
                for(new i;i<MAX_PLAYERS;i++) {
                    if(GetPlayerVirtualWorld(i)==rowid) {  
                        if(GetCompanySafeLaserStatus(rowid)==LASER_STATUS_HACKING)HidePlayerTxdProgress(i);
                    }
                }
                gCompanySafe_LASER[rowid][LASER_STATUS] = LASER_STATUS_ALARM;
            }
            if(gCompanySafe_LASER[rowid][LASER_STATUS] == LASER_STATUS_ALARM || gCompanySafe_LASER[rowid][LASER_STATUS] == LASER_STATUS_OFF) {
                return 1;
            }

        }
    }
    return 1;
}
/*
    Keypad handle
                    */
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if(PRESSED(KEY_YES)) {
        if(IsPlayerInCompanySafe(playerid)) {
            new Float:dist,rowid;
            new String:msg;
            rowid=GetPlayerVirtualWorld(playerid);
            dist=GetPlayerDistanceFromPoint(playerid,gCompanySafe_LASER[rowid][COMPANYLASER_COORDS][0],gCompanySafe_LASER[rowid][COMPANYLASER_COORDS][1],gCompanySafe_LASER[rowid][COMPANYLASER_COORDS][2]);
            if(dist<=1.0&&GetCompanySafeLaserStatus(rowid)==LASER_STATUS_WAITING ||dist<=1.0&&GetCompanySafeLaserStatus(rowid) == LASER_STATUS_OFF) {
                ShowPlayerDialog(playerid,ROBBERYDIALOG_LASER,DIALOG_STYLE_LIST,"Sistema de Segurança","Desativar alarme\nHackear alarme\nAtivar alarme","Escolher","Cancelar");
            }
        }
    }
    return 1;
}
/*
    Keypad dialog handle
                        */
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(IsPlayerInCompanySafe(playerid)) {
        new rowid;
        rowid=GetPlayerVirtualWorld(playerid);
        if(dialogid==ROBBERYDIALOG_LASER&&response) {
            if(listitem==0) { // Desativar alarme (Dono/Subdono/Cop) TODO cop
                if(GetCompanySafeLaserStatus(rowid) == LASER_STATUS_WAITING) {
                    if(IsPlayerCompanyOwner(playerid,rowid)||IsPlayerCompanyCoowner(playerid,rowid)) {
                        new msg[255];
                        format(msg,255,"[ALERTA] O sistema de segurança foi desativado por %s[%d]",GetPlayerNameEx(playerid),playerid);
                        SendVirtualWorldMessage(rowid,COLOR_YELLOW,msg);
                        DestroyCompanySafeLaser(rowid);
                    }
                    else SendClientMessage(playerid,COLOR_YELLOW,"Não pertences á gestão desta empresa!");
                }
                else SendClientMessage(playerid,COLOR_YELLOW,"O alarme já está desativado!");
            }
            if(listitem==1) { // Hackear Alarme
                new msg[255];
                if(GetCompanySafeLaserStatus(rowid)==LASER_STATUS_WAITING) {
                    format(msg,255,"[ALERTA] %s[%d] está a tentar hackear o sistema de segurança da empresa %s[%d]!",GetPlayerNameEx(playerid),playerid,gCompanies[rowid][COMPANY_NAME],rowid);
                    gCompanySafe_LASER[rowid][LASER_STATUS]=LASER_STATUS_HACKING;
                    SendVirtualWorldMessage(rowid,COLOR_YELLOW,msg);
                    SetPlayerAttachedObject(playerid,1,19893,5);
                    UpdateCompanySafeLASERText(rowid);
                    for(new i;i<MAX_PLAYERS;i++) {
                        if(IsPlayerConnected(i)&&GetPlayerVirtualWorld(i)==rowid) {
                            ShowPlayerTxdProgress(i);
                            SetPlayerTxdProgressText(i,"Hackeando 0%");
                            SetPlayerTxdProgressProgress(i,0.0);
                        }
                    }
                    //TODO freze player and apply animation
                    gCompanySafe_LASER[rowid][COMPANYLASER_PROGRESS]=0;
                    gCompanySafe_LASER[rowid][COMPANYLASER_TIMERID]=SetPreciseTimer("CompanyLaserHackProgress",100,true,"ii",playerid,rowid);
                    SendClientMessage(playerid,COLOR_YELLOW,"Não fiques longe do keypad, senão o hack é cancelado!");
                }
            }
            if(listitem==2) { // Ativar alarme
            //Must be COP, company owner or company co owner
            //TODO must be cop
                if(GetCompanySafeLaserStatus(rowid) == LASER_STATUS_OFF) {
                    if(IsPlayerCompanyOwner(playerid,rowid)||IsPlayerCompanyCoowner(playerid,rowid)) {
                        new msg[255];
                        format(msg,255,"[ALERTA] O sistema de segurança foi ativado por %s[%d]",GetPlayerNameEx(playerid),playerid);
                        SendVirtualWorldMessage(rowid,COLOR_YELLOW,msg);
                        RegenCompanySafeLaser(rowid);
                    }
                    else SendClientMessage(playerid,COLOR_YELLOW,"Não pertences á gestão desta empresa!");
                }
                else SendClientMessage(playerid,COLOR_YELLOW,"O alarme já está ativado!");
            }
        }
    }
    return 1;
}
#include <YSI_Coding\y_hooks>
/*
    Company Safe Interact Handle
    No need for dialog as players can only plant the drill.
                        */
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if(PRESSED(KEY_YES)&&IsPlayerInCompanySafe(playerid)) {
        new Float:dist,rowid;
        new msg[255];
        rowid=GetPlayerVirtualWorld(playerid);
        dist=GetPlayerDistanceFromPoint(playerid,gCompanySafe_SAFE[rowid][COMPANYSAFE_COORDS][0],gCompanySafe_SAFE[rowid][COMPANYSAFE_COORDS][1],gCompanySafe_SAFE[rowid][COMPANYSAFE_COORDS][2]);
        if(dist<=1.0) {
            if(GetCompanySafeSafeStatus(rowid) == SAFE_STATUS_WAITING) {
                format(msg,255,"[ALERTA] %s[%d] está instalando o drill no cofre da empresa %s[%d]",GetPlayerNameEx(playerid),playerid,gCompanies[rowid][COMPANY_NAME],rowid);
                SendVirtualWorldMessage(rowid,COLOR_YELLOW,msg);
                gCompanySafe_SAFE[rowid][SAFE_STATUS] = SAFE_STATUS_PLANTING;
                gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS] = 0;
                gCompanySafe_SAFE[rowid][COMPANYSAFE_TIMERID] = SetPreciseTimer("CompanySafeRobProgress",250,true,"ii",playerid,rowid);
                for(new i;i<MAX_PLAYERS;i++) {
                    ShowPlayerTxdProgress(i);
                    SetPlayerTxdProgressText(i,"Instalando 0%");
                    SetPlayerTxdProgressProgress(i,0.0);
                }
            }
        }
    }
    return 1;
}

forward CompanySafeRobProgress(playerid,rowid);
public CompanySafeRobProgress(playerid,rowid) {
    if(GetCompanySafeSafeStatus(rowid) == SAFE_STATUS_PLANTING) {
        if(gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS]<100) {
            new Float:dist;
            new msg[255];
            dist=GetPlayerDistanceFromPoint(playerid,gCompanySafe_SAFE[rowid][COMPANYSAFE_COORDS][0],gCompanySafe_SAFE[rowid][COMPANYSAFE_COORDS][1],gCompanySafe_SAFE[rowid][COMPANYSAFE_COORDS][2]);
            if(dist<=1.0) {
                new Float:floatProgress;
                gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS] +=SAFEPROGRESS_MIN + random(SAFEPROGRESS_MAX);
                if(gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS]>100)gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS]=100;
                format(msg,255,"Instalando %d%%",gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS]);
                floatProgress=float(gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS]);
                UpdateCompanySafeSAFEText(rowid);
                for(new i;i<MAX_PLAYERS;i++) {
                    if(GetPlayerVirtualWorld(i)==rowid) {
                        SetPlayerTxdProgressProgress(i,floatProgress);
                        SetPlayerTxdProgressText(i,msg);
                    }
                }
            }
            else {
                SendVirtualWorldMessage(rowid,COLOR_YELLOW,"[ALERTA] O plantador está longe do cofre, a ação foi cancelada!");
                gCompanySafe_SAFE[rowid][SAFE_STATUS] = SAFE_STATUS_WAITING;
                UpdateCompanySafeSAFEText(rowid);
                for(new i;i<MAX_PLAYERS;i++) {
                    if(GetPlayerVirtualWorld(i)==rowid) {
                        HidePlayerTxdProgress(i);
                    }
                }
            }
        }
        else {
            gCompanySafe_SAFE[rowid][SAFE_STATUS] = SAFE_STATUS_DRILLING;
            SendVirtualWorldMessage(rowid,COLOR_YELLOW,"[ALERTA] O Drill foi montado, protege-o até prefurar o cofre por completo!");
            gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS] = 0;
            DeletePreciseTimer(gCompanySafe_SAFE[rowid][COMPANYSAFE_TIMERID]);
            gCompanySafe_SAFE[rowid][COMPANYSAFE_TIMERID]=SetPreciseTimer("CompanySafeDrillProgress",DRILLPROGRESS_DELAY,true,"ii",playerid,rowid);
        }
    }
    return 1;
}
forward CompanySafeDrillProgress(playerid,rowid);
public CompanySafeDrillProgress(playerid,rowid) {
    if(GetCompanySafeSafeStatus(rowid) == SAFE_STATUS_DRILLING) {
        if(gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS]<100) {
            //Same bullshit as before, sorry for repeating.
            new Float:floatProgress;
            new msg[255];
            gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS] +=DRILLPROGRESS_MIN + random(DRILLPROGRESS_MAX);
            if(gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS]>100)gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS]=100;
            UpdateCompanySafeSAFEText(rowid);
            format(msg,255,"Furando %d%%",gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS]);
            floatProgress=float(gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS]);
            for(new i;i<MAX_PLAYERS;i++) {
                if(GetPlayerVirtualWorld(i)==rowid) {
                    SetPlayerTxdProgressProgress(i,floatProgress);
                    SetPlayerTxdProgressText(i,msg);
                }
            }
            // Error chance
            new errorChance;
            errorChance = 0 + random(100);
            if(errorChance<=DRILLPROGRESS_ERRRORCHANCE) {// between 0 and const drillprogress_errorchance
                gCompanySafe_SAFE[rowid][SAFE_STATUS] = SAFE_STATUS_DRILLERROR;
                UpdateCompanySafeSAFEText(rowid);
                SendVirtualWorldMessage(rowid,COLOR_YELLOW,"[ALERTA] O drill encravou, resolvam o problema!");
                for(new i;i<MAX_PLAYERS;i++) {
                    if(GetPlayerVirtualWorld(i)==rowid) {
                        ShowPlayerTxdbNotification(i);
                        SetPlayerTxdbNotifText(i,"Atencao ~n~ O drill encravou!",4);
                    }
                }
            }
        }
        else {
            gCompanySafe_SAFE[rowid][SAFE_STATUS] = SAFE_STATUS_ROBBED;
            UpdateCompanySafeSAFEText(rowid);
            SendVirtualWorldMessage(rowid,COLOR_YELLOW,"[ALERTA] O cofre foi roubado!");
            new companyReward;
            new serverReward;
            // TODO fix this too much
            companyReward = (GetCompanyCash(rowid)/4);
            gCompanies[rowid][COMPANY_CASH]-=companyReward;
            serverReward = ROBMONEY_SERVERMIN + random(ROBMONEY_SERVERMAX);
            PrepareSaveCompany(rowid);
            //TODO check if player is cop and dont give monz to them
            // TODO also raise wanted level
            new msg[255],msg2[255],msg3[255],txdMsg[255];
            format(msg,255,"Dinheiro roubado da empresa: +R$%d",companyReward);
            format(msg2,255,"Prémio por roubo concluido: +R$%d",serverReward);
            format(msg3,255,"TOTAL +R$%d",companyReward+serverReward);
            format(txdMsg,255,"Roubo concluido ~n~ +R$%d",companyReward+serverReward);
            SendVirtualWorldMessage(rowid,COLOR_YELLOW,"|______ ROUBO CONCLUIDO _______|");
            SendVirtualWorldMessage(rowid,COLOR_YELLOW,msg);
            SendVirtualWorldMessage(rowid,COLOR_YELLOW,msg2);
            SendVirtualWorldMessage(rowid,COLOR_YELLOW,msg3);
            SendVirtualWorldMessage(rowid,COLOR_LIGHTGREEN,"O cofre será regenerado em 5 minutos");
            SetPreciseTimer("RegenCompanySafeSafe",300000,false,"i",rowid);
            for(new i;i<MAX_PLAYERS;i++) {
                if(GetPlayerVirtualWorld(i)==rowid) {
                    HidePlayerTxdProgress(i);
                    ShowPlayerTxdbNotification(i);
                    SetPlayerTxdbNotifText(i,txdMsg,8);
                    GivePlayerMoney(i,serverReward+companyReward);
                }
            }
        }
    }
    else {
        DeletePreciseTimer(gCompanySafe_SAFE[rowid][COMPANYSAFE_TIMERID]);
    }
}

forward RegenCompanySafeSafe(rowid);
public RegenCompanySafeSafe(rowid) {
    if(GetCompanySafeSafeStatus(rowid) == SAFE_STATUS_ROBBED) {
        gCompanySafe_SAFE[rowid][SAFE_STATUS] = SAFE_STATUS_WAITING;
        SendVirtualWorldMessage(rowid,COLOR_YELLOW,"[ALERTA] O cofre regenerou-se!");
        UpdateCompanySafeSAFEText(rowid);
    }
}
/*
    Drill-Fix handle
                    */
#include <YSI_Coding\y_hooks>
hook OnPlayerKeyStateChange(playerid,newkeys,oldkeys) {
    if(PRESSED(KEY_YES)) {
        if(IsPlayerInCompanySafe(playerid)) {
            new Float:dist,rowid;
            new String:msg[255];
            rowid=GetPlayerVirtualWorld(playerid);
            dist=GetPlayerDistanceFromPoint(playerid,gCompanySafe_SAFE[rowid][COMPANYSAFE_COORDS][0],gCompanySafe_SAFE[rowid][COMPANYSAFE_COORDS][1],gCompanySafe_SAFE[rowid][COMPANYSAFE_COORDS][2]);
            if(dist<=1.0&&GetCompanySafeSafeStatus(rowid) == SAFE_STATUS_DRILLERROR) {
                gCompanySafe_SAFE[rowid][SAFE_STATUS] = SAFE_STATUS_DRILLFIX;
                format(msg,255,"[ALERTA] %s[%d] está reparando o drill!",GetPlayerNameEx(playerid),playerid);
                SendVirtualWorldMessage(rowid,COLOR_YELLOW,msg);
                gCompanySafe_SAFE[rowid][COMPANYSAFE_RPROGRESS]=0;
                gCompanySafe_SAFE[rowid][COMPANYSAFE_TIMERID] = SetPreciseTimer("CompanySafeDrillRepairProgress",500,true,"ii",playerid,rowid);
                for(new i;i<MAX_PLAYERS;i++) {
                    if(GetPlayerVirtualWorld(i)==rowid) {
                        SetPlayerTxdProgressProgress(i,0.0);
                        SetPlayerTxdProgressText(i,"Reparando 0%");
                    }
                }
            }
        }
    }
    return 1;
}

stock CompanySafeSyncPlayer(playerid,rowid) {
    if(GetPlayerVirtualWorld(playerid)==rowid) {
        SetPlayerTxdProgressText(playerid,"Aguardando");
        SetPlayerTxdProgressProgress(playerid,0.0);
        ShowPlayerTxdProgress(playerid);
    }
    else HidePlayerTxdProgress(playerid);
    return 1;
}
forward CompanySafeDrillRepairProgress(playerid,rowid);
public CompanySafeDrillRepairProgress(playerid,rowid) {
    if(GetCompanySafeSafeStatus(rowid) == SAFE_STATUS_DRILLFIX) {
        new Float:dist;
        new Float:floatProgress;
        new msg[255];
        dist=GetPlayerDistanceFromPoint(playerid,gCompanySafe_SAFE[rowid][COMPANYSAFE_COORDS][0],gCompanySafe_SAFE[rowid][COMPANYSAFE_COORDS][1],gCompanySafe_SAFE[rowid][COMPANYSAFE_COORDS][2]);
        if(dist<=1.0) {
            if(gCompanySafe_SAFE[rowid][COMPANYSAFE_RPROGRESS]<100) {
                gCompanySafe_SAFE[rowid][COMPANYSAFE_RPROGRESS]+= DRILLREPAIRPROGRESS_MIN + random(DRILLREPAIRPROGRESS_MAX);
                if(gCompanySafe_SAFE[rowid][COMPANYSAFE_RPROGRESS]>100)gCompanySafe_SAFE[rowid][COMPANYSAFE_RPROGRESS]=100;
                floatProgress=float(gCompanySafe_SAFE[rowid][COMPANYSAFE_RPROGRESS]);
                format(msg,255,"Reparando %d%%",gCompanySafe_SAFE[rowid][COMPANYSAFE_RPROGRESS]);
                UpdateCompanySafeSAFEText(rowid);
                for(new i;i<MAX_PLAYERS;i++) {
                    if(GetPlayerVirtualWorld(i)==rowid) {
                        SetPlayerTxdProgressProgress(i,floatProgress);
                        SetPlayerTxdProgressText(i,msg);
                    }
                }
            }
            else {
                SendVirtualWorldMessage(rowid,COLOR_YELLOW,"[ALERTA] O drill foi reparado!");
                gCompanySafe_SAFE[rowid][SAFE_STATUS] = SAFE_STATUS_DRILLING;
                UpdateCompanySafeSAFEText(rowid);
                DeletePreciseTimer(gCompanySafe_SAFE[rowid][COMPANYSAFE_TIMERID]);
                gCompanySafe_SAFE[rowid][COMPANYSAFE_TIMERID]=SetPreciseTimer("CompanySafeDrillProgress",DRILLPROGRESS_DELAY,true,"ii",playerid,rowid);
            }
        }
        else {
            SendVirtualWorldMessage(rowid,COLOR_YELLOW,"[ALERTA] A pessoa que estava reparando o drill afastou-se, a ação foi cancelada!");
            gCompanySafe_SAFE[rowid][SAFE_STATUS] = SAFE_STATUS_DRILLERROR;
            DeletePreciseTimer(gCompanySafe_SAFE[rowid][COMPANYSAFE_TIMERID]);
            UpdateCompanySafeSAFEText(rowid);
            format(msg,255,"Furando %d%%",gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS]);
            floatProgress=float(gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS]);
            for(new i;i<MAX_PLAYERS;i++) {
                if(GetPlayerVirtualWorld(i)==rowid) {
                    SetPlayerTxdProgressProgress(i,floatProgress);
                    SetPlayerTxdProgressText(i,msg);
                }
            }
        }
    }
    else SendClientMessage(playerid,COLOR_YELLOW,"estado errado");
    return 1;
}
#include <YSI_Coding\y_hooks>
/*
    Safe-Door Handle
                        */
hook OnPlayerKeyStateChange(playerid,newkeys,oldkeys) {
    if(PRESSED(KEY_YES)) {
        if(IsPlayerInCompanySafe(playerid)) {
            new Float:dist,rowid;
            new String:msg;
            rowid=GetPlayerVirtualWorld(playerid);
            dist=GetPlayerDistanceFromPoint(playerid,gCompanySafe_DOOR[rowid][COMPANYDOOR_COORDS][0],gCompanySafe_DOOR[rowid][COMPANYDOOR_COORDS][1],gCompanySafe_DOOR[rowid][COMPANYDOOR_COORDS][2]);
            if(dist<=1.0&&GetCompanySafeDoorStatus(rowid)==DOOR_STATUS_WAITING ||dist<=1.0&&GetCompanySafeDoorStatus(rowid) == DOOR_STATUS_EXPLODED) {
                ShowPlayerDialog(playerid,ROBBERYDIALOG_DOOR,DIALOG_STYLE_LIST,"Porta de Segurança","Regenerar Porta\nPlantar explosivo\nAbrir Porta","Escolher","Cancelar");
            }
        }
    }
    return 1;
}

/*
    Safe-Door dialog handle
                            */
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(IsPlayerInCompanySafe(playerid)&&dialogid==ROBBERYDIALOG_DOOR&&response) {
        new rowid;
        rowid=GetPlayerVirtualWorld(playerid);
        if(listitem==0) { // Regenerar Porta
            if(GetCompanySafeDoorStatus(rowid) == DOOR_STATUS_EXPLODED) {
                if(IsPlayerCompanyOwner(playerid,rowid)||IsPlayerCompanyCoowner(playerid,rowid)) {// TODO if it's cop
                    SendVirtualWorldMessage(rowid,COLOR_YELLOW,"[ALERTA] A porta de segurança foi fechada.");
                    RegenCompanySafeDoor(rowid);
                }
                else return SendClientMessage(playerid,COLOR_YELLOW,"Não fazes parte da gerência desta empresa!");         
            }
            else return SendClientMessage(playerid,COLOR_YELLOW,"A porta já está fechada!");
        } 
        if(listitem==1) { // Plantar Explosivo
            if(GetCompanySafeDoorStatus(rowid)== DOOR_STATUS_WAITING) {
                new msg[255];
                format(msg,255,"[ALERTA] %s[%d] está a plantar um explosivo na porta de segurança do cofre da empresa %s[%d]!",GetPlayerNameEx(playerid),playerid,gCompanies[rowid][COMPANY_NAME],rowid);
                SendVirtualWorldMessage(rowid,COLOR_YELLOW,msg);
                gCompanySafe_DOOR[rowid][DOOR_STATUS] = DOOR_STATUS_EXPLODING;
                gCompanySafe_DOOR[rowid][COMPANYDOOR_PROGRESS] = 0;
                gCompanySafe_DOOR[rowid][COMPANYDOOR_TIMERID] = SetPreciseTimer("CompayDoorExplodeProgress",100,true,"ii",playerid,rowid);
                for(new i;i<MAX_PLAYERS;i++) {
                    if(GetPlayerVirtualWorld(i)==rowid) {
                        ShowPlayerTxdProgress(i);
                        SetPlayerTxdProgressText(i,"Plantando 0%");
                        SetPlayerTxdProgressProgress(i,0.0);
                    }
                }
            }
        }
        if(listitem==2) { // Abrir porta
            if(GetCompanySafeDoorStatus(rowid) == DOOR_STATUS_WAITING) {
                if(IsPlayerCompanyOwner(playerid,rowid)||IsPlayerCompanyCoowner(playerid,rowid)) {// TODO if it's cop
                    DestroyCompanySafeDoor(rowid,0);
                    SendVirtualWorldMessage(rowid,COLOR_YELLOW,"[ALERTA] A porta de segurança foi aberta.");
                }
                else return SendClientMessage(playerid,COLOR_YELLOW,"Não fazes parte da gerência desta empresa!");         
            }
            else return SendClientMessage(playerid,COLOR_YELLOW,"A porta já está aberta!");
        }
    }
    return 1;
}
/*
    Safe-Door functions
                            */
stock OnCompanySafeDoorExplode(rowid,playerid) {
    if(GetCompanySafeDoorStatus(rowid)==DOOR_STATUS_EXPLODING) { // Fail-safe
        gCompanySafe_DOOR[rowid][COMPANYDOOR_PROGRESS]=101; // Prevent this from being called again!
        DestroyCompanySafeDoor(rowid,1);
        SendVirtualWorldMessage(rowid,COLOR_YELLOW,"[ALERTA] O explosivo foi plantado, afastem-se, vai explodir!");
        AttachDynamicObjectToObject(1654,gCompanySafe_DOOR[rowid][COMPANYDOOR_OBJECTID],0.0,0.0,0.0,0.0,0.0,0.0);
        UpdateCompanySafeDOORText(rowid);
        for(new i=0;i<MAX_PLAYERS;i++) {
            if(GetPlayerVirtualWorld(i)==rowid) {
                HidePlayerTxdProgress(i);
            }
        }
    }
    return 1;
}
stock RegenCompanySafeDoor(rowid) {
    if(GetCompanySafeDoorStatus(rowid)==DOOR_STATUS_EXPLODED) {
        gCompanySafe_DOOR[rowid][DOOR_STATUS] = DOOR_STATUS_WAITING;
        gCompanySafe_DOOR[rowid][COMPANYDOOR_OBJECTID] = CreateDynamicObject(2634,gCompanySafe_DOOR[rowid][COMPANYDOOR_COORDS][0],gCompanySafe_DOOR[rowid][COMPANYDOOR_COORDS][1],gCompanySafe_DOOR[rowid][COMPANYDOOR_COORDS][2],0.0,0.0,179.899902,rowid,ROBBERY_INTERIOR_ID);
        UpdateCompanySafeDOORText(rowid);
    }
    return 1;
}
stock DestroyCompanySafeDoor(rowid,shouldExplode = 0) {
    if(GetCompanySafeDoorStatus(rowid)== DOOR_STATUS_WAITING || GetCompanySafeDoorStatus(rowid) == DOOR_STATUS_EXPLODING) {
        if(shouldExplode) {
            SetPreciseTimer("DestroyCompanySafeDoorExp",3000,false,"i",rowid);
        }
        else {
            DestroyDynamicObject(gCompanySafe_DOOR[rowid][COMPANYDOOR_OBJECTID]);
            gCompanySafe_DOOR[rowid][DOOR_STATUS] = DOOR_STATUS_EXPLODED;
            UpdateCompanySafeDOORText(rowid);
        }
    }
    return 1;
}
forward DestroyCompanySafeDoorExp(rowid); // Explosion effect
public DestroyCompanySafeDoorExp(rowid) {
    if(GetCompanySafeDoorStatus(rowid) == DOOR_STATUS_EXPLODING) {
        for(new i=0;i<MAX_PLAYERS;i++) {
            if(GetPlayerVirtualWorld(i)==rowid) {
                CreateExplosionForPlayer(i,gCompanySafe_DOOR[rowid][COMPANYDOOR_COORDS][0],gCompanySafe_DOOR[rowid][COMPANYDOOR_COORDS][1],gCompanySafe_DOOR[rowid][COMPANYDOOR_COORDS][2],11,3.0);
            }
        }
        DestroyDynamicObject(gCompanySafe_DOOR[rowid][COMPANYDOOR_OBJECTID]);
        gCompanySafe_DOOR[rowid][DOOR_STATUS] = DOOR_STATUS_EXPLODED;
    }
    return 1;
}
forward CompayDoorExplodeProgress(playerid,rowid);
public CompayDoorExplodeProgress(playerid,rowid) {
    if(GetCompanySafeDoorStatus(rowid) == DOOR_STATUS_EXPLODING) {
        new msg[255],Float:progressFloat;
        if(gCompanySafe_DOOR[rowid][COMPANYDOOR_PROGRESS]<100) {
            new Float:dist;
            dist=GetPlayerDistanceFromPoint(playerid,gCompanySafe_DOOR[rowid][COMPANYDOOR_COORDS][0],gCompanySafe_DOOR[rowid][COMPANYDOOR_COORDS][1],gCompanySafe_DOOR[rowid][COMPANYDOOR_COORDS][2]);
            if(dist>1.0) {
                SendVirtualWorldMessage(rowid,COLOR_YELLOW,"[ALERTA] O plantador afastou-se da porta, por isso a ação foi cancelada!");
                gCompanySafe_DOOR[rowid][DOOR_STATUS] = DOOR_STATUS_WAITING;
            }
            gCompanySafe_DOOR[rowid][COMPANYDOOR_PROGRESS]+=DOORPROGRESS_MIN + random(DOORPROGRESS_MAX);
            if(gCompanySafe_DOOR[rowid][COMPANYDOOR_PROGRESS]>100)gCompanySafe_DOOR[rowid][COMPANYDOOR_PROGRESS]=100;
            progressFloat=float(gCompanySafe_DOOR[rowid][COMPANYDOOR_PROGRESS]);
            format(msg,255,"Plantando %d%%",gCompanySafe_DOOR[rowid][COMPANYDOOR_PROGRESS]);
            for(new i=0;i<MAX_PLAYERS;i++) {
                if(GetPlayerVirtualWorld(i)==rowid) {
                    if(GetCompanySafeDoorStatus(rowid) == DOOR_STATUS_EXPLODING) {
                        SetPlayerTxdProgressText(i,msg);
                        SetPlayerTxdProgressProgress(i,progressFloat);
                    }
                    else {
                        HidePlayerTxdProgress(i);
                    }
                }
            }
        }
        else if(GetCompanySafeDoorStatus(rowid)== DOOR_STATUS_EXPLODING &&gCompanySafe_DOOR[rowid][COMPANYDOOR_PROGRESS]==100){
            OnCompanySafeDoorExplode(rowid,playerid);
        }
    }
    else {
        DeletePreciseTimer(gCompanySafe_DOOR[rowid][COMPANYDOOR_TIMERID]);
        gCompanySafe_DOOR[rowid][COMPANYDOOR_TIMERID]=0;
    }
    UpdateCompanySafeDOORText(rowid);
}
    /*
    Safe/Alarm functions
                            */
stock RegenCompanySafeLaser(rowid) {
    if(IsValidCompany(rowid)&&GetCompanySafeLaserStatus(rowid)==LASER_STATUS_OFF) {
        gCompanySafe_LASER[rowid][LASER_STATUS] = LASER_STATUS_WAITING;
        gCompanySafe_staticLASER[rowid][0]=CreateDynamicObject(18643,2141.766601,1606.728759,993.548034,0.0,0.0,0.0,rowid,ROBBERY_INTERIOR_ID);
        gCompanySafe_staticLASER[rowid][1]=CreateDynamicObject(18643,2141.926269,1606.677001,994.108398,0.0,0.0,0.0,rowid,ROBBERY_INTERIOR_ID);
        gCompanySafe_staticLASER[rowid][2]=CreateDynamicObject(18643,2141.370117,1606.693237,994.598083,0.0,0.0,0.0,rowid,ROBBERY_INTERIOR_ID);
        UpdateCompanySafeLASERText(rowid);
    }
    return 1;
}
stock DestroyCompanySafeLaser(rowid) {
    if(GetCompanySafeLaserStatus(rowid)==LASER_STATUS_WAITING||GetCompanySafeLaserStatus(rowid)==LASER_STATUS_HACKING) {
        gCompanySafe_LASER[rowid][LASER_STATUS] = LASER_STATUS_OFF;
        DestroyDynamicObject(gCompanySafe_staticLASER[rowid][0]);
        DestroyDynamicObject(gCompanySafe_staticLASER[rowid][1]);
        DestroyDynamicObject(gCompanySafe_staticLASER[rowid][2]);
        UpdateCompanySafeLASERText(rowid);
        for(new i;i<MAX_PLAYERS;i++) {
            if(GetPlayerVirtualWorld(i)==rowid) {
                ShowPlayerTxdbNotification(i);
                SetPlayerTxdbNotifText(i,"Alerta ~n~ O alarme foi desligado",4);
            }
        }
    }
    return 1;
}
public CompanyLaserHackProgress(playerid,rowid) {
    if(GetCompanySafeLaserStatus(rowid)==LASER_STATUS_HACKING) { // Fail-safe
        new Float:progressFloat;
        new msg[255];
        if(gCompanySafe_LASER[rowid][COMPANYLASER_PROGRESS]<100) {
            new Float:dist;
            dist=GetPlayerDistanceFromPoint(playerid,gCompanySafe_LASER[rowid][COMPANYLASER_COORDS][0],gCompanySafe_LASER[rowid][COMPANYLASER_COORDS][1],gCompanySafe_LASER[rowid][COMPANYLASER_COORDS][2]);
            if(dist>1.0) {
                SendVirtualWorldMessage(rowid,COLOR_YELLOW,"[ALERTA] O hacker afastou-se do keypad, por isso o hack foi cancelado!");
                gCompanySafe_LASER[rowid][LASER_STATUS] = LASER_STATUS_WAITING;
            }
            else {
                gCompanySafe_LASER[rowid][COMPANYLASER_PROGRESS]+=LASERPROGRESS_MIN + random(LASERPROGRESS_MAX);
                if(gCompanySafe_LASER[rowid][COMPANYLASER_PROGRESS]>100)gCompanySafe_LASER[rowid][COMPANYLASER_PROGRESS]=100;
                progressFloat=float(gCompanySafe_LASER[rowid][COMPANYLASER_PROGRESS]);
                format(msg,255,"Hackenado %d%%", gCompanySafe_LASER[rowid][COMPANYLASER_PROGRESS]);
                }
            for(new i=0;i<MAX_PLAYERS;i++) {
                if(GetPlayerVirtualWorld(i)==rowid) {
                    if(GetCompanySafeLaserStatus(rowid)== LASER_STATUS_HACKING) {
                        SetPlayerTxdProgressText(i,msg);
                        SetPlayerTxdProgressProgress(i,progressFloat);
                    }
                    else {
                        HidePlayerTxdProgress(i);
                    }
                }
            }
        }
        else if(GetCompanySafeLaserStatus(rowid)== LASER_STATUS_HACKING ){
            OnCompanyLaserHack(rowid,playerid);
        }
    }
    else {
        DeletePreciseTimer(gCompanySafe_LASER[rowid][COMPANYLASER_TIMERID]);
        gCompanySafe_LASER[rowid][COMPANYLASER_TIMERID]=0;
    }
    UpdateCompanySafeLASERText(rowid);
    return 1;
}
forward OnCompanyLaserHack(rowid,playerid);
public OnCompanyLaserHack(rowid,playerid) {
    if(GetCompanySafeLaserStatus(rowid)==LASER_STATUS_HACKING) { // Fail-safe
        DestroyCompanySafeLaser(rowid);
        SendVirtualWorldMessage(rowid,COLOR_YELLOW,"[ALERTA] O alarme foi hackeado, as autoridades não foram avisadas!");
        UpdateCompanySafeLASERText(rowid);
        for(new i=0;i<MAX_PLAYERS;i++) {
            if(GetPlayerVirtualWorld(i)==rowid) {
                HidePlayerTxdProgress(i);
            }
        }
    }
    return 1;
}
/*
    Text update functions
                            */
stock UpdateCompanySafeSAFEText(rowid) {
    if(IsValidCompany(rowid)) {
        new String:safeText[255];
        if(gCompanySafe_SAFE[rowid][SAFE_STATUS]==SAFE_STATUS_WAITING) {
            format(safeText,255,"Cofre\nDinheiro: R$%d\nAperte Y para plantar o drill.",GetCompanyCash(rowid));
        }
        if(gCompanySafe_SAFE[rowid][SAFE_STATUS] == SAFE_STATUS_PLANTING) {
            format(safeText,255,"Plantando drill %d%%",gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS]);
        }
        if(gCompanySafe_SAFE[rowid][SAFE_STATUS]==SAFE_STATUS_DRILLING) {
            format(safeText,255,"Drill em funcionamento %d%%",gCompanySafe_SAFE[rowid][COMPANYSAFE_PROGRESS]);
        }
        if(gCompanySafe_SAFE[rowid][SAFE_STATUS]==SAFE_STATUS_DRILLERROR) {
            format(safeText,255,"Erro no drill!\nUse Y para corrigir!");
        }
        if(gCompanySafe_SAFE[rowid][SAFE_STATUS]==SAFE_STATUS_DRILLFIX) {
            format(safeText,255,"Reparando drill %d%%",gCompanySafe_SAFE[rowid][COMPANYSAFE_RPROGRESS]);
        }
        if(gCompanySafe_SAFE[rowid][SAFE_STATUS]==SAFE_STATUS_ROBBED) {
            format(safeText,255,"Cofre DETONADO");
        }
        UpdateDynamic3DTextLabelText(gCompanySafe_SAFE[rowid][COMPANYSAFE_TEXT],-1,safeText);
    }
    else printf("[companysafe.pwn] WARN - Tried to update company safeText of invalid company id %d",rowid);
    return 1;
}


stock UpdateCompanySafeDOORText(rowid) {
    if(IsValidCompany(rowid)) {
        new String:doorText[255];
        if(gCompanySafe_DOOR[rowid][DOOR_STATUS]==DOOR_STATUS_WAITING) {
            format(doorText,255,"Porta de Segurança\nAperte Y para interagir!");
        }
        if(gCompanySafe_DOOR[rowid][DOOR_STATUS]==DOOR_STATUS_EXPLODING) {
            format(doorText,255,"Plantando %d%%",gCompanySafe_DOOR[rowid][COMPANYDOOR_PROGRESS]);
        }
        if(gCompanySafe_DOOR[rowid][DOOR_STATUS]==DOOR_STATUS_EXPLODED) {
            format(doorText,255,"Porta aberta ou detonada!");
        }
        UpdateDynamic3DTextLabelText(gCompanySafe_DOOR[rowid][COMPANYDOOR_TEXT],-1,doorText);
    }
    else printf("[companysafe.pwn] WARN - Tried to update company doorText  of invalid company id %d",rowid);
    return 1;
}

stock UpdateCompanySafeLASERText(rowid) {
    if(IsValidCompany(rowid)) {
        new String:laserText[255];
        if(gCompanySafe_LASER[rowid][LASER_STATUS] == LASER_STATUS_WAITING) {
            format(laserText,255,"Sistema de segurança ligado\nAperte Y para interagir!");
        }
        if(gCompanySafe_LASER[rowid][LASER_STATUS] == LASER_STATUS_HACKING) {
            format(laserText,255,"Hackeando %d%%",gCompanySafe_LASER[rowid][COMPANYLASER_PROGRESS]);
        }
        if(gCompanySafe_LASER[rowid][LASER_STATUS] == LASER_STATUS_OFF) {
            format(laserText,255,"Sistema de segurança desligado!\nAperte Y para interagir!");
        }
        if(gCompanySafe_LASER[rowid][LASER_STATUS] == LASER_STATUS_ALARM) {
            format(laserText,255,"Sistema de segurança ancionado!\nAs autoridades foram avisaadas.\nAperte Y para interagir");
        }
        UpdateDynamic3DTextLabelText(gCompanySafe_LASER[rowid][COMPANYSAFE_TEXT],-1,laserText);
    }
    else printf("[companysafe.pwn] WAN - Treid to update company laserText of invalid company id %d",rowid);
    return 1;
}

/*
    Retrurns company safe location by reference
    Now, since all of them are the same I know this is a little bit redundant,
    but the goal is to make it eaiser to change interiors in the future
                                                                        */
forward GetCompanySafeLocationPtrs(rowid,&Float:x,&Float:y,&Float:z);
public GetCompanySafeLocationPtrs(rowid,&Float:x,&Float:y,&Float:z) {
    if(IsValidCompany(rowid)) {
        x=gCompanySafe_EXIT[rowid][COMPANYEXIT_COORDS][0];
        y=gCompanySafe_EXIT[rowid][COMPANYEXIT_COORDS][1];
        z=gCompanySafe_EXIT[rowid][COMPANYEXIT_COORDS][2];
        return 1;
    }
    return 0;
}
stock GetCompanySafeSafeStatus(rowid) {
    return gCompanySafe_SAFE[rowid][SAFE_STATUS];
}
stock GetCompanySafeDoorStatus(rowid) {
    return gCompanySafe_DOOR[rowid][DOOR_STATUS];
}
stock GetCompanySafeLaserStatus(rowid) {
    if(IsValidCompany(rowid)) {
        return gCompanySafe_LASER[rowid][LASER_STATUS];
    }
}
stock IsPlayerInCompanySafe(playerid) {
    return gPlayer_CompanySafe[playerid];
}
stock SetPlayerCompanySafe(playerid,bool) {
    gPlayer_CompanySafe[playerid]=bool;
    return 1;
}
hook OnPlayerDeath(playerid, killerid, reason) {
    PlayerPlaySound(playerid,0,0.0,0.0,0.0);
    gPlayer_CompanySafe[playerid]=0;
    return 1;
}
hook OnPlayerDisconnect(playerid, reason) {
    gPlayer_CompanySafe[playerid]=0;
    return 1;
}

