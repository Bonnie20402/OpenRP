


#define COMPANYMGR_MAIN 700
#define COMPANYMGR_COOWNER 701
#define COMPANYMGR_DEPOSIT 702
#define COMPANYMGR_WITHDRAW 703
#define COMPANYMGR_SELLCOMPANY 704
#define COMPANYMGR_CHANGEFEE 705

#define MAX_FEE 1000 // Max entrance fee company owners can set.

#include <YSI_Coding\y_hooks>
new gCompanyManager[MAX_PLAYERS]; // Company id of players managing a company
/*
    Shows comapny maanger main menu
                                */
forward OpenCompanyMgrMenu(playerid,rowid);
public OpenCompanyMgrMenu(playerid,rowid) {
    new msg[255];
    new title[255];
    gCompanyManager[playerid]=rowid;
    format(title,255,"Gestor de Empresas [%d]",rowid);
    format(msg,255,"Mudar Taxa de Entrada\nAtualizar Sub-Dono\nDepositar dinhero no Cofre\nLevantar dinheiro do Cofre\nAbandonar Gestão da empresa");
    ShowPlayerDialog(playerid,COMPANYMGR_MAIN,DIALOG_STYLE_LIST,title,msg,"Proximo","Sair");
    return 1;
}
/*
    Handles menu responses to sub-menus
                                                        */
hook OnDialogResponse(playerid,dialogid,response,listitem,inputtext[]) {
    if(gCompanyManager[playerid]) {
        new msg[255];
        new title[255];
        if(dialogid==COMPANYMGR_MAIN) {
            if(listitem==0)  {// Changing entrance fee
                format(title,255,"Ajustar a Taxa de Entrada [%d]",gCompanyManager[playerid]);
                format(msg,255,"Indique o valor da taxa de entrada em baixo");
                ShowPlayerDialog(playerid,COMPANYMGR_CHANGEFEE,DIALOG_STYLE_INPUT,title,msg,"Defenir","Cancelar");
            }
            if(listitem==1) {//Atualizar Sub-Dono
                format(title,255,"Mudar o Sub-Dono [%d]",gCompanyManager[playerid]);
                format(msg,255,"Indique o ID do novo Sub-Dono\nEscreva -1 para limpar o Sub-Dono");
                ShowPlayerDialog(playerid,COMPANYMGR_COOWNER,DIALOG_STYLE_INPUT,title,msg,"Defenir","Cancelar");
            }
            if(listitem==2) { // Deposit
                new rowid;
                rowid=gCompanyManager[playerid];
                format(title,255,"Efetuar Deposito [%d]",gCompanyManager[playerid]);
                format(msg,255,"Saldo atual: R$%d\nInsere o valor a depositar",gCompanies[rowid][COMPANY_CASH]);
                ShowPlayerDialog(playerid,COMPANYMGR_DEPOSIT,DIALOG_STYLE_INPUT,title,msg,"Depositar","Cancelar");
            }
            if(listitem==3) { // Withdraw
                new rowid;
                rowid=gCompanyManager[playerid];
                format(title,255,"Efetuar Levantamento [%d]",gCompanyManager[playerid]);
                format(msg,255,"Saldo atual: R$%d\nInsere o valor a levantar",gCompanies[rowid][COMPANY_CASH]);
                ShowPlayerDialog(playerid,COMPANYMGR_WITHDRAW,DIALOG_STYLE_INPUT,title,msg,"Levantar","Cancelar");
            }
            if(listitem==4)  {// Sell company
                new rowid;
                rowid=gCompanyManager[playerid]; //TODO adjust new line on msg
                format(title,255,"Abandonar Empresa [%d]",gCompanyManager[playerid]);
                format(msg,255,"Desejas mesmo abandonar a tua empresa?\n");
                if(IsPlayerCompanyCoowner(playerid,rowid))format(msg,255,"%sO dono da empresa poderá contratar outro Sub-Dono",msg);
                else format(msg,255,"%sTodo o dinheiro do cofre será destruido.",msg);
                ShowPlayerDialog(playerid,COMPANYMGR_SELLCOMPANY,DIALOG_STYLE_MSGBOX,title,msg,"Abandonar","Cancelar");
            }
        }
    }
    return 1;
}
/*
    Handles inputs
                        */
#include <YSI_Coding\y_hooks>
hook OnDialogResponse(playerid,dialogid,response,listitem,inputtext[]) {
    if(gCompanyManager[playerid]&&dialogid!=COMPANYMGR_MAIN) {
        new msg[255];
        new title[255];
        if(dialogid==COMPANYMGR_CHANGEFEE&&response) {
            new rowid;
            rowid=gCompanyManager[playerid];
            new fee;
            sscanf(inputtext,"i",fee);
            if(fee>0&&fee<=MAX_FEE) {
                gCompanies[rowid][COMPANY_ENTRANCEFEE]=fee;
                format(msg,255,"A taxa de entrada foi ajustada para R$%d",fee);
                SendClientMessage(playerid,COLOR_YELLOW,msg);
                PrepareSaveCompany(rowid);
                UpdateCompanyTextLabel(rowid);
                return 1;
            }
            format(msg,255,"A taxa de entrada deve estar entre R$0 e R$%d",MAX_FEE);
            SendClientMessage(playerid,COLOR_RED,msg);
            return 1;
        }
        if(dialogid==COMPANYMGR_COOWNER&&response) {
            new rowid;
            rowid=gCompanyManager[playerid];
            new targetid;
            sscanf(inputtext,"i",targetid);
            if(!IsPlayerCompanyOwner(playerid,rowid)) {
                SendClientMessage(playerid,COLOR_YELLOW,"Apenas o dono da empresa pode demitir ou contratar sub-donos!");
                return 1;
            }
            if(IsPlayerConnected(targetid)) { // TODO check if targetid is not playerid
                if(targetid==playerid) {
                    SendClientMessage(playerid,COLOR_YELLOW,"Não podes ser o Sub-Dono da tua própria empresa!");
                    return 1;
                }
                format(gCompanies[rowid][COMPANY_COOWNER],64,"%s",GetPlayerNameEx(targetid));
                format(msg,255,"O Sub-Dono foi ajustado para %s[%d]",GetPlayerNameEx(targetid),targetid);
                SendClientMessage(playerid,COLOR_YELLOW,msg);
                UpdateCompanyTextLabel(rowid);
                PrepareSaveCompany(rowid);
            }
            else if(targetid==-1) {
                format(gCompanies[rowid][COMPANY_COOWNER],64,"%s","Ninguém");
                SendClientMessage(playerid,COLOR_YELLOW,"O Sub-Dono da tua empresa foi demitido.");
                UpdateCompanyTextLabel(rowid);
                PrepareSaveCompany(rowid);
                return 1;
            }
            else SendClientMessage(playerid,COLOR_RED,"Esse ID não corresponde a nenhum jogador!");
        }
        if(dialogid==COMPANYMGR_DEPOSIT&&response) { // TODO allow depositing from bank account as well.
            new rowid;
            rowid=gCompanyManager[playerid];
            new depositValue;
            sscanf(inputtext,"i",depositValue);
            if(depositValue<=0) {
                SendClientMessage(playerid,COLOR_RED,"O valor tem que ser superior a 0");
                return 1;
            }
            if(GetPlayerMoney(playerid)>=depositValue) {
                GivePlayerMoney(playerid,-depositValue);
                gCompanies[rowid][COMPANY_CASH]+=depositValue;
                format(msg,255,"Depositaste R$%d na empresa. Agora, o cofre da empresa possui R$%d",depositValue,gCompanies[rowid][COMPANY_CASH]);
                SendClientMessage(playerid,COLOR_YELLOW,msg);
                UpdateCompanyTextLabel(rowid);
                PrepareSaveCompany(rowid);
            }
            else SendClientMessage(playerid,COLOR_YELLOW,"Não tens esse dinheiro todo!");
        }
        if(dialogid==COMPANYMGR_WITHDRAW&&response) { // TODO allow withdrawing from bank account as well.
            new rowid;
            rowid=gCompanyManager[playerid];
            new withdrawValue;
            sscanf(inputtext,"i",withdrawValue);
            if(withdrawValue<=0) {
                SendClientMessage(playerid,COLOR_RED,"O valor tem que ser superior a 0");
                return 1;
            }
            if(gCompanies[rowid][COMPANY_CASH]>=withdrawValue) {
                GivePlayerMoney(playerid,withdrawValue);
                gCompanies[rowid][COMPANY_CASH]-=withdrawValue;
                format(msg,255,"Levantaste R$%d do cofre da empresa. Agora, o cofre da empresa possui R$%d",withdrawValue,gCompanies[rowid][COMPANY_CASH]);
                SendClientMessage(playerid,COLOR_YELLOW,msg);
                UpdateCompanyTextLabel(rowid);
                PrepareSaveCompany(rowid);
            }
            else SendClientMessage(playerid,COLOR_YELLOW,"O cofre da tua empresa não tem esse dinheiro todo!");
        }
        if(dialogid==COMPANYMGR_SELLCOMPANY&&response) {
            new rowid;
            rowid=gCompanyManager[playerid];
            if(IsPlayerCompanyCoowner(playerid,rowid)) { // Se for sub-dono
                format(gCompanies[rowid][COMPANY_COOWNER],64,"%s",DONO_NULL);
                UpdateCompanyTextLabel(rowid);
                PrepareSaveCompany(rowid);
                SendClientMessage(playerid,COLOR_YELLOW,"Já não és mais Sub-Dono da empresa.");
                return 1;
            }
            SendClientMessage(playerid,COLOR_YELLOW,"Abandonaste a tua empresa. Agora, outro jogador poderá adquiri-la!");
            gCompanies[rowid][COMPANY_CASH]=0;
            format(gCompanies[rowid][COMPANY_OWNER],64,"Ninguém");
            format(gCompanies[rowid][COMPANY_COOWNER],64,"Ninguém");
            UpdateCompanyTextLabel(rowid);
            PrepareSaveCompany(rowid);
        }
        gCompanyManager[playerid]=0;
    }
    return 1;
}
// TODO continuar empresas binco,banco, centoro licenaçs, tirei print da loc do banco e das coords exit e shop
// TODO house system
hook OnPlayerDisconnect(playerid,reason) {
    gCompanyManager[playerid]=0;
    return 1;
}