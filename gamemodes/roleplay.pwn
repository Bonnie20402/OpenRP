// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT
#define LASTEST_UPDATE "08/03/2023"
#define VERSION "0.0.1"
#define AMX_OLD_CALL
#include <a_samp>
#include <fixes>
#include <VehiclePartPosition>
#include <a_mysql>
#include <sscanf2>
#include <progress2>
#include <bcrypt>
#include <streamer>
#include <crashdetect>
#include "modulos\util\colors.inc" 
#include "modulos\util\uteis.pwn"
#include "modulos\util\msg.pwn"
#include <YSI_Visual\y_commands>

/*
	First-time variables
*/
new MySQL:mysql;
//TODO: Mover todas as globais para headers!
/*
	HEADERS
				*/
#include "modulos\admins\headers2.pwn"
#include "modulos\gps\headers3.pwn"
#include "modulos\login\headers4.pwn"
#include "modulos\locations\headers5.pwn"
#include "modulos\players\headers6.pwn"
#include "modulos\vehicles\headers7.pwn"
#include "modulos\infocmds\headers8.pwn"
#include "modulos\players\bank\headers9.pwn"
#include "modulos\jobs\headers10.pwn"
#include "modulos\jobs\trashman\headers10a.pwn"
#include "modulos\companies\headers11.pwn"

/*
	LOGIN
	*/
	
#include "modulos\login\loading.pwn"
/*
	PLAYER
			*/
#include "modulos\infocmds\creditos.pwn"
#include "modulos\players\playerinfo.pwn"
#include "modulos\players\playerspawn.pwn"
#include "modulos\players\bank\playerbank.pwn"


/*
LOCATIONS
*/
#include "modulos\locations\locations.pwn"
#include "modulos\companies\companies.pwn"
/*
	gps
			*/
#include "modulos\gps\gps.pwn"
/*
	admin
				*/
#include "modulos\admins\admins.pwn"

/*
	vehicles
			*/
#include "modulos\vehicles\vehicles.pwn"

/*
	jobs
				*/
#include "modulos\jobs\jobs.pwn"

main() {
	return 1;
 }
public OnGameModeInit()
{
	ShowPlayerMarkers(0);
	DisableInteriorEnterExits();
	ManualVehicleEngineAndLights();
	UsePlayerPedAnims();
	SendRconCommand("hostname Open SXurce RP!");
	SendRconCommand("maxplayers 100");
	SendRconCommand("language PT");
	SendRconCommand("mode RPG");
	dbInit();
	return 1;
}

forward dbInit();
public dbInit() {
	/*
	// TODO tablea contas em ingles
			LIGAÇÃO Á DB
						*/
	print("[roleplay.pwn] Connecting to MYSQL...");
	new MySQLOpt:option_id=mysql_init_options();
	mysql_set_option(option_id,AUTO_RECONNECT,true);
	mysql=mysql_connect("localhost","root","","openrp",option_id);
	if(mysql_errno(mysql)) {
		print("[roleplay.pwn] Error connecting- server won't work propely!");
		SendRconCommand("stop");
	}
	else print("[roleplay.pwn] Connected to database OpenRP.");

	PrepareAccountsTable();
	PrepareLocationsTable();
	PrepareLocationPickupsTable(); // BEWARE! This module depends on PrepareLocationsTable, load it first!
	PrepareCitizenVehiclesTable();
	PreparePlayerInfoTable();
	PreparePlayerBankAccountsTable();
	PrepareBankAtmTable(); // the props that open bank account dialog
	PrepareCompaniesTable();

	JobsInit();
	return 1;
}
public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	/*
	 Moved to here in order to make sure all hooks of OnPlayerDisconnect that need the player to be authenticated go through
	*/
	gLoggedIn[playerid]=0; 
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
