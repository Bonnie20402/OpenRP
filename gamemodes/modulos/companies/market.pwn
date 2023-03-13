#include <YSI_Coding\y_hooks>


new gMarket_PICKUP;
new gMarket_TEXT;
new const Float:gMarket_SHOPLOCATION[] = {-20.9308,-138.6448,1003.5469};
forward MarketInit();
public MarketInit() {
    new rowid;
    rowid=GetCompanyIdFromName("Mercado 24/7");
    if(rowid) {
        new interiorid;
        interiorid=GetCompanyInteriorId(rowid);
        DestroyDynamicPickup(gMarket_PICKUP);
        DestroyDynamic3DTextLabel(gMarket_TEXT);
        new String:text[256];
        format(text,256,"Mercado 24/7\nAperte Y para adquirir produtos");
        gMarket_PICKUP = CreateDynamicPickup(1274,1,gMarket_SHOPLOCATION[0],gMarket_SHOPLOCATION[1],gMarket_SHOPLOCATION[2],rowid,interiorid);
        gMarket_TEXT = CreateDynamic3DTextLabel(text,-1,gMarket_SHOPLOCATION[0],gMarket_SHOPLOCATION[1],gMarket_SHOPLOCATION[2],25.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,rowid,interiorid);
        print("[market.pwn] Market Company loaded");
    }
    else {
        print("[market.pwn] WARN -> No market company found. Name: Mercado 24/7");
    }
    return 1;
}