
YCMD:creditos(playerid,params[],help) {
    ShowCreditsDialog(playerid);
}
stock ShowCreditsDialog(playerid) {
    new String:credits[1024];
    format(credits,1024,"\
    {33CCFF}|________________________________| Open RPG - 2023 |________________________________|\
    \n{FFFFFF} Inicio do desenvolvimento: 20/02/2023\n\
    \n{FFFFFF}Staff atual:\n\
    {9733FF}Bonnie20402 {ffffff}@bonnie20402 - Programador\n\
    \n\
    {ffffff}Agradecimentos especiais a:\
    \n\
    \n{0B61B9}Prof. Sofia B. {3E4048} - introduziu-me á linguagem C.\n\
    {0B61B9}Chainksain {3E4048} - introduziu-me ao pawn\n\
    {0B61B9}Prof. Alexandre R. & Carla R. {3E4048} - Quase como familia para mim!\n\
    {0B61B9}Guilherme{ffffff} @guilherme.coto {0B61B9}Côto - Grande amigo <3!\n\
    Tiago{ffffff} @tiago_almeida_23 {0B61B9}Almeida - O gajo de oculos mais bem desposto que conheço\n\
    Renato{ffffff} @asteroidrenato {0B61B9}Almeida - Muito porreiro :)\n\
    Manuel{ffffff} @manuel14674 {0B61B9}Teixeira - Oh Manel, vou te bater...\n\
    Mariana{ffffff} @_.maariaanaa {0B61B9} P. - Boa pessoa, sempre a sorrir <3\n\
    Erico{ffffff} @mr.mewo_{0B61B9} Siqueira - Posso sempre contar com ele :)\n\
    Rafael{ffffff} @rafaelcabral04{0B61B9} Cabral - Super tranquilo!\n\
    \n{ffffff}\
    Obrigado por leres. <3\n\
    ");
    ShowPlayerDialog(playerid,CREDITSDIALOG,DIALOG_STYLE_MSGBOX,"Por favor, leia!",credits,"Lido","");
    return 1;
}