
forward InvAction:OnPlayerInvActionJoin(playerid,modelid,quantity);
public InvAction:OnPlayerInvActionJoin(playerid,modelid,quantity) {
    if(modelid==ITEM_INVALID||!quantity) return 1;
    new selectedIndex=GetPlayerInvSelectedItemIndex(playerid);
    new dBody[1024];
    new totalFound;
    new iQuantity = GetPlayerInvItemQuantity(playerid,selectedIndex);
    totalFound+=iQuantity;
    format(dBody,1024,"Juntou %s com\n",GetItemNameString(modelid));
    for(new j;j<INVENTORY_REALSIZE;j++) {
        if(GetPlayerInvModelid(playerid,selectedIndex) == GetPlayerInvModelid(playerid,j) && selectedIndex!=j) {
            new jQuantity=GetPlayerInvItemQuantity(playerid,j);
            totalFound+=jQuantity;
            format(dBody,1024,"%s+%d, encontrados no slot %d\n",dBody,jQuantity,j);
            SetPlayerInvItem(playerid,selectedIndex,modelid,totalFound);
            SetPlayerInvItem(playerid,j,ITEM_INVALID,0);
        }
    }
    SetPlayerInvSelectedItem(playerid,-1);
    if(totalFound==iQuantity) Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Ups!","Não existe nada a juntar.","OK","");
    else {
        format(dBody,1024,"%s\nTotal: %d items",dBody,totalFound);
        PrepareSavePlayerInventory(playerid);
        Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Feito!",dBody,"OK","");
        RefreshPlayerInv(playerid);
    }
    return 1;
}