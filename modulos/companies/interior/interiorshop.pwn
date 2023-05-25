
enum INTERIORSHOP {
    INTERIORSHOP_MODELID,
    INTERIORSHOP_PRICE,
    INTERIORSHOP_LISTITEM // Keep track of item list in dialogs. They start from zero, therefore it's always the same value as the index. 
}

#define INTERIOR_SHOP_MAX_ITENS 64

new gInteriorShop[MAX_PLAYERS][INTERIOR_SHOP_MAX_ITENS][INTERIORSHOP];

//TODO: Add payment methods (in hand money VS in debit card)
stock CompanyDialog:ShowInteriorShopDialog(playerid) {
    new selectedItem,quantity,price,String:dBody[512];
    inline SubmitOrder(responseC,listitemC,String:inputtextC[]) {
        if(!responseC)return Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Adeus","Saiste do menu de compras.","OK");
        new currentMoney = GetPlayerMoney(playerid);
        if(currentMoney>=price) {
            new rowid = GetPlayerVirtualWorld(playerid);
            GivePlayerMoney(playerid,-price);
            GivePlayerInvItem(playerid,selectedItem,quantity);
            SendClientMessagef(playerid,-1,"Compraste %d %s por R$ %d",quantity,GetItemNameString(selectedItem),price);
            gCompanies[rowid][COMPANY_CASH]+=price;
            UpdateCompanyTextLabel(rowid);
            PrepareSaveCompany(rowid);
        }
        else return Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Ups!","Não tens dinheiro suficiente","OK","");
    }
    inline ConfirmPurchase(responseB,listitemB,String:inputtextB[]) {
        quantity=strval(StinputtextB);
        if(!responseB)return Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Adeus","Saiste do menu de compras.","OK");
        if(quantity <=0) return Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Ups","A quantidade deve ser um valor positivo!","OK","");
        price*=quantity;
        format(dBody,512,"Irás adquirir %d %s(s) por R$ %d\nContinuar?",quantity,GetItemNameString(selectedItem),price); 
        Dialog_ShowCallback(playerid,using inline SubmitOrder,DIALOG_STYLE_MSGBOX,"Confirmar...",dBody,"Adquirir","Cancelar");
    }
    inline SetupQuantity(responseA,listitemA,String:inputtextA[]) {
        if(!responseA)return Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Adeus","Saiste do menu de compras.","OK","");
        price=gInteriorShop[playerid][listitemA][INTERIORSHOP_PRICE]; // cut R$ from the string R - [0] $ - [1]
        selectedItem=gInteriorShop[playerid][listitemA][INTERIORSHOP_MODELID];
        format(dBody,512,"Escolheste adquirir %s.\nPreço por unidade: R$ %d\nIntroduz a quantidade:",GetItemNameString(gInteriorShop[playerid][listitemA][INTERIORSHOP_MODELID]),gInteriorShop[playerid][listitemA][INTERIORSHOP_PRICE]);
        Dialog_ShowCallback(playerid,using inline ConfirmPurchase,DIALOG_STYLE_INPUT,"Quantidade",dBody,"Continuar","Cancelar");
    }
    format(dBody,512,"Item\tPreço");
    for(new i;i<INTERIOR_SHOP_MAX_ITENS;i++) {
        if(gInteriorShop[playerid][i][INTERIORSHOP_MODELID] != ITEM_INVALID) {
            format(dBody,512,"%s\n%s\tR$ %d",dBody,GetItemNameString(gInteriorShop[playerid][i][INTERIORSHOP_MODELID]),gInteriorShop[playerid][i][INTERIORSHOP_PRICE]);
        }
    }
    Dialog_ShowCallback(playerid,using inline SetupQuantity,DIALOG_STYLE_TABLIST_HEADERS,"Menu de Compras",dBody,"Escolher","Sair");
    return 1;
}


// Clears any previous dialogshop values. Should be called before adding the items and displaying the dialog. This is the first thing you call!
stock InteriorDialogs:DialogShopInit(playerid) {
    for(new i;i<INTERIOR_SHOP_MAX_ITENS;i++) {
        gInteriorShop[playerid][i][INTERIORSHOP_MODELID] = ITEM_INVALID;
        gInteriorShop[playerid][i][INTERIORSHOP_PRICE] = 0;
    }
    return 1;
}

/* Gets nearest free DialogShop slot. Returns -1 if none found */
stock InteriorDialogs:GetDialogShopIndex(playerid) {
    for(new i;i<INTERIOR_SHOP_MAX_ITENS;i++) {
        if(gInteriorShop[playerid][i][INTERIORSHOP_MODELID]==ITEM_INVALID)return i;
    }
    return -1;
}

stock InteriorDialogs:AddDialogShopItem(playerid,modelid,price) {
    new index = GetDialogShopIndex(playerid);
    gInteriorShop[playerid][index][INTERIORSHOP_MODELID]=modelid;
    gInteriorShop[playerid][index][INTERIORSHOP_PRICE]=price;
    gInteriorShop[playerid][index][INTERIORSHOP_LISTITEM]=index;
    return 1;
}