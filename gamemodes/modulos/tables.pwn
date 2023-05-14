

stock LoadPlayerTables(playerid) {
    PrepareLoadPlayerBankAccount(playerid);
    PrepareLoadPlayerInfo(playerid);
    PrepareLoadPlayerInventory(playerid);
    PrepareLoadPlayerLevel(playerid);
    PrepareLoadPlayerPaydayTimer(playerid);
	printf("[tables.pwn] All player tables have ben called to load for %s[%d]",GetPlayerNameEx(playerid),playerid);
}

stock LoadServerTables() {
	PrepareAccountsTable();
	PrepareLocationsTable(); // Deprecated
	PrepareLocationPickupsTable(); // Deprecated 
	PrepareCitizenVehiclesTable(); // Deprecated 
	PreparePlayerInfoTable(); // Deprecated 
	PrepareAdminsTable();
	PreparePlayerBankAccountsTable(); // Player bank accounts table creation.
	PreparePlayerLevelTable(); // Player level,respect,hoursplayed  table creation.
	PreparePlayerPaydayTimerTable();
	PrepareBankAtmTable(); // ATM locations table creation and loading.
	PrepareCompaniesTable(); // Companies table creation and loading.

	printf("[tables.pwn] All server tables have been called to load.");
}