
#include <YSI_Coding\y_hooks>
public OnPlayerInvAction(playerid,modelid,quantity,actiontype) {
	if(modelid==ITEM_INVALID)return 1;
    if(!quantity) return 1;
	if(actiontype==INVACTION_USE) {
        OnPlayerInvActionUse(playerid,modelid,quantity);
	}
    if(actiontype==INVACTION_DROP) {
        SendClientMessagef(playerid,-1,"Drop phase0 modelid %d qtt %d",modelid,quantity);
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





