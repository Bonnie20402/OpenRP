/*
    helprequests.pwn
                    */
#define MAX_HELP_REQUESTS 300

enum HELPSTATUS {
    HELPSTATUS_NONE,
    HELPSTATUS_WAITING,
    HELPSTATUS_ONGOING,
    HELPSTATUS_COMPLETE
}
enum HELPHANDLER {
    HELPHANDLER_FROMID, // the playerid that asks for the help. Should be initiated at INVALID_PLAYER_ID
    String:HELPHANDLER_MSG[255], // the help message 
    HELPHANDLER_STATUS, // the status, should be a value between the HELPSTATUS enum
    HELPHANDLER_ADMINID, // The admin that is helping the dude. Should be init at INVALID_PLAYER_ID
    HELPHANDLER_TIME_H, // timer mark(h)
    HELPHANDLER_TIME_M, // timer mark(m)
    HELPHANDLER_TIME_S // timer mark(s)
}
new gHelpRequests[MAX_HELP_REQUESTS][HELPHANDLER];