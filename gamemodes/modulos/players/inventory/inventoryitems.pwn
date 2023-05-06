/*
	Inventory module: inventorytable.pwn
	Contains the item defines for their ids as well as a stock function to convert the id to a name string based on id.
	Prefix: InvItem:			*/
 
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

#define ITEM_SKIN_MIN 0
#define ITEM_SKIN_MAX 312


stock InvItem:GetItemNameString(modelid) {
    new itemName[64];
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
	}
	if(modelid >= ITEM_SKIN_MIN && modelid < ITEM_SKIN_MAX) {
		format(itemName, 64, "Skin %d",modelid); // if it's a skin
	}
	return itemName;
}
