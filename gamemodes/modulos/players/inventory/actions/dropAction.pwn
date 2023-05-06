
/*
    Inventory Module - Sub-module dropAction
    Handles the button drop logic.
                                */
enum DROP {
    String:INVDROP_AUTHOR[MAX_PLAYER_NAME],
    INVDROP_PICKUPID,
    INVDROP_MODELID,
    INVDROP_SPHEREID,
    INVDROP_QUANTITY,
    INVDROP_WORLDID,
    INVDROP_TIMERID,
    INVDROP_INTERIORID
}
#define INVENTORY_MAXDROPS MAX_PICKUPS
#define INVENTORY_INVALID_DROP -1
#define INVENTORY_INVALID_AREAID -1

#define INVDROPDLG_DROP 2026
#define INVDROPDLG_EMPTY 131212

#define INVDROP_SPHERE_SIZE 0.5
#define INVDROP_CONFIG_EXPIRETIMER 0 // Timer in seconds for the item to be deleted forever. Set 0 to disable.
#include <YSI_Coding\y_hooks>

new gInv_control_droppedItens[MAX_PICKUPS][DROP];


forward InvAction:PlayerInvDropInit();
public InvAction:PlayerInvDropInit() {
    for(new i;i<MAX_PICKUPS;i++) {
        gInv_control_droppedItens[i][INVDROP_PICKUPID] = INVENTORY_INVALID_DROP;
        gInv_control_droppedItens[i][INVDROP_SPHEREID] = INVENTORY_INVALID_AREAID;
    }
    return 1;
}

//Returns the model id of a valid PlayerInvDrop by passing index. If not valid, returns -1.
forward InvAction:GetPlayerInvDropModelid(index);
public InvAction:GetPlayerInvDropModelid(index) {
    if(IsValidPlayerInvDrop(index))return gInv_control_droppedItens[index][INVDROP_MODELID];
    return -1;
}
//Returns the nearest free index to drop an item. Returns INVENTORY_INVALID_DROP if not found. if there are no free indexes.
forward InvAction:GetEmptyPlayerInvDropIndex();
public InvAction:GetEmptyPlayerInvDropIndex() {
    for(new i;i<MAX_PICKUPS;i++) {
        if(gInv_control_droppedItens[i][INVDROP_PICKUPID] == INVENTORY_INVALID_DROP) {
            return i;
        }
    }
    return INVENTORY_INVALID_DROP;
}
//Returns the area id of a valid PlayerInv index. If it's not valid, returns INVENTORY_INVALID_AREAID
forward InvAction:GetPlayerInvDropAreaId(index);
public InvAction:GetPlayerInvDropAreaId(index) {
    for(new i;i<MAX_PICKUPS;i++) {
        if(IsValidPlayerInvDrop(i)&&i==index)return gInv_control_droppedItens[i][INVDROP_SPHEREID];
    }
    return INVENTORY_INVALID_AREAID;
}
//Returns the index of the player drop, by passing pickupid. Returns INVENTORY_INVALID_DROP if not found.
forward InvAction:GetPlayerInvDropIndexEx(pickupid);
public InvAction:GetPlayerInvDropIndexEx(pickupid) {
    for(new i;i<MAX_PICKUPS;i++) {
        if(IsValidPlayerInvDrop(i)&&gInv_control_droppedItens[i][INVDROP_PICKUPID] == pickupid)return i;
    }
    return INVENTORY_INVALID_DROP;
}
forward InvAction:GetPlayerInvDropPickupId(sphereid);
public InvAction:GetPlayerInvDropPickupId(sphereid) {
    if(sphereid==-1||!sphereid) return 0;
    for(new i;i<MAX_PICKUPS;i++) {
        if(IsValidPlayerInvDrop(i)) {
            if(gInv_control_droppedItens[i][INVDROP_SPHEREID]==sphereid)return gInv_control_droppedItens[i][INVDROP_PICKUPID];
        }
    }
    return 0;
}
//Checks if given index is a invalid drop or not.
forward InvAction:IsValidPlayerInvDrop(index);
public InvAction:IsValidPlayerInvDrop(index) {
    if(gInv_control_droppedItens[index][INVDROP_PICKUPID] == INVENTORY_INVALID_DROP) return 0;
    return 1;
}

//Clears all of the ram values of the pickup. Deletes the sphere, kills the timer and the destroys the pickup.
forward InvAction:ClearPlayerInvDropData(index);
public InvAction:ClearPlayerInvDropData(index) {
    if(IsValidDynamicArea(gInv_control_droppedItens[index][INVDROP_SPHEREID])) {
        new index,areaid;
        for(new i;i<MAX_PLAYERS;i++) {
            if(IsPlayerConnected(i)) {
                index=GetPlayerInvDropIndex(i);
                areaid=GetPlayerInvDropAreaId(index);
                if(areaid==gInv_control_droppedItens[index][INVDROP_SPHEREID])  {
                    HidePlayerTxdInvDrop(i);
                }
            }
        }
        DestroyDynamicArea(gInv_control_droppedItens[index][INVDROP_SPHEREID]);
        gInv_control_droppedItens[index][INVDROP_SPHEREID] = INVENTORY_INVALID_AREAID;
        DestroyDynamicPickup(gInv_control_droppedItens[index][INVDROP_PICKUPID]);
        gInv_control_droppedItens[index][INVDROP_PICKUPID] = INVENTORY_INVALID_DROP;
        for(new i;i<MAX_PLAYERS;i++)Streamer_Update(i);
    }
    DeletePreciseTimer(gInv_control_droppedItens[index][INVDROP_TIMERID]);
    gInv_control_droppedItens[index][INVDROP_TIMERID]=0;
    gInv_control_droppedItens[index][INVDROP_QUANTITY] = 0;
    gInv_control_droppedItens[index][INVDROP_MODELID] = INVENTORY_INVALID_DROP;
    gInv_control_droppedItens[index][INVDROP_WORLDID] = 0;
    gInv_control_droppedItens[index][INVDROP_INTERIORID] = 0;
    return 1;
}

//Creates a new dropped item. Does not subtract the item from the player inventory. Doesn't save the player inventory.
forward InvAction:DropPlayerInvItem(playerid,modelid,quantity);
public InvAction:DropPlayerInvItem(playerid,modelid,quantity) {
    new worldid,interiorid,index,Float:x,Float:y,Float:z,author[MAX_PLAYER_NAME];
    GetPlayerName(playerid,author,MAX_PLAYER_NAME);
    GetPlayerPos(playerid,x,y,z);
    worldid=GetPlayerVirtualWorld(playerid);
    interiorid=GetPlayerInterior(playerid);
    index=GetEmptyPlayerInvDropIndex();
    if(index != INVENTORY_INVALID_DROP) {
        gInv_control_droppedItens[index][INVDROP_AUTHOR]=GetPlayerNameEx(playerid);
        gInv_control_droppedItens[index][INVDROP_INTERIORID]=interiorid;
        gInv_control_droppedItens[index][INVDROP_MODELID]=modelid;
        gInv_control_droppedItens[index][INVDROP_WORLDID]=worldid;
        gInv_control_droppedItens[index][INVDROP_QUANTITY]=quantity;
        gInv_control_droppedItens[index][INVDROP_PICKUPID]=CreateDynamicPickup(modelid,1,x,y,z,worldid,interiorid);
        gInv_control_droppedItens[index][INVDROP_SPHEREID]=CreateDynamicSphere(x,y,z,INVDROP_SPHERE_SIZE, worldid, interiorid);
        if(INVDROP_CONFIG_EXPIRETIMER)gInv_control_droppedItens[index][INVDROP_TIMERID]=SetPreciseTimer("ClearPlayerInvDropData",INVDROP_CONFIG_EXPIRETIMER*1000,false,"i",index);
        format(gInv_control_droppedItens[index][INVDROP_AUTHOR],MAX_PLAYER_NAME,"%s",author);
    }
    return 1;
}
//Returns the drop quantity, by passing index
forward InvAction:GetPlayerInvDropQuantity(index);
public InvAction:GetPlayerInvDropQuantity(index) {
    return gInv_control_droppedItens[index][INVDROP_QUANTITY];
}
//Returns the nearest Drop index. If the player is not in any dynamic sphere drop, returns INVENTORY_INVALID_AREAID.
forward InvAction:GetPlayerInvDropIndex(playerid);
public InvAction:GetPlayerInvDropIndex(playerid) {
    for(new i;i<MAX_PICKUPS;i++) {
        if(IsValidPlayerInvDrop(i)) {
            if(IsPlayerInDynamicArea(playerid,gInv_control_droppedItens[i][INVDROP_SPHEREID])) {
                return i;
            }
        }
    }
    return INVENTORY_INVALID_AREAID;
}

// Pickup item logic TODO fix it
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if(HOLDING(KEY_YES)) {
        if(GetPlayerInvDropIndex(playerid) != INVENTORY_INVALID_AREAID) {
            new pickupid,index,quantity,modelid;
            index=GetPlayerInvDropIndex(playerid);   
            quantity=GetPlayerInvDropQuantity(index);
            modelid=GetPlayerInvDropModelid(index);      
            ClearPlayerInvDropData(index);
            GivePlayerInvItem(playerid,modelid,quantity);
            SendClientMessagef(playerid,-1,"Apanhas-te %dx%s!",quantity,GetItemNameString(modelid));
            PrepareSavePlayerInventory(playerid);
        }
    }
    return 1;
}

//Show notification logic
hook OnPlayerEnterDynamicArea(p, a) {
    new playerid,areaid;
    playerid=p;
    areaid=a;
    if(GetPlayerInvDropIndex(playerid) != INVENTORY_INVALID_AREAID) {
        new pickupid,index,quantity,modelid,text[64];
        index=GetPlayerInvDropIndex(playerid);   
        quantity=GetPlayerInvDropQuantity(index);
        modelid=GetPlayerInvDropModelid(index);
        format(text,64,"Aperte Y para pegar~n~%s de %s",GetItemNameString(modelid),gInv_control_droppedItens[index][INVDROP_AUTHOR]);
        ShowPlayerTxdInvDrop(playerid,text,modelid,quantity);  
    }
}
//Hide drop notification logic
hook OnPlayerLeaveDynamicArea(playerid, areaid) {
    if(GetPlayerInvDropIndex(playerid) == INVENTORY_INVALID_AREAID)HidePlayerTxdInvDrop(playerid);
    return 1;
}
forward InvAction:OnPlayerInvActionDrop(playerid,modelid,quantity);
public InvAction:OnPlayerInvActionDrop(playerid,modelid,quantity) {
    new index;
    index=GetPlayerInvSelectedItemIndex(playerid);
    SetPlayerInvItem(playerid,index,ITEM_INVALID,0);
    DropPlayerInvItem(playerid,modelid,quantity);
    new msg[255];
    format(msg,255,"Descartou %dx%s para o chao.",quantity,GetItemNameString(modelid));
    ShowPlayerDialog(playerid,INVDROPDLG_DROP,DIALOG_STYLE_MSGBOX,"Aviso",msg,"OK","");
    SetPlayerInvSelectedItem(playerid,-1);
    RefreshPlayerInv(playerid);
    PrepareSavePlayerInventory(playerid);
    return 1;
}