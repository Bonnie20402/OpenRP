
YCMD:ajudainventario(playerid,params[],help)=invhelp;
YCMD:invhelp(playerid,params[],help) {
    if(!IsPlayerLoggedIn(playerid))return 1;
    Dialog_Show(playerid,DIALOG_STYLE_MSGBOX,"Ajuda inventario","{1e92f7}INVENTÁRIO OPEN RP{FFFFFF}\n\
Para usar o inventário, {ff851b}clique{FFFFFF} em um item para selecioná-lo.\n\
Ele ficará {ff851b}destacado{FFFFFF} em azul.\n\
Os slots vazios são {ff851b}marcados{FFFFFF} com ?.\n\
Com um item selecionado, você pode {ff851b}usar{FFFFFF}, {ffa339}vender{FFFFFF}, {ffa339}descartar{FFFFFF} ou {ff851b}juntar{FFFFFF} clicando nos respeitivos {2ecc40}botões{FFFFFF}.\n\
Para {ff851b}mover{FFFFFF} um item, faz um duplo-clique nele e seleciona um slot vazio.","OK","");
    return 1;
}