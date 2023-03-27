
YCMD:creditos(playerid,params[],help) {
    if(IsPlayerLoggedIn(playerid)) {
        new String:credits[1024];
        format(credits,1024,"\
        {33CCFF}|________________________________| Créditos - OS RP |________________________________|\
        \n{FFFFFF} Inicio do desenvolvimento: 20/02/2023\
        \n\
        {9733FF}Bonnie20402 {ffffff}@bonnie20402 - Programador\n\
        {7289da}Discord: Bonnie20402#0550\n\
        \n\
        {ffffff}Agradecimentos especiais a:\
        \n\
        {0B61B9}ForT {3E4048} - pela textdraw dos veiculos\n\
        {0B61B9}Vision Team {3E4048} - por tirar as minhas dúvidas durante o desenvolvimento\n\
        {0B61B9}Chainksain {3E4048} - por me introduzir ao pawno, através do Youtube\n\
        {0B61B9}Prof. Alexandre R. & Carla R. {3E4048} - por coordenar o curso de TGPSI\n\
        \n\
        {ffffff}Os meus amores <3:{0B61B9}\n\
        \n\
        Guilherme{ffffff} @guilherme.coto {0B61B9}Côto <3\n\
        Tiago{ffffff} @tiago_almeida_23 {0B61B9}Almeida <3\n\
        Abel{ffffff} @apef2504 {0B61B9}Pina <3\n\
        Renato{ffffff} @asteroidrenato {0B61B9}Almeida <3\n\
        Manuel{ffffff} @manuel14674 {0B61B9}Teixeira <3\n\
        Mariana{ffffff} @_.maariaanaa {0B61B9} MARIANA_SURNAME <3\n\
        Erico{ffffff} @mr.mewo_{0B61B9} ERICO_SURNAME <3\n\
        Rafael{ffffff} @rafaelcabral04{0B61B9} Cabral <3\n\
        \n\
        "); /*
        TODO: Mariana's surname, Erico's surname, ask personally for approval of:
            Prof.Alex & Prof Ca. - TO ASK,
            Guilherme - OK,
            Abel - ok,
            Tiago - TO ASK,
            Renato - TO ASK,
            Manuel - TO ASK,
            Mariana - TO ASK,
            Erico - TO ASK,
            Rafael - OK
        */

        if(IsPlayerLoggedIn(playerid))ShowPlayerDialog(playerid,INFODIALOG,DIALOG_STYLE_MSGBOX,"Open Source Roleplay - 2023",credits,"OK","");
        return 1;
    }
}
