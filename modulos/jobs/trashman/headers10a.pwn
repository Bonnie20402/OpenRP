#define PRICE_PER_TRASH 5 // Price per trash.

#define RNG_TRASH_MIN 100 // Min amount of trash per trow
#define RNG_TRASH_MAX 200 // Max amount of trash per throw

#define MAX_TRASH_CAPACITY 300 // Max amount of trash per truck.

#define TRASHMAN_PAY 5000 // Payday value

enum TRASHMANVEHICLE {
    TRASHMANVEHICLE_VEHICLEID,
    TRASHMANVEHICLE_CURRENTTRASH,
    TRASHMANVEHICLE_MAXTRASH,
    Text3D:TRASHMANVEHICLE_TEXT
}



new gTrashman_VEHICLES[MAX_VEHICLES][TRASHMANVEHICLE]; // Trash man vehicles and their data
new gTrashman_PLAYERPICKUP[MAX_PLAYERS]; // Pickup for trash man players to get
new Float:gTrashman_PLAYERPICKUPCOORDS[MAX_PLAYERS][3];
new gTrashman_LASTPLAYERVEHICLE[MAX_PLAYERS]; // saves last job vehicle they're on, to get it's back position
new gTrashman_HOLDINGTRASH[MAX_PLAYERS]; // A boolean that returns if the player is holding a trash bag or not
    // Trash locations init (TODO add more trash locations)
new const Float:gLocations_Trashman[][] = {
    {2331.9841,-1949.5024,13.5808}, // Lixo 1
    {1843.6819,-1737.8408,13.3619}, //Lixo 2
    {1075.1863,-1699.1251,13.5469},//Lixo 3
    {1013.5336,-1307.4752,13.3828}, // Lixo 4
    {1369.3083,-1312.8268,13.5469}, // Lixo 5
    {1461.6632,-1487.8311,13.5469} // Lixo 6
    // pickup id 8 disappears after pickup but has no effect. Calls pickup event.

};
forward TrashManInit();
forward FindNewTrashmanLocation(playerid);
forward Float:GetPlayerDistanceFromTrashmanHQ(playerid);
forward GetTrashmanVehicleMaxTrash(vehicleid);
forward GetTrashmanVehicleTrash(vehicleid);
forward SetTrashmanVehicleTrash(vehicleid,amount);
forward UpdateTrashmanVehicleLabel(trashmanvehicleid);
forward IsTrashmanHoldingTrash(playerid);
forward IsValidTrashmanVehicle(vehicleid);
forward IsPlayerTrashman(playerid);