/*
    vehicles.pwn
                    */
enum VEHICLEINFO {
	VEHICLEINFO_ROWID,
	VEHICLEINFO_VEHICLEID,
	VEHICLEINFO_MODELID,
	Float:VEHICLEINFO_COORDS[3],
	Float:VEHICLEINFO_ANGLE,
	VEHICLEINFO_COLOR1,
	VEHICLEINFO_COLOR2,
	VEHICLEINFO_FUEL,
	VEHICLEINFO_SHIELD,
	VEHICLEINFO_HP,
	VEHICLEINFO_LOCKED,
	VEHICLEINFO_FLAG_RESPAWN, // FLAG to decide if vehicle is supposed to be respawned by itself or not
	VEHICLEINFO_RESPAWNTIME,
	VEHICLEINFO_FLAG_PUBLIC,  // FLAG to know if vehicle is public or has a owner type (Might be a org vehicle, player vehicle)
	VEHICLEINFO_OWNERTYPE,
	String:VEHICLEINFO_OWNER[64], // If ownertype is player it's going to be a playerid, if org orgid, etc.....
	Text3D:VEHICLEINFO_TEXT3D[64] // 3D text for vehicles.

}

enum OWNERTYPE { //
	OWNERTYPE_PLAYER,
	OWNERTYPE_JOB,
	OWNERTYPE_ORG,
	OWNERTYPE_ADMIN,
	OWNERTYPE_COP 
}
new gVehicles[MAX_VEHICLES][VEHICLEINFO];
forward OnVehicleSpawn(vehicleid);
forward VehicleInit(vehicleid);

/*
    vehiclehud.pwn
                    */
new txdVehicleHud[6];
new txdVehicleHudPlayer[5][MAX_PLAYERS];
new gVehicleTimer[MAX_PLAYERS];

forward ShowPlayerSpeedMeter(playerid);
forward UpdateVehicleSpeedMeter(playerid);

/*
    vehiclefuel.pwn
                    */
new gVehicleFuel[MAX_VEHICLES];
forward UpdateVehicleFuel(vehicleid);
forward GetVehicleFuel(vehicleid);
forward SetVehicleFuel(vehicleid,fuel);
forward FuelVehicle(vehicleid);
/*
    vehicleshield.pwn
                    */
new gVehicleShield[MAX_VEHICLES];
forward ShieldVehicle(vehicleid);
forward SetVehicleShield(vehicleid,shield);
forward GetVehicleShield(vehicleid);

