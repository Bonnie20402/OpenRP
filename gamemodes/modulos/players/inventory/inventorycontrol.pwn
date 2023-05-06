/*
	Inventory module: inventorycontrol.pwn
	Updates the current selected player inv item as well as the current open inventory page.
    Uses the InvGUI module
	Prefix: InvControl:			*/


#include <YSI_Coding\y_hooks>

new gInv_control_selectedItem[MAX_PLAYERS];
new gInv_control_currentPage[MAX_PLAYERS];
new gInv_control_items[MAX_PLAYERS][INVENTORY_MAXPAGES*INVENTORY_SIZE][ITEMDATA];


//Updates current page. Handles both the control variable and the textdraw.
forward InvControl:SetPlayerInvPage(playerid,page);
public InvControl:SetPlayerInvPage(playerid,page) {
	if(IsPlayerLoggedIn(playerid)&&IsPlayerInvOpen(playerid)) {
		gInv_control_currentPage[playerid]=page;
		new msg[255];
		format(msg,255,"Pagina %d/%d",page,INVENTORY_MAXPAGES);
		PlayerTextDrawSetString(playerid,txdInv_Page[playerid],msg);
		return 1;
	}
	else {
		gInv_control_currentPage[playerid]=0;
	}
	return 0;
}
forward InvControl:SetPlayerInvSelectedItem(playerid,index);
public InvControl:SetPlayerInvSelectedItem(playerid,index) {
    gInv_control_selectedItem[playerid]=index;
    if(index==-1)PlayerTextDrawSetString(playerid,txdInv_Title[playerid],"Nenhum item selecionado");
    return 1;
}
hook OnFilterScriptInit() {
    for(new i;i<MAX_PLAYERS;i++)gInv_control_selectedItem[i]=-1;
    return 1;
}
hook OnPlayerConnect(playerid) {
    gInv_control_selectedItem[playerid] = -1;
    gInv_control_currentPage[playerid]=0;
    return 1;
}
hook OnPlayerDisconnect(playerid, reason) {
    gInv_control_selectedItem[playerid] = -1;
    gInv_control_currentPage[playerid]=0;
    return 1;
}