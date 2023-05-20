enum COMPANY {
    String:COMPANY_OWNER[64],
    String:COMPANY_COOWNER[64],
    String:COMPANY_NAME[64],
    String:COMPANY_DESCRIPTION[64],
    Int:COMPANY_ROWID, // Company ID
    Int:COMPANY_INTERIORID, // should be 0 if it has no interior.
    Int:COMPANY_CASH, // holds company cash
    Int:COMPANY_ENTRANCEFEE, // The fee players have to pay to get in
    Float:COMPANY_EXTCOORDS[3],
    Float:COMPANY_INTCOORDS[3],
    Text3D:COMPANY_EXTTEXT,
    Text3D:COMPANY_INTTEXT,
    Int:COMPANY_EXTPICKUPID,
    Int:COMPANY_INTPICKUPID,
    Int:COMPANY_MAPICON,
    Int:COMPANY_ICONID
    //TODO Players level below 3 should pay no fee.
}

#define DONO_NULL "Ninguém"
#define COMAPNYBASEPRICE 5000
new gCompanies[250][COMPANY];

forward PrepareCompaniesTable();
forward PrepareLoadCompanies();
forward FinishLoadCompanies();
forward PrepareAddCompany(const name[],interiorid,mapicon,Float:ix,Float:iy,Float:iz,Float:x,Float:y,Float:z) ;
forward FinishAddQuery();
forward PrepareRemoveCompany(rowid);
forward FinishRemoveCompany(rowid);
forward IsValidCompany(rowid);
forward CreateCompanyMapIcons();
forward GetCompanyExtLocationPtrs(rowid,&Float:x,&Float:y,&Float:z);
forward GetPlayerNearestCompanyPointers(playerid,&rowid,&Float:distance);
forward GetCompanyIntLocationPtrs(rowid,&Float:x,&Float:y,&Float:z);
forward GetCompanyInteriorId(rowid);
forward GetCompanyIdFromName(const name[]);