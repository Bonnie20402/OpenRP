
stock CompanyDialog:ShowRestaurantDialog(playerid) {
    new p=playerid;
    new selectedItem,quantity,price,String:dBody[255];
    inline SubmitOrder(responseC,listitemC,String:inputtextC[]) {
        if(!responseC)return Dialog_Show(p,DIALOG_STYLE_MSGBOX,"Adeus","Saiste do menu de compras.");
        new currentMoney = GetPlayerMoney(p);
        if(currentMoney>=price) {
            new rowid = GetPlayerVirtualWorld(p);
            GivePlayerMoney(p,-price);
            GivePlayerInvItem(p,selectedItem,quantity);
            SendClientMessagef(p,-1,"Compraste %d %s por R$ %d",quantity,GetItemNameString(selectedItem),price);
            gCompanies[rowid][COMPANY_CASH]+=price;
            UpdateCompanyTextLabel(rowid);
            PrepareSaveCompany(rowid);
        }
        else return Dialog_Show(p,DIALOG_STYLE_MSGBOX,"Ups!","Não tens dinheiro suficiente","OK","");
    }
    inline ConfirmPurchase(responseB,listitemB,String:inputtextB[]) {
        quantity=strval(StinputtextB);
        if(!responseB)return Dialog_Show(p,DIALOG_STYLE_MSGBOX,"Adeus","Saiste do menu de compras.");
        if(quantity <=0) return Dialog_Show(p,DIALOG_STYLE_MSGBOX,"Ups","A quantidade deve ser um valor positivo!","OK","");
        price*=quantity;
        format(dBody,255,"Irás adquirir %d %s(s) por R$ %d\nContinuar?",quantity,GetItemNameString(selectedItem),price); 
        Dialog_ShowCallback(p,using inline SubmitOrder,DIALOG_STYLE_MSGBOX,"Confirmar...",dBody,"Adquirir","Cancelar");
    }
    inline SetupQuantity(responseA,listitemA,String:inputtextA[]) {
        if(!responseA)return Dialog_Show(p,DIALOG_STYLE_MSGBOX,"Adeus","Saiste do menu de compras.");
        price=strval(StinputtextA[2]); // cut R$ from the string R - [0] $ - [1]
        switch(listitemA) {
            case 0:
                selectedItem=ITEM_PIZZA;
            case 1:
                selectedItem=ITEM_SUMOLARANJA;
            case 2:
                selectedItem=ITEM_SUMOMACA;
            case 3:
                selectedItem=ITEM_TACO;
            case 4:
                selectedItem=ITEM_HAMBURGER;
        }
        format(dBody,255,"Escolheste adquirir %s.\nPreço por unidade: R$ %d\nIntroduz a quantidade:",GetItemNameString(selectedItem),price);
        Dialog_ShowCallback(p,using inline ConfirmPurchase,DIALOG_STYLE_INPUT,"Quantidade",dBody,"Continuar","Cancelar");
    }
    Dialog_ShowCallback(p,using inline SetupQuantity,DIALOG_STYLE_TABLIST_HEADERS,"Restaurante 1",\
    "Preço\tItem\n\
    R$300\t Pizza\n\
    R$100\t Sumo de laranja\n\
    R$100\t Sumo de maçã\n\
    R$250\t Taco\n\
    R$250\t Hamburger\n\
    ","Adquirir","Cancelar");
    return 1;
}