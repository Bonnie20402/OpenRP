#define MAX_LOCATIONS 501
enum LOCATIONS {
    String:LOCATION_NAME[64],
    Float:LOCATION_COORDS[3]
}

new gLocations[MAX_LOCATIONS-1][LOCATIONS];

forward PrepareLocationsTable();

forward PrepareLocationsLoad();
forward FinishLocationsLoad();

forward PrepareAddLocation(const name[],Float:x,Float:y,Float:z);
forward FinishAddLocation(const name[],Float:x,Float:y,Float:z);

forward PrepareRemoveLocation(playerid,locationid);
forward ContinueRemoveLocation(playerid,locationid);
forward FinishRemoveLocation(playerid,locationid);

forward IsValidLocation(locationid);

forward Float:GetLocationX(locationid);
forward Float:GetLocationY(locationid);
forward Float:GetLocationZ(locationid);

forward Int:GetLocationIDFromName(const name[]);

forward GetLocationName(locationid);