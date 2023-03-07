#include <YSI_Coding\y_hooks>
// TOOD move interiorid to locations table to make life easy
public PrepareLocationPickupsTable() {
    new query[255];
    mysql_format(mysql,query,255,"CREATE TABLE IF NOT EXISTS LocationPickups (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,model INT,interiorid INT,locationid INT,text VARCHAR(64),x FLOAT,y FLOAT,z FLOAT)");
    mysql_query(mysql,query,false);
    PrepareLoadLocationPickups();
    return 1;
}


public PrepareLoadLocationPickups() {
    new query[255];
    mysql_format(mysql,query,255,"SELECT * FROM LocationPickups");
    mysql_pquery(mysql,query,"FinishLoadLocationPickups","");
    return 1;
}

public FinishLoadLocationPickups() {
    new i,String:rawText[64];
    for(i=0;i<sizeof(gLocationPickups);i++) {
        if(IsValidLocationPickup(i)) {
            DestroyDynamic3DTextLabel(gLocationPickups[i][LOCATIONPICKUP_TEXT]);
            DestroyDynamicPickup(gLocationPickups[i][LOCATIONPICKUP_PICKUPID]);
            gLocationPickups[i][LOCATIONPICKUP_PICKUPID]=-1;
        }
    }
    for(i=0;i<cache_num_rows();i++) {
        cache_get_value_index_int(i,0,gLocationPickups[i][LOCATIONPICKUP_ROWID]);
        cache_get_value_index_int(i,1,gLocationPickups[i][LOCATIONPICKUP_MODEL]);
        cache_get_value_index_int(i,2,gLocationPickups[i][LOCATIONPICKUP_INTERIORID]);
        cache_get_value_index_int(i,3,gLocationPickups[i][LOCATIONPICKUP_LOCATIONID]); // Reminder! Locations module.
        //if(!IsValidLocation(gLocationPickups[i][LOCATIONPICKUP_LOCATIONID]))printf("[locationpickups.pwn] WARN - pickup id %d points to invalid location %d",gLocationPickups[i][LOCATIONPICKUP_ROWID],gLocationPickups[i][LOCATIONPICKUP_LOCATIONID]);
        cache_get_value_index_float(i,5,gLocationPickups[i][LOCATIONPICKUP_COORDS][0]);
        cache_get_value_index_float(i,6,gLocationPickups[i][LOCATIONPICKUP_COORDS][1]);
        cache_get_value_index_float(i,7,gLocationPickups[i][LOCATIONPICKUP_COORDS][2]);
        cache_get_value_index(i,4,rawText);
        gLocationPickups[i][LOCATIONPICKUP_TEXT]=CreateDynamic3DTextLabel(rawText,-1,gLocationPickups[i][LOCATIONPICKUP_COORDS][0],gLocationPickups[i][LOCATIONPICKUP_COORDS][1],gLocationPickups[i][LOCATIONPICKUP_COORDS][2],30);
        gLocationPickups[i][LOCATIONPICKUP_PICKUPID]=CreateDynamicPickup(gLocationPickups[i][LOCATIONPICKUP_MODEL],1,gLocationPickups[i][LOCATIONPICKUP_COORDS][0],gLocationPickups[i][LOCATIONPICKUP_COORDS][1],gLocationPickups[i][LOCATIONPICKUP_COORDS][2]);
    }
    printf("[locationpickups.pwn] Foram carregados %d LocationPickups",cache_num_rows());
    return 1;
}
public PrepareAddLocationPickup(model,interiorid,locationid,const text[64],Float:x,Float:y,Float:z) {
    if(!IsValidLocation(locationid)) {
        SendStaffMessage(-1,"[locationPickups] Localização inválida!");
        return 0;
    }
    new query[255];
    mysql_format(mysql,query,255,"INSERT INTO LocationPickups (model, locationid,interiorid, text, x, y, z) VALUES (%d, %d,%d, '%s', %f, %f, %f)",model,locationid,interiorid,text,x,y,z);
    mysql_pquery(mysql,query,"FinishAddLocationPickup","iiisfff",model,interiorid,locationid,text,x,y,z);
    return 1;
}

public FinishAddLocationPickup(model,interiorid,locationid,const text[64],Float:x,Float:y,Float:z) {
    printf("[locationpickups.pwn] NOVO PICKUP CRIADO\nModelo:%d IntID: %d LocID: %d\nText: %s\nCoords: {%f,%f,%f}",model,interiorid,locationid,text,x,y,z);
    PrepareLoadLocationPickups();
    return 1;
}


public PrepareRemoveLocationPickup(rowid) {
    new query[255];
    mysql_format(mysql,query,255,"DELETE FROM LocationPickups WHERE id = %d;",rowid);
    mysql_pquery(mysql,query,"FinishRemoveLocationPickup","i",rowid);
    return 1;
}

public FinishRemoveLocationPickup(rowid) {
    SendStaffMessage(-1,"[locationPickups] Um locationnPickup foi eliminado por um Programador!");
    printf("[locationpickups.pwn] Location deleted rowid: %d",rowid);
    PrepareLoadLocationPickups();
    return 1;
}


public IsValidLocationPickup(pickupid) {
    if (gLocationPickups[pickupid][LOCATIONPICKUP_PICKUPID]!=-1) return 1;
    return 0;
}


public GetLocationPickupIdFromName(const name[64]) {
    for(new i=0;i<sizeof(gLocationPickups);i++) {
        if(!strcmp(gLocationPickups[i][LOCATIONPICKUP_TEXT],name))return gLocationPickups[i][LOCATIONPICKUP_ROWID];
    }
    return 0;
}

public GetLocationPickupCoordsPointers(pickupid,&Float:x,&Float:y,&Float:z) {
    if(IsValidLocationPickup(pickupid)) {
        x=gLocationPickups[pickupid][LOCATIONPICKUP_COORDS][0];
        y=gLocationPickups[pickupid][LOCATIONPICKUP_COORDS][1];
        z=gLocationPickups[pickupid][LOCATIONPICKUP_COORDS][2];
        return 1;
    }
    return 0;
}


public GetLocationPickupInteriorId(pickupid) {
    if(IsValidLocationPickup(pickupid))return gLocationPickups[pickupid][LOCATIONPICKUP_INTERIORID];
    return -1;
}
public GetLocationPickupInteriorIdPointer(pickupid,&interiorid) {
    if(IsValidLocationPickup(pickupid))interiorid=gLocationPickups[pickupid][LOCATIONPICKUP_INTERIORID];
    return 1;
}

public GetLocationPickupLocationID(pickupid) {
    if(IsValidLocationPickup(pickupid))return gLocationPickups[pickupid][LOCATIONPICKUP_LOCATIONID];
    return 1;
}



hook OnPlayerKeyStateChange(playerid,newkeys,oldkeys) {
    if(PRESSED(KEY_YES)) {
        new interiorid,Float:dist,Float:x,Float:y,Float:z;
        for(new i;i<sizeof(gLocationPickups);i++) {
            if(IsValidLocationPickup(i)) {
                GetLocationPickupCoordsPointers(i,x,y,z);
                dist=GetPlayerDistanceFromPoint(playerid,x,y,z);
                if(dist<2) {
                    new Float:x2,Float:y2,Float:z2;
                    GetLocationCoordsPointers(GetLocationPickupLocationID(i),x2,y2,z2);
                    interiorid=GetLocationPickupInteriorId(i);
                    SetPlayerPos(playerid,x2,y2,z2);
                    SetPlayerInterior(playerid,interiorid);
                }
            }
        }
        return 1;
    }

    
}






