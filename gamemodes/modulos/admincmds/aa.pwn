

YCMD:aa(playerid,params[],help) {
    if(Getter:GetStaffLevel(playerid)) {
        new String:msg[256];
        format(msg,256,"\
        COMANDOS DA EQUIPA DE STAFF\
        \n*** /aa /atrabalhar /av /ban /kick /cadeia /mute ***\
        \n*** - Bonnie20402 ***");
        ShowPlayerDialog(playerid,ADMINDIALOG_AA,DIALOG_STYLE_MSGBOX,"Comandos Admin",msg,"Ok","");
    }
    else {
        SendClientMessage(playerid,COLOR_RED,"Não pertencas á equipa da staff.");
    }
    return 1;
}