/*
    jobs.pwn
            */
enum JOBLIST {
    JOBLIST_UNEMPLOYED,
    JOBLIST_TRASHMAN,
    JOBLIST_BUSDRIVER,
    JOBLIST_TRUCKDRIVER,
    JOBLIST_PIZZAGUY
}
enum JOBINFO {
    Int:JOBINFO_CURRENTJOB, // Get's player's current job
    Float:JOBINFO_SPAWN[3], // Get's jobs spawn
    String:JOBINFO_NAME[64], // Get's jobs name
    Int:JOBINFO_PAYCHECK, // paycheck TODO payday
    Int: JOBINFO_SKIN // Job's skin
}

new gJobs[JOBLIST][JOBINFO];
new gPlayerJobs[MAX_PLAYERS]; // Should assign a value of the JOBLIST enum.
forward JobsInit();
