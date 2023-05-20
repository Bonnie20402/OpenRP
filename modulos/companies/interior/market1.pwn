#include <YSI_Coding\y_hooks>


new interiorMarket1_PICKUP;
new interiorMarket1_TEXT;
new const Float:interiorMarket1_SHOPLOCATION[] = {-20.9308,-138.6448,1003.5469};
forward Market1Init();
public Market1Init() {
    new rowid;
    rowid=GetCompanyIdFromName("Mercado 24/7");
    if(rowid) {
        new interiorid;
        interiorid=GetCompanyInteriorId(rowid);
        new String:text[256];
        format(text,256,"Mercado 24/7\nAperte Y para adquirir produtos");
        interiorMarket1_PICKUP = CreateDynamicPickup(1274,1,interiorMarket1_SHOPLOCATION[0],interiorMarket1_SHOPLOCATION[1],interiorMarket1_SHOPLOCATION[2],rowid,interiorid);
        interiorMarket1_TEXT = CreateDynamic3DTextLabel(text,-1,interiorMarket1_SHOPLOCATION[0],interiorMarket1_SHOPLOCATION[1],interiorMarket1_SHOPLOCATION[2],25.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,rowid,interiorid);
        print("[market.pwn] Market Company loaded");
    }
    else {
        print("[market.pwn] WARN -> No market company found. Name: Mercado 24/7");
    }
    return 1;
}