
#include <YSI_Coding\y_hooks>

// Cluckin' Bell
new interiorRestaurante1_PICKUP;
new interiorRestaurante1_TEXT;
new const Float:interiorRestaurante1_BUYLOC[] = {370.9290,-6.1019,1001.8589}; // the thing to buy food :)
forward Rest1Init();
public Rest1Init() {
    new rowid;
    rowid=GetCompanyIdFromName("Restaurante 1");
    if(rowid) {
        new interiorid;
        interiorid=GetCompanyInteriorId(rowid);
        new String:text[256];
        format(text,256,"Cluckin' Bell\nAperte Y para realizar o seu pedido!");
        interiorRestaurante1_PICKUP = CreateDynamicPickup(1274,1,interiorRestaurante1_BUYLOC[0],interiorRestaurante1_BUYLOC[1],interiorRestaurante1_BUYLOC[2],rowid,interiorid);
        interiorRestaurante1_TEXT = CreateDynamic3DTextLabel(text,-1,interiorRestaurante1_BUYLOC[0],interiorRestaurante1_BUYLOC[1],interiorRestaurante1_BUYLOC[2],25.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,rowid,interiorid);
        print("[rest1.pwn] Restaurante 1 Company loaded - cluckin bell ");
    }
    else print("[rest1.pwn] WARN -> No retaurante1 company found. Name: Restaurante 1");
    return 1;
}