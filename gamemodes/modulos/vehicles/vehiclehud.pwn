/*
    Credit: http://unidadesamp.blogspot.com/2016/05/fs-velocimetro-estilo-gta-v.html
    HUD Author: ForT 
                                                                                    */
#include <YSI_Coding\y_hooks>
hook OnScriptInit() {
    txdVehicleHud[0] = TextDrawCreate(379.000000, 353.000000, "i");
    TextDrawBackgroundColor(txdVehicleHud[0], 0);
    TextDrawFont(txdVehicleHud[0], 2);
    TextDrawLetterSize(txdVehicleHud[0], 28.800073, 2.600000);
    TextDrawColor(txdVehicleHud[0], 80);
    TextDrawSetOutline(txdVehicleHud[0], 0);
    TextDrawSetProportional(txdVehicleHud[0], 1);
    TextDrawSetShadow(txdVehicleHud[0], 1);
    TextDrawSetSelectable(txdVehicleHud[0], 0);
    txdVehicleHud[1] = TextDrawCreate(379.000000, 368.000000, "i");
    TextDrawBackgroundColor(txdVehicleHud[1], 0);
    TextDrawFont(txdVehicleHud[1], 2);
    TextDrawLetterSize(txdVehicleHud[1], 28.800073, 2.600000);
    TextDrawColor(txdVehicleHud[1], 80);
    TextDrawSetOutline(txdVehicleHud[1], 0);
    TextDrawSetProportional(txdVehicleHud[1], 1);
    TextDrawSetShadow(txdVehicleHud[1], 1);
    TextDrawSetSelectable(txdVehicleHud[1], 0);
    txdVehicleHud[2] = TextDrawCreate(379.000000, 382.000000, "i");
    TextDrawBackgroundColor(txdVehicleHud[2], 0);
    TextDrawFont(txdVehicleHud[2], 2);
    TextDrawLetterSize(txdVehicleHud[2], 28.800073, 2.600000);
    TextDrawColor(txdVehicleHud[2], 80);
    TextDrawSetOutline(txdVehicleHud[2], 0);
    TextDrawSetProportional(txdVehicleHud[2], 1);
    TextDrawSetShadow(txdVehicleHud[2], 1);
    TextDrawSetSelectable(txdVehicleHud[2], 0);
    txdVehicleHud[3] = TextDrawCreate(379.000000, 396.000000, "i");
    TextDrawBackgroundColor(txdVehicleHud[3], 0);
    TextDrawFont(txdVehicleHud[3], 2);
    TextDrawLetterSize(txdVehicleHud[3], 28.800073, 2.600000);
    TextDrawColor(txdVehicleHud[3], 80);
    TextDrawSetOutline(txdVehicleHud[3], 0);
    TextDrawSetProportional(txdVehicleHud[3], 1);
    TextDrawSetShadow(txdVehicleHud[3], 1);
    TextDrawSetSelectable(txdVehicleHud[3], 0);
    txdVehicleHud[4] = TextDrawCreate(379.000000, 410.000000, "i");
    TextDrawBackgroundColor(txdVehicleHud[4], 0);
    TextDrawFont(txdVehicleHud[4], 2);
    TextDrawLetterSize(txdVehicleHud[4], 28.800073, 2.600000);
    TextDrawColor(txdVehicleHud[4], 80);
    TextDrawSetOutline(txdVehicleHud[4], 0);
    TextDrawSetProportional(txdVehicleHud[4], 1);
    TextDrawSetShadow(txdVehicleHud[4], 1);
    TextDrawSetSelectable(txdVehicleHud[4], 0);
    txdVehicleHud[5] = TextDrawCreate(531.000000, 361.000000, "Veiculo~n~~n~Velocidade~n~~n~Combustivel~n~~n~Lataria~n~~n~Blindagem");
    TextDrawAlignment(txdVehicleHud[5], 3);
    TextDrawBackgroundColor(txdVehicleHud[5], 0);
    TextDrawFont(txdVehicleHud[5], 2);
    TextDrawLetterSize(txdVehicleHud[5], 0.210000, 0.799999);
    TextDrawColor(txdVehicleHud[5], -186);
    TextDrawSetOutline(txdVehicleHud[5], 0);
    TextDrawSetProportional(txdVehicleHud[5], 1);
    TextDrawSetShadow(txdVehicleHud[5], 1);
    TextDrawSetSelectable(txdVehicleHud[5], 0);
    return 1;
}

hook OnPlayerDisconnect(playerid,reason) {
    gVehicleTimer[playerid]=0;
    return 0;
}

hook OnPlayerConnect(playerid) {
    txdVehicleHudPlayer[0][playerid] = CreatePlayerTextDraw(playerid,615.000000, 359.000000, "Nenhum");
    PlayerTextDrawAlignment(playerid,txdVehicleHudPlayer[0][playerid], 3);
    PlayerTextDrawBackgroundColor(playerid,txdVehicleHudPlayer[0][playerid], 0);
    PlayerTextDrawFont(playerid,txdVehicleHudPlayer[0][playerid], 1);
    PlayerTextDrawLetterSize(playerid,txdVehicleHudPlayer[0][playerid], 0.330000, 1.299999);
    PlayerTextDrawColor(playerid,txdVehicleHudPlayer[0][playerid], -156);
    PlayerTextDrawSetOutline(playerid,txdVehicleHudPlayer[0][playerid], 0);
    PlayerTextDrawSetProportional(playerid,txdVehicleHudPlayer[0][playerid], 1);
    PlayerTextDrawSetShadow(playerid,txdVehicleHudPlayer[0][playerid], 1);
    PlayerTextDrawSetSelectable(playerid,txdVehicleHudPlayer[0][playerid], 0);

    txdVehicleHudPlayer[1][playerid] = CreatePlayerTextDraw(playerid,615.000000, 375.000000, "000 km/h");
    PlayerTextDrawAlignment(playerid,txdVehicleHudPlayer[1][playerid], 3);
    PlayerTextDrawBackgroundColor(playerid,txdVehicleHudPlayer[1][playerid], 0);
    PlayerTextDrawFont(playerid,txdVehicleHudPlayer[1][playerid], 2);
    PlayerTextDrawLetterSize(playerid,txdVehicleHudPlayer[1][playerid], 0.250000, 1.299999);
    PlayerTextDrawColor(playerid,txdVehicleHudPlayer[1][playerid], -156);
    PlayerTextDrawSetOutline(playerid,txdVehicleHudPlayer[1][playerid], 0);
    PlayerTextDrawSetProportional(playerid,txdVehicleHudPlayer[1][playerid], 1);
    PlayerTextDrawSetShadow(playerid,txdVehicleHudPlayer[1][playerid], 1);
    PlayerTextDrawSetSelectable(playerid,txdVehicleHudPlayer[1][playerid], 0);

    txdVehicleHudPlayer[2][playerid] = CreatePlayerTextDraw(playerid,615.000000, 389.000000, "0 litros");
    PlayerTextDrawAlignment(playerid,txdVehicleHudPlayer[2][playerid], 3);
    PlayerTextDrawBackgroundColor(playerid,txdVehicleHudPlayer[2][playerid], 0);
    PlayerTextDrawFont(playerid,txdVehicleHudPlayer[2][playerid], 2);
    PlayerTextDrawLetterSize(playerid,txdVehicleHudPlayer[2][playerid], 0.250000, 1.299999);
    PlayerTextDrawColor(playerid,txdVehicleHudPlayer[2][playerid], -156);
    PlayerTextDrawSetOutline(playerid,txdVehicleHudPlayer[2][playerid], 0);
    PlayerTextDrawSetProportional(playerid,txdVehicleHudPlayer[2][playerid], 1);
    PlayerTextDrawSetShadow(playerid,txdVehicleHudPlayer[2][playerid], 1);
    PlayerTextDrawSetSelectable(playerid,txdVehicleHudPlayer[2][playerid], 0);

    txdVehicleHudPlayer[3][playerid] = CreatePlayerTextDraw(playerid,613.000000, 403.000000, "0%");
    PlayerTextDrawAlignment(playerid,txdVehicleHudPlayer[3][playerid], 3);
    PlayerTextDrawBackgroundColor(playerid,txdVehicleHudPlayer[3][playerid], 0);
    PlayerTextDrawFont(playerid,txdVehicleHudPlayer[3][playerid], 2);
    PlayerTextDrawLetterSize(playerid,txdVehicleHudPlayer[3][playerid], 0.250000, 1.299999);
    PlayerTextDrawColor(playerid,txdVehicleHudPlayer[3][playerid], -156);
    PlayerTextDrawSetOutline(playerid,txdVehicleHudPlayer[3][playerid], 0);
    PlayerTextDrawSetProportional(playerid,txdVehicleHudPlayer[3][playerid], 1);
    PlayerTextDrawSetShadow(playerid,txdVehicleHudPlayer[3][playerid], 1);
    PlayerTextDrawSetSelectable(playerid,txdVehicleHudPlayer[3][playerid], 0);

    txdVehicleHudPlayer[4][playerid] = CreatePlayerTextDraw(playerid,615.000000, 416.000000, "0%");
    PlayerTextDrawAlignment(playerid,txdVehicleHudPlayer[4][playerid], 3);
    PlayerTextDrawBackgroundColor(playerid,txdVehicleHudPlayer[4][playerid], 0);
    PlayerTextDrawFont(playerid,txdVehicleHudPlayer[4][playerid], 2);
    PlayerTextDrawLetterSize(playerid,txdVehicleHudPlayer[4][playerid], 0.250000, 1.299999);
    PlayerTextDrawColor(playerid,txdVehicleHudPlayer[4][playerid], -156);
    PlayerTextDrawSetOutline(playerid,txdVehicleHudPlayer[4][playerid], 0);
    PlayerTextDrawSetProportional(playerid,txdVehicleHudPlayer[4][playerid], 1);
    PlayerTextDrawSetShadow(playerid,txdVehicleHudPlayer[4][playerid], 1);
    PlayerTextDrawSetSelectable(playerid,txdVehicleHudPlayer[4][playerid], 0);
    return 1;
}

public ShowPlayerSpeedMeter(playerid) {
    if(!gVehicleTimer[playerid]) {
        for( new i;i< 6;i++) TextDrawShowForPlayer(playerid, txdVehicleHud[i]);
        for( new i;i<5;i++) PlayerTextDrawShow(playerid, txdVehicleHudPlayer[i][playerid]);
        gVehicleTimer[playerid]=SetTimerEx("UpdatePlayerSpeedMeter",25,true,"i",playerid);
    }
}

public UpdatePlayerSpeedMeter(playerid) {
        new currentVeh;
        currentVeh=GetPlayerVehicleID(playerid);
        if (IsPlayerInVehicle(playerid,currentVeh)) {
            new vehicleid = GetPlayerVehicleID(playerid);
            new vehicleStats[15];
            new Float:health;
            GetVehicleHealth(vehicleid,health);
            //TODO FUEL and SHIELD
            format(vehicleStats, sizeof (vehicleStats), "%02d km/h", GetVehicleSpeed(vehicleid));
            PlayerTextDrawSetString(playerid, txdVehicleHudPlayer[1][playerid], vehicleStats);
            format(vehicleStats, sizeof (vehicleStats), "%.0f%%",health);
            PlayerTextDrawSetString(playerid, txdVehicleHudPlayer[3][playerid], vehicleStats);
            format(vehicleStats, sizeof (vehicleStats), "%d%%",0);
            PlayerTextDrawSetString(playerid, txdVehicleHudPlayer[4][playerid], vehicleStats);
            format(vehicleStats, sizeof (vehicleStats), "%02d Litros",GetVehicleFuel(vehicleid));
            PlayerTextDrawSetString(playerid, txdVehicleHudPlayer[2][playerid], vehicleStats);
            return 1;
        }
        for( new i;i< 6;i++) TextDrawHideForPlayer(playerid, txdVehicleHud[i]);
        for( new i;i<5;i++) PlayerTextDrawHide(playerid, txdVehicleHudPlayer[i][playerid]);
        KillTimer(gVehicleTimer[playerid]);
        gVehicleTimer[playerid]=0;
        return 1;
}