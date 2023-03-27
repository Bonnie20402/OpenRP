
#include <YSI_Coding\y_hooks>


new interiorCentroDeLicencas_PICKUP;
new interiorCentroDeLicencas_TEXT;
new const Float:interiorCentroDeLicencas_BUYLOC[] = {-2033.2815,-117.3587,1035.1719}; // the thing to buy veichle licenses
forward Cdl_lsInit();
public Cdl_lsInit() {
    new rowid;
    rowid=GetCompanyIdFromName("Centro de Licenças");
    if(rowid) {
        new interiorid;
        interiorid=GetCompanyInteriorId(rowid);
        new String:text[256];
        format(text,256,"Centro de Licenças\nAperte Y para adquirir licenças!");
        interiorCentroDeLicencas_PICKUP = CreateDynamicPickup(1581,1,interiorCentroDeLicencas_BUYLOC[0],interiorCentroDeLicencas_BUYLOC[1],interiorCentroDeLicencas_BUYLOC[2],rowid,interiorid);
        interiorCentroDeLicencas_TEXT = CreateDynamic3DTextLabel(text,-1,interiorCentroDeLicencas_BUYLOC[0],interiorCentroDeLicencas_BUYLOC[1],interiorCentroDeLicencas_BUYLOC[2],25.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,rowid,interiorid);
        print("[cdl_ls.pwn] Centro de Licenças LS Company loaded");
    }
    else print("[cdl_ls.pwn] WARN -> No CDL  company found. Name: Centro de Licenças");
    return 1;
}