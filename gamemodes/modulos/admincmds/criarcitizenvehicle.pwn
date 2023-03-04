YCMD:criarcitizenvehicle(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=3000) {
        new Float:x,Float:y,Float:z;
        GetPlayerPos(playerid,x,y,z);
        SendStaffMessage(-1,"Veiculo citizen adicionado!");
        PrepareAddCitizenVehicle(462,1,1,x,y,z);
        return 1;
    }
    return 1;
}