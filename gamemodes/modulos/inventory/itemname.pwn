#define ITEM_INVALID 18631 // the question mark
#define ITEM_RESPEITO 19941
#define ITEM_DINHEIRO 1212
#define ITEM_GASOLINA 1650
#define ITEM_MEDKIT 11736
#define ITEM_CAIXACOMUM 19054
#define ITEM_CAIXAINCOMUM 19055
#define ITEM_CAIXARARA 19056
#define ITEM_CAIXAEPICA 19057
#define ITEM_CAIXALENDARIA 19058


stock String:GetItemNameString(modelid) {
    new String:itemName[64];
    if(modelid == 0) format(itemName, 50, "Desconhecido");
	if(modelid == 19941) format( itemName, 50, "Respeito");
	if(modelid == 1212) format( itemName, 50, "Dinheiro");
	if(modelid == 1650) format( itemName, 50, "Gasolina");
	if(modelid == 2226) format(itemName, 50, "Radio Portatil");
	if(modelid == 18976) format(itemName, 50, "Capacete");
	if(modelid == 980) format(itemName, 50, "Portao");
	if(modelid == 11738) format(itemName, 50, "Remedio pequeno");
	if(modelid == 11739) format(itemName, 50, "Remedio Normal");
	if(modelid == 11736) format(itemName, 50, "MedKit");
	if(modelid == 11738) format(itemName, 50, "Kit M�dico");
	if(modelid == 1271) format(itemName, 50, "Caixa de Itens");
	if(modelid == 1581) format(itemName, 50, "Titulo Personalizado");
	if(modelid == 2881) format(itemName, 50, "Pizza");
 	if(modelid == 2768) format(itemName, 50, "Hamburguer");
 	if(modelid == 19562) format(itemName, 50, "Cereal");
	if(modelid == 19054) format(itemName, 50, "Caixa Comum");
	if(modelid == 19055) format(itemName, 50, "Caixa Incomum");
	if(modelid == 19056) format(itemName, 50, "Caixa Rara");
	if(modelid == 19057) format(itemName, 50, "Caixa Epica");
	if(modelid == 19058) format(itemName, 50, "Caixa Lendaria");
	if(modelid == 370) format(itemName, 50, "JetPack");
	if(modelid == 1609) format( itemName, 50, "Tartaruga");
	if(modelid == 19317) format( itemName, 50, "Guitarra");
	if(modelid == 19319) format( itemName, 50, "Guitarra");
	if(modelid == 19094) format( itemName, 50, "Item Raro");
	if(modelid == 18974) format( itemName, 50, "Item Raro");
	if(modelid == 19142) format( itemName, 50, "Colete");
	if(modelid == 19555) format( itemName, 50, "Luva esquerda");
	if(modelid == 19556) format( itemName, 50, "Luva direita");
	if(modelid == 1736) format( itemName, 50, "Cabeca de touro");
	if(modelid == 2052) format( itemName, 50, "CJ Tommy Hat");
	if(modelid == 2053) format( itemName, 50, "CJ Jerry Hat");
	if(modelid == 2114) format( itemName, 50, "Bola de Basquete");
	if(modelid == 6865) format( itemName, 50, "Cabeca de cervo");
	if(modelid == 3528) format( itemName, 50, "Cabeca de dragao");
	if(modelid == 1262) format( itemName, 50, "Cabeca de semaforo");
	if(modelid == 19320) format( itemName, 50, "Cabeca de abobora");
	if(modelid == 19348) format( itemName, 50, "Bengala");
	if(modelid == 19042) format( itemName, 50, "Relogio de ouro");
	if(modelid == 19528) format( itemName, 50, "Chapeu de bruxa");
	if(modelid == 19527) format( itemName, 50, "Caldeirao");
	if(modelid == 19557) format( itemName, 50, "Mascara Stripp");
	if(modelid == 11704) format( itemName, 50, "Mascara DEMON");
	if(modelid == 954) format( itemName, 50, "Ferradura");
	if(modelid == 1247) format( itemName, 50, "Estrela");
	if(modelid == 1274) format( itemName, 50, "Sifrao");
	if(modelid == 2918) format( itemName, 50, "Bola aquatica");
	if(modelid == 19121) format( itemName, 50, "Luz Branca");
	if(modelid == 19122) format( itemName, 50, "Luz Azul");
	if(modelid == 19123) format( itemName, 50, "Luz Verde");
	if(modelid == 19124) format( itemName, 50, "Luz Vermelha");
	if(modelid == 19125) format( itemName, 50, "Luz Amarela");
	if(modelid == 19126) format( itemName, 50, "Luz Azul Bebe");
	if(modelid == 19127) format( itemName, 50, "Luz Roxa");
	if(modelid == 2894) format( itemName, 50, "Contrato Hospitalar");
	if(modelid == 354) format( itemName, 50, "Charuto Do Bern");
	if(modelid == 2749) format( itemName, 50, "Grafite Personalizado");
	if(modelid == 2886) format( itemName, 50, "Decodificador");
	if(modelid == 2976) format( itemName, 50, "Bomba Nuclear");
	if(modelid == 3096) format( itemName, 50, "Kit De Reparo");
	if(modelid == 2647) format( itemName, 50, "Coca-Cola");
	if(modelid == 1668) format( itemName, 50, "Garrafa de agua");
	if(modelid == 19878) format( itemName, 50, "Skate");
	if(modelid == 19582) format( itemName, 50, "Carne");
	if(modelid == 19630) format( itemName, 50, "Peixe");
	if(modelid == 2702) format( itemName, 50, "Fatia de Pizza");
	if(modelid == 2880) format( itemName, 50, "Hamburguer");
	if(modelid == 1650) format( itemName, 50, "Galao de combustevel");
	if(modelid == 19382) format( itemName, 50, "Nenhum Item");
	if(modelid == 964) format( itemName, 50, "Caixa De Armas");
	if(modelid == 2922) format( itemName, 50, "Decodificador");
	if(modelid == 1252) format( itemName, 50, "CB");
	if(modelid == 1578) format( itemName, 50, "Maconha");
	if(modelid == 1575) format( itemName, 50, "Crack");
	if(modelid == 1576) format( itemName, 50, "LSD");
	if(modelid == 1279) format( itemName, 50, "Cocaina");
	if(modelid == 1654) format( itemName, 50, "Dinamite");
	if(modelid == 2993) format( itemName, 50, "Respawn Veiculos");
	if(modelid == 19421) format( itemName, 50, "iPad");
	if(modelid >= 0 && modelid < 312) format(itemName, 50, "Skin %d",modelid); // se for skin
    return itemName;
}