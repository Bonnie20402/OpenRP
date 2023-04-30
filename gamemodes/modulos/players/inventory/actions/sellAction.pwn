
/*
    Inventory Module - Sub-module sellAction
    Makes players able to sell their inventory items to other in-range players.
    They can pay by money or by bank.
                                */

#define MAX_OFFERS 250 
#define INVSELL_DISTANCE 25.0
#define INVSELL_EXPIRETIME 20 // Offer expire time, in seconds.

#include <YSI_Coding\y_hooks>

enum SELLHANDLER {
    SELLHANDLER_INDEX,
    SELLHANDLER_MODELID,
    SELLHANDLER_QUANTITY,
    SELLHANDLER_WAITINGREPLY,
    SELLHANDLER_PRICE,
    SELLHANDLER_TARGETID,
    SELLHANDLER_EXPIRETIME
}
new gInv_control_sellHandler[MAX_PLAYERS][SELLHANDLER];



hook OnPlayerConnect(playerid) {
    ResetPlayerOffer(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    ResetPlayerOffer(playerid);
    return 1;
}
forward OnPlayerInvActionSell(playerid,modelid,quantity);
public OnPlayerInvActionSell(playerid,modelid,quantity) {
    if(modelid==ITEM_INVALID)return 1;
    inline const NoPlayersNearbyResponse(response,listitem,String:inputtext[]) {
        #pragma unused listitem
        if(response)return 1;
        //TODO Open the server market
        else return Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Ups!","O mercado ainda não existe. Fica atento ás novidades no discord!","OK","");
    }

    new Float:x,Float:y,Float:z,String:msg[1024],qtt;
    format(msg,1024,"Nome\tNivel\n");
    for(new i;i<MAX_PLAYERS;i++) {
        if(IsPlayerConnected(i)&&IsPlayerLoggedIn(playerid)&&playerid!=i) {
            GetPlayerPos(i,x,y,z);
            if(GetPlayerDistanceToPointEx(playerid,x,y,z)<=INVSELL_DISTANCE) {
                qtt++;
                format(msg,1024,"%s%s\t%d\n",msg,GetPlayerNameEx(i),0); // TODO Replace level placeholder with actual player level
            }
        }
        if(qtt)  {
            Dialog_ShowCallback(playerid,using public OnPlayerInvSellTargetSet<iiiis>,DIALOG_STYLE_TABLIST_HEADERS,"Seleciona um jogador",msg,"Selecionar","Cancelar");
            gInv_control_sellHandler[playerid][SELLHANDLER_INDEX]=GetPlayerInvSelectedItemIndex(playerid);
            gInv_control_sellHandler[playerid][SELLHANDLER_MODELID]=modelid;
            gInv_control_sellHandler[playerid][SELLHANDLER_QUANTITY]=quantity;
            gInv_control_sellHandler[playerid][SELLHANDLER_EXPIRETIME]=INVSELL_EXPIRETIME;
        }
        else Dialog_ShowCallback(playerid,using inline NoPlayersNearbyResponse,DIALOG_STYLE_MSGBOX,"Ups!","Não existem jogadores por perto.\nPodes tentar vender o teu item no Mercado do servidor","OK","Abrir Mercado");
    }
    return 1;
}

// Price input and validation logic. Uses ysi's inline libary.
public OnPlayerInvSellTargetSet(playerid, dialogid, response, listitem,const inputtext[]) {
    // Offer cancel logic
    inline const offerCancelResponse(response,listitem,string:cancelText[]) {
        #pragma unused listitem,cancelText,response
        gInv_control_sellHandler[playerid][SELLHANDLER_WAITINGREPLY] = 0;
        Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Tudo feito","A tua oferta foi cancelada.\nO jogador já não poderá aceitá-la.","OK");
        ResetPlayerOffer(playerid);
    }
    // Once target picks up a payment type set.
    inline const offerConcludePaymentTypeSet(targetid,dlgid,response,listitem,String:paymentText[]) {
        new fromid=GetPlayerOfferFromID(targetid);
        if(response) {
            if(fromid==INVALID_PLAYER_ID) return Dialog_Show(targetid,DIALOG_STYLE_MSGBOX,"Ups!","Parece que a oferta expirou.","OK","");
            new currentMoney,price,chosenOption;
            chosenOption=listitem;
            price=gInv_control_sellHandler[fromid][SELLHANDLER_PRICE];
            if(!chosenOption) currentMoney = GetPlayerMoney(targetid); // Hand money
            else if(chosenOption) currentMoney = GetPlayerBankAccount(targetid); // Bank account money
            new subtractMoney=currentMoney-price;
            if(subtractMoney>=0) {
                new modelid,quantity,outputMessage[255];
                format(outputMessage,255,"A oferta foi aceite.\nO jogador pagou via ");
                modelid=gInv_control_sellHandler[fromid][SELLHANDLER_MODELID];
                quantity=gInv_control_sellHandler[fromid][SELLHANDLER_QUANTITY];
                if(!chosenOption) { // Chosen option is by hand money
                    GivePlayerMoney(fromid,price);
                    GivePlayerMoney(targetid,-price);
                    format(outputMessage,255,"%s dinheiro em maos.\nO dinheiro foi parar em suas maos.",outputMessage);
                }
                else if(chosenOption) { // Chosen option is bank account.
                    format(outputMessage,255,"%s conta bancaria.\nO montante foi transferido para a sua conta bancaria.",outputMessage);
                    SetPlayerBankAccountMoney(fromid,GetPlayerBankAccount(fromid)+price);
                    SetPlayerBankAccountMoney(targetid,subtractMoney);
                }
                SetPlayerInvItem(fromid,gInv_control_sellHandler[fromid][SELLHANDLER_INDEX],ITEM_INVALID,0);
                GivePlayerInvItem(targetid,modelid,quantity);
                Dialog_Show(fromid,DIALOG_STYLE_MSGBOX,"Concluido",outputMessage,"OK","");
                Dialog_Show(targetid,DIALOG_STYLE_MSGBOX,"Concluido","Aceitaste a oferta e os itens foram adicionados ao teu inventario.","OK","");
                PrepareSavePlayerInventory(fromid);
                PrepareSavePlayerInventory(targetid);
                RefreshPlayerInv(fromid);
                RefreshPlayerInv(targetid);
                
            }
            else {
                Dialog_Show(fromid,DIALOG_STYLE_MSGBOX,"Ups!","Parece que o jogador não tem dinheiro suficiente.\nA oferta foi cancelada.","OK","");
                Dialog_Show(targetid,DIALOG_STYLE_MSGBOX,"Ups!","Não tens dinheiro suficiente para pagar por essa via.\nA oferta foi cancelada.","OK","");
            }
            ResetPlayerOffer(fromid);
        }
        else {
            Dialog_Show(fromid,DIALOG_STYLE_MSGBOX,"Ups!","Parece que o jogador mudou de ideias e rejeitou a sua oferta.","OK","");
            ResetPlayerOffer(fromid);
            Dialog_Show(targetid,DIALOG_STYLE_MSGBOX,"Concluido","A oferta foi rejeitada.\nO outro jogador foi avisado.","OK");
        }
    }
    // The answer to the offer logic. Handles offer rejection/acceptance too.
    inline const offerConcludeResponse(targetid,dlgid,response,listitem,String:concludeText[]) {
        #pragma unused listitem,dlgid,listitem
        new fromid = GetPlayerOfferFromID(targetid);
        //Just in case the fromid quits or the offer expires.
        if(fromid==INVALID_PLAYER_ID) return Dialog_Show(targetid,DIALOG_STYLE_MSGBOX,"Ups!","Parece que a oferta expirou.","OK","");
        if(!response) {
            Dialog_Show(fromid,DIALOG_STYLE_MSGBOX,"Concluido!","A tua oferta foi rejeitada pelo jogador","OK","");
            ResetPlayerOffer(fromid);
            Dialog_Show(targetid,DIALOG_STYLE_MSGBOX,"Concluido!","A oferta foi rejeitada!","OK","");
        }
        else {
            new title[255],msg[255];
            format(title,255,"Pagar o montante de R$ %d",gInv_control_sellHandler[fromid][SELLHANDLER_PRICE]);
            format(msg,255,"Via\tMeio\nDinheiro em maos\tR$ %d\nConta bancaria\tR$ %d",GetPlayerMoney(targetid),GetPlayerBankAccount(targetid));
            Dialog_ShowCallback(fromid,using inline offerCancelResponse,DIALOG_STYLE_MSGBOX,"Aguarda...","O jogador está a escolher o meio de pagamento...","Cancelar","");
            Dialog_ShowCallback(targetid,using inline offerConcludePaymentTypeSet,DIALOG_STYLE_TABLIST_HEADERS,title,msg,"Selecionar","Rejeitar");
        }
    }
    #pragma unused dialogid,listitem
    if(response) {
        new targetid=INVALID_PLAYER_ID,targetName[MAX_PLAYER_NAME];
        sscanf(inputtext,"s[64]",targetName);
        //Grab player id by their username.
        for(new i;i<MAX_PLAYERS;i++) {
            if(IsPlayerLoggedIn(playerid)&&!strcmp(targetName,GetPlayerNameEx(i)))targetid=i;
        }

        // Post-price processing. Includes validation (>0)
        inline const priceSetResponse(pid,did,resp,listitem,String:sellPriceText[]) {
            #pragma unused pid,did,listitem
            new sellPrice;
            sellPrice=strval(StsellPriceText);
            if(!sellPrice || sellPrice<0)Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Ups!","O preço deve ser um valor positivo.","OK");
            else {
                gInv_control_sellHandler[playerid][SELLHANDLER_TARGETID]=targetid;
                gInv_control_sellHandler[playerid][SELLHANDLER_WAITINGREPLY] = 1;
                gInv_control_sellHandler[playerid][SELLHANDLER_PRICE]=sellPrice;
                new msg[255],modelid,quantity,price;
                price=gInv_control_sellHandler[playerid][SELLHANDLER_PRICE];
                modelid=gInv_control_sellHandler[playerid][SELLHANDLER_MODELID];
                quantity=gInv_control_sellHandler[playerid][SELLHANDLER_QUANTITY];
                format(msg,255,"O jogador %s[%d] está a vender-te %dx%s por R$ %d\nAceitas esta oferta?",GetPlayerNameEx(playerid),playerid,quantity,GetItemNameString(modelid),price);
                Dialog_ShowCallback(targetid,using inline offerConcludeResponse,DIALOG_STYLE_MSGBOX,"Oferta",msg,"Aceitar","Rejeitar");
                Dialog_ShowCallback(playerid,using inline offerCancelResponse,DIALOG_STYLE_MSGBOX,"Aguardando resposta...","O jogador foi notificado da tua oferta.\nNão feches esta mensagem até obteres uma resposta!\nA aguardar uma resposta...","Cancelar","");
                SetPreciseTimer("ExpirePlayerInvOffer",1000,false,"i",playerid);
            }
        }
        //Actual target set handling. This is a mess, I know.
        if(targetid==INVALID_PLAYER_ID) return Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Ups!","Este jogador não está atualmente autenticado!","OK","");
        if(GetPlayerOfferFromID(targetid) != INVALID_PLAYER_ID) return Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Ups!","Este jogador está negociando atualmente com outro jogador.\nTente novamente mais tarde.","OK","");
        Dialog_ShowCallback(playerid,using inline priceSetResponse,DIALOG_STYLE_INPUT,"Vender","Introduz o preço de venda","OK","");
    }
    else return Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Aviso","A venda foi cancelada.","OK","");
    return 1;
}

forward ExpirePlayerInvOffer(playerid);
public ExpirePlayerInvOffer(playerid) {
    if(gInv_control_sellHandler[playerid][SELLHANDLER_EXPIRETIME]>0) {
        gInv_control_sellHandler[playerid][SELLHANDLER_EXPIRETIME]--;
        SetPreciseTimer("ExpirePlayerInvOffer",1000,false,"i",playerid);
    }
    else if (gInv_control_sellHandler[playerid][SELLHANDLER_MODELID] != ITEM_INVALID &&\
    gInv_control_sellHandler[playerid][SELLHANDLER_PRICE] && gInv_control_sellHandler[playerid][SELLHANDLER_QUANTITY]) {
        Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Ups!","O tempo limite da oferta expirou, e não obtiveste uma resposta.","OK","");
        ResetPlayerOffer(playerid);
    }
    return 1;
}


// Checks where the offer of specified comes from. Returns their offerman player id. If none found, returns INVALID_PLAYER_ID
stock GetPlayerOfferFromID(targetid) {
    if(!IsPlayerLoggedIn(targetid))return INVALID_PLAYER_ID;
    new fromid=INVALID_PLAYER_ID;
    for(new i;i<MAX_PLAYERS;i++) {
        if(IsPlayerLoggedIn(i)) {
            if(gInv_control_sellHandler[i][SELLHANDLER_TARGETID]==targetid) {
                fromid=i;
            }
        }
    }
    return fromid;
}


//Resets a offerman offer.
stock ResetPlayerOffer(playerid) {
    gInv_control_sellHandler[playerid][SELLHANDLER_INDEX] = -1;
    gInv_control_sellHandler[playerid][SELLHANDLER_MODELID] = ITEM_INVALID;
    gInv_control_sellHandler[playerid][SELLHANDLER_QUANTITY] = 0;
    gInv_control_sellHandler[playerid][SELLHANDLER_WAITINGREPLY] = 0;
    gInv_control_sellHandler[playerid][SELLHANDLER_TARGETID] = INVALID_PLAYER_ID;
    gInv_control_sellHandler[playerid][SELLHANDLER_EXPIRETIME] = -1;
    return 1;
}

