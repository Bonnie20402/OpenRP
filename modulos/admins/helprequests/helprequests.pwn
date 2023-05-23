/*
    HelpRequests.pwn module.
    Allows players to ask for staff assistance in a easy way
    Prefix: HelpRequests
                                                            */

#include <YSI_Coding\y_hooks>

YCMD:atendimento(playerid,params[],help) {
    if(IsPlayerLoggedIn(playerid)) {
        new String:actualHelpMessage[255];
        // After the players confirm create the thread
        inline const helpMsgConfirmResponse(pd,dlgid,confirmed,listitem,String:inputtext[]) {
            #pragma unused pd,dlgid,listitem,Stinputtext
            if(confirmed) {
                new hasRequest=GetPlayerHelpRequestIndex(playerid);
                if(hasRequest == -1){
                    CreateHelpRequest(playerid,actualHelpMessage);
                    Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Tudo feito!","Solicitou um atendimento!\nA staff foi notificada.","OK","");
                    }
                else Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Ups!","Já solicitaste um atendimento.","OK","");
            }
            else Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Info","A solicitação de atendimento foi cancelada.","OK","");
        }
        //Confirm dialog after response is set
        inline const helpMsgSetResponse(pid,did,resp,listitem,String:preHelpMsg[]) {
            #pragma unused pid,did,listitem
            if(resp) {
                format(actualHelpMessage,255,"%s",StpreHelpMsg);
                new dBody[255];
                //Avoid buffer overflow.
                if(strlen(StpreHelpMsg)<3||strlen(StpreHelpMsg)>48) {
                    Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Ups!","Por motivos de segurança, a descrição deve ter entre 3 a 48 carateres.","OK","");
                    return 1;
                } 
                format(dBody,255,"Estás a pedir um atendimento com a seguinte descrição:\n%s",StpreHelpMsg);
                Dialog_ShowCallback(playerid,using inline helpMsgConfirmResponse,DIALOG_STYLE_MSGBOX,"Tens a certeza?",dBody,"Sim","Cancelar");
            }
            else Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Info","A solicitação de atendimento foi cancelada.","OK","");
        }
        Dialog_ShowCallback(playerid,using inline helpMsgSetResponse,DIALOG_STYLE_INPUT,"Pedido de atendimento",\
        "{ffffff}Escreve uma breve descrição do teu problema ou duvida.","Pedir","Cancelar");
    }
    return 1;
}
YCMD:atendimentos(playerid,params[],help) {
    ShowHelpRequests(playerid);
    return 1;
}
stock HelpRequests:CreateHelpRequest(fromid,String:message[]) {
    new index = GetHelpRequestIndex();
    if(index != -1) {
        new h,m,s;
        gettime(h,m,s);
        format(gHelpRequests[index][HELPHANDLER_MSG],255,"%s",message);
        gHelpRequests[index][HELPHANDLER_FROMID]=fromid;
        gHelpRequests[index][HELPHANDLER_STATUS]=HELPSTATUS_WAITING;
        gHelpRequests[index][HELPHANDLER_TIME_H]=h;
        gHelpRequests[index][HELPHANDLER_TIME_M]=m;
        gHelpRequests[index][HELPHANDLER_TIME_S]=s;
        return 1;
    }
    return 0;
}




stock HelpRequests:ShowHelpRequests(playerid) {
    new dTitle[32],dBody[1024],qtt;
    inline const helpRequestResponse(pid,did,resp,listitem,String:whoAskedForHelp[]) {  
        #pragma unused did,listitem
        new targetid=-1,index;
        targetid=GetPlayerIdFromName(StwhoAskedForHelp);
        index=GetPlayerHelpRequestIndex(targetid);
        if(index != -1 ) {
                //TODO add ramiuning logic messages, log time, the atendiumento time
            gHelpRequests[index][HELPHANDLER_STATUS] = HELPSTATUS_ONGOING;
            gHelpRequests[index][HELPHANDLER_ADMINID] = pid;
            gettime(gHelpRequests[index][HELPHANDLER_TIME_H],gHelpRequests[index][HELPHANDLER_TIME_M],gHelpRequests[index][HELPHANDLER_TIME_S]);
            format(dBody,1024,"O suporte chegou!\n\
            O %s %s será o membro da staff que irá te atender.\n\
            O motivo do teu atendimento é:\n\
            %s",GetStaffLevelString(pid),GetPlayerNameEx(pid),gHelpRequests[index][HELPHANDLER_MSG]);
            Dialog_Show(targetid,DIALOG_STYLE_MSGBOX,"Atendimento",dBody,"OK","");
            SendClientMessage(playerid,-1,"Para o atendimento, escreva terminar no chat.");
        }

        else if(resp) Dialog_Show(pid,DIALOG_STYLE_MSGBOX,"Ups!","Atendimento não enconntrado!","OK","");
    }
    format(dBody,1024,"Pedido de\tEstado\tTempo\tMensagem\n");
    for(new i;i<MAX_HELP_REQUESTS;i++) {
        if(IsValidHelpRequest(i)) {
            qtt++;
            format(dBody,1024,"%s%s\t%s\t%s\t%s\n",dBody,\
            GetPlayerNameEx(gHelpRequests[i][HELPHANDLER_FROMID]),\
            GetHelpRequestStatusString(i),\
            GetTimeFormatted(gHelpRequests[i][HELPHANDLER_TIME_H],gHelpRequests[i][HELPHANDLER_TIME_M],gHelpRequests[i][HELPHANDLER_TIME_S]),\
            gHelpRequests[i][HELPHANDLER_MSG]);
        }
    }
    format(dTitle,32,"{FFFFFF}Pedidos de Suporte (%d)",qtt);
    Dialog_ShowCallback(playerid,using inline helpRequestResponse,DIALOG_STYLE_TABLIST_HEADERS,dTitle,dBody,"Atender","Fechar");
}




stock HelpRequests:GetHelpRequestStatusString(index) {
    new String:helpStatus[128];
    switch (gHelpRequests[index][HELPHANDLER_STATUS]) {
        case HELPSTATUS_NONE:
            format(helpStatus,32,"N/A");
        case HELPSTATUS_WAITING:
            format(helpStatus,32,"Em espera");
        case HELPSTATUS_ONGOING:
            format(helpStatus,32,"Atendimento (%s)",GetPlayerNameEx(gHelpRequests[index][HELPHANDLER_ADMINID]));
    }
    return helpStatus;
}

stock HelpRequests:IsValidHelpRequest(index) {
    if(gHelpRequests[index][HELPHANDLER_STATUS] == HELPSTATUS_NONE) return 0;
    return 1;
}

stock HelpRequests:GetPlayerHelpRequestIndex(playerid) {
    for(new i;i<MAX_HELP_REQUESTS;i++) {
        if(gHelpRequests[i][HELPHANDLER_FROMID] == playerid && IsValidHelpRequest(i))return i;
    }
    return -1;
}
stock HelpRequests:GetHelpRequestIndex() {
    for(new i;i<MAX_HELP_REQUESTS;i++) {
        if(gHelpRequests[i][HELPHANDLER_STATUS]== HELPSTATUS_NONE)return i;
    }
    return -1;
}
stock HelpRequests:adminhelpingInit() {
    for(new i;i<MAX_HELP_REQUESTS;i++) {
        ResetHelpRequest(i);
    }
    printf("[helprequests.pwn] - Init success");
    return 1;
}

stock HelpRequests:ResetHelpRequest(index) {
    gHelpRequests[index][HELPHANDLER_FROMID]=INVALID_PLAYER_ID;
    gHelpRequests[index][HELPHANDLER_ADMINID]=INVALID_PLAYER_ID;
    gHelpRequests[index][HELPHANDLER_STATUS]=HELPSTATUS_NONE;
    return 1;
}

//Chat logic
hook OnPlayerText(playerid, text[]) {
    new index;
    index=GetPlayerHelpRequestIndex(playerid);
    if(index!=-1) {
        new adminid;
        adminid=gHelpRequests[index][HELPHANDLER_ADMINID];
        if(!strcmp("terminar",text)) {
            ResetHelpRequest(index);
            SendClientMessage(playerid,-1,"O atendimento foi finalizado pelo jogador atendido.");
            SendClientMessage(adminid,-1,"O atendimento foi finalizado pelo jogador atendido.");
            return 0;
        }
        SendClientMessagef(adminid,-1,"[Atendimento] Jogador %s[%d]: %s",GetPlayerNameEx(playerid),playerid,text);
        SendClientMessagef(playerid,-1,"[Atendimento] Jogador %s[%d]: %s",GetPlayerNameEx(playerid),playerid,text);
        return 0;
    }
    for(new i;i<MAX_HELP_REQUESTS;i++){
        if(IsValidHelpRequest(i)&&gHelpRequests[i][HELPHANDLER_ADMINID]==playerid) {
            if(!strcmp("terminar",text)) {
                SendClientMessage(gHelpRequests[i][HELPHANDLER_FROMID],-1,"O atendimento foi finalizado pelo administrador.");
                SendClientMessage(gHelpRequests[i][HELPHANDLER_ADMINID],-1,"O atendimento foi finalizado pelo administrador.");
                ResetHelpRequest(i);
                return 0;
            }
            SendClientMessagef(gHelpRequests[i][HELPHANDLER_FROMID],-1,"[Atendimento] %s %s[%d]: %s",GetStaffLevelString(playerid),GetPlayerNameEx(playerid),playerid,text);
            SendClientMessagef(gHelpRequests[i][HELPHANDLER_ADMINID],-1,"[Atendimento] %s %s[%d]: %s",GetStaffLevelString(playerid),GetPlayerNameEx(playerid),playerid,text);
            return 0;
        }
    }
    return 1;
}




