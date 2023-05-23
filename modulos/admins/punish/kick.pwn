/*
    Handles player kicks
                        */

stock StaffPunishKick(byid,targetid,String:reason[]) {
    new dialogMessage[1024],kickMessage[512];
    //Dialog to the targetid
    format(dialogMessage,sizeof(dialogMessage),\
    "{ffffff}Acabaste de ser expulso do servidor pela Staff.\n\
    O membro da staff que te expulsou foi o %s %s[%d]\n\
    O motivo desta punição é: %s\n\
    Se acreditas que a punição é inválida, podes recorrer no discord.",\
    GetStaffLevelString(byid),GetPlayerNameEx(byid),byid,reason);
    Dialog_Show(targetid,DIALOG_STYLE_MSGBOX,"Expulso do servidor",dialogMessage,"OK","");
    SetPreciseTimer("KickCallback",20,false,"i",targetid);

    // The message to all logged in players
    format(kickMessage,sizeof(kickMessage),"\
    O %s %s[%d] expulsou %s[%d] do servidor, motivo: %s",\
    GetStaffLevelString(byid),GetPlayerNameEx(byid),byid,GetPlayerNameEx(targetid),targetid,reason);
    SendStaffMessageToAll(kickMessage);


}


forward KickCallback(playerid);
public KickCallback(playerid) {
    Kick(playerid);
    return 1;
}