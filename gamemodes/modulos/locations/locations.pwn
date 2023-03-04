


#include <YSI_Coding\y_hooks>

/*
    hooks
            */
hook dbInit() {
    PrepareLocationsTable();
    return 1;
}

/*
    LocationsTable
    Creates the locations table
    */
public PrepareLocationsTable() {
    new query[255];
    mysql_format(mysql,query,255,"CREATE TABLE IF NOT EXISTS locations (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,name varchar(64),x decimal(20,6),y decimal(20,6),z decimal(20,6));");
    mysql_query(mysql,query,false);
    PrepareLocationsLoad();
}

/*
        LocationsLoad
        Loads the locations from the table and 
        fills the vector in ram
                                        */
public PrepareLocationsLoad() {
    new query[255];
    mysql_format(mysql,query,255,"SELECT * FROM locations");
    mysql_pquery(mysql,query,"FinishLocationsLoad","");
}

public FinishLocationsLoad() {
    new rows;
    cache_get_row_count(rows);
    for(new i=0;i<rows;i++) {
        new id;
        cache_get_value_index_int(i,0,id);
        cache_get_value_index(i,1,gLocations[id][LOCATION_NAME]);
        cache_get_value_index_float(i,2,gLocations[id][LOCATION_COORDS][0]);
        cache_get_value_index_float(i,3,gLocations[id][LOCATION_COORDS][1]);
        cache_get_value_index_float(i,4,gLocations[id][LOCATION_COORDS][2]);
    }
}
/*
        AddLocation
        Adds a location to the table
                                            */

public PrepareAddLocation(const name[],Float:x,Float:y,Float:z) {
    new query[255];
    mysql_format(mysql,query,255,"INSERT INTO locations (name, x, y, z) VALUES ('%s', %f, %f, %f)",name,x,y,z);
    mysql_pquery(mysql,query,"FinishAddLocation","sfff",name,x,y,z);
    return 1;
}

public FinishAddLocation(const name[],Float:x,Float:y,Float:z) {
    new String:msg[255];
    format(msg,255,"A localização %s nas coords (%.2f,%.2f,%.2f) foi criada.",name,x,y,z);
    SendStaffMessage(-1,msg);
    PrepareLocationsLoad();
    return 1;
}
/*
    RemoveLocation
    Removes a location from the table
    and empties it's value in RAM
                                    */

public PrepareRemoveLocation(playerid,locationid) {
    new query[255];
    mysql_format(mysql,query,255,"SELECT * FROM locations WHERE id = %d",locationid);
    mysql_pquery(mysql,query,"ContinueRemoveLocation","ii",playerid,locationid);
    return 1;
}

public ContinueRemoveLocation(playerid,locationid) {
    new Int: locExists;
    new String:msg[64];
    cache_get_field_count(locExists);
    if(locExists) {
        new query[255];
        mysql_format(mysql,query,255,"DELETE FROM locations WHERE id = %d",locationid);
        mysql_pquery(mysql,query,"FinishRemoveLocation","ii",playerid,locationid);
        return 1;   
    }
    format(msg,64,"A localização ID %d não existe",locationid);
    SendStaffMessage(-1,msg);
    return 1;
}


public FinishRemoveLocation(playerid,locationid) {
    new String:msg[255];
    format(msg,255,"A localozação ID %d foi removida da base de dados e da RAM.",locationid);
    gLocations[locationid][LOCATION_COORDS][0] = 0;
    gLocations[locationid][LOCATION_COORDS][1] = 0;
    gLocations[locationid][LOCATION_COORDS][2] = 0;
    format(gLocations[locationid][LOCATION_NAME],64,"");
    SendStaffMessage(-1,msg);
    return 1;
}

/*
    Getters
                */

/*
    IsValidLocation
    checks if a given locationid exists
    does it by comparing the name atribute > 0
                                    */
public IsValidLocation(locationid) {
    //If the size is 0, thhen the location does not exist.
    return strlen(gLocations[locationid][LOCATION_NAME]);
}
public Float:GetLocationX(locationid) {
    return gLocations[locationid][LOCATION_COORDS][0];
}
public Float:GetLocationY(locationid) {
    return gLocations[locationid][LOCATION_COORDS][1];
}
public Float:GetLocationZ(locationid) {
    return gLocations[locationid][LOCATION_COORDS][2];
}
public Int:GetLocationIDFromName(const name[]) {
    for(new i=0;i<sizeof(gLocations);i++) {
        if(!strcmp((gLocations)[i][LOCATION_NAME],name))  return i;
    }
    return 0;
}
public GetLocationName(locationid) {
    return gLocations[locationid][LOCATION_NAME];
}

