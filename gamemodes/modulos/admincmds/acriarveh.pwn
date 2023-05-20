#include <YSI_Coding\y_hooks>

static gCreatingVehicle[MAX_PLAYERS][VEHICLEINFO];

hook OnPlayerConnect(playerid) {
    gCreatingVehicle[playerid][VEHICLEINFO_MODELID]=0;
    return 1;
}
YCMD:acriarveh(playerid,params[],help) {
    //TODO adjust the angle its not working idk why fuck this shit
    if(GetStaffLevel(playerid)) {
        new modelid;
        sscanf(params,"i",modelid);
        gCreatingVehicle[playerid][VEHICLEINFO_MODELID]=modelid;
        new Float:x,Float:y,Float:z;
        GetPlayerPos(playerid,x,y,z);
        new tempveh = AddStaticVehicle(modelid,x,y,z,0.0,1,1);
        PutPlayerInVehicle(playerid,tempveh,0);
        SetVehicleFuel(tempveh,100);
        SendClientMessage(playerid,COLOR_AQUA,"Conduz o carro até ao ponto de estacionamento e sai do carro.");
    }
    return 1;
}



hook OnPlayerExitVehicle(playerid, vehicleid) {
    if(gCreatingVehicle[playerid][VEHICLEINFO_MODELID]) {
        new modelid = GetVehicleModel(vehicleid);
        new Float:x,Float:y,Float:z,Float:angle=0.0;
        GetVehiclePos(vehicleid,x,y,z);
        inline CreateVehicleConfirm(responseH,listitemH,String:inputtextH) {
            #pragma unused listitemH,inputtextH
            PrepareAddVehicle(modelid,x,y,z,angle,gCreatingVehicle[playerid][VEHICLEINFO_COLOR1],\
            gCreatingVehicle[playerid][VEHICLEINFO_COLOR2],gCreatingVehicle[playerid][VEHICLEINFO_FLAG_RESPAWN],\
            gCreatingVehicle[playerid][VEHICLEINFO_RESPAWNTIME],\
            gCreatingVehicle[playerid][VEHICLEINFO_FLAG_PUBLIC],gCreatingVehicle[playerid][VEHICLEINFO_OWNERTYPE],\
            gCreatingVehicle[playerid][VEHICLEINFO_OWNERID]);
            SendClientMessage(playerid,COLOR_AQUA,"Veiculo criado!");
            PrepareLoadVehicles();
            gCreatingVehicle[playerid][VEHICLEINFO_MODELID]=0;
            DestroyVehicle(vehicleid);
        }
        inline OwnerSet(responseG,listitemG,String:inputtextG[]) {
            #pragma unused listitemG
            gCreatingVehicle[playerid][VEHICLEINFO_OWNERID]=strval(StinputtextG);
            new dialogBody[512];
            format(dialogBody,512,\
            "atributo\tvalor\n\
            modelid\t%d\n\
            XYZ\t %.2f %.2f %.2f\n\
            angulo\t%.2f\n\
            color1\t%d\n\
            color2\t%d\n\
            FLAG_RESPAWN\t%d\n\
            respawntime\t%d\n\
            FLAG_PUBLIC\t%d\n\
            ownertype\t%d\n\
            ownerid\t%d",\
            modelid,x,y,z,angle,gCreatingVehicle[playerid][VEHICLEINFO_COLOR1],gCreatingVehicle[playerid][VEHICLEINFO_COLOR2],\
            gCreatingVehicle[playerid][VEHICLEINFO_FLAG_RESPAWN],gCreatingVehicle[playerid][VEHICLEINFO_RESPAWNTIME],gCreatingVehicle[playerid][VEHICLEINFO_FLAG_PUBLIC],\
            gCreatingVehicle[playerid][VEHICLEINFO_OWNERTYPE],gCreatingVehicle[playerid][VEHICLEINFO_OWNERID]);
            Dialog_ShowCallback(playerid,using inline CreateVehicleConfirm,DIALOG_STYLE_TABLIST_HEADERS,"Confirmar",dialogBody,"Sim","Não");
        }
        inline OwnerTypeSet(responseF,listitemF,String:inputtextF[]) {
            #pragma unused StinputtextF
            gCreatingVehicle[playerid][VEHICLEINFO_OWNERTYPE]=listitemF;
            Dialog_ShowCallback(playerid,using inline OwnerSet,DIALOG_STYLE_INPUT,"ID OWNER","Escreve o owner id","OK","Cancelar");
        }
        inline FlagPublicSet(responseE,listitemE,String:inputtextE[]) {
            #pragma unused listitemE,StinputtextE
            gCreatingVehicle[playerid][VEHICLEINFO_FLAG_PUBLIC]=responseE;
            //warn  the list should be in the same order as the ownertype enum so eaiser to know yay thanks.
            Dialog_ShowCallback(playerid,using inline OwnerTypeSet,DIALOG_STYLE_LIST,"Tipo de owner","OWNERTYPE_PLAYER\nOWNERTYPE_JOB\nOWNERTYPE_ADMIN\nOWNERTYPE_ORG","OK","Cancelar");
        }
        inline RespawnTimeSet(responseD,listitemD,String:inputtextD[]) {
            #pragma unused listitemD
            gCreatingVehicle[playerid][VEHICLEINFO_RESPAWNTIME]=strval(StinputtextD);
            Dialog_ShowCallback(playerid,using inline FlagPublicSet,DIALOG_STYLE_MSGBOX,"Criar veiculo","Veiculo é publico?\nSe sim, ownertype e owner serão ignorados.","Sim","Não");
        }
        inline FlagRespawnSet(responseC,listitemC,String:inputtextC[]) {
            #pragma unused listitemC,StinputtextC
            gCreatingVehicle[playerid][VEHICLEINFO_FLAG_RESPAWN]=responseC; // Response can only be 0 or 1, 0 for no 1 for yes so... yeah
            Dialog_ShowCallback(playerid,using inline RespawnTimeSet,DIALOG_STYLE_INPUT,"Criar veiculo","Tempo de respawn, em segundos\nSe não for com respawn, coloque 0 ou nada.","OK","Cancelar");
        }
        inline Color2Set(responseB,listitemB,String:inputtextB[]) {
            #pragma unused listitemB
            gCreatingVehicle[playerid][VEHICLEINFO_COLOR2]=strval(StinputtextB);
            Dialog_ShowCallback(playerid,using inline FlagRespawnSet,DIALOG_STYLE_MSGBOX,"Criar veiculo","Veiculo com respawn?","Sim","Não");
        }
        inline Color1Set(responseA,listitemA,String:inputtextA[]) {
            #pragma unused listitemA
            gCreatingVehicle[playerid][VEHICLEINFO_COLOR1]=strval(StinputtextA);
            Dialog_ShowCallback(playerid,using inline Color2Set,DIALOG_STYLE_INPUT,"Criar veiculo","Introduz o valor da cor 2","OK","Cancelar");
        }
        Dialog_ShowCallback(playerid,using inline Color1Set,DIALOG_STYLE_INPUT,"Criando veiculo","Introduz o valor da cor 1","OK","Cancelar");
        return 1;
    }
    
}
