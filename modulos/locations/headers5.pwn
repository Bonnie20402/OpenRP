/*
    locations.pwn
                    */
#define MAX_LOCATIONS 501
enum LOCATIONS {
    String:LOCATION_NAME[64],
    Int:LOCATION_INTERIORID,
    Float:LOCATION_COORDS[3]
}

new gLocations[MAX_LOCATIONS-1][LOCATIONS];

forward PrepareLocationsTable();

forward PrepareLoadLocations();
forward FinishLoadLocations();

forward PrepareAddLocation(const name[],interiorid,Float:x,Float:y,Float:z);
forward FinishAddLocation(const name[],interiorid,Float:x,Float:y,Float:z);

forward PrepareRemoveLocation(playerid,locationid);
forward ContinueRemoveLocation(playerid,locationid);
forward FinishRemoveLocation(playerid,locationid);

forward IsValidLocation(locationid);
forward GetLocationCoordsPointers(locationid, &Float:x,&Float:y,&Float:z);
forward Float:GetLocationX(locationid);
forward Float:GetLocationY(locationid);
forward Float:GetLocationZ(locationid);

forward Int:GetLocationIDFromName(const name[]);

forward String:GetLocationName(locationid);

forward GetLocationInterior(locationid);
/*
    locationpickups.pwn
                        */
enum LOCATIONPICKUP {
    //Int:LOCATIONPICKUP_TYPE Should always be 1, for now.
    Int:LOCATIONPICKUP_PICKUPID,
    Int:LOCATIONPICKUP_ROWID, // It's the mysql row id.
    Int:LOCATIONPICKUP_MODEL,
    Int:LOCATIONPICKUP_INTERIORID,
    Int:LOCATIONPICKUP_LOCATIONID, // Linked to a locationid from the other module.
    Text3D:LOCATIONPICKUP_TEXT,
    Float:LOCATIONPICKUP_COORDS[3]
}
// DEPENDS ON THE LOCATIONS MODULE!
new gLocationPickups[MAX_PICKUPS][LOCATIONPICKUP];

forward PrepareLocationPickupsTable();
forward PrepareLoadLocationPickups();
forward FinishLoadLocationPickups();


forward PrepareAddLocationPickup(model,interiorid,locationid,const text[64],Float:x,Float:y,Float:z);
forward FinishAddLocationPickup(model,interiorid,locationid,const text[64],Float:x,Float:y,Float:z);

forward PrepareRemoveLocationPickup(rowid);
forward FinishRemoveLocationPickup(rowid);

forward IsValidLocationPickup(pickupid);
forward GetLocationPickupIdFromName(const name[64]);

forward GetLocationPickupCoordsPointers(pickupid,&Float:x,&Float:y,&Float:z);

forward GetLocationPickupInteriorId(pickupid);
forward GetLocationPickupInteriorIdPointer(pickupid,&interiorid);

forward GetLocationPickupLocationID(pickupid);