#define INVDLG_SEPARATE 2025
#define INVACDIALOG_EMPTY 131211
#include <YSI_Coding\y_hooks>

forward OnPlayerInvActionSeparate(playerid,modelid,quantity);
public OnPlayerInvActionSeparate(playerid,modelid,quantity) {
    ShowPlayerDialog(playerid,INVDLG_SEPARATE,DIALOG_STYLE_INPUT,"Separar item","Introduz a quantidade que desejas separar.","Separar","Cancelar");
    return 1;

}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid==INVDLG_SEPARATE) {
        if(response) {
            new separateQuantity,modelid,currentQuantity,emptySlot;
            separateQuantity = strval(inputtext);
            modelid = GetPlayerInvSelectedItemEx(playerid);
            emptySlot=GetPlayerInvEmptySlot(playerid);
            currentQuantity = GetPlayerInvItemQuantity(playerid,modelid);
            if(emptySlot==-1) {
                ShowPlayerDialog(playerid,INVACDIALOG_EMPTY,DIALOG_STYLE_MSGBOX,"Ups!","O teu inventario está cheio.\nTenta descartar ou juntar alguns itens primeiro.","OK","");
                return 0;
            }
            if(!separateQuantity)ShowPlayerDialog(playerid,INVACDIALOG_EMPTY,DIALOG_STYLE_MSGBOX,"Ups!","Deves introduzir um valor positivo","OK","");
            else if(separateQuantity>=currentQuantity)ShowPlayerDialog(playerid,INVACDIALOG_EMPTY,DIALOG_STYLE_MSGBOX,"Ups!","O valor a separar deve ser inferior ao valor total de itens\nTente outra vez","OK","");
            else {
                SeparatePlayerInvItem(playerid,modelid,separateQuantity);
                RefreshPlayerInv(playerid);
                ShowPlayerDialog(playerid,INVACDIALOG_EMPTY,DIALOG_STYLE_MSGBOX,"Feito","Item separado com sucesso!","OK","");
                PrepareSavePlayerInventory(playerid);
            } 
        }
        else {
            ShowPlayerDialog(playerid,INVACDIALOG_EMPTY,DIALOG_STYLE_MSGBOX,"Feito","Ação cancelada com sucesso.","OK","");
            return 1;
        }
        SetPlayerInvSelectedItem(playerid,-1);

    }
    return 1;
}