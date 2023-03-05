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

forward PrepareInteriorPickupsTable();
forward PrepareLoadInteriorPickups();
forward FinishLoadInteriorPickups();

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