//testezin

//includes//
#include <a_samp>
#include <core>
#include <float>
#include <string>
#include <file>
#include <time>
#include <datagram>
#include <a_players>
#include <a_vehicles>
#include <a_objects>
#include <a_sampdb>
#include <zcmd>
#include <DOF2>
#include <sscanf2>
//includes//

//variaveis//
#define AZUL 0x1055F8FF
#define VERMELHO 0xFC0A0AFF
#define LARANJA 0xFF8000FF
#define AMARELO 0xFFFF00FF
#define VERDE_CLARO 0x11FF3AFF
#define VERDE 0x00A81EFF
#define AQUA 0x0AFEA3FF
#define CYAN 0x00FFFFFF
#define ROXO 0x800080FF
#define ROSA 0xFF00FFFF
#define PINK 0xFF0080FF
#define WHITE 0xFFFFFFFF
#define BLACK 0x000000FF

#define AZULT 0x1055F899
#define VERMELHOT 0xFC0A0A99
#define LARANJAT 0xFF800099
#define AMARELOT 0xFFFF0099
#define VERDE_CLAROT 0x11FF3A99
#define VERDET 0x00A81E99
#define AQUAT 0x0AFEA399
#define CYANT 0x00FFFF99
#define ROXOT 0x80008099
#define ROSAT 0xFF00FF99
#define PINKT 0xFF008099
#define WHITET 0xFFFFFF99
#define BLACKT 0x00000099
#define BLACKT 0x00000099

#define CONTAS "contas/%s.ini"
#define GOVS "Governo/%d.ini"
#define ORGS "Governo/%d.ini"
#define SAIDAS "Saidas/%d.ini"
#define RADARES "Radares/%d.ini"
#define CASAS "Casas/%d.ini"
#define EMPRESAS "Empresas/%d.ini"
#define MAX_ORGS 50
#define MAX_SAIDAS 50
#define MAX_CASAS 350
#define MAX_EMPRESAS 150
#define MAP_HQ 0



new tmrclock[MAX_PLAYERS];
new bool:Logado[MAX_PLAYERS];
new senha[128], confsenha[128], senhalogin[128];
new Governo[100];
new GovernoT[100];
new s[100];
new s2[100];
new OrgsID;
new SaidasID;
new CasasID;
new EmpresasID;
new Empresa[MAX_EMPRESAS];
new Casas[MAX_CASAS];
new EmpresaT[MAX_EMPRESAS];
new CasasT[MAX_CASAS];
new float:lastx[MAX_PLAYERS],float:lasty[MAX_PLAYERS],float:lastz[MAX_PLAYERS];
new float:lx[MAX_PLAYERS],float:ly[MAX_PLAYERS],float:lz[MAX_PLAYERS];
new timerOrgs, timerSaida, timerRecupS, timerRecupOrgs;
new inpref[MAX_PLAYERS];
new actPref, actBank, actDetran, actPolice, actAE, actAuto, actImo;
new actPrefT, actBankT, actDetranT, actPoliceT, actAET, actAutoT, actImoT;
new actPrefT2, actBankT2, actDetranT2, actPoliceT2, actAET2, actAutoT2, actImoT2;

new pckPrefT, pckBankT, pckDetranT, pckPoliceT, pckAET, pckAutoT;
new pckPrefT2, pckBankT2, pckDetranT2, pckPoliceT2, pckAET2, pckAutoT2;

new pckpPizza, pckpPizzaT;

new multas[MAX_PLAYERS];
new cmnh[MAX_PLAYERS], CmnhT, CmnhT2;


new profJornal, profPizza;
new profJornal2, profPizza2;
new cp[MAX_PLAYERS], bool:autoescola[MAX_PLAYERS],bool:aereo[MAX_PLAYERS],cpaereo[MAX_PLAYERS],bool:aquatico[MAX_PLAYERS],cpagua[MAX_PLAYERS],bool:Caminhao[MAX_PLAYERS],bool:mssn[MAX_PLAYERS];
new bankmoney[MAX_PLAYERS];

new Float:casax[MAX_PLAYERS], Float:casay[MAX_PLAYERS], Float:casaz[MAX_PLAYERS];
new Float:nextx[MAX_PLAYERS], Float:nexty[MAX_PLAYERS], Float:nextz[MAX_PLAYERS];
new jornais[MAX_PLAYERS], bool:JornalT[MAX_PLAYERS];
new Pizzas[MAX_PLAYERS], bool:PizzaT[MAX_PLAYERS];
new bike1[MAX_PLAYERS], bikeT[MAX_PLAYERS], bool:bike2[MAX_PLAYERS];
new pckpJornal, pckpJornalT;
new Float:h1[MAX_PLAYERS], Float:h2[MAX_PLAYERS], Float:h3[MAX_PLAYERS], Float:h4[MAX_PLAYERS], Float:h5[MAX_PLAYERS];
new Pbike[MAX_PLAYERS], PbikeT[MAX_PLAYERS];
new bool:death[MAX_PLAYERS];
#define MAX_RADAR   200
static
	radarid[MAX_PLAYERS],
	Text3D:TRadar[MAX_RADAR],
	Variavel[MAX_PLAYERS];
enum radar {
	idDoRadar,
	Float:lPosX,
	Float:lPosY,
	Float:lPosZ,
	Float:lAngulo,
	lVelocidade
};

new InfoRadar[MAX_RADAR][radar];
new RadarID[radar];
new tmrRadar[MAX_PLAYERS];
new bool:onvehicle[MAX_PLAYERS];
new tmrKick[MAX_PLAYERS];
new tmrCasas;



//variaveis//

//Dialogs//
#define DIALOG_REGISTRO 0
#define DIALOG_CONFREGISTRO 1

#define DIALOG_LOGIN 2

#define DIALOG_PREFEITURA 2
#define DIALOG_LICENCAS 3



#define DIALOG_AGENCIA 4

#define DIALOG_CLASSEB 5
#define DIALOG_CLASSEM 6
#define DIALOG_CLASSEA 7
#define DIALOG_MILITAR 8



#define DIALOG_AUTO 9



#define DIALOG_DETRAN 10

#define DIALOG_RENOVARHAB 11



#define DIALOG_NEWSENHA 12
#define DIALOG_CONFSENHA 13

#define DIALOG_SENHALOGIN 14

#define DIALOG_BANCO 15
#define DIALOG_DEPOSITO 16
#define DIALOG_SAQUE 17
#define DIALOG_CHANGEPASS 18



#define DIALOG_IMOBILIARIA 19
#define DIALOG_VENDACASA 20

//Dialogs//

//textdraws//
new PlayerText:PlayerTD[MAX_PLAYERS][28];
new PlayerText:ClockTD[MAX_PLAYERS][2];
//textdraws//


//funções//
forward LoadRadares();
public LoadRadares(){
	new file[128];
	new qtdRadares;
	for(new i; i<MAX_RADAR;i++){
		format(file, sizeof(file), RADARES,i);

		if(DOF2_FileExists(file)){
			new strradar[2500];
			
			InfoRadar[i][lPosX] = DOF2_GetFloat(file,"PosX");
			InfoRadar[i][lPosY] = DOF2_GetFloat(file,"PosY");
			InfoRadar[i][lPosZ] = DOF2_GetFloat(file,"PosZ");
			InfoRadar[i][lAngulo] = DOF2_GetFloat(file,"Angulo");
			InfoRadar[i][lVelocidade] = DOF2_GetInt(file, "Velocidade");
			format(strradar, sizeof(strradar),"{FF0000}Radar\n\n{00ff00}ID:%d\n{FFFFFF}Limite de velocidade: %d KM/H", i, InfoRadar[i][lVelocidade]);
			CreateObject(18880, InfoRadar[i][lPosX], InfoRadar[i][lPosY], InfoRadar[i][lPosZ], 0.0, 0.0, InfoRadar[i][lAngulo]);
			CreateObject(18880, InfoRadar[i][lPosX], InfoRadar[i][lPosY], InfoRadar[i][lPosZ], 0.0, 0.0, InfoRadar[i][lAngulo] + 180.0);
			TRadar[i] = Text3D:Create3DTextLabel(strradar, -1, InfoRadar[i][lPosX], InfoRadar[i][lPosY], InfoRadar[i][lPosZ]+5.5, 150.0, 0);
			qtdRadares = i;
		}else{
			break;
		}
		
	}
	RadarID[idDoRadar] = qtdRadares + 1;
	printf("=            %d Radares Carregados.           =", qtdRadares);
	RadarID[idDoRadar] = qtdRadares;

}

main()
{
    printf("==================[PhantomRP]==================");
    printf("=                                             =");
    printf("=             Servidor carregado.             =");
	LoadRadares();
    printf("=                                             =");
    printf("==================[PhantomRP]==================");
}

forward KP(playerid);
public KP(playerid){
	Kick(playerid);
	return 1;
}

forward KickPlayer(playerid);
public KickPlayer(playerid){
	SendClientMessage(playerid, -1, "{FF0000}[ERRO]{FFFFFF}Voce demorou demais para logar e por isso foi desconectado.");
	SetTimer("KP", 1000, false);
	return 1;
}



forward start(playerid);
public start(playerid){
	new file[128];
	format(file, sizeof(file), "contas/%s.ini", PlayerName(playerid));
	new cam;
    cam = random2(0,3);


	//SetSpawnInfo(playerid, GetPlayerTeam(playerid), 0, 0.0, 0.0, 0.0, 0.0);

    if(cam == 0){
        InterpolateCameraPos(playerid, -16.776363, -2071.549804, 145.789672, 2504.847412, -1481.552246, 125.794448, 50000);
        InterpolateCameraLookAt(playerid, -13.651768, -2068.070312, 144.020263, 2501.822265, -1478.139770, 123.743972, 50000);
    }else if(cam == 1){
        InterpolateCameraPos(playerid, 854.839782, -1215.568115, 196.104782, 1336.177246, -1232.114501, 16.122467, 50000);
        InterpolateCameraLookAt(playerid, 856.604492, -1219.503173, 193.574676, 1338.891235, -1236.301513, 16.443048, 50000);
    }else if(cam == 2){
        InterpolateCameraPos(playerid, 1834.899902, -1040.523315, 216.126510, 88.353263, -1124.242919, 176.513442, 50000);
        InterpolateCameraLookAt(playerid, 1832.391601, -1036.634399, 214.233062, 90.477981, -1119.991699, 174.960220, 50000);
    }else if(cam == 3){
        InterpolateCameraPos(playerid, 291.758850, -737.588134, 157.044021, 169.185165, 1025.968872, 107.048583, 50000);
        InterpolateCameraLookAt(playerid, 296.282165, -736.465576, 155.233123, 174.012939, 1025.364624, 105.896438, 50000);
    }

	CreateInicial(playerid);
	//tmrKick[playerid] = SetTimer("KickPlayer", 50000, false);
	return 1;
}

forward CheckPref(playerid);
public CheckPref(playerid){
	new Keys, ud, lr, file[128], msg[128];
    GetPlayerKeys ( playerid, Keys, ud, lr ) ;
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 362.77471923, 173.68565368, 1008.38281250)){
			if(Keys ==  KEY_YES){
				ShowPlayerDialog(playerid, DIALOG_PREFEITURA, DIALOG_STYLE_TABLIST, "Prefeitura", "Licencas\nRemover niveis de procurado", "Aceitar", "Cancelar");
			}
		}if(IsPlayerInRangeOfPoint(playerid, 3.0, 246.286956, 117.782485, 1003.218750)){
			if(Keys ==  KEY_YES){
				ShowPlayerDialog(playerid, DIALOG_AGENCIA, DIALOG_STYLE_TABLIST, "Agencia de empregos", "{8080FF}CLASSE BAIXA\n{FF8040}CLASSE MEDIA\n{800040}CLASSE ALTA\n{008000}MILITAR", "Aceitar", "Cancelar");
			}
		}if(IsPlayerInRangeOfPoint(playerid, 3.0, 1490.283813, 1305.732543, 1093.296386)){
			if(Keys ==  KEY_YES){
				ShowPlayerDialog(playerid, DIALOG_AUTO, DIALOG_STYLE_TABLIST_HEADERS, "Auto-Escola", "{FF0000}Habilitacao \t\t{008000}Preco\nTerrestre\t\t{008000}$5000\nAerea\t\t{008000}$10000\nMaritima\t\t{008000}$15000\n", "Aceitar", "Cancelar");
			}
		}if(IsPlayerInRangeOfPoint(playerid, 3.0, 822.730041, 3.0, 1004.179687)){
			if(Keys ==  KEY_YES){
				new total[MAX_PLAYERS];
				multas[playerid] = DOF2_GetInt(file, "MultasT");
				total[playerid] = multas[playerid]*2000;
				
				format(msg, sizeof(msg),"{FF0000}\t\t{008000}\nPagar multas\t\t{008000}$%d\nRenovar Habilitacoes" , total);
				ShowPlayerDialog(playerid, DIALOG_DETRAN, DIALOG_STYLE_TABLIST_HEADERS, "Detran", msg, "Aceitar", "Cancelar");
			}
		}
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 292.262152, 179.451049, 1007.179443)){
			if(Keys == KEY_YES){
				if(DOF2_GetInt(file, "Banco") == 1){
					ShowPlayerDialog(playerid, DIALOG_SENHALOGIN, DIALOG_STYLE_PASSWORD, "Banco", "Digite a senha de sua conta bancaria para continuar", "Aceitar", "Cancelar");
				}else if(DOF2_GetInt(file, "Banco") == 0){
					ShowPlayerDialog(playerid, DIALOG_NEWSENHA, DIALOG_STYLE_PASSWORD, "Banco", "Digite uma senha para registrar sua conta bancaria.", "Aceitar", "Cancela");
				}
			}
		}if(IsPlayerInRangeOfPoint(playerid, 3.0, 362.775573, 169.893692,1025.789062)){
			if(Keys == KEY_SECONDARY_ATTACK){
				ShowPlayerDialog(playerid, DIALOG_IMOBILIARIA, DIALOG_STYLE_TABLIST_HEADERS, "Imobiliaria", "\t\t{008000}Preco\n{ffffff}Licenca para aquisicao de Propriedades\t\t$10000\n{ffffff}Licenca para aquisicao de empresas\t\t$25000\nVender casa");
			}
		}

	return 1;
}

stock ClearPlayerChat(playerid){

	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");

	return 1;
}

forward UpdateClock(playerid);
public UpdateClock(playerid){
	PlayerTextDrawHide(playerid, ClockTD[playerid][0]);
	PlayerTextDrawHide(playerid, ClockTD[playerid][1]);

	new hora[MAX_PLAYERS], min[MAX_PLAYERS], seg[MAX_PLAYERS], dia[MAX_PLAYERS], mes[MAX_PLAYERS], ano[MAX_PLAYERS], msg[128];
	gettime(hora[playerid], min[playerid], seg[playerid]);
	getdate(ano[playerid], mes[playerid], dia[playerid])	
	format(msg, sizeof(msg),"%02d/%02d/%02d", dia[playerid], mes[playerid], ano[playerid]);
	PlayerTextDrawSetString(playerid, ClockTD[playerid][1], msg);
	format(msg, sizeof(msg),"%02d:%02d", hora[playerid], min[playerid]);
	PlayerTextDrawSetString(playerid, ClockTD[playerid][0], msg);

	PlayerTextDrawShow(playerid, ClockTD[playerid][0]);
	PlayerTextDrawShow(playerid, ClockTD[playerid][1]);
	return 1;
}


forward CreateClock(playerid);
public CreateClock(playerid)
{
	ClockTD[playerid][0] = CreatePlayerTextDraw(playerid, 578.000000, 31.000000, "00:00");
	PlayerTextDrawFont(playerid, ClockTD[playerid][0], 3);
	PlayerTextDrawLetterSize(playerid, ClockTD[playerid][0], 0.554166, 2.449999);
	PlayerTextDrawTextSize(playerid, ClockTD[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ClockTD[playerid][0], 2);
	PlayerTextDrawSetShadow(playerid, ClockTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, ClockTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, ClockTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, ClockTD[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, ClockTD[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, ClockTD[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, ClockTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, ClockTD[playerid][0], 0);

	ClockTD[playerid][1] = CreatePlayerTextDraw(playerid, 501.000000, 1.000000, "00/00/0000");
	PlayerTextDrawFont(playerid, ClockTD[playerid][1], 3);
	PlayerTextDrawLetterSize(playerid, ClockTD[playerid][1], 0.558332, 2.299998);
	PlayerTextDrawTextSize(playerid, ClockTD[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ClockTD[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, ClockTD[playerid][1], 1);
	PlayerTextDrawAlignment(playerid, ClockTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, ClockTD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, ClockTD[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, ClockTD[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, ClockTD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, ClockTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, ClockTD[playerid][1], 0);

	return 1;
}

stock CreateInicial(playerid)
{
	PlayerTD[playerid][0] = CreatePlayerTextDraw(playerid, 320.000000, 133.000000, "_");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][0], 0.600000, 0.649999);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][0], 303.500000, 238.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][0], 1097458135);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][0], 0);

	PlayerTD[playerid][1] = CreatePlayerTextDraw(playerid, 320.000000, 144.000000, "_");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][1], 0.600000, 21.750000);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][1], 303.500000, 238.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][1], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][1], 215);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][1], 0);

	PlayerTD[playerid][2] = CreatePlayerTextDraw(playerid, 320.000000, 144.000000, "_");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][2], 0.600000, 21.750003);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][2], 303.500000, -8.000000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][2], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][2], 1097458135);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][2], 0);

	PlayerTD[playerid][3] = CreatePlayerTextDraw(playerid, 260.000000, 145.000000, "Registro");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][3], 2);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][3], 0.533333, 2.149997);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][3], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][3], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][3], 0);

	PlayerTD[playerid][4] = CreatePlayerTextDraw(playerid, 267.000000, 97.000000, "Phantom");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][4], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][4], 1097458175);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][4], 0);

	PlayerTD[playerid][5] = CreatePlayerTextDraw(playerid, 346.000000, 97.000000, " -RP");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][5], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][5], 0);

	PlayerTD[playerid][6] = CreatePlayerTextDraw(playerid, 382.000000, 145.000000, "Login");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][6], 2);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][6], 0.533333, 2.149997);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][6], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][6], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][6], 0);

	PlayerTD[playerid][7] = CreatePlayerTextDraw(playerid, 260.000000, 219.000000, "_");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][7], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][7], 0.600000, 0.050000);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][7], 306.000000, 98.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][7], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][7], 1097458135);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][7], 0);

	PlayerTD[playerid][8] = CreatePlayerTextDraw(playerid, 260.000000, 245.000000, "_");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][8], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][8], 0.600000, 0.050000);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][8], 306.000000, 98.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][8], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][8], 1097458135);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][8], 0);

	PlayerTD[playerid][9] = CreatePlayerTextDraw(playerid, 260.000000, 271.000000, "_");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][9], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][9], 0.600000, 0.050000);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][9], 306.000000, 98.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][9], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][9], 1097458135);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][9], 0);

	PlayerTD[playerid][10] = CreatePlayerTextDraw(playerid, 226.000000, 201.000000, PlayerName(playerid));
	PlayerTextDrawFont(playerid, PlayerTD[playerid][10], 2);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][10], 0.254166, 1.399999);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][10], 280.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][10], 1);

	PlayerTD[playerid][11] = CreatePlayerTextDraw(playerid, 208.000000, 199.000000, "HUD:radar_light");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][11], 4);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][11], 0.087499, 4.900000);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][11], 13.500000, 15.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][11], -206);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][11], 0);

	PlayerTD[playerid][12] = CreatePlayerTextDraw(playerid, 208.000000, 225.000000, "HUD:radar_light");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][12], 4);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][12], 0.087499, 4.900000);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][12], 13.500000, 15.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][12], -206);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][12], 0);

	PlayerTD[playerid][13] = CreatePlayerTextDraw(playerid, 208.000000, 252.000000, "HUD:radar_light");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][13], 4);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][13], 0.087499, 4.900000);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][13], 13.500000, 15.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][13], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][13], -206);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][13], 0);

	PlayerTD[playerid][14] = CreatePlayerTextDraw(playerid, 226.000000, 228.000000, "Senha");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][14], 2);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][14], 0.254166, 1.399999);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][14], 270.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][14], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][14], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][14], 1);

	PlayerTD[playerid][15] = CreatePlayerTextDraw(playerid, 226.000000, 253.000000, "Conf. Senha");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][15], 2);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][15], 0.254166, 1.399999);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][15], 296.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][15], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][15], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][15], 1);

	PlayerTD[playerid][16] = CreatePlayerTextDraw(playerid, 380.000000, 219.000000, "_");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][16], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][16], 0.600000, 0.050000);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][16], 306.000000, 98.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][16], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][16], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][16], 1097458135);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][16], 0);

	PlayerTD[playerid][17] = CreatePlayerTextDraw(playerid, 380.000000, 245.000000, "_");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][17], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][17], 0.600000, 0.050000);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][17], 306.000000, 98.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][17], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][17], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][17], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][17], 1097458135);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][17], 0);

	PlayerTD[playerid][18] = CreatePlayerTextDraw(playerid, 347.000000, 201.000000, PlayerName(playerid));
	PlayerTextDrawFont(playerid, PlayerTD[playerid][18], 2);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][18], 0.254166, 1.399999);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][18], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][18], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][18], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][18], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][18], 50);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][18], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][18], 1);

	PlayerTD[playerid][19] = CreatePlayerTextDraw(playerid, 347.000000, 228.000000, "Senha");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][19], 2);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][19], 0.254166, 1.399999);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][19], 390.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][19], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][19], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][19], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][19], 50);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][19], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][19], 1);

	PlayerTD[playerid][20] = CreatePlayerTextDraw(playerid, 330.000000, 199.000000, "HUD:radar_light");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][20], 4);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][20], 0.087499, 4.900000);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][20], 13.500000, 15.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][20], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][20], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][20], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][20], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][20], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][20], -206);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][20], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][20], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][20], 0);

	PlayerTD[playerid][21] = CreatePlayerTextDraw(playerid, 330.000000, 225.000000, "HUD:radar_light");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][21], 4);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][21], 0.087499, 4.900000);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][21], 13.500000, 15.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][21], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][21], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][21], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][21], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][21], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][21], -206);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][21], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][21], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][21], 0);

	PlayerTD[playerid][22] = CreatePlayerTextDraw(playerid, 260.000000, 319.000000, "_");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][22], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][22], 0.600000, 1.349998);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][22], 306.000000, 98.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][22], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][22], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][22], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][22], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][22], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][22], 1097458135);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][22], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][22], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][22], 0);

	PlayerTD[playerid][23] = CreatePlayerTextDraw(playerid, 260.000000, 319.000000, "_");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][23], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][23], 0.600000, 0.449999);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][23], 306.000000, 98.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][23], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][23], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][23], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][23], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][23], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][23], 1097458135);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][23], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][23], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][23], 0);

	PlayerTD[playerid][24] = CreatePlayerTextDraw(playerid, 379.000000, 319.000000, "_");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][24], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][24], 0.600000, 1.349998);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][24], 306.000000, 98.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][24], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][24], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][24], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][24], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][24], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][24], 1097458135);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][24], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][24], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][24], 0);

	PlayerTD[playerid][25] = CreatePlayerTextDraw(playerid, 260.000000, 318.000000, "Registrar");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][25], 2);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][25], 0.254166, 1.399999);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][25], 15.500000, 74.000000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][25], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][25], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][25], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][25], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][25], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][25], 50);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][25], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][25], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][25], 1);

	PlayerTD[playerid][26] = CreatePlayerTextDraw(playerid, 379.000000, 319.000000, "_");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][26], 1);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][26], 0.600000, 0.449999);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][26], 306.000000, 98.500000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][26], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][26], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][26], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][26], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][26], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][26], 1097458135);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][26], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][26], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][26], 0);

	PlayerTD[playerid][27] = CreatePlayerTextDraw(playerid, 379.000000, 318.000000, "Entrar");
	PlayerTextDrawFont(playerid, PlayerTD[playerid][27], 2);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][27], 0.254166, 1.399999);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][27], 15.500000, 74.000000);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][27], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][27], 0);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][27], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][27], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][27], 255);
	PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][27], 50);
	PlayerTextDrawUseBox(playerid, PlayerTD[playerid][27], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][27], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][27], 1);

	PlayerTextDrawShow(playerid, PlayerTD[playerid][0]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][1]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][2]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][3]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][4]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][5]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][6]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][7]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][8]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][9]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][10]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][11]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][12]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][13]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][14]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][15]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][16]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][17]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][18]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][19]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][20]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][21]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][22]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][23]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][24]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][25]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][26]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][27]);

	SelectTextDraw(playerid, 0xFF0000FF);

	return 1;
}
stock DestroyInicial(playerid)
{
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][0]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][1]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][2]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][3]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][4]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][5]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][6]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][7]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][8]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][9]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][10]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][11]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][12]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][13]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][14]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][15]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][16]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][17]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][18]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][19]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][20]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][21]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][22]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][23]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][24]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][25]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][26]);
	PlayerTextDrawDestroy(playerid, PlayerTD[playerid][27]);
	return 1;
}

stock SalvarConta(playerid){
    new file[128];
    format(file, sizeof(file), CONTAS, PlayerName(playerid));

    new Float:x[MAX_PLAYERS], Float:y[MAX_PLAYERS], Float:z[MAX_PLAYERS];
    GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
    DOF2_SetInt(file, "Level", GetPlayerScore(playerid));
    DOF2_SetInt(file, "Money", GetPlayerMoney(playerid));
    DOF2_SetFloat(file, "X", x[playerid]);
    DOF2_SetFloat(file, "Y", y[playerid]);
    DOF2_SetFloat(file, "Z", floatadd(z[playerid], 0.5));
    DOF2_SetInt(file, "Skin", GetPlayerSkin(playerid));
    DOF2_SaveFile(file);
    return 1;
}
forward activateOrgs(playerid);
public activateOrgs(playerid){
	timerOrgs = SetTimer("CheckOrgs", 50, true);
}

forward activateSaidas(playerid);
public activateSaidas(playerid){
	timerSaida = SetTimer("CheckSaidas", 50, true);
}
forward activateCasas(playerid);
public activateCasas(playerid){
	tmrCasas = SetTimer("CheckCasas", 200, true);
}

forward CheckOrgs(playerid);
public CheckOrgs(playerid){
	new Keys, ud, lr, file[128], file2[128];
    GetPlayerKeys ( playerid, Keys, ud, lr ) ;
	new interiorID = GetPlayerInterior(playerid);
	format(file, sizeof(file), CONTAS, PlayerName(playerid));

	for(new i = 0; i < MAX_ORGS; i++)
	{
		new float:x[10000], float:y[10000], float:z[10000];
		new msg[128];
		format(file, sizeof(file), ORGS, i);

		if(IsPlayerInRangeOfPoint(playerid, 5.0, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"))){
			if(Keys == KEY_SECONDARY_ATTACK){
				GetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
				if(DOF2_GetInt(file, "Pickup") == 1247){
					DOF2_SetInt(file2, "Interior", 6);
					SetPlayerInterior(playerid, 6);
					SetPlayerPos(playerid, 246.783996,63.900199,1003.640625);
					//SendClientMessage(playerid, -1, "{00FF00}[DELEGACIA] {FFFFFF}Voce entrou na delegacia.");
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);
					
				}else if(DOF2_GetInt(file, "Pickup") == 1212){
					inpref[playerid] = 1;
					DOF2_SetInt(file2, "Interior", 3);
					SetPlayerInterior(playerid, 3);
					SetPlayerPos(playerid, 384.808624,173.804992,1008.382812);
					//SendClientMessage(playerid, -1, "{00FF00}[PREFEITURA] {FFFFFF}Voce entrou na prefeitura.");
					SetTimer("CheckPref", 1000, true);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);

				}else if(DOF2_GetInt(file, "Pickup") == 1210){
					DOF2_SetInt(file2, "Interior", 10);
					SetPlayerInterior(playerid, 10);
					SetPlayerPos(playerid, 246.375991,109.245994,1003.218750);
					//SendClientMessage(playerid, -1, "{00FF00}[AGENCIA DE EMPREGOS] {FFFFFF}Voce entrou na agencia de empregos.");
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);

				}else if(DOF2_GetInt(file, "Pickup") == 1239){
					SetPlayerInterior(playerid, 3);
					DOF2_SetInt(file2, "Interior", 3);
					SetPlayerPos(playerid, 833.269775,10.588416,1004.179687);
					//SendClientMessage(playerid, -1, "{00FF00}[DETRAN] {FFFFFF}Voce entrou no detran.");
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);

				}else if(DOF2_GetInt(file, "Pickup") == 1581){
					SetPlayerInterior(playerid, 3);
					DOF2_SetInt(file2, "Interior", 3);
					SetPlayerPos(playerid, 1494.325195,1304.942871,1093.289062);
					//SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA] {FFFFFF}Voce entrou na auto-escola.");
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);

				}else if(DOF2_GetInt(file, "Pickup") == 1274){
					DOF2_SetInt(file2, "Interior", 3);
					//SendClientMessage(playerid, -1, "{00FF00}[BANCO] {FFFFFF}Voce entrou no banco.");
					SetPlayerInterior(playerid, 3);
					SetPlayerPos(playerid, 288.745971,169.350997,1007.171875);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);
				}else if(DOF2_GetInt(file, "Pickup") == 1277){
					DOF2_SetInt(file2, "Interior", 15);
					//SendClientMessage(playerid, -1, "{00FF00}[HOTEL] {FFFFFF}Voce entrou no hotel.");
					SetPlayerInterior(playerid, 15);
					SetPlayerPos(playerid, 2215.454833, -1147.475585,1025.796875);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);
				}else if(DOF2_GetInt(file, "Pickup") == 19197){
					DOF2_SetInt(file2, "Interior", 5);
					//SendClientMessage(playerid, -1, "{00FF00}[PIZZA] {FFFFFF}Voce entrou na pizzaria.");
					SetPlayerInterior(playerid, 5);
					SetPlayerPos(playerid, 372.399353, -131.870697, 1001.5);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);
				}else if(DOF2_GetInt(file, "Pickup") == 19198){
					DOF2_SetInt(file2, "Interior", 10);
					//SendClientMessage(playerid, -1, "{00FF00}[BURGUER-SHOT] {FFFFFF}Voce entrou no Burguer Shot.");
					SetPlayerInterior(playerid, 10);
					SetPlayerPos(playerid, 363.742584, -74.305526, 1001.507812);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);
				}else if(DOF2_GetInt(file, "Pickup") == 19524){
					DOF2_SetInt(file2, "Interior", 3);
					//SendClientMessage(playerid, -1, "{00FF00}[IMOBILIARIA] {FFFFFF}Voce entrou no Burguer Shot.");
					SetPlayerInterior(playerid, 3);
					SetPlayerPos(playerid, 363, 165.5, 1026);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);
				}
			}
		}
		
		
	   

	}
}
forward CheckSaidas(playerid);
public CheckSaidas(playerid){
	new Keys, ud, lr, file[128],MSG[128];
	new msgg[128]
	new interiorID = GetPlayerInterior(playerid);
    GetPlayerKeys ( playerid, Keys, ud, lr ) ;
	for(new i = 0;i < MAX_SAIDAS; i++){
		format(file, sizeof(file), SAIDAS, i);
		if(IsPlayerInRangeOfPoint(playerid, 3.0, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"))){
			if(Keys == KEY_SECONDARY_ATTACK){
				KillTimer(tmrCasas);
				SetTimer("activateCasas", 5000, false);
				if(DOF2_GetInt(file, "Tipo") == 0){
					SetPlayerInterior(playerid, 0);
					DOF2_SetInt(file, "Interior", 0);
					SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
					//SendClientMessage(playerid, -1, "{00FF00}[DELEGACIA] {FFFFFF}Voce saiu da delegacia.");
					KillTimer(timerOrgs);
					SetTimer("activateOrgs", 5000, false);
					
				}else if(DOF2_GetInt(file, "Tipo") == 1){
					inpref[playerid] = 0;
					DOF2_SetInt(file, "Interior", 0);
					SetPlayerInterior(playerid, 0);
					SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
					//SendClientMessage(playerid, -1, "{00FF00}[PREFEITURA] {FFFFFF}Voce saiu da prefeitura.");
					KillTimer(timerOrgs);
					SetTimer("activateOrgs", 5000, false);
					
				}else if(DOF2_GetInt(file, "Tipo") == 2){
					SetPlayerInterior(playerid, 0);
					DOF2_SetInt(file, "Interior", 0);
					SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
					//SendClientMessage(playerid, -1, "{00FF00}[AGENCIA DE EMPREGOS] {FFFFFF}Voce saiu da Agencia de empregos.");
					KillTimer(timerOrgs);
					SetTimer("activateOrgs", 5000, false);
				}else if(DOF2_GetInt(file, "Tipo") == 3){
					SetPlayerInterior(playerid, 0);
					DOF2_SetInt(file, "Interior", 0);
					SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
					//SendClientMessage(playerid, -1, "{00FF00}[DETRAN] {FFFFFF}Voce saiu do detran.");
					KillTimer(timerOrgs);
					SetTimer("activateOrgs", 5000, false);
				}else if(DOF2_GetInt(file, "Tipo") == 4){
					SetPlayerInterior(playerid, 0);
					DOF2_SetInt(file, "Interior", 0);
					SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
					//SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA] {FFFFFF}Voce saiu da auto-escola.");
					KillTimer(timerOrgs);
					SetTimer("activateOrgs", 5000, false);
				}else if(DOF2_GetInt(file, "Tipo") == 5){
					SetPlayerInterior(playerid, 0);
					DOF2_SetInt(file, "Interior", 0);
					SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
					//SendClientMessage(playerid, -1, "{00FF00}[BANCO] {FFFFFF}Voce saiu do banco.");
					KillTimer(timerOrgs);
					SetTimer("activateOrgs", 5000, false);
				}else if(DOF2_GetInt(file, "Tipo") == 6){
					SetPlayerInterior(playerid, 0);
					DOF2_SetInt(file, "Interior", 0);
					SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
					//SendClientMessage(playerid, -1, "{00FF00}[BANCO] {FFFFFF}Voce saiu do banco.");
					KillTimer(timerOrgs);
					SetTimer("activateOrgs", 5000, false);
				}else if(DOF2_GetInt(file, "Tipo") == 7){
					SetPlayerInterior(playerid, 0);
					DOF2_SetInt(file, "Interior", 0);
					SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
					//SendClientMessage(playerid, -1, "{00FF00}[BANCO] {FFFFFF}Voce saiu do banco.");
					KillTimer(timerOrgs);
					SetTimer("activateOrgs", 5000, false);
				}else if(DOF2_GetInt(file, "Tipo") == 8){
					SetPlayerInterior(playerid, 0);
					DOF2_SetInt(file, "Interior", 0);
					SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
					//SendClientMessage(playerid, -1, "{00FF00}[BANCO] {FFFFFF}Voce saiu do banco.");
					KillTimer(timerOrgs);
					SetTimer("activateOrgs", 5000, false);
				}
				else if(DOF2_GetInt(file, "Tipo") == 9){
					SetPlayerInterior(playerid, 0);
					DOF2_SetInt(file, "Interior", 0);
					SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
					//SendClientMessage(playerid, -1, "{00FF00}[Casa] {FFFFFF}Voce saiu do banco.");
					KillTimer(timerOrgs);
					SetTimer("activateOrgs", 5000, false);
				}
				else if(DOF2_GetInt(file, "Tipo") == 10){
					SetPlayerInterior(playerid, 0);
					DOF2_SetInt(file, "Interior", 0);
					SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
					//SendClientMessage(playerid, -1, "{00FF00}[Ammu-nation] {FFFFFF}Voce saiu do banco.");
					KillTimer(timerOrgs);
					SetTimer("activateOrgs", 5000, false);
				}
				else if(DOF2_GetInt(file, "Tipo") == 11){
					SetPlayerInterior(playerid, 0);
					DOF2_SetInt(file, "Interior", 0);
					SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
					//SendClientMessage(playerid, -1, "{00FF00}[Skin] {FFFFFF}Voce saiu do banco.");
					KillTimer(timerOrgs);
					SetTimer("activateOrgs", 5000, false);
				}
				else if(DOF2_GetInt(file, "Tipo") == 12){
					SetPlayerInterior(playerid, 0);
					DOF2_SetInt(file, "Interior", 0);
					SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
					//SendClientMessage(playerid, -1, "{00FF00}[Restaurante] {FFFFFF}Voce saiu do banco.");
					KillTimer(timerOrgs);
					SetTimer("activateOrgs", 5000, false);
				}
				else if(DOF2_GetInt(file, "Tipo") == 13){
					SetPlayerInterior(playerid, 0);
					DOF2_SetInt(file, "Interior", 0);
					SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
					//SendClientMessage(playerid, -1, "{00FF00}[24/7] {FFFFFF}Voce saiu do banco.");
					KillTimer(timerOrgs);
					SetTimer("activateOrgs", 5000, false);
				}

			}
		}
	}
	return 1;
} 

forward CheckCasas(playerid);
public CheckCasas(playerid){
	new file[128], Keys, ud, lr;
	
	GetPlayerKeys(playerid, Keys, ud, lr);
	for(new i = 0; i < MAX_CASAS; i++){
		format(file, sizeof(file), CASAS, i);
		if(IsPlayerInRangeOfPoint(playerid, 1.0, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"))){
			if(Keys == KEY_SECONDARY_ATTACK){
				if((strcmp(DOF2_GetString(file, "Proprietario"), PlayerName(playerid)) == 1) && (DOF2_GetInt(file, "Trancada") > 0 )) return SendClientMessage(playerid, -1, "{ff0000}[CASA]{ffffff}Esta casa esta trancada.");
				if(DOF2_GetInt(file, "Upgrade") == 0){
					SetPlayerInterior(playerid, 1);
					SetPlayerPos(playerid, 244.0, 304.8, 999.14);
					SetPlayerVirtualWorld(playerid, playerid);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 2500, false);
					GetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
				}
				if(DOF2_GetInt(file, "Upgrade") == 1){
					SetPlayerInterior(playerid, 2);
					SetPlayerPos(playerid, 266.884979,306.631988,999.148437);
					SetPlayerVirtualWorld(playerid, playerid);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 2500, false);
					GetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
				}if(DOF2_GetInt(file, "Upgrade") == 2){
					SetPlayerInterior(playerid, 3);
					SetPlayerPos(playerid, 2496.049804,-1695.238159,1014.742187);
					SetPlayerVirtualWorld(playerid, playerid);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 2500, false);
					GetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
				}
				if(DOF2_GetInt(file, "Upgrade") == 3){
					SetPlayerInterior(playerid, 5);
					SetPlayerPos(playerid, 1262.0, -785.5, 1092.0);
					SetPlayerVirtualWorld(playerid, playerid);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 2500, false);
					GetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
				}
			}
		}
	}
	return 1;
}

forward CheckProfs(playerid);
public CheckProfs(playerid){
	new Keys, ud, lr, file[128];
    GetPlayerKeys ( playerid, Keys, ud, lr ) ;
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	if(IsPlayerInRangeOfPoint(playerid, 3, 784.5, -1335.0, 13.5)){
		if(Keys ==  KEY_YES){
			if(strcmp(DOF2_GetString(file, "Emprego"), "Pizza", false) == 1) return SendClientMessage(playerid, -1, "{ff0000}[ERRO]{ffffff}Voce nao e desta profissao.");
			new name[128];
			format(name, sizeof(name), "{FFFFFF}Bike de {1010FF}%s", PlayerName(playerid));
			DestroyVehicle(bike1[playerid]);
			bike1[playerid] = AddStaticVehicle(510, 784.5, -1361.5, 13.5, 90.0, -1, -1);
			bikeT[playerid] = Text3D:Create3DTextLabel(name, -1, 0,0,0, 100, 0);
			Attach3DTextLabelToVehicle(bikeT[playerid], bike1[playerid], 0, 0, 0);
			bike2[playerid] = true;
			SendClientMessage(playerid, -1, "{00FF00}[ENTREGADOR DE JORNAL]{FFFFFF}Sua bike esta estacionada em seu local de trabalho.");
		}
	}

	return 1;
}
public OnGameModeInit(){
    EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	SetGameModeText("RPG|Brasil PRP[PT-BR]v0.1|");
    new file[128];
	for(new i = 0; i < MAX_ORGS;i++){
		format(file, sizeof(file), GOVS, i);
		if(DOF2_FileExists(file)){
			new pckup;
			pckup = DOF2_GetInt(file, "Pickup");
			Governo[i] = CreatePickup(DOF2_GetInt(file, "Pickup"), 1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"));
			if(pckup == 1212){
				GovernoT[i] = Text3d:Create3DTextLabel("{FF8000}PREFEITURA\n\n{ffffff}Pressione \"F\" para entrar.", 1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 50, 0);
			}else if(pckup == 1247){
				GovernoT[i] = Text3d:Create3DTextLabel("{FF8000}DEPARTAMENTO DE POLICIA\n\n{ffffff}Pressione \"F\" para entrar.", 1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 50, 0);
			}else if(pckup == 1581){
				GovernoT[i] = Text3d:Create3DTextLabel("{FF8000}AUTO-ESCOLA\n\n{ffffff}Pressione \"F\" para entrar.", 1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 50, 0);
			}else if(pckup == 1239){
				GovernoT[i] = Text3d:Create3DTextLabel("{FF8000}DETRAN\n\n{ffffff}Pressione \"F\" para entrar.", 1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 50, 0);
			}else if(pckup == 1210){
				GovernoT[i] = Text3d:Create3DTextLabel("{FF8000}AGENCIA DE EMPREGOS\n\n{ffffff}Pressione \"F\" para entrar.", 1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 50, 0);
			}else if(pckup == 1274){
				GovernoT[i] = Text3d:Create3DTextLabel("{FF8000}BANCO\n\n{ffffff}Pressione \"F\" para entrar.", 1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 50, 0);
			}else if(pckup == 1277){
				GovernoT[i] = Text3d:Create3DTextLabel("{FF8000}HOTEL\n\n{ffffff}Pressione \"F\" para entrar.", 1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 50, 0);
			}else if(pckup == 19197){
				GovernoT[i] = Text3d:Create3DTextLabel("{FF8000}PIZZARIA\n\n{ffffff}Pressione \"F\" para entrar.", 1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 50, 0);
			}else if(pckup == 19198){
				GovernoT[i] = Text3d:Create3DTextLabel("{FF8000}BURGUER-SHOT\n\n{ffffff}Pressione \"F\" para entrar.", 1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 50, 0);
			}else if(pckup == 19524){
				GovernoT[i] = Text3d:Create3DTextLabel("{FF8000}IMOBILIARIA\n\n{ffffff}Pressione \"F\" para entrar.", 1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 50, 0);
			}
			OrgsID = i+1;
			// else if(pckup == 1212){
			// 	GovernoT[i] = Text3d:Create3DTextLabel("{FF8000}PREFEITURA\n\n{ffffff}Pressione \"Y\" para entrar.", 1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 50, 0);
			// }
		}
	}
	for(new i = 0; i < MAX_SAIDAS; i++){
		format(file, sizeof(file), SAIDAS, i);
		if(DOF2_FileExists(file)){
			new nome[128], sd[128];
			s2[i] = CreatePickup(1239, 1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"));

			format(sd, sizeof(sd), "Pressione \"F\" ou \"ENTER\" para sair.");

			if(DOF2_GetInt(file, "Tipo") == 0){
				format(nome, sizeof(nome), "{FF8000}Delegacia de Policia\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[i] = Text3D:Create3DTextLabel(nome, -1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10.0, 0);
				
				
			}else if(DOF2_GetInt(file, "Tipo") == 1){
				format(nome, sizeof(nome), "{FF8000}Prefeitura\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[i] = Text3D:Create3DTextLabel(nome, -1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 2){
				format(nome, sizeof(nome), "{FF8000}Agencia de Empregos\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[i] = Text3D:Create3DTextLabel(nome, -1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 3){
				format(nome, sizeof(nome), "{FF8000}Detran\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[i] = Text3D:Create3DTextLabel(nome, -1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 4){
				format(nome, sizeof(nome), "{FF8000}Auto-Escola\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[i] = Text3D:Create3DTextLabel(nome, -1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 5){
				format(nome, sizeof(nome), "{FF8000}Banco\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[i] = Text3D:Create3DTextLabel(nome, -1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 6){
				format(nome, sizeof(nome), "{FF8000}Hotel\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[i] = Text3D:Create3DTextLabel(nome, -1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 8){
				format(nome, sizeof(nome), "{FF8000}Pizzaria\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[i] = Text3D:Create3DTextLabel(nome, -1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 9){
				format(nome, sizeof(nome), "{FF8000}{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair de casa.");
				s[i] = Text3D:Create3DTextLabel(nome, -1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 10){
				format(nome, sizeof(nome), "{FF8000}Ammu-Nation\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[i] = Text3D:Create3DTextLabel(nome, -1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 11){
				format(nome, sizeof(nome), "{FF8000}Loja de Roupas\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[i] = Text3D:Create3DTextLabel(nome, -1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 12){
				format(nome, sizeof(nome), "{FF8000}Restaurante\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[i] = Text3D:Create3DTextLabel(nome, -1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 13){
				format(nome, sizeof(nome), "{FF8000}Loja de utilitarios\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[i] = Text3D:Create3DTextLabel(nome, -1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10.0, 0);
			
			}else if(DOF2_GetInt(file, "Tipo") == 14){
				format(nome, sizeof(nome), "{FF8000}Imobiliaria\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[i] = Text3D:Create3DTextLabel(nome, -1, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10.0, 0);
				

			}
			SaidasID = i+1;
		}else{

		}
	}
	for(new i = 0; i < MAX_CASAS; i++){
		format(file, sizeof(file), CASAS, i);
		if(DOF2_FileExists(file)){
			new Float:x, Float:y, Float:z;
			x = DOF2_GetFloat(file, "X");
			y = DOF2_GetFloat(file, "Y");
			z = DOF2_GetFloat(file, "Z");
			
			if(strcmp(DOF2_GetString(file, "Proprietario"), "Ninguem") == 0){
				Casas[i] = CreatePickup(1273, 1, x, y, z, 0);
				new msg[128];
			 	format(msg, sizeof(msg), "{ffffff}Casa de: {1010ff}%s\n{ffffff}ID:{1010ff}%d\n{008000}$%d\n\n{ffffff}Pressione \"F\" para entrar.", DOF2_GetString(file, "Proprietario"), i, DOF2_GetInt(file, "Preco"));
				CasasT[i] = Text3D:Create3DTextLabel(msg, -1, x, y, z, 25.0, 0);
			}else{
				Casas[i] = CreatePickup(19522, 1, x, y, z, 0);
				new msg[128];
			 	format(msg, sizeof(msg), "{ffffff}Casa de: {1010ff}%s\n{ffffff}ID:{1010ff}%d\n\n{ffffff}Pressione \"F\" para entrar.", DOF2_GetString(file, "Proprietario"), i);
				CasasT[i] = Text3D:Create3DTextLabel(msg, -1, x, y, z, 25.0, 0);
			}	
		}
	}
	for(new i = 0; i < MAX_EMPRESAS; i++){
		format(file, sizeof(file), EMPRESAS, i);
		if(DOF2_FileExists(file)){
			new Float:x, Float:y, Float:z;
			x = DOF2_GetFloat(file, "X");
			y = DOF2_GetFloat(file, "Y");
			z = DOF2_GetFloat(file, "Z");
			
			if(strcmp(DOF2_GetString(file, "Proprietario"), "Ninguem") == 0){
				Empresa[i] = CreatePickup(1273, 1, x, y, z, 0);
				new msg[128];
			 	format(msg, sizeof(msg), "{ffffff}Empresa de: {1010ff}%s\n{ffffff}ID:{1010ff}%d\n{008000}$%d\n\n{ffffff}Pressione \"F\" para entrar.", DOF2_GetString(file, "Proprietario"), i, DOF2_GetInt(file, "Preco"));
				EmpresaT[i] = Text3D:Create3DTextLabel(msg, -1, x, y, z, 25.0, 0);

			}else{
				Empresa[i] = CreatePickup(19522, 1, x, y, z, 0);
				new msg[128];
			 	format(msg, sizeof(msg), "{ffffff}Empresa de: {1010ff}%s\n{ffffff}ID:{1010ff}%d\n\n{ffffff}Pressione \"F\" para entrar.", DOF2_GetString(file, "Proprietario"), i);
				EmpresaT[i] = Text3D:Create3DTextLabel(msg, -1, x, y, z, 25.0, 0);
		
			}	
		}
	}
	timerOrgs = SetTimer("CheckOrgs", 350, true);
	timerSaida = SetTimer("CheckSaidas", 350, true);
	tmrCasas = SetTimer("CheckCasas", 350, true);
	SetTimer("CheckPref", 100, true);
	SetTimer("CheckProfs", 100, true);

	actPref = CreateActor(141, 359.713165, 173.581893, 1008.389343, 268.450744);
	actAE = CreateActor(17, 246.313308, 120.393333, 1003.269287, 180.82184);
	actAuto = CreateActor(186, 1488.823486, 1305.642944, 1093.296386, 274.037017);
	actDetran = CreateActor(187, 294.243011, 182.129043, 1007.171875, 154.441696);
	actBank = CreateActor(295, 2318.0, -7.246706, 26.742187, 90.433349);
	actImo = CreateActor(57, 362.157745, 171.662109, 1025.789062, 187.846343);

	

	SetActorVirtualWorld(actPref, 0);
	SetActorInvulnerable(actPref, true);
	ApplyActorAnimation(actPref, "PED","SEAT_IDLE", 4.0, 1, 0, 0, 0, 0);
	ApplyActorAnimation(actImo, "PED","SEAT_IDLE", 4.0, 1, 0, 0, 0, 0);
	SetActorInvulnerable(actBank, true);

	actPrefT2 = CreatePickup(1212, 1, 362.77471923, 173.68565368, 1008.38281250, 0);
	actPrefT = Text3D:Create3DTextLabel("{FF8000}Prefeitura\n{FFFFFF}Pressione \"Y\"", -1, 362.77471923, 173.68565368, 1008.38281250, 50.0);

	actAET2 = CreatePickup(1210, 1, 246.286956, 117.782485, 1003.218750, 0);
	actAET= Text3D:Create3DTextLabel("{FF8000}Agencia de empregos\n {FFFFFF}Pressione \"Y\"", -1, 246.286956, 117.782485, 1003.218750, 20.0, 0);

	actAutoT = CreatePickup(1581, 1, 1490.283813, 1305.732543, 1093.296386, 0);
	actAutoT2 = Text3D:Create3DTextLabel("{FF8000}Auto-Escola\n {FFFFFF}Pressione \"Y\"", -1, 1490.283813, 1305.732543, 1093.296386, 20.0, 0);

	actBankT = CreatePickup(1274, 1, 292.262152, 179.451049, 1007.179443, 0);
	actBankT2 = Text3D:Create3DTextLabel("{FF8000}Banco\n {FFFFFF}Pressione \"Y\"", -1, 292.262152, 179.451049, 1007.179443, 20.0, 0);

	actDetranT = CreatePickup(1239, 1, 822.730041, 3.0, 1004.179687, 0)
	actDetranT2 = Text3D:Create3DTextLabel("{FF8000}Detran\n {FFFFFF}Pressione \"Y\"", -1, 822.730041, 3.0, 1004.179687, 20.0, 0);

	profJornal = CreatePickup(1210, 1, 784.719726, -1332.507812, 13.541118, 0);
	profJornal2 = Text3D:Create3DTextLabel("{FF8000}Entregador de jornal\n {FFFFFF}Digite /profissao", -1, 784.719726, -1332.507812, 13.541118, 20.0, 0);

	pckpJornal = CreatePickup(1239, 1, 784.5, -1335.0, 13.5, -1);
	pckpJornalT = Text3D:Create3DTextLabel("{FF8000}Entregador de jornal\n {FFFFFF}Pressione \"Y\"", -1, 784.5, -1335.0, 13.5, 20.0, 0);

	profPizza = CreatePickup(1210, 1, 2088.197753, -1806.460815, 13.54687, 0);
	profPizza2 = Text3D:Create3DTextLabel("{FF8000}Entregador de Pizza\n {FFFFFF}Digite /profissao", -1, 2088.197753, -1806.460815, 13.54687, 20.0, 0);

	CmnhT = CreatePickup(1239, 1, 278.221740, 1408.768798, 10.436569, 0);
	CmnhT2 = Text3D:Create3DTextLabel("{FF8000}Caminhoneiro\n {FFFFFF}Pressione \"Y\"", -1, 278.221740, 1408.768798, 10.436569, 10.0, 0);

	pckpPizza = CreatePickup(1239, 1, 2122.837402, -1784.188720, 13.387416, 0);
	pckpPizzaT = Text3D:Create3DTextLabel("{FF8000}Entregador de pizza\n {FFFFFF}Pressione \"Y\"", -1, 2122.837402, -1784.188720, 13.387416, 10.0, 0);

	actImoT = CreatePickup(1239, 1, 362.775573, 169.893692,1025.789062, 0);
	actImoT2 = Text3D:Create3DTextLabel("{FF8000}Imobiliaria\n {FFFFFF}Pressione \"Y\"", -1, 362.775573, 169.893692,1025.789062, 10.0, 0);

	
	CreateObject(3557, 2530.12231, -1948.62964, 14.91125,   0.00000, 0.00000, 0.00000);
		CreateObject(19906, 2526.17114, -1950.10010, 14.94250,   90.00000, 0.00000, 0.00000);
		CreateObject(19906, 2526.30249, -1955.07104, 15.08270,   0.00000, 0.00000, 0.00000);
		CreateObject(19866, 2537.59277, -1957.93335, 12.54713,   0.00000, 0.00000, 0.19690);
		CreateObject(19866, 2525.79224, -1975.28955, 12.54760,   0.00000, 0.00000, 90.00000);
		CreateObject(19866, 2537.60400, -1962.91296, 12.54710,   0.00000, 0.00000, 0.19690);
		CreateObject(19866, 2537.61182, -1967.89124, 12.54710,   0.00000, 0.00000, 0.19690);
		CreateObject(19866, 2537.61914, -1972.87793, 12.54710,   0.00000, 0.00000, 0.19690);
		CreateObject(19866, 2535.22119, -1975.25586, 12.54760,   0.00000, 0.00000, 90.00000);
		CreateObject(19866, 2530.77222, -1975.26660, 12.54760,   0.00000, 0.00000, 90.00000);
		CreateObject(19866, 2523.17749, -1967.89331, 12.54710,   0.00000, 0.00000, 0.19690);
		CreateObject(19866, 2523.18408, -1972.88049, 12.54710,   0.00000, 0.00000, 0.19690);
		CreateObject(5150, 2482.70313, -2010.96875, 23.60156,   356.85840, 0.00000, 3.14159);
		CreateObject(19866, 2523.16675, -1962.92554, 12.54710,   0.00000, 0.00000, 0.19690);
		CreateObject(19866, 2523.15356, -1957.93579, 12.54713,   0.00000, 0.00000, 0.19690);
		CreateObject(970, 1165.60107, -1756.23035, 90.00000,   0.00000, 0.00000, 352.19089);
		CreateObject(970, 1146.31250, -1757.63123, 13.26100,   0.00000, 0.00000, 90.00000);
		CreateObject(970, 1161.77832, -1757.65564, 13.26100,   0.00000, 0.00000, 90.00000);
		CreateObject(970, 1156.18311, -1755.62427, 13.26100,   0.00000, 0.00000, 0.00000);
		CreateObject(970, 1148.38257, -1756.24524, 13.26100,   0.00000, 0.00000, 0.00000);
		CreateObject(970, 1149.05603, -1755.62024, 13.26100,   0.00000, 0.00000, 0.00000);
		CreateObject(970, 1159.76685, -1755.60547, 13.26100,   0.00000, 0.00000, 0.00000);
		CreateObject(970, 1152.36768, -1755.59937, 13.26100,   0.00000, 0.00000, 0.00000);
		CreateObject(970, 1156.60400, -1756.24158, 13.26100,   0.00000, 0.00000, 0.00000);
		CreateObject(970, 1152.49365, -1756.24365, 13.26100,   0.00000, 0.00000, 0.00000);
		CreateObject(3471, 1146.82715, -1771.55505, 16.81960,   0.00000, 0.00000, 90.00000);
		CreateObject(3471, 1160.71277, -1771.49805, 16.81960,   0.00000, 0.00000, 90.00000);
		CreateObject(13360, 363.5, 165.3, 1025.7, 0.00000, 0.00000, 0.00000);
    return 1;
}

public OnGameModeExit(){
    DOF2_Exit();
    return 1;
}

public OnPlayerConnect(playerid){
    new cam, file[128],file2[128];
    cam = random2(0,3);
	format(file2, sizeof(file2), "contas/%s.ini", PlayerName(playerid));
	
    if(IsPlayerNPC(playerid)) SpawnPlayer(playerid);
	
	SetTimer("start", 3000, false);
	SetTimer("CheckRadar", 250, true);
	CreateClock(playerid);
	for(new i = 0; i < MAX_ORGS;i++){
		format(file, sizeof(file), GOVS, i);
		new pckup;
		pckup = DOF2_GetInt(file, "Pickup");
		if(DOF2_FileExists(file)){
			
			if(pckup == 1212){ //PREFEITURA
				SetPlayerMapIcon(playerid, i, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 58, -1, MAPICON_LOCAL);
			}else if(pckup == 1247){ // DP
				SetPlayerMapIcon(playerid, i, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 30, -1, MAPICON_LOCAL);
			}else if(pckup == 1581){ // AUTO-ESCOLA
				SetPlayerMapIcon(playerid, i, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 36, -1, MAPICON_LOCAL);
			}else if(pckup == 1239){ // DETRAN
				SetPlayerMapIcon(playerid, i, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 19, -1, MAPICON_LOCAL);
			}else if(pckup == 1210){ // AGENCIA DE EMPREGOS
				SetPlayerMapIcon(playerid, i, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 23, -1, MAPICON_LOCAL);
			}else if(pckup == 1274){ // BANCO
				SetPlayerMapIcon(playerid, i, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 52, -1, MAPICON_LOCAL);
			}else if(pckup == 19524){ // HOTEL
				SetPlayerMapIcon(playerid, i, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 35, -1, MAPICON_LOCAL);
			}else if(pckup == 19197){ // PIZZARIA
				SetPlayerMapIcon(playerid, i, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 29, -1, MAPICON_LOCAL);
			}else if(pckup == 19198){ // LANCHONETE
				SetPlayerMapIcon(playerid, i, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"), 10, -1, MAPICON_LOCAL);
			}
		}
	}

    return 1;
}

public OnPlayerDisconnect(playerid, reason){
    KillTimer(tmrclock[playerid]);
	KillTimer(tmrRadar[playerid]);
	KillTimer(tmrKick[playerid]);
	if(Logado[playerid]) SalvarConta(playerid);
	new file[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	DOF2_SetInt(file, "Interior", GetPlayerInterior(playerid));
    
    return 1;
}

public OnPlayerSpawn(playerid){
	new file[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	if(IsPlayerNPC(playerid)) return 1;
	if(death[playerid]){
		death[playerid] = false;
		SetPlayerSkin(playerid, DOF2_GetInt(file, "Skin"));		
		if(GetPlayerMoney(playerid) >= 2500){
			GivePlayerMoney(playerid, -2400);
			SendClientMessage(playerid, -1, "{FFFFFF}=================={FF0000}[HOSPITAL]{FFFFFF}==================");
			SendClientMessage(playerid, -1, "{FFFFFF}Voce ficou inconsciente e foi levado ao hospital mais proximo.");
			SendClientMessage(playerid, -1, "{FFFFFF}Foi retirado $2500 de sua carteira pelos servicos medicos.");
			SendClientMessage(playerid, -1, "{FFFFFF}Voce nao possui um plano de saude.");
			SendClientMessage(playerid, -1, "{FFFFFF}=================={FF0000}[HOSPITAL]{FFFFFF}==================");
		}else{
			if(bankmoney[playerid] >= 2500){
				bankmoney[playerid] = bankmoney[playerid] - 2500
				GivePlayerMoney(playerid, 100);
				SendClientMessage(playerid, -1, "{FFFFFF}=================={FF0000}[HOSPITAL]{FFFFFF}==================");
				SendClientMessage(playerid, -1, "{FFFFFF}Voce ficou inconsciente e foi levado ao hospital mais proximo.");
				SendClientMessage(playerid, -1, "{FFFFFF}Foi retirado $2500 de sua conta pelos servicos medicos.");
				SendClientMessage(playerid, -1, "{FFFFFF}Voce nao possui um plano de saude.");
				SendClientMessage(playerid, -1, "{FFFFFF}=================={FF0000}[HOSPITAL]{FFFFFF}==================");
			}else{
				SendClientMessage(playerid, -1, "{FFFFFF}===================={FF0000}[HOSPITAL]{FFFFFF}====================");
				SendClientMessage(playerid, -1, "{FFFFFF}Voce ficou inconsciente e foi levado ao hospital mais proximo.");
				SendClientMessage(playerid, -1, "{FFFFFF}Voce pagou todo o dinheiro que tinha pelo servicos medicos");
				SendClientMessage(playerid, -1, "{FFFFFF}e esta com o saldo negativo. pague sua divida ou sera procurado. ");
				SendClientMessage(playerid, -1, "{FFFFFF}Voce nao possui um plano de saude.");
				SendClientMessage(playerid, -1, "{FFFFFF}===================={FF0000}[HOSPITAL]{FFFFFF}====================");
				GivePlayerMoney(playerid, -2500);
			}
		}

		if((h1[playerid] < h2[playerid]) || (h1[playerid] < h3[playerid]) || (h1[playerid] < h4[playerid]) || (h1[playerid] < h5[playerid])){
			SetPlayerPos(playerid, 1177.6176,-1323.4061,14.0796);
		}
		else if((h2[playerid] < h1[playerid]) || (h2[playerid] < h3[playerid]) || (h2[playerid] < h4[playerid]) || (h2[playerid] < h5[playerid])){
			SetPlayerPos(playerid, 2029.2397,-1419.3047,16.9922);
		}
		else if((h3[playerid] < h1[playerid]) || (h3[playerid] < h2[playerid]) || (h3[playerid] < h4[playerid]) || (h3[playerid] < h5[playerid])){
			SetPlayerPos(playerid, 624.7316,-493.9832,16.3359);
		}
		else if((h4[playerid] < h1[playerid]) || (h4[playerid] < h2[playerid]) || (h4[playerid] < h3[playerid]) || (h4[playerid] < h5[playerid])){
			SetPlayerPos(playerid, -2666.0039,607.5567,14.4545);
		}
		else if((h5[playerid] < h1[playerid]) || (h5[playerid] < h2[playerid]) || (h5[playerid] < h3[playerid]) || (h5[playerid] < h4[playerid])){
			SetPlayerPos(playerid, 1580.6509,1768.8568,10.8203);	
		}
	}
	new Float:x[MAX_PLAYERS], Float:y[MAX_PLAYERS], Float:z[MAX_PLAYERS];
	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	if(x[playerid] == 0 && y[playerid] == 0 && z[playerid] == 0){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 1481.060546, -1767.387573, 18.795755);
		if(GetPlayerSkin(playerid) == 0) SetPlayerSkin(playerid, 154);
	}
	else {
		SetPlayerInterior(DOF2_GetInt(file, "Interior"));
		SetPlayerPos(playerid, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"));
		SetPlayerSkin(playerid, DOF2_GetInt(file, "Skin"));
	}
	KillTimer(tmrKick[playerid]);
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid){
	new file[128];
	format(file, sizeof(file), "contas/%s.ini", PlayerName(playerid));
		
		if(playertextid == PlayerTD[playerid][14]){ // REGISTRO SENHA
			ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", "{FFFFFF}Digite uma senha", "Aceitar", "Cancelar");
		}
		if(playertextid == PlayerTD[playerid][15]){ // REGISTRO CONFIRMAR SENHA
			ShowPlayerDialog(playerid, DIALOG_CONFREGISTRO, DIALOG_STYLE_PASSWORD, "Registro", "{FFFFFF}Confirme sua senha", "Aceitar", "Cancelar");
		}
		if(playertextid == PlayerTD[playerid][25]){ //CLICK REGISTRAR
			if(DOF2_FileExists(file)) return SendClientMessage(playerid, -1, "{FF0000}[ERRO]{FFFFFF}Essa conta ja foi registrada.");
			if(strcmp(senha, confsenha, false) == 0){
				DestroyInicial(playerid);

				DOF2_CreateFile(file);
				DOF2_SetInt(file, "Level", 0);
				DOF2_SetInt(file, "Exp", 0);
				DOF2_SetInt(file, "Nivel de procurado", 0);
				DOF2_SetInt(file, "Money", 10000);
				DOF2_SetString(file, "Password", senha);
				DOF2_SetFloat(file, "X", 1481.060546);
				DOF2_SetFloat(file, "Y", -1767.387573);
				DOF2_SetFloat(file, "Z", 18.795755);
				DOF2_SetInt(file,"IsVip",0);
				SetPlayerSkin(playerid, 154);
				SetPlayerPos(playerid, 1481.060546, -1767.387573, 18.795755);
				DOF2_SetInt(file, "Skin", GetPlayerSkin(playerid));
				new float:health[MAX_PLAYERS];
				GetPlayerHealth(playerid, health[playerid]);
				DOF2_SetFloat(file, "Vida", health[playerid]);
				DOF2_SetInt(file, "Fome", 100);
				DOF2_SetInt(file, "Sede", 100);
				DOF2_SetInt(file, "Sono", 100);
				
				DOF2_SetInt(file, "HabTerrestre", 0);
				DOF2_SetInt(file, "HabAerea", 0);
				DOF2_SetInt(file, "HabAquatica", 0);
				DOF2_SetInt(file, "MultasT", 0);
				DOF2_SetInt(file, "MultasAr", 0);
				DOF2_SetInt(file, "MultasAq", 0);
				DOF2_SetInt(file, "Radio", 0);
				DOF2_SetString(file, "Emprego", "Nenhum");
				DOF2_SetInt(file, "Salario", 0);
				DOF2_SetInt(file, "Banco", 0);
				DOF2_SaveFile(file);

				//ShowPlayerDialog(playerid, 503, DIALOG_STYLE_MSGBOX, "Registro", "{FFFFFF}Conta criada, digite seu login e senha", "Ok");
				TogglePlayerSpectating(playerid, false);
				SpawnPlayer(playerid);

				GivePlayerMoney(playerid, DOF2_GetInt(file, "Money"));
				SetPlayerPos(playerid, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"), DOF2_GetFloat(file, "Z"));
				SetPlayerSkin(playerid, DOF2_GetInt(file, "Skin"));
				ClearPlayerChat(playerid);
				SendClientMessage(playerid, -1, "{00FF00}Seja bem-vindo ao Phantom Roleplay!");
				SendClientMessage(playerid, -1, "{00FF00}Digite {FF0000}/regras {00FF00}para ver as regras do servidor e {FF0000}/tutorial {00FF00}para saber o basico sobre o servidor.");
				SendClientMessage(playerid, -1, "{00FF00}Caso tenha mais alguma duvida, digite {FF0000}/comandos {00FF00}para ver todos os comandos disponiveis no servidor.");
				Logado[playerid] = true;
				CancelSelectTextDraw(playerid);
				tmrclock[playerid] = SetTimer("UpdateClock", 1000, true);
				KillTimer(tmrKick[playerid]);
				//SpawnPlayer(playerid);
			}else{
				 return SendClientMessage(playerid, -1, "{FF0000}[ERRO]{FFFFFF}As senhas nao coincidem.");
			}
		}
		if(playertextid == PlayerTD[playerid][19]){ //LOGIN SENHA
			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "{FFFFFF}Digite sua senha", "Aceitar", "Cancelar");
		}
		if(playertextid == PlayerTD[playerid][27]){ //CLICK ENTRAR
			if(!DOF2_FileExists(file)) return SendClientMessage(playerid, -1, "{FF0000}[ERRO]{FFFFFF}Conta nao encontrada, tente se registrar");
			if(!strlen(senhalogin)) return SendClientMessage(playerid, -1, "{FF0000}[ERRO]{FFFFFF}Campo nao deve ficar em branco.");
			if(strcmp(senhalogin, DOF2_GetString(file, "Password"), false) == 1) return SendClientMessage(playerid, -1, "{FF0000}[ERRO]{FFFFFF}Senha incorreta");
			
			DestroyInicial(playerid);

			GivePlayerMoney(playerid, DOF2_GetInt(file, "Money"));
			SetPlayerPos(playerid, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"),DOF2_GetFloat(file, "Z"));
			SetPlayerScore(playerid, DOF2_GetInt(file, "Level"));

			TogglePlayerSpectating(playerid, false);
			SpawnPlayer(playerid);
			

			SetPlayerPos(playerid, DOF2_GetFloat(file, "X"), DOF2_GetFloat(file, "Y"),DOF2_GetFloat(file, "Z"));
			SetPlayerScore(playerid, DOF2_GetInt(file, "Level"));
			SetPlayerSkin(playerid, DOF2_GetInt(file, "Skin"));

			ClearPlayerChat(playerid)
			SendClientMessage(playerid, -1, "{00FF00}Seja bem-vindo novamente ao Phantom Roleplay!");
			SendClientMessage(playerid, -1, "{00FF00}Digite {FF0000}/regras {00FF00}para ver as regras do servidor.");
			SendClientMessage(playerid, -1, "{00FF00}Caso tenha mais alguma duvida, digite {FF0000}/comandos {00FF00}para ver todos os comandos disponiveis no servidor.");
			Logado[playerid] = true;
			CancelSelectTextDraw(playerid);
			tmrclock[playerid] = SetTimer("UpdateClock", 1000, true);
			KillTimer(tmrKick[playerid]);
			
		}

	// }
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
    new file[128];
	format(file, sizeof(file), "contas/%s.ini", PlayerName(playerid));
	if(dialogid == DIALOG_REGISTRO){
		if(response == 1){
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", "{FF0000}[ERRO]{FFFFFF}Espaco nao pode ficar em branco\n\n{FFFFFF}Digite uma senha", "Aceitar", "Cancelar");
			format(senha, sizeof(senha), inputtext);
			PlayerTextDrawHide(playerid, PlayerTD[playerid][14]);
			PlayerTextDrawSetString(playerid, PlayerTD[playerid][14], ".........");
			PlayerTextDrawShow(playerid, PlayerTD[playerid][14]);
		}
	}
	if(dialogid == DIALOG_CONFREGISTRO){
		if(response == 1){
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_CONFREGISTRO, DIALOG_STYLE_PASSWORD, "Registro", "{FF0000}[ERRO]{FFFFFF}Espaco nao pode ficar em branco\n\n{FFFFFF}Confirme sua senha", "Aceitar", "Cancelar");
			format(confsenha, sizeof(confsenha), inputtext);
			PlayerTextDrawHide(playerid, PlayerTD[playerid][15]);
			PlayerTextDrawSetString(playerid, PlayerTD[playerid][15], ".........");
			PlayerTextDrawShow(playerid, PlayerTD[playerid][15]);
		}
	}
	if(dialogid == DIALOG_LOGIN){
		if(response == 1){
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "{FF0000}[ERRO]{FFFFFF}Espaco nao pode ficar em branco\n\n{FFFFFF}Digite sua senha", "Aceitar", "Cancelar");
			format(senhalogin, sizeof(senhalogin), inputtext);
			PlayerTextDrawHide(playerid, PlayerTD[playerid][19]);
			PlayerTextDrawSetString(playerid, PlayerTD[playerid][19], ".........");
			PlayerTextDrawShow(playerid, PlayerTD[playerid][19]);
		}
	}
	if(dialogid == DIALOG_PREFEITURA){
		if(response == 1){
			SetTimer("activepref", 5000, false);
			if(listitem == 0){
				ShowPlayerDialog(playerid, DIALOG_LICENCAS, DIALOG_STYLE_TABLIST_HEADERS, "Prefeitura", "Licenca\t\tPreco\nPorte de armas \t{008000}$10000\nExercito\t{008000}$50000\nAeronautica\t{008000}$50000\nMarinha\t{008000}$50000", "Aceitar", "Voltar");
			}if(listitem == 1){
				new price, niveis, actual;
				new msg[128];
				price = 3800;
				niveis = DOF2_GetInt(file, "Nivel de procurado");
				if(niveis > 0){
					if(GetPlayerMoney(playerid) >= niveis*price){
						actual = 0 - niveis * price;
						GivePlayerMoney(playerid, actual);
						format(msg, sizeof(msg), "{00FF00}[PREFEITURA]{FFFFFF}Voce tinha %d niveis de procurado. Voce pagou %d retira-los", niveis, niveis * price);
						DOF2_SetInt(file, "Nivel de procurado", 0);
						SendClientMessage(playerid, -1, msg);
					}else{
						SendClientMessage(playerid, -1, "{FF0000}[PREFEITURA]{FFFFFF}Voce nao tem dinheiro suficiente.");
					}
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[PREFEITURA]{FFFFFF}Voce nao possui niveis de procurado.");
				}
			}
		}
	}
	if(dialogid == DIALOG_LICENCAS){
		if(response == 0){
			ShowPlayerDialog(playerid, DIALOG_PREFEITURA, DIALOG_STYLE_TABLIST, "Prefeitura", "Licencas\nRemover niveis de procurado", "Aceitar", "Cancelar");
		}else{
			if(listitem == 0){
				if(GetPlayerMoney(playerid) >= 10000){
					if(DOF2_GetInt(file, "Exercito") == 0){
						SendClientMessage(playerid, -1, "{00FF00}[PREFEITURA]{FFFFFF}Licenca adiquirida com sucesso.");
						GivePlayerMoney(playerid, -10000);
						DOF2_SetInt(file, "Porte de Armas", 1);
					}else{
						SendClientMessage(playerid, -1, "{FF0000}[PREFEITURA]{FFFFFF}Voce ja possui essa licenca");
						ShowPlayerDialog(playerid, DIALOG_LICENCAS, DIALOG_STYLE_TABLIST_HEADERS, "Prefeitura", "Licenca\t\tPreco\nPorte de armas \t{008000}$10000\nExercito\t{008000}$50000\nAeronautica\t{008000}$50000\nMarinha\t{008000}$50000", "Aceitar", "Voltar");
					}
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[PREFEITURA]{FFFFFF}Voce nao tem dinheiro suficiente.");
					ShowPlayerDialog(playerid, DIALOG_LICENCAS, DIALOG_STYLE_TABLIST_HEADERS, "Prefeitura", "Licenca\t\tPreco\nPorte de armas \t{008000}$10000\nExercito\t{008000}$50000\nAeronautica\t{008000}$50000\nMarinha\t{008000}$50000", "Aceitar", "Voltar");
				}
			}else if(listitem == 1){
				if(GetPlayerMoney(playerid) >= 50000){
					if(DOF2_GetInt(file, "Exercito") == 0){
						SendClientMessage(playerid, -1, "{00FF00}[PREFEITURA]{FFFFFF}Licenca adiquirida com sucesso.");
						GivePlayerMoney(playerid, -50000);
						DOF2_SetInt(file, "Exercito", 1);
					}else{
						SendClientMessage(playerid, -1, "{FF0000}[PREFEITURA]{FFFFFF}Voce ja possui essa licenca");
						ShowPlayerDialog(playerid, DIALOG_LICENCAS, DIALOG_STYLE_TABLIST_HEADERS, "Prefeitura", "Licenca\t\tPreco\nPorte de armas \t{008000}$10000\nExercito\t{008000}$50000\nAeronautica\t{008000}$50000\nMarinha\t{008000}$50000", "Aceitar", "Voltar");
					}
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[PREFEITURA]{FFFFFF}Voce nao tem dinheiro suficiente.");
					ShowPlayerDialog(playerid, DIALOG_LICENCAS, DIALOG_STYLE_TABLIST_HEADERS, "Prefeitura", "Licenca\t\tPreco\nPorte de armas \t{008000}$10000\nExercito\t{008000}$50000\nAeronautica\t{008000}$50000\nMarinha\t{008000}$50000", "Aceitar", "Voltar");
				}
			}else if(listitem == 2){
				if(GetPlayerMoney(playerid) >= 50000){
					if(DOF2_GetInt(file, "Aeronautica") == 0){
						SendClientMessage(playerid, -1, "{00FF00}[PREFEITURA]{FFFFFF}Licenca adiquirida com sucesso.");
						GivePlayerMoney(playerid, -50000);
						DOF2_SetInt(file, "Aeronautica", 1);
					}else{
						SendClientMessage(playerid, -1, "{FF0000}[PREFEITURA]{FFFFFF}Voce ja possui essa licenca");
						ShowPlayerDialog(playerid, DIALOG_LICENCAS, DIALOG_STYLE_TABLIST_HEADERS, "Prefeitura", "Licenca\t\tPreco\nPorte de armas \t{008000}$10000\nExercito\t{008000}$50000\nAeronautica\t{008000}$50000\nMarinha\t{008000}$50000", "Aceitar", "Voltar");
					}
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[PREFEITURA]{FFFFFF}Voce nao tem dinheiro suficiente.");
					ShowPlayerDialog(playerid, DIALOG_LICENCAS, DIALOG_STYLE_TABLIST_HEADERS, "Prefeitura", "Licenca\t\tPreco\nPorte de armas \t{008000}$10000\nExercito\t{008000}$50000\nAeronautica\t{008000}$50000\nMarinha\t{008000}$50000", "Aceitar", "Voltar");
				}
			}else if(listitem == 3){
				if(GetPlayerMoney(playerid) >= 50000){
					if(DOF2_GetInt(file, "Marinha") == 0){
						SendClientMessage(playerid, -1, "{00FF00}[PREFEITURA]{FFFFFF}Licenca adiquirida com sucesso.");
						GivePlayerMoney(playerid, -50000);
						DOF2_SetInt(file, "Marinha", 1);
					}else{
						SendClientMessage(playerid, -1, "{FF0000}[PREFEITURA]{FFFFFF}Voce ja possui essa licenca");
						ShowPlayerDialog(playerid, DIALOG_LICENCAS, DIALOG_STYLE_TABLIST_HEADERS, "Prefeitura", "Licenca\t\tPreco\nPorte de armas \t{008000}$10000\nExercito\t{008000}$50000\nAeronautica\t{008000}$50000\nMarinha\t{008000}$50000", "Aceitar", "Voltar");
					}
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[PREFEITURA]{FFFFFF}Voce nao tem dinheiro suficiente.");
					ShowPlayerDialog(playerid, DIALOG_LICENCAS, DIALOG_STYLE_TABLIST_HEADERS, "Prefeitura", "Licenca\t\tPreco\nPorte de armas \t{008000}$10000\nExercito\t{008000}$50000\nAeronautica\t{008000}$50000\nMarinha\t{008000}$50000", "Aceitar", "Voltar");
				}
			}
		}
	}
	if(dialogid == DIALOG_AGENCIA){
		if(response == 1){
			if(listitem == 0){
				new msg[1000];
				strcat(msg, "Emprego\t {800000}Nivel\t{008000}Salario \n");
				strcat(msg, "Entregador de jornal \t0\t$600\n");
				strcat(msg, "Entregador de pizza\t5\t$900\n");
				strcat(msg, "Caminhoneiro\t10\t$1000\n");
				strcat(msg, "Taxista\t15\t$1000\n");
				strcat(msg, "Leiteiro\t15\t$1150\n");
				strcat(msg, "Correios\t20\t$1250\n");
				strcat(msg, "Mecanico\t30\t$1350\n");
				strcat(msg, "Motorista de Onibus\t40\t$1400\n");
				strcat(msg, "Piloto\t50\t$1500\n");
				ShowPlayerDialog(playerid, DIALOG_CLASSEB, DIALOG_STYLE_TABLIST_HEADERS, "Agencia de empregos", msg, "Aceitar", "Cancelar");
			}
		}
	}
	if(dialogid == DIALOG_CLASSEB){
		if(response == 1){
			if(listitem == 0){
				SendClientMessage(playerid, -1, "{00FF00}[AGENCIA DE EMPREGOS]{FFFFFF}Voce foi aceito na profissao {00FF00}Entregador de jornal{FFFFFF}");
				SendClientMessage(playerid, -1, "{00FF00}[AGENCIA DE EMPREGOS]{FFFFFF}Seu local de trabalho foi marcado no mapa.");
				RemovePlayerMapIcon(playerid, MAP_HQ);
				SetPlayerMapIcon(playerid, MAP_HQ, 784.719726, -1332.507812, 13.541118, 41, -1, MAPICON_GLOBAL);
				DOF2_SetString(file, "Emprego", "Jornal");
				DOF2_SetInt(file, "Salario", 600);
				DOF2_SaveFile(file);
			}
			if(listitem == 1){
				if(GetPlayerScore(playerid) >= 5){
					SendClientMessage(playerid, -1, "{00FF00}[AGENCIA DE EMPREGOS]{FFFFFF}Voce foi aceito na profissao {00FF00}Entregador de pizza{FFFFFF}");
					SendClientMessage(playerid, -1, "{00FF00}[AGENCIA DE EMPREGOS]{FFFFFF}Seu local de trabalho foi marcado no mapa.");
					RemovePlayerMapIcon(playerid, MAP_HQ);
					SetPlayerMapIcon(playerid, MAP_HQ, 2088.197753, -1806.460815, 13.546875, 41, -1, MAPICON_GLOBAL);
					DOF2_SetString(file, "Emprego", "Pizza");
					DOF2_SetInt(file, "Salario", 900);
					DOF2_SaveFile(file);
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[AGENCIA DE EMPREGOS]{FFFFFF}Voce nao tem Level para essa profissao.")
				}
			}if(listitem == 2){
				if(GetPlayerScore(playerid) >= 15){
					SendClientMessage(playerid, -1, "{00FF00}[AGENCIA DE EMPREGOS]{FFFFFF}Voce foi aceito na profissao {00FF00}Caminhoneiro{FFFFFF}");
					SendClientMessage(playerid, -1, "{00FF00}[AGENCIA DE EMPREGOS]{FFFFFF}Seu local de trabalho foi marcado no mapa.");
					RemovePlayerMapIcon(playerid, MAP_HQ);
					SetPlayerMapIcon(playerid, MAP_HQ, 278.221740, 1408.768798, 10.436569, 41, -1, MAPICON_GLOBAL);
					DOF2_SetString(file, "Emprego", "Caminhoneiro");
					DOF2_SetInt(file, "Salario", 1000);
					DOF2_SaveFile(file);
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[AGENCIA DE EMPREGOS]{FFFFFF}Voce nao tem Level para essa profissao.")
				}
			}if(listitem == 3){
				if(GetPlayerScore(playerid) >= 10){
					SendClientMessage(playerid, -1, "{00FF00}[AGENCIA DE EMPREGOS]{FFFFFF}Voce foi aceito na profissao {00FF00}Taxista{FFFFFF}");
					SendClientMessage(playerid, -1, "{00FF00}[AGENCIA DE EMPREGOS]{FFFFFF}Seu local de trabalho foi marcado no mapa.");
					RemovePlayerMapIcon(playerid, MAP_HQ);
					SetPlayerMapIcon(playerid, MAP_HQ, 1807.791015, -1918.288696, 13.565514, 41, -1, MAPICON_GLOBAL);
					DOF2_SetString(file, "Emprego", "Taxista");
					DOF2_SetInt(file, "Salario", 1000);
					DOF2_SaveFile(file);
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[AGENCIA DE EMPREGOS]{FFFFFF}Voce nao tem Level para essa profissao.")
				}
			}
		}
	}
	if(dialogid == DIALOG_AUTO){
		if(response == 1){
			if(listitem == 0){
				if(DOF2_GetInt(file,"HabTerrestre") == 0){
					if(GetPlayerMoney(playerid) < 5000){
						SendClientMessage(playerid, -1, "{FF0000}[AUTO-ESCOLA]Voce nao tem dinheiro suficiente.")
					}else{
						new car;
						GetPlayerPos(playerid, lx[playerid], ly[playerid], lz[playerid]);
						cp[playerid] = 0;
						autoescola[playerid] = true;
						SetPlayerInterior(playerid, 0);
						car = CreateVehicle(451, -2397.8398,-591.9321,132.2160,124.8750,0xFE9E0EFF, 0xFE9E0EFF, -1, 0);
						//CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, 0, 0)
						PutPlayerInVehicle(playerid, car, 0);
						SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA]{FFFFFF}Teste para habilitacao {00FF00}Terrestre{FFFFFF} iniciado");
						SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA]{FFFFFF}Tenha uma boa prova!");
						//SetPlayerRaceCheckpoint(playerid, 0, check[0][0], check[0][1], check[0][2], check[1][0], check[1][1], check[1][2], 3);
						SetPlayerRaceCheckpoint(playerid, 0, -2457.1931,-524.1797,113.5046, -2595.3477,-492.3535,73.9313, 4.0);
						GivePlayerMoney(playerid, -5000);
						DOF2_SetInt(file, "HabTerrestre", 1);
						DOF2_SaveFile(file);
					}
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[AUTO-ESCOLA]Voce ja possui habilitacao Terrestre.")

				}
			}else if(listitem == 1){
				if(DOF2_GetInt(file,"HabAerea") == 0){
					if(GetPlayerMoney(playerid) < 10000){
						SendClientMessage(playerid, -1, "{FF0000}[AUTO-ESCOLA]Voce nao tem dinheiro suficiente.")
					}else{
						new car;
						GetPlayerPos(playerid, lx[playerid], ly[playerid], lz[playerid]);
						cpaereo[playerid] = 0;
						aereo[playerid] = true;
						SetPlayerInterior(playerid, 0);
						car = CreateVehicle(593, 382.1660, 2516.2749, 16.5185, 90.1393,0xFE9E0EFF, 0xFE9E0EFF, -1, 0);
						//CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, 0, 0)
						PutPlayerInVehicle(playerid, car, 0);
						SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA]{FFFFFF}Teste para habilitacao {00FF00}Aerea{FFFFFF} iniciado");
						SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA]{FFFFFF}Tenha uma boa prova!");
						//SetPlayerRaceCheckpoint(playerid, 0, check[0][0], check[0][1], check[0][2], check[1][0], check[1][1], check[1][2], 3);
						SetPlayerRaceCheckpoint(playerid, 0,302.7526,2516.6885,16.6505, 179.1495,2518.4880,24.7020, 4.0);
						GivePlayerMoney(playerid, -10000);
						//DOF2_SetInt(file, "HabAerea", 1);
						DOF2_SaveFile(file);
					}
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[AUTO-ESCOLA]Voce ja possui habilitacao Aerea.")

				}
			}else if(listitem == 2){
				if(DOF2_GetInt(file,"HabAquatica") == 0){
					if(GetPlayerMoney(playerid) < 15000){
						SendClientMessage(playerid, -1, "{FF0000}[AUTO-ESCOLA]Voce nao tem dinheiro suficiente.")
					}else{
						new car;
						GetPlayerPos(playerid, lx[playerid], ly[playerid], lz[playerid]);
						cpaereo[playerid] = 0;
						aquatico[playerid] = true;
						SetPlayerInterior(playerid, 0);
						car = CreateVehicle(452, 154.6822,-1974.0598,-0.1217,179.8800,0xFE9E0EFF, 0xFE9E0EFF, -1, 0);
						//CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, 0, 0)
						PutPlayerInVehicle(playerid, car, 0);
						SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA]{FFFFFF}Teste para habilitacao {00FF00}Maritima{FFFFFF} iniciado");
						SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA]{FFFFFF}Tenha uma boa prova!");
						//SetPlayerRaceCheckpoint(playerid, 0, check[0][0], check[0][1], check[0][2], check[1][0], check[1][1], check[1][2], 3);
						SetPlayerRaceCheckpoint(playerid, 3,155.0404,-2037.5446,-0.2671, 204.3897,-2171.1855,-0.3192, 4.0);
						GivePlayerMoney(playerid, -15000);
						//DOF2_SetInt(file, "HabAerea", 1);
						DOF2_SaveFile(file);
					}
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[AUTO-ESCOLA]Voce ja possui habilitacao Aerea.")

				}
			}
		}
	}
	if(dialogid == DIALOG_DETRAN){
		if(response == 1){
			if(listitem == 0){
				multas[playerid] = DOF2_GetInt(file, "MultasT");
				if(GetPlayerMoney(playerid) >= 2000*multas[playerid]){
					new total[MAX_PLAYERS];
					total[playerid] = 2000*multas[playerid];
					DOF2_SetInt(file, "MultasT", 0);
					new msg[128];
					GivePlayerMoney(playerid, 0 - total[playerid]);
					format(msg, sizeof(msg), "{00FF00}[DETRAN]{FFFFFF}Voce pagou %d multas. total de {00FF00}$%d{FFFFFF}.",multas[playerid], 2000*multas[playerid]);
					SendClientMessage(playerid, -1, msg);
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[DETRAN]{FFFFFF}Voce nao tem dinheiro suficiente.");
				}
			}else if(listitem == 1){
				ShowPlayerDialog(playerid, DIALOG_RENOVARHAB, DIALOG_STYLE_TABLIST_HEADERS, "Detran", "{FFFFFF}\nTerrestre\nAerea\nMaritima", "Aceitar", "Voltar");
			}
		}
	}
	if(dialogid == DIALOG_RENOVARHAB){
		if(response == 1){

		}else if(response == 0){
				new total[MAX_PLAYERS], msg[128];
				multas[playerid] = DOF2_GetInt(file, "MultasT");
				total[playerid] = multas[playerid]*2000;
				
				format(msg, sizeof(msg),"{FF0000}\t\t{008000}\nPagar multas\t\t$%d\nRenovar Habilitacoes" , total);
				ShowPlayerDialog(playerid, DIALOG_DETRAN, DIALOG_STYLE_TABLIST_HEADERS, "Detran", msg, "Aceitar", "Cancelar");

		}
	}
	if(dialogid == DIALOG_NEWSENHA){
		if(response == 1){
			if(!strlen(inputtext)){
				ShowPlayerDialog(playerid, DIALOG_NEWSENHA, DIALOG_STYLE_PASSWORD, "Banco", "{FF0000}[ERRO]{FFFFFF}O espaco nao pode ficar em branco\n{FFFFFF}Digite uma senha para registrar sua conta bancaria", "Aceitar", "Cancelar");
			}else{
				
				format(senha, sizeof(senha), inputtext);
				ShowPlayerDialog(playerid, DIALOG_CONFSENHA, DIALOG_STYLE_PASSWORD, "Banco", "{FFFFFF}Confirme a senha de sua conta bancaria.", "Aceitar", "Cancelar");
				return 1;
			}
		}
	}
	if(dialogid == DIALOG_CONFSENHA){
		if(response == 1){
			if(strlen(inputtext)){
				new str[128]
				format(str, sizeof(str), inputtext);
				if(strcmp(str, senha) == 0){
					DOF2_SetInt(file, "Banco", 1);
					DOF2_SetString(file, "SenhaBanco", str);
					DOF2_SetInt(file, "DinheiroBanco", 0);
					DOF2_SaveFile(file);
					ShowPlayerDialog(playerid, DIALOG_BANCO, DIALOG_STYLE_TABLIST, "Banco", "Depositar\nSacar\nMudar senha\nSaldo", "Aceitar", "Cancelar");
				}else{
					ShowPlayerDialog(playerid, DIALOG_CONFSENHA, DIALOG_STYLE_PASSWORD, "Banco", "{FF0000}[ERRO]{FFFFFF}As senhas nao coincidem\n{FFFFFF}Confirme a senha de sua conta bancaria.", "Aceitar", "Cancelar");
				}
			}else{
				ShowPlayerDialog(playerid, DIALOG_CONFSENHA, DIALOG_STYLE_PASSWORD, "Banco", "{FF0000}[ERRO]{FFFFFF}Campo nao deve ficar em branco\n{FFFFFF}Confirme a senha de sua conta bancaria.", "Aceitar", "Cancelar");
	
			}
		}
	}
	if(dialogid == DIALOG_SENHALOGIN){
		if(response == 1){
			if(strlen(inputtext)){
				if(strcmp(DOF2_GetString(file, "SenhaBanco"), inputtext) == 0){
					ShowPlayerDialog(playerid, DIALOG_BANCO, DIALOG_STYLE_TABLIST, "Banco", "Depositar\nSacar\nMudar senha\nSaldo", "Aceitar", "Cancelar");
				}else{
					ShowPlayerDialog(playerid, DIALOG_SENHALOGIN, DIALOG_STYLE_PASSWORD, "Banco", "{FF0000}[ERRO]{FFFFFF}Senha incorreta\nDigite a senha de sua conta bancaria para continuar.", "Aceitar", "Cancelar");
				}
			}else{
				ShowPlayerDialog(playerid, DIALOG_SENHALOGIN, DIALOG_STYLE_PASSWORD, "Banco", "{FF0000}[ERRO]{FFFFFF}Senha incorreta\nDigite a senha de sua conta bancaria para continuar.", "Aceitar", "Cancelar");
			}
		}
	}
	if(dialogid == DIALOG_BANCO){
		if(response == 1){
			if(listitem == 0){
				ShowPlayerDialog(playerid, DIALOG_DEPOSITO, DIALOG_STYLE_INPUT, "Banco", "Digite a quantia que deseja depositar", "Aceitar", "Voltar");
			}else if(listitem == 1){
				ShowPlayerDialog(playerid, DIALOG_SAQUE, DIALOG_STYLE_INPUT, "Banco", "Digite a quantia que deseja sacar.", "Aceitar", "Voltar");
			}else if(listitem == 2){
				ShowPlayerDialog(playerid, DIALOG_CHANGEPASS, DIALOG_STYLE_PASSWORD, "Banco", "Digite sua nova senha", "Aceitar", "Voltar");
			}else if(listitem == 3){
				new msg[128];
				format(msg, sizeof(msg), "Saldo atual:$%d", DOF2_GetInt(file, "DinheiroBanco"));
				SendClientMessage(playerid, -1, "{FFFFFF}================{00FF00}[BANCO]{FFFFFF}================");
				SendClientMessage(playerid, -1, msg);
				SendClientMessage(playerid, -1, "{FFFFFF}================{00FF00}[BANCO]{FFFFFF}================");

			}
		}
	}
	if(dialogid == DIALOG_DEPOSITO){
		if(response == 1){
			new qtd[MAX_PLAYERS];
			if(sscanf(inputtext, "d", qtd[playerid])){
				ShowPlayerDialog(playerid, DIALOG_DEPOSITO, DIALOG_STYLE_INPUT, "Banco", "{FF0000}[ERRO]{FFFFFF}Utilize apenas numeros.\nDigite a quantia que deseja depositar", "Aceitar", "Voltar");
			}else{
				if(GetPlayerMoney(playerid) >= qtd[playerid]){
					
					bankmoney[playerid] = DOF2_GetInt(file, "DinheiroBanco");
					GivePlayerMoney(playerid, 0 - qtd[playerid]);
					DOF2_SetInt(file, "DinheiroBanco", bankmoney[playerid] + qtd[playerid]);
					SendClientMessage(playerid, -1, "{00FF00}[BANCO]Deposito efetuado com sucesso.");
					ShowPlayerDialog(playerid, DIALOG_BANCO, DIALOG_STYLE_TABLIST, "Banco", "Depositar\nSacar\nMudar senha\nSaldo", "Aceitar", "Cancelar");

				}else{
					ShowPlayerDialog(playerid, DIALOG_DEPOSITO, DIALOG_STYLE_INPUT, "Banco", "{FF0000}[ERRO]{FFFFFF}Voce nao tem dinheiro suficiente.\nDigite a quantia que deseja depositar", "Aceitar", "Voltar");
				}
			}

		}
	}
	if(dialogid == DIALOG_SAQUE){
		if(response == 1){
			new qtd[MAX_PLAYERS];
			if(sscanf(inputtext, "d", qtd[playerid])){
				ShowPlayerDialog(playerid, DIALOG_SAQUE, DIALOG_STYLE_INPUT, "Banco", "{FF0000}[ERRO]{FFFFFF}Utilize apenas numeros.\nDigite a quantia que deseja sacar", "Aceitar", "Voltar");
			}else{
				bankmoney[playerid] = DOF2_GetInt(file, "DinheiroBanco");
				if(bankmoney[playerid] >= qtd[playerid]){
					GivePlayerMoney(playerid, 0 + qtd[playerid]);
					DOF2_SetInt(file, "DinheiroBanco", bankmoney[playerid] - qtd[playerid]);
					SendClientMessage(playerid, -1, "{00FF00}[BANCO]Saque efetuado com sucesso.");
					ShowPlayerDialog(playerid, DIALOG_BANCO, DIALOG_STYLE_TABLIST, "Banco", "Depositar\nSacar\nMudar senha\nSaldo", "Aceitar", "Cancelar");
				}
				
			}

		}
	}
	if(dialogid == DIALOG_CHANGEPASS){
		if(response == 1){
			if(!strlen(inputtext)){
				ShowPlayerDialog(playerid, DIALOG_CHANGEPASS, DIALOG_STYLE_PASSWORD, "Banco", "{FF0000}[ERRO]{FFFFFF}Espaco nao pode ficar em branco.\nDigite sua nova senha", "Aceitar", "Voltar");
			}else{
				DOF2_SetString(file, "SenhaBanco", inputtext);
				SendClientMessage(playerid, -1, "{00FF00}[BANCO]{FFFFFF}Senha da conta bancaria alterada com sucesso.")
			}
		}
	}
	if(dialogid == DIALOG_IMOBILIARIA){
		if(response == 1){
			new file2[128], temcasa[MAX_PLAYERS];
			if(listitem == 0){
				if(GetPlayerMoney(playerid) < 10000) return SendClientMessage(playerid, -1, "{ff0000}[ERRO]{ffffff}Voce nao tem dinheiro suficiente.");
				if(DOF2_GetInt(file, "LicencaCasa") == 1) return SendClientMessage(playerid, -1, "{ff0000}[ERRO]{ffffff}Voce ja possui esta licenca.");
				for(new i = 0; i< MAX_CASAS; i++){
					format(file2, sizeof(file2), CASAS, i);
					if(strcmp(DOF2_GetString(file, "Proprietario"), PlayerName(playerid))){
						temcasa[playerid] = 1;
						i = MAX_CASAS;
					}else{
						temcasa[playerid] = 0;
					}
				}
				if(temcasa[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}[ERRO]{ffffff}Voce ja possui uma propriedade.");
				DOF2_SetInt(file, "LicencaCasa", 1);
				GivePlayerMoney(playerid, -10000);
				SendClientMessage(playerid, -1, "{00ff00}[CASA]{ffffff}Licenca adiquirida.");
			}
		}
	}
    return 1;
}

public OnPlayerRequestClass(playerid, classid){

    return 1;
}

public OnPlayerRequestSpawn(playerid){
	if(IsPlayerNPC(playerid)) return 1;
    return 0;
}

stock PlayerName(playerid){
	new string[MAX_PLAYER_NAME];
	GetPlayerName(playerid, string, sizeof(string));
	return string;

}

public OnPlayerExitVehicle(playerid, vehicleid){
	new file[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	if(autoescola[playerid]){
		DisablePlayerRaceCheckpoint(playerid);
		cp[playerid] = 0;
		autoescola[playerid] = false;
		cpaereo[playerid] = 0;
		aereo[playerid] = false;
		cpagua[playerid] = 0;
		aquatico[playerid]= false;
		SetPlayerPos(playerid, lx[playerid], ly[playerid], lz[playerid]);
		SendClientMessage(playerid, -1, "{FF0000}[AUTO-ESCOLA]{FFFFFF}Voce saiu de seu veiculo, seu teste foi cancelado.")
		DOF2_SaveFile(file);

	}
}

public OnVehicleDeath(vehicleid, killerid){
	if(PizzaT[killerid]){
		if(vehicleid == Pbike[killerid]){
			SendClientMessage(killerid, -1, "{FF0000}[ENTREGADOR DE PIZZA]{FFFFFF}Seus serviços foram cancelados devido a falta de cuidados com o veiculo.");
			DestroyVehicle(Pbike[killerid]);
			Pizzas[killerid] = 0
			PizzaT[killerid] = false;
			DisablePlayerRaceCheckpoint(killerid);
			Delete3DTextLabel(PbikeT[killerid]);
		}else{
			DestroyVehicle(Pbike[killerid]);
			Pizzas[killerid] = 0
			PizzaT[killerid] = false;
			DisablePlayerRaceCheckpoint(killerid);
			Delete3DTextLabel(PbikeT[killerid]);
		}
	}
	if(JornalT[killerid]){
		if(vehicleid == bike1[killerid]){
			SendClientMessage(killerid, -1, "{FF0000}[ENTREGADOR DE JORNAL]{FFFFFF}Seus serviços foram cancelados devido a falta de cuidados com o veiculo.");
			DestroyVehicle(bike1[killerid]);
			jornais[killerid] = 0
			JornalT[killerid] = false;
			DisablePlayerRaceCheckpoint(killerid);
			Delete3DTextLabel(bike2[killerid]);
		}else{
			DestroyVehicle(Pbike[killerid]);
			jornais[killerid] = 0
			JornalT[killerid] = false;
			DisablePlayerRaceCheckpoint(killerid);
			Delete3DTextLabel(bike2[killerid]);
		}
	}
	return 1;
}
stock random2(min,max) // returns a random value, between min and max.
{
    return min + random ( max - min );
}
new Float:casass[][3] = {
	{1336.8339,-1093.7610,23.6418},
	{1467.6663,-889.2573,55.9296},
	{1530.4695,-853.5467,65.4441},
	{1520.3248,-780.0930,77.9428},
	{1497.6917,-704.2638,94.3117},
	{1443.0314,-639.7916,95.2196},
	{1329.1946,-627.4650,108.7064},
	{1094.2853,-643.7815,112.8078},
	{976.8851,-671.5106,120.9702},
	{910.9485,-685.6395,115.5505},
	{803.1732,-1455.8081,13.1147},
	{766.1105,-1565.0377,13.0998},
	{760.7520,-1655.6814,4.1703},
	{922.0576,-1798.7534,13.1469},
	{981.7774,-1809.4949,13.8131},
	{1849.1975,-1923.5748,13.1179},
	{1936.2377,-1924.0403,13.1184},
	{2072.5076,-1717.1624,13.0896},
	{2072.9233,-1643.7172,13.1177},
	{2170.5789,-1615.1101,13.8904},
	{2239.1665,-1644.0488,15.0490},
	{2386.0100,-1723.6201,13.1344},
	{2402.6267,-1722.3495,13.1745},
	{2437.6130,-2016.8002,13.1192},
	{2486.6604,-2016.9469,13.1204},
	{2465.5789,-2000.2388,13.1192},
	{1895.3412,-2060.9880,13.1139},
	{1887.5198,-2000.9437,13.1188},
	{1878.1044,-1983.3345,13.1181},
	{2150.2778,-1446.5647,25.3394}
};

forward casas(playerid);
public casas(playerid){
	new rand, rand2;
	rand = random(sizeof(casass));
	rand2 = random(sizeof(casass));
	
	casax[playerid] = casass[rand][0];
	casay[playerid] = casass[rand][1];
	casaz[playerid] = casass[rand][2];

	nextx[playerid] = casass[rand2][0];
	nexty[playerid] = casass[rand2][1];
	nextz[playerid] = casass[rand2][2];
    return 1; 
}
public OnPlayerEnterRaceCheckpoint(playerid){
	new file[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	if(autoescola[playerid]){
		if(cp[playerid] == 0){
			DisablePlayerRaceCheckpoint(playerid);
			cp[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 0, -2595.3477,-492.3535,73.9313,-2561.2710,-469.3673,68.0980, 4.0);

		}else if(cp[playerid] == 1){
			DisablePlayerRaceCheckpoint(playerid);
			cp[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 0, -2561.2710,-469.3673,68.0980,-2421.6670,-420.1531,85.3575, 4.0);

		}else if(cp[playerid] == 2){
			DisablePlayerRaceCheckpoint(playerid);
			cp[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 0, -2421.6670,-420.1531,85.3575,-2327.2290,-458.8102,79.5880, 4.0);

		}else if(cp[playerid] == 3){
			DisablePlayerRaceCheckpoint(playerid);
			cp[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 0, -2327.2290,-458.8102,79.5880,-2379.7397,-379.0146,75.8489, 4.0);

		}else if(cp[playerid] == 4){
			DisablePlayerRaceCheckpoint(playerid);
			cp[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 0, -2379.7397,-379.0146,75.8489,-2570.8022,-369.7393,49.0720, 4.0);
		}else if(cp[playerid] == 5){
			DisablePlayerRaceCheckpoint(playerid);
			cp[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 0, -2570.8022,-369.7393,49.0720,-2674.7544,-413.2680,32.1486, 4.0);
		}else if(cp[playerid] == 6){
			DisablePlayerRaceCheckpoint(playerid);
			cp[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 0, -2674.7544,-413.2680,32.1486,-2685.9875,-522.7034,16.2413, 4.0);
		}else if(cp[playerid] == 7){
			DisablePlayerRaceCheckpoint(playerid);
			cp[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 0, -2685.9875,-522.7034,16.2413,-2787.6526,-481.7680,7.1875, 4.0);
		}else if(cp[playerid] == 8){
			DisablePlayerRaceCheckpoint(playerid);
			cp[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 0, -2787.6526,-481.7680,7.1875,-2816.5452,-368.6092,7.0313, 4.0);
		}else if(cp[playerid] == 9){
			DisablePlayerRaceCheckpoint(playerid);
			cp[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 0, -2816.5452,-368.6092,7.0313,-2809.7429,-327.5912,7.0313, 4.0);
		}else if(cp[playerid] == 10){
			DisablePlayerRaceCheckpoint(playerid);
			cp[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 0, -2809.7429,-327.5912,7.0313,-2783.9253,-324.4658,7.0391, 4.0);
		}else if(cp[playerid] == 11){
			DisablePlayerRaceCheckpoint(playerid);
			cp[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 0, -2783.9253,-324.4658,7.0391,-2783.8340,-281.4125,7.0391, 4.0);
		}else if(cp[playerid] == 12){
			DisablePlayerRaceCheckpoint(playerid);
			cp[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 1, -2783.8340,-281.4125,7.0391,0,0,0, 4.0);
			SetPlayerInterior(playerid, 3);
			SetPlayerPos(playerid, lx[playerid], ly[playerid], lz[playerid]);
			SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA]{FFFFFF}Teste para habilitacao {00FF00}Terrestre{FFFFFF} concluido");
			SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA]{FFFFFF}Habilitacao terrestre concedida.");
			DOF2_SetInt(file, "HabTerrestre", 1);
			DOF2_SaveFile(file);
		}

	}
	if(aereo[playerid]){
		if(cpaereo[playerid] == 0){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 3,302.7526,2516.6885,16.6505, 179.1495,2518.4880,24.7020, 6.0);

		}
		else if(cpaereo[playerid] == 1){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 3,179.1495,2518.4880,24.7020, -105.3679,2523.2388,83.7783, 6.0);

		}
		else if(cpaereo[playerid] == 2){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 3, -105.3679,2523.2388,83.7783, -497.0988,2686.7759,149.2739, 6.0);
		}
		else if(cpaereo[playerid] == 3){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 3, -497.0988,2686.7759,149.2739, -697.4061,2723.0422,126.3371, 6.0);
		}
		else if(cpaereo[playerid] == 4){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 3, -697.4061,2723.0422,126.3371,-722.0015,2536.9944,125.2083, 6.0);
		}
		else if(cpaereo[playerid] == 5){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 3, -722.0015,2536.9944,125.2083, -948.5345,2529.4983,135.4504, 6.0);
		}
		else if(cpaereo[playerid] == 6){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 3, -948.5345,2529.4983,135.4504, -934.1727,2164.6030,119.9019, 6.0);
		}
		else if(cpaereo[playerid] == 7){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 3, -934.1727,2164.6030,119.9019, -764.0433,2118.0525,103.7352, 6.0);
		}
		else if(cpaereo[playerid] == 8){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 3, -764.0433,2118.0525,103.7352, -648.5529,2124.0476,53.0793, 6.0);
		}
		else if(cpaereo[playerid] == 9){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 3, -648.5529,2124.0476,53.0793, -463.6210,2056.2466,101.5372, 6.0);
		}
		else if(cpaereo[playerid] == 10){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 3, -463.6210,2056.2466,101.5372, -244.1639,2115.4685,83.6868, 6.0);
		}
		else if(cpaereo[playerid] == 11){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 3, -244.1639,2115.4685,83.6868, -155.9245,2266.4561,79.0694, 6.0);
		}
		else if(cpaereo[playerid] == 12){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 3, -155.9245,2266.4561,79.0694, -35.4273,2497.2710,39.0585, 6.0);
		}
		else if(cpaereo[playerid] == 13){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 3, -35.4273,2497.2710,39.0585, 220.8718,2496.8906,16.4844, 6.0);
		}
		else if(cpaereo[playerid] == 14){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 0, 220.8718,2496.8906,16.4844, 348.7738,2497.3438,16.4844, 6.0);

		}else if(cpaereo[playerid] == 15){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid]++
			SetPlayerRaceCheckpoint(playerid, 1, 348.7738,2497.3438,16.4844, 0,0,0, 6.0);

		}else if(cpaereo[playerid] == 16){
			DisablePlayerRaceCheckpoint(playerid);
			cpaereo[playerid] = 0;
			SetPlayerInterior(playerid, 3);
			SetPlayerPos(playerid, lx[playerid], ly[playerid], lz[playerid]);
			SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA]{FFFFFF}Teste para habilitacao {00FF00}Aerea{FFFFFF} concluido");
			SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA]{FFFFFF}Habilitacao Aerea concedida.");
			DOF2_SetInt(file, "HabAerea", 1);
			DOF2_SaveFile(file);
		}
	}
	if(aquatico[playerid]){
		if(cpagua[playerid] == 0){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 155.0404,-2037.5446,-0.2671, 204.3897,-2171.1855,-0.3192, 4.0);
		}else if(cpagua[playerid] == 1){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 204.3897,-2171.1855,-0.3192, 303.0293,-2174.5369,-0.4846, 4.0);
		}else if(cpagua[playerid] == 2){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 303.0293,-2174.5369,-0.4846, 286.0421,-2004.1190,-0.1731, 4.0);
		}else if(cpagua[playerid] == 3){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 286.0421,-2004.1190,-0.1731, 368.9024,-1941.9435,-0.0878, 4.0);
		}else if(cpagua[playerid] == 4){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 368.9024,-1941.9435,-0.0878, 498.4171,-1970.5730,-0.0570, 4.0);
		}else if(cpagua[playerid] == 5){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 498.4171,-1970.5730,-0.0570, 685.5302,-1977.1198,-0.3030, 4.0);
		}else if(cpagua[playerid] == 6){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 685.5302,-1977.1198,-0.3030, 829.4973,-1971.8219,-0.1503, 4.0);
		}else if(cpagua[playerid] == 7){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 829.4973,-1971.8219,-0.1503, 901.3828,-2060.1750,-0.3401, 4.0);
		}else if(cpagua[playerid] == 8){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 901.3828,-2060.1750,-0.3401, 975.9664,-2303.2322,-0.2659, 4.0);
		}else if(cpagua[playerid] == 9){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 975.9664,-2303.2322,-0.2659, 1107.6635,-2437.3018,-0.2651, 4.0);
		}else if(cpagua[playerid] == 10){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 1107.6635,-2437.3018,-0.2651, 1264.3359,-2694.0850,0.1300, 4.0);
		}else if(cpagua[playerid] == 11){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 1264.3359,-2694.0850,0.1300, 1772.1442,-2807.8147,0.0798, 4.0);
		}else if(cpagua[playerid] == 12){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 1772.1442,-2807.8147,0.0798, 2114.7993,-2783.3394,-0.4265, 4.0);
		}else if(cpagua[playerid] == 13){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 2114.7993,-2783.3394,-0.4265, 2315.7451,-2685.4048,0.1728, 4.0);
		}else if(cpagua[playerid] == 14){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 3, 2315.7451,-2685.4048,0.1728, 2355.1067,-2511.8291,-0.1937, 4.0);
		}else if(cpagua[playerid] == 15){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid]++;
			SetPlayerRaceCheckpoint(playerid, 4, 2355.1067,-2511.8291,-0.1937, 0,0,0, 4.0);
		}else if(cpagua[playerid] == 16){
			DisablePlayerRaceCheckpoint(playerid);
			cpagua[playerid] = 0;
			SetPlayerInterior(playerid, 3);
			SetPlayerPos(playerid, lx[playerid], ly[playerid], lz[playerid]);
			SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA]{FFFFFF}Teste para habilitacao {00FF00}Maritima{FFFFFF} concluido");
			SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA]{FFFFFF}Habilitacao Maritima concedida.");
			DOF2_SetInt(file, "HabAquatica", 1);
			DOF2_SaveFile(file);

		}
	}
	if(JornalT[playerid]){
		if(GetPlayerVehicleID(playerid) == bike1[playerid]){
			if(jornais[playerid] > 1){
				new msg[128];
				DisablePlayerRaceCheckpoint(playerid);
				jornais[playerid]--;
				format(msg, sizeof(msg), "{00FF00}[ENTREGADOR DE JORNAIS]{FFFFFF}Voce entregou um jornal, {00FF00}%d {FFFFFF}jornais restantes.", jornais[playerid]);
				casas(playerid);
				GivePlayerMoney(playerid, random2(90, 150));
				SetPlayerRaceCheckpoint(playerid, 1, casax[playerid], casay[playerid], casaz[playerid],nextx[playerid],nexty[playerid],nextz[playerid], 2.0);
				SendClientMessage(playerid, -1, msg);
				new mny;
				mny = random2(50, 110);
				new msg2[128];
				format(msg2, sizeof(msg2), "{00FF00}[ENTREGADOR DE JORNAIS]{FFFFFF}Voce recebeu $%d pela entrega.", mny);
				SendClientMessage(playerid, -1, msg2);
				GivePlayerMoney(playerid, mny);

			}else if(jornais[playerid] == 1){
				new msg[128];
				DisablePlayerRaceCheckpoint(playerid);
				jornais[playerid]--;
				format(msg, sizeof(msg), "{00FF00}[ENTREGADOR DE JORNAIS]{FFFFFF}Voce entregou um jornal, {00FF00}%d {FFFFFF}jornais restantes.", jornais[playerid]);
				casas(playerid);
				
				SetPlayerRaceCheckpoint(playerid, 1, casax[playerid], casay[playerid], casaz[playerid],nextx[playerid],nexty[playerid],nextz[playerid], 2.0);
				SendClientMessage(playerid, -1, msg);
				new mny;
				mny = random2(50, 110);
				new msg2[128];
				format(msg2, sizeof(msg2), "{00FF00}[ENTREGADOR DE JORNAIS]{FFFFFF}Voce recebeu $%d pela entrega.", mny);
				SendClientMessage(playerid, -1, msg2);
				GivePlayerMoney(playerid, mny);
				DisablePlayerRaceCheckpoint(playerid);
				jornais[playerid] = 0;
				JornalT[playerid] = false;
				SendClientMessage(playerid, -1, "{00FF00}[ENTREGADOR DE JORNAIS]{FFFFFF}Voce entregou todos os jornais volte para a hq para pegar mais.");

			}
		}else{
			SendClientMessage(playerid, -1, "{FF0000}[ENTREGADOR DE JORNAIS]{FFFFFF}Voce nao esta em sua bike");
		}

	}
	if(PizzaT[playerid]){
		if(GetPlayerVehicleID(playerid) == Pbike[playerid]){
			if(Pizzas[playerid] > 1){
				DisablePlayerRaceCheckpoint(playerid);
				new msg[128];
				Pizzas[playerid]--;
				format(msg, sizeof(msg), "{00FF00}[ENTREGADOR DE PIZZA]{FFFFFF}Voce entregou uma pizza, {00FF00}%d {FFFFFF}pizzas restantes.", Pizzas[playerid]);
				casas(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, casax[playerid], casay[playerid], casaz[playerid],nextx[playerid],nexty[playerid],nextz[playerid], 2.0);
				SendClientMessage(playerid, -1, msg);
				new mny;
				mny = random2(90, 210);
				new msg2[128];
				format(msg2, sizeof(msg2), "{00FF00}[ENTREGADOR DE PIZZA]{FFFFFF}Voce recebeu $%d pela entrega.", mny);
				SendClientMessage(playerid, -1, msg2);
				GivePlayerMoney(playerid, mny);

			}else if(Pizzas[playerid] == 1){
				DisablePlayerRaceCheckpoint(playerid);
				new msg[128];
				
				Pizzas[playerid]--;
				format(msg, sizeof(msg), "{00FF00}[ENTREGADOR DE PIZZA]{FFFFFF}Voce entregou uma pizza, {00FF00}%d {FFFFFF}pizzas restantes.", Pizzas[playerid]);
				casas(playerid);
				
				SetPlayerRaceCheckpoint(playerid, 1, casax[playerid], casay[playerid], casaz[playerid],nextx[playerid],nexty[playerid],nextz[playerid], 2.0);
				SendClientMessage(playerid, -1, msg);
				new mny;
				mny = random2(90, 210);
				new msg2[128];
				format(msg2, sizeof(msg2), "{00FF00}[ENTREGADOR DE PIZZA]{FFFFFF}Voce recebeu $%d pela entrega.", mny);
				SendClientMessage(playerid, -1, msg2);
				GivePlayerMoney(playerid, mny);
				DisablePlayerRaceCheckpoint(playerid);
				Pizzas[playerid] = 0;
				PizzaT[playerid] = false;
				SendClientMessage(playerid, -1, "{00FF00}[ENTREGADOR DE PIZZA]{FFFFFF}Voce entregou todas as pizzas, volte para a hq para pegar mais.");

			}
		}else{
			SendClientMessage(playerid, -1, "{FF0000}[ENTREGADOR DE PIZZA]{FFFFFF}Voce nao esta em sua moto");
		}

	}
	
	


	return 1;
}

public OnPlayerDeath(playerid, killerid, reason){
	if(autoescola[playerid]){
		DisablePlayerRaceCheckpoint(playerid);
		cp[playerid] = 0;
		autoescola[playerid] = false;
		cpaereo[playerid] = 0;
		aereo[playerid] = false;
		cpagua[playerid] = 0;
		aquatico[playerid]= false;
		SendClientMessage(playerid, -1, "{FF0000}[AUTO-ESCOLA]{FFFFFF}Voce se machucou, seu teste foi cancelado.");

	}
	DisablePlayerRaceCheckpoint(playerid);
	death[playerid] =true;
	jornais[playerid] = 0;
	Pizzas[playerid] = 0;
	JornalT[playerid] = false;
	PizzaT[playerid] = false;
	h1[playerid] = GetPlayerDistanceFromPoint(playerid, 1177.6176,-1323.4061,14.0796);
	h2[playerid] = GetPlayerDistanceFromPoint(playerid, 2029.2397,-1419.3047,16.9922);
	h3[playerid] = GetPlayerDistanceFromPoint(playerid, 624.7316,-493.9832,16.3359);
	h4[playerid] = GetPlayerDistanceFromPoint(playerid, -2666.0039,607.5567,14.4545);
	h5[playerid] = GetPlayerDistanceFromPoint(playerid, 1580.6509,1768.8568,10.8203);
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
	new file[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	if(!IsPlayerNPC(playerid)){
		if((vehicleid == 417) || (vehicleid == 425 ) || (vehicleid == 460 ) || (vehicleid == 469 ) || (vehicleid == 476 ) ||(vehicleid == 417) || (vehicleid == 487 ) || (vehicleid == 497 ) || (vehicleid == 511 ) || (vehicleid == 512 ) || (vehicleid == 513 ) ||(vehicleid == 520  ) ||(vehicleid == 553  ) ||(vehicleid == 563  ) ||(vehicleid == 577  ) ||(vehicleid == 593)){
			if(DOF2_GetInt(file, "HabAerea") == 0){
			SendClientMessage(playerid, -1, "{FF0000} Voce nao possui habilitacao para avioes e veiculos voadores.")
			TogglePlayerControllable(playerid, false);
			TogglePlayerControllable(playerid, true);
			}else{
				onvehicle[playerid] = true;
			}
		}else if((vehicleid == 430 ) || (vehicleid == 446  ) || (vehicleid == 452  ) || (vehicleid == 453  ) || (vehicleid == 454  ) ||(vehicleid == 472 ) || (vehicleid == 473  ) || (vehicleid == 484  ) || (vehicleid == 493  ) || (vehicleid == 539  ) || (vehicleid == 595 )){
			if(DOF2_GetInt(file, "HabAquatica") == 0){
			SendClientMessage(playerid, -1, "{FF0000} Voce nao possui habilitacao para barcos e veiculos aquaticos.")
			TogglePlayerControllable(playerid, false);
			TogglePlayerControllable(playerid, true);
			}else{
				onvehicle[playerid] = true;
			}
		}else if((vehicleid == 510) || (vehicleid == 509) || (vehicleid == 481) || (vehicleid == 509)){
			
		}else{
			if(DOF2_GetInt(file, "HabTerrestre") == 0){
			SendClientMessage(playerid, -1, "{FF0000} Voce nao possui habilitacao para veiculos terrestres.")
			TogglePlayerControllable(playerid, false);
			TogglePlayerControllable(playerid, true);
			}else{
				onvehicle[playerid] = true;
			}
		}
	}
}

forward CheckRadar(playerid);
public CheckRadar(playerid)
{

	new
		Float:PlayerSpeedDistance,
		VelocidadeDoPlayer[MAX_PLAYERS],
		float:ppx,
		float:ppy,
		float:ppz,
		file[128];
	
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	GetVehicleVelocity(GetPlayerVehicleID(playerid), ppx, ppy, ppz);
	PlayerSpeedDistance = floatmul(floatsqroot(floatadd(floatadd(floatpower(ppx, 2), floatpower(ppy, 2)),  floatpower(ppz, 2))), 160.0);
	new spe = floatround(PlayerSpeedDistance * 1);
	VelocidadeDoPlayer[playerid] = spe;
	new vehicle;
	vehicle = GetPlayerVehicleID(playerid);
	if(vehicle > 0){
		if((!vehicle == 481) || (!vehicle == 509) || (!vehicle == 509)){
			for(new i = 0; i < MAX_RADAR; i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 15.0, InfoRadar[i][lPosX],InfoRadar[i][lPosY],InfoRadar[i][lPosZ]))
				{
					if(DOF2_GetInt(file,"HabTerrestre") == 1){
						if(VelocidadeDoPlayer[playerid] > InfoRadar[i][lVelocidade])
						{
							if(gettime() > Variavel[playerid])
							{
						
								DOF2_SetInt(file, "MultasT", DOF2_GetInt(file, "MultasT") + 1);
								Variavel[playerid] = (gettime() + 1);
								new s1[128], s2[128], s3[128], s4[128];
								format(s4, sizeof(s4), "{FF0000}Id do radar: {FFFFFF}%d" , i);
								format(s2, sizeof(s2), "{FF0000}Limite: {FFFFFF}%dKM/h" , InfoRadar[i][lVelocidade]);
								format(s1, sizeof(s1), "{FF0000}Velocidade Registrada: {FFFFFF}%dKM/h", VelocidadeDoPlayer[playerid]);
								format(s3, sizeof(s3), "{FF0000}Multas na CNH: {FFFFFF}%d",  DOF2_GetInt(file, "MultasT"));
								SendClientMessage(playerid, -1, "{FFFFFF}==================== {FF0000}MULTA {FFFFFF}====================");
								SendClientMessage(playerid, -1, "{FF0000}Motivo: {FFFFFF}Excesso de velocidade");
								SendClientMessage(playerid, -1, s4);
								SendClientMessage(playerid, -1, s2);
								SendClientMessage(playerid, -1, s1);
								SendClientMessage(playerid, -1, s3);
								SendClientMessage(playerid, -1, "{FFFFFF}==================== {FF0000}MULTA {FFFFFF}====================");
								
								
								return 1;
							}
						}
					}else{
						Variavel[playerid] = (gettime() + 1);
						new s1[128], s2[128], s3[128];
						format(s2, sizeof(s2), "{FF0000}Id do radar: {FFFFFF}%d" , i);
						format(s1, sizeof(s1), "{FF0000}Voce nao possui habilitacao terrestre" );
						format(s3, sizeof(s3), "{FF0000}e por isso recebeu uma estrela de procurado.");
						SendClientMessage(playerid, -1, "{FFFFFF}==================== {FF0000}MULTA {FFFFFF}====================");
						SendClientMessage(playerid, -1, s2);
						SendClientMessage(playerid, -1, s1);
						SendClientMessage(playerid, -1, s3);
						SendClientMessage(playerid, -1, "{FFFFFF}==================== {FF0000}MULTA {FFFFFF}====================");
						DOF2_SetInt(file, "Nivel de procurado", DOF2_GetInt(file, "Nivel de procurado") + 1);
									
									
						return 1;
					}
				}
			}
		}
	}
	return 1;
}


public OnPlayerUpdate(playerid){
	new file[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	
	if(DOF2_GetInt(file, "MultasT") >= 10){
		SendClientMessage(playerid, -1, "{FFFFFF}==================== {FF0000}MULTA {FFFFFF}====================");
		SendClientMessage(playerid, -1, "{FFFFFF}Voce recebeu 10 multas e por isso perdeu sua habilitacao.");
		SendClientMessage(playerid, -1, "{FFFFFF}Pague suas multas antes de renovar sua CNH.");
		SendClientMessage(playerid, -1, "{FFFFFF}==================== {FF0000}MULTA {FFFFFF}====================");
		DOF2_SetInt(file, "HabTerrestre", 0);
		DOF2_SetInt(file, "MultasT", 9);

	}

	return 1;
}
//funçoes//


//comandos//
CMD:m(playerid, params[]){
    new Float:x[MAX_PLAYERS], Float:y[MAX_PLAYERS], Float:z[MAX_PLAYERS], cor1, cor2;
    GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
    if(sscanf(params, "dd", cor1, cor2)){
    	AddStaticVehicle(522, x[playerid], y[playerid], z[playerid], 0.0, -1, -1);
    	SendClientMessage(playerid, -1, "{00FF00}[MOTO]{FFFFFF}Veiculo criado.");
    }else if(!sscanf(params, "dd", cor1, cor2)){
    	AddStaticVehicle(522, x[playerid], y[playerid], z[playerid], 0.0, cor1, cor2);
    	SendClientMessage(playerid, -1, "{00FF00}[MOTO]{FFFFFF}Veiculo criado.");
    }
    else return SendClientMessage(playerid, -1, "{FF0000}[MOTO]{FFFFFF}Digite: /m ou /m [cor1] [cor2]");

    return 1;
}


CMD:cores(playerid, params[]){

	SendClientMessage(playerid, WHITE, "=============CORES=============");
	SendClientMessage(playerid, AZUL, "AZUL");
	SendClientMessage(playerid, VERMELHO, "VERMELHO");
	SendClientMessage(playerid, VERDE, "VERDE");
	SendClientMessage(playerid, VERDE_CLARO, "VERDE CLARO");
	SendClientMessage(playerid, WHITE, "BRANCO");
	SendClientMessage(playerid, AMARELO, "AMARELO");
	SendClientMessage(playerid, LARANJA, "LARANJA");
	SendClientMessage(playerid, AQUA, "AQUA");
	SendClientMessage(playerid, CYAN, "CIANO");
	SendClientMessage(playerid, ROXO, "ROXO");
	SendClientMessage(playerid, ROSA, "ROSA");
	SendClientMessage(playerid, PINK, "PINK");
	SendClientMessage(playerid, BLACK, "PRETO");
	SendClientMessage(playerid, WHITE, "=============CORES=============");
	

	return 1;
	
}
CMD:spawnplayer(playerid, params[]){
	SpawnPlayer(playerid);
	return 1;
}
CMD:tp(playerid, params[]){
	new Float:x, Float:y, Float:z;
	if(sscanf(params, "fff", x, y, z)) return SendClientMessage(playerid, -1, "{ff0000}[ERRO]{FFFFFF}Digite: /tp [x] [y] [z]");
	SetPlayerPos(playerid, x, y, z);
	SendClientMessage(playerid, -1, "{00ff00}[TELEPORTE]{FFFFFF}Teleportado com sucesso");
	return 1;
}
CMD:j(playerid, params[]){
	SendClientMessage(playerid, -1, "{00FF00}[JETPACK]{FFFFFF}Jetpack concedida.");
	SetPlayerSpecialAction (playerid, SPECIAL_ACTION_USEJETPACK);
	return 1;
}
CMD:pegarjornal(playerid, params[]){
	new file[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	new Float:offset;
	offset = 5.0;
	new Float:x, Float:y, Float:z;
	if((GetPlayerVehicleID(playerid) == bike1[playerid])){
		if(strcmp(DOF2_GetString(file, "Emprego"), "Jornal", false) == 0){
			if(!IsPlayerInRangeOfPoint(playerid, 65.0, 784.958679, -1336.407470, 13.541410)) return SendClientMessage(playerid, -1, "{00FF00}[ENTREGADOR DE JORNAL]{FFFFFF}Voce nao esta na sua HQ.");
		}else{
			return SendClientMessage(playerid, -1, "{00FF00}[ERRO]{FFFFFF}Voce nao trabalha como entregador de jornal.");
		}
	}else{
		return SendClientMessage(playerid, -1, "{00FF00}[ERRO]{FFFFFF}Voce nao esta em sua bike");

	}
	jornais[playerid] = 15;
	JornalT[playerid] = true;
	casas(playerid);
	SetPlayerRaceCheckpoint(playerid, 0, casax[playerid], casay[playerid], casaz[playerid],nextx[playerid],nexty[playerid],nextz[playerid], 2.0);
	SendClientMessage(playerid, -1, "{00FF00}[ENTREGADOR DE JORNAL]{FFFFFF}Voce pegou {800000}15 {FFFFFF}Jornais, va ate as localizacoes no mapa para entrega-los");
	return 1;
}

CMD:pegarpizza(playerid, params[]){
	if(Pizzas[playerid] == 0){
		DisablePlayerCheckpoint(playerid);
		new file[128];
		format(file, sizeof(file), CONTAS, PlayerName(playerid));
		new Float:offset;
		offset = 5.0;
		new Float:x, Float:y, Float:z;
		if(GetPlayerVehicleID(playerid) == Pbike[playerid]){
			if(strcmp(DOF2_GetString(file, "Emprego"), "Pizza", false) == 0){
				if(!IsPlayerInRangeOfPoint(playerid, 25.0, 2112.431152, -1775.801391, 13.391513)) return SendClientMessage(playerid, -1, "{00FF00}[ENTREGADOR DE PIZZA]{FFFFFF}Voce nao esta na sua HQ.");
			}else{
				return SendClientMessage(playerid, -1, "{00FF00}[ERRO]{FFFFFF}Voce nao trabalha como entregador de pizza.");
			}
		}else{
			return SendClientMessage(playerid, -1, "{00FF00}[ERRO]{FFFFFF}Voce nao esta em sua moto");

		}
		Pizzas[playerid] = 15;
		PizzaT[playerid] = true;
		casas(playerid);
		SetPlayerRaceCheckpoint(playerid, 0, casax[playerid], casay[playerid], casaz[playerid],nextx[playerid],nexty[playerid],nextz[playerid], 2.0);
		SendClientMessage(playerid, -1, "{00FF00}[ENTREGADOR DE PIZZA]{FFFFFF}Voce pegou {800000}15 {FFFFFF}Pizzas, va ate as localizaçoes no mapa para entrega-las");
	}else{
		SendClientMessage(playerid, -1, "{FF0000}[ENTREGADOR DE PIZZA]{FFFFFF}Voce ainda tem pizzas para entregar.");
	}
	return 1;
}
CMD:createhotel(playerid, params[]){
		new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
		format(file, sizeof(file), ORGS, OrgsID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
		pckp = 1277;
		Governo[OrgsID] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Hotel\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
		GovernoT[OrgsID] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);
		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Pickup",pckp);
		DOF2_SetFloat(file,"X" , x[playerid]);
		DOF2_SetFloat(file,"Y" , y[playerid]);
		DOF2_SetFloat(file,"Z" , z[playerid]);
		DOF2_SaveFile(file);
		OrgsID++;
		SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
		return 1;
}
CMD:createpizza(playerid, params[]){
		new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
		format(file, sizeof(file), ORGS, OrgsID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
		pckp = 19197;
		Governo[OrgsID]  = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Pizzaria\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
		GovernoT[OrgsID]  = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);


		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Pickup",pckp);
		DOF2_SetFloat(file,"X" , x[playerid]);
		DOF2_SetFloat(file,"Y" , y[playerid]);
		DOF2_SetFloat(file,"Z" , z[playerid]);
		DOF2_SaveFile(file);
		OrgsID++;
		SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
		return 1;
}
CMD:createlanche(playerid, params[]){
		new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
		format(file, sizeof(file), ORGS, OrgsID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
		pckp = 19198;
		Governo[OrgsID] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Lanchonete\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
		GovernoT[OrgsID] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Pickup",pckp);
		DOF2_SetFloat(file,"X" , x[playerid]);
		DOF2_SetFloat(file,"Y" , y[playerid]);
		DOF2_SetFloat(file,"Z" , z[playerid]);
		DOF2_SaveFile(file);
		OrgsID++;
		SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
		return 1;
}
CMD:spawn(playerid, params[]){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 1481.060546, -1767.387573, 18.795755);
		SendClientMessage(playerid, -1, "{00FF00}Teleportado com sucesso para o spawn.");
		return 1;
}
CMD:createsaida(playerid, params[]){
		new file[128],pckp, nome[128],type, float:x[10000], float:y[10000], float:z[10000];
		if(sscanf(params, "d", type)) return SendClientMessage(playerid, -1, "{FF0000}[ERRO] {FFFFFF}Digite: /createsaida [0 = dp / 1 = prefeitura / 2 = Agencia / 3 = detran / 4 = Auto-escola / 5 = banco / 6 = hotel / 7 = lanchonete / 8 = pizzaria / 9 = casa / 10 = ammunation / 11 = skin / 12 = restaurante / 13 = 24/7 / 14 = imobiliaria]");

		format(file, sizeof(file), SAIDAS, SaidasID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);


		pckp = 1239;
		s[SaidasID] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Detran\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
		s2[SaidasID] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);



		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Tipo", type);
		DOF2_SetFloat(file, "X", x[playerid]);
		DOF2_SetFloat(file, "Y", y[playerid]);
		DOF2_SetFloat(file, "Z", z[playerid]);
		DOF2_SaveFile(file);
		SaidasID ++;
		return 1;
}
CMD:ppos(playerid, params[]){
	new Float:x, Float:y, Float:z, Float:rot, interior;
	new msg[150];
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, rot);
	interior = GetPlayerInterior(playerid);
	format(msg, sizeof(msg), "{ffffff}X:{ff0000}%f {ffffff}Y:{ff0000}%f {ffffff}Z:{ff0000}%f {ffffff}R:{ff0000}%f {ffffff}I:{ff0000}%d ", x,y,z,rot,interior);
	SendClientMessage(playerid, -1, msg);
	
	return 1;
}

CMD:createdp(playerid, params[]){
		new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
		format(file, sizeof(file), ORGS, OrgsID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
		pckp = 1247;
		Governo[OrgsID] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Delegacia de Policia\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
		GovernoT[OrgsID] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Pickup",pckp);
		DOF2_SetFloat(file,"X" , x[playerid]);
		DOF2_SetFloat(file,"Y" , y[playerid]);
		DOF2_SetFloat(file,"Z" , z[playerid]);
		DOF2_SaveFile(file);

		OrgsID++;
		SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
		
		return 1;
}
CMD:createprefeitura(playerid, params[]){
		new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
		format(file, sizeof(file), ORGS, OrgsID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
		pckp = 1212;
		Governo[OrgsID] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Prefeitura\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
		GovernoT[OrgsID] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Pickup",pckp);
		DOF2_SetFloat(file,"X" , x[playerid]);
		DOF2_SetFloat(file,"Y" , y[playerid]);
		DOF2_SetFloat(file,"Z" , z[playerid]);
		DOF2_SaveFile(file);
		
		OrgsID++;
		SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
		return 1;
}
CMD:createae(playerid, params[]){
		new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
		format(file, sizeof(file), ORGS, OrgsID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
		pckp = 1210;
		Governo[OrgsID] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Agencia de Empregos\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
		GovernoT[OrgsID] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

		
		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Pickup",pckp);
		DOF2_SetFloat(file,"X" , x[playerid]);
		DOF2_SetFloat(file,"Y" , y[playerid]);
		DOF2_SetFloat(file,"Z" , z[playerid]);
		DOF2_SaveFile(file);
		OrgsID++;
		SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
		return 1;
}
CMD:createdetran(playerid, params[]){
	    new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
		format(file, sizeof(file), ORGS, OrgsID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
		pckp = 1239;
		Governo[OrgsID] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Detran\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
		GovernoT[OrgsID]= Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Pickup",pckp);
		DOF2_SetFloat(file,"X" , x[playerid]);
		DOF2_SetFloat(file,"Y" , y[playerid]);
		DOF2_SetFloat(file,"Z" , z[playerid]);
		DOF2_SaveFile(file);

		OrgsID++;
		SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
		return 1;
}
CMD:createauto(playerid, params[]){
		new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
		format(file, sizeof(file), ORGS, OrgsID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
		pckp = 1581;
		Governo[OrgsID] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Auto-Escola\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
		GovernoT[OrgsID] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Pickup",pckp);
		DOF2_SetFloat(file,"X" , x[playerid]);
		DOF2_SetFloat(file,"Y" , y[playerid]);
		DOF2_SetFloat(file,"Z" , z[playerid]);
		DOF2_SaveFile(file);
		OrgsID++;
		SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
		return 1;
}
CMD:createbank(playerid, params[]){
		new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
		format(file, sizeof(file), ORGS, OrgsID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
		pckp = 1274;
		Governo[OrgsID] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Banco\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
		GovernoT[OrgsID] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Pickup",pckp);
		DOF2_SetFloat(file,"X" , x[playerid]);
		DOF2_SetFloat(file,"Y" , y[playerid]);
		DOF2_SetFloat(file,"Z" , z[playerid]);
		DOF2_SaveFile(file);
		
		OrgsID++;
		SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
		return 1;
}
CMD:sethab(playerid, params[]){
	new file[128], param[MAX_PLAYERS];
	if(sscanf(params, "d", param[playerid])) return SendClientMessage(playerid, -1, "{ff0000}[ERRO]{ffffff}Digite:/sethab 0 ou 1");
	if(param[playerid] > 1) return SendClientMessage(playerid, -1, "{ff0000}[ERRO]{ffffff}Digite:/sethab 0 ou 1");
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	DOF2_SetInt(file, "HabTerrestre", param[playerid]);
	SendClientMessage(playerid, -1, "{00FF00}[HABILITACAO]{FFFFFF}Habilitacao alterada com sucesso.");

	return 1;
}
CMD:createcasa(playerid, params[]){
	new Float:x[MAX_PLAYERS], Float:y[MAX_PLAYERS], Float:z[MAX_PLAYERS], file[128], preco;
	format(file, sizeof(file), CASAS, CasasID);
	if(sscanf(params, "d", preco)) return SendClientMessage(playerid, -1, "{ff0000}[ERRO]{FFFFFF}Digite: /createcasa [preco]");
	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	DOF2_CreateFile(file);
	DOF2_SetString(file, "Proprietario", "Ninguem");
	DOF2_SetInt(file, "Upgrade", 0);
	DOF2_SetString(file, "Senha","");
	DOF2_SetInt(file, "Trancada", 0);
	DOF2_SetInt(file, "Lixos", 0);
	DOF2_SetFloat(file, "X", x[playerid]);
	DOF2_SetFloat(file, "Y", y[playerid]);
	DOF2_SetFloat(file, "Z", z[playerid]);
	DOF2_SetInt(file, "Preco", preco);
	DOF2_SaveFile(file);

	Casas[CasasID] = CreatePickup(19522, 1, x[playerid], y[playerid], z[playerid], 0);
	new msg[128];
	format(msg, sizeof(msg), "{ffffff}Casa de: {1010ff}Ninguem\n{ffffff}ID:{1010ff}%d\n{008000}$%d\n\n{ffffff}Pressione \"F\" para entrar.", PlayerName(playerid), CasasID, DOF2_GetInt(file, "Preco"));
	CasasT[CasasID] = Create3DTextLabel(msg, -1, x[playerid], y[playerid], z[playerid], 25.0, 0);
	SendClientMessage(playerid, -1, "{00FF00}[CASAS]{ffffff}Propriedade criada com sucesso.");
	CasasID++;

	return 1;
}
CMD:createemp(playerid, params[]){
	new Float:x[MAX_PLAYERS], Float:y[MAX_PLAYERS], Float:z[MAX_PLAYERS], file[128], preco;
	format(file, sizeof(file), EMPRESAS, EmpresasID);
	if(sscanf(params, "dd", preco)) return SendClientMessage(playerid, -1, "{ff0000}[ERRO]{FFFFFF}Digite: /createemp [preco] [0 = 24/7 | 1 = Ammu-Nation | 2 = rc | 3 = Restaurante]");
	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	DOF2_CreateFile(file);
	DOF2_SetString(file, "Proprietario", "Ninguem");
	DOF2_SetInt(file, "Tipo", 0);
	DOF2_SetFloat(file, "X", x[playerid]);
	DOF2_SetFloat(file, "Y", y[playerid]);
	DOF2_SetFloat(file, "Z", z[playerid]);
	DOF2_SetInt(file, "Preco", preco);
	DOF2_SaveFile(file);

	Empresa[EmpresasID] = CreatePickup(19522, 1, x[playerid], y[playerid], z[playerid], 0);
	new msg[128];
	format(msg, sizeof(msg), "{ffffff}Empresa de: {1010ff}%s\n{ffffff}ID:{1010ff}%d\n{008000}$%d\n\n{ffffff}Pressione \"F\" para entrar.", PlayerName(playerid), EmpresasID, DOF2_GetInt(file, "Preco"));
	EmpresaT[EmpresasID] = Create3DTextLabel(msg, -1, x[playerid], y[playerid], z[playerid], 50.0, 0);
	SendClientMessage(playerid, -1, "{00FF00}[EMPRESAS]{ffffff}Empresas criada com sucesso.");
	EmpresasID++;

	return 1;
}
CMD:setinterior(playerid, params[]){
	new file[128], interior;
	if(sscanf(params, "d", interior)) return SendClientMessage(playerid, -1, "{ff0000}[ERRO]{ffffff}Digite: /setinterior [id do interior]");
	SetPlayerInterior(playerid, interior);
	SendClientMessage(playerid, -1, "{00ff00}[INTERIOR]{ffffff}Interior alterado com sucesso!");

	return 1;
}
CMD:createimo(playerid, params[]){
		new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
		format(file, sizeof(file), ORGS, OrgsID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
		pckp = 19524;
		Governo[OrgsID] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Imobiliaria\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
		GovernoT[OrgsID] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Pickup",pckp);
		DOF2_SetFloat(file,"X" , x[playerid]);
		DOF2_SetFloat(file,"Y" , y[playerid]);
		DOF2_SetFloat(file,"Z" , z[playerid]);
		DOF2_SaveFile(file);
		OrgsID++;
		SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
		return 1;
}
CMD:comprarcasa(playerid, params[]){
	new file[128], file2[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	for(new i = 0; i < MAX_CASAS; i++){
		format(file2, sizeof(file2), CASAS, i);
		if(!IsPlayerInRangeOfPoint(playerid, DOF2_GetFloat(file2, "X"), DOF2_GetFloat(file2, "Y"), DOF2_GetFloat(file2, "Z"))) return SendClientMessage(playerid, -1, "{ff0000}[ERRO]{ffffff}Voce nao esta proximo de uma casa.");
		if(DOF2_GetInt(file, "LicencaCasa") == 0) return SendClientMessage(playerid, -1, "{ff0000}[ERRO]{ffffff}Voce nao possui uma licenca, va ate a imobiliaria e compre uma");
		if(strcmp(DOF2_GetString(file2, "Proprietario"), "Ninguem")) return SendClientMessage(playerid, -1, "{ff0000}[ERRO]{ffffff}Esta propriedade ja tem dono.");
		//if(strcmp(DOF2_GetString(file2, "Proprietario"), PlayerName(playerid) == 0)) return SendClientMessage(playerid, -1, "{FF0000}[ERRO]{FFFFFF}Esta propriedade ja e sua.");
		if(GetPlayerMoney(playerid) < DOF2_GetInt(file2, "Preco")) return SendClientMessage(playerid, -1, "{FF0000}[ERRO]{FFFFFF}Voce nao tem dinheiro suficiente.");
		DestroyPickup(Casas[i]);
		Delete3DTextLabel(CasasT[i]);
		Casas[CasasID] = CreatePickup(19522, 1, DOF2_GetFloat(file2, "X"), DOF2_GetFloat(file2, "Y"), DOF2_GetFloat(file2, "Z"), 0);
		new msg[128];
		format(msg, sizeof(msg), "{ffffff}Casa de: {1010ff}%s\n{ffffff}ID:%d\n\n{ffffff}Pressione \"F\" para entrar.", PlayerName(playerid), i);
		CasasT[CasasID] = Create3DTextLabel(msg, -1, DOF2_GetFloat(file2, "X"), DOF2_GetFloat(file2, "Y"), DOF2_GetFloat(file2, "Z"), 25.0, 0);
		SendClientMessage(playerid, -1, "{00ff00}[CASA]{ffffff}Propriedade adquirida com sucesso.");
		DOF2_SetInt(file, "LicencaCasa", 0);
		DOF2_GetString(file2, "Proprietario", PlayerName(playerid));
	}

	return 1;
}
//comandos//




