/*
    GPS.pwn
                */
enum GPS {
    Float:GPS_DIST,
    Int:GPS_LOCID,
    Int:GPS_TIMERID
}
new gGPS[MAX_PLAYERS][GPS];
forward CreateGPSTimer(playerid,locationid);
forward UpdateGPSDistance(playerid);

/*
    gpsdialog.pwn
                    */
forward ShowGPSMainDialog(playerid);

/*
    gpstxd.pwn
                */
new PlayerText:txdGPS_background[MAX_PLAYERS];
new PlayerText:txdGPS_distance[MAX_PLAYERS];  

/*
    icons.pwn
                */
forward gpsIconsInit(playerid);