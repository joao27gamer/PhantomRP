

#include <a_samp>
#include <DOF2>
#include <sscanf>
#include <core>
#include <float>
#include <string>
#include <file>
#include <time>
#include <datagram>
#include <a_players>
#include <a_npc>
#include <a_vehicles>
#include <a_objects>
#include <a_sampdb>
#include <zcmd>
#include <streamer>

#define MAX_ORGS 50
#define MAX_SAIDAS 50
#define ORGS "Governo/%d.ini"
#define SAIDAS "Saidas/%d.ini"
#define CONTAS "contas/%s.ini"

#define DIALOG_MECANICO 200



#define DIALOG_PREFEITURA 201
#define DIALOG_LICENCAS 202




#define DIALOG_AGENCIA 203

#define DIALOG_CLASSEB 204
#define DIALOG_CLASSEM 205
#define DIALOG_CLASSEA 206
#define DIALOG_MILITAR 207



#define DIALOG_AUTO 208



#define DIALOG_DETRAN 209

#define DIALOG_RENOVARHAB 210



#define DIALOG_NEWSENHA 211
#define DIALOG_CONFSENHA 212

#define DIALOG_SENHALOGIN 213

#define DIALOG_BANCO 214
#define DIALOG_DEPOSITO 215
#define DIALOG_SAQUE 216
#define DIALOG_CHANGEPASS 217
#define DIALOG_CAMINHONEIRO 218




#define MAP_HQ 0

enum eOrgs{
	pickup,
	saida,
	float:posx,
	float:posy,
	float:posz,
	texto,
	txtsaida

}
enum eSaidas{
	pickup,
	float:posx,
	float:posy,
	float:posz,
	texto

}
new float:lastx[MAX_PLAYERS],float:lasty[MAX_PLAYERS],float:lastz[MAX_PLAYERS];
new float:lx[MAX_PLAYERS],float:ly[MAX_PLAYERS],float:lz[MAX_PLAYERS];
new org[MAX_ORGS][eOrgs];
new s[MAX_SAIDAS][eSaidas];
new OrgsID;
new SaidasID;
new mp3[MAX_PLAYERS];
new senha[128];
new actPref, actBank, actDetran, actPolice, actAE, actAuto;
new actPrefT, actBankT, actDetranT, actPoliceT, actAET, actAutoT;
new actPrefT2, actBankT2, actDetranT2, actPoliceT2, actAET2, actAutoT2;

new pckPrefT, pckBankT, pckDetranT, pckPoliceT, pckAET, pckAutoT;
new pckPrefT2, pckBankT2, pckDetranT2, pckPoliceT2, pckAET2, pckAutoT2;

new pckpPizza, pckpPizzaT;

new profJornal, profPizza;
new profJornal2, profPizza2;


new inpref[MAX_PLAYERS];
new bool:mecanico[MAX_PLAYERS]
new bool:pref[MAX_PLAYERS];

new timerJornal;

new timerOrgs, timerSaida, timerRecupS, timerRecupOrgs;

new Float:casax[MAX_PLAYERS], Float:casay[MAX_PLAYERS], Float:casaz[MAX_PLAYERS];
new Float:nextx[MAX_PLAYERS], Float:nexty[MAX_PLAYERS], Float:nextz[MAX_PLAYERS];
new jornais[MAX_PLAYERS], bool:JornalT[MAX_PLAYERS];
new Pizzas[MAX_PLAYERS], bool:PizzaT[MAX_PLAYERS];

new cp[MAX_PLAYERS], bool:autoescola[MAX_PLAYERS],bool:aereo[MAX_PLAYERS],cpaereo[MAX_PLAYERS],bool:aquatico[MAX_PLAYERS],cpagua[MAX_PLAYERS],bool:Caminhao[MAX_PLAYERS],bool:mssn[MAX_PLAYERS];
new trailer[MAX_PLAYERS], dest[MAX_PLAYERS];
new timerCmnh[MAX_PLAYERS];
new CaminhaoT[MAX_PLAYERS], CaminhaoT2[MAX_PLAYERS];
new abcd;

forward activateOrgs(playerid);
public activateOrgs(playerid){
	timerOrgs = SetTimer("CheckOrgs", 50, true);
}

forward activateSaidas(playerid);
public activateSaidas(playerid){
	timerSaida = SetTimer("CheckSaidas", 50, true);
}

forward activateProfs(playerid);
public activateProfs(playerid){
	timerJornal = SetTimer("CheckProfs", 100, true);
}

forward CheckOrgs(playerid);
public CheckOrgs(playerid){
	new Keys, ud, lr, file[128];
    GetPlayerKeys ( playerid, Keys, ud, lr ) ;
	new interiorID = GetPlayerInterior(playerid);


	for(new i = 0; i < MAX_ORGS; i++)
	{
		new float:x[10000], float:y[10000], float:z[10000];
		new msg[128];
		format(file, sizeof(file), ORGS, i);

		if(IsPlayerInRangeOfPoint(playerid, 5.0, org[i][posx],org[i][posy],org[i][posz])){
			if(Keys == KEY_SECONDARY_ATTACK){
				GetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
				if(DOF2_GetInt(file, "Pickup") == 1247){
					DOF2_SetInt(file, "Interior", 6);
					SetPlayerInterior(playerid, 6);
					SetPlayerPos(playerid, 246.783996,63.900199,1003.640625);
					//SendClientMessage(playerid, -1, "{00FF00}[DELEGACIA] {FFFFFF}Voce entrou na delegacia.");
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);
					
				}else if(DOF2_GetInt(file, "Pickup") == 1212){
					inpref[playerid] = 1;
					DOF2_SetInt(file, "Interior", 3);
					SetPlayerInterior(playerid, 3);
					SetPlayerPos(playerid, 384.808624,173.804992,1008.382812);
					//SendClientMessage(playerid, -1, "{00FF00}[PREFEITURA] {FFFFFF}Voce entrou na prefeitura.");
					SetTimer("CheckPref", 1000, true);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);

				}else if(DOF2_GetInt(file, "Pickup") == 1210){
					DOF2_SetInt(file, "Interior", 10);
					SetPlayerInterior(playerid, 10);
					SetPlayerPos(playerid, 246.375991,109.245994,1003.218750);
					//SendClientMessage(playerid, -1, "{00FF00}[AGENCIA DE EMPREGOS] {FFFFFF}Voce entrou na agencia de empregos.");
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);

				}else if(DOF2_GetInt(file, "Pickup") == 1239){
					SetPlayerInterior(playerid, 3);
					DOF2_SetInt(file, "Interior", 3);
					SetPlayerPos(playerid, 833.269775,10.588416,1004.179687);
					//SendClientMessage(playerid, -1, "{00FF00}[DETRAN] {FFFFFF}Voce entrou no detran.");
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);

				}else if(DOF2_GetInt(file, "Pickup") == 1581){
					SetPlayerInterior(playerid, 3);
					DOF2_SetInt(file, "Interior", 3);
					SetPlayerPos(playerid, 1494.325195,1304.942871,1093.289062);
					//SendClientMessage(playerid, -1, "{00FF00}[AUTO-ESCOLA] {FFFFFF}Voce entrou na auto-escola.");
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);

				}else if(DOF2_GetInt(file, "Pickup") == 1274){
					DOF2_SetInt(file, "Interior", 3);
					//SendClientMessage(playerid, -1, "{00FF00}[BANCO] {FFFFFF}Voce entrou no banco.");
					SetPlayerInterior(playerid, 3);
					SetPlayerPos(playerid, 288.745971,169.350997,1007.171875);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);
				}else if(DOF2_GetInt(file, "Pickup") == 19524){
					DOF2_SetInt(file, "Interior", 15);
					//SendClientMessage(playerid, -1, "{00FF00}[HOTEL] {FFFFFF}Voce entrou no hotel.");
					SetPlayerInterior(playerid, 15);
					SetPlayerPos(playerid, 2215.454833, -1147.475585,1025.796875);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);
				}else if(DOF2_GetInt(file, "Pickup") == 19197){
					DOF2_SetInt(file, "Interior", 5);
					//SendClientMessage(playerid, -1, "{00FF00}[PIZZA] {FFFFFF}Voce entrou na pizzaria.");
					SetPlayerInterior(playerid, 5);
					SetPlayerPos(playerid, 373.825653, -117.270904,1001.499511);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);
				}else if(DOF2_GetInt(file, "Pickup") == 19198){
					DOF2_SetInt(file, "Interior", 10);
					//SendClientMessage(playerid, -1, "{00FF00}[BURGUER-SHOT] {FFFFFF}Voce entrou no Burguer Shot.");
					SetPlayerInterior(playerid, 10);
					SetPlayerPos(playerid, 375.962463, -65.816848,1001.507812);
					KillTimer(timerSaida);
					SetTimer("activateSaidas", 5000, false);
				}
			}
		}
		
		
	   

	}
}

forward updateactor(playerid);
public updateactor(playerid){
	SetActorPos(actPref, 359.713165, 173.581893, 1008.389343);
	return 1;
}

new multas[MAX_PLAYERS];
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
		}

	return 1;
}
forward CheckSaidas(playerid);
public CheckSaidas(playerid){
	new Keys, ud, lr, file[128],MSG[128];
	new msgg[128]
	new interiorID = GetPlayerInterior(playerid);
    GetPlayerKeys ( playerid, Keys, ud, lr ) ;
	for(new i = 0;i < MAX_SAIDAS; i++){
		format(file, sizeof(file), SAIDAS, i);
		s[i][posx] = DOF2_GetFloat(file, "X");
		s[i][posy] = DOF2_GetFloat(file, "Y");
		s[i][posz] = DOF2_GetFloat(file, "Z");
		if(IsPlayerInRangeOfPoint(playerid, 3.0, s[i][posx], s[i][posy], s[i][posz])){
			if(Keys == KEY_SECONDARY_ATTACK){
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

			}
		}
	}
	return 1;
}

forward CheckHQs(playerid);
public CheckHQs(playerid){
	new Keys, ud, lr, file[128];
    GetPlayerKeys ( playerid, Keys, ud, lr ) ;
	if(IsPlayerInRangeOfPoint(playerid, 10.0, 784.719726, -1332.507812, 13.541118)){
		RemovePlayerMapIcon(playerid, MAP_HQ);

	}if(IsPlayerInRangeOfPoint(playerid, 10.0, 2088.197753, -1806.460815, 13.546875)){
		RemovePlayerMapIcon(playerid, MAP_HQ);
		
	}if(IsPlayerInRangeOfPoint(playerid, 10.0, 278.221740, 1408.768798, 10.436569)){
		RemovePlayerMapIcon(playerid, MAP_HQ);
	}
	return 1;
}


new bike1, bike2, bike3, bike4, bike5, bike6, bike7, bike8, bike9, bike10;

new Pbike[MAX_PLAYERS], PbikeT[MAX_PLAYERS];
new Taxi[MAX_PLAYERS], TaxiT[MAX_PLAYERS];

new pckptaxi,pckptaxiT;

new bool:Taxista[MAX_PLAYERS], bool:taximetro[MAX_PLAYERS];
new cmnh[MAX_PLAYERS], CmnhT, CmnhT2;
stock Float:GetDistance(Float:x1,Float:y1,Float:z1, Float:x2,Float:y2,Float:z2)
{
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}
new reward[MAX_PLAYERS];
forward CheckProfs(playerid);
public CheckProfs(playerid){
	
	new file[128];
	new Keys, ud, lr;
    GetPlayerKeys ( playerid, Keys, ud, lr ) ;
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 278.221740, 1408.768798, 10.436569)){
		if(Keys == KEY_YES){
			if(strcmp(DOF2_GetString(file, "Emprego"), "Caminhoneiro", false) == 0){
					new msg[1000], fmt[128], Float:price, ret;
					price = 0.82;
					new distance, str[128];
					strcat(msg, "Localizacao\tDistancia\tRetorno\n");
					format(fmt, sizeof(fmt), "Los Santos\t45.7Km\t$%d\n", floatround(floatmul(GetDistance(2739.409423, -2465.345214, 13.648437,278.221740, 1408.768798, 10.436569), price), ret));
					strcat(msg, fmt);	
					format(fmt, sizeof(fmt), "Las Venturas\t12.7Km\t$%d\n", floatround(floatmul(GetDistance(1469.189453, 1029.842895, 10.257703, 278.221740, 1408.768798, 10.436569), price), ret));
					strcat(msg, fmt);
					format(fmt, sizeof(fmt), "San Fierro\t23.6Km\t$%d", floatround(floatmul(GetDistance(-1745.754272, 163.085037, 3.549555, 278.221740, 1408.768798, 10.436569), price), ret));
					strcat(msg, fmt);
					ShowPlayerDialog(playerid, DIALOG_CAMINHONEIRO, DIALOG_STYLE_TABLIST_HEADERS, "Caminhoneiro", msg, "Aceitar", "Cancelar");
			}else{
				SendClientMessage(playerid, -1, "{FF0000}[ERRO]{FFFFFF}Voce nao e desta profissao");
				KillTimer(timerJornal);
				SetTimer("activateProfs", 5000, false);
			}
		}
	}

	if(IsPlayerInRangeOfPoint(playerid, 5.0, 2122.837402, -1784.188720, 13.387416)){
		if(Keys == KEY_YES){
			if(strcmp(DOF2_GetString(file, "Emprego"), "Pizza", false) == 0){
				new msg[128];

				format(msg, sizeof(msg), "Veiculo de {101080}%s", PlayerName(playerid));

				Pbike[playerid] = CreateVehicle(448, 2100.746826, -1784.611694, 12.969348, 16.112672, 3,3, -1);
				PbikeT[playerid] = Text3D:Create3DTextLabel(msg, -1, 2100.746826, -1784.611694, 12.969348, 100, 0);
				Attach3DTextLabelToVehicle(PbikeT[playerid], Pbike[playerid], 0.0, 0.0, 0.0);
				GivePlayerMoney(playerid, -250);
				SendClientMessage(playerid, -1, "{00FF00}[ENTREGADOR DE PIZZA]{FFFFFF}Seu veiculo esta estacionado ao lado da pizzaria, digite /pegarpizza para fazer as entregas");
				SendClientMessage(playerid, -1, "{00FF00}[ENTREGADOR DE PIZZA]{FFFFFF}Foi descontado $250 de seu dinheiro pelo aluguel do veiculo.");
			}else{
				SendClientMessage(playerid, -1, "{FF0000}[ERRO]{FFFFFF}Voce nao e desta profissao");
			}
		}
	}if(IsPlayerInRangeOfPoint(playerid, 5.0, 1807.791015, -1918.288696, 13.565514)){
		if(Keys == KEY_YES){
			if(strcmp(DOF2_GetString(file, "Emprego"), "Taxista", false) == 0){
				new msg[128];

				format(msg, sizeof(msg), "Veiculo de {101080}%s", PlayerName(playerid));

				Taxi[playerid] = CreateVehicle(448, 1803.201904, -1933.708984, 13.385871, 90.0 , 3,3, -1);
				TaxiT[playerid] = Text3D:Create3DTextLabel(msg, -1, 1803.201904, -1933.708984, 13.385871, 100, 0);
				Attach3DTextLabelToVehicle(TaxiT[playerid], Taxi[playerid], 0.0, 0.0, 0.0);
				GivePlayerMoney(playerid, -250);
				SendClientMessage(playerid, -1, "{00FF00}[TAXISTA]{FFFFFF}Seu veiculo esta estacionado, digite /localizar [id do player] para pegar o passageiro e /taximetro para cobrar");
				SendClientMessage(playerid, -1, "{00FF00}[TAXISTA]{FFFFFF}Foi descontado $250 de seu dinheiro pelo aluguel do veiculo.");
			}else{
				SendClientMessage(playerid, -1, "{FF0000}[ERRO]{FFFFFF}Voce nao e desta profissao");
			}
		}
	}

	return 1;
}
new Onibus1;
public OnFilterScriptInit()
{
	new file[128];
	for(new i = 0; i < MAX_ORGS; i++){
		format(file, sizeof(file), ORGS, i);
		if(DOF2_FileExists(file)){
			new nome[128], sd[128];
			org[i][posx] = DOF2_GetFloat(file, "X");
			org[i][posy] = DOF2_GetFloat(file, "Y");
			org[i][posz] = DOF2_GetFloat(file, "Z");
			org[i][pickup] = CreatePickup(DOF2_GetInt(file, "Pickup"), 1, org[i][posx], org[i][posy], org[i][posz], 0);

			format(sd, sizeof(sd), "Pressione \"F\" ou \"ENTER\" para sair.");

			if(DOF2_GetInt(file, "Pickup") == 1247){
				format(nome, sizeof(nome), "{FF8000}Delegacia de Policia\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
				org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, org[i][posx], org[i][posy], org[i][posz], 10.0, 0);
				
				
			}else if(DOF2_GetInt(file, "Pickup") == 1212){
				format(nome, sizeof(nome), "{FF8000}Prefeitura\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
				org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, org[i][posx], org[i][posy], org[i][posz], 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Pickup") == 1210){
				format(nome, sizeof(nome), "{FF8000}Agencia de Empregos\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
				org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, org[i][posx], org[i][posy], org[i][posz], 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Pickup") == 1239){
				format(nome, sizeof(nome), "{FF8000}Detran\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
				org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, org[i][posx], org[i][posy], org[i][posz], 10.0, 0);
			

			}else if(DOF2_GetInt(file, "Pickup") == 1581){
				format(nome, sizeof(nome), "{FF8000}Auto-Escola\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
				org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, org[i][posx], org[i][posy], org[i][posz], 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Pickup") == 1274){
				format(nome, sizeof(nome), "{FF8000}Banco\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
				org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, org[i][posx], org[i][posy], org[i][posz], 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Pickup") == 19524){
				format(nome, sizeof(nome), "{FF8000}Hotel\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
				org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, org[i][posx], org[i][posy], org[i][posz], 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Pickup") == 19197){
				format(nome, sizeof(nome), "{FF8000}Pizzaria\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
				org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, org[i][posx], org[i][posy], org[i][posz], 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Pickup") == 19198){
				format(nome, sizeof(nome), "{FF8000}Lanchonete\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
				org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, org[i][posx], org[i][posy], org[i][posz], 10.0, 0);
				

			}
			OrgsID = i+1;
		}else{

		}
		
	}
		printf("====================[GOVERNO]====================");
		printf(" ");
		printf("         %d lugares publicos carregados.         ", OrgsID);
		printf(" ");
		printf("====================[GOVERNO]====================");

	for(new i = 0; i < MAX_SAIDAS; i++){
		format(file, sizeof(file), SAIDAS, i);
		if(DOF2_FileExists(file)){
			new nome[128], sd[128];
			s[i][posx] = DOF2_GetFloat(file, "X");
			s[i][posy] = DOF2_GetFloat(file, "Y");
			s[i][posz] = DOF2_GetFloat(file, "Z");
			s[i][pickup] = CreatePickup(1239, 1, s[i][posx], s[i][posy], s[i][posz], 0);

			format(sd, sizeof(sd), "Pressione \"F\" ou \"ENTER\" para sair.");

			if(DOF2_GetInt(file, "Tipo") == 0){
				format(nome, sizeof(nome), "{FF8000}Delegacia de Policia\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[SaidasID][texto] = Text3D:Create3DTextLabel(nome, -1, s[i][posx], s[i][posy], s[i][posz], 10.0, 0);
				
				
			}else if(DOF2_GetInt(file, "Tipo") == 1){
				format(nome, sizeof(nome), "{FF8000}Prefeitura\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[SaidasID][texto] = Text3D:Create3DTextLabel(nome, -1, s[i][posx], s[i][posy], s[i][posz], 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 2){
				format(nome, sizeof(nome), "{FF8000}Agencia de Empregos\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[SaidasID][texto] = Text3D:Create3DTextLabel(nome, -1, s[i][posx], s[i][posy], s[i][posz], 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 3){
				format(nome, sizeof(nome), "{FF8000}Detran\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[SaidasID][texto] = Text3D:Create3DTextLabel(nome, -1, s[i][posx], s[i][posy], s[i][posz], 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 4){
				format(nome, sizeof(nome), "{FF8000}Auto-Escola\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[SaidasID][texto] = Text3D:Create3DTextLabel(nome, -1, s[i][posx], s[i][posy], s[i][posz], 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 5){
				format(nome, sizeof(nome), "{FF8000}Banco\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[SaidasID][texto] = Text3D:Create3DTextLabel(nome, -1, s[i][posx], s[i][posy], s[i][posz], 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 6){
				format(nome, sizeof(nome), "{FF8000}Hotel\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[SaidasID][texto] = Text3D:Create3DTextLabel(nome, -1, s[i][posx], s[i][posy], s[i][posz], 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 7){
				format(nome, sizeof(nome), "{FF8000}Pizzaria\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[SaidasID][texto] = Text3D:Create3DTextLabel(nome, -1, s[i][posx], s[i][posy], s[i][posz], 10.0, 0);
				

			}else if(DOF2_GetInt(file, "Tipo") == 8){
				format(nome, sizeof(nome), "{FF8000}Lanchonete\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
				s[SaidasID][texto] = Text3D:Create3DTextLabel(nome, -1, s[i][posx], s[i][posy], s[i][posz], 10.0, 0);
				

			}
			SaidasID = i+1;
		}else{

		}
	}

	

	timerOrgs = SetTimer("CheckOrgs", 200, true);
	timerSaida = SetTimer("CheckSaidas", 200, true);
	SetTimer("CheckPref", 100, true);
	SetTimer("CheckHQs", 100, true);
	timerJornal = SetTimer("CheckProfs", 100, true);

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

	new mecanicopckp, mecanicoT;
	mecanicopckp = CreatePickup(1239, 1, 2525.472167, -1952.905029, 12.046875, 0);
	mecanicoT = Text3D:Create3DTextLabel("{FF8000}Mecanico\n {FFFFFF}Pressione \"Y\"", -1, 2525.472167, -1952.905029, 12.046875, 50.0, 0);


	profJornal = CreatePickup(1210, 1, 784.719726, -1332.507812, 13.541118, 0);
	profJornal2= Text3D:Create3DTextLabel("{FF8000}Entregador de jornal\n {FFFFFF}Digite /profissao", -1, 784.719726, -1332.507812, 13.541118, 20.0, 0);

	profPizza = CreatePickup(1210, 1, 2088.197753, -1806.460815, 13.54687, 0);
	profPizza2= Text3D:Create3DTextLabel("{FF8000}Entregador de Pizza\n {FFFFFF}Digite /profissao", -1, 2088.197753, -1806.460815, 13.54687, 20.0, 0);

	CmnhT = CreatePickup(1239, 1, 278.221740, 1408.768798, 10.436569, 0);
	CmnhT2 = Text3D:Create3DTextLabel("{FF8000}Caminhoneiro\n {FFFFFF}Pressione \"Y\"", -1, 278.221740, 1408.768798, 10.436569, 10.0, 0);

	pckpPizza = CreatePickup(1239, 1, 2122.837402, -1784.188720, 13.387416, 0);
	pckpPizzaT = Text3D:Create3DTextLabel("{FF8000}Entregador de pizza\n {FFFFFF}Pressione \"Y\"", -1, 2122.837402, -1784.188720, 13.387416, 10.0, 0);

	pckptaxi = CreatePickup(1239, 1, 1807.791015, -1918.288696, 13.565514, 0);
	pckptaxiT = Text3D:Create3DTextLabel("{FF8000}Taxista\n {FFFFFF}Pressione \"Y\"", -1, 1807.791015, -1918.288696, 13.565514, 10.0, 0);
	

	//actPref = CreateDynamicActor(141, 359.721221, 193.555374, 1008.389343, 268.450744, 1, 100.0, -1, 3);
	actPref = CreateActor(141, 359.713165, 173.581893, 1008.389343, 268.450744);
	actAE = CreateActor(17, 246.313308, 120.393333, 1003.269287, 180.82184);
	actAuto = CreateActor(186, 1488.823486, 1305.642944, 1093.296386, 274.037017);
	actDetran = CreateActor(187, 294.243011, 182.129043, 1007.171875, 154.441696);
	actBank = CreateActor(295, 2318.0, -7.246706, 26.742187, 90.433349);


	SetActorVirtualWorld(actPref, 0);
	SetActorInvulnerable(actPref, true);
	ApplyActorAnimation(actPref, "PED","SEAT_IDLE", 4.0, 1, 0, 0, 0, 0);
	SetActorInvulnerable(actBank, true);

	SetTimer("updateactor", 100, true);


	new Float:offset;
	offset = 5.0;
	new Float:x, Float:y, Float:z;
	x = 784.958679;
	y = -1336.407470;
	z = 13.541410;

	
	bike1 = CreateVehicle(510, 784.958679, -1336.407470, 13.541410, 90.0, 0, 0, 1800000);
	bike2 = CreateVehicle(510, 784.958679, -1340.407470, 13.541410, 90.0, 0, 0, 1800000);
	bike3 = CreateVehicle(510, 784.958679, -1345.407470, 13.541410, 90.0, 0, 0, 1800000);
	bike4 = CreateVehicle(510, 784.958679, -1350.407470, 13.541410, 90.0, 0, 0, 1800000);
	bike5 = CreateVehicle(510, 784.958679, -1355.407470, 13.541410, 90.0, 0, 0, 1800000);
	bike6 = CreateVehicle(510, 784.958679, -1360.407470, 13.541410, 90.0, 0, 0, 1800000);
	bike7 = CreateVehicle(510, 784.958679, -1365.407470, 13.541410, 90.0, 0, 0, 1800000);
	bike8 = CreateVehicle(510, 784.958679, -1370.407470, 13.541410, 90.0, 0, 0, 1800000);
	bike9 = CreateVehicle(510, 784.958679, -1375.407470, 13.541410, 90.0, 0, 0, 1800000);
	bike10 = CreateVehicle(510, 784.958679, -1380.407470, 13.541410, 90.0, 0, 0, 1800000);

	//300.562438, 1337.873657, 10.425979, 280.0



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
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	if(IsPlayerNPC(playerid)) //Verifica se o jogador é um NPC.
  	{
    	new npcname[MAX_PLAYER_NAME];
    	GetPlayerName(playerid, npcname, sizeof(npcname)); //Obtendo o nome do(s) NPC(s).
    	if(!strcmp(npcname, "test", true)) //Checando se o nome do NPC é MeuPrimeiroNPC
    	{
			SpawnPlayer(playerid);
    		PutPlayerInVehicle(playerid, Onibus1, 0); //Colocar o NPC dentro do veículo que criamos para isso.	
		  
    	}
    	return 1;
  	}
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/audiomsg");
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	new file[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	DisablePlayerCheckpoint(playerid);
	Delete3DTextLabel(PbikeT[playerid]);
	DestroyVehicle(Pbike[playerid]);
	DestroyVehicle(trailer[playerid]);
	DestroyVehicle(cmnh[playerid]);
	Caminhao[playerid] = false;
	KillTimer(timerCmnh[playerid]);
	dest[playerid] = 0;
	reward[playerid] = 0;
	Pizzas[playerid] = 0
	PizzaT[playerid] = false;
	
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	
	return 0;
}

stock PlayerName(playerid){
	new string[MAX_PLAYER_NAME];
	GetPlayerName(playerid, string, sizeof(string));
	return string;

}
new bankmoney[MAX_PLAYERS];

public OnPlayerSpawn(playerid){
	new file[128];
	format(file, sizeof(file), "Contas/%s.ini", PlayerName(playerid));
//Outras coisas para os jogadores normais vai aqui!
	if(IsPlayerNPC(playerid)) PutPlayerInVehicle(playerid, Onibus1, 0);
	if(DOF2_FileExists(file)){
		//bankmoney[playerid] = DOF2_GetInt(file, "DinheiroBanco");
		SetPlayerInterior(playerid, DOF2_GetInt(file, "Interior"));
		SetPlayerPos(playerid, DOF2_GetFloat(file, "PosX"),DOF2_GetFloat(file, "PosY"), DOF2_GetFloat(file, "PosZ"));
	}else{
		//DOF2_SetInt(file, "DinheiroBanco", 0);
		SetPlayerPos(playerid,1481.060546,-1767.387573,18.795755);
	}
	
	return 1;

}

forward activemec(playerid);
public activemec(playerid){
	mecanico[playerid] = false;
}
forward activepref(playerid);
public activepref(playerid){
	pref[playerid] = false;
}

forward CaminhaoTrailer(playerid);
public CaminhaoTrailer(playerid){
	if(Caminhao[playerid]){
			if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == trailer[playerid]){
				if(dest[playerid] == 0){
					SendClientMessage(playerid, -1, "{00FF00}[CAMINHONEIRO]{FFFFFF}Carga engatada va ate o checkpoint em {00FF00}Los Santos {FFFFFF}e entregue-a");
					DisablePlayerCheckpoint(playerid);
					SetPlayerCheckpoint(playerid, 2739.409423, -2465.345214, 13.648437, 4.0);
					dest[playerid] = 0;
					//Delete3DTextLabel(CaminhaoT[playerid]);
					
					KillTimer(timerCmnh[playerid]);
					
				}else if(dest[playerid] == 1){
					SendClientMessage(playerid, -1, "{00FF00}[CAMINHONEIRO]{FFFFFF}Carga engatada va ate o checkpoint em {00FF00}Las Venturas {FFFFFF} e entregue-a");
					DisablePlayerCheckpoint(playerid);
					SetPlayerCheckpoint(playerid, 1469.189453, 1029.842895, 10.257703, 4.0);
					dest[playerid] = 1;
					//Delete3DTextLabel(CaminhaoT[playerid]);
					KillTimer(timerCmnh[playerid]);
				}else if(dest[playerid] == 2){
					SendClientMessage(playerid, -1, "{00FF00}[CAMINHONEIRO]{FFFFFF}Carga engatada va ate o checkpoint em {00FF00}San fierro {FFFFFF} e entregue-a");
					DisablePlayerCheckpoint(playerid);
					SetPlayerCheckpoint(playerid, -1745.754272, 163.085037, 3.549555, 4.0);
					dest[playerid] = 2;
					//
					KillTimer(timerCmnh[playerid]);
				}
			}
		
	}
	return 1;
}
stock IsVehicleInWater(vehicleid)
{
        new Float:water_areas[][] =
        {
                {25.0,  2313.0, -1417.0,        23.0},
                {15.0,  1280.0, -773.0,         1082.0},
                {15.0,  1279.0, -804.0,         86.0},
                {20.0,  1094.0, -674.0,         111.0},
                {26.0,  194.0,  -1232.0,        76.0},
                {25.0,  2583.0, 2385.0,         15.0},
                {25.0,  225.0,  -1187.0,        73.0},
                {50.0,  1973.0, -1198.0,        17.0}
        };
        for(new t=0; t < sizeof water_areas; t++)
        if(GetVehicleDistanceFromPoint(vehicleid,water_areas[t][1],water_areas[t][2],water_areas[t][3]) <= water_areas[t][0]) return 1;
    return 0;
}

public OnVehicleDeath(vehicleid, killerid){
		if(vehicleid == cmnh[killerid]){
			DisablePlayerCheckpoint(killerid);
			Delete3DTextLabel(CaminhaoT[killerid]);
			DestroyVehicle(trailer[killerid]);
			DestroyVehicle(cmnh[killerid]);
			Caminhao[killerid] = false;
			KillTimer(timerCmnh[killerid]);
			dest[killerid] = 0;
			reward[killerid] = 0;
			SendClientMessage(killerid, -1, "{FF0000}[CAMINHONEIRO]{FFFFFF}Seus servicos foram cancelados, devido a falta de cuidado com a mercadoria.");
		}else{
			DisablePlayerCheckpoint(killerid);
			Delete3DTextLabel(CaminhaoT[killerid]);
			DestroyVehicle(trailer[killerid]);
			DestroyVehicle(cmnh[killerid]);
			Caminhao[killerid] = false;
			KillTimer(timerCmnh[killerid]);
			dest[killerid] = 0;
			reward[killerid] = 0;
		}

		if(vehicleid == Pbike[killerid]){
			DisablePlayerRaceCheckpoint(killerid);
			DestroyVehicle(Pbike[killerid]);
			Delete3DTextLabel(PbikeT[killerid]);
			Pizzas[killerid] = 0;
			PizzaT[killerid] = false;
			SendClientMessage(killerid, -1, "{FF0000}[ENTREGADOR DE PIZZA]{FFFFFF}Seus Serviços foram cancelados pois seu veiculo foi destruido.");
		}else{

		}
		
	return 1;
}
new bool:d[MAX_PLAYERS];
public OnPlayerUpdate(playerid){
	new interiorID = GetPlayerInterior(playerid);
	new Keys, ud, lr, file[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	GetPlayerKeys(playerid, Keys, ud, lr);
		if(IsPlayerInRangeOfPoint(playerid, 15.0, 2525.472167, -1952.905029, 12.046875)){
			if(IsPlayerInAnyVehicle(playerid)){
				if(Keys == KEY_YES){
					//SetPlayerCheckpoint(playerid, 2525.472167, -1952.905029, 12.046875, 3.0);
					//mecanico[playerid] = true;
					ShowPlayerDialog(playerid, DIALOG_MECANICO, DIALOG_STYLE_TABLIST, "Oficina", "Consertar veiculo \t $100\nInstalar Hidraulica \t $1500\nRadio MP3 \t $10000\nGrave\t$25000\nTurbo\t1000", "Aceitar", "Cancelar");
				}
			}
		}
	

	new Float:health[MAX_PLAYERS];
	GetVehicleHealth(trailer[playerid], health[playerid])
	
	//361.727951, 173.565216, 1008.382812
	
	if(!IsPlayerInAnyVehicle(playerid)){
		StopAudioStreamForPlayer(playerid);
	}


	if(strcmp(DOF2_GetString(file, "Emprego"), "Jornal")){
		SetPlayerColor(playerid, 0xC5E6EDFF);
	}else if(strcmp(DOF2_GetString(file, "Emprego"), "Pizza")){
		SetPlayerColor(playerid, 0xFF8000FF);
	}else if(strcmp(DOF2_GetString(file, "Emprego"), "Caminhoneiro")){
		SetPlayerColor(playerid, 0x804000FF);
	}

	

	return 1;
}

public OnPlayerEnterCheckpoint(playerid){
	if(Caminhao[playerid]){
		if(GetPlayerVehicleID(playerid) == cmnh[playerid]){
			if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))){
				if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == trailer[playerid]){
					new msg[128];
					DisablePlayerCheckpoint(playerid);
					GivePlayerMoney(playerid, reward[playerid]);
					DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
					DestroyVehicle(trailer[playerid]);
					format(msg, sizeof(msg), "{00FF00}[CAMINHONEIRO]{FFFFFF}Carga entregue com sucesso. Voce ganhou $%d pela entrega.", reward[playerid]);
					SendClientMessage(playerid, -1, msg);
					Delete3DTextLabel(CaminhaoT[playerid]);
					Caminhao[playerid] = false;
					KillTimer(timerCmnh[playerid]);
					dest[playerid] = 0;
					reward[playerid] = 0;
					mssn[playerid] = true;
				}else{
				SendClientMessage(playerid, -1, "{FF0000}[CAMINHONEIRO]{FFFFFF}Carga nao engatada.");
				}
			}else{
				SendClientMessage(playerid, -1, "{FF0000}[CAMINHONEIRO]{FFFFFF}Carga nao engatada.");
			}
		}else{
			SendClientMessage(playerid, -1, "{FF0000}[CAMINHONEIRO]{FFFFFF}Voce nao esta em seu veiculo.");
		}
	}
	return 1;
}
new tmrTaxi[MAX_PLAYERS], id[MAX_PLAYERS], precotaxi[MAX_PLAYERS];

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	new file[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	if(dialogid == DIALOG_MECANICO){
		if(response == 1){
			SetTimer("activemec", 5000, false);
			if(listitem == 0){
				if(GetPlayerMoney(playerid) >= 100){
				SetVehicleHealth(GetPlayerVehicleID(playerid), 1000);
				GivePlayerMoney(playerid, -100);
				SendClientMessage(playerid, -1, "{00FF00}[MECANICO]Voce pagou $100 ao mecanico e consertou seu veiculo.");
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[MECANICO]Voce nao tem dinheiro suficiente");
				}
			}else if(listitem == 1){
				if(GetPlayerMoney(playerid) >= 1500){
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1070);
				GivePlayerMoney(playerid, -1500);
				SendClientMessage(playerid, -1, "{00FF00}[MECANICO]Voce pagou $1500 ao mecanico e Instalou Hidraulica no seu veiculo.");
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[MECANICO]Voce nao tem dinheiro suficiente");
				}
			}else if(listitem == 2){
				if(GetPlayerMoney(playerid) >= 10000){
				DOF2_SetInt(file, "Radio", 1);
				DOF2_SaveFile(file);
				GivePlayerMoney(playerid, -10000);
				SendClientMessage(playerid, -1, "{00FF00}[MECANICO]Voce pagou $10000 ao mecanico e Instalou Radio MP3 no seu veiculo, digite /playradio para ouvir.");	
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[MECANICO]Voce nao tem dinheiro suficiente");
				}
			}else if(listitem == 3){
				if(GetPlayerMoney(playerid) >= 25000){
				DOF2_SetInt(file, "Radio", 2);
				DOF2_SaveFile(file);
				GivePlayerMoney(playerid, -25000);
				SendClientMessage(playerid, -1, "{00FF00}[MECANICO]Voce pagou $25000 ao mecanico e Instalou Grave no seu veiculo, digite /playradio para ouvir.");
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[MECANICO]Voce nao tem dinheiro suficiente");
				}
			}else if(listitem == 4){
				if(GetPlayerMoney(playerid) >= 1000){
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1008);
				GivePlayerMoney(playerid, -1000);
				SendClientMessage(playerid, -1, "{00FF00}[MECANICO]Voce pagou $1000 ao mecanico e Instalou Turbo no seu veiculo.");
				}else{
					SendClientMessage(playerid, -1, "{FF0000}[MECANICO]Voce nao tem dinheiro suficiente");
				}
			}

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
	if(dialogid == DIALOG_CAMINHONEIRO){
		new msg[1000], fmt[128], Float:price, ret;
		price = 0.82;
		if(response == 1){
			if(listitem == 0){
				if(IsPlayerInAnyVehicle(playerid)){
					if(GetPlayerVehicleID(playerid) == cmnh[playerid]){
						DisablePlayerCheckpoint(playerid);
						Caminhao[playerid] = true;
						DestroyVehicle(trailer[playerid]);
						
						trailer[playerid] = CreateVehicle(435, 296.214111, 1431.292358, 10.0, 268.895477, 1, 1, -1);
						SendClientMessage(playerid, -1, "{00FF00}[CAMINHONEIRO]{FFFFFF}Carga spawnada, va ate o checkpoint {800000}vermelho{FFFFFF}.");
						dest[playerid] = 0
						reward[playerid] = floatround(floatmul(GetDistance(2739.409423, -2465.345214, 13.648437,278.221740, 1408.768798, 10.436569), price), ret);
						timerCmnh[playerid] = SetTimer("CaminhaoTrailer", 1000, true);
						format(msg, sizeof(msg), "{FFFFFF}Trailer de {1010FF}%s", PlayerName(playerid));
						CaminhaoT[playerid] = Text3D:Create3DTextLabel(msg, -1, 296.214111, 1431.292358, 10.0, 100.0, 0);
						Attach3DTextLabelToVehicle(CaminhaoT[playerid], trailer[playerid], 0.0, 0.0, 0.0);
						d[playerid] = true;
					}else{
						DisablePlayerCheckpoint(playerid);
						Caminhao[playerid] = true;
						DestroyVehicle(trailer[playerid]);
						
						trailer[playerid] = CreateVehicle(435, 296.214111, 1431.292358, 10.0, 268.895477, 1, 1, -1);
						SendClientMessage(playerid, -1, "{00FF00}[CAMINHONEIRO]{FFFFFF}Caminhao spawnado, va ate o checkpoint {800000}vermelho{FFFFFF}.");
						dest[playerid] = 0
						reward[playerid] = floatround(floatmul(GetDistance(2739.409423, -2465.345214, 13.648437,278.221740, 1408.768798, 10.436569), price), ret);
						timerCmnh[playerid] = SetTimer("CaminhaoTrailer", 1000, true);
						format(msg, sizeof(msg), "{FFFFFF}Trailer de {1010FF}%s", PlayerName(playerid));
						CaminhaoT[playerid] = Text3D:Create3DTextLabel(msg, -1, 296.214111, 1431.292358, 10.0, 100.0, 0);
						Attach3DTextLabelToVehicle(CaminhaoT[playerid], trailer[playerid], 0.0, 0.0, 0.0);
						d[playerid] = true;
						cmnh[playerid] = CreateVehicle(515, 300.562438, 1337.873657, 10.425979, 280.0, 3, 3, 1800000);
						AttachTrailerToVehicle(trailer[playerid], cmnh[playerid]);
						format(msg, sizeof(msg), "{FFFFFF}Caminhao de {1010FF}%s", PlayerName(playerid));
						CaminhaoT2[playerid] = Text3D:Create3DTextLabel(msg, -1, 300.562438, 1337.873657, 10.425979, 100.0, 0);
						Attach3DTextLabelToVehicle(CaminhaoT2[playerid], cmnh[playerid], 0.0, 0.0, 0.0);
						new Float:x[1000], Float:y[1000], Float:z[1000];
						GetVehiclePos(cmnh[playerid], x[playerid], y[playerid], z[playerid]);
						SetPlayerCheckpoint(playerid, x[playerid], y[playerid], z[playerid], 1.5);
					}
				}else{
					DisablePlayerCheckpoint(playerid);
					Caminhao[playerid] = true;
					DestroyVehicle(trailer[playerid]);
					
					trailer[playerid] = CreateVehicle(435, 296.214111, 1431.292358, 10.0, 268.895477, 1, 1, -1);
					SendClientMessage(playerid, -1, "{00FF00}[CAMINHONEIRO]{FFFFFF}Caminhao spawnado, va ate o checkpoint {800000}vermelho{FFFFFF}.");
					dest[playerid] = 0
					reward[playerid] = floatround(floatmul(GetDistance(2739.409423, -2465.345214, 13.648437,278.221740, 1408.768798, 10.436569), price), ret);
					timerCmnh[playerid] = SetTimer("CaminhaoTrailer", 1000, true);
					format(msg, sizeof(msg), "{FFFFFF}Trailer de {1010FF}%s", PlayerName(playerid));
					CaminhaoT[playerid] = Text3D:Create3DTextLabel(msg, -1, 296.214111, 1431.292358, 10.0, 100.0, 0);
					Attach3DTextLabelToVehicle(CaminhaoT[playerid], trailer[playerid], 0.0, 0.0, 0.0);
					d[playerid] = true;
					cmnh[playerid] = CreateVehicle(515, 300.562438, 1337.873657, 10.425979, 280.0, 3, 3, 1800000);
					AttachTrailerToVehicle(trailer[playerid], cmnh[playerid]);
					format(msg, sizeof(msg), "{FFFFFF}Caminhao de {1010FF}%s", PlayerName(playerid));
					CaminhaoT2[playerid] = Text3D:Create3DTextLabel(msg, -1, 300.562438, 1337.873657, 10.425979, 100.0, 0);
					Attach3DTextLabelToVehicle(CaminhaoT2[playerid], cmnh[playerid], 0.0, 0.0, 0.0);
					new Float:x[1000], Float:y[1000], Float:z[1000];
					GetVehiclePos(cmnh[playerid], x[playerid], y[playerid], z[playerid]);
					SetPlayerCheckpoint(playerid, x[playerid], y[playerid], z[playerid], 1.5);
				}

			}else if(listitem == 1){
				if(IsPlayerInAnyVehicle(playerid)){
					if(GetPlayerVehicleID(playerid) == cmnh[playerid]){
						DisablePlayerCheckpoint(playerid);
						Caminhao[playerid] = true;
						DestroyVehicle(trailer[playerid]);
						trailer[playerid] = CreateVehicle(435, 296.214111, 1431.292358, 10.0, 268.895477, 1, 1, -1);
						SendClientMessage(playerid, -1, "{00FF00}[CAMINHONEIRO]{FFFFFF}Carga spawnada, va ate o checkpoint {800000}vermelho{FFFFFF}.");
						dest[playerid] = 1
						reward[playerid] = floatround(floatmul(GetDistance(1469.189453, 1029.842895, 10.257703, 278.221740, 1408.768798, 10.436569), price), ret);
						timerCmnh[playerid] = SetTimer("CaminhaoTrailer", 1000, true);

						format(msg, sizeof(msg), "{FFFFFF}Trailer de {1010FF}%s", PlayerName(playerid));
						CaminhaoT[playerid] = Text3D:Create3DTextLabel(msg, -1, 296.214111, 1431.292358, 10.0, 100.0, 0);
						Attach3DTextLabelToVehicle(CaminhaoT[playerid], trailer[playerid], 0.0, 0.0, 0.0);
						d[playerid] = true;
						
					}else{
						DisablePlayerCheckpoint(playerid);
						Caminhao[playerid] = true;
						DestroyVehicle(trailer[playerid]);
						
						trailer[playerid] = CreateVehicle(435, 296.214111, 1431.292358, 10.0, 268.895477, 1, 1, -1);
						SendClientMessage(playerid, -1, "{00FF00}[CAMINHONEIRO]{FFFFFF}Caminhao spawnado, va ate o checkpoint {800000}vermelho{FFFFFF}.");
						dest[playerid] = 1
						reward[playerid] = floatround(floatmul(GetDistance(1469.189453, 1029.842895, 10.257703, 278.221740, 1408.768798, 10.436569), price), ret);						timerCmnh[playerid] = SetTimer("CaminhaoTrailer", 1000, true);
						format(msg, sizeof(msg), "{FFFFFF}Trailer de {1010FF}%s", PlayerName(playerid));
						CaminhaoT[playerid] = Text3D:Create3DTextLabel(msg, -1, 296.214111, 1431.292358, 10.0, 100.0, 0);
						Attach3DTextLabelToVehicle(CaminhaoT[playerid], trailer[playerid], 0.0, 0.0, 0.0);
						d[playerid] = true;
						cmnh[playerid] = CreateVehicle(515, 300.562438, 1337.873657, 10.425979, 280.0, 3, 3, 1800000);
						AttachTrailerToVehicle(trailer[playerid], cmnh[playerid]);
						format(msg, sizeof(msg), "{FFFFFF}Caminhao de {1010FF}%s", PlayerName(playerid));
						CaminhaoT2[playerid] = Text3D:Create3DTextLabel(msg, -1, 300.562438, 1337.873657, 10.425979, 100.0, 0);
						Attach3DTextLabelToVehicle(CaminhaoT2[playerid], cmnh[playerid], 0.0, 0.0, 0.0);
						new Float:x[1000], Float:y[1000], Float:z[1000];
						GetVehiclePos(cmnh[playerid], x[playerid], y[playerid], z[playerid]);
						SetPlayerCheckpoint(playerid, x[playerid], y[playerid], z[playerid], 1.5);
					}
				}else{
						DisablePlayerCheckpoint(playerid);
						Caminhao[playerid] = true;
						DestroyVehicle(trailer[playerid]);
						
						trailer[playerid] = CreateVehicle(435, 296.214111, 1431.292358, 10.0, 268.895477, 1, 1, -1);
						SendClientMessage(playerid, -1, "{00FF00}[CAMINHONEIRO]{FFFFFF}Caminhao spawnado, va ate o checkpoint {800000}vermelho{FFFFFF}.");
						dest[playerid] = 1
						reward[playerid] = floatround(floatmul(GetDistance(1469.189453, 1029.842895, 10.257703, 278.221740, 1408.768798, 10.436569), price), ret);						timerCmnh[playerid] = SetTimer("CaminhaoTrailer", 1000, true);
						timerCmnh[playerid] = SetTimer("CaminhaoTrailer", 1000, true);
						format(msg, sizeof(msg), "{FFFFFF}Trailer de {1010FF}%s", PlayerName(playerid));
						CaminhaoT[playerid] = Text3D:Create3DTextLabel(msg, -1, 296.214111, 1431.292358, 10.0, 100.0, 0);
						Attach3DTextLabelToVehicle(CaminhaoT[playerid], trailer[playerid], 0.0, 0.0, 0.0);
						d[playerid] = true;
						cmnh[playerid] = CreateVehicle(515, 300.562438, 1337.873657, 10.425979, 280.0, 3, 3, 1800000);
						AttachTrailerToVehicle(trailer[playerid], cmnh[playerid]);
						format(msg, sizeof(msg), "{FFFFFF}Caminhao de {1010FF}%s", PlayerName(playerid));
						CaminhaoT2[playerid] = Text3D:Create3DTextLabel(msg, -1, 300.562438, 1337.873657, 10.425979, 100.0, 0);
						Attach3DTextLabelToVehicle(CaminhaoT2[playerid], cmnh[playerid], 0.0, 0.0, 0.0);
						new Float:x[1000], Float:y[1000], Float:z[1000];
						GetVehiclePos(cmnh[playerid], x[playerid], y[playerid], z[playerid]);
						SetPlayerCheckpoint(playerid, x[playerid], y[playerid], z[playerid], 1.5);
					}
			}else if(listitem == 2){
				if(IsPlayerInAnyVehicle(playerid)){
					if(GetPlayerVehicleID(playerid) == cmnh[playerid]){
						DisablePlayerCheckpoint(playerid);
						Caminhao[playerid] = true;
						DestroyVehicle(trailer[playerid]);
						trailer[playerid] = CreateVehicle(435, 296.214111, 1431.292358, 10.0, 268.895477, 1, 1, -1);
						SendClientMessage(playerid, -1, "{00FF00}[CAMINHONEIRO]{FFFFFF}Carga spawnada, va ate o checkpoint {800000}vermelho{FFFFFF}.");
						dest[playerid] = 2
						reward[playerid] = floatround(floatmul(GetDistance(-1745.754272, 163.085037, 3.549555, 278.221740, 1408.768798, 10.436569), price), ret);
						timerCmnh[playerid] = SetTimer("CaminhaoTrailer", 1000, true);
						format(msg, sizeof(msg), "{FFFFFF}Trailer de {1010FF}%s", PlayerName(playerid));
						CaminhaoT[playerid] = Text3D:Create3DTextLabel(msg, -1, 296.214111, 1431.292358, 10.0, 100.0, 0);
						Attach3DTextLabelToVehicle(CaminhaoT[playerid], trailer[playerid], 0.0, 0.0, 0.0);
						d[playerid] = true;
						
					}else{
						DisablePlayerCheckpoint(playerid);
						Caminhao[playerid] = true;
						DestroyVehicle(trailer[playerid]);
						
						trailer[playerid] = CreateVehicle(435, 296.214111, 1431.292358, 10.0, 268.895477, 1, 1, -1);
						SendClientMessage(playerid, -1, "{00FF00}[CAMINHONEIRO]{FFFFFF}Caminhao spawnado, va ate o checkpoint {800000}vermelho{FFFFFF}.");
						dest[playerid] = 2
						reward[playerid] = floatround(floatmul(GetDistance(-1745.754272, 163.085037, 3.549555, 278.221740, 1408.768798, 10.436569), price), ret);
						timerCmnh[playerid] = SetTimer("CaminhaoTrailer", 1000, true);
						format(msg, sizeof(msg), "{FFFFFF}Trailer de {1010FF}%s", PlayerName(playerid));
						CaminhaoT[playerid] = Text3D:Create3DTextLabel(msg, -1, 296.214111, 1431.292358, 10.0, 100.0, 0);
						Attach3DTextLabelToVehicle(CaminhaoT[playerid], trailer[playerid], 0.0, 0.0, 0.0);
						d[playerid] = true;
						cmnh[playerid] = CreateVehicle(515, 300.562438, 1337.873657, 10.425979, 280.0, 3, 3, 1800000);
						AttachTrailerToVehicle(trailer[playerid], cmnh[playerid]);
						format(msg, sizeof(msg), "{FFFFFF}Caminhao de {1010FF}%s", PlayerName(playerid));
						CaminhaoT2[playerid] = Text3D:Create3DTextLabel(msg, -1, 300.562438, 1337.873657, 10.425979, 100.0, 0);
						Attach3DTextLabelToVehicle(CaminhaoT2[playerid], cmnh[playerid], 0.0, 0.0, 0.0);
						new Float:x[1000], Float:y[1000], Float:z[1000];
						GetVehiclePos(cmnh[playerid], x[playerid], y[playerid], z[playerid]);
						SetPlayerCheckpoint(playerid, x[playerid], y[playerid], z[playerid], 1.5);
					}
				}else{
					DisablePlayerCheckpoint(playerid);
					Caminhao[playerid] = true;
					DestroyVehicle(trailer[playerid]);
					
					trailer[playerid] = CreateVehicle(591, 296.214111, 1431.292358, 10.0, 268.895477, 1, 1, -1);
					SendClientMessage(playerid, -1, "{00FF00}[CAMINHONEIRO]{FFFFFF}Caminhao spawnado, va ate o checkpoint {800000}vermelho{FFFFFF}.");
					dest[playerid] = 2
					reward[playerid] = floatround(floatmul(GetDistance(-1745.754272, 163.085037, 3.549555, 278.221740, 1408.768798, 10.436569), price), ret);
					timerCmnh[playerid] = SetTimer("CaminhaoTrailer", 1000, true);
					format(msg, sizeof(msg), "{FFFFFF}Trailer de {1010FF}%s", PlayerName(playerid));
					CaminhaoT[playerid] = Text3D:Create3DTextLabel(msg, -1, 296.214111, 1431.292358, 10.0, 100.0, 0);
					Attach3DTextLabelToVehicle(CaminhaoT[playerid], trailer[playerid], 0.0, 0.0, 0.0);
					d[playerid] = true;
					cmnh[playerid] = CreateVehicle(515, 300.562438, 1337.873657, 10.425979, 280.0, 3, 3, 1800000);
					AttachTrailerToVehicle(trailer[playerid], cmnh[playerid]);
					format(msg, sizeof(msg), "{FFFFFF}Caminhao de {1010FF}%s", PlayerName(playerid));
					CaminhaoT2[playerid] = Text3D:Create3DTextLabel(msg, -1, 300.562438, 1337.873657, 10.425979, 100.0, 0);
					Attach3DTextLabelToVehicle(CaminhaoT2[playerid], cmnh[playerid], 0.0, 0.0, 0.0);
					new Float:x[1000], Float:y[1000], Float:z[1000];
					GetVehiclePos(cmnh[playerid], x[playerid], y[playerid], z[playerid]);
					SetPlayerCheckpoint(playerid, x[playerid], y[playerid], z[playerid], 1.5);
				}
			}
		}
	}

}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
	if(vehicleid == cmnh[playerid]){
		new Float:x[1000], Float:y[1000], Float:z[1000];
		GetVehiclePos(trailer[playerid], x[playerid], y[playerid], z[playerid]);
		Delete3DTextLabel(CaminhaoT2[playerid]);
		DisablePlayerCheckpoint(playerid);
		SetPlayerCheckpoint(playerid, x[playerid], y[playerid], z[playerid], 1.5);
		SendClientMessage(playerid, -1, "{00FF00}[CAMINHONEIRO]{FFFFFF}Va ate o checkpoint{800000} vermelho {FFFFFF}e pegue sua carga.")
		Caminhao[playerid]=true;
	}
	return 1;
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
	if(vehicleid == cmnh[playerid]){
		if(Caminhao[playerid]){
			new Float:x[1000], Float:y[1000], Float:z[1000], msg[128];
			GetVehiclePos(cmnh[playerid], x[playerid], y[playerid], z[playerid]);
			Caminhao[playerid]=false;
			DisablePlayerCheckpoint(playerid);
			format(msg, sizeof(msg), "{FFFFFF}Caminhao de {1010FF}%s", PlayerName(playerid));
			CaminhaoT2[playerid] = Text3D:Create3DTextLabel(msg, -1, 300.562438, 1337.873657, 10.425979, 100.0, 0);
			Attach3DTextLabelToVehicle(CaminhaoT2[playerid], cmnh[playerid], 0.0, 0.0, 0.0);
			SetPlayerCheckpoint(playerid, x[playerid], y[playerid], z[playerid], 1.5);
			SendClientMessage(playerid, -1, "{00FF00}[CAMINHONEIRO]{FFFFFF}Voce saiu de seu veiculo, volte para o seu {800000}Caminhao{FFFFFF}.");
			timerCmnh[playerid] = SetTimer("CaminhaoTrailer", 1000, true);
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i ++){
		if(GetPlayerVehicleID(i) == Taxi[playerid]){
			if(GetPlayerState(i) == PLAYER_STATE_PASSENGER){
				new msg[128];
				format(msg, sizeof(msg), "{00FF00}[TAXI]{FFFFFF}Voce saiu do taxi e pagou $%d pela viagem", precotaxi[playerid]);
				SendClientMessage(i, -1, msg);
				new preco;
				preco -= precotaxi[playerid];
				GivePlayerMoney(i, preco);
				KillTimer(tmrTaxi[playerid]);
			}
		}
	}
	return 1;
}
new checks[16][3] = {
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{}
};
stock random2(min,max) // returns a random value, between min and max.
{
    return min + random ( max - min );
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
		if((GetPlayerVehicleID(playerid) == bike1) || (GetPlayerVehicleID(playerid) == bike2) || (GetPlayerVehicleID(playerid) == bike3) || (GetPlayerVehicleID(playerid) == bike4) || (GetPlayerVehicleID(playerid) == bike5) || (GetPlayerVehicleID(playerid) == bike6)|| (GetPlayerVehicleID(playerid) == bike7) || (GetPlayerVehicleID(playerid) == bike8) || (GetPlayerVehicleID(playerid) == bike9) || (GetPlayerVehicleID(playerid) == bike10)){
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


forward checktaxi(playerid);
public checktaxi(playerid){
	precotaxi[playerid] += random2(15,29);
	return 1;
}
//----------------------------COMANDOS----------------------------

// CMD:createdp(playerid, params[]){
	// 	new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
	// 	format(file, sizeof(file), ORGS, OrgsID);
	// 	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	// 	pckp = 1247;
	// 	org[OrgsID][pickup] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
	// 	format(nome, sizeof(nome), "{FF8000}Delegacia de Policia\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
	// 	org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);


	// 	org[OrgsID][posx] = x[playerid];
	// 	org[OrgsID][posy] = y[playerid];
	// 	org[OrgsID][posz] = z[playerid];
	// 	DOF2_CreateFile(file);
	// 	DOF2_SetInt(file, "Pickup",pckp);
	// 	DOF2_SetFloat(file,"X" , x[playerid]);
	// 	DOF2_SetFloat(file,"Y" , y[playerid]);
	// 	DOF2_SetFloat(file,"Z" , z[playerid]);
	// 	DOF2_SaveFile(file);
	// 	org[OrgsID][posx] = DOF2_GetFloat(file, "X");
	// 	org[OrgsID][posy] = DOF2_GetFloat(file, "Y");
	// 	org[OrgsID][posz] = DOF2_GetFloat(file, "Z");
	// 	OrgsID++;
	// 	SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
		
	// 	return 1;
// }
// CMD:createprefeitura(playerid, params[]){
	// 	new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
	// 	format(file, sizeof(file), ORGS, OrgsID);
	// 	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	// 	pckp = 1212;
	// 	org[OrgsID][pickup] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
	// 	format(nome, sizeof(nome), "{FF8000}Prefeitura\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
	// 	org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

	// 	org[OrgsID][posx] = x[playerid];
	// 	org[OrgsID][posy] = y[playerid];
	// 	org[OrgsID][posz] = z[playerid];
	// 	DOF2_CreateFile(file);
	// 	DOF2_SetInt(file, "Pickup",pckp);
	// 	DOF2_SetFloat(file,"X" , x[playerid]);
	// 	DOF2_SetFloat(file,"Y" , y[playerid]);
	// 	DOF2_SetFloat(file,"Z" , z[playerid]);
	// 	DOF2_SaveFile(file);
	// 	org[OrgsID][posx] = DOF2_GetFloat(file, "X");
	// 	org[OrgsID][posy] = DOF2_GetFloat(file, "Y");
	// 	org[OrgsID][posz] = DOF2_GetFloat(file, "Z");
	// 	OrgsID++;
	// 	SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
	// 	return 1;
// }
// CMD:createae(playerid, params[]){
	// 	new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
	// 	format(file, sizeof(file), ORGS, OrgsID);
	// 	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	// 	pckp = 1210;
	// 	org[OrgsID][pickup] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
	// 	format(nome, sizeof(nome), "{FF8000}Agencia de Empregos\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
	// 	org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

	// 	org[OrgsID][posx] = x[playerid];
	// 	org[OrgsID][posy] = y[playerid];
	// 	org[OrgsID][posz] = z[playerid];
	// 	DOF2_CreateFile(file);
	// 	DOF2_SetInt(file, "Pickup",pckp);
	// 	DOF2_SetFloat(file,"X" , x[playerid]);
	// 	DOF2_SetFloat(file,"Y" , y[playerid]);
	// 	DOF2_SetFloat(file,"Z" , z[playerid]);
	// 	DOF2_SaveFile(file);
	// 	org[OrgsID][posx] = DOF2_GetFloat(file, "X");
	// 	org[OrgsID][posy] = DOF2_GetFloat(file, "Y");
	// 	org[OrgsID][posz] = DOF2_GetFloat(file, "Z");
	// 	OrgsID++;
	// 	SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
	// 	return 1;
// }
// CMD:createdetran(playerid, params[]){
	//     new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
	// 	format(file, sizeof(file), ORGS, OrgsID);
	// 	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	// 	pckp = 1239;
	// 	org[OrgsID][pickup] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
	// 	format(nome, sizeof(nome), "{FF8000}Detran\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
	// 	org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

	// 	org[OrgsID][posx] = x[playerid];
	// 	org[OrgsID][posy] = y[playerid];
	// 	org[OrgsID][posz] = z[playerid];
	// 	DOF2_CreateFile(file);
	// 	DOF2_SetInt(file, "Pickup",pckp);
	// 	DOF2_SetFloat(file,"X" , x[playerid]);
	// 	DOF2_SetFloat(file,"Y" , y[playerid]);
	// 	DOF2_SetFloat(file,"Z" , z[playerid]);
	// 	DOF2_SaveFile(file);
	// 	org[OrgsID][posx] = DOF2_GetFloat(file, "X");
	// 	org[OrgsID][posy] = DOF2_GetFloat(file, "Y");
	// 	org[OrgsID][posz] = DOF2_GetFloat(file, "Z");
	// 	OrgsID++;
	// 	SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
	// 	return 1;
// }
// CMD:createauto(playerid, params[]){
	// 	new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
	// 	format(file, sizeof(file), ORGS, OrgsID);
	// 	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	// 	pckp = 1581;
	// 	org[OrgsID][pickup] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
	// 	format(nome, sizeof(nome), "{FF8000}Auto-Escola\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
	// 	org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

	// 	org[OrgsID][posx] = x[playerid];
	// 	org[OrgsID][posy] = y[playerid];
	// 	org[OrgsID][posz] = z[playerid];
	// 	DOF2_CreateFile(file);
	// 	DOF2_SetInt(file, "Pickup",pckp);
	// 	DOF2_SetFloat(file,"X" , x[playerid]);
	// 	DOF2_SetFloat(file,"Y" , y[playerid]);
	// 	DOF2_SetFloat(file,"Z" , z[playerid]);
	// 	DOF2_SaveFile(file);
	// 	org[OrgsID][posx] = DOF2_GetFloat(file, "X");
	// 	org[OrgsID][posy] = DOF2_GetFloat(file, "Y");
	// 	org[OrgsID][posz] = DOF2_GetFloat(file, "Z");
	// 	OrgsID++;
	// 	SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
	// 	return 1;
// }
CMD:createbank(playerid, params[]){
		new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
		format(file, sizeof(file), ORGS, OrgsID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
		pckp = 1274;
		org[OrgsID][pickup] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Banco\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
		org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

		org[OrgsID][posx] = x[playerid];
		org[OrgsID][posy] = y[playerid];
		org[OrgsID][posz] = z[playerid];
		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Pickup",pckp);
		DOF2_SetFloat(file,"X" , x[playerid]);
		DOF2_SetFloat(file,"Y" , y[playerid]);
		DOF2_SetFloat(file,"Z" , z[playerid]);
		DOF2_SaveFile(file);
		org[OrgsID][posx] = DOF2_GetFloat(file, "X");
		org[OrgsID][posy] = DOF2_GetFloat(file, "Y");
		org[OrgsID][posz] = DOF2_GetFloat(file, "Z");
		OrgsID++;
		SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
		return 1;
}
CMD:createhotel(playerid, params[]){
		new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
		format(file, sizeof(file), ORGS, OrgsID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
		pckp = 19524;
		org[OrgsID][pickup] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Hotel\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
		org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

		org[OrgsID][posx] = x[playerid];
		org[OrgsID][posy] = y[playerid];
		org[OrgsID][posz] = z[playerid];
		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Pickup",pckp);
		DOF2_SetFloat(file,"X" , x[playerid]);
		DOF2_SetFloat(file,"Y" , y[playerid]);
		DOF2_SetFloat(file,"Z" , z[playerid]);
		DOF2_SaveFile(file);
		org[OrgsID][posx] = DOF2_GetFloat(file, "X");
		org[OrgsID][posy] = DOF2_GetFloat(file, "Y");
		org[OrgsID][posz] = DOF2_GetFloat(file, "Z");
		OrgsID++;
		SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
		return 1;
}
CMD:createpizza(playerid, params[]){
		new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
		format(file, sizeof(file), ORGS, OrgsID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
		pckp = 19197;
		org[OrgsID][pickup] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Pizzaria\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
		org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

		org[OrgsID][posx] = x[playerid];
		org[OrgsID][posy] = y[playerid];
		org[OrgsID][posz] = z[playerid];
		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Pickup",pckp);
		DOF2_SetFloat(file,"X" , x[playerid]);
		DOF2_SetFloat(file,"Y" , y[playerid]);
		DOF2_SetFloat(file,"Z" , z[playerid]);
		DOF2_SaveFile(file);
		org[OrgsID][posx] = DOF2_GetFloat(file, "X");
		org[OrgsID][posy] = DOF2_GetFloat(file, "Y");
		org[OrgsID][posz] = DOF2_GetFloat(file, "Z");
		OrgsID++;
		SendClientMessage(playerid, -1, "{00FF00}[ORGS] {FFFFFF}Organizacao criada com sucesso!.");
		return 1;
}
CMD:createlanche(playerid, params[]){
		new file[128],pckp, nome[128], float:x[10000], float:y[10000], float:z[10000];
		format(file, sizeof(file), ORGS, OrgsID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
		pckp = 19198;
		org[OrgsID][pickup] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Lanchonete\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para entrar.");
		org[OrgsID][texto] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);

		org[OrgsID][posx] = x[playerid];
		org[OrgsID][posy] = y[playerid];
		org[OrgsID][posz] = z[playerid];
		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Pickup",pckp);
		DOF2_SetFloat(file,"X" , x[playerid]);
		DOF2_SetFloat(file,"Y" , y[playerid]);
		DOF2_SetFloat(file,"Z" , z[playerid]);
		DOF2_SaveFile(file);
		org[OrgsID][posx] = DOF2_GetFloat(file, "X");
		org[OrgsID][posy] = DOF2_GetFloat(file, "Y");
		org[OrgsID][posz] = DOF2_GetFloat(file, "Z");
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
		if(sscanf(params, "d", type)) return SendClientMessage(playerid, -1, "{FF0000}[ERRO] {FFFFFF}Digite: /createsaida [0 = dp / 1 = prefeitura / 2 = Agencia / 3 = detran / 4 = Auto-escola / 5 = banco / 6 = hotel / 7 = lanchonete / 8 = pizzaria]");

		format(file, sizeof(file), SAIDAS, SaidasID);
		GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);


		pckp = 1239;
		s[SaidasID][pickup] = CreatePickup(pckp, 1, x[playerid], y[playerid], z[playerid], 0);
		format(nome, sizeof(nome), "{FF8000}Detran\n\n{FFFFFF}Pressione \"f\" ou \"ENTER\" para sair.");
		s[SaidasID][texto] = Text3D:Create3DTextLabel(nome, -1, x[playerid], y[playerid], z[playerid], 10.0, 0);



		DOF2_CreateFile(file);
		DOF2_SetInt(file, "Tipo", type);
		DOF2_SetFloat(file, "X", x[playerid]);
		DOF2_SetFloat(file, "Y", y[playerid]);
		DOF2_SetFloat(file, "Z", z[playerid]);
		DOF2_SaveFile(file);
		s[SaidasID][posx] = x[playerid];
		s[SaidasID][posy] = y[playerid];
		s[SaidasID][posz] = z[playerid];
		SaidasID ++;
		return 1;
}
CMD:playradio(playerid, params[]){
	new file[128], float:x, float:y , float:z;
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	if(IsPlayerInAnyVehicle(playerid)){
		if(DOF2_GetInt(file, "Radio") == 0){
		 return SendClientMessage(playerid, -1, "{FF0000}[ERRO] {FFFFFF}Voce nao possui som instalado no seu veiculo.");
		}else if(DOF2_GetInt(file, "Radio") == 1){
			StopAudioStreamForPlayer(playerid);
			PlayAudioStreamForPlayer(playerid, "http://live.hunterfm.com/live", x, y, z, 0.0, 0);
			SendClientMessage(playerid, -1, "{00FF00}[RADIO] {FFFFFF}Radio ligada, para desligar apenas saia do veiculo.");
		}else if(DOF2_GetInt(file, "Radio") == 2){

			StopAudioStreamForPlayer(playerid);
			PlayAudioStreamForPlayer(playerid, "http://live.hunterfm.com/live", x, y, z, 0.0, 0);
			SendClientMessage(playerid, -1, "{00FF00}[RADIO] {FFFFFF}Radio ligada, para desligar apenas saia do veiculo.");
		}

	}else{
		return SendClientMessage(playerid, -1, "{FF0000}[ERRO] {FFFFFF}Voce precisa estar em um veiculo para utilizar a radio.");
	}

	return 1;
}
CMD:v(playerid, params[]){
	new float:x[10000], float:y[10000], float:z[10000];
	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	AddStaticVehicle(411, x[playerid], y[playerid], z[playerid], 0.0, -1, -1);
	SendClientMessage(playerid, -1, "{0000FF}Veiculo spawnado");
	return 1;
}
// CMD:createcheck(playerid, params[]){

	// 	new file[128], numb;
	// 	format(file, sizeof(file), "%d.ini", numb);
	// 	new float:x[10000],	float:y[10000], float:z[10000];
	// 	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	// 	SetPlayerCheckpoint(playerid, x[playerid], y[playerid], z[playerid], 3.0);
	// 	SendClientMessage(playerid, -1, "CHECKPOINT CRIADO");
	// 	DOF2_CreateFile(file);
	// 	DOF2_SetFloat(file, "x", x[playerid]);
	// 	DOF2_SetFloat(file, "y", y[playerid]);
	// 	DOF2_SetFloat(file, "z", z[playerid]);
	// 	DOF2_SaveFile(file);
	// 	return 1;
// }

CMD:tp(playerid, params[]){
	new float:x, float:y, float:z
	if(sscanf(params,"fff",x,y,z)) return SendClientMessage(playerid, -1, "{FF0000}[ERRO]{FFFFFF}Digite /tp [x] [y] [z]");
	SetPlayerPos(playerid, x, y, z);
	SendClientMessage(playerid, -1, "{00FF00}TELEPORTADO");
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
	if((GetPlayerVehicleID(playerid) == bike1) || (GetPlayerVehicleID(playerid) == bike2) || (GetPlayerVehicleID(playerid) == bike3) || (GetPlayerVehicleID(playerid) == bike4) || (GetPlayerVehicleID(playerid) == bike5) || (GetPlayerVehicleID(playerid) == bike6)|| (GetPlayerVehicleID(playerid) == bike7) || (GetPlayerVehicleID(playerid) == bike8) || (GetPlayerVehicleID(playerid) == bike9) || (GetPlayerVehicleID(playerid) == bike10)){
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

CMD:taxi(playerid, params[]){
	new file[128];
	SendClientMessage(playerid, -1, "{00FF00}[TAXI]{FFFFFF}Os taxistas foram chamados.");
	for(new i = 0; i < MAX_PLAYERS; i++){
		format(file, sizeof(file), CONTAS, PlayerName(i));
		if(strcmp(DOF2_GetString(file, "Emprego"), "Taxista") == 0){
			new msg[128];
			format(msg, sizeof(msg), "{FFFF00}[TAXISTA]{FFFFFF}O player {FF0000}%s[%d] {FFFFFF}esta solicitando um taxi.", PlayerName(playerid), playerid);
			SendClientMessage(i, -1, msg);
		}

	}

	return 1;
}

CMD:localizar(playerid, params[]){
	new file[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	if(strcmp(DOF2_GetString(file, "Emprego"), "Taxista", false) == 1) return SendClientMessage(playerid, -1, "{FF0000}[ERRO]{FFFFFF}Voce nao e um taxista");
	if(sscanf(params, "d", id[playerid])) return SendClientMessage(playerid, -1, "{FF0000}[TAXISTA]{FFFFFF}Digite /localizar [id do jogador]");
	if(!IsPlayerConnected(id[playerid])) return SendClientMessage(playerid, -1, "{FF0000}[TAXISTA]{FFFFFF}O jogador nao esta conectado.");
	new vehicleid;
	vehicleid = GetPlayerVehicleID(playerid);
	if(vehicleid == Taxi[playerid]){
		new Float:x, Float:y, Float:z;
		GetPlayerPos(id[playerid], x, y, z);
		DisablePlayerCheckpoint(playerid);
		SetPlayerCheckpoint(playerid, x, y, z, 1.5);
	}else{
		SendClientMessage(playerid, -1, "{FF0000}[TAXISTA]{FFFFFF}Voce nao esta em seu veiculo.");
	}
	return 1;
}

CMD:taximetro(playerid, params[]){
	new file[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	if(strcmp(DOF2_GetString(file, "Emprego"), "Taxista", false) == 1) return SendClientMessage(playerid, -1, "{FF0000}[ERRO]{FFFFFF}Voce nao e um taxista");
	for(new i = 0; i < MAX_PLAYERS; i ++){
		if(GetPlayerVehicleID(i) == Taxi[playerid]){
			if(GetPlayerState(i) == PLAYER_STATE_PASSENGER){
				SendClientMessage(playerid, -1, "{00FF00}[TAXISTA]{FFFFFF}O taximetro foi ativado.");
				SendClientMessage(i, -1, "{00FF00}[TAXI]{FFFFFF}O taximetro foi ativado.");
				tmrTaxi[playerid] = SetTimer("checktaxi", 1000, true);
			}
		}
	}
	
	return 1;
}
CMD:connectnpc(playerid, params[]){
	ConnectNPC("test","Teste");
	Onibus1 = CreateVehicle(431, 0.0, 0.0, 5.0, 0.0, 3, 3, 5000);
	SendClientMessage(playerid, -1, "{00FF00}NPC conectado.")
	return 1;
}
//----------------------------COMANDOS----------------------------