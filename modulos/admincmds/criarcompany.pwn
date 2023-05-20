#include <YSI_Coding\y_hooks>
#define COMPANYDIALOG_CREATING0 500
#define COMPANYDIALOG_CREATING1 501
#define COMPANYDIALOG_INTERIOR0 518
#define COMPANYDIALOG_INTERIOR1 519
#define COMPANYDIALOG_INTERIOR2 520
#define COMPANYDIALOG_INTERIOR3 521
#define COMPANYDIALOG_INTERIOR4 555
#define COMPANYDIALOG_INTERIOR5 522
#define COMPANYDIALOG_INTERIOR6 523
#define COMPANYDIALOG_INTERIOR7 524
#define COMPANYDIALOG_INTERIOR8 600
#define COMPANYDIALOG_INTERIOR9 601
#define COMPANYDIALOG_INTERIOR10 602
#define COMPANYDIALOG_INTERIOR11 603
#define COMPANYDIALOG_INTERIOR12 604
#define COMPANYDIALOG_INTERIOR13 605
#define COMPANYDIALOG_INTERIOR14 606
#define COMPANYDIALOG_INTERIOR15 607
#define COMPANYDIALOG_INTERIOR16 608
#define COMPANYDIALOG_INTERIOR17 609
#define COMPANYDIALOG_INTERIOR18 610

enum COMPANYCREATOR {
    COMPANYCREATOR_CREATING,
    COMPANYCREATOR_MAPICON,
    String:COMPANYCREATOR_NAME[1024]
}
new gCreatingCompany[MAX_PLAYERS][COMPANYCREATOR];
new const interiorIds[] = {0,1,3,5,6,7,8,9,10,11,12,13,14,15,16,17,18};
YCMD:criarcompany(playerid,params[],help) {
    if(GetStaffLevel(playerid)>=5000) {
        new String:companyName[1024],mapicon;
        if(!sscanf(params,"is[1024]",gCreatingCompany[playerid][COMPANYCREATOR_MAPICON],gCreatingCompany[playerid][COMPANYCREATOR_NAME])) {
            gCreatingCompany[playerid][COMPANYCREATOR_CREATING]=1;
            SendStaffMessage(-1,"Um programador está a criar uma nova Company");
            ShowPlayerDialog(playerid,COMPANYDIALOG_CREATING0,DIALOG_STYLE_MSGBOX,"Company Criador","A empresa tem interior?","Sim","Não");
        }
    }
    return 1;
}

hook OnDialogResponse(playerid,dialogid,response,listitem,inputtext[]) {
    if(!gCreatingCompany[playerid][COMPANYCREATOR_CREATING]) return 1;
    new Float:pX,Float:pY,Float:pZ;
    GetPlayerPos(playerid,pX,pY,pZ);
    if(dialogid==COMPANYDIALOG_CREATING0) {
        if(!response) {
            gCreatingCompany[playerid][COMPANYCREATOR_CREATING]=0;
            new Float:x,Float:y,Float:z;
            GetPlayerPos(playerid,x,y,z);
            PrepareAddCompany(gCreatingCompany[playerid][COMPANYCREATOR_NAME],0,gCreatingCompany[playerid][COMPANYCREATOR_MAPICON],x,y,z,x,y,z);
            return 1;
        }
        else {
            ShowPlayerDialog(playerid,COMPANYDIALOG_CREATING1,DIALOG_STYLE_INPUT,"ID interior","Indica o interior ID","Proximo","Cancelar");
            return 1;
        }
    }
    if(dialogid==COMPANYDIALOG_CREATING1) {
        if(response) {
            new Int:interiorid;
            sscanf(inputtext,"i",interiorid);
            if(interiorid||!interiorid) {
                if(interiorid==0)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR0,DIALOG_STYLE_LIST,"Escolher interior","Bank\nDillimore Gas Station","Escolher","Cancelar");
                if(interiorid==1)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR1,DIALOG_STYLE_LIST,"Escolher interior","Ammu-Nation 1\nBulgary House 1\nThe Welcome Pump\nRestaurant 1\nCaligulas Casino\nDenise Place\nShamal Cabin\nLiberty City\nSweet's house\nTransfender\nSafe House 4\nTrials Stadium\nWarehouse 1 \nDoherty Garage\nSindacco Abatoir\nSuburban\nWu Zi Mu Betting place","Escolher","Cancelar");
                if(interiorid==2)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR2,DIALOG_STYLE_LIST,"Escolher interior","Ryder's House\nAngel Pine Trailer\nThe Pig Pen\nBDUPS Crack apalace\nBig smoke crack palace\nBurglary House 2\nBulgary house 3\nBulgary House 4\nKatie's place\nLoco low co.\nReece's Barbershop","Escolher","Cancelar");
                if(interiorid==3)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR3,DIALOG_STYLE_LIST,"Escolher interior","Jizzy's Pleasure Domes\nBrothel\nBrothel 2\nBDups Apartment\nBike School\nBig Spread Ranch\nLV Tattoo Parlour\nLVPD HQ\nOG Loc's House\nPro-Laps\nLas Venturas Planning Dep.\nRecord Label Hallway\nDriving School\nJohnson House\nBurglary House 5\nGay Gordo's Barbershop\nHelena's Place\nInside Track Betting\nSex Shop\nWheel Arch Angels","Escolher","Cancelar");
                if(interiorid==4)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR4,DIALOG_STYLE_LIST,"Escolher interior","24/7 shop I\nAmmu-Nation 2\nBurglary House 6\nBurglary House 7\nBurglary House 8\nDiner 2\nDirtbike Stadium\nMichelle's Place","Escolher","Cancelar");
                if(interiorid==5)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR5,DIALOG_STYLE_LIST,"Escolher Interior","Madd Dogg's Mansion\nWell Stacked Pizza Co.\nVictim\nBurning Desire House\nBarbara's Place\nBurglary House 9\nBurglary House 10\nBurglary House II\nThe Crack Den\nPolice Station (Barbara's)\nDiner I\nGanton Gym\nVank Hoff Hotel","Escolher","Cancelar");
                if(interiorid==6)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR6,DIALOG_STYLE_LIST,"Escolher Interior","Ammu-Nation 3\nAmmu-Nation 4\nLSPD HQ\nSafe House 3\nSafe House 5\nSafe House 6\nCobra Marital Arts Gym\n24/7 shop 2\nMillie's Bedroom\nFanny Batter's Brothel\nRestaurant 2\nBurglary House 15\nBurglary House 16","Escolher","Cancelar");
                if(interiorid==7)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR7, DIALOG_STYLE_LIST, "Escolher Interior", "Ammu-Nation 5 (2 Floors)\n8-Track Stadium\nBelow the Belt Gym", "Escolher", "Cancelar");
                if(interiorid==8)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR8, DIALOG_STYLE_LIST, "Escolher Interior", "Safe house 2\nColonel Fuhrberger's House\nBurglary House 22", "Escolher", "Cancelar");
                if(interiorid==9)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR9, DIALOG_STYLE_LIST, "Escolher Interior", "Unknown safe house\nAndromada Cargo hold\nBurglary House 12\nBurglary House 13\nCluckin' Bell", "Escolher", "Cancelar");
                if(interiorid==10)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR10, DIALOG_STYLE_LIST, "Escolher Interior", "Four Dragons Casino\nRC Zero's Battlefield\nBurger Shot\nBurglary House 14\nJanitor room(Four Dragons Maintena\nSafe House I\nHashbury safe house\n24/7 shop 3\nAbandoned AC Tower\nSFPD HQ", "Escolher", "Cancelar");
                if(interiorid==11)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR11, DIALOG_STYLE_LIST, "Escolher Interior", "The Four Dragons Office\nLos Santos safe house\nTen Green Bottles Bar", "Escolher", "Cancelar");
                if(interiorid==12)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR12, DIALOG_STYLE_LIST, "Escolher Interior", "Budget Inn Motel Room\nThe Casino\nMacisla's Barbershop\nSafe house 7\nModem safe house", "Escolher", "Cancelar");
                if(interiorid==13)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR13, DIALOG_STYLE_LIST, "Escolher Interior", "LS Atrium\nCJ's Garage", "Escolher", "Cancelar");
                if(interiorid==14)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR14, DIALOG_STYLE_LIST, "Escolher Interior", "Kickstart Stadium\nDidier Sachs\nFrancis Int. Airport (Front ext.)\nFrancis Int. Airport (Baggage Claim/Ticket Sales)\nWardrobe", "Escolher", "Cancelar");
                if(interiorid==15)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR15, DIALOG_STYLE_LIST, "Escolher Interior", "Binco\nBlood Bowl Stadium\nJefferson Motel\nBurglary House 17\nBurglary House 18\nBurglary House 19\nBurglary House 20\nBurglary House 21", "Escolher", "Cancelar");
                if(interiorid==16)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR16, DIALOG_STYLE_LIST, "Escolher Interior", "24/7 shop 4\nLS Tattoo Parlour\nSumoring? stadium", "Escolher", "Cancelar");
                if(interiorid==17)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR17, DIALOG_STYLE_LIST, "Escolher Interior", "24/7 shop 5\nClub\nRusty Brown's - Ring Donuts\nThe Sherman's Dam Generator Hall\nHemlock Tattoo", "Escolher", "Cancelar");
                if(interiorid==18)ShowPlayerDialog(playerid,COMPANYDIALOG_INTERIOR18, DIALOG_STYLE_LIST, "Escolher Interior", "Lil Probe Inn\n24/7 shop 6\nAtrium\nWarehouse 2\nZip", "Escolher", "Cancelar");
            }
        }
    }
    new Float:x,Float:y,Float:z;
    if(dialogid==COMPANYDIALOG_INTERIOR1) {
        if(listitem==0) { // Ammu-nation 1
            x=289.7870;
            y=-35.7190;
            z=1003.5160;
        }
        if(listitem==1) { // Burglary House 1
            x=224.6351;
            y=1289.012;
            z=1082.141;
        }
        if(listitem==2) { // The Wellcome Pump (Catalina?)
            x=681.65;
            y=-452.86;
            z=-25.62;
        }
        if(listitem==3) { // Restaurant 1
            x=446.6941;
            y=-9.7977;
            z=1000.7340;
        }
        if(listitem==4) { // Caligulas Casino
            x=2235.2524;
            y=1708.5146;
            z=1010.6129;
        }
        if(listitem==5) { // Denise's Place
            x=244.0892;
            y=304.8456;
            z=999.1484;
        }
        if(listitem==6) { // Shamal cabin
            x=1.6127;
            y=34.7411;
            z=1199.0;
        }
        if(listitem==7) { // Liberty City
            x=-750.80;
            y=491.00;
            z=1371.70;
        }
        if(listitem==8) { // Sweet's House
            x=2525.0420;
            y=-1679.1150;
            z=1015.4990;
        }
        if(listitem==9) { // Transfender
            x=621.7850;
            y=-12.5417;
            z=1000.9220;
        }
        if(listitem==10) { // Safe House 4
            x=2216.5400;
            y=-1076.2900;
            z=1050.4840;
        }
        if(listitem==11) { // Trials(Hyman Memorial?) Stadium
            x=-1401.13;
            y=106.110;
            z=1032.273;
        }
        if(listitem==12) { // Warehouse 1
            x=1405.3120;
            y=-8.2928;
            z=1000.9130;
        }
        if(listitem==13) { // Doherty Garage
            x=-2042.42;
            y=178.59;
            z=28.84;
        }
        if(listitem==14) { // Sindacco Abatoir
            x=963.6078;
            y=2108.3970;
            z=1011.0300;
        }
        if(listitem==15) { // Sub Urban
            x=203.8173;
            y=-46.5385;
            z=1001.8050;
        }
        if(listitem==16) { // Wu Zi Mu's Betting place
            x=-2159.9260;
            y=641.4587;
            z=1052.3820;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR2) {
        if(listitem == 0) { // Ryder's House
            x = 2464.2110;
            y = -1697.9520;
            z = 1013.5080;
        }
        if(listitem == 1) { // Angel Pine Trailer
            x = 0.3440;
            y = -0.5140;
            z = 1000.5490;
        }
        if(listitem == 2) { // The Pig Pen
            x = 1213.4330;
            y = -6.6830;
            z = 1000.9220;
        }
        if(listitem == 3) { // BDups Crack Palace
            x = 1523.7510;
            y = -46.0458;
            z = 1002.1310;
        }
        if(listitem == 4) { // Big Smoke's Crack Palace
            x = 2543.6610;
            y = -1303.9320;
            z = 1025.0700;
        }
        if(listitem == 5) { // Burglary House 2
            x = 225.756;
            y = 1240.000;
            z = 1082.149;
        }
        if(listitem == 6) { // Burglary House 3
            x = 447.470;
            y = 1398.348;
            z = 1084.305;
        }
        if(listitem == 7) { // Burglary House 4
            x = 491.740;
            y = 1400.541;
            z = 1080.265;
        }
        if(listitem == 8) { // Katie's Place
            x = 267.2290;
            y = 304.7100;
            z = 999.1480;
        }
        if(listitem == 9) { // Loco Low Co.
            x = 612.5910;
            y = -75.6370;
            z = 997.9920;
        }
        if(listitem == 10) { // Reece's Barbershop
            x = 411.6259;
            y = -21.4332;
            z = 1001.8046;
        }
    }
    if(dialogid==COMPANYDIALOG_INTERIOR3) {
        if(listitem==0) { // Jizzy's Pleasure Domes
            x=-2636.7190;
            y=1402.9170;
            z=906.4609;
        }
        if(listitem==1) { // Brothel
            x=940.6520;
            y=-18.4860;
            z=1000.9300;
        }
        if(listitem==2) { // Brothel 2
            x=967.5334;
            y=-53.0245;
            z=1001.1250;
        }
        if(listitem==3) { // BDups Apartment
            x=1527.38;
            y=-11.02;
            z=1002.10;
        }
        if(listitem==4) { // Bike School
            x=1494.3350;
            y=1305.6510;
            z=1093.2890;
        }
        if(listitem==5) { // Big Spread Ranch
            x=1210.2570;
            y=-29.2986;
            z=1000.8790;
        }
        if(listitem==6) { // LV Tattoo Parlour
            x=-204.4390;
            y=-43.6520;
            z=1002.2990;
        }
        if(listitem==7) { // LVPD HQ
            x=289.7703;
            y=171.7460;
            z=1007.1790;
        }
        if(listitem==8) { // OG Loc's House
            x=516.8890;
            y=-18.4120;
            z=1001.5650;
        }
        if(listitem==9) { // Pro-Laps
            x=207.3560;
            y=-138.0029;
            z=1003.3130;
        }
        if(listitem==10) { // Las Venturas Planning Dep.
            x=374.6708;
            y=173.8050;
            z=1008.3893;
        }
        if(listitem==11) { // Record Label Hallway
            x=1038.2190;
            y=6.9905;
            z=1001.2840;
        }
        if(listitem==12) { // Driving School
            x=-2027.9200;
            y=-105.1830;
            z=1035.1720;
        }
        if(listitem==13) { // Johnson House
            x=2496.0500;
            y=-1693.9260;
            z=1014.7420;
        }
        if(listitem==14) { // Burglary House 5
            x=234.733;
            y=1190.391;
            z=1080.258;
        }
        if(listitem==15) { // Gay Gordo's Barbershop
            x=418.6530;
            y=-82.6390;
            z=1001.8050;
        }
        if(listitem==16) { // Helena's Place
            x=292.4459;
            y=308.7790;
            z=999.1484;
        }
        if(listitem==17) { // Inside Track Betting
            x=826.8863;
            y=5.5091;
            z=1004.4830;
        }
        if(listitem==18) { // Sex Shop
            x=-106.7268;
            y=-19.6444;
            z=1000.7190;
        }
        if(listitem==19) { // Wheel Arch Angels
            x=614.3889;
            y=-124.0991;
            z=997.9950;
        }
    }
    if(dialogid==COMPANYDIALOG_INTERIOR4) {
        if(listitem==0) { // 24/7 shop 1
            x=-27.3769;
            y=-27.6416;
            z=1003.5570;
        }
        if(listitem==1) { // Ammu-Nation 2
            x=285.8000;
            y=-84.5470;
            z=1001.5390;
        }
        if(listitem==2) { // Burglary House 6
            x=-262.91;
            y=1454.966;
            z=1084.367;
        }
        if(listitem==3) { // Burglary House 7
            x=221.4296;
            y=1142.423;
            z=1082.609;
        }
        if(listitem==4) { // Burglary House 8
            x=261.1168;
            y=1286.519;
            z=1080.258;
        }
        if(listitem==5) { // Diner 2
            x=460.0;
            y=-88.43;
            z=999.62;
        }
        if(listitem==6) { // Dirtbike Stadium
            x=-1435.8690;
            y=-662.2505;
            z=1052.4650;
        }
        if(listitem==7) { // Michelle's Place
            x=302.6404;
            y=304.8048;
            z=999.1484;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR5) {
        if (listitem == 0) { // Madd Dogg's Mansion
            x = 1272.9116;
            y = -768.9028;
            z = 1090.5097;
        }
        if (listitem == 1) { // Well Stacked Pizza Co.
            x = 377.7758;
            y = -126.2766;
            z = 1001.4920;
        }
        if (listitem == 2) { // Victim
            x = 221.3310;
            y = -6.6169;
            z = 1005.1977;
        }
        if (listitem == 3) { // Burning Desire House
            x = 2351.1540;
            y = -1180.5770;
            z = 1027.9770;
        }
        if (listitem == 4) { // Barbara's Place
            x = 322.1979;
            y = 302.4979;
            z = 999.1484;
        }
        if (listitem == 5) { // Burglary House 9
            x = 22.79996;
            y = 1404.642;
            z = 1084.43;
        }
        if (listitem == 6) { // Burglary House 10
            x = 228.9003;
            y = 1114.477;
            z = 1080.992;
        }
        if (listitem == 7) { // Burglary House 11
            x = 140.5631;
            y = 1369.051;
            z = 1083.864;
        }
        if (listitem == 8) { // The Crack Den
            x = 322.1117;
            y = 1119.3270;
            z = 1083.8830;
        }
        if (listitem == 9) { // Police Station (Barbara's)
            x = 322.72;
            y = 306.43;
            z = 999.15;
        }
        if (listitem == 10) { // Diner 1
            x = 448.7435;
            y = -110.0457;
            z = 1000.0772;
        }
        if (listitem == 11) { // Ganton Gym
            x = 768.0793;
            y = 5.8606;
            z = 1000.7160;
        }
        if (listitem == 12) { // Vank Hoff Hotel
            x = 2232.8210;
            y = -1110.0180;
            z = 1050.8830;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR6) {
        if(listitem == 0) { // Ammu-Nation 3
            x = 297.4460;
            y = -109.9680;
            z = 1001.5160;
        }
        if(listitem == 1) { // Ammu-Nation 4
            x = 317.2380;
            y = -168.0520;
            z = 999.5930;
        }
        if(listitem == 2) { // LSPD HQ
            x = 246.4510;
            y = 65.5860;
            z = 1003.6410;
        }
        if(listitem == 3) { // Safe House 3
            x = 2333.0330;
            y = -1073.9600;
            z = 1049.0230;
        }
        if(listitem == 4) { // Safe House 5
            x = 2194.2910;
            y = -1204.0150;
            z = 1049.0230;
        }
        if(listitem == 5) { // Safe House 6
            x = 2308.8710;
            y = -1210.7170;
            z = 1049.0230;
        }
        if(listitem == 6) { // Cobra Marital Arts Gym
            x = 774.0870;
            y = -47.9830;
            z = 1000.5860;
        }
        if(listitem == 7) { // 24/7 shop 2
            x = -26.7180;
            y = -55.9860;
            z = 1003.5470;
        }
        if(listitem == 8) { // Millie's Bedroom
            x = 344.5200;
            y = 304.8210;
            z = 999.1480;
        }
        if(listitem == 9) { // Fanny Batter's Brothel
            x = 744.2710;
            y = 1437.2530;
            z = 1102.7030;
        }
        if(listitem == 10) { // Restaurant 2
            x = 443.9810;
            y = -65.2190;
            z = 1050.0000;
        }
        if(listitem == 11) { // Burglary House 15
            x = 234.319;
            y = 1066.455;
            z = 1084.208;
        }
        if(listitem == 12) { // Burglary House 16
            x = -69.049;
            y = 1354.056;
            z = 1080.211;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR7) {
        if(listitem==0) { // Ammu-Nation 5 (2 Floors)
            x=315.3850;
            y=-142.2420;
            z=999.6010;
        }
        if(listitem==1) { // 8-Track Stadium
            x=-1417.8720;
            y=-276.4260;
            z=1051.1910;
        }
        if(listitem==2) { // Below the Belt Gym
            x=774.2430;
            y=-76.0090;
            z=1000.6540;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR8) {
        if(listitem==0) { // Safe house 2
            x=2365.2383;
            y=-1134.2969;
            z=1050.875;
        }
        if(listitem==1) { // Colonel Fuhrberger's House
            x=2807.8990;
            y=-1172.9210;
            z=1025.5700;
        }
        if(listitem==2) { // Burglary House 22
            x=-42.490;
            y=1407.644;
            z=1084.43;
        }
    }
    if(dialogid==COMPANYDIALOG_INTERIOR9) {
        if(listitem==0) { // Unknown safe house
            x=2253.1740;
            y=-1139.0100;
            z=1050.6330;
        }
        if(listitem==1) { // Andromada Cargo hold
            x=315.48;
            y=-984.13;
            z=1959.11;
        }
        if(listitem==2) { // Burglary House 12
            x=85.32596;
            y=-1323.585;
            z=1083.859;
        }
        if(listitem==3) { // Burglary House 13
            x=260.3189;
            y=-1239.663;
            z=1084.258;
        }
        if(listitem==4) { // Cluckin' Bell
            x=364.7723;
            y=-11.3051;
            z=1001.8516;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR10) { 
        if(listitem==0) { // Four Dragons Casino
            x=2009.4140;
            y=-1017.8990;
            z=994.4680;
        }
        if(listitem==1) { // RC Zero's Battlefield
            x=-975.5766;
            y=1061.1312;
            z=1345.6719;
        }
        if(listitem==2) { // Burger Shot
            x=363.1431;
            y=-74.7714;
            z=1001.5078;
        }
        if(listitem==3) { // Burglary House 14
            x=21.241;
            y=1342.153;
            z=1084.375;
        }
        if(listitem==4) { // Janitor room(Four Dragons Maintenance)
            x=1891.3960;
            y=1018.1260;
            z=31.8820;
        }
        if(listitem==5) { // Safe House 1
            x=2262.83;
            y=-1137.71;
            z=1050.63;
        }
        if(listitem==6) { // Hashbury safe house
            x=2264.5231;
            y=-1210.5229;
            z=1049.0234;
        }
        if(listitem==7) { // 24/7 shop 3
            x=6.0780;
            y=-28.6330;
            z=1003.5490;
        }
        if(listitem==8) { // Abandoned AC Tower
            x=419.6140;
            y=2536.6030;
            z=10.0000;
        }
        if(listitem==9) { // SFPD HQ
            x=246.4410;
            y=112.1640;
            z=1003.2190;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR11) {
        if(listitem==0) { // The Four Dragons Office
            x=2011.6030;
            y=1017.0230;
            z=39.0910;
        }
        if(listitem==1) { // Los Santos safe house
            x=2282.9766;
            y=-1140.2861;
            z=1050.8984;
        }
        if(listitem==2) { // Ten Green Bottles Bar
            x=502.3310;
            y=-70.6820;
            z=998.7570;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR12) {
        if(listitem==0) { // Budget Inn Motel Room
            x=444.6469;
            y=508.2390;
            z=1001.4194;
        }
        if(listitem==1) { // The Casino
            x=1132.9450;
            y=-8.6750;
            z=1000.6800;
        }
        if(listitem==2) { // Macisla's Barbershop
            x=411.6410;
            y=-51.8460;
            z=1001.8980;
        }
        if(listitem==3) { // Safe house 7
            x=2324.3848;
            y=-1148.4805;
            z=1050.7101;
        }
        if(listitem==4) { // Modern safe house
            x=2324.4990;
            y=-1147.0710;
            z=1050.7100;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR13) {
        if(listitem==0) { // LS Atrium
            x=1724.33;
            y=-1625.784;
            z=20.211;
        }
        if(listitem==1) { // CJ's Garage
            x=-2043.966;
            y=172.932;
            z=28.835;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR14) {
        if(listitem==0) { // Kickstart Stadium
            x=-1464.5360;
            y=1557.6900;
            z=1052.5310;
        }
        if(listitem==1) { // Didier Sachs
            x=204.1789;
            y=-165.8740;
            z=1000.5230;
        }
        if(listitem==2) { // Francis Int. Airport (Front ext.)
            x=-1827.1473;
            y=7.2074;
            z=1061.1435;
        }
        if(listitem==3) { // Francis Int. Airport (Baggage Claim/Ticket Sales)
            x=-1855.5687;
            y=41.2631;
            z=1061.1435;
        }
        if(listitem==4) { // Wardrobe
            x=255.7190;
            y=-41.1370;
            z=1002.0230;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR15) {
        if(listitem==0) { // Binco
            x=207.5430;
            y=-109.0040;
            z=1005.1330;
        }
        if(listitem==1) { // Blood Bowl Stadium
            x=-1394.20;
            y=987.62;
            z=1023.96;
        }
        if(listitem==2) { // Jefferson Motel
            x=2217.6250;
            y=-1150.6580;
            z=1025.7970;
        }
        if(listitem==3) { // Burglary House 17
            x=-285.711;
            y=1470.697;
            z=1084.375;
        }
        if(listitem==4) { // Burglary House 18
            x=327.808;
            y=1479.74;
            z=1084.438;
        }
        if(listitem==5) { // Burglary House 19
            x=375.572;
            y=1417.439;
            z=1081.328;
        }
        if(listitem==6) { // Burglary House 20
            x=384.644;
            y=1471.479;
            z=1080.195;
        }
        if(listitem==7) { // Burglary House 21
            x=295.467;
            y=1474.697;
            z=1080.258;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR16) {
        if(listitem==0) { // 24/7 shop 4
            x=-25.3730;
            y=-139.6540;
            z=1003.5470;
        }
        if(listitem==1) { // LS Tattoo Parlour
            x=-204.5580;
            y=-25.6970;
            z=1002.2730;
        }
        if(listitem==2) { // Sumoring? stadium
            x=-1400.0;
            y=1250.0;
            z=1040.0;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR17) {
        if (listitem == 0) { // 24/7 shop 5
            x = -25.3930;
            y = -185.9110;
            z = 1003.5470;
        }
        if (listitem == 1) { // Club
            x = 493.4687;
            y = -23.0080;
            z = 1000.6796;
        }
        if (listitem == 2) { // Rusty Brown's - Ring Donuts
            x = 377.0030;
            y = -192.5070;
            z = 1000.6330;
        }
        if (listitem == 3) { // The Sherman's Dam Generator Hall
            x = -942.1320;
            y = 1849.1420;
            z = 5.0050;
        }
        if (listitem == 4) { // Hemlock Tattoo
            x = 377.0030;
            y = -192.5070;
            z = 1000.6330;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR18) {
        if(listitem==0) { // Lil Probe Inn
            x=-227.0280;
            y=1401.2290;
            z=27.7690;
        }
        if(listitem==1) { // 24/7 shop 6
            x=-30.9460;
            y=-89.6090;
            z=1003.5490;
        }
        if(listitem==2) { // Atrium
            x=1726.1370;
            y=-1645.2300;
            z=20.2260;
        }
        if(listitem==3) { // Warehouse 2
            x=1296.6310;
            y=0.5920;
            z=1001.0230;
        }
        if(listitem==4) { // Zip
            x=161.4620;
            y=-91.3940;
            z=1001.8050;
        }
        
    }
    if(dialogid==COMPANYDIALOG_INTERIOR0) {
        if(listitem==0){ // baaank
            x=2306.38;
            y=-15.23;
            z=26.74;
        }
        if(listitem==1){ // dILLIMORE Gas St.
            x=663.05;
            y=-573.62;
            z=16.33;
        }
    }
    new const interiorsList[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18};
    new const interiorDialogs[] = {COMPANYDIALOG_INTERIOR0,COMPANYDIALOG_INTERIOR1,COMPANYDIALOG_INTERIOR2,COMPANYDIALOG_INTERIOR3,COMPANYDIALOG_INTERIOR4,COMPANYDIALOG_INTERIOR5,COMPANYDIALOG_INTERIOR6,COMPANYDIALOG_INTERIOR7,COMPANYDIALOG_INTERIOR8,COMPANYDIALOG_INTERIOR9,COMPANYDIALOG_INTERIOR10,COMPANYDIALOG_INTERIOR11,COMPANYDIALOG_INTERIOR12,COMPANYDIALOG_INTERIOR13,COMPANYDIALOG_INTERIOR14,COMPANYDIALOG_INTERIOR15,COMPANYDIALOG_INTERIOR16,COMPANYDIALOG_INTERIOR17,COMPANYDIALOG_INTERIOR18};
    for(new i=0;i<sizeof(interiorDialogs);i++) {
        if(dialogid==interiorDialogs[i]) {
            printf("A criar interiorid %d\nNome %s \nMapID %d",interiorsList[i],gCreatingCompany[playerid][COMPANYCREATOR_NAME],gCreatingCompany[playerid][COMPANYCREATOR_MAPICON]);
            gCreatingCompany[playerid][COMPANYCREATOR_CREATING]=0;
            PrepareAddCompany(gCreatingCompany[playerid][COMPANYCREATOR_NAME],interiorsList[i],gCreatingCompany[playerid][COMPANYCREATOR_MAPICON],x,y,z,pX,pY,pZ);
            
            return 1;
        }
    }
    return 1;
}
hook OnPlayerDisconnect(playerid,reason) {
    gCreatingCompany[playerid][COMPANYCREATOR_CREATING]=0;
    return 1;
}