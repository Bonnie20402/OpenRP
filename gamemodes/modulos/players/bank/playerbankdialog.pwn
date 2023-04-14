
#define PLAYERBANKDIALOG_MAIN 8001
#define PLAYERBANKDIALOG_DEPOSIT 8002
#define PLAYERBANKDIALOG_WITHDRAW 8003

#include <YSI_Coding\y_hooks>

forward ShowPlayerBankAccountMenu(playerid,menuid);
public ShowPlayerBankAccountMenu(playerid,menuid) {
    new String:msg[255];
    if(menuid==PLAYERBANKDIALOG_MAIN) {
        new money;
        money=GetPlayerBankAccount(playerid);
        format(msg,255,"Meu Saldo:\t R$%d\n\
        Depositar\tDepositar um valor na sua conta bancaria\n\
        Levantar\tLevantar um valor da sua conta bancaria\n",money);
        ShowPlayerDialog(playerid,PLAYERBANKDIALOG_MAIN,DIALOG_STYLE_TABLIST,"Menu do Banco",msg,"Selecionar","Sair");
    }
    if(menuid==PLAYERBANKDIALOG_DEPOSIT) {
        format(msg,255,"Indica o valor a depositar");
        ShowPlayerDialog(playerid,PLAYERBANKDIALOG_DEPOSIT,DIALOG_STYLE_INPUT,"Depositar",msg,"Depositar","Voltar");
    }
    if(menuid==PLAYERBANKDIALOG_WITHDRAW) {
        format(msg,255,"Indica o valor a levantar");
        ShowPlayerDialog(playerid,PLAYERBANKDIALOG_WITHDRAW,DIALOG_STYLE_INPUT,"Levantar",msg,"Levantar","Voltar");
    }
    return 1;
}

hook OnDialogResponse(playerid,dialogid,response,listitem,inputtext[]) {
    if(dialogid==PLAYERBANKDIALOG_MAIN) {
        if(!response)return 1;
        switch(listitem) {
            case 0:
                return 1;
            case 1:
                ShowPlayerBankAccountMenu(playerid,PLAYERBANKDIALOG_DEPOSIT);
            case 2:
                ShowPlayerBankAccountMenu(playerid,PLAYERBANKDIALOG_WITHDRAW);
        }
    }
    if(dialogid==PLAYERBANKDIALOG_DEPOSIT) {
        if(!response) return 1;
        new handMoney,depositMoney;
        handMoney=GetPlayerMoney(playerid);
        depositMoney=strval(inputtext);
        if(depositMoney<=0) {
            SendClientMessage(playerid,COLOR_YELLOW,"O valor deve ser positivo!");
            return 1;
        }
        if(handMoney-depositMoney>=0) {
            ResetPlayerMoney(playerid);
            GivePlayerMoney(playerid,handMoney-depositMoney);
            gBankAccount[playerid]=gBankAccount[playerid]+depositMoney;
            PrepareSavePlayerBankAccount(playerid);
            ShowPlayerBankAccountMenu(playerid,PLAYERBANKDIALOG_MAIN);
            return 1;
        }
        SendClientMessage(playerid,COLOR_YELLOW,"Não tens esse dinheiro todo em mãos!");
        return 1;
    }
    if(dialogid==PLAYERBANKDIALOG_WITHDRAW) {
        if(!response) return 1;
        new withdrawMoney,bankMoney;
        bankMoney=GetPlayerBankAccount(playerid);
        withdrawMoney=strval(inputtext);
        if(withdrawMoney<=0) {
            SendClientMessage(playerid,COLOR_YELLOW,"O valor deve ser positivo!");
            return 1;
        }
        if(bankMoney-withdrawMoney>=0) {
            gBankAccount[playerid]=gBankAccount[playerid]-withdrawMoney;
            PrepareSavePlayerBankAccount(playerid);
            GivePlayerMoney(playerid,withdrawMoney);
            return 1;
        }
        SendClientMessage(playerid,COLOR_YELLOW,"A tua conta bancaria não tem dinheiro suficiente!");
    }
    return 1;
}
YCMD:banco(playerid,params[],help) {
    ShowPlayerBankAccountMenu(playerid,PLAYERBANKDIALOG_MAIN);
    return 1;
}
YCMD:rbanco(playerid,params[],help) {
    gBankAccount[playerid]=0;
    ResetPlayerMoney(playerid);
    return 1;
}