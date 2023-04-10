/*
This textdraw does NOT follow the server standards.
*/
#include "modulos/inventory/inventoryitems.pwn"
#include <YSI_Coding\y_hooks>

/*
	Inventory Draw Configuration
									*/
#define INVENTORY_MAXPAGES 5
#define INVENTORY_ROWLIMIT 3 // from left to right
#define INVENTORY_COLUMNLIMIT 6 // from top to bottom
#define INVENTORY_SIZE INVENTORY_ROWLIMIT*INVENTORY_COLUMNLIMIT
#define INVENTORY_MAXITEMS INVENTORY_MAXPAGES*INVENTORY_SIZE

/*
	Invenntory Render Default Coordenates
	Offset: 83.0
											*/
#define INVENTORY_DEFAULT_BTN_X 39.0
#define INVENTORY_DEFAULT_BTN_Y 109.9

#define INVENTORY_DEFAULT_TITLE_X 80.0
#define INVENTORY_DEFAULT_TITLE_Y 106.0

#define INVENTORY_DEFAULT_QTT_X 107.0
#define INVENTORY_DEFAULT_QTT_Y 176.0

#define INVENTORY_DEFAULT_MODEL_X 33.0
#define INVENTORY_DEFAULT_MODEL_Y 113.0


enum RENDERTYPE {
	RENDERTYPE_BTN,
	RENDERTYPE_MODEL,
	RENDERTYPE_TITLE,
	RENDERTYPE_QUANTITY
}

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

new gInv_control_selectedItem[MAX_PLAYERS];

new PlayerText:txdInv_btnNEXT[MAX_PLAYERS];
new PlayerText:txdInv_btnPREVIOUS[MAX_PLAYERS];
new PlayerText:txdInv_btnUSE[MAX_PLAYERS];
new PlayerText:txdInv_btnSELL[MAX_PLAYERS];
new PlayerText:txdInv_btnDROP[MAX_PLAYERS];
new PlayerText:txdInv_btnSEPARATE[MAX_PLAYERS];
new PlayerText:txdInv_btnJOIN[MAX_PLAYERS];
new PlayerText:txdInv_btnCLOSE[MAX_PLAYERS];


/*
	Updates an item	by passing the row and column. UNSAFE: No out of bounds check!
						*/
forward InventoryRenderUpdateItem(playerid,row,column,newModel,const title[],const quantity[]);
public InventoryRenderUpdateItem(playerid,row,column,newModel,const title[],const quantity[]) {
	PlayerTextDrawSetPreviewModel(playerid,txdInv_render_model[playerid][row][column],newModel);
	PlayerTextDrawHide(playerid, txdInv_render_model[playerid][row][column]);
	PlayerTextDrawShow(playerid, txdInv_render_model[playerid][row][column]);
	PlayerTextDrawSetString(playerid,txdInv_render_title[playerid][row][column],title);
	PlayerTextDrawSetString(playerid,txdInv_render_quantity[playerid][row][column],quantity);
	return 1;
}


/*
	Updates an item by passing a index SAFE: Has out of bounds check.
	*/
forward InventoryRenderUpdateItemEx(playerid, index,newModel, const title[], const quantity[]);
public InventoryRenderUpdateItemEx(playerid, index,newModel, const title[], const quantity[]) {
    new i = index / INVENTORY_COLUMNLIMIT;
    new j = index % INVENTORY_COLUMNLIMIT;
    if (i >= INVENTORY_ROWLIMIT || j >= INVENTORY_COLUMNLIMIT) return 0;
    PlayerTextDrawSetPreviewModel(playerid, txdInv_render_model[playerid][i][j],newModel);
	PlayerTextDrawHide(playerid, txdInv_render_model[playerid][i][j]);
	PlayerTextDrawShow(playerid, txdInv_render_model[playerid][i][j]);
    PlayerTextDrawSetString(playerid, txdInv_render_title[playerid][i][j], title);
    PlayerTextDrawSetString(playerid, txdInv_render_quantity[playerid][i][j], quantity);
    return 1;
}

//Checks if player is currently with their inventory open or not.
forward IsPlayerInvOpen(playerid);
public IsPlayerInvOpen(playerid) {
	if(IsPlayerTextDrawVisible(playerid,txdInv_bg0[playerid]))return 1;
	return 0;
}
//Checks if player has an item, by modelid. If so, returns the quantity, otherwhise 0 */
forward DoesPlayerInvHaveItem(playerid,modelid);
public DoesPlayerInvHaveItem(playerid,modelid) {
	for(new i;i<INVENTORY_ROWLIMIT;i++) {
		for(new j;j<INVENTORY_COLUMNLIMIT;j++) {
			if(GetPlayerInvModelid(playerid,i,j)==modelid)return GetPlayerInvItemQuantity(playerid,i,j);
		}
	}
	return 0;
}
//Checks if player has an item, by modelid. If so, returns the 1D location. Otherwhsie returns 0 */
forward DoesPlayerInvHaveItemEx(playerid,modelid);
public DoesPlayerInvHaveItemEx(playerid,modelid) {
	for(new i;i<INVENTORY_ROWLIMIT;i++) {
		for(new j;j<INVENTORY_COLUMNLIMIT;j++) {
			if(GetPlayerInvModelid(playerid,i,j)==modelid)return i * INVENTORY_COLUMNLIMIT + j;
		}
	}
	return 0;
}
//Returns current selected item 1D index. If no item is selected, returns -1.
forward GetPlayerInvSelectedItem(playerid);
public GetPlayerInvSelectedItem(playerid) {
	if(!IsPlayerConnected(playerid))return -1;
	return gInv_control_selectedItem[playerid];
}
//Returns current selected item modelid. If no item is selected, returns -1.
forward GetPlayerInvSelectedItemEx(playerid);
public GetPlayerInvSelectedItemEx(playerid) {
	if(gInv_control_selectedItem[playerid] != -1)return GetPlayerInvModelidEx(playerid,gInv_control_selectedItem[playerid]);
	return -1;
}
// Gets an item quantity, by passing row and column. UNSAFE: No out of bounds check!
forward GetPlayerInvItemQuantity(playerid,row,column);
public GetPlayerInvItemQuantity(playerid,row,column) {
	new quantity[64];
	PlayerTextDrawGetString(playerid,txdInv_render_quantity[playerid][row][column],quantity,64);
	return strval(quantity);
}
//Gets an item quantity, by passing index. SAFE: Has out of bounds check and returns -1 if invalid.
forward GetPlayerInvItemQuantityEx(playerid,index);
public GetPlayerInvItemQuantityEx(playerid,index) {
    new i = index / INVENTORY_COLUMNLIMIT;
    new j = index % INVENTORY_COLUMNLIMIT;
    if (i >= INVENTORY_ROWLIMIT || j >= INVENTORY_COLUMNLIMIT) return -1;
	return PlayerTextDrawGetPreviewModel(playerid,txdInv_render_model[playerid][i][j]);

}
//Gets an item model id, by passing row and column. UNSAFE: No out of bounds check!
forward GetPlayerInvModelid(playerid,row,column);
public GetPlayerInvModelid(playerid,row,column) {
	return PlayerTextDrawGetPreviewModel(playerid,txdInv_render_model[playerid][row][column]);
}
//Gets an item model id, by passing index. SAFE: Has out of bounds check. Retruns -1 if invalid.
forward GetPlayerInvModelidEx(playerid,index);
public GetPlayerInvModelidEx(playerid,index) {
    new i = index / INVENTORY_COLUMNLIMIT;
    new j = index % INVENTORY_COLUMNLIMIT;
    if (i >= INVENTORY_ROWLIMIT || j >= INVENTORY_COLUMNLIMIT) return -1;
	return PlayerTextDrawGetPreviewModel(playerid,txdInv_render_model[playerid][i][j]);
}
//Counts how many valid items the player currently has rendered. The inventory SHOULD be open, otherwhise returns zero.
forward GetPlayerInvItemCount(playerid);
public GetPlayerInvItemCount(playerid) {
	new itemAmount;
	if(IsPlayerInvOpen(playerid)) {
		for(new i;i<INVENTORY_ROWLIMIT;i++) {
			for(new j;j<INVENTORY_ROWLIMIT;j++) {
				if(GetPlayerInvItemQuantity(playerid,i,j))itemAmount++;
			}
		}
	}
	return itemAmount;
}


/*
	Starts to prepare render all of the inventories items.
	Doesn't show them. Should be called OnPlayerConnect with the other txd stuff
															*/
forward InventoryRenderInit(playerid);
public InventoryRenderInit(playerid) {
    new Float:defaultX[] = {INVENTORY_DEFAULT_BTN_X,INVENTORY_DEFAULT_MODEL_X,INVENTORY_DEFAULT_TITLE_X,INVENTORY_DEFAULT_QTT_X};
    new Float:defaultY[] = {INVENTORY_DEFAULT_BTN_Y,INVENTORY_DEFAULT_MODEL_Y,INVENTORY_DEFAULT_TITLE_Y,INVENTORY_DEFAULT_QTT_Y};
	for(new i;i<INVENTORY_ROWLIMIT;i++) {
		for(new j;j<INVENTORY_COLUMNLIMIT;j++) {
            txdInv_render_btn[playerid][i][j] = CreatePlayerTextDraw(playerid,defaultX[0],defaultY[0], "LD_DUAL:white");
			txdInv_render_model[playerid][i][j] = CreatePlayerTextDraw(playerid,defaultX[1],defaultY[1], "Preview_Model");
            txdInv_render_title[playerid][i][j] = CreatePlayerTextDraw(playerid,defaultX[2],defaultY[2], "_");
			txdInv_render_quantity[playerid][i][j] = CreatePlayerTextDraw(playerid,defaultX[3],defaultY[3], "_");
			ApplyInvPropetiesPtr(playerid,txdInv_render_btn[playerid][i][j],RENDERTYPE_BTN);
            ApplyInvPropetiesPtr(playerid,txdInv_render_model[playerid][i][j],RENDERTYPE_MODEL);
            ApplyInvPropetiesPtr(playerid,txdInv_render_title[playerid][i][j],RENDERTYPE_TITLE);
			ApplyInvPropetiesPtr(playerid,txdInv_render_quantity[playerid][i][j],RENDERTYPE_QUANTITY);
			for(new k;k<sizeof(defaultX);k++)defaultX[k]+=cstInv_renderOffset;
		}
        defaultX[0] = INVENTORY_DEFAULT_BTN_X;
        defaultX[1] = INVENTORY_DEFAULT_MODEL_X;
        defaultX[2] = INVENTORY_DEFAULT_TITLE_X;
        defaultX[3] = INVENTORY_DEFAULT_QTT_X;

        for(new l;l<sizeof(defaultY);l++)defaultY[l]+=cstInv_renderOffset;
	}
    return 1;
}
// Applies the propeties by reference. Shouldn't be used elsewhere other than InventoryRenderInit.
stock ApplyInvPropetiesPtr(playerid,&PlayerText:renderText,type) { // In pawn, & represents a pointer.
	if(type==RENDERTYPE_BTN) {
		//button bullshit
		PlayerTextDrawFont(playerid, renderText, 4);
		PlayerTextDrawLetterSize(playerid, renderText, 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, renderText, 82.000000, 82.000000);
		PlayerTextDrawSetOutline(playerid, renderText, 1);
		PlayerTextDrawSetShadow(playerid, renderText, 0);
		PlayerTextDrawAlignment(playerid, renderText, 1);
		PlayerTextDrawColor(playerid, renderText,COLOR_GRAY);
		PlayerTextDrawBackgroundColor(playerid, renderText,255);
		PlayerTextDrawBoxColor(playerid,renderText, 50);
		PlayerTextDrawUseBox(playerid, renderText, 1);
		PlayerTextDrawSetProportional(playerid,renderText, 1);
		PlayerTextDrawSetSelectable(playerid,renderText, 1);
	}
	if(type==RENDERTYPE_MODEL) {
		PlayerTextDrawFont(playerid, renderText, 5);
		PlayerTextDrawLetterSize(playerid, renderText, 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, renderText, 82.000000, 81.500000);
		PlayerTextDrawSetOutline(playerid, renderText, 0);
		PlayerTextDrawSetShadow(playerid, renderText, 0);
		PlayerTextDrawAlignment(playerid, renderText, 1);
		PlayerTextDrawColor(playerid, renderText, -1);
		PlayerTextDrawBackgroundColor(playerid, renderText, 0);
		PlayerTextDrawBoxColor(playerid, renderText, 255);
		PlayerTextDrawUseBox(playerid, renderText, 0);
		PlayerTextDrawSetProportional(playerid, renderText, 1);
		PlayerTextDrawSetSelectable(playerid, renderText, 0);
		PlayerTextDrawSetPreviewModel(playerid, renderText ,18631);
		PlayerTextDrawSetPreviewRot(playerid, renderText , 0.000000,-1.000000,-20.000000 ,1.200000);
		PlayerTextDrawSetPreviewVehCol(playerid ,renderText ,1 ,1 );
	}
	if(type==RENDERTYPE_QUANTITY) {
		//quantity bullshit
		PlayerTextDrawFont(playerid, renderText, 1);
		PlayerTextDrawLetterSize(playerid, renderText, 0.174998, 1.350000);
		PlayerTextDrawTextSize(playerid, renderText, 119.000000, 77.000000);
		PlayerTextDrawSetOutline(playerid, renderText, 0);
		PlayerTextDrawSetShadow(playerid, renderText, 0);
		PlayerTextDrawAlignment(playerid, renderText, 1);
		PlayerTextDrawColor(playerid, renderText, -1);
		PlayerTextDrawBackgroundColor(playerid, renderText, 255);
		PlayerTextDrawBoxColor(playerid, renderText, 50);
		PlayerTextDrawUseBox(playerid, renderText, 0);
		PlayerTextDrawSetProportional(playerid, renderText ,1);
		PlayerTextDrawSetSelectable(playerid ,renderText ,0 );
	}
	if(type==RENDERTYPE_TITLE) {
		//title bs
		PlayerTextDrawFont(playerid, renderText, 1);
		PlayerTextDrawLetterSize(playerid, renderText, 0.200000, 2.099997);
		PlayerTextDrawTextSize(playerid, renderText, 400.000000, 78.000000);
		PlayerTextDrawSetOutline(playerid, renderText, 0);
		PlayerTextDrawSetShadow(playerid, renderText, 0);
		PlayerTextDrawAlignment(playerid, renderText ,2);
		PlayerTextDrawColor(playerid ,renderText ,-1);
		PlayerTextDrawBackgroundColor(playerid ,renderText ,255);
		PlayerTextDrawBoxColor(playerid ,renderText ,50);
		PlayerTextDrawUseBox(playerid ,renderText ,0);
		PlayerTextDrawSetProportional(playerid ,renderText ,1);
		PlayerTextDrawSetSelectable(playerid ,renderText ,0 );
	}
}

YCMD:inv(playerid,params[],help) {
	SendClientMessage(playerid,-1,"OPEEEN");
	OpenInventory(playerid);
	InventoryRenderUpdateItemEx(playerid,0,33,GetItemNameString(33),"1");
	InventoryRenderUpdateItemEx(playerid,1,34,GetItemNameString(34),"22");
	InventoryRenderUpdateItemEx(playerid,2,ITEM_RESPEITO,GetItemNameString(ITEM_RESPEITO),"1");
	InventoryRenderUpdateItemEx(playerid,3,ITEM_GASOLINA,GetItemNameString(ITEM_GASOLINA),"344");
	return 1;
}
forward OpenInventory(playerid);
public OpenInventory(playerid) {
	if(IsPlayerLoggedIn(playerid)) {
		PlayerTextDrawShow(playerid, txdInv_bg0[playerid]);
		PlayerTextDrawShow(playerid, txdInv_Title[playerid]);
		PlayerTextDrawShow(playerid, txdInv_btnCLOSE[playerid]);
		PlayerTextDrawShow(playerid, txdInv_bg1[playerid]);
		PlayerTextDrawShow(playerid, txdInv_bg2[playerid]);
		PlayerTextDrawShow(playerid, txdInv_btnNEXT[playerid]);
		PlayerTextDrawShow(playerid, txdInv_btnPREVIOUS[playerid]);
		PlayerTextDrawShow(playerid, txdInv_btnUSE[playerid]);
		PlayerTextDrawShow(playerid, txdInv_btnSELL[playerid]);
		PlayerTextDrawShow(playerid, txdInv_btnDROP[playerid]);
		PlayerTextDrawShow(playerid, txdInv_btnSEPARATE[playerid]);
		PlayerTextDrawShow(playerid, txdInv_btnJOIN[playerid]);
		PlayerTextDrawShow(playerid, txdInv_Page[playerid]);
		for(new i;i<INVENTORY_ROWLIMIT;i++) {
			for(new j;j<INVENTORY_COLUMNLIMIT;j++) {
				PlayerTextDrawShow(playerid, txdInv_render_quantity[playerid][i][j]);
				PlayerTextDrawShow(playerid, txdInv_render_btn[playerid][i][j]);
				PlayerTextDrawShow(playerid, txdInv_render_model[playerid][i][j]);
				PlayerTextDrawShow(playerid, txdInv_render_title[playerid][i][j]);
			}
		}
		SelectTextDraw(playerid, 0xFF0000FF);
	}
}
forward CloseInventory(playerid);
public CloseInventory(playerid) {
	if(IsPlayerLoggedIn(playerid)&&IsPlayerInvOpen(playerid)) {
		gInv_control_selectedItem[playerid]=-1;
		PlayerTextDrawSetString(playerid,txdInv_Title[playerid],"Nenhum item selecionado");
		PlayerTextDrawHide(playerid, txdInv_bg0[playerid]);
		PlayerTextDrawHide(playerid, txdInv_Title[playerid]);
		PlayerTextDrawHide(playerid, txdInv_btnCLOSE[playerid]);
		PlayerTextDrawHide(playerid, txdInv_bg1[playerid]);
		PlayerTextDrawHide(playerid, txdInv_bg2[playerid]);
		PlayerTextDrawHide(playerid, txdInv_btnNEXT[playerid]);
		PlayerTextDrawHide(playerid, txdInv_btnPREVIOUS[playerid]);
		PlayerTextDrawHide(playerid, txdInv_btnUSE[playerid]);
		PlayerTextDrawHide(playerid, txdInv_btnSELL[playerid]);
		PlayerTextDrawHide(playerid, txdInv_btnDROP[playerid]);
		PlayerTextDrawHide(playerid, txdInv_btnSEPARATE[playerid]);
		PlayerTextDrawHide(playerid, txdInv_btnJOIN[playerid]);
		PlayerTextDrawHide(playerid, txdInv_Page[playerid]);
		for(new i;i<INVENTORY_ROWLIMIT;i++) {
			for(new j;j<INVENTORY_COLUMNLIMIT;j++) {
				PlayerTextDrawHide(playerid, txdInv_render_quantity[playerid][i][j]);
				PlayerTextDrawHide(playerid, txdInv_render_btn[playerid][i][j]);
				PlayerTextDrawHide(playerid, txdInv_render_model[playerid][i][j]);
				PlayerTextDrawHide(playerid, txdInv_render_title[playerid][i][j]);
			}
		}
		CancelSelectTextDraw(playerid);
	}
}
//Handles selected logic.
hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) {
	if(IsPlayerInvOpen(playerid)) {
		new msg[255];
		for(new i;i<INVENTORY_ROWLIMIT;i++) {
			for(new j;j<INVENTORY_COLUMNLIMIT;j++) {
				PlayerTextDrawHide(playerid,txdInv_render_btn[playerid][i][j]);
				if(GetPlayerInvItemQuantity(playerid,i,j))PlayerTextDrawColor(playerid,txdInv_render_btn[playerid][i][j],COLOR_GRAY);
				if(playertextid==txdInv_render_btn[playerid][i][j]) {
					if(GetPlayerInvItemQuantity(playerid,i,j)) {
						gInv_control_selectedItem[playerid]=i * INVENTORY_COLUMNLIMIT + j;
						PlayerTextDrawColor(playerid,txdInv_render_btn[playerid][i][j],COLOR_AQUA);
						PlayerTextDrawGetString(playerid,txdInv_render_title[playerid][i][j],msg,255);
						format(msg,255,"Selecionado: ~b~~h~~h~~h~%dx~w~%s",GetPlayerInvItemQuantity(playerid,i,j),msg);
						PlayerTextDrawSetString(playerid,txdInv_Title[playerid],msg);
					}
					else {
						PlayerTextDrawSetString(playerid,txdInv_Title[playerid],"Nenhum item selecionado");
					}
				}
				PlayerTextDrawShow(playerid,txdInv_render_btn[playerid][i][j]);
			}
		}
	}
	return 1;
}
// Handles inventory close logic
#include <YSI_Coding\y_hooks>
hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) {
	if(playertextid==txdInv_btnCLOSE[playerid]&&IsPlayerInvOpen(playerid))  {
		CloseInventory(playerid); 
	}
}

hook OnPlayerConnect(playerid)
{
	gInv_control_selectedItem[playerid] = -1;
	txdInv_bg0[playerid] = CreatePlayerTextDraw(playerid, 37.000000, 85.000000, "LD_DUAL:white");
	PlayerTextDrawFont(playerid, txdInv_bg0[playerid], 4);
	PlayerTextDrawLetterSize(playerid, txdInv_bg0[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, txdInv_bg0[playerid], 527.000000, 327.500000);
	PlayerTextDrawSetOutline(playerid, txdInv_bg0[playerid], 1);
	PlayerTextDrawSetShadow(playerid, txdInv_bg0[playerid], 0);
	PlayerTextDrawAlignment(playerid, txdInv_bg0[playerid], 1);
	PlayerTextDrawColor(playerid, txdInv_bg0[playerid], 1433087999);
	PlayerTextDrawBackgroundColor(playerid, txdInv_bg0[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdInv_bg0[playerid], 50);
	PlayerTextDrawUseBox(playerid, txdInv_bg0[playerid], 1);
	PlayerTextDrawSetProportional(playerid, txdInv_bg0[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdInv_bg0[playerid], 0);

	txdInv_Title[playerid] = CreatePlayerTextDraw(playerid, 38.000000, 87.000000, "Nenhum item selecionado");
	PlayerTextDrawFont(playerid, txdInv_Title[playerid], 1);
	PlayerTextDrawLetterSize(playerid, txdInv_Title[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, txdInv_Title[playerid], 562.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, txdInv_Title[playerid], 0);
	PlayerTextDrawSetShadow(playerid, txdInv_Title[playerid], 0);
	PlayerTextDrawAlignment(playerid, txdInv_Title[playerid], 1);
	PlayerTextDrawColor(playerid, txdInv_Title[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, txdInv_Title[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdInv_Title[playerid], 50);
	PlayerTextDrawUseBox(playerid, txdInv_Title[playerid], 1);
	PlayerTextDrawSetProportional(playerid, txdInv_Title[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdInv_Title[playerid], 0);

	txdInv_btnCLOSE[playerid] = CreatePlayerTextDraw(playerid, 554.000000, 87.000000, "X");
	PlayerTextDrawFont(playerid, txdInv_btnCLOSE[playerid], 1);
	PlayerTextDrawLetterSize(playerid, txdInv_btnCLOSE[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, txdInv_btnCLOSE[playerid], 249.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, txdInv_btnCLOSE[playerid], 0);
	PlayerTextDrawSetShadow(playerid, txdInv_btnCLOSE[playerid], 0);
	PlayerTextDrawAlignment(playerid, txdInv_btnCLOSE[playerid], 2);
	PlayerTextDrawColor(playerid, txdInv_btnCLOSE[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, txdInv_btnCLOSE[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdInv_btnCLOSE[playerid], -16777166);
	PlayerTextDrawUseBox(playerid, txdInv_btnCLOSE[playerid], 1);
	PlayerTextDrawSetProportional(playerid, txdInv_btnCLOSE[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdInv_btnCLOSE[playerid], 1);

	

	txdInv_bg1[playerid] = CreatePlayerTextDraw(playerid, 37.000000, 383.000000, "LD_DUAL:white");
	PlayerTextDrawFont(playerid, txdInv_bg1[playerid], 4);
	PlayerTextDrawLetterSize(playerid, txdInv_bg1[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, txdInv_bg1[playerid], 527.000000, 2.500000);
	PlayerTextDrawSetOutline(playerid, txdInv_bg1[playerid], 1);
	PlayerTextDrawSetShadow(playerid, txdInv_bg1[playerid], 0);
	PlayerTextDrawAlignment(playerid, txdInv_bg1[playerid], 1);
	PlayerTextDrawColor(playerid, txdInv_bg1[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, txdInv_bg1[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdInv_bg1[playerid], 50);
	PlayerTextDrawUseBox(playerid, txdInv_bg1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, txdInv_bg1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdInv_bg1[playerid], 0);

	txdInv_bg2[playerid] = CreatePlayerTextDraw(playerid, 554.000000, 110.000000, "_");
	PlayerTextDrawFont(playerid, txdInv_bg2[playerid], 1);
	PlayerTextDrawLetterSize(playerid, txdInv_bg2[playerid], 0.600000, 30.099975);
	PlayerTextDrawTextSize(playerid, txdInv_bg2[playerid], 298.500000, 16.000000);
	PlayerTextDrawSetOutline(playerid, txdInv_bg2[playerid], 1);
	PlayerTextDrawSetShadow(playerid, txdInv_bg2[playerid], 0);
	PlayerTextDrawAlignment(playerid, txdInv_bg2[playerid], 2);
	PlayerTextDrawColor(playerid, txdInv_bg2[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, txdInv_bg2[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdInv_bg2[playerid], 135);
	PlayerTextDrawUseBox(playerid, txdInv_bg2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, txdInv_bg2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdInv_bg2[playerid], 0);

	txdInv_btnNEXT[playerid] = CreatePlayerTextDraw(playerid, 545.000000, 359.000000, "LD_BEAT:down");
	PlayerTextDrawFont(playerid, txdInv_btnNEXT[playerid], 4);
	PlayerTextDrawLetterSize(playerid, txdInv_btnNEXT[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, txdInv_btnNEXT[playerid], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, txdInv_btnNEXT[playerid], 1);
	PlayerTextDrawSetShadow(playerid, txdInv_btnNEXT[playerid], 0);
	PlayerTextDrawAlignment(playerid, txdInv_btnNEXT[playerid], 1);
	PlayerTextDrawColor(playerid, txdInv_btnNEXT[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, txdInv_btnNEXT[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdInv_btnNEXT[playerid], 50);
	PlayerTextDrawUseBox(playerid, txdInv_btnNEXT[playerid], 1);
	PlayerTextDrawSetProportional(playerid, txdInv_btnNEXT[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdInv_btnNEXT[playerid], 1);

	txdInv_btnPREVIOUS[playerid] = CreatePlayerTextDraw(playerid, 545.000000, 116.000000, "LD_BEAT:up");
	PlayerTextDrawFont(playerid, txdInv_btnPREVIOUS[playerid], 4);
	PlayerTextDrawLetterSize(playerid, txdInv_btnPREVIOUS[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, txdInv_btnPREVIOUS[playerid], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, txdInv_btnPREVIOUS[playerid], 1);
	PlayerTextDrawSetShadow(playerid, txdInv_btnPREVIOUS[playerid], 0);
	PlayerTextDrawAlignment(playerid, txdInv_btnPREVIOUS[playerid], 1);
	PlayerTextDrawColor(playerid, txdInv_btnPREVIOUS[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, txdInv_btnPREVIOUS[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdInv_btnPREVIOUS[playerid], 50);
	PlayerTextDrawUseBox(playerid, txdInv_btnPREVIOUS[playerid], 1);
	PlayerTextDrawSetProportional(playerid, txdInv_btnPREVIOUS[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdInv_btnPREVIOUS[playerid], 1);

	txdInv_btnUSE[playerid] = CreatePlayerTextDraw(playerid, 46.000000, 390.000000, "USAR");
	PlayerTextDrawFont(playerid, txdInv_btnUSE[playerid], 3);
	PlayerTextDrawLetterSize(playerid, txdInv_btnUSE[playerid], 0.629166, 2.000000);
	PlayerTextDrawTextSize(playerid, txdInv_btnUSE[playerid], 95.500000, 42.000000);
	PlayerTextDrawSetOutline(playerid, txdInv_btnUSE[playerid], 0);
	PlayerTextDrawSetShadow(playerid, txdInv_btnUSE[playerid], 1);
	PlayerTextDrawAlignment(playerid, txdInv_btnUSE[playerid], 1);
	PlayerTextDrawColor(playerid, txdInv_btnUSE[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, txdInv_btnUSE[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdInv_btnUSE[playerid], 50);
	PlayerTextDrawUseBox(playerid, txdInv_btnUSE[playerid], 1);
	PlayerTextDrawSetProportional(playerid, txdInv_btnUSE[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdInv_btnUSE[playerid], 1);

	txdInv_btnSELL[playerid] = CreatePlayerTextDraw(playerid, 135.000000, 390.000000, "VENDER");
	PlayerTextDrawFont(playerid, txdInv_btnSELL[playerid], 3);
	PlayerTextDrawLetterSize(playerid, txdInv_btnSELL[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, txdInv_btnSELL[playerid], 205.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, txdInv_btnSELL[playerid], 0);
	PlayerTextDrawSetShadow(playerid, txdInv_btnSELL[playerid], 1);
	PlayerTextDrawAlignment(playerid, txdInv_btnSELL[playerid], 1);
	PlayerTextDrawColor(playerid, txdInv_btnSELL[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, txdInv_btnSELL[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdInv_btnSELL[playerid], 50);
	PlayerTextDrawUseBox(playerid, txdInv_btnSELL[playerid], 1);
	PlayerTextDrawSetProportional(playerid, txdInv_btnSELL[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdInv_btnSELL[playerid], 1);

	txdInv_btnDROP[playerid] = CreatePlayerTextDraw(playerid, 236.000000, 390.000000, "descArtar");
	PlayerTextDrawFont(playerid, txdInv_btnDROP[playerid], 3);
	PlayerTextDrawLetterSize(playerid, txdInv_btnDROP[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, txdInv_btnDROP[playerid], 341.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, txdInv_btnDROP[playerid], 0);
	PlayerTextDrawSetShadow(playerid, txdInv_btnDROP[playerid], 1);
	PlayerTextDrawAlignment(playerid, txdInv_btnDROP[playerid], 1);
	PlayerTextDrawColor(playerid, txdInv_btnDROP[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, txdInv_btnDROP[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdInv_btnDROP[playerid], 50);
	PlayerTextDrawUseBox(playerid, txdInv_btnDROP[playerid], 1);
	PlayerTextDrawSetProportional(playerid, txdInv_btnDROP[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdInv_btnDROP[playerid], 1);

	txdInv_btnSEPARATE[playerid] = CreatePlayerTextDraw(playerid, 360.000000, 390.000000, "separar");
	PlayerTextDrawFont(playerid, txdInv_btnSEPARATE[playerid], 3);
	PlayerTextDrawLetterSize(playerid, txdInv_btnSEPARATE[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, txdInv_btnSEPARATE[playerid], 440.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, txdInv_btnSEPARATE[playerid], 0);
	PlayerTextDrawSetShadow(playerid, txdInv_btnSEPARATE[playerid], 1);
	PlayerTextDrawAlignment(playerid, txdInv_btnSEPARATE[playerid], 1);
	PlayerTextDrawColor(playerid, txdInv_btnSEPARATE[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, txdInv_btnSEPARATE[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdInv_btnSEPARATE[playerid], 50);
	PlayerTextDrawUseBox(playerid, txdInv_btnSEPARATE[playerid], 1);
	PlayerTextDrawSetProportional(playerid, txdInv_btnSEPARATE[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdInv_btnSEPARATE[playerid], 1);

	txdInv_btnJOIN[playerid] = CreatePlayerTextDraw(playerid, 465.000000, 390.000000, "juntar");
	PlayerTextDrawFont(playerid, txdInv_btnJOIN[playerid], 3);
	PlayerTextDrawLetterSize(playerid, txdInv_btnJOIN[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, txdInv_btnJOIN[playerid], 535.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, txdInv_btnJOIN[playerid], 0);
	PlayerTextDrawSetShadow(playerid, txdInv_btnJOIN[playerid], 1);
	PlayerTextDrawAlignment(playerid, txdInv_btnJOIN[playerid], 1);
	PlayerTextDrawColor(playerid, txdInv_btnJOIN[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, txdInv_btnJOIN[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdInv_btnJOIN[playerid], 50);
	PlayerTextDrawUseBox(playerid, txdInv_btnJOIN[playerid], 1);
	PlayerTextDrawSetProportional(playerid, txdInv_btnJOIN[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdInv_btnJOIN[playerid], 1);
	new msgMaxPages[255];
	format(msgMaxPages,255,"Pagina 1/%d",INVENTORY_MAXPAGES);
	txdInv_Page[playerid] = CreatePlayerTextDraw(playerid, 432.000000, 85.000000,msgMaxPages);
	PlayerTextDrawFont(playerid, txdInv_Page[playerid], 1);
	PlayerTextDrawLetterSize(playerid, txdInv_Page[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, txdInv_Page[playerid], 610.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, txdInv_Page[playerid], 0);
	PlayerTextDrawSetShadow(playerid, txdInv_Page[playerid], 0);
	PlayerTextDrawAlignment(playerid, txdInv_Page[playerid], 1);
	PlayerTextDrawColor(playerid, txdInv_Page[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, txdInv_Page[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdInv_Page[playerid], 50);
	PlayerTextDrawUseBox(playerid, txdInv_Page[playerid], 0);
	PlayerTextDrawSetProportional(playerid, txdInv_Page[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdInv_Page[playerid], 0);
	
    InventoryRenderInit(playerid);

	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	PlayerTextDrawDestroy(playerid, txdInv_bg0[playerid]);
	PlayerTextDrawDestroy(playerid, txdInv_Title[playerid]);
	PlayerTextDrawDestroy(playerid, txdInv_btnCLOSE[playerid]);
	PlayerTextDrawDestroy(playerid, txdInv_bg1[playerid]);
	PlayerTextDrawDestroy(playerid, txdInv_bg2[playerid]);
	PlayerTextDrawDestroy(playerid, txdInv_btnNEXT[playerid]);
	PlayerTextDrawDestroy(playerid, txdInv_btnPREVIOUS[playerid]);
	PlayerTextDrawDestroy(playerid, txdInv_btnUSE[playerid]);
	PlayerTextDrawDestroy(playerid, txdInv_btnSELL[playerid]);
	PlayerTextDrawDestroy(playerid, txdInv_btnDROP[playerid]);
	PlayerTextDrawDestroy(playerid, txdInv_btnSEPARATE[playerid]);
	PlayerTextDrawDestroy(playerid, txdInv_btnJOIN[playerid]);
	PlayerTextDrawDestroy(playerid, txdInv_Page[playerid]);
	for(new i;i<INVENTORY_ROWLIMIT;i++) {
		for(new j;j<INVENTORY_COLUMNLIMIT;j++) {
			PlayerTextDrawDestroy(playerid, txdInv_render_quantity[playerid][i][j]);
			PlayerTextDrawDestroy(playerid, txdInv_render_btn[playerid][i][j]);
			PlayerTextDrawDestroy(playerid, txdInv_render_model[playerid][i][j]);
			PlayerTextDrawDestroy(playerid, txdInv_render_title[playerid][i][j]);
		}
	}
	return 1;
}


