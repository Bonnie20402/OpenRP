#include <YSI_Coding\y_hooks>
// HOLDING(keys)
#define HOLDING(%0) \
    ((newkeys & (%0)) == (%0))
// PRESSED(keys)
#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
// PRESSING(keyVariable, keys)
#define PRESSING(%0,%1) \
    (%0 & (%1))
hook OnPlayerKeyStateChange(playerid,newkeys,oldkeys) {
    if(PRESSED(KEY_YES)) {
        if(IsPlayerInAnyVehicle(playerid)) {
            new vehicleid,engine,lights,doors,alarm,bonnet,boot,objective;
            vehicleid=GetPlayerVehicleID(playerid);
            GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
            if(!engine) {
                if(GetVehicleFuel(vehicleid)) {
                    engine=1;
                    lights=1;
                    ShowPlayerScreenMessage(playerid,2000,"Veiculo ligado!");     
                }
                else ShowPlayerScreenMessage(playerid,2000,"Veiculo sem combustivel!");
            }
            else {
                engine=0;
                lights=0;
                ShowPlayerScreenMessage(playerid,2000,"Veiculo desligado!");     
            }
            SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
        }
    }
    return 1;
}