
#define MAX_SELL 2000

#define INVSELLDLG_QTT 2050 // Ask for quantity input (should be validated)
#define INVSELLDLG_FROM 2051 // Dialog to show confirm
#define INVSELLDLG_TARGET 2052 // Dialog to show to the target
/* TODO: Item market.
enum MARKETSELL {
    String:ITEMMARKET_AUTHOR[MAX_PLAYER_NAME],
    ITEMMARKET_MODELID,
    ITEMMARKET_QUANTITY,
    ITEMMARKET_TIMERID,
    ITEMMARKET_PRICE,
    ITEMMARKET_OTHERPRICE // TODO: Setup paid currency and add it to the item price if needed.
}*/


enum ITEMSELLSELL {
    String:ITEMSELL_FROM[MAX_PLAYER_NAME],
    String:ITEMSELL_TO[MAX_PLAYER_NAME],
    ITEMSELL_MODELID,
    ITEMSELL_QUANTITY,
    ITEMSELL_PRICE
}


new gInv_control_sellItems[MAX_SELL][ITEMSELL];
//new gInv_control_marketItems[]; TODO: Item market
forward OnPlayerInvActionSell(playerid,modelid,quantity);
public OnPlayerInvActionSell(playerid,modelid,quantity) {
    return 1;
}