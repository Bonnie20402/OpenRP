YCMD:ajobs(playerid,params[],help) {
    if(GetStaffLevel(playerid)) {
        new message[255];
        format(message,255,\
        "[ DEV INFO  - JOBS ENUM ]\n\
        JOBLIST_UNEMPLOYED -> %d\n\
        JOBLIST_TRASHMAN -> %d\n\
        JOBLIST_BUSSDRIVER -> %d \n\
        JOBLIST_TRUCKDRIVER -> %d\n\
        JOBLIST_PIZZAGUY -> %d",\
        JOBLIST_UNEMPLOYED,JOBLIST_TRASHMAN,JOBLIST_BUSDRIVER,JOBLIST_TRUCKDRIVER,JOBLIST_PIZZAGUY);
        SendClientMessage(playerid,-1,message);
        print(message);
    }
    return 1;
}

