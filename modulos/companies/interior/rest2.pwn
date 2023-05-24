
#include <YSI_Coding\y_hooks>

// Burger Shot
new interiorRestaurante2_PICKUP;
new interiorRestaurante2_AREAID;
new interiorRestaurante2_TEXT;
new const Float:interiorRestaurante2_BUYLOC[] = {376.4714,-67.8059,1001.5151}; // the thing to buy food :)
forward Rest2Init();
public Rest2Init() {
    new rowid;
    rowid=GetCompanyIdFromName("Restaurante 2");
    if(rowid) {
        new interiorid;
        interiorid=GetCompanyInteriorId(rowid);
        new String:text[256];
        format(text,256,"Burger Shot\nAperte Y para realizar o seu pedido!");
        interiorRestaurante2_PICKUP = CreateDynamicPickup(1274,1,interiorRestaurante2_BUYLOC[0],interiorRestaurante2_BUYLOC[1],interiorRestaurante2_BUYLOC[2],rowid,interiorid);
        interiorRestaurante2_AREAID = CreateDynamicSphere(interiorRestaurante2_BUYLOC[0],interiorRestaurante2_BUYLOC[1],interiorRestaurante2_BUYLOC[2],1.0,-1,interiorid);
        interiorRestaurante2_TEXT = CreateDynamic3DTextLabel(text,-1,interiorRestaurante2_BUYLOC[0],interiorRestaurante2_BUYLOC[1],interiorRestaurante2_BUYLOC[2],25.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,rowid,interiorid);
        print("[rest2.pwn] Restaurante 2 Company loaded - Burger shot ");
    }
    else print("[rest2.pwn] WARN -> No company found. Name: Restaurante 2");
    return 1;
}

hook OnPlayerEnterDynArea(p,a) {
    if(a==interiorRestaurante1_AREAID)ShowRestaurantDialog(p);
    return 1;
}