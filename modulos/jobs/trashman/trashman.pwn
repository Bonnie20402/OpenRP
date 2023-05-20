/*
    TRASH MAN
    Adds trash man job to the server    
    TODO criar spawn lixeiro
    TODO criar carros lixeiro
    TODO criar logica lixeiro        
                                    */
#include <YSI_Coding\y_hooks>


public TrashManInit() {
    //Setup job information
    gJobs[JOBLIST_TRASHMAN][JOBINFO_SPAWN][0] = 2195.9844;
    gJobs[JOBLIST_TRASHMAN][JOBINFO_SPAWN][1] = -1973.4258;
    gJobs[JOBLIST_TRASHMAN][JOBINFO_SPAWN][2] = 13.5589;
    gJobs[JOBLIST_TRASHMAN][JOBINFO_SKIN] = 289; 
    gJobs[JOBLIST_TRASHMAN][JOBINFO_PAYCHECK] = TRASHMAN_PAY;
    //Clear all loaded vehicles (reload-friendly)
    for(new i=0;i<sizeof(gTrashman_VEHICLES);i++) {
        if(IsValidVehicle(gTrashman_VEHICLES[i][TRASHMANVEHICLE_VEHICLEID])) {
            DestroyVehicle(i);
            DestroyDynamic3DTextLabel(gTrashman_VEHICLES[i][TRASHMANVEHICLE_TEXT]);
        }
    }
    // Job vehicles
    //ADDING IN GAME
    
    
    //Vehicle  init logic
    for(new i=0;i<sizeof(gTrashman_VEHICLES);i++) {
        if(IsValidVehicle(gTrashman_VEHICLES[i][TRASHMANVEHICLE_VEHICLEID])) {
            VehicleInit(gTrashman_VEHICLES[i][TRASHMANVEHICLE_VEHICLEID]);
            SetVehicleShield(gTrashman_VEHICLES[i][TRASHMANVEHICLE_VEHICLEID],25);
            gTrashman_VEHICLES[i][TRASHMANVEHICLE_MAXTRASH]=MAX_TRASH_CAPACITY;
            gTrashman_VEHICLES[i][TRASHMANVEHICLE_TEXT]=CreateDynamic3DTextLabel("Á espera...",-1,0,0,0,15,INVALID_PLAYER_ID,gTrashman_VEHICLES[i][TRASHMANVEHICLE_VEHICLEID]);
            UpdateTrashmanVehicleLabel(gTrashman_VEHICLES[i][TRASHMANVEHICLE_VEHICLEID]);
        }
    }
    print("[trashman.pwn] Job loaded!");
    return 1;
}
YCMD:trash(playerid,params[],help) {
    gPlayerJobs[playerid]=JOBLIST_TRASHMAN;
    SendStaffMessage(-1,"Um programador tornou-se lixeiro lol");
    return 1;
}
/*
    FindNewTrashmanLocation
    Creates a new pickup for a player.
    Validates:
    - If the player is a trashman;
    - If player is currently in a trashman vehicle;
    - If the player's trashman vehicle is full or not, and notifies them if so marking the gps to their hq;

*/

public FindNewTrashmanLocation(playerid) {
    if(IsPlayerTrashman(playerid)) {
        if(IsValidTrashmanVehicle(GetPlayerVehicleID(playerid))) {
            new vehicleid;
            vehicleid = GetPlayerVehicleID(playerid);
            // If vehicle is full, tell player to go back to trashman hq
            if(vehicleid==INVALID_VEHICLE_ID)return 0;
            if(GetTrashmanVehicleTrash(vehicleid)==GetTrashmanVehicleMaxTrash(vehicleid)) {
                new Float:x,Float:y,Float:z;
                new locationid;
                locationid=GetLocationIDFromName("JOBHQ_Lixeiro");
                GetLocationCoordsPointers(locationid,x,y,z);
                SetPlayerCheckpoint(playerid,x,y,z,1.0);
                ShowPlayerScreenMessage(playerid,3000,"Veiculo cheio, va despejar na base!");
                SendClientMessage(playerid,COLOR_YELLOW,"Veiculo cheio, volte para a base e buzine para vender o seu lixo!");
                return 1;
            }
        }
        // Check if they already have a location marked
        if(gTrashman_PLAYERPICKUP[playerid]) {
            SetPlayerCheckpoint(playerid,gTrashman_PLAYERPICKUPCOORDS[playerid][0],gTrashman_PLAYERPICKUPCOORDS[playerid][1],gTrashman_PLAYERPICKUPCOORDS[playerid][2],1.0);
            SendClientMessage(playerid,COLOR_YELLOW,"Você já tem lixo marcado no radar!");
            return 1;
        }
        // Else get a new location for them.
        new loc,Float:x,Float:y,Float:z;
        loc = random(sizeof(gLocations_Trashman)-1);
        x = gLocations_Trashman[loc][0];
        y = gLocations_Trashman[loc][1];
        z = gLocations_Trashman[loc][2];
        gTrashman_PLAYERPICKUP[playerid]=CreateDynamicPickup(1264,8,x,y,z,-1,-1,playerid,25.0);
        SetPlayerCheckpoint(playerid,x,y,z,1.0);
        gTrashman_PLAYERPICKUPCOORDS[playerid][0]=x;
        gTrashman_PLAYERPICKUPCOORDS[playerid][1]=y;
        gTrashman_PLAYERPICKUPCOORDS[playerid][2]=z;
        SendClientMessage(playerid,COLOR_YELLOW,"Foi marcado um lixo no radar, vá pegar ele!");
        ShowPlayerScreenMessage(playerid,3000,"Lixo marcado no radar!");
        return 1;
    }
    SendClientMessage(playerid,COLOR_RED,"Não és Lixeiro!");
    return 1;
}
hook OnPlayerPickUpDynPickup(playerid,pickupid) {
    if(pickupid==gTrashman_PLAYERPICKUP[playerid]) {
        /*
            Attach trash to player logic
                                            */
        SetPlayerAttachedObject(playerid,1, 1264, 4, 0.226000, -0.277000, 0.126999, 9.200012, -11.000000, -88.799995);
        DestroyDynamicPickup(gTrashman_PLAYERPICKUP[playerid]);
        gTrashman_PLAYERPICKUP[playerid]=0;
        gTrashman_HOLDINGTRASH[playerid]=SetTimerEx("TrashmanHoldingTrashCheck",500,true,"i",playerid);
        ShowPlayerScreenMessage(playerid,2000,"Meta o lixo na parte traseira do veiculo!");
        gTrashman_PLAYERPICKUPCOORDS[playerid][0] = 0.0;
        gTrashman_PLAYERPICKUPCOORDS[playerid][1] = 0.0;
        gTrashman_PLAYERPICKUPCOORDS[playerid][2] = 0.0;
        new Float:x,Float:y,Float:z,Float:dist;
        GetPosNearVehiclePart(GetPlayerLastTrashmanVehicle(playerid),VEH_PART_TRUNK,x,y,z,0.25);
        SetPlayerCheckpoint(playerid,x,y,z,1.0);
        return 1;
    }
    return 1;
}
public TrashmanHoldingTrashCheck(playerid) {
        /*
        Fill logic
        When the players puts trash in back of truck.
        Insipred on BrasilPlayShox
        TODO: Add throwing animation
    */
    if(IsPlayerTrashman(playerid)&&gTrashman_HOLDINGTRASH[playerid]) {
        new Float:x,Float:y,Float:z,Float:dist;
        GetPosNearVehiclePart(GetPlayerLastTrashmanVehicle(playerid),VEH_PART_TRUNK,x,y,z,0.25);
        dist=GetPlayerDistanceFromPoint(playerid,x,y,z);
        if(dist<3.0) {
            RemovePlayerAttachedObject(playerid,1);
            new trashQuantity;
            trashQuantity = RNG_TRASH_MIN + random(RNG_TRASH_MAX);
            new vehicleid;
            vehicleid=GetPlayerLastTrashmanVehicle(playerid);
            new newTrash;
            newTrash=GetTrashmanVehicleTrash(vehicleid);
            newTrash+=trashQuantity;
            if(newTrash>MAX_TRASH_CAPACITY)newTrash=MAX_TRASH_CAPACITY;
            SetTrashmanVehicleTrash(vehicleid,newTrash);
            SendClientMessage(playerid,COLOR_YELLOW,"Lixo adicionado ao veiculo! Volte a entrar e aperte N para saber a proxima localização!");
            DisablePlayerCheckpoint(playerid);
            KillTimer(gTrashman_HOLDINGTRASH[playerid]);
            gTrashman_HOLDINGTRASH[playerid]=0;
        }
    }
    return 1;
}
//Remember last vehicle trash man players were on.
hook OnPlayerExitVehicle(playerid,vehicleid) {
    if(IsPlayerTrashman(playerid)&&IsValidTrashmanVehicle(vehicleid)) {
        gTrashman_LASTPLAYERVEHICLE[playerid]=vehicleid;
    }
}
//Prevent a vehicle from being used by other job members
hook OnPlayerEnterVehicle(playerid,vehicleid,ispassanger) {
    if(!ispassanger&&IsValidTrashmanVehicle(vehicleid)&&!IsPlayerTrashman(playerid)) {
        new Float:x,Float:y,Float:z;
        GetPlayerPos(playerid,x,y,z);
        SetPlayerPos(playerid,x,y,z);
        SendClientMessage(playerid,COLOR_YELLOW,"Precisas de ser Lixeiro para usar este veiculo!");
        return 1;
    }
}
#include <YSI_Coding\y_hooks>
hook OnPlayerEnterVehicle(playerid,vehicleid,ispassanger) {
    if(IsPlayerTrashman(playerid)&&!ispassanger&&IsValidTrashmanVehicle(vehicleid)&&GetPlayerDistanceFromTrashmanHQ(playerid)<20.0) {
        SendClientMessage(playerid,COLOR_YELLOW,"Para trabalhar, aperte N e siga o ponto de lixo marcado no radar!");
        SendClientMessage(playerid,COLOR_YELLOW,"Quando o depósito encher, volte para a HQ e buzine para vender!");
        return 1;
    }
}

public Float:GetPlayerDistanceFromTrashmanHQ(playerid) {
    new Float:x,Float:y,Float:z,Float:dist;
    new locationid=GetLocationIDFromName("JOBHQ_Lixeiro");
    GetLocationCoordsPointers(locationid,x,y,z);
    return GetPlayerDistanceFromPoint(playerid,x,y,z);
}
hook OnPlayerKeyStateChange(playerid,newkeys,oldkeys) {
    if(PRESSED(KEY_NO)&&IsPlayerTrashman(playerid)) {
/*
                    Work logic
                    forwarded to function FindNewTrashmanLocation
                                    */
        if(IsValidTrashmanVehicle(GetPlayerVehicleID(playerid))) {
            FindNewTrashmanLocation(playerid);
            return 1;
        }
    }
    if(PRESSED(KEY_CROUCH)&&IsPlayerTrashman(playerid)) {
        new Float:dist,Float:x,Float:y,Float:z;
        new String:msg[64];
/*
                    Sell logic
                    Should be at HQ, at distance < 15.
                    price is const PRICE_PER_TRASH*trashamount.
                    After selling, label should be updated.
                                    */
        if(IsValidTrashmanVehicle(GetPlayerVehicleID(playerid))) {
            new locationid,vehicleid;
            vehicleid=GetPlayerVehicleID(playerid);
            locationid=GetLocationIDFromName("JOBHQ_Lixeiro");
            GetLocationCoordsPointers(locationid,x,y,z);
            dist=GetPlayerDistanceFromPoint(playerid,x,y,z);
            if(dist<=15.0&&GetTrashmanVehicleTrash(vehicleid)>0) {
                new sellMoney;
                sellMoney=PRICE_PER_TRASH*GetTrashmanVehicleTrash(vehicleid);
                format(msg,64,"Você vendeu %dkg de lixo por R$%d!",GetTrashmanVehicleTrash(vehicleid),sellMoney);
                SetTrashmanVehicleTrash(vehicleid,0);
                GivePlayerMoney(playerid,sellMoney);
                UpdateTrashmanVehicleLabel(vehicleid);
                SendClientMessage(playerid,COLOR_YELLOW,msg);
                return 1;
            }
        }
    }
    return 1;
}


hook OnPlayerDisconnect(playerid,reason) {
    //Clear the pickups and holding boolean when player disconnects.
    gTrashman_HOLDINGTRASH[playerid]=0;
    gTrashman_PLAYERPICKUP[playerid]=0;
    return 1;
}

//Returns the MAXIMUM trash of the truck

public GetTrashmanVehicleMaxTrash(vehicleid) {
    for(new i=0;i<sizeof(gTrashman_VEHICLES);i++) {
        if(gTrashman_VEHICLES[i][TRASHMANVEHICLE_VEHICLEID]==vehicleid) {
            return gTrashman_VEHICLES[i][TRASHMANVEHICLE_MAXTRASH];
        }
    }
    return -2;
}

//Retruns the CURRENT trash of the truck

public GetTrashmanVehicleTrash(vehicleid) {
    for(new i=0;i<sizeof(gTrashman_VEHICLES);i++) {
        if(gTrashman_VEHICLES[i][TRASHMANVEHICLE_VEHICLEID]==vehicleid) {
            return gTrashman_VEHICLES[i][TRASHMANVEHICLE_CURRENTTRASH];
        }
    }
    return -1;
}
//Changes the CURRENT trash value of the truck
public SetTrashmanVehicleTrash(vehicleid,amount) {
    for(new i=0;i<sizeof(gTrashman_VEHICLES);i++) {
        if(gTrashman_VEHICLES[i][TRASHMANVEHICLE_VEHICLEID]==vehicleid) {
            gTrashman_VEHICLES[i][TRASHMANVEHICLE_CURRENTTRASH]=amount;
            UpdateTrashmanVehicleLabel(vehicleid);
            return 1;
        }
    }
    return 0;
}
//Updates the truck's label with the latest ram-loaded values
public UpdateTrashmanVehicleLabel(trashmanvehicleid) {
    for(new i=0;i<sizeof(gTrashman_VEHICLES);i++) {
        if(gTrashman_VEHICLES[i][TRASHMANVEHICLE_VEHICLEID]==trashmanvehicleid) {
            new String:text[64];
            format(text,64,"- Camião do Lixo [%d] -\nLixo: %d/%d",i,gTrashman_VEHICLES[i][TRASHMANVEHICLE_CURRENTTRASH],gTrashman_VEHICLES[i][TRASHMANVEHICLE_MAXTRASH]);
            UpdateDynamic3DTextLabelText(gTrashman_VEHICLES[i][TRASHMANVEHICLE_TEXT],-1,text);
            return 1;
        }
    }
}

//Self-Explainatory
public IsTrashmanHoldingTrash(playerid) {
    return gTrashman_HOLDINGTRASH[playerid];
}
//Returns the last valid trashman vehicle player has been on
forward GetPlayerLastTrashmanVehicle(playerid);
public GetPlayerLastTrashmanVehicle(playerid) {
    return gTrashman_LASTPLAYERVEHICLE[playerid];
}

//Checks if given vehicleid is a valid trashman vehicle
public IsValidTrashmanVehicle(vehicleid) {
    if(!vehicleid) return 0;
    for(new i=0;i<sizeof(gTrashman_VEHICLES);i++) {
        if(gTrashman_VEHICLES[i][TRASHMANVEHICLE_VEHICLEID]==vehicleid) return 1;
        }
    printf("veiculo invalido");
    return 0;
}
// Checks if job of player is trashman
//Uses the JOBLIST enum (declared in jobs.pwn)
public IsPlayerTrashman(playerid) {
    if (gPlayerJobs[playerid]==JOBLIST_TRASHMAN)return 1;
    else return 0;
}

