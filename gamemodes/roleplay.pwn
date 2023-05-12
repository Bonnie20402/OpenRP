
#pragma compat 1
#pragma naked
#pragma warning disable 200
#pragma warning disable 201
#pragma warning disable 202
#pragma warning disable 203
#pragma warning disable 204
#pragma warning disable 205
#pragma warning disable 206
#pragma warning disable 207
#pragma warning disable 208
#pragma warning disable 209
#pragma warning disable 210
#pragma warning disable 211
#pragma warning disable 212
#pragma warning disable 213
#pragma warning disable 214
#pragma warning disable 215

#define CGEN_MEMORY 60000



#define DATE "02/04/2023"
#define VERSION "0.0.2c"
#define AMX_OLD_CALL
#include <a_samp>
#include <fixes>
#include <VehiclePartPosition>
#include <a_mysql>
#include <sscanf2>
#include <progress2>
#include <bcrypt>
#include <samp-precise-timers>
#include <streamer>
#include <weapon-config.inc>
#include <crashdetect>
//WARN if YSK gives error function different from prototype, just comment that function out.
#include <YSF>
#include <YSI_Visual\y_commands>
#include <YSI_Visual/y_dialog>
#include <YSI_Coding/y_inline>
#include <YSI_Extra/y_inline_mysql>


#include "modulos\util\datetime.inc"
#include "modulos\util\colors.inc" 
#include "modulos\util\uteis.pwn"
#include "modulos\util\msg.pwn"
#include "modulos\util\animbrowse.pwn"

/*
	First-time variables
*/
new MySQL:mysql;
/*
	HEADERS
				*/
#include "modulos\admins\headers2.pwn"
#include "modulos\admins\helprequests\headers2a.pwn"
#include "modulos\players\gps\headers3.pwn"
#include "modulos\players\login\headers4.pwn"
#include "modulos\locations\headers5.pwn"
#include "modulos\players\headers6.pwn"
#include "modulos\vehicles\headers7.pwn"
#include "modulos\players\cmds\headers8.pwn"
#include "modulos\players\bank\headers9.pwn"
#include "modulos\jobs\headers10.pwn"
#include "modulos\jobs\trashman\headers10a.pwn"
#include "modulos\companies\headers11.pwn"
#include "modulos\players\inventory\headers13.pwn"
#include "modulos\players\payday\headers14.pwn"

/*
	Textdraws
					*/
#include "modulos\txd\txdprogress.pwn"
#include "modulos\txd\txdbnotification.pwn"
#include "modulos\txd\txdloading.pwn"
#include "modulos\txd\txdinvdrop.pwn"

/*
	LOGIN
	*/
	
#include "modulos\players\login\loading.pwn"
/*
	PLAYER
			*/
#include "modulos\players\cmds\cmds.pwn"
#include "modulos\players\chat.pwn"
#include "modulos\players\playerinfo.pwn"
#include "modulos\players\playerspawn.pwn"
#include "modulos\players\bank\playerbank.pwn"
#include "modulos\players\inventory\inventory.pwn"
#include "modulos\players\gps\gps.pwn"
#include "modulos\players\payday\payday.pwn"


/*
Companies/Locations
*/
#include "modulos\locations\locations.pwn"
#include "modulos\companies\companies.pwn"
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
	PrepareCitizenVehiclesTable(); // TO BE REPLACED loads citize nvehicles at spawn
	PreparePlayerInfoTable(); // contains player coords (xyz) health skinid and armor.
	PreparePlayerBankAccountsTable(); // player bank account table
	PreparePlayerLevelTable(); // prepares level respect table stuff
	PrepareBankAtmTable(); // the props that open bank account dialog
	PrepareCompaniesTable(); // Loads companies

	JobsInit();
	PlayerInvDropInit();
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
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
	return 1;
}
/*
    Custom callbacks
                            */
