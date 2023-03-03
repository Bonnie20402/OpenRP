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