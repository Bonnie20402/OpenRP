/*
	Inventory module: inventorytable.pwn
	Contains the item defines for their ids as well as a stock function to convert the id to a name string based on id.
	Prefix: InvItem:			*/
 

 /* Common */
#define ITEM_INVALID 18631 // the question mark
#define ITEM_RESPEITO 19941
#define ITEM_DINHEIRO 1212
#define ITEM_GASOLINA 1650
#define ITEM_MEDKIT 11736
#define ITEM_CELULAR_RED 18870
#define ITEM_CELULAR_BLACK 18868
#define ITEM_CELULAR_ORANGE 18865
#define ITEM_CELULAR_PINK 18869
#define ITEM_CELULAR_GREEN 18871
#define ITEM_CELULAR_BLUE 18866

/* Loot Boxes*/
#define ITEM_CAIXACOMUM 19054
#define ITEM_CAIXAINCOMUM 19055
#define ITEM_CAIXARARA 19056
#define ITEM_CAIXAEPICA 19057
#define ITEM_CAIXALENDARIA 19058

/*Food */
#define ITEM_SUMOLARANJA 19563
#define ITEM_SUMOMACA 19564
#define ITEM_PIZZA 2814
#define ITEM_TACO 2769
#define ITEM_HAMBURGER 2880
#define ITEM_AGUA 19570
#define ITEM_PAO 19883
#define ITEM_FRANGO 19847
#define ITEM_LEITE 19569

/* Cards */
#define ITEM_CARTAO_CONDUCAO 1581
#define ITEM_CARTAO_IDENTIDADE 19792


/* Skins*/ 
#define ITEM_SKIN_MIN 0
#define ITEM_SKIN_MAX 312


stock InvItem:GetItemNameString(modelid) {
    new itemName[64];
	if(modelid == ITEM_CELULAR_BLACK || modelid == ITEM_CELULAR_BLUE || modelid == ITEM_CELULAR_GREEN || modelid == ITEM_CELULAR_ORANGE || modelid == ITEM_CELULAR_PINK || modelid == ITEM_CELULAR_RED) {
		format(itemName,64,"Celular");
	}
	switch(modelid) {
		case ITEM_INVALID:
			format(itemName,64,"_");
		case ITEM_RESPEITO:
			format(itemName,64,"Respeito");
		case ITEM_DINHEIRO:
			format(itemName,64,"Dinheiro");
		case ITEM_GASOLINA:
			format(itemName,64,"Commbustivel");
		case ITEM_MEDKIT:
			format(itemName,64,"Medkit");
		case ITEM_CAIXACOMUM:
			format(itemName,64,"Caixa Comum");
		case ITEM_CAIXAINCOMUM:
			format(itemName,64,"Caixa Incomum");
		case ITEM_CAIXARARA:
			format(itemName,64,"Caixa Rara");
		case ITEM_CAIXAEPICA:
			format(itemName,64,"Caixa Epica");
		case ITEM_CAIXALENDARIA:
			format(itemName,64,"Caixa Lendaria");
		case ITEM_PIZZA:
			format(itemName,64,"Caixa de Pizza");
		case ITEM_TACO:
			format(itemName,64,"Taco");
		case ITEM_SUMOLARANJA:
			format(itemName,64,"Sumo de laranja");
		case ITEM_SUMOMACA:
			format(itemName,64,"Sumo de maca");
		case ITEM_HAMBURGER:
			format(itemName,64,"Hamburger");
	}
	if(modelid >= ITEM_SKIN_MIN && modelid < ITEM_SKIN_MAX) {
		format(itemName, 64, "Skin %d",modelid); // if it's a skin
	}
	return itemName;
}
