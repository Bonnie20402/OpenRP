
YCMD:creditos(playerid,params[],help) {
    if(IsPlayerLoggedIn(playerid)) {
        new credits[512];
        format(credits,512,"\
        {33CCFF}|________________________________| Créditos - OS RP |________________________________|\
        \n\
        \n\
        \n\
        {9733FF}Bonnie20402 {ffffff} - Programador\n\
        {3E4048}Programador da gamemode\n\
        {7289da}Discord: Bonnie20402#0550\n\
        \n\
        \n\
        {ffffff}Agradecimentos especiais a:\
        \n\
        \n\
        {0B61B9}ForT {3E4048} - pela textdraw dos veiculos\n\
        {0B61B9}Vision Team {3E4048} - por tirar as minhas duvidas durante o desenvolvimento\n\
        {0B61B9}Chainksain {3E4048} - por me introduzir ao pawno, atraves do Youtube\n\
        {0B61B9}Professora Sofia B. {3E4048} - por me ensinar a linguagem C\n\
        {0B61B9}Escola D.Pedro V {3E4048} - pelo curso de TGPSI\n\
        ");
        if(IsPlayerLoggedIn(playerid))ShowPlayerDialog(playerid,INFODIALOG,DIALOG_STYLE_MSGBOX,"Open Source Roleplay - 2023",credits,"OK","");
        return 1;
    }
}
