

#include "modulos/locations/iconsInit.pwn"
#include <YSI_Coding/y_hooks>
#define MAX_LOCATIONS 501


/*
    VARIABLES
                    */

enum LOCATIONS {
    String:LOCATION_NAME[64],
    Float:LOCATION_COORDS[3]
}

new gLocations[MAX_LOCATIONS-1][LOCATIONS];


/*
    hooks
            */
            // TODO iniciar locations ao ligar a database
hook OnPlayerLogin@000(playerid) {
    locationIconsInit(playerid);
}
/*
    LocationsTable
    Creates the locations table
    */
forward PrepareLocationsTable();
public PrepareLocationsTable() {
    new query[255];
    mysql_format(mysql,query,255,"CREATE TABLE IF NOT EXISTS locations (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,name varchar(64),x float,y float,z float);");
    mysql_query(mysql,query,false);
    PrepareLocationsLoad();
}

/*
        LocationsLoad
        Loads the locations from the table and 
        fills the vector in ram
                                        */
stock PrepareLocationsLoad() {
    new String:query[255];
    mysql_format(mysql,query,255,"SELECT * FROM locations");
    mysql_pquery(mysql,query,"FinishLocationsLoad","");
}
forward FinishLocationsLoad();
public FinishLocationsLoad() {
    new rows;
    cache_get_row_count(rows);
    for(new i=0;i<rows;i++) {
        new id;
        cache_get_value_index_int(i,0,id);
        cache_get_value_index(i,1,gLocations[id][LOCATION_NAME]);
        cache_get_value_index_float(i,2,gLocations[id][LOCATION_COORDS][0]);
        cache_get_value_index_float(i,2,gLocations[id][LOCATION_COORDS][1]);
        cache_get_value_index_float(i,3,gLocations[id][LOCATION_COORDS][2]);
    }
    SendStaffMessage(-1,"Localizções carregadas!");
}
/*
        AddLocation
        Adds a location to the table
                                            */

forward PrepareAddLocation(const name[],Float:x,Float:y,Float:z);
public PrepareAddLocation(const name[],Float:x,Float:y,Float:z) {
    new String:query[255];
    mysql_format(mysql,query,255,"INSERT INTO locations (name, x, y, z) VALUES ('%s', %f, %f, %f)",name,x,y,z);
    mysql_pquery(mysql,query,"FinishAddLocation","sfff",name,x,y,z);
    SendStaffMessage(-1,"A adicionar localização...");
    return 1;
}
forward FinishAddLocation(const name[],Float:x,Float:y,Float:z);
public FinishAddLocation(const name[],Float:x,Float:y,Float:z) {
    new String:msg[255];
    format(msg,255,"A localização %s nas coords (%.2f,%.2f,%.2f) foi criada.",name,x,y,z);
    SendStaffMessage(-1,msg);
    PrepareLocationsLoad();
    return 1;
}

// TODO remove location