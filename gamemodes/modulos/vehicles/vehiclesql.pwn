


forward VehicleSQL:PrepareVehiclesTable();
public VehicleSQL:PrepareVehiclesTable() {
	new query[512];
	mysql_format(mysql,query,512,"CREATE TABLE IF NOT EXISTS vehicles ( rowid INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT, modelid INTEGER, x FLOAT, y FLOAT, z FLOAT, angle FLOAT, color1 INTEGER, color2 INTEGER, fuel INTEGER, shield INTEGER, hp INTEGER, locked INTEGER, FLAG_RESPAWN INTEGER, respawntime INTEGER, FLAG_PUBLIC INTEGER, ownertype INTEGER, owner varchar(64));");
    mysql_pquery(mysql,query,"PrepareLoadVehicles");
	print("[vehicesql.pwn] Vehicle SQL table loaded");
    return 1;
}

forward VehicleSQL:PrepareLoadVehicles();
public VehicleSQL:PrepareLoadVehicles() {
	inline LoadVehicles() {
		if(!cache_num_rows())print("[vehiclessql.pwn] WARN - No vehicles to load?!");
		else {
			new i;
			for(i;i<cache_num_rows();i++) {
				cache_get_value_index_int(i,0,gVehicles[i][VEHICLEINFO_ROWID]);
				cache_get_value_index_int(i,1,gVehicles[i][VEHICLEINFO_MODELID]);
				cache_get_value_index_float(i,2,gVehicles[i][VEHICLEINFO_COORDS][0]);
				cache_get_value_index_float(i,3,gVehicles[i][VEHICLEINFO_COORDS][1]);
				cache_get_value_index_float(i,4,gVehicles[i][VEHICLEINFO_COORDS][2]);
				cache_get_value_index_float(i,5,gVehicles[i][VEHICLEINFO_ANGLE]);
				cache_get_value_index_int(i,6,gVehicles[i][VEHICLEINFO_COLOR1]);
				cache_get_value_index_int(i,7,gVehicles[i][VEHICLEINFO_COLOR2]);
				cache_get_value_index_int(i,8,gVehicles[i][VEHICLEINFO_FUEL]);
				cache_get_value_index_int(i,9,gVehicles[i][VEHICLEINFO_SHIELD]);
				cache_get_value_index_int(i,10,gVehicles[i][VEHICLEINFO_HP]);
				cache_get_value_index_int(i,11,gVehicles[i][VEHICLEINFO_LOCKED]);
				cache_get_value_index_int(i,12,gVehicles[i][VEHICLEINFO_FLAG_RESPAWN]);
				cache_get_value_index_int(i,13,gVehicles[i][VEHICLEINFO_RESPAWNTIME]);
				cache_get_value_index_int(i,14,gVehicles[i][VEHICLEINFO_FLAG_PUBLIC]);
				cache_get_value_index_int(i,15,gVehicles[i][VEHICLEINFO_OWNERTYPE]);
				cache_get_value_index(i,16,gVehicles[i][VEHICLEINFO_OWNER]);
			}
			printf("[vehicles.pwn] A total of %d vehicles have been loaded",i);
			SpawnLoadedVehicles();
		}
	}
	new query[255];
	mysql_format(mysql,query,255,"SELECT * FROM vehicles");
	MySQL_PQueryInline(mysql,using inline LoadVehicles,query);
	return 1;
}

stock VehicleSQL:PrepareAddVehicle(modelid,Float:x,Float:y,Float:z,Float:angle,color1,color2,FLAG_RESPAWN,respawntime,FLAG_PUBLIC,ownertype,const owner[]) {
	new query[512];
	inline AddVehicle() {
		if(cache_affected_rows())printf("[vehiclesq.pwn] A new vehicle has been added",query);
		else printf("[vehiclesql.pwn] A new vehicle could not be added.\nCheck the query out:",query);
	}
	new fuel=100,hp=1000,shield=0;
	mysql_format(mysql, query, sizeof(query),
		"INSERT INTO vehicles (\
		modelid, x, y, z, angle, color1, color2, fuel, shield, hp, locked, FLAG_RESPAWN, respawntime, FLAG_PUBLIC, ownertype, owner) \
		VALUES (%d, %f, %f, %f, %f, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, '%s')",
		modelid, x, y, z, angle, color1, color2, fuel, shield, hp, 0, FLAG_RESPAWN, respawntime, FLAG_PUBLIC, ownertype, owner);
	if(!MySQL_PQueryInline(mysql,using inline AddVehicle,query)) {
		printf("[vehiclesql.pwn] Error in query while adding vehicle.\nQuery: %s",query);
	}
	return 1;
}

stock VehicleSQL:PrepareEditVehicle(rowid,modelid,Float:x,Float:y,Float:z,Float:angle,color1,color2,FLAG_RESPAWN,respawntime,FLAG_PUBLIC,ownertype,const owner[]) {
	inline EditVehicle() {
		printf("[vehiclesql.pwn] The vehicle with rowid %d has been edited.",rowid);
	}
	new query[512];
	mysql_format(mysql, query, sizeof(query), "UPDATE vehicles SET modelid = %d, x = %f, y = %f, z = %f, angle = %f, color1 = %d, color2 = %d, fuel = %d, shield = %d, hp = %d, locked = %d, FLAG_RESPAWN = %d, respawntime = %d, FLAG_PUBLIC = %d, ownertype = %d, owner = '%s' WHERE rowid = %d", modelid, x, y, z, angle, color1, color2, fuel, shield, hp, 0, FLAG_RESPAWN, respawntime, FLAG_PUBLIC, ownertype, ownerid,rowid);
	if(!MySQL_PQueryInline(mysql,using inline EditVehicle,query)) {
		printf("[vehiclesql.pwn] Error in query while editing vehicle.\nQuery: %s",query);
	}
	return 1;
}

stock VehicleSQL:PrepareSaveLoadedVehicle(vehicleid,silent = 0) {
	new index = GetLoadedVehicleIndex(vehicleid);
	new rowid = GetLoadedVehicleRowId(vehicleid);
	new Float:fhp;
	GetVehicleHealth(vehicleid,fhp);
	new hp=floatround(fhp);
	inline SaveLoadedVehicle() {
		if(!silent)printf("[vehiclesql.pwn] The vehicle id %d, at index %d and rowid %d has been saved with latest values from RAM.",vehicleid,index,rowid);
	}
	new query[512];
	mysql_format(mysql, query, sizeof(query), "UPDATE vehicles SET modelid = %d, x = %f, y = %f, z = %f, angle = %f, color1 = %d, color2 = %d, fuel = %d, shield = %d, hp = %d, locked = %d, FLAG_RESPAWN = %d, respawntime = %d, FLAG_PUBLIC = %d, ownertype = %d, owner = '%s' WHERE rowid = %d",\
	gVehicles[index][VEHICLEINFO_MODELID],gVehicles[index][VEHICLEINFO_COORDS][0],gVehicles[index][VEHICLEINFO_COORDS][1], gVehicles[index][VEHICLEINFO_COORDS][2],\
	gVehicles[index][VEHICLEINFO_ANGLE],gVehicles[index][VEHICLEINFO_COLOR1],gVehicles[index][VEHICLEINFO_COLOR2],\
	GetVehicleFuel(vehicleid),GetVehicleShield(vehicleid),hp,0,\
	gVehicles[index][VEHICLEINFO_FLAG_RESPAWN], gVehicles[index][VEHICLEINFO_RESPAWNTIME],\
	gVehicles[index][VEHICLEINFO_FLAG_PUBLIC],gVehicles[index][VEHICLEINFO_OWNERTYPE],gVehicles[index][VEHICLEINFO_OWNER],rowid);
	if(!MySQL_PQueryInline(mysql,using inline SaveLoadedVehicle,query)) {
		printf("[vehiclesql.pwn] Error ocurred while saving vehicle id %d. Index is %d and rowid is %d\nThe query: %s",vehicleid,index,rowid,query);
	}
	return 1;
}
stock VehicleSQL:PrepareDeleteVehicle(vehicleid) {
	if(IsValidLoadedVehicle(vehicleid)) {
		new rowid = GetLoadedVehicleRowId(vehicleid);
		inline DeleteVehicle() {
			DestroyLoadedVehicle(vehicleid);
			if(cache_affected_rows())printf("[vehiclesql.pwn] Deleted the vehicle id %d, with rowid %d and index %d",vehicleid,rowid,GetLoadedVehicleIndex(vehicleid));
			else printf("[vehiclesql.pwn] WARN - No rows affected while deleting vehicle id %d, with rowid %d and index %d!",vehicleid,rowid,GetLoadedVehicleIndex(vehicleid));
		}
		new query[255];
		mysql_format(mysql,query,255,"DELETE FROM vehicles WHERE rowid = %d",rowid);
		MySQL_PQueryInline(mysql,using inline DeleteVehicle,query);
	}
	return 1;
}
stock VehicleSQL:PrepareSaveLoadedVehicles() {
	for(new i;i<MAX_VEHICLES;i++) {
		if(IsValidLoadedVehicle(i))PrepareSaveLoadedVehicle(i,1);
	}
	return 1;
}

