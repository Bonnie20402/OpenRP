#include <YSI_Coding\y_hooks>
hook OnPlayerKeyStateChange(playerid,newkeys,oldkeys) {
    if(PRESSED(KEY_YES)) {
        if(IsPlayerInAnyVehicle(playerid)) {
            new Float:health;
            new vehicleid,engine,lights,doors,alarm,bonnet,boot,objective;
            vehicleid=GetPlayerVehicleID(playerid);
            GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
            GetVehicleHealth(vehicleid,health);
            if(!engine) {
                //TODO prevent catch fire
                if(GetVehicleFuel(vehicleid)) {
                        if(health>250) {
                        engine=1;
                        lights=1;
                        ShowPlayerScreenMessage(playerid,2000,"Veiculo ligado!");
                        }
                        else ShowPlayerScreenMessage(playerid,2000,"Veiculo quebrado!");  
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