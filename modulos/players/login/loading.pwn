/*
    Loading
Handles player connection logic
                */

#include "modulos\players\login\login.pwn"

#include <YSI_Coding\y_hooks>

static const cstLoadingTips[][] = {
    "Sabias que este projeto e Open Source?",
    "Caso tenhas fome ou sede, procura por um Restaurante.",
    "Visita a Auto-Escola para adquirires a tua licenca de conducao!",
    "Tens dinheiro a mais? Converte-o em ouros!",
    "Torna-te caminhoneiro e trabalha para outros jogadores~n~Mais info em /ajuda!",
    "Encontraste a tua outra metade? ~n~Dirijam-se a Igreija e casem!",
    "Junta-te a uma organizacao, mais info no comando /orgs!",
    "Faltar ao respeito a outros jogadores e punivel.~n~Mais info no comando /regras!",
    "Criado por Bonnie20402",
    "Queres saber quem contribuiu para o projeto?~n~Clica em JOGAR",
    "Sabias que podes vincular a tua conta ao Discord?~n~Mais info no comando /discord!",
    "Queres liderar uma organizacao?~n~Candidata-te, mais info no Discord",
    "Podes ganhar dinheiro de varias maneiras!",
    "E possivel arrendar ou comprar uma casa.~m~Mais info no comando /ajuda!",
    "Completa o teu Passe Mensal para ganhares premios exclusivos!",
    "Procura melhorar as tuas habilidades!",
    "Podes sempre carregar N para abrir o menu principal OpenRP",
    "Es novo aqui? Procura um emprego na Perfeitura",
    "No caso de teres alguma duvida, chama um membro da Staff!",
    "Sabias que podes jogar tanto no PC como no Android?",
    "Convida os teus amigos para jogarem contigo!",
    "Estas perdido por algum lado?~n~Abre o GPS, faz o comando /GPS!",
    "Visita o nosso website:~n~www.openrp.pt",
    "Podes adquirir CONST_PAIDCURRENCY em ~n~www.openrp.pt",
    "Sala 308 - Talvez um Easter Egg?"
};

new gLoadingTipsTimer[MAX_PLAYERS];

/*
        Does the loading logic
                            */
hook OnPlayerConnect(playerid) {
    PlayAudioStreamForPlayer(playerid,"https://www.dropbox.com/s/x86pxgwmrvx51es/FNF_Dlow_Original.mp3?dl=1");
    ClearPlayerChat(playerid);
    SendClientMessage(playerid,COLOR_AQUA,"Bem-vindo!");
    SendClientMessage(playerid,COLOR_AQUA,"A carregar informações do SQL, aguarda...");
    GenerateLoadingTip(playerid);
    // TODO pre-load player logic from SQL table
    gLoadingTimer[playerid]=-1;
    TogglePlayerSpectating(playerid,true);
    gLoadingTipsTimer[playerid]=SetPreciseTimer("GenerateLoadingTip",3500,true,"i",playerid);
    gLoadingTimer[playerid]=SetPreciseTimer("AddLoadingProgress",5,true,"i", playerid);
    SetPlayerTxdLoadingProgress(playerid,0.0);
    ShowPlayerTxdLoading(playerid,0);
    return 1;
}


forward GenerateLoadingTip(playerid);
public GenerateLoadingTip(playerid) {
    if(IsPlayerLoggedIn(playerid)) {
        DeletePreciseTimer(gLoadingTipsTimer[playerid]);
        gLoadingTipsTimer[playerid]=-1;
        return 1;
    }
    static number;
    new oldnumber=number;
    PlayerPlaySound(playerid, 5205,0.0,0.0,0.0);
    do {
        number = 0 + random(sizeof(cstLoadingTips));
    }while(number==oldnumber);
    SetPlayerTxdLoadingText(playerid,cstLoadingTips[number]);
    return 1;
}
forward AddLoadingProgress(playerid);
public AddLoadingProgress(playerid) {
    if(gLoadingTimer[playerid]!=-1) {
        new Float:currentProgress;
        currentProgress=GetPlayerTxdLoadingProgress(playerid);
        if(currentProgress < 100.0) {
            new Float:newProgress;
            newProgress = currentProgress + 0.5;
            SetPlayerTxdLoadingProgress(playerid,newProgress);
            return 1;
        }
        //Se já estiver carregado
        DeletePreciseTimer(gLoadingTimer[playerid]);
        gLoadingTimer[playerid]=-1;
        SendClientMessage(playerid,COLOR_AQUA,"Concluido, carrega no botão JOGAR para iniciares essão!");
        ShowPlayerTxdLoading(playerid,1);
        return 1;
    }
    return 1;
}

public IsPlayerLoaded(playerid) {
    if(gLoadingTimer[playerid]==-1)return 0;
    return 1;
}

public OnPlayerLoad(playerid) {
    ShowCreditsDialog(playerid);
    return 1;
}
hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) {
    if(playertextid==txdLoading_btn0[playerid]) { // Jogar
        CancelSelectTextDraw(playerid);
        OnPlayerLoad(playerid);
    }
    if(playertextid==txdLoading_btn1[playerid]) { // Channgelog TODO Changelog
        CancelSelectTextDraw(playerid);
        OnPlayerLoad(playerid);
    }
    if(playertextid==txdLoading_btn2[playerid]) { // Sair
        CancelSelectTextDraw(playerid);
        Kick(playerid);
    }
    return 1;
}
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid==CREDITSDIALOG&&!IsPlayerLoggedIn(playerid)) {
        PrepareAccountCheck(playerid);
    }
    return 1;
}
