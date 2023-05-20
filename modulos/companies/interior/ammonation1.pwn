
#include <YSI_Coding\y_hooks>


new interiorAmmunation1_PICKUP;
new interiorAmmunation1_TEXT;
new const Float:interiorAmmunation1_BUYLOC[] = {297.5204,-80.5325,1001.5156}; // the thing to buy weapons
forward Ammunation1Init();
public Ammunation1Init() {
    new rowid;
    rowid=GetCompanyIdFromName("Ammu-Nation 1");
    if(rowid) {
        new interiorid;
        interiorid=GetCompanyInteriorId(rowid);
        new String:text[256];
        format(text,256,"Loja de Armas\nAperte Y para comprar armas!");
        
        interiorAmmunation1_PICKUP = CreateDynamicPickup(1274,1,interiorAmmunation1_BUYLOC[0],interiorAmmunation1_BUYLOC[1],interiorAmmunation1_BUYLOC[2],rowid,interiorid);
        interiorAmmunation1_TEXT = CreateDynamic3DTextLabel(text,-1,interiorAmmunation1_BUYLOC[0],interiorAmmunation1_BUYLOC[1],interiorAmmunation1_BUYLOC[2],25.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,rowid,interiorid);
        print("[ammunation1.pwn] Ammunation 1 Company loaded");
    }
    else print("[ammunation1.pwn] WARN -> No Ammunation 1 company found. Name: Ammunation 1");
    return 1;
}