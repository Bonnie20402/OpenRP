
#define INVENTORY_MAXDROPS MAX_PICKUPS
#define INVDROP_EXPIRETIMER 10 // Timer in seconds for the item to be deleted forever.

#define INVDROP_CONFIG_SAVE 0 // 0: Don't save drops to disk. 1: Save drop locations to disk.
#define INVDROP_CONFIG_TEXTDRAW 1 // 0: Disable pickup textdraws. 1: Enable pickup textdraws

enum DROP {
    String:DROP_AUTHOR[MAX_PLAYER_NAME],
    DROP_PICKUPID,
    DROP_MODELID,
    DROP_SPHEREID,
    DROP_QUANTITY,
    DROP_WORLDID,
    DROP_INTERIORID
}


// TODO work on item drops
// TODO create spheres around the item to show some cool ass pick item textdraw
new gInv_control_droppedItens[INVENTORY_MAXDROPS][DROP];

forward OnPlayerInvActionDrop(playerid,modelid,quantity);
public OnPlayerInvActionDrop(playerid,modelid,quantity) {
    return 1;
}