forward OnPlayerInvAction(playerid,modelid,quantity,actiontype);

/*
    inventory.pwmn
                    */

enum RENDERTYPE {
	RENDERTYPE_BTN,
	RENDERTYPE_MODEL,
	RENDERTYPE_TITLE,
	RENDERTYPE_QUANTITY
}
enum INVACTION {
    INVACTION_USE,
    INVACTION_DROP,
    INVACTION_JOIN,
    INVACTION_SEPARATE,
    INVACTION_SELL
}
enum ITEMDATA {
    ITEMDATA_MODELID,
    ITEMDATA_QUANTITY
}
#define INVENTORY_MAXPAGES 4
#define INVENTORY_ROWLIMIT 3 // from left to right
#define INVENTORY_COLUMNLIMIT 6 // from top to bottom
#define INVENTORY_SIZE INVENTORY_ROWLIMIT*INVENTORY_COLUMNLIMIT
#define INVENTORY_MAXITEMS INVENTORY_MAXPAGES*INVENTORY_SIZE
#define INVENTORY_DEFAULT_BTN_X 39.0
#define INVENTORY_DEFAULT_BTN_Y 109.9
#define INVENTORY_DEFAULT_TITLE_X 80.0
#define INVENTORY_DEFAULT_TITLE_Y 106.0
#define INVENTORY_DEFAULT_QTT_X 107.0
#define INVENTORY_DEFAULT_QTT_Y 176.0
#define INVENTORY_DEFAULT_MODEL_X 33.0
#define INVENTORY_DEFAULT_MODEL_Y 113.0
#define INVENTORY_INVALID_SLOT -1
const Float:cstInv_renderOffset = 83.0;
new PlayerText:txdInv_bg0[MAX_PLAYERS];
new PlayerText:txdInv_bg1[MAX_PLAYERS];
new PlayerText:txdInv_bg2[MAX_PLAYERS];
new PlayerText:txdInv_Title[MAX_PLAYERS];
new PlayerText:txdInv_Page[MAX_PLAYERS];
new PlayerText:txdInv_render_btn[MAX_PLAYERS][INVENTORY_ROWLIMIT][INVENTORY_COLUMNLIMIT];
new PlayerText:txdInv_render_model[MAX_PLAYERS][INVENTORY_ROWLIMIT][INVENTORY_COLUMNLIMIT];
new PlayerText:txdInv_render_title[MAX_PLAYERS][INVENTORY_ROWLIMIT][INVENTORY_COLUMNLIMIT];
new PlayerText:txdInv_render_quantity[MAX_PLAYERS][INVENTORY_ROWLIMIT][INVENTORY_COLUMNLIMIT];
new PlayerText:txdInv_btnNEXT[MAX_PLAYERS];
new PlayerText:txdInv_btnPREVIOUS[MAX_PLAYERS];
new PlayerText:txdInv_btnUSE[MAX_PLAYERS];
new PlayerText:txdInv_btnSELL[MAX_PLAYERS];
new PlayerText:txdInv_btnDROP[MAX_PLAYERS];
new PlayerText:txdInv_btnSEPARATE[MAX_PLAYERS];
new PlayerText:txdInv_btnJOIN[MAX_PLAYERS];
new PlayerText:txdInv_btnCLOSE[MAX_PLAYERS];

/*
    INVENTORYtable.pwn
                    */
forward SeparatePlayerInvItem(playerid,index,reduceQuantity);