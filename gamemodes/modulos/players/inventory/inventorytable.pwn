/*
	Inventory module: inventorytable.pwn
	Handles all of the SQL and variable logic for player inventories.
    Uses the InvGUI module
	Prefix: InvSQL			*/


enum INVENTORYITEM {
    Int:INVITEM_MODELID,
    Int:INVITEM_QUANTITY,
    Int:INVITEM_SELECTED
}




#define INVENTORY_TABLESIZE 148 // The size of the SQL table that stores player items.
#define INVENTORY_REALSIZE 72 // The size of the table, divided by two.

#include <YSI_Coding\y_hooks>

new gInventories[MAX_PLAYERS][INVENTORY_TABLESIZE][INVENTORYITEM];
new gInv_control_savedItens[MAX_PLAYERS];

forward InvSQL:PreparePlayerInventoryTable(playerid);
public InvSQL:PreparePlayerInventoryTable(playerid) {
    /*new const query[]="
    CREATE TABLE IF NOT EXISTS inventories (
    username VARCHAR(64) PRinvITMARY KEY,
    item1 INT DEFAULT 18631,
    itemquantity1 INT DEFAULT 0,
    item2 INT DEFAULT 18631,
    itemquantity2 INT DEFAULT 0,
    item3 INT DEFAULT 18631,
    itemquantity3 INT DEFAULT 0,
    item4 INT DEFAULT 18631,
    itemquantity4 INT DEFAULT 0,
    item5 INT DEFAULT 18631,
    itemquantity5 INT DEFAULT 0,
    item6 INT DEFAULT 18631,
    itemquantity6 INT DEFAULT 0,
    item7 INT DEFAULT 18631,
    itemquantity7 INT DEFAULT 0,
    item8 INT DEFAULT 18631,
    itemquantity8 INT DEFAULT 0,
    item9 INT DEFAULT 18631,
    itemquantity9 INT DEFAULT 0,
    item10 INT DEFAULT 18631,
    itemquantity10 INT DEFAULT 0,
    item11 INT DEFAULT 18631,
    itemquantity11 INT DEFAULT 0,
    item12 INT DEFAULT 18631,
    itemquantity12 INT DEFAULT 0,
    item13 INT DEFAULT 18631,
    itemquantity13 INT DEFAULT 0,
    item14 INT DEFAULT 18631,
    itemquantity14 INT DEFAULT 0,
    item15 INT DEFAULT 18631,
    itemquantity15 INT DEFAULT 0,
    item16 INT DEFAULT 18631,
    itemquantity16 INT DEFAULT 0,
    item17 INT DEFAULT 18631,
    itemquantity17 INT DEFAULT 0,
    item18 INT DEFAULT 18631,
    itemquantity18 INT DEFAULT 0,
    item19 INT DEFAULT 18631,
    itemquantity19 INT DEFAULT 0,
    item20 INT DEFAULT 18631,
    itemquantity20 INT DEFAULT 0,
    item21 INT DEFAULT 18631,
    itemquantity21 INT DEFAULT 0,
    item22 INT DEFAULT 18631,
    itemquantity22 INT DEFAULT 0,
    item23 INT DEFAULT 18631,
    itemquantity23 INT DEFAULT 0,
    item24 INT DEFAULT 18631,
    itemquantity24 INT DEFAULT 0,
    item25 INT DEFAULT 18631,
    itemquantity25 INT DEFAULT 0,
    item26 INT DEFAULT 18631,
    itemquantity26 INT DEFAULT 0,
    item27 INT DEFAULT 18631,
    itemquantity27 INT DEFAULT 0,
    item28 INT DEFAULT 18631,
    itemquantity28 INT DEFAULT 0,
    item29 INT DEFAULT 18631,
    itemquantity29 INT DEFAULT 0,
    item30 INT DEFAULT 18631,
    itemquantity30 INT DEFAULT 0,
    item31 INT DEFAULT 18631,
    itemquantity31 INT DEFAULT 0,
    item32 INT DEFAULT 18631,
    itemquantity32 INT DEFAULT 0,
    item33 INT DEFAULT 18631,
    itemquantity33 INT DEFAULT 0,
    item34 INT DEFAULT 18631,
    itemquantity34 INT DEFAULT 0,
    item35 INT DEFAULT 18631,
    itemquantity35 INT DEFAULT 0,
    item36 INT DEFAULT 18631,
    itemquantity36 INT DEFAULT 0,
    item37 INT DEFAULT 18631,
    itemquantity37 INT DEFAULT 0,
    item38 INT DEFAULT 18631,
    itemquantity38 INT DEFAULT 0,
    item39 INT DEFAULT 18631,
    itemquantity39 INT DEFAULT 0,
    item40 INT DEFAULT 18631,
    itemquantity40 INT DEFAULT 0,
    item41 INT DEFAULT 18631,
    itemquantity41 INT DEFAULT 0,
    item42 INT DEFAULT 18631,
    itemquantity42 INT DEFAULT 0,
    item43 INT DEFAULT 18631,
    itemquantity43 INT DEFAULT 0,
    item44 INT DEFAULT 18631,
    itemquantity44 INT DEFAULT 0,
    item45 INT DEFAULT 18631,
    itemquantity45 INT DEFAULT 0,
    item46 INT DEFAULT 18631,
    itemquantity46 INT DEFAULT 0,
    item47 INT DEFAULT 18631,
    itemquantity47 INT DEFAULT 0,
    item48 INT DEFAULT 18631,
    itemquantity48 INT DEFAULT 0,
    item49 INT DEFAULT 18631,
    itemquantity49 INT DEFAULT 0,
    item50 INT DEFAULT 18631,
    itemquantity50 INT DEFAULT 0,
    item51 INT DEFAULT 18631,
    itemquantity51 INT DEFAULT 0,
    item52 INT DEFAULT 18631,
    itemquantity52 INT DEFAULT 0,
    item53 INT DEFAULT 18631,
    itemquantity53 INT DEFAULT 0,
    item54 INT DEFAULT 18631,
    itemquantity54 INT DEFAULT 0,
    item55 INT DEFAULT 18631,
    itemquantity55 INT DEFAULT 0,
    item56 INT DEFAULT 18631,
    itemquantity56 INT DEFAULT 0,
    item57 INT DEFAULT 18631,
    itemquantity57 INT DEFAULT 0,
    item58 INT DEFAULT 18631,
    itemquantity58 INT DEFAULT 0,
    item59 INT DEFAULT 18631,
    itemquantity59 INT DEFAULT 0,
    item60 INT DEFAULT 18631,
    itemquantity60 INT DEFAULT 0,
    item61 INT DEFAULT 18631,
    itemquantity61 INT DEFAULT 0,
    item62 INT DEFAULT 18631,
    itemquantity62 INT DEFAULT 0,
    item63 INT DEFAULT 18631,
    itemquantity63 INT DEFAULT 0,
    item64 INT DEFAULT 18631,
    itemquantity64 INT DEFAULT 0,
    item65 INT DEFAULT 18631,
    itemquantity65 INT DEFAULT 0,
    item66 INT DEFAULT 18631,
    itemquantity66 INT DEFAULT 0,
    item67 INT DEFAULT 18631,
    itemquantity67 INT DEFAULT 0,
    item68 INT DEFAULT 18631,
    itemquantity68 INT DEFAULT 0,
    item69 INT DEFAULT 18631,
    itemquantity69 INT DEFAULT 0,
    item70 INT DEFAULT 18631,
    itemquantity70 INT DEFAULT 0,
    item71 INT DEFAULT 18631,
    itemquantity71 INT DEFAULT 0,
    item72 INT DEFAULT 18631,
    itemquantity72 INT DEFAULT 0
    );*/
    //Since the input line is too long, create the table by yourself on XAMPP phpmyadmin.
    // TODO rebuild the string by using a for loop.
    new const query[] = ";";
    //mysql_query(mysql,query,false);
    PrepareLoadPlayerInventory(playerid);
    return 1;
}


forward InvSQL:PrepareLoadPlayerInventory(playerid);
public InvSQL:PrepareLoadPlayerInventory(playerid) {
    new query[255];
    mysql_format(mysql,query,255,"SELECT * FROM inventories WHERE username = '%s'",GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query,"FinishLoadPlayerInventory","i",playerid);
    return 1;
}
forward InvSQL:FinishLoadPlayerInventory(playerid);
public InvSQL:FinishLoadPlayerInventory(playerid) {
    if(!cache_num_rows()) {
        printf("[inventorytable.pwn] WARN inventory of %s[%d] not found, first join? Creating..",GetPlayerNameEx(playerid),playerid);
        PrepareCreatePlayerInventory(playerid);
        return 1;
    }
    new qtt;
    new tablePointer=1; // keep track of the correct row to get the values from.
    for(new i;i<INVENTORY_REALSIZE;i++) { 
        cache_get_value_index_int(0,tablePointer,gInventories[playerid][i][INVITEM_MODELID]);
        cache_get_value_index_int(0,tablePointer+1,gInventories[playerid][i][INVITEM_QUANTITY]);
        tablePointer+=2;
        if(gInventories[playerid][i][INVITEM_MODELID] != ITEM_INVALID) qtt++;
    }
    printf("[inventorytable.pwn] %d valid itens loaded for %s[%d]",qtt,GetPlayerNameEx(playerid),playerid);
    return 1;
}

forward InvSQL:PrepareCreatePlayerInventory(playerid);
public InvSQL:PrepareCreatePlayerInventory(playerid) {
    new query[255];
    mysql_format(mysql,query,255,"INSERT INTO inventories (username) VALUES ('%s')",GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query,"PrepareLoadPlayerInventory","i",playerid);
    printf("[inventorytable.pwn] A new inventory has been created for %s[%d]. Reloading...",GetPlayerNameEx(playerid),playerid);
    return 1;
}


//Saves the ram values of player's inventory to database. Builds the string in parts because once again fuck pawn's compiler :/
forward InvSQL:PrepareSavePlayerInventory(playerid);
public InvSQL:PrepareSavePlayerInventory(playerid) {
    new String:query[1024];
    new qtt=1;
    gInv_control_savedItens[playerid]=0;
    format(query,1024,"UPDATE inventories SET item1 = %d, itemquantity1 = %d",gInventories[playerid][0][INVITEM_MODELID],gInventories[playerid][0][INVITEM_QUANTITY]);
    for(new i=1;i<INVENTORY_REALSIZE;i++) {
        if(gInventories[playerid][i][INVITEM_MODELID]!=ITEM_INVALID)qtt++;
        mysql_format(mysql,query,256,"%s,item%d = %d, itemquantity%d = %d",query,\
        i+1,gInventories[playerid][i][INVITEM_MODELID],i+1,gInventories[playerid][i][INVITEM_QUANTITY]);
    }
    format(query,1024,"%s WHERE username = '%s'",query,GetPlayerNameEx(playerid));
    mysql_pquery(mysql,query,"FinishSavePlayerInventory","is",playerid,GetPlayerNameEx(playerid));
    printf("[inventorytable.pwn] %d valid itens saved for %s[%d]",qtt,GetPlayerNameEx(playerid),playerid);
    return 1;
}
forward InvSQL:FinishSavePlayerInventory(const playerid,const username[]);
public InvSQL:FinishSavePlayerInventory(const playerid,const username[]) {
    if(cache_affected_rows())return 1;
    else printf("[inventorytable.pwn] WARN - No rows affected while saving the inventory of %s[%d]",username,playerid);
    return 1;
}

// Sets a player's item model id at specified index. Index should be between 0 and INVENTORY_REALSIZE Doesn't save to SQL
forward InvSQL:SetPlayerInvItem(playerid,index,modelid,quantity);
public InvSQL:SetPlayerInvItem(playerid,index,modelid,quantity) {
    gInventories[playerid][index][INVITEM_MODELID]=modelid;
    gInventories[playerid][index][INVITEM_QUANTITY]=quantity;
    return 1;
}

//Gives a player an item. Checks for empty slots. If it does not find one, returns 0. Does not save to SQL
forward InvSQL:GivePlayerInvItem(playerid,modelid,quantity);
public InvSQL:GivePlayerInvItem(playerid,modelid,quantity) {
    new slotFound; // if the inventory is full
    for(new i;i<INVENTORY_REALSIZE;i++) {
        if(!slotFound&&gInventories[playerid][i][INVITEM_MODELID] == ITEM_INVALID) {
            SetPlayerInvItem(playerid,i,modelid,quantity);
            slotFound=1;
        }
    }
    if(!slotFound)return 0;
    
    return 1;
}

YCMD:dinheiro(playerid,params[],help) {
    GivePlayerInvItem(playerid,ITEM_CAIXALENDARIA,1);
    GivePlayerInvItem(playerid,ITEM_RESPEITO,12);
    GivePlayerInvItem(playerid,ITEM_GASOLINA,13);
    GivePlayerInvItem(playerid,ITEM_MEDKIT,1);
}


//Organizes the player inventory, checking for repeated itens and joining them. Saves to RAM only, not to SQL!
forward InvSQL:OrganizePlayerInv(playerid);
public InvSQL:OrganizePlayerInv(playerid) {
    new newQuantity,organizedItems;
    for(new i;i<INVENTORY_REALSIZE;i++) {
        for(new j;j<INVENTORY_REALSIZE;j++) {
            if(gInventories[playerid][i][INVITEM_MODELID]==gInventories[playerid][j][INVITEM_MODELID] &&  i != j) {
                organizedItems++;
                newQuantity=gInventories[playerid][j][INVITEM_QUANTITY];
                SetPlayerInvItem(playerid,j,ITEM_INVALID,0);
                SetPlayerInvItem(playerid,i,gInventories[playerid][i][INVITEM_QUANTITY]+newQuantity);
            }
        }
    }
    RefreshPlayerInv(playerid);
    return 1;
}


//Checks if a player has said item by passing index. Returns the quantity. Always returns ITEM_INVALID if ITEM_INVALID is passed as modelid.
forward InvSQL:GetPlayerInvItemQuantity(playerid,index);
public InvSQL:GetPlayerInvItemQuantity(playerid,index) {
    if(GetPlayerInvModelid(playerid,index)==ITEM_INVALID) return ITEM_INVALID;
    SendClientMessagef(playerid,-1,"I returned quantity %d at the index %d",gInventories[playerid][index][INVITEM_QUANTITY],index);
    return gInventories[playerid][index][INVITEM_QUANTITY];
}
//Returns the index of the nearest empty slot. Returns -1 if inventory is full
forward InvSQL:GetPlayerInvEmptySlot(playerid);
public InvSQL:GetPlayerInvEmptySlot(playerid) {
    for(new i;i<INVENTORY_REALSIZE;i++) {
        if(gInventories[playerid][i][INVITEM_MODELID]==ITEM_INVALID) return i;
    }
    return -1;
}
//Checks if given slot is empty. Returns 1 of so. Returns 0 otherwhise. Returns 0 if out of bounds.
forward InvSQL:IsPlayerInvSlotEmpty(playerid,index);
public InvSQL:IsPlayerInvSlotEmpty(playerid,index) {
    if(index>INVENTORY_REALSIZE||index<0) return 0;
    if(gInventories[playerid][index][INVITEM_MODELID] == ITEM_INVALID) return 1;
    return 0;
}
//Checks if a player has said item by passing modelid. Returns the index. Always returns -1 if not found or ITEM_INVALID is passed as modelid.
forward InvSQL:GetPlayerInvItemQuantityEx(playerid,modelid);
public InvSQL:GetPlayerInvItemQuantityEx(playerid,modelid) {
    if(modelid==ITEM_INVALID) return -1;
    for(new i;i<INVENTORY_REALSIZE;i++) {
        if(gInventories[playerid][i][INVITEM_MODELID]==modelid)return i;
    }
    return -1;
}

forward InvSQL:GetPlayerInvModelid(playerid,index);
public InvSQL:GetPlayerInvModelid(playerid,index) {
    return gInventories[playerid][index][INVITEM_MODELID];
}

/*
    Separates a item to the nearest empty slot. 
    If the passed reduceQuantity >=  the current quantity, returns 0 and does not do anything. 
    Otherwhise returns 1.
    Doesn't save to SQL.
 */

public InvSQL:SeparatePlayerInvItem(playerid,index,reduceQuantity) {

    new currentQuantity,emptySlot,modelid;
    currentQuantity=GetPlayerInvItemQuantity(playerid,index);
    SendClientMessage(playerid,-1,"chamado2");
    modelid=GetPlayerInvModelid(playerid,index);
    if(reduceQuantity >= currentQuantity)return 0;
    emptySlot=GetPlayerInvEmptySlot(playerid);
    if(currentQuantity) {
        currentQuantity-=reduceQuantity;
        SetPlayerInvItem(playerid,index,modelid,currentQuantity);
        SetPlayerInvItem(playerid,emptySlot,modelid,reduceQuantity);
        return 1;
    }
    return 0;
}

hook OnPlayerDisconnect(playerid, reason) {
    if(IsPlayerLoggedIn(playerid))PrepareSavePlayerInventory(playerid);
    return 1;
}



