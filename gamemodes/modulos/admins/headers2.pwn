/*

    admins.pwn
                    */
#define ADMINDIALOG_AA 5000
#define ADMINDIALOG_ADMINSLIST 5001
enum ADMININFO {
    Int:ADMININFO_LEVEL,
    Int:ADMININFO_AUTH,
    String:ADMININFO_ROLE[64],
    Int:ADMININFO_WORKING
}
new gAdmins[MAX_PLAYERS][ADMININFO];
/*
    adminmsg.pwn
                */
forward SendStaffMessage(playerid,const message[]);