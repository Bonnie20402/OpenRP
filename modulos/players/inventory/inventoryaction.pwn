
/*
	Inventory module: inventoryaction.pwn
	Forward the button's logic to their own functions (located at modulos/player/inventory/actions/)
	Prefix: InvAction			*/

public InvAction:OnPlayerInvAction(playerid,modelid,quantity,actiontype) {
	if(modelid==ITEM_INVALID)return 1;
    if(!quantity) return 1;
	if(actiontype==INVACTION_USE) {
        OnPlayerInvActionUse(playerid,modelid,quantity);
	}
    if(actiontype==INVACTION_DROP) {
        OnPlayerInvActionDrop(playerid,modelid,quantity);
    }
    if(actiontype==INVACTION_SELL) {
        OnPlayerInvActionSell(playerid,modelid,quantity);
    }
    if(actiontype==INVACTION_SEPARATE) {
        OnPlayerInvActionSeparate(playerid,modelid,quantity);
    }
    if(actiontype==INVACTION_JOIN) {
        OnPlayerInvActionJoin(playerid,modelid,quantity);
    }
	return 1;
}





