#include <YSI_Coding\y_hooks>
public PrepareBankAtmTable() {
    new query[255];
    mysql_format(mysql,query,255,"CREATE TABLE IF NOT EXISTS bankatm (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,x FLOAT,y FLOAT,z FLOAT,rx FLOAT,ry FLOAT,rz FLOAT);");
    mysql_query(mysql,query,false);
    PrepareLoadBankAtm();
}

public PrepareLoadBankAtm() {
    new query[255];
    mysql_format(mysql,query,255,"SELECT * FROM bankatm");
    mysql_pquery(mysql,query,"FinishLoadBankAtm","");
}
public FinishLoadBankAtm() {
    new Float:x,Float:y,Float:z;
    new Float:rX,Float:rY,Float:rZ;
    for(new i=0;i<sizeof(gBankAtm);i++) {
        if(gBankAtm[i][ATMINFO_OBJECTID]) {
            DestroyDynamicObject(gBankAtm[i][ATMINFO_OBJECTID]);
            DestroyDynamic3DTextLabel(gBankAtm[i][ATMINFO_TEXT]);
            gBankAtm[i][ATMINFO_OBJECTID]=0;
            gBankAtm[i][ATMINFO_TEXT]=0;
            gBankAtm[i][ATMINFO_ROWID]=0;
        }
    }
    for(new i=0;i<cache_num_rows();i++) {
        cache_get_value_index_int(i,0,gBankAtm[i][ATMINFO_ROWID]);
        cache_get_value_index_float(i,1,x);
        cache_get_value_index_float(i,2,y);
        cache_get_value_index_float(i,3,z);
        cache_get_value_index_float(i,4,rX);
        cache_get_value_index_float(i,5,rY);
        cache_get_value_index_float(i,6,rZ);
        gBankAtm[i][ATMINFO_COORDS][0]=x;
        gBankAtm[i][ATMINFO_COORDS][1]=y;
        gBankAtm[i][ATMINFO_COORDS][2]=z;
        gBankAtm[i][Int:ATMINFO_OBJECTID]=CreateDynamicObject(19324,x,y,z,rX,rY,rZ);
        new String:text[64];
        format(text,64,"- ATM [%d] -\nAperte Y para usar",gBankAtm[i][ATMINFO_ROWID]);
        gBankAtm[i][ATMINFO_TEXT]=CreateDynamic3DTextLabel(text,-1,x,y,z,25);
    }
    if(!cache_num_rows())print("[bankatm.pwn] No ATMS loaded.");
    else printf("[bankatm.pwn] %d atms have been loaded",cache_num_rows());
    return 1;
}

public PrepareAddBankAtm(Float:x,Float:y,Float:z,Float:rX,Float:rY,Float:rZ) {
    new query[255];
    mysql_format(mysql,query,255,"INSERT INTO bankatm (x, y, z, rx, ry, rz) VALUES (%f, %f, %f, %f, %f, %f)",x,y,z,rX,rY,rZ);
    mysql_pquery(mysql,query,"FinishAddBankAtm","");
    print(query);
    return 1;
}
public FinishAddBankAtm() {
    print("[bankatm.pwn] A new ATM has been created");
    PrepareLoadBankAtm();
    return 1;
}

public PrepareRemoveBankAtm(rowid) {
    new query[255];
    mysql_format(mysql,query,255,"DELETE FROM bankatm WHERE id = %d;",rowid);
    mysql_pquery(mysql,query,"FinishRemoveBankAtm","i",rowid);
    return 1;
}

public FinishRemoveBankAtm(rowid) {
    printf("[bankatm.pwn] The AMT ID %d has been deleted",rowid);
    PrepareLoadBankAtm();
    return 1;
}

public IsValidBankAtm(objectid) {
    if(gBankAtm[objectid][ATMINFO_ROWID]) return 1;
    return 0;
}

public GetBankAtmCoordsPointers(objectid,&Float:x,&Float:y,&Float:z) {
    if(IsValidBankAtm(objectid)) {
        x=gBankAtm[objectid][ATMINFO_COORDS][0];
        y=gBankAtm[objectid][ATMINFO_COORDS][1];
        z=gBankAtm[objectid][ATMINFO_COORDS][2];
        return 1;
    }
    return 0;
}

hook OnPlayerKeyStateChange(playerid,newkeys,oldkeys) {
    if(PRESSED(KEY_YES)) {
        for(new i=0;i<sizeof(gBankAtm);i++) {
            if(IsValidBankAtm(i)) {
                new Float:x,Float:y,Float:z,Float:dist;
                GetBankAtmCoordsPointers(i,x,y,z);
                dist=GetPlayerDistanceFromPoint(playerid,x,y,z);
                if(dist<2) {
                    ShowPlayerBankAccountMenu(playerid,8001); // TODO preparar headers e mudar para PLAYERDIALOGBANK MAIN ver ficheiro ajustar y-coord ao criar um atm
                    return 1;
                }
                else continue;
            }
        }
    }
    return 1;
}