
enum INVENTORYITEM {
    String:INVITEM_NAME[64],
    Int:INVITEM_MODELID=ITEM_INVALID,
    Int:INVITEM_QUANTITY,
    Int:INVITEM_SELECTED
}



enum INVETORYACTION {
    INVACTION_USE,
    INVACTION_DROP,
    INVACTION_JOIN,
    INVACTION_SEPARATE,
    INVACTION_SELL
}

new gInventories[MAX_PLAYERS][75][INVENTORYITEM];
new gInventoryController[MAX_PLAYERS][INVETORYACTION];
new PlayerText:txdInventory_GUI[MAX_PLAYERS];
new PlayerText:txdInventory_ACTIONGUI[MAX_PLAYERS];

forward PreparePlayerInventoryTable(playerid);
public PreparePlayerInventoryTable(playerid) {
    new query[350];
    mysql_format(mysql,query,350,"\
    CREATE TABLE IF NOT EXISTS inventories (\
    username VARCHAR(64) PRIMARY KEY,\
    item1 INT,\
    itemquantity1 INT,\
    item2 INT,\
    itemquantity2 INT,\
    item3 INT,\
    itemquantity3 INT,\
    item4 INT,\
    itemquantity4 INT,\
    item5 INT,\
    itemquantity5 INT,\
    item6 INT,\
    itemquantity6 INT,\
    item7 INT,\
    itemquantity7 INT,\
    item8 INT,\
    itemquantity8 INT,\
    item9 INT,\
    itemquantity9 INT,\
    item10 INT,\
    itemquantity10 INT,\
    item11 INT,\
    itemquantity11 INT,\
    item12 INT,\
    itemquantity12 INT,\
    item13 INT,\
    itemquantity13 INT,\
    item14 INT,\
    itemquantity14 INT,\
    item15 INT,\
    itemquantity15 INT,\
    item16 INT,\
    itemquantity16 INT,\
    item17 INT,\
    itemquantity17 INT,\
    item18 INT,\
    itemquantity18 INT,\
    item19 INT,\
    itemquantity19 INT,\
    item20 INT,\
    itemquantity20 INT,\
    item21 INT,\
    itemquantity21 INT,\
    item22 INT,\
    itemquantity22 INT,\
    item23 INT,\
    itemquantity23 INT,\
    item24 INT,\
    itemquantity24 INT,\
    item25 INT,\
    itemquantity25 INT,\
    item26 INT,\
    itemquantity26 INT,\
    item27 INT,\
    itemquantity27 INT,\
    item28 INT,\
    itemquantity28 INT,\
    item29 INT,\
    itemquantity29 INT,\
    item30 INT,\
    itemquantity30 INT,\
    item31 INT,\
    itemquantity31 INT,\
    item32 INT,\
    itemquantity32 INT,\
    item33 INT,\
    itemquantity33 INT,\
    item34 INT,\
    itemquantity34 INT,\
    item35 INT,\
    itemquantity35 INT,\
    item36 INT,\
    itemquantity36 INT,\
    item37 INT,\
    itemquantity37 INT,\
    item38 INT,\
    itemquantity38 INT,\
    item39 INT,\
    itemquantity39 INT,\
    item40 INT,\
    itemquantity40 INT,\
    item41 INT,\
    itemquantity41 INT,\
    item42 INT,\
    itemquantity42 INT,\
    item43 INT,\
    itemquantity43 INT,\
    item44 INT,\
    itemquantity44 INT,\
    item45 INT,\
    itemquantity45 INT,\
    item46 INT,\
    itemquantity46 INT,\
    item47 INT,\
    itemquantity47 INT,\
    item48 INT,\
    itemquantity48 INT,\
    item49 INT,\
    itemquantity49 INT,\
    item50 INT,\
    itemquantity50 INT,\
    item51 INT,\
    itemquantity51 INT,\
    item52 INT,\
    itemquantity52 INT,\
    item53 INT,\
    itemquantity53 INT,\
    item54 INT,\
    itemquantity54 INT,\
    item55 INT,\
    itemquantity55 INT,\
    item56 INT,\
    itemquantity56 INT,\
    item57 INT,\
    itemquantity57 INT,\
    item58 INT,\
    itemquantity58 INT,\
    item59 INT,\
    itemquantity59 INT,\
    item60 INT,\
    itemquantity60 INT,\
    item61 INT,\
    itemquantity61 INT,\
    item62 INT,\
    itemquantity62 INT,\
    item63 INT,\
    itemquantity63 INT,\
    item64 INT,\
    itemquantity64 INT,\
    item65 INT,\
    itemquantity65 INT,\
    item66 INT,\
    itemquantity66 INT,\
    item67 INT,\
    itemquantity67 INT,\
    item68 INT,\
    itemquantity68 INT,\
    item69 INT,\
    itemquantity69 INT,\
    item70 INT,\
    itemquantity70 INT,\
    item71 INT,\
    itemquantity71 INT,\
    item72 INT,\
    itemquantity72 INT,\
    item73 INT,\
    itemquantity73 INT,\
    item74 INT,\
    itemquantity74 INT,\
    item75 INT,\
    itemquantity75 INT\
    );\
    ");
    mysql_query(mysql,query,false);
}
