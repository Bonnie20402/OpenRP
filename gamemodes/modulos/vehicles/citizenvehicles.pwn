


//Put this on dbInit();
public PrepareCitizenVehiclesTable() {
    new query[255];
    mysql_format(mysql,query,255,"CREATE TABLE IF NOT EXISTS citizenvehicles (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,type INT,color1 INT,color2 INT,x DECIMAL(10,6),y DECIMAL(10,6),z DECIMAL(10,6));");
    mysql_query(mysql,query,false);
    PrepareLoadCitizenVehicles();
}

/*
    LoadCitizenVehicles
    Loads vehicles from the table to the server
    is reload-safe, as already created vehicles will be ignored.
                        */
public PrepareLoadCitizenVehicles() {
    new query[255];
    mysql_format(mysql,query,255,"SELECT * FROM citizenvehicles");
    mysql_pquery(mysql,query,"FinishLoadCitizenVehicles","");
}
public FinishLoadCitizenVehicles() {
    /*
        Clear the already loaded vehicles
                                            */
    new qtd;
    for(new i=0;i<sizeof(gCitizenVehicles);i++) {
        DestroyVehicle(gCitizenVehicles[i]);
        gCitizenVehicles[i]=0;
    }
    //Spawn the vehicles
    for(new i=0;i<cache_num_rows();i++) {
        new id,type,color1,color2;
        new Float:x,Float:y,Float:z;
        cache_get_value_index_int(i,0,id);
        cache_get_value_index_int(i,1,type);
        cache_get_value_index_int(i,2,color1);
        cache_get_value_index_int(i,3,color2);
        cache_get_value_index_float(i,4,x);
        cache_get_value_index_float(i,5,y);
        cache_get_value_index_float(i,6,z);
        qtd++;
        if(!gCitizenVehicles[id]) { 
            gCitizenVehicles[id] =AddStaticVehicleEx(type,x,y,z,90,color1,color2,120,0);
            new String:vehicleText[255];
            new Text3D:vehicleTextLabel;
            format(vehicleText,255,"{ffffff}- Veiculo Civil[{00ffff}%d{ffffff}] -",id);
            vehicleTextLabel = Create3DTextLabel(vehicleText,-1, 0.0, 0.0, 0.0, 50.0, 0, 1);
            Attach3DTextLabelToVehicle(vehicleTextLabel,gCitizenVehicles[id],0,0,0);
            VehicleInit(gCitizenVehicles[id]);
        }
    }
    new msg[255];
    format(msg,255,"[citizenvehicles.pwn] %d citizenVehicles loaded.",qtd);
    print(msg);
    return 1;
}
/*
        RemoveCitizenVehicle
        Removes a citizen vehicle from the table then reloads the vehicles.
                            */
public PrepareRemoveCitizenVehicle(rowid) {
    new query[255];
    mysql_format(mysql,query,255,"DELETE FROM citizenvehicles WHERE id = %d",rowid);
    mysql_pquery(mysql,query,"FinishRemoveCitizenVehicle","i",rowid);
}

public FinishRemoveCitizenVehicle(rowid) {
    printf("rowid %d",rowid);
    if(cache_affected_rows()) {
        new msg[255];
        format(msg,255,"Veiculo CitizenVehicle ID %d foi eliminado!",rowid);
        SendStaffMessage(-1,msg);
        PrepareLoadCitizenVehicles();
        return 1;
    }
    SendStaffMessage(-1,"Erro ao remover CitizenVehicle: veiculo não existe");
}
/*
    AddCitizenVehicle
    AAdds a new citizen vehicle
                            */
public PrepareAddCitizenVehicle(type,color1,color2,Float:x,Float:y,Float:z) {
    new query[255];
    mysql_format(mysql,query,255,"INSERT INTO citizenvehicles (type, color1, color2, x, y, z) VALUES (%d, %d, %d, %f, %f, %f)",type,color1,color2,x,y,z);
    mysql_pquery(mysql,query,"FinishAddCitizenVehicle","");
}


public FinishAddCitizenVehicle() {
    if(!cache_affected_rows())print("[citizenvehicles.pwn] Error adding vehicle!");
    else {
        print("[citizenvehicles.pwn] Vehicle has been added. Reloading...");
        PrepareLoadCitizenVehicles();
    }
    return 1;
}

/*
    IsCitizenVehicle
    Checks if a vehicleid is a CitizenVehicle
                                */

public IsCitizenVehicle(vehicleid) {
    for(new i=0;i<sizeof(gCitizenVehicles);i++) {
        if(gCitizenVehicles[i]==vehicleid) return 1;
    }
    return 0;
}