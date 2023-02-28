// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT
#define AMX_OLD_CALL
#include <a_samp>
#include <YSI_Visual/y_commands>
#include <a_mysql>
#include <sscanf2>
#include <bcrypt>
#include "modulos/util/colors.inc" 
#include "modulos/util/uteis.pwn"

/*
	VARIAVEIS GLOBAIS
*/
new MySQL:mysql; 

/*gi
	LOGIN
	*/
#include "modulos/login/login.pwn"

/*
	SPAWN
	*/
#include "modulos/spawn/playerspawn.pwn"

/*
GPS
*/
#include "modulos/locations/locations.pwn"
/*
	admin
				*/
#include "modulos/admins/admins.pwn"

main() {
	return 1;
 }
public OnGameModeInit()
{
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
			LIGAÇÃO Á DB
						*/
	print("A ligar á DB...");
	new MySQLOpt:option_id=mysql_init_options();
	mysql_set_option(option_id,AUTO_RECONNECT,true);
	mysql=mysql_connect("localhost","root","","openrp",option_id);
	if(mysql_errno(mysql)) {
		print("[LOGIN] Erro ao ligar á db!");
		SendRconCommand("stop");
	}
	else print("Ligado á DB - Tabela: OpenRP");
	    	/*
		CRIAÇÃO DE TABELAS
						*/
	new TabelaAccounts[128];
	mysql_format(mysql,TabelaAccounts,128,"CREATE TABLE IF NOT EXISTS ACCOUNTS (account_id INT(11) PRIMARY KEY NOT NULL,username VARCHAR(32),password VARCHAR(256))");
	mysql_query(mysql,TabelaAccounts,false);

	/*
		Tabela init
				*/
	PrepareLocationsTable();
}
forward SQL:getInstance();
public SQL:getInstance() {
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
