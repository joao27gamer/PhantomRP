#include <a_samp>
#include <DOF2>
#include <Pawn.CMD>
#include <streamer>
#include <foreach>
#include <sscanf2>
#include <mailer>
#include <timerfix>
#include <PreviewModelDialog>

//DEFINES//
#define DIALOG_REGISTRO 			1
#define DIALOG_LOGIN				2
#define DIALOG_AGENCIA				3
#define DIALOG_HONES				4
#define DIALOG_TRANSPORTES 			5
#define DIALOG_GOVERNO				6
#define DIALOG_POLICIA				7
#define DIALOG_FARMADAS				8
#define DIALOG_MAFIA				9
#define DIALOG_ROTAONIBUS			10
#define DIALOG_SEMENTE				11
#define DIALOG_SEMENTES				12
#define DIALOG_PROFISSOES			13
#define DIALOG_HOSPITAL				14
#define DIALOG_UTILITARIOS			15
#define DIALOG_CREDITOS				16
#define DIALOG_EMAIL				17
#define DIALOG_ATIVAR_CONTA			18
#define DIALOG_RECUPERAR			19
#define DIALOG_RECUPERAR_CODIGO		20
#define DIALOG_SEXUALIDADE			21
#define ADMIN_LEVEL					22
#define DIALOG_SEMPARAR				23
#define DIALOG_IDENTIDADE			24
#define DIALOG_ROTACARRO			25
#define DIALOG_CONCE				26
#define DIALOG_ADMINS				27
#define PASTA_CONTAS 				"Contas/%s.ini"
#define PASTA_CARROS				"Carros/%i.ini"
/*FIM DEFINES*/

#define MAX_CARROS 					10

new sstring[300];

#define 	SendClientFormat(%1,%2,%3,%4) do{format(sstring,sizeof(sstring),%3,%4);SendClientMessage(%1,%2,sstring);}while(IsPlayerConnected(-1))

#define MAILER_URL 					"SendMailer"
#define EMAIL_SERVIDOR				"Email"

//DEFINES CORES
#define COR_ERRO 					0xFF4500FF

//DEFINES CONCE
#define CARROS 3
#define SPAWN_X 528.3288
#define SPAWN_Y -1320.7841
#define SPAWN_Z 17.2422
#define ANGULO 99.7823
#define Car_Infernus 30000
#define Car_Cheetah 30000
#define Car_Banshee 30000

//CORES PROFISSOES//
#define COR_DESEMPREGADO      		0xFFFAFAFF
#define COR_MOTORISTABUS      		0x009ACDFF
#define COR_TAXI					0xFFFF00FF
#define COR_PILOTO					0x6495EDFF
#define COR_FAZENDEIRO			 	0xEE0000FF
#define COR_CARROFORTE				0x5F9EA0FF
#define COR_SMS 					0xFFA500FF
#define COR_ADM						0x4169E1FF
#define COR_VERDE					0x32CD32FF
#define COR_BRANCO					0xFFFFFFFF
#define COR_VERMELHO 				0xFF0000FF
#define COR_DUVIDA					0x00CED1FF
//TextDraws
new Text:Textdraw0;
new Text:Textdraw1;
new Text:Aviso[MAX_PLAYERS];

//EMPREGOS//
#define DESEMPREGADO 				0
#define MOTORISTA_ONIBUS       	 	1
#define TAXISTA                	 	2
#define PILOTO 						3
#define FAZENDEIRO 					4
#define MOTORISTA_CARROFORTE		5

//FORWARDS
forward PassageirosE(playerid);
forward PassageirosD(playerid);
forward DescarregouT(playerid);
forward DescarregarA(playerid);
forward Horas(playerid);
forward Plantar1(playerid);
forward Sumiu(playerid);
//FIM FORWARDS

enum pLeo {
	bool:RegistroNaoConcluido,
	pSenhaInvalida,
	Senha,
	Matou,
	Morreu,
	Dinheiro,
	Profissao,
	Sementes,
	PlanoMedico,
	Celular,
	Creditos,
	Admin,
	CarroID,
	UltimoLoginD,
	UltimoLoginA,
	UltimoLoginM,
	Level
}

new PlayerLeo[MAX_PLAYERS][pLeo]; 

new CCP[MAX_PLAYERS];
new Carregado[MAX_PLAYERS];
new Trabalhando[MAX_PLAYERS];
new EmRota[MAX_PLAYERS];
new CCO[MAX_PLAYERS];
new CheckCF[MAX_PLAYERS];
new Plantando[MAX_PLAYERS];
new Colher[MAX_PLAYERS];
new Colhido[MAX_PLAYERS];
new PassagemValor[MAX_PLAYERS];
new PassagemOferecido[MAX_PLAYERS];
new PassagemRecebido[MAX_PLAYERS];
new PassagemID[MAX_PLAYERS];
new PassagemPID[MAX_PLAYERS];
new PassagemMensagem[MAX_PLAYERS];
new PassagemTimer[MAX_PLAYERS];
new PassagemJa[MAX_PLAYERS];
new SemParar[MAX_PLAYERS];
new CancelaP[MAX_PLAYERS][6];
new bool:PassouPedagio[MAX_PLAYERS];
new Calado[MAX_PLAYERS];
new Ausente[MAX_PLAYERS];
new TimerCalado[MAX_PLAYERS];
new CheckFazenda[5];
new PAviao[8];
new MOnibus[8];
new CarroForte[8];
new Maconha;

enum Plantacao
{
	Float:posX,
	Float:posY,
	Float:posZ
};

static const PlantacaoF[][Plantacao] =
{
	{-1060.3507, -1616.7421, 76.3672}, //0
	{-1060.2245, -1623.3790, 76.3672}, //1
	{-1060.1792, -1630.3490, 76.3672}, //2
	{-1052.4302, -1616.5619, 76.3672}, //3
	{-1052.1691, -1623.4929, 76.3672}, //4
	{-1051.9437, -1630.5760, 76.3672}, //5
	{-1043.8438, -1616.5940, 76.3672}, //6
	{-1043.6317, -1623.7639, 76.3672}, //7
	{-1043.3975, -1630.7271, 76.3672}, //8
	{-1035.2700, -1616.2325, 76.3672}, //9
	{-1035.4470, -1623.9568, 76.3672}, //10
	{-1035.6522, -1630.6733, 76.3672}  //11
};

enum VeiculosConce {
	VeiculosID,
	VeiculoNome[28],
	Preco
};

new const VeiculosT[][VeiculosConce] =
{
	{400, "Landstalker", 35000},
	{401, "Bravura", 40000},
	{402, "Buffalo", 45000},
	{403, "Linerunner", 120000},
	{404, "Perennial", 30000},
	{405, "Sentinel", 28000},
	{408, "Trashmaster", 80000},
	{409, "Stretch", 60000},
	{410, "Manana", 60000},
	{411, "Infernus", 200000},
	{412, "Voodoo", 70000},
	{413, "Pony", 65000},
	{414, "Mule", 70000},
	{415, "Cheetah", 50000},
	{418, "Moonbeam", 50000},
	{419, "Esperanto", 50000},
	{421, "Washington", 50000},
	{422, "Bobcat", 50000},
	{424, "BF Injection", 50000},
	{426, "Premier", 50000},
	{429, "Banshee", 50000},
	{431, "Bus", 50000},
	{434, "Hotknife", 50000},
	{436, "Previon", 50000},
	{437, "Coach", 50000},
	{439, "Stallion", 50000},
	{440, "Rumpo", 50000},
	{442, "Romero", 50000},
	{445, "Admiral", 50000},
	{451, "Turismo", 50000},
	{455, "Flatbed", 50000},
	{456, "Yankee", 50000},
	{458, "Solair", 50000},
	{461, "PCJ-600", 50000},
	{462, "Faggio", 50000},
	{463, "Freeway", 50000},
	{466, "Glendale", 50000},
	{467, "Oceanic", 50000},
	{468, "Sanchez", 50000},
	{471, "Quad", 50000},
	{474, "Hermes", 50000},
	{475, "Sabre", 50000},
	{477, "ZR-350", 50000},
	{478, "Walton", 50000},
	{479, "Regina", 50000},
	{480, "Comet", 50000},
	{482, "Burrito", 50000},
	{483, "Camper", 50000},
	{489, "Rancher", 50000},
	{491, "Virgo", 50000},
	{492, "Greenwood", 50000},
	{494, "Hotring Racer", 50000},
	{495, "Sandking", 50000},
	{496, "Blista Compact", 50000},
	{498, "Boxville", 50000},
	{499, "Benson", 50000},
	{500, "Mesa", 50000},
	{502, "Hotring Racer A", 50000},
	{503, "Hotring Racer B", 50000},
	{505, "Rancher Lure", 50000},
	{506, "Super GT", 50000},
	{507, "Elegant", 50000},
	{508, "Journey", 50000},
	{514, "Tanker", 50000},
	{515, "Roadtrain", 50000},
	{516, "Nebula", 50000},
	{517, "Majestic", 50000},
	{518, "Buccaneer", 50000},
	{521, "FCR-900", 50000},
	{522, "NRG-500", 50000},
	{526, "Fortune", 50000},
	{527, "Cadrona", 50000},
	{529, "Willard", 50000},
	{533, "Feltzer", 50000},
	{534, "Remington", 50000},
	{535, "Slamvan", 50000},
	{536, "Blade", 50000},
	{539, "Vortex", 50000},
	{540, "Vincent", 50000},
	{541, "Bullet", 50000},
	{542, "Clover", 50000},
	{543, "Sadler", 50000},
	{545, "Hustler", 50000},
	{546, "Intruder", 50000},
	{547, "Primo", 50000},
	{550, "Sunrise", 50000},
	{551, "Merit", 50000},
	{554, "Yosemite", 50000},
	{555, "Windsor", 50000},
	{558, "Uranus", 50000},
	{559, "Jester", 50000},
	{560, "Sultan", 50000},
	{561, "Stratum", 50000},
	{562, "Elegy", 50000},
	{565, "Flash", 50000},
	{566, "Tahoma", 50000},
	{567, "Savanna", 50000},
	{568, "Bandito", 50000},
	{575, "Broadway", 50000},
	{576, "Tornado", 50000},
	{578, "DFT-30", 50000},
	{579, "Huntley", 50000},
	{580, "Stafford", 50000},
	{581, "BF-400", 50000},
	{585, "Emperor", 50000},
	{586, "Wayfarer", 50000},
	{587, "Euros", 50000},
	{589, "Club", 50000},
	{600, "Picador", 50000},
	{602, "Alpha", 50000},
	{603, "Phoenix", 50000}
};

new
    vNames[212][] =
    {
        "Landstalker", "Bravura", "Buffalo", "Linerunner", "Pereniel", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
        "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Mr Whoopee", "BF Injection",
        "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
        "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
        "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider",
        "Glendale", "Oceanic", "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina",
        "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood",
        "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B",
        "Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropdust", "Stunt", "Tanker", "RoadTrain",
        "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune", "Cadrona", "FBI Truck",
        "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent", "Bullet", "Clover",
        "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster A",
        "Monster B", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito", "Freight", "Trailer",
        "Kart", "Mower", "Duneride", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "Newsvan", "Tug", "Trailer A", "Emperor",
        "Wayfarer", "Euros", "Hotdog", "Club", "Trailer B", "Trailer C", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car (LSPD)", "Police Car (SFPD)",
        "Police Car (LVPD)", "Police Ranger", "Picador", "S.W.A.T. Van", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage Trailer A", "Luggage Trailer B",
        "Stair Trailer", "Boxville", "Farm Plow", "Utility Trailer"
    }
;

main()
{
	print("\n----------------------------------------------------------------\n");
	print(" Gamemode Base RPG\n");
	print(" Créditos: iAplle pelo Gamemode\n");
	print(" Leonardo Bradoks pela agencia e o sistema de registro\n");
	print("----------------------------------------------------------------\n");
}

public OnGameModeInit()
{
	new string[64];
	SendRconCommand("hostname Base RPG por iAplle");
	SetGameModeText("[RPG] Base RPG v1.0 por iAplle");
	SendRconCommand("mapname [RPG] San Andreas");
	SendRconCommand("website forum.sa-mp.com");

	for(new i = 0; i < sizeof(PlantacaoF); i ++)
	{
		format(string, sizeof(string), "{32CD32}Plantação {FFFFFF}ID: %d", i); 
        Create3DTextLabel(string, 0xFFFFFFFF, PlantacaoF[i][posX], PlantacaoF[i][posY], PlantacaoF[i][posZ], 20.0, 0);
        CheckFazenda[0] = CreateDynamicCP(PlantacaoF[i][posX], PlantacaoF[i][posY], PlantacaoF[i][posZ], 0.7, -1, -1, -1, 10);
	}
	AddPlayerClass(0, 1938.1903, -2645.8267, 13.5469, 355.7780, 0, 0, 0, 0, 0, 0);
	//Aviao Piloto
	PAviao[0] = CreateVehicle(593, 1938.1903, -2645.8267, 13.5469, 355.7780, -1, -1, 300);
	PAviao[1] = CreateVehicle(593, 1738.0029, -2646.0476, 14.0346, 0.0000, -1, -1, 300);
	PAviao[2] = CreateVehicle(593, 1904.8475, -2644.3452, 14.0346, 0.0000, -1, -1, 300);
	PAviao[3] = CreateVehicle(593, 1870.2150, -2644.3452, 14.0346, 0.0000, -1, -1, 300);
	PAviao[4] = CreateVehicle(593, 1839.0034, -2644.4233, 14.0346, 0.0000, -1, -1, 300);
	PAviao[5] = CreateVehicle(593, 1804.4484, -2645.1787, 14.0346, 0.0000, -1, -1, 300);
	PAviao[6] = CreateVehicle(593, 1772.5469, -2645.7295, 14.0346, 0.0000, -1, -1, 300);
	//Onibus Motorista de Onbus
	MOnibus[0] = CreateVehicle(437, 2807.5803, 1348.5842, 10.7402, -90.0000, -1, -1, 300);
	MOnibus[1] = CreateVehicle(437, 2767.2524, 1271.9750, 10.7402, -90.0000, -1, -1, 300);
	MOnibus[2] = CreateVehicle(437, 2767.2532, 1278.3861, 10.7402, -90.0000, -1, -1, 300);
	MOnibus[3] = CreateVehicle(437, 2781.9856, 1292.4948, 10.7402, 180.0000, -1, -1, 300);
	MOnibus[4] = CreateVehicle(437, 2767.3435, 1288.0079, 10.7402, -90.0000, -1, -1, 300);
	MOnibus[5] = CreateVehicle(437, 2807.6604, 1335.7874, 10.7402, -90.0000, -1, -1, 300);
	MOnibus[6] = CreateVehicle(437, 2807.3787, 1361.4490, 10.7402, -90.0000, -1, -1, 300);

	CarroForte[0] = CreateVehicle(428, 608.3939, -1306.0569, 14.3516, 8.0000, 6, 6, 300);
	CarroForte[1] = CreateVehicle(428, 579.4124, -1309.7803, 14.0116, 8.0000, 6, 6, 300);
	CarroForte[2] = CreateVehicle(428, 584.8554, -1309.2919, 14.0116, 8.0000, 6, 6, 300);
	CarroForte[3] = CreateVehicle(428, 590.2287, -1308.8018, 14.0116, 8.0000, 6, 6, 300);
	CarroForte[4] = CreateVehicle(428, 596.3364, -1307.7777, 14.0116, 8.0000, 6, 6, 300);
	CarroForte[5] = CreateVehicle(428, 602.5659, -1306.9375, 14.0516, 8.0000, 6, 6, 300);

	//text draw horas
	{
		Textdraw1 = TextDrawCreate(547.486694, 31.516885, "00:00:00");
		TextDrawLetterSize(Textdraw1, 0.265001, 1.989999);
		TextDrawAlignment(Textdraw1, 1);
		TextDrawColor(Textdraw1, -1);
		TextDrawSetShadow(Textdraw1, 0);
		TextDrawSetOutline(Textdraw1, 1);
		TextDrawBackgroundColor(Textdraw1, 255);
		TextDrawFont(Textdraw1, 2);
		TextDrawSetProportional(Textdraw1, 1);
		TextDrawSetShadow(Textdraw1, 0);
	//text draw data
    	Textdraw0 = TextDrawCreate(547.330322, 16.183233, "00/00/00");
		TextDrawLetterSize(Textdraw0, 0.278001, 1.799998);
		TextDrawAlignment(Textdraw0, 1);
		TextDrawColor(Textdraw0, -1);
		TextDrawSetShadow(Textdraw0, 0);
		TextDrawSetOutline(Textdraw0, 1);
		TextDrawBackgroundColor(Textdraw0, 255);
		TextDrawFont(Textdraw0, 2);
		TextDrawSetProportional(Textdraw0, 1);
		TextDrawSetShadow(Textdraw0, 0);
    	SetTimer("Horas", 1000, 1);
	}
	for(new i=0; i<GetMaxPlayers(); i++) 
	{
		Aviso[i] = TextDrawCreate(35.000000, 152.000000, " "); 
        TextDrawBackgroundColor(Aviso[i], 255); 
        TextDrawFont(Aviso[i], 1); 
        TextDrawLetterSize(Aviso[i], 0.310000, 1.000000); 
        TextDrawColor(Aviso[i], -1); 
        TextDrawSetOutline(Aviso[i], 1); 
        TextDrawSetProportional(Aviso[i], 1);
	}
	SetTimer("CheckSemParar", 300, true);

	for(new i = 0; i < GetMaxPlayers(); i ++) 
	{
		SetTimerEx("CorrigirSementes", 1000, true, "i", i);
	}
	SetTimer("AtualizarText", 500, true);
	return 1;
}

public OnGameModeExit()
{
	DOF2_SaveFile();
	DOF2_Exit();
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1940.1903, -2645.8267, 13.5469);
	SetPlayerCameraPos(playerid, 1940.1903, -2645.8267, 13.5469);
	SetPlayerCameraLookAt(playerid, 1940.1903, -2645.8267, 13.5469);

	new  string[200];

	/* -- SISTEMA DE REGISTRO --*/
	if(DOF2_FileExists(Contas(playerid))) {
		format(string, sizeof(string), "{FFFFFF}Seja Bem Vindo novamente ao servidor!\n\nNick:{32CD32} %s{FFFFFF}\n\nNível:{FF0000} %d{FFFFFF}\n\nRegistrado: {00FF00}Sim\n\n{FFFFFF}Digite sua senha para efetuar o login!", GetPlayerNome(playerid), DOF2_GetInt(Contas(playerid), "Level"));
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "BVR - LOGIN", string , "Logar", "Recuperar");
	} else {
		format(string, sizeof(string), "{FFFFFF}Seja Bem Vindo ao servidor!\n\nNick:{32CD32} %s{FFFFFF}\n\nNível:{FF0000} N/A{FFFFFF}\n\nRegistrado: {FF0000}Não\n\n*Digite uma senha para efetuar o registro!*", GetPlayerNome(playerid));
		ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "BVR - REGISTRO", string , "Registrar", "Sair");
	}

	return 1;
}

public OnPlayerConnect(playerid)
{
	//OBJETOS AEROPORTO
	RemoveBuildingForPlayer(playerid, 3672, 1889.6563, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1822.7344, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1682.7266, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1617.2813, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1754.1719, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1617.2813, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1649.0625, -2641.4063, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1682.7266, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1754.1719, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1822.7344, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1889.6563, -2666.0078, 18.8828, 0.25);
	CreateObject(16098, 1887.62842, -2648.11816, 17.43370,   0.00000, 0.00000, 91.00000);
	CreateObject(16098, 1821.55042, -2648.11816, 17.43370,   0.00000, 0.00000, 90.00000);
	CreateObject(16098, 1755.09839, -2648.11816, 17.43370,   0.00000, 0.00000, 90.00000);
	CreateObject(1290, 1788.81494, -2639.88672, 18.47660,   356.85840, 0.00000, -3.12520);
	CreateObject(10814, 1640.06714, -2676.80347, 16.15450,   0.00000, 0.00000, 178.00000);
	CreateObject(1290, 1720.92419, -2639.88672, 18.47656,   356.85840, 0.00000, -3.12515);
	CreateObject(1290, 1630.12244, -2656.98828, 18.47656,   356.85840, 0.00000, -3.12515);
	CreateObject(1290, 1646.11169, -2657.57275, 18.47656,   356.85840, 0.00000, -3.12515);
	//FIM OBJETOS AEROPORTO

	//PEDAGIO ANGEL PINE
	CreateObject(7033, -1119.19543, -2857.91821, 71.06570,   0.00000, 0.00000, 91.00000);
	CreateObject(966, -1120.57800, -2860.29834, 66.66960,   0.00000, 0.00000, 92.30000);
	CreateObject(1237, -1120.27002, -2869.80884, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(1237, -1120.24792, -2867.89624, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(1237, -1120.28540, -2868.87402, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(966, -1121.28479, -2855.61279, 66.66960,   0.00000, 0.00000, -87.76000);
	CreateObject(1237, -1120.24792, -2867.89624, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(1237, -1121.69775, -2848.11035, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(1237, -1120.27002, -2869.80884, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(1237, -1121.70935, -2847.03345, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(1237, -1121.72217, -2845.90430, 66.66370,   0.00000, 0.00000, 0.00000);
	CreateObject(19989, -1160.66919, -2859.07910, 66.65020,   0.00000, 0.00000, 273.00000);
	CreateObject(19989, -1079.16602, -2857.70190, 66.65020,   0.00000, 0.00000, 90.00000);
	//PEDAGIO LS/LV
	CreateObject(9623, 1741.29565, 527.96973, 29.39350,   -3.00000, 0.00000, -18.50000);
	CreateObject(966, 1752.70667, 529.16046, 26.26540,   2.16000, 0.50000, 158.53999);
	CreateObject(966, 1743.73718, 532.58051, 26.26540,   2.16000, 0.50000, 158.53999);
	CreateObject(966, 1738.24561, 523.41498, 26.84540,   -2.50000, 0.00000, -17.96000);
	CreateObject(966, 1729.86572, 526.34528, 26.84540,   -2.50000, 0.00000, -17.96000);
	CreateObject(1237, 1722.46045, 528.80078, 26.96500,   -6.72000, 0.00000, 0.00000);
	CreateObject(1237, 1721.50623, 529.15082, 26.96500,   -6.72000, 0.00000, 0.00000);
	CreateObject(1237, 1759.71533, 526.29120, 26.34500,   0.00000, 0.00000, 0.00000);

	//CANCELA PEDAGIO ANGEL PINE
	CancelaP[playerid][0] = CreatePlayerObject(playerid, 968, -1120.59277, -2860.23462, 67.43290, 0.00000, 90.00000, 272.38000);
	CancelaP[playerid][1] = CreatePlayerObject(playerid, 968, -1121.28052, -2855.66870, 67.43290, 0.00000, 90.00000, 92.18000);
	//CANCELA PEDAGIO LS/LV
	CancelaP[playerid][2] = CreatePlayerObject(playerid, 968, 1752.64233, 529.21753, 27.08570,   0.00000, 90.00000, -21.52000); //Direita meio
	CancelaP[playerid][3] = CreatePlayerObject(playerid, 968, 1743.69641, 532.61810, 27.08570,   0.00000, 90.00000, -21.52000);	//direita
	CancelaP[playerid][4] = CreatePlayerObject(playerid, 968, 1738.31946, 523.43921, 27.62790,   0.00000, 90.00000, 162.17999);	//esquerda
	CancelaP[playerid][5] = CreatePlayerObject(playerid, 968, 1729.92896, 526.36902, 27.62790,   0.00000, 90.00000, 162.17999);	//esuquerda meio


	LimparChat(playerid, 50);
	new Celula[128];
	GetPlayerVersion(playerid, Celula, sizeof(Celula));
	format(Celula, sizeof(Celula), "{FF8C00}Sua versão do SA-MP é:{FFFFFF} %s", Celula);
	SendClientMessage(playerid, 0xFF8C00FF, Celula);
	//Text Relogio e data
	TextDrawShowForPlayer(playerid, Textdraw0);
    TextDrawShowForPlayer(playerid, Textdraw1);
    //Fim text relogio e data
    if(PassagemOferecido[playerid] == 1)
	{
		KillTimer(PassagemTimer[playerid]);
		PassagemOferecido[playerid] = 0;
		PassagemRecebido[playerid] = 0;
		PassagemMensagem[playerid] = 0;
		PassagemValor[playerid] = 0;
		PassagemJa[playerid] = 0;
		PassagemID[playerid] = -1;
	}
    Colher[playerid] = 1;
    Carregado[playerid] = 0;
	Trabalhando[playerid] = 0;
	EmRota[playerid] = 0;
	Plantando[playerid] = 0;
	Colhido[playerid] = 0;
	Ausente[playerid] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	Carregado[playerid] = 0;
	Trabalhando[playerid] = 0;
	EmRota[playerid] = 0;
	Plantando[playerid] = 0;
	Colher[playerid] = 0;
	Colhido[playerid] = 0;
	Ausente[playerid] = 0;
	PlayerLeo[playerid][pSenhaInvalida] = 0;
	SalvarContas(playerid);
	DOF2_SaveFile();
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerPos(playerid, -1060.3507, -1616.7421, 76.3672);
	PlayerLeo[playerid][RegistroNaoConcluido] = false;
	CorProfissao(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(PlayerLeo[playerid][PlanoMedico] == 1) {
		SendClientMessage(playerid, -1, "Tem Plano");
		return 1;
	}
	if(PlayerLeo[playerid][PlanoMedico] == 0) {
		SendClientMessage(playerid, -1, "Não tem Plano");
		return 1;
	}
	if(Trabalhando[playerid] == 1)
	{
		SendClientMessage(playerid, 0xFFFF00FF, "| MORTE | Você morreu em trabalho e o mesmo foi cancelado, para custear as despesas você pagou R$1000 a empresa.");
		GivePlayerMoney(playerid, -1000);
		DisablePlayerRaceCheckpoint(playerid);
		DisablePlayerCheckpoint(playerid);
		Carregado[playerid] = 0;
		Trabalhando[playerid] = 0;
		EmRota[playerid] = 0;
		return 1;
	}
	PlayerLeo[playerid][Morreu]++;
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
	new string[1000];
	if(Calado[playerid] == 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você está calado e não pode falar no chat!");
		return 0;
	}
	if(PlayerLeo[playerid][Admin] == 5) {
		format(string, sizeof(string), "%s{FFFFFF}: [{228B22}Staff{FFFFFF}]{FFFFFF} [%d] %s", GetPlayerNome(playerid), playerid, text);
		SendClientMessageToAll(GetPlayerColor(playerid), string);
		return 0;
	}
	if(PlayerLeo[playerid][Admin] == 4) {
		format(string, sizeof(string), "%s{FFFFFF}: [{B8860B}Sub-Staff{FFFFFF}]{FFFFFF} [%d] %s", GetPlayerNome(playerid), playerid, text);
		SendClientMessageToAll(GetPlayerColor(playerid), string);
		return 0;
	}
	if(PlayerLeo[playerid][Admin] == 3) {
		format(string, sizeof(string), "%s{FFFFFF}: [{1E90FF}Administrador{FFFFFF}]{FFFFFF} [%d] %s", GetPlayerNome(playerid), playerid, text);
		SendClientMessageToAll(GetPlayerColor(playerid), string);
		return 0;
	}
	if(PlayerLeo[playerid][Admin] == 2) {
		format(string, sizeof(string), "%s{FFFFFF}: [{FFA500}Mod{FFFFFF}]{FFFFFF} [%d] %s", GetPlayerNome(playerid), playerid, text);
		SendClientMessageToAll(GetPlayerColor(playerid), string);
		return 0;
	}
	if(PlayerLeo[playerid][Admin] == 1) {
		format(string, sizeof(string), "%s{FFFFFF}: [{FFFF00}Ajudante{FFFFFF}]{FFFFFF} [%d] %s", GetPlayerNome(playerid), playerid, text);
		SendClientMessageToAll(GetPlayerColor(playerid), string);
		return 0;
	}
	if(PlayerLeo[playerid][Admin] == 0) {
		format(string, sizeof(string), "%s{FFFFFF}: [%d] %s", GetPlayerNome(playerid), playerid, text);
		SendClientMessageToAll(GetPlayerColor(playerid), string);
		return 0;
	}
	return 0;
}

/*public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}*/

CMD:sms(playerid, params[]) 
{ 
    new id = -1, texto[128]; 
    sscanf(params, "us[128]", id, texto); 
    if(PlayerLeo[playerid][Celular] == 0) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem um celular!");
    if(PlayerLeo[playerid][Creditos] <= 0) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem créditos!");
    PlayerLeo[playerid][Creditos] --;
    if(id != -1) 
    { 
        if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Este jogador(a) não esta conectado(a)."); 
        if(PlayerLeo[id][Celular] == 0) return SendClientMessage(playerid, COR_ERRO, "| ERRO | O(A) jogador(a) que você está tentando mandar mensagem não tem um celular!");
        if(playerid == id) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não pode mandar mensagem para você!"); 
        if(isnull(texto)) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Digite alguma mensagem!"); 
         
        new nome[MAX_PLAYER_NAME], nome2[MAX_PLAYER_NAME], str[128]; 
        GetPlayerName(playerid, nome, 16); 
        GetPlayerName(id, nome2, 16); 
        format(str, sizeof(str), "| SMS | O Jogador(a) %s[%d] te enviou uma mensagem: %s", nome, playerid, texto);
        GameTextForPlayer(playerid, "Mensagem recebida!", 4000, 1); 
        SendClientMessage(id, COR_SMS, str); 
        format(str, sizeof(str), "| SMS | Você enviou uma mensagem para %s[%d]: %s", nome2, id, texto);
        GameTextForPlayer(playerid, "Mensagem enviada!", 4000, 1); 
        SendClientMessage(playerid, COR_SMS, str); 
    } 
    else SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso correto: /Sms [ID] [Mensagem]"); 
    return 1; 
}

CMD:semparar(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_SEMPARAR, DIALOG_STYLE_TABLIST_HEADERS, "{FF0000}#{FFFFFF}Sem Parar",
	"Quantidade\tPreço(R$)\n\
	10 Passagens{FFFFFF}\t{32CD32}R${FFFFFF}900\n{FFFFFF}20 Passagens{FFFFFF}\t{32CD32}R${FFFFFF}1700\n{FFFFFF}30 Passagens{FFFFFF}\t{32CD32}R${FFFFFF}3200\n{FFFFFF}40 Passagens\t{32CD32}R${FFFFFF}6200", "Comprar", "Sair");
}

CMD:concessionaria(playerid, params[])
{
	static string[sizeof(VeiculosT) * 64]; 
	if (string[0] == EOS) {
		for(new i; i < sizeof(VeiculosT); i ++)
		{
			format(string, sizeof(string), "%s%i\t~w~~h~%s~n~~g~~h~R$%i\n", string, VeiculosT[i][VeiculosID], VeiculosT[i][VeiculoNome], VeiculosT[i][Preco]);
		}
	}
	return ShowPlayerDialog(playerid, DIALOG_CONCE, DIALOG_STYLE_PREVIEW_MODEL, "Concessionaria Terrestre", string, "Comprar", "Sair");
}

CMD:utilitarios(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_UTILITARIOS, DIALOG_STYLE_TABLIST_HEADERS, "Loja de Utilitarios",
	 "Itens\tUnidades\tPreço(R$)\n\
	 Celular\t1\t{32CD32}R${FFFFFF}3000\n\
	 Créditos\t50\t{32CD32}R${FFFFFF}300", "Comprar", "Sair");
	return 1;
}

CMD:admins(playerid, params[])
{
	new ajd, mod, adm, sub, staff;
	new stg2[500], gStr[500], string[128];
	strcat(stg2, "Nome\tCargo\tStatus\n");
	foreach(Player, i)
	{
		if(PlayerLeo[i][Admin] == 5 && Ausente[i] == 0)
		{
			staff++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}Staff\t{32CD32}Online\n", GetPlayerNome(i), i);
            strcat(stg2, gStr);
		}
		if(PlayerLeo[i][Admin] == 5 && Ausente[i] == 1)
		{
			staff++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}Staff\t{FF4500}Ausente\n", GetPlayerNome(i), i);
            strcat(stg2, gStr);
		}
		if(PlayerLeo[i][Admin] == 4 && Ausente[i] == 0)
		{
			sub++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{B8860B}Sub-Staff\t{32CD32}Online\n", GetPlayerNome(i), i); 
            strcat(stg2, gStr);
		}
		if(PlayerLeo[i][Admin] == 4 && Ausente[i] == 1)
		{
			sub++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{B8860B}Sub-Staff\t{FF4500}Ausente\n", GetPlayerNome(i), i); 
            strcat(stg2, gStr);
		}
		if(PlayerLeo[i][Admin] == 3 && Ausente[i] == 0)
		{
			adm++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{1E90FF}Administrador(a)\t{32CD32}Online\n", GetPlayerNome(i), i); 
            strcat(stg2, gStr);
		}
		if(PlayerLeo[i][Admin] == 3 && Ausente[i] == 1)
		{
			adm++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{1E90FF}Administrador(a)\t{FF4500}Ausente\n", GetPlayerNome(i), i); 
            strcat(stg2, gStr);
		}
		if(PlayerLeo[i][Admin] == 2 && Ausente[i] == 0)
		{
			mod++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFA500}Moderador(a)\t{32CD32}Online\n", GetPlayerNome(i), i); 
            strcat(stg2, gStr);
		}
		if(PlayerLeo[i][Admin] == 2 && Ausente[i] == 1)
		{
			mod++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFA500}Moderador(a)\t{FF4500}Ausente\n", GetPlayerNome(i), i); 
            strcat(stg2, gStr);
		}
		if(PlayerLeo[i][Admin] == 1 && Ausente[i] == 0)
		{
			ajd++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFFF00}Ajudante\t{32CD32}Online\n", GetPlayerNome(i), i); 
            strcat(stg2, gStr);
		}
		if(PlayerLeo[i][Admin] == 1 && Ausente[i] == 1)
		{
			ajd++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFFF00}Ajudante\t{FF4500}Ausente\n", GetPlayerNome(i), i); 
            strcat(stg2, gStr);
		}
	}
	new teste = staff + sub + adm + mod + ajd;
	if(teste == 0) return ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "{FFFFFF}Admins Offline", "\n{FF0000}Nenhum membro da administração online no momento!\n\n", "Sair", "");
	format(string, sizeof(string), "{FFFFFF}Administradores Onlines [{32CD32}%d{FFFFFF}]", teste); 
    ShowPlayerDialog(playerid, DIALOG_ADMINS, DIALOG_STYLE_TABLIST_HEADERS, string, stg2, "Fechar", "");
    return 1;
}

CMD:ausente(playerid, params[])
{
	if(PlayerLeo[playerid][Admin] < 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	if(Ausente[playerid] == 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você já está ausente");
		return 1;
	}
	SendClientMessage(playerid, COR_ERRO, "| ADM | Você entrou em modo ausente! Para sair use (/Online)");
	Ausente[playerid] = 1;
	TogglePlayerControllable(playerid, 0);
	return 1;
}

CMD:online(playerid, params[])
{
	if(PlayerLeo[playerid][Admin] < 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	if(Ausente[playerid] == 0)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não está ausente");
		return 1;
	}
	SendClientMessage(playerid, COR_ERRO, "| ADM | Você entrou em modo online novamente!");
	Ausente[playerid] = 0;
	TogglePlayerControllable(playerid, 1);
	return 1;
}

CMD:cv(playerid, params[])
{
	new Float:Cv[3];
	GetPlayerPos(playerid, Cv[0], Cv[1], Cv[2]);
	CreateVehicle(411, Cv[0]+3, Cv[1], Cv[2], 0, -1, -1, -1);
	return 1;
}

CMD:hospital(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_HOSPITAL, DIALOG_STYLE_TABLIST_HEADERS, "Menu - Hospital",
	"Itens\tPreço(R$)\n\
	Plano Médico\t{32CD32}R${FFFFFF}5000\nMudar Sexo\t{32CD32}R${FFFFFF}50000", "Selecionar", "Sair");
	return 1;
}

CMD:cp(playerid, params[])
{
	new texto[24], str[64];
	if(sscanf(params, "s[128]", texto))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso correto: /Cp [Texto].");
	}
	else {
		foreach(Player, i) {
			if(PlayerLeo[i][Profissao] == PlayerLeo[playerid][Profissao]) {
				format(str, sizeof(str), "(Chat Profissão) %s[%d]: %s", GetPlayerNome(playerid), playerid, texto);
				SendClientMessage(i, GetPlayerColor(playerid), str);
			}
		}
	}
	return 1;
}
	
CMD:profissao(playerid, params[])
{
	ComandosProf(playerid);
	return 1;
}

CMD:cnn1(playerid, params[])
{
	new texto[128], str[128];
	if(sscanf(params, "s", texto))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso correto: /Cnn1 [Texto]");
		return 1;
	}
	else {
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
		format(str, sizeof(str), "~g~~h~%s~w~~h~: %s", GetPlayerNome(playerid), texto);
		TextDrawSetString(Aviso[i], str);
		TextDrawShowForPlayer(i, Aviso[i]);
		SetTimerEx("Sumiu", 5000, false, "i", i);
		}
		return 1;
	}
}

CMD:calar(playerid, params[])
{
	if(PlayerLeo[playerid][Admin] < 2 )
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	new id, tempo, motivo[28], string[300];
	if(sscanf(params, "uis", id, tempo, motivo))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /Calar [ID] [Tempo] [Motivo]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido");
		return 1;
	}
	if(Calado[id] == 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) já está mutado");
		return 1;
	}
	if(tempo < 1 || tempo > 20)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Tempo de 1 á 20 minutos!");
		return 1;
	}
	Calado[id] = 1;

	format(string, sizeof(string), "| ADM | O(A) %s %s calou o jogador(a) %s por %i minutos. (Motivo: %s)", AdminLevel(playerid), GetPlayerNome(playerid), GetPlayerNome(id), tempo, motivo);
	SendClientMessageToAll(COR_VERMELHO, string);

	format(string, sizeof(string), "| ADM | O(A) %s %s calou você por %i minutos. (Motivo: %s)", AdminLevel(playerid), GetPlayerNome(playerid), tempo, motivo);
	SendClientMessage(id, COR_VERMELHO, string);

	format(string, sizeof(string), "| INFO | Você calou o jogador(a) %s por %i minutos. (Motivo: %s)", GetPlayerNome(id), tempo, motivo);
	SendClientMessage(playerid, COR_ADM, string);

	TimerCalado[id] = SetTimerEx("MutadoTimer", tempo *1000 *60, false, "i", id);
	return 1;
}

CMD:descalar(playerid, params[])
{
	if(PlayerLeo[playerid][Admin] < 2)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	new id, string[128];
	if(sscanf(params, "u", id))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /Descalar [ID]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido");
		return 1;
	}
	if(Calado[id] == 0)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) não esta calado!");
		return 1;
	}
	Calado[id] = 0;

	format(string, sizeof(string), "| ADM | O(A) %s %s descalou você.", AdminLevel(playerid), GetPlayerNome(playerid));
	SendClientMessage(id, COR_ADM, string);

	format(string, sizeof(string), "| INFO | Você descalou o jogador(a) %s", GetPlayerNome(id));
	SendClientMessage(playerid, COR_ADM, string);

	KillTimer(TimerCalado[id]);
	return 1;
}

CMD:daradmin(playerid, params[]) 
 { 
    if(IsPlayerConnected(playerid)) 
    { 
        if(PlayerLeo[playerid][Admin] < 4) 
        { 
            SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido"); 
            return 1; 
        }
    	new novoadmin, nivel;
	    if(sscanf(params, "ui", novoadmin, nivel)) 
	    { 
	      	SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso correto: /Daradmin [ID] [NivelAdm] ou use /AdminsLevel"); 
	      	return 1; 
	    }
	    if(nivel > 5) {
	    	SendClientMessage(playerid, -1, "| ERRO | Level de admin de 0 á 5 {FF0000}Obs: Level 0 = Jogador{FFFFFF}!");
	    	return 1;
	    }
	    if(novoadmin == INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido(a)"); 
	    PlayerLeo[novoadmin][Admin] = nivel; 
	    new string[128], nome[MAX_PLAYER_NAME+1]; 
	    GetPlayerName(playerid, nome, MAX_PLAYER_NAME); 
	    format(string, sizeof(string), "| INFO | Você foi promovido para %s - Por %s", AdminLevel(novoadmin), GetPlayerNome(playerid)); 
	    SendClientMessage(novoadmin, COR_ADM, string); 
	    GetPlayerName(novoadmin, nome, MAX_PLAYER_NAME); 
	    format(string, sizeof(string), "| INFO | Você promoveu %s para o level %d de Admin. Para mais informações /AdminsLevel", GetPlayerNome(novoadmin), nivel); 
	    SendClientMessage(playerid, COR_ADM, string); 
	} 
    return 1; 
}

CMD:irjogador(playerid, params[])
{
	if(PlayerLeo[playerid][Admin] < 2)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Inválido");
		return 1;
	}
	new id, string[128];
	if(sscanf(params, "u", id))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /IrJogador [ID]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido(a)");
	else {
		new Float:Pos[3];
		GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);
		SetPlayerPos(playerid, Pos[0], Pos[1]+1, Pos[2]);

		format(string, sizeof(string), "| ADM | O(A) %s %s veio até você.", AdminLevel(playerid), GetPlayerNome(playerid));
		SendClientMessage(id, COR_ADM, string);

		format(string, sizeof(string), "| ADM | Você foi até o jogador(a) %s.", GetPlayerNome(id));
		SendClientMessage(playerid, COR_ADM, string);
	}
	return 1;
}

CMD:dargrana(playerid, params[])
{
	if(PlayerLeo[playerid][Admin] < 3)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	new id, grana;
	if(sscanf(params, "ui", id, grana)) 
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /DarGrana [ID] [Quantidade]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido(a)");
	else {
		GivePlayerMoney(playerid, grana);
		new string[128];
		format(string, sizeof(string), "| INFO | O %s %s te deu R$%d", AdminLevel(playerid), GetPlayerNome(playerid), grana);
		SendClientMessage(id, COR_ADM, string);

		format(string, sizeof(string), "| INFO | Você deu R$%d para{FFFFFF} %s", grana, GetPlayerNome(id));
		SendClientMessage(playerid, COR_ADM, string);
	}
	return 1;
}

CMD:darlevel(playerid, params[])
{
	if(PlayerLeo[playerid][Admin] < 3)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	new id, qlevel;
	if(sscanf(params, "ui", id, qlevel))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /DarLevel [ID] [Score]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido(a)");
	else {
		SetPlayerScore(id, qlevel);
		new string[128];
		format(string, sizeof(string), "| INFO | O %s %s te deu %d scores", AdminLevel(playerid), GetPlayerNome(playerid), qlevel);
		SendClientMessage(id, COR_ADM, string);

		format(string, sizeof(string), "| INFO | Você deu %d scores para %s", qlevel, GetPlayerNome(id));
		SendClientMessage(playerid, COR_ADM, string);
	}
	return 1;
}

CMD:tapa(playerid, params[])
{
	if(PlayerLeo[playerid][Admin] < 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	new id;
	if(sscanf(params, "u", id))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /Tapa [ID]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido(a)");
	else {
		new Float:Pos[3], string[128];
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		SetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]+15);
		format(string, sizeof(string), "| ADM | O(A) %s %s deu um tapa no jogador(a) %s.", AdminLevel(playerid), GetPlayerNome(playerid), GetPlayerNome(id));
		SendClientMessageToAll(0xFF0000FF, string);

		format(string, sizeof(string), "| ADM | O(A) %s %s te deu um tapa.", AdminLevel(playerid), GetPlayerNome(playerid));
		SendClientMessage(id, COR_ADM, string);

		format(string, sizeof(string), "| INFO | Você deu um tapa no jogador %s.", GetPlayerNome(id));
		SendClientMessage(playerid, COR_ADM, string);
	}
	return 1;
}

CMD:identidade(playerid, params[])
{
		new stg[1500], gstring[1500], oi[128];
		format(gstring, sizeof(gstring), "{32CD32}~~~~~~~~~~~~~~~~ Identidade ~~~~~~~~~~~~~~~~\n\n");
		strcat(stg, gstring);
		format(gstring, sizeof(gstring), "{FFFFFF}» Level: {32CD32}%d", GetPlayerScore(playerid));
		strcat(stg, gstring);
		if(PlayerLeo[playerid][Celular] == 1) 
		{
			format(gstring, sizeof(gstring), "\n{FFFFFF}» Celular: {32CD32}Possui");
			strcat(stg, gstring);
		}
		if(PlayerLeo[playerid][Celular] == 0) 
		{
			format(gstring, sizeof(gstring), "\n{FFFFFF}» Celular: {FF0000}Não Possui");
			strcat(stg, gstring);
		}
		if(SemParar[playerid])
		{
			format(gstring, sizeof(gstring), "\n{FFFFFF}» SemParar: {32CD32}Possui");
			strcat(stg, gstring);
		}
		if(!SemParar[playerid])
		{
			format(gstring, sizeof(gstring), "\n{FFFFFF}» SemParar: {FF0000}Não Possui");
			strcat(stg, gstring);
		}
		format(gstring, sizeof(gstring), "\n{FFFFFF}» Creditos: {32CD32}%d", PlayerLeo[playerid][Creditos]);
		strcat(stg, gstring);
		format(gstring, sizeof(gstring), "\n{FFFFFF}» Sementes: {32CD32}%d", PlayerLeo[playerid][Sementes]);
		strcat(stg, gstring);
		format(gstring, sizeof(gstring), "\n\n{32CD32}~~~~~~~~~~~~~~~~ Identidade ~~~~~~~~~~~~~~~~");
		strcat(stg, gstring);
		format(gstring, sizeof(gstring), "{FFA500}Identidade de{FFFFFF}: %s", GetPlayerNome(playerid));
		strcat(oi, gstring);

		ShowPlayerDialog(playerid, DIALOG_IDENTIDADE, DIALOG_STYLE_MSGBOX, oi, stg, "Fechar", "");
}

CMD:adminslevel(playerid, params[])
{
	if(PlayerLeo[playerid][Admin] < 4) {
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando invalido");
		return 1;
	}
	ShowPlayerDialog(playerid, ADMIN_LEVEL, DIALOG_STYLE_TABLIST, "Leveis Admin", "Level 1\tAjudante\nLevel 2\tModerador\nLevel 3\tAdministrador\nLevel 4\tSub-Staff", "Sair", "");
	return 1;
}

CMD:cnn(playerid, params[])
{
	if(PlayerLeo[playerid][Admin] < 1) 
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando inválido");
		return 1;
	}
	new texto[128], str[128];
	if(sscanf(params, "s[24]", texto))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso correto: /Cnn [Texto]");
		return 1;
	}
	else {
		format(str, sizeof(str), "~p~] ~w~%s ~p~]", texto);
		GameTextForPlayer(playerid, str, 5000, 3);
		return 1;
	}
}

CMD:carregar(playerid, params[])
{
	if(PlayerLeo[playerid][Profissao] != PILOTO)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce não e um piloto!");
		return 1;
	}
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 593)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não esta em um avião.");
		return 1;
	}
	if(!IsPlayerInPlace(playerid, 1820.931, -2635.032, 1918.360, -2612.415))
	{
        SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não esta no local de carregamento.");
        return 1;
    }
	if(Carregado[playerid] == 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você já esta carregado.");
		return 1;
	}
	CCP[playerid] = 1;
	Carregado[playerid] = 1;
	Trabalhando[playerid] = 1;
	SetPlayerRaceCheckpoint(playerid, 0, 1322.6554, 1354.3180, 10.8203, 306.5969,2519.2402,16.6951, 3.0); //aero lv
	SendClientMessage(playerid, -1, "| AEROPORTO | Você pegou 3 pacotes entregue-os no {FF0000}checkpoint {FFFFFF}marcado em seu mapa");
	return 1;
}

CMD:duvida(playerid, params[])
{
	new duvida, string[128];
	if(sscanf(params, "s[64]", duvida))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso válido: /Duvida [Texto]" );
		return 1;
	}
	foreach(Player, i)
	{
		if(PlayerLeo[i][Admin] >= 1)
		{
			format(string, sizeof(string), "| ADM | Dúvida recebida de %s[%d]: %s", GetPlayerNome(playerid), playerid, duvida);
			SendClientMessage(i, COR_DUVIDA, string);
			GameTextForPlayer(i, "~b~~h~DUVIDA", 5000, 4);
		}
	}
	return 1;
}

CMD:venderpassagem(playerid, params[])
{
	if(PlayerLeo[playerid][Profissao] != MOTORISTA_ONIBUS)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não é um Motorista de Ônibus.");
		return 1;
	}
	new id, valor, str[250];
	new Float:Pos[3];
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	if(sscanf(params, "ui", id, valor)) //id = outro player 
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso correto: /VenderPassagem [ID] [Preço]");
		return 1;
	}
	if(id == playerid) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não pode vender para si mesmo!");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) inválido(a)");
	if(valor < 1 || valor > 100)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Valor por passagem de R$1 á R$100");
		return 1;
	}
	if(PassagemJa[playerid] == 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você ja fez uma oferta! Aguarde.");
		return 1;
	}
	if(GetPlayerMoney(id) < valor)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | O(A) Jogador(a) não tem dinheiro suficiente para comprar passagem");
		return 1;
	}
	if(!IsPlayerInRangeOfPoint(id, 7.0, Pos[0], Pos[1], Pos[2]))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) muito longe.");
		return 1;
	}
	else {
		format(str, sizeof(str), "| PASSAGEM | Você ofereceu uma passagem para %s no valor de R$%d", GetPlayerNome(id), valor);
		SendClientMessage(playerid, COR_MOTORISTABUS, str);
		format(str, sizeof(str), "| PASSAGEM | O(A) Motorista de Ônibus %s esta te oferecendo uma passagem por R$%d. (/pAceitar | /pRecusar).", GetPlayerNome(playerid), valor);
		SendClientMessage(id, COR_MOTORISTABUS, str);
		PassagemJa[playerid] = 1;
		PassagemValor[id] = valor;
		PassagemPID[id] = playerid;
		PassagemID[id] = playerid;
		PassagemOferecido[playerid] = 1;
		PassagemRecebido[id] = 1;
		PassagemTimer[id] = SetTimerEx("MsgPassagem", 4000, false, "d", id);
		return 1;
	}

}

CMD:paceitar(playerid, params[])
{
	if(PassagemRecebido[playerid] == 0)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não recebeu nenhuma oferta de passagem.");
		return 1;
	}
	SendClientFormat(PassagemID[playerid], COR_MOTORISTABUS, "| PASSAGEM | %s aceitou sua oferta, passagem vendida com sucesso!", GetPlayerNome(playerid));
	SendClientFormat(playerid, COR_MOTORISTABUS, "| PASSAGEM | Você aceitou a passagem, oferta feita por %s.", GetPlayerNome(PassagemID[playerid]));
	GivePlayerMoney(playerid, -PassagemValor[playerid]);
	GivePlayerMoney(PassagemPID[playerid],	PassagemValor[playerid]);
	PassagemOferecido[PassagemID[playerid]] = 0;
	PassagemJa[playerid] = 0;
	PassagemRecebido[playerid] = 0;
	PassagemID[playerid] = 0;
	PassagemValor[playerid] = 0;
	return 1;
}

CMD:precusar(playerid, params[])
{
	if(PassagemRecebido[playerid] == 0)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não recebeu nenhuma oferta de passagem.");
		return 1;
	}
	SendClientFormat(PassagemID[playerid], COR_MOTORISTABUS, "| PASSAGEM | %s recusou sua oferta, a passagem não foi vendida, sua venda não obteve sucesso!", GetPlayerNome(playerid));
	SendClientFormat(playerid, COR_MOTORISTABUS, "| PASSAGEM | Você recusou a passagem, oferta feita por %s, você não comprou a passagem.", GetPlayerNome(PassagemID[playerid]));
	PassagemOferecido[PassagemID[playerid]] = 0;
	PassagemRecebido[playerid] = 0;
	PassagemJa[playerid] = 0;
	PassagemValor[playerid] = 0;
	PassagemID[playerid] = -1;
	return 1;
}

CMD:iniciarrota(playerid, params[])
{
	if(PlayerLeo[playerid][Profissao] != MOTORISTA_ONIBUS)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não é um Motorista de Ônibus.");
		return 1;
	}
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 437)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não está em um Ônibus.");
		return 1;
	}
	if(!IsPlayerInPlace(playerid, 2802.457, 1257.640, 2833.595, 1377.551))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não esta na rodoviária.");
		return 1;
	}
	if(EmRota[playerid] == 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você ja iniciou uma rota.");
		return 1;
	}
	ShowPlayerDialog(playerid, DIALOG_ROTAONIBUS, DIALOG_STYLE_LIST, "Rotas Disponiveis", "San Fierro", "Iniciar", "Cancelar");
	return 1;
}

CMD:profs(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_AGENCIA, DIALOG_STYLE_LIST, "{FF0000}Profissões", "{FFFFFF}Classe » {38b170}Honestas\n{FFFFFF}Classe » {8bcffa}Transporte\n{FFFFFF}Classe » {847c7f}Governo\n{FFFFFF}Classe » {218ffd}Policia\n{FFFFFF}Classe » {211b88}Forças Armadas\n{FFFFFF}Classe » {840000}Mafia\n", "Selecionar", "Sair");
	return 1;
}

CMD:carregarm(playerid, params[])
{
	if(PlayerLeo[playerid][Profissao] != MOTORISTA_CARROFORTE)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não é um Motorista de Carro Forte!");
		return 1;
	}
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 428)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não está em um Carro Forte!");
		return 1;
	}
	if(EmRota[playerid] == 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você já está em uma rota.");
		return 1;
	}
	ShowPlayerDialog(playerid, DIALOG_ROTACARRO, DIALOG_STYLE_TABLIST_HEADERS, "Rotas Disponives", 
	"Local:\tLucro(R$):\n\
	Angel Pine\tR$900", "Iniciar", "Cancelar");
	return 1;
}

CMD:minhassementes(playerid, params[])
{
	new string[72];
	format(string, sizeof(string), "\n{FFFFFF}» Você tem uma total de {1E90FF}%d{FFFFFF} sementes.\n\n", PlayerLeo[playerid][Sementes]);
	ShowPlayerDialog(playerid, DIALOG_SEMENTES, DIALOG_STYLE_MSGBOX, "{FF0000}# {FFFFFF}Sementes", string, "Sair", "");
	return 1;
}

CMD:comprarsementes(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_SEMENTE, DIALOG_STYLE_TABLIST_HEADERS, "{00FF00}# {FFFFFF}Sementes",
	"Quantidade\tPreço (R$)\n\
	10 Sementes\t{32CD32}R${FFFFFF}3000\n20 Sementes\t{32CD32}R${FFFFFF}5000\n30 Sementes\t{32CD32}R${FFFFFF}8000", "Comprar", "Cancelar");
	return 1;
}

CMD:colher(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Não pode colher dentro de um veiculo.");
		return 1;
	}
	if(PlayerLeo[playerid][Profissao] != FAZENDEIRO) {
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não é um fazendeiro.");
		return 1;
	}
	if(Colher[playerid] == 1) {
		SendClientMessage(playerid, COR_ERRO, "| ERRO | A sua maconha ainda não esta pronta para colher");
		return 1;
	}
	if(Colhido[playerid] == 1) {
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você já colheu ou não plantou nada!");
		return 1;
	}
	for(new i = 0; i < sizeof(PlantacaoF); i ++) { 
        if(IsPlayerInRangeOfPoint(playerid, 0.6, PlantacaoF[i][posX], PlantacaoF[i][posY], PlantacaoF[i][posZ])) 
        {
        	new string[128];
			new gramas = random(300 - 100) + 100;
			new grana = random(1000 - 500) + 500;
			GivePlayerMoney(playerid, grana);
			DestroyObject(Maconha);
			Colhido[playerid] = 1;
			Plantando[playerid] = 0;
			format(string, sizeof(string), "| INFO | Você colheu {FF0000}%d gramas{FFFFFF} de maconha, e recebeu {228B22}R$%d{FFFFFF}.", gramas, grana);
			SendClientMessage(playerid, -1, string); 
			return i;
        }
    }
	return -1;
}

CMD:plantarmaconha(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Não pode plantar dentro de um veiculo.");
		return 1;
	}
	if(PlayerLeo[playerid][Profissao] != FAZENDEIRO) {
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não é um fazendeiro");
		return 1;
	}
	if(PlayerLeo[playerid][Sementes] < 2) {
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem sementes o suficiente para plantar maconha (2 Sementes necessárias)");
		return 1;
	}
	if(Plantando[playerid] == 1) {
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Já começou a plantar espere até crescer para plantar novamente.");
		return 1;
	}
	for(new i = 0; i < sizeof(PlantacaoF); i ++) { 
        if(IsPlayerInRangeOfPoint(playerid, 0.6, PlantacaoF[i][posX], PlantacaoF[i][posY], PlantacaoF[i][posZ])) 
        {
        	SendClientMessage(playerid, -1, "| INFO | Você começou a plantar maconha, espere até crescer e colha.");
			ApplyAnimation(playerid,"BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 10000, 0);
			ApplyAnimation(playerid,"BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 10000, 0);
			PlayerLeo[playerid][Sementes] -= 2;
			Plantando[playerid] = 1;
			Colher[playerid] = 1;
			Colhido[playerid] = 0;
			SetTimerEx("Plantar1", 10000, false, "i", playerid);
            return i; 
        }
    }
    return -1; 
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
	if(newstate == PLAYER_STATE_DRIVER)
    {
	    new
			veiculo = GetPlayerVehicleID(playerid)
		;
		if(veiculo == PAviao[0] || veiculo == PAviao[1] || veiculo == PAviao[2] || veiculo == PAviao[3] || veiculo == PAviao[4] || veiculo == PAviao[5] || veiculo == PAviao[6])
			{
				if(PlayerLeo[playerid][Profissao] != PILOTO) {
				RemovePlayerFromVehicle(playerid);
				SendClientMessage(playerid, COR_ERRO, "| ERRO | Veículo reservado para Pilotos.");
				return 1;
			}
		}
		if(veiculo == MOnibus[0] || veiculo == MOnibus[1] || veiculo == MOnibus[2] || veiculo == MOnibus[3] || veiculo == MOnibus[4] || veiculo == MOnibus[5] || veiculo == MOnibus[6])
			{
				if(PlayerLeo[playerid][Profissao] != MOTORISTA_ONIBUS) {
				RemovePlayerFromVehicle(playerid);
				SendClientMessage(playerid, COR_ERRO, "| ERRO | Veículo reservado para Motorista de Ônibus.");
				return 1;
			}
		}
		if(veiculo == CarroForte[0] || veiculo == CarroForte[1] || veiculo == CarroForte[2] || veiculo == CarroForte[3] || veiculo == CarroForte[4] || veiculo == CarroForte[5])
		{
			if(PlayerLeo[playerid][Profissao] != MOTORISTA_CARROFORTE) {
				RemovePlayerFromVehicle(playerid);
				SendClientMessage(playerid, COR_ERRO, "| ERRO | Veículo reservado para Pilotos.");
				return 1;
			}
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(CCO[playerid] == 1)
 	{
 		SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~INICIANDO ~b~~h~ROTA~w~...", 5000, 4);
 		DisablePlayerCheckpoint(playerid);
 		CCO[playerid] = 2;
 		SetPlayerRaceCheckpoint(playerid, 0, 2074.7566, 1467.4360, 10.6719, 2145.1140, 1841.6689, 10.6719, 3.0);
 		return 1;
 	}
 	if(CheckCF[playerid] == 1)
 	{
 		SetTimerEx("Carregando", 3000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~CARREGANDO ~g~~h~MALOTES...", 3000, 4);
 		DisablePlayerCheckpoint(playerid);
 		CheckCF[playerid] = 2;
 		SetPlayerCheckpoint(playerid, -1556.9434, -2739.6458, 48.5459, 5.0);
 		return 1;
 	}
 	if(CheckCF[playerid] == 2)
 	{
 		SendClientMessage(playerid, COR_BRANCO, "| BANCO | Você abasteceu o caixa em {1E90FF}Angel Pine{FFFFFF} e recebeu {32CD32}R$900");
 		GivePlayerMoney(playerid, 900);
 		EmRota[playerid] = 0;
 		DisablePlayerCheckpoint(playerid);
 		return 1;
 	}
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(CCP[playerid] == 1)
    {
    	SetTimerEx("DescarregarA", 5000, false, "i", playerid);
    	TogglePlayerControllable(playerid, 0);
    	GameTextForPlayer(playerid, "DESCARREGANDO...", 5000, 4);
        DisablePlayerRaceCheckpoint(playerid);
        CCP[playerid] = 2;
        SetPlayerRaceCheckpoint(playerid, 0, 306.5969,2519.2402,16.6951, -1191.6188,-162.3909,14.1484, 3.0); //aeroab
        return 1;
    }
    if(CCP[playerid] == 2)
    {
    	SetTimerEx("DescarregarA", 5000, false, "i", playerid);
    	TogglePlayerControllable(playerid, 0);
    	GameTextForPlayer(playerid, "DESCARREGANDO...", 5000, 4);
        DisablePlayerRaceCheckpoint(playerid);
        CCP[playerid] = 3;
        SetPlayerRaceCheckpoint(playerid, 1, -1191.6188,-162.3909,14.1484, -1191.6188,-162.3909,14.1484, 3.0); //aerosf
        return 1;
    }
    if(CCP[playerid] == 3)
    {
    	SetTimerEx("DescarregouT", 5000, false, "i", playerid);
    	TogglePlayerControllable(playerid, 0);
    	GameTextForPlayer(playerid, "DESCARREGANDO...", 5000, 4);
    	DisablePlayerRaceCheckpoint(playerid);
        return 1;
    }
    if(CCO[playerid] == 2)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 3;
 		SetPlayerRaceCheckpoint(playerid, 0, 2145.1140, 1841.6689, 10.6719, 2230.9080, 2401.1260, 10.6719, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 3)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 4;
 		SetPlayerRaceCheckpoint(playerid, 0, 2230.9080, 2401.1260, 10.6719, 1924.0610, 2315.3696, 10.6719, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 4)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 5;
 		SetPlayerRaceCheckpoint(playerid, 0, 1924.0610, 2315.3696, 10.6719, 1564.5828, 2201.2500, 10.6719, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 5)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 6;
 		SetPlayerRaceCheckpoint(playerid, 0, 1564.5828, 2201.2500, 10.6719, 1503.4354, 2056.4260, 10.6719, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 6)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 7;
 		SetPlayerRaceCheckpoint(playerid, 0, 1503.4354, 2056.4260, 10.6719, 1336.3447,2055.9392,10.6719, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 7)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 8;
 		SetPlayerRaceCheckpoint(playerid, 0, 1336.3447, 2055.9392, 10.6719, 652.4479, 1724.1727, 6.9922, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 8)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 9;
 		SetPlayerRaceCheckpoint(playerid, 0, 652.4479, 1724.1727, 6.9922, 345.8485, 1412.4386, 6.6120, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 9)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 10;
 		SetPlayerRaceCheckpoint(playerid, 0, 345.8485, 1412.4386, 6.6120, -67.2117, 1202.1240, 19.5938, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 10)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 11;
 		SetPlayerRaceCheckpoint(playerid, 0, -67.2117, 1202.1240, 19.5938, -198.4940, 1006.8690, 19.5794, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 11)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 12;
 		SetPlayerRaceCheckpoint(playerid, 0, -198.4940, 1006.8690, 19.5794, -1894.4221,583.9077,34.9078, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 12)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 13;
 		SetPlayerRaceCheckpoint(playerid, 0, -1894.4221, 583.9077, 34.9078, -2224.1926, 569.7197, 35.0156, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 13)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 14;
 		SetPlayerRaceCheckpoint(playerid, 0, -2224.1926, 569.7197, 35.0156, -2149.1113, 255.8757, 35.1719, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 14)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 15;
 		SetPlayerRaceCheckpoint(playerid, 0, -2149.1113, 255.8757, 35.1719, -2025.3326, -72.8854, 35.1719, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 15)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 16;
 		SetPlayerRaceCheckpoint(playerid, 0, -2025.3326, -72.8854, 35.1719, -1989.9607, 150.7433, 27.5391, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 16)
    {
    	SetTimerEx("PassageirosE", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~EMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		CCO[playerid] = 17;
 		SetPlayerRaceCheckpoint(playerid, 1, -1989.9607, 150.7433, 27.5391, -1989.9607, 150.7433, 27.5391, 3.0);
 		return 1;
    }
    if(CCO[playerid] == 17)
    {
    	SetTimerEx("PassageirosD", 5000, false, "i", playerid);
 		TogglePlayerControllable(playerid, 0);
 		GameTextForPlayer(playerid, "~w~~h~DESEMBARCANDO ~b~~h~PASSAGEIROS~w~...", 5000, 4);
 		DisablePlayerRaceCheckpoint(playerid);
 		return 1;
    }
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
	switch(dialogid) {
		case DIALOG_LOGIN: {
			if(response) {
				if(!strval(inputtext)) {
					new string[500];
					SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não digitou sua senha para entrar na sua Contas");
					format(string, sizeof(string), "{FFFFFF}Seja Bem Vindo novamente ao servidor!\n\nNick:{32CD32} %s{FFFFFF}\n\nNível:{FF0000} %d{FFFFFF}\n\nRegistrado: {00FF00}Sim\n\n{FFFFFF}Digite sua senha para efetuar o login!", GetPlayerNome(playerid), DOF2_GetInt(Contas(playerid), "Level"));
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "BVR - LOGIN", string , "Logar", "Recuperar");
				} else {
					PlayerLeo[playerid][Senha] = DOF2_GetInt(Contas(playerid), "Senha");
					if(strval(inputtext) == PlayerLeo[playerid][Senha]) {
						new string[128];
						CarregarConta(playerid);
                		GivePlayerMoney(playerid, PlayerLeo[playerid][Dinheiro]);
                		LimparChat(playerid, 128);
                		SendClientMessage(playerid, 0x006400FF, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
						format(string, sizeof(string), "Seja Bem Vindo novamente {006400}%s{FFFFFF}! Seu ultimo login foi dia {FF0000}%02d/%02d/%d.", GetPlayerNome(playerid), PlayerLeo[playerid][UltimoLoginD], PlayerLeo[playerid][UltimoLoginM], PlayerLeo[playerid][UltimoLoginA]);
						SendClientMessage(playerid, -1, string);
						SendClientMessage(playerid, 0x006400FF, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
						SpawnPlayer(playerid);						
						return 1;
					} else {
						PlayerLeo[playerid][pSenhaInvalida]++;
						if(PlayerLeo[playerid][pSenhaInvalida] == 3) return Kick(playerid);
						new string[500];
						format(string, sizeof(string), "| ERRO | Senha Inválida! Tentativas [%d/3]", PlayerLeo[playerid][pSenhaInvalida]);
						SendClientMessage(playerid, COR_ERRO, string);
						format(string, sizeof(string), "{FFFFFF}Seja Bem Vindo novamente ao servidor!\n\nNick:{32CD32} %s{FFFFFF}\n\nNível:{FF0000} %d{FFFFFF}\n\nRegistrado: {00FF00}Sim\n\n{FFFFFF}Digite sua senha para efetuar o login!", GetPlayerNome(playerid), DOF2_GetInt(Contas(playerid), "Level"));
						ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "BVR - LOGIN", string , "Logar", "Recuperar");
					}
				}
			} else {
				new string[500];
				format(string, sizeof(string), "{FFFFFF}Seja Bem Vindo novamente ao servidor!\n\nNick:{32CD32} %s{FFFFFF}\n\nNível:{FF0000} %d{FFFFFF}\n\nRegistrado: {00FF00}Sim\n\n{FFFFFF}Digite sua senha para efetuar o login!", GetPlayerNome(playerid), DOF2_GetInt(Contas(playerid), "Level"));
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "BVR - LOGIN", string , "Logar", "Recuperar");
				SendClientMessage(playerid, COR_ERRO, "| ERRO | Sistema em construção!");
				return 1;
			}
			return 1;
		}
		case DIALOG_REGISTRO: {
			if(response) {
				if(!strlen(inputtext)) {
					new string[500];
					SendClientMessage(playerid, COR_ERRO, "| ERRO | Você nao digitou uma senha para registrar sua conta");
					format(string, sizeof(string), "{FFFFFF}Seja Bem Vindo ao servidor!\n\nNick:{32CD32} %s{FFFFFF}\n\nNível:{FF0000} N/A{FFFFFF}\n\nRegistrado: {FF0000}Não\n\n*Digite uma senha para efetuar o registro!*", GetPlayerNome(playerid));
					ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "BVR - REGISTRO", string , "Registrar", "Sair");
				} else {
					DOF2_CreateFile(Contas(playerid));
					PlayerLeo[playerid][Senha] = strval(inputtext);
					DOF2_SetInt(Contas(playerid), "Dinheiro", 5000);
					DOF2_SetInt(Contas(playerid), "Level", 0);
					PlayerLeo[playerid][Profissao] = DESEMPREGADO;
					PlayerLeo[playerid][Admin] = 0;
					PlayerLeo[playerid][Celular] = 0;
					PlayerLeo[playerid][Creditos] = 0;
					GivePlayerMoney(playerid, 5000);
					SetPlayerScore(playerid, 1);
					SalvarContas(playerid);
					PlayerLeo[playerid][RegistroNaoConcluido] = true;
					SpawnPlayer(playerid);
					LimparChat(playerid, 128);
					SendClientMessage(playerid, COR_BRANCO, "Seja Bem Vindo ao Servidor!");
					return 1;
				}
			} else {
				new file[123];
				format(file, sizeof(file), "Contas/%s.ini", GetPlayerNome(playerid));
				DOF2_RemoveFile(file);
				DOF2_SaveFile();
			}
			return 1;
		}
	}
	if(dialogid == DIALOG_AGENCIA) {
		if(response) {
			switch(listitem) {
				case 0: {
					new string[1300];
                    strcat(string, "{FFFFFF}Profissão\t{ff4503}Level\t{1a8622}Salario{FFFFFF}\n");
					strcat(string, "Desempregado\t{ff4503}0\t{1a8622}$220{FFFFFF}\n");
                    strcat(string, "Caçador\t{ff4503}0\t{1a8622}$600{FFFFFF}\n");
                    strcat(string, "Pescador\t{ff4503}5\t{1a8622}$600{FFFFFF}\n");
                    strcat(string, "Gari\t{ff4503}6\t{1a8622}$600{FFFFFF}\n");
                    strcat(string, "Mecânico\t{ff4503}7\t{1a8622}$700{FFFFFF}\n");
                    strcat(string, "Paraquedista\t{ff4503}8\t{1a8622}$750{FFFFFF}\n");
                    strcat(string, "Pizza Boy\t{ff4503}10\t{1a8622}$750{FFFFFF}\n");
                    strcat(string, "Correios\t{ff4503}15\t{1a8622}$750{FFFFFF}\n");
                    strcat(string, "Paramedico\t{ff4503}20\t{1a8622}$800{FFFFFF}\n");
                    strcat(string, "Dnit\t{ff4503}23\t{1a8622}$820{FFFFFF}\n");
                    strcat(string, "Frentista\t{ff4503}25\t{1a8622}$850{FFFFFF}\n");
                    strcat(string, "Fotografo\t{ff4503}30\t{1a8622}$870{FFFFFF}\n");
                    strcat(string, "Instrutor de Direção\t{ff4503}40\t{1a8622}$900{FFFFFF}\n");
                    strcat(string, "Bombeiro\t{ff4503}45\t{1a8622}$910{FFFFFF}\n");
                    strcat(string, "Padre\t{ff4503}45\t{1a8622}$920{FFFFFF}\n");
                    strcat(string, "Vendedor de HotDog\t{ff4503}46\t{1a8622}$920{FFFFFF}\n");
                    strcat(string, "Sorvetero\t{ff4503}47\t{1a8622}$930{FFFFFF}\n");
                    strcat(string, "Barman\t{ff4503}47\t{1a8622}$940{FFFFFF}\n");
                    strcat(string, "Jornalista\t{ff4503}50\t{1a8622}$950{FFFFFF}\n");
                    strcat(string, "Vendedor de Skin\t{ff4503}55\t{1a8622}$980{FFFFFF}\n");
                    strcat(string, "Meteorologista\t{ff4503}60\t{1a8622}$1000{FFFFFF}\n");
                    strcat(string, "Advogado\t{ff4503}75\t{1a8622}$1500{FFFFFF}\n");
                    strcat(string, "Bancario\t{ff4503}80\t{1a8622}$1700{FFFFFF}\n");
                    strcat(string, "Corretor de Imoveis\t{ff4503}150\t{1a8622}$1000 ");
                    ShowPlayerDialog(playerid, DIALOG_HONES, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Profissões Honestas", string,"Selecionar", "Voltar");
                }
                case 1:{
                	new string[750];
                    strcat(string, "{FFFFFF}Profissão\t{ff4503}Level\t{1a8622}Salario{FFFFFF}\n");
                    strcat(string, "Petroleiro\t{ff4503}0\t{1a8622}$800{FFFFFF}\n");
                    strcat(string, "Transportador\t{ff4503}5\t{1a8622}$820{FFFFFF}\n");
                    strcat(string, "Minerador\t{ff4503}10\t{1a8622}$850{FFFFFF}\n");
                    strcat(string, "Piloto\t{ff4503}15\t{1a8622}$880{FFFFFF}\n");
                    strcat(string, "Carregadores\t{ff4503}20\t{1a8622}$900{FFFFFF}\n");
                    strcat(string, "Maquinista\t{ff4503}25\t{1a8622}$950{FFFFFF}\n");
                    strcat(string, "Carregador de Concreto\t{ff4503}40\t{1a8622}$1000{FFFFFF}\n");
                    strcat(string, "Motorista de Carro Forte\t{ff4503}85\t{1a8622}$1000{FFFFFF}\n");
                    strcat(string, "Motorista de Onibus\t{ff4503}20\t{1a8622}$800{FFFFFF}\n");
                    strcat(string, "Taxista\t{ff4503}25\t{1a8622}$850{FFFFFF}\n");
                    strcat(string, "Moto Taxi\t{ff4503}25\t{1a8622}$850{FFFFFF}\n");
                    strcat(string, "Taxi Aereo\t{ff4503}30\t{1a8622}$900{FFFFFF}\n");
                    strcat(string, "Motorista Particular\t{ff4503}33\t{1a8622}$900");
                    ShowPlayerDialog(playerid, DIALOG_TRANSPORTES, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Profissões Transportes", string,"Selecionar", "Voltar");
                }
                case 2:{
                	new string[180];
                    strcat(string, "{FFFFFF}Profissão\t{ff4503}Level\t{1a8622}Salario{FFFFFF}\n");
                    strcat(string, "Corregedoria\t{ff4503}900\t{1a8622}$5000{FFFFFF}\n");
                    strcat(string, "Aposentado\t{ff4503}1500\t{1a8622}$10000");
                    ShowPlayerDialog(playerid, DIALOG_GOVERNO, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Profissões Governo", string,"Selecionar", "Voltar");
                }
                case 3:{
                	new string[500];
                    strcat(string, "{FFFFFF}Profissão\t{ff4503}Level\t{1a8622}Salario{FFFFFF}\n");
                    strcat(string, "Policia Militar\t{ff4503}80\t{1a8622}$1000{FFFFFF}\n");
                    strcat(string, "Ibama\t{ff4503}100\t{1a8622}$1100{FFFFFF}\n");
                    strcat(string, "Policia Federal\t{ff4503}130\t{1a8622}$1250{FFFFFF}\n");
                    strcat(string, "Delegado\t{ff4503}150\t{1a8622}$1500{FFFFFF}\n");
                    strcat(string, "FBI\t{ff4503}200\t{1a8622}$1800{FFFFFF}\n");
                    strcat(string, "CIA\t{ff4503}230\t{1a8622}$2150{FFFFFF}\n");
                    strcat(string, "S.W.A.T\t{ff4503}250\t{1a8622}$2500{FFFFFF}\n");
                    strcat(string, "Narcoticos\t{ff4503}300\t{1a8622}$3000{FFFFFF}\n");
                    strcat(string, "Interpol\t{ff4503}450\t{1a8622}$3500");
                    ShowPlayerDialog(playerid, DIALOG_POLICIA, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Profissões Policia", string,"Selecionar", "Voltar");
                }
                case 4:{
                	new string[180];
                    strcat(string, "{FFFFFF}Profissão\t{ff4503}Level\t{1a8622}Salario{FFFFFF}\n");
                    strcat(string, "Marinha\t{ff4503}800\t{1a8622}$6000{FFFFFF}\n");
                    strcat(string, "Exercito\t{ff4503}1000\t{1a8622}$7500{FFFFFF}\n");
                    strcat(string, "Aeronautica\t{ff4503}1100\t{1a8622}$8000");
                    ShowPlayerDialog(playerid, DIALOG_FARMADAS, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Profissões Forças Armadas", string,"Selecionar", "Voltar");
                }
                case 5:{
                	new string[800];
                    strcat(string, "{FFFFFF}Profissão\t{ff4503}Level\t{1a8622}Salario{FFFFFF}\n");
                    strcat(string, "Fazendeiro\t{ff4503}10\t{1a8622}$600{FFFFFF}\n");
                    strcat(string, "Transportador de Drogas\t{ff4503}15\t{1a8622}$600{FFFFFF}\n");
                    strcat(string, "Vendedor de Drogas\t{ff4503}20\t{1a8622}$700{FFFFFF}\n");
                    strcat(string, "Traficante de Armas\t{ff4503}40\t{1a8622}$800{FFFFFF}\n");
                    strcat(string, "Sequestrador\t{ff4503}65\t{1a8622}$800{FFFFFF}\n");
                    strcat(string, "Assaltante\t{ff4503}80\t{1a8622}$900{FFFFFF}\n");
                    strcat(string, "Assassino\t{ff4503}150\t{1a8622}$1000{FFFFFF}\n");
                    strcat(string, "Petroleiro Clandestino\t{ff4503}250\t{1a8622}$1500{FFFFFF}\n");
                    strcat(string, "Chefao da Mafia\t{ff4503}400\t{1a8622}$2000{FFFFFF}\n");
                    strcat(string, "Terrorista\t{ff4503}800\t{1a8622}$5000");
                    ShowPlayerDialog(playerid, DIALOG_MAFIA, DIALOG_STYLE_TABLIST_HEADERS, "Profissões Máfia", string, "Selecionar", "Voltar");
                }
			}
			return 1;
		}
	}
	if(dialogid == DIALOG_HONES) {
		if(response) {
			switch(listitem) {
				case 0: {
					if(PlayerLeo[playerid][Profissao] == DESEMPREGADO)
					{
						SendClientMessage(playerid, -1, "| ERRO | Você já é um Desempregado!");
						return 1;
					}
					if(GetPlayerScore(playerid) >= 0) {
						SendClientMessage(playerid, -1, "| INFO | Parabéns agora você é um desempregado!");
						PlayerLeo[playerid][Profissao] = DESEMPREGADO;
						SetPlayerColor(playerid, COR_DESEMPREGADO);
					}
					else {
						SendClientMessage(playerid, -1, "Você não tem nivel suficiente para esta profissão");
					}
					return 1;
				}
				case 1: {
					//Caçador
				}
				case 2: {
					//Pescador
				}
				case 3: {
					//Gari
				}
				case 4: {
					//Mecanico
				}
				case 5: {
					//Paraquedista
				}
				case 6: {
					//PizzaBoy
				}
				case 7: {
					//Correios
				}
				case 8: {
					//Paramedicos
				}
				case 9: {
					//Dnit
				}
				case 10: {
					//Frentista
				}
				case 11: {
					//Fotografo
				}
				case 12: {
					//InstrutorDirecao
				}
				case 13: {
					//Bombeiro
				}
				case 14: {
					////Padre
				}
				case 15: {
					//Vendedor de hotdog
				}
				case 16: {
					//sorveiteiro
				}
				case 17: {
					//Barman
				}
				case 18: {
					//JORNAL
				}
				case 19: {
					//Vendedor de Skin
				}
				case 20: {
					//Metereologista
				}
				case 21: {
					//Advogado
				}
				case 22: {
					//Bancario
				}
				case 23:{
					//Corretor de Imoevis
				}
			}
		}
		else {
			ShowPlayerDialog(playerid, DIALOG_AGENCIA, DIALOG_STYLE_LIST, "{FF0000}Profissões", "{FFFFFF}Classe » {38b170}Honestas\n{FFFFFF}Classe » {8bcffa}Transporte\n{FFFFFF}Classe » {847c7f}Governo\n{FFFFFF}Classe » {218ffd}Policia\n{FFFFFF}Classe » {211b88}Forças Armadas\n{FFFFFF}Classe » {840000}Mafia\n", "Selecionar", "Sair");
		}
		return 1;
	}

	if(dialogid == DIALOG_TRANSPORTES) {
		if(response) {
            switch(listitem) {
                case 0: { //Petroleiro
                }
                case 1: { //Transportador
                }
				case 2: { //Minerador
				}
				case 3:
				{
					if(PlayerLeo[playerid][Profissao] == PILOTO)
					{
						SendClientMessage(playerid, COR_ERRO, "| ERRO | Você já é um piloto!");
						return 1;
					}
					if(GetPlayerScore(playerid) >= 15)
					{
						SendClientMessage(playerid, COR_PILOTO, "| PILOTO | Parabéns agora você é um Piloto");
						PlayerLeo[playerid][Profissao] = PILOTO;
						SetPlayerColor(playerid, COR_PILOTO);
					}
					else {
						SendClientMessage(playerid, COR_ERRO, "Você não tem o level suficiente para esta profissão!");
					}
					return 1;
				}
				case 4: { //Carregadores
				}
				case 5: { //Maquinista
				}
				case 6: { //Carregador de Concreto
				}
				case 7: { //Motorista de Carro Forte
					if(PlayerLeo[playerid][Profissao] == MOTORISTA_CARROFORTE)
					{
						SendClientMessage(playerid, COR_ERRO, "| ERRO | VocÊ já é um Motorista de Carro Forte!");
						return 1;
					}
					if(GetPlayerScore(playerid) >= 85)
					{
						SendClientMessage(playerid, COR_CARROFORTE, "| AGENCIA | Você foi aceito em seu emprego (Motorista de Carro Forte)");
						PlayerLeo[playerid][Profissao] = MOTORISTA_CARROFORTE;
						SetPlayerColor(playerid, COR_CARROFORTE);
					}
					else {
						SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem o level suficiente para essa profissão!");
					}
					return 1;
				}
				case 8: {
					if(PlayerLeo[playerid][Profissao] == MOTORISTA_ONIBUS)
					{
						SendClientMessage(playerid, COR_ERRO, "| ERRO | Você já é um Motorista de Ônibus!");
						return 1;
					}
					if(GetPlayerScore(playerid) >= 20)
					{
						SendClientMessage(playerid, COR_MOTORISTABUS, "| AGENCIA | Parabéns agora você é um Motorista de Ônibus");
						PlayerLeo[playerid][Profissao] = MOTORISTA_ONIBUS;
	                    SetPlayerColor(playerid, COR_MOTORISTABUS);
					}
					else {
						SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem o level suficiente para essa profissão!");
					}
					return 1;
				}
				case 9: { //Taxista
				}
				case 10: { //Moto Taxi
				}
				case 11: { //Taxi Aereo
				}
				case 12: { //Motorista Particular
				}
			}
    	}
        else {
            ShowPlayerDialog(playerid, DIALOG_AGENCIA, DIALOG_STYLE_LIST, "{FF0000}Profissões", "{FFFFFF}Classe » {38b170}Honestas\n{FFFFFF}Classe » {8bcffa}Transporte\n{FFFFFF}Classe » {847c7f}Governo\n{FFFFFF}Classe » {218ffd}Policia\n{FFFFFF}Classe » {211b88}Forças Armadas\n{FFFFFF}Classe » {840000}Mafia\n", "Selecionar", "Sair");
        }
        return 1;
    }

    if(dialogid == DIALOG_GOVERNO) {
    	if(response) {
            switch(listitem) {
                case 0: { //Corregedoria
                }
                case 1: { //Aposentado
            	}
        	}
    	}
        else {
             ShowPlayerDialog(playerid, DIALOG_AGENCIA, DIALOG_STYLE_LIST, "{FF0000}Profissões", "{FFFFFF}Classe » {38b170}Honestas\n{FFFFFF}Classe » {8bcffa}Transporte\n{FFFFFF}Classe » {847c7f}Governo\n{FFFFFF}Classe » {218ffd}Policia\n{FFFFFF}Classe » {211b88}Forças Armadas\n{FFFFFF}Classe » {840000}Mafia\n", "Selecionar", "Sair");
        }
        return 1;
    }

    if(dialogid == DIALOG_POLICIA) {
    	if(response) {
            switch(listitem) {
                case 0: { //Policia Militar
                }
                case 1: { //Ibama
                }
                case 2: { //Policia Federal
                }
                case 3: { //Delegado
                }
               	case 4: { //FBI
                }
              	case 5: { //CIA
                }
                case 6: { //S.W.A.T
                }
                case 7: { //Narcoticos
                }
               	case 8: { //Interpol
                }
            }
        }
        else {
             ShowPlayerDialog(playerid, DIALOG_AGENCIA, DIALOG_STYLE_LIST, "{FF0000}Profissões", "{FFFFFF}Classe » {38b170}Honestas\n{FFFFFF}Classe » {8bcffa}Transporte\n{FFFFFF}Classe » {847c7f}Governo\n{FFFFFF}Classe » {218ffd}Policia\n{FFFFFF}Classe » {211b88}Forças Armadas\n{FFFFFF}Classe » {840000}Mafia\n", "Selecionar", "Sair");
        }
        return 1;
    }

    if(dialogid == DIALOG_FARMADAS) {
    	if(response) {
            switch(listitem) {
                case 0: { //Marinha
                }
                case 1: { //Exercito
              	}
                case 2: { //Aeronautica
            	}
       		}
        }
        else {
             ShowPlayerDialog(playerid, DIALOG_AGENCIA, DIALOG_STYLE_LIST, "{FF0000}Profissões", "{FFFFFF}Classe » {38b170}Honestas\n{FFFFFF}Classe » {8bcffa}Transporte\n{FFFFFF}Classe » {847c7f}Governo\n{FFFFFF}Classe » {218ffd}Policia\n{FFFFFF}Classe » {211b88}Forças Armadas\n{FFFFFF}Classe » {840000}Mafia\n", "Selecionar", "Sair");
        }
        return 1;
    }

    if(dialogid == DIALOG_MAFIA) {
    	if(response) {
            switch(listitem) {
                case 0: {
                	if(PlayerLeo[playerid][Profissao] == FAZENDEIRO) {
                		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você já é um fazendeiro.");
                		return 1;
                	}
                	if(GetPlayerScore(playerid) >= 10) {
                		SendClientMessage(playerid, COR_FAZENDEIRO, "| MAFIA | Você se tornou um fazendeiro.");
                		PlayerLeo[playerid][Profissao] = FAZENDEIRO;
                		SetPlayerColor(playerid, COR_FAZENDEIRO);
                		return 1;
                	} else {
                		SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem o level necessário para esta profissão.");
                	}
                }
                case 1: { //Transportador de Drogas
                }
                case 2: { //Vendedor de Drogas
                }
                case 3: { //Traficante de Armas
                }
                case 4: { //Sequestrador
                }
                case 5: { //Assaltante
                }
                case 6: { //Assassino
                }
                case 7: { //Petroleiro Clandestino
               	}
                case 8: { //Chefao da Mafia
                }
                case 9: { //Terrorista
                }
            }
        }
        else {
             ShowPlayerDialog(playerid, DIALOG_AGENCIA, DIALOG_STYLE_LIST, "{FF0000}Profissões", "{FFFFFF}Classe » {38b170}Honestas\n{FFFFFF}Classe » {8bcffa}Transporte\n{FFFFFF}Classe » {847c7f}Governo\n{FFFFFF}Classe » {218ffd}Policia\n{FFFFFF}Classe » {211b88}Forças Armadas\n{FFFFFF}Classe » {840000}Mafia\n", "Selecionar", "Sair");
        }
        return 1;
        }
    if(dialogid == DIALOG_ROTAONIBUS) {
    	if(response) {
    		switch(listitem) {
    			case 0: {
    				SetPlayerCheckpoint(playerid, 2806.0938, 1313.2496, 10.7500, 5.0);
    				CCO[playerid] = 1;
    				Trabalhando[playerid] = 1;
    				EmRota[playerid] = 1;
    				return 1;
    			}
    		}
    	}
    }
    if(dialogid == DIALOG_ROTACARRO) {
    	if(response) {
    		switch(listitem) {
    			case 0: {
    				SetPlayerCheckpoint(playerid, 611.7098, -1295.8733, 15.1473, 5.0);
    				CheckCF[playerid] = 1;
    				EmRota[playerid] = 1;
    				return 1;
    			}
    		}
    	}
    }
    if(dialogid == DIALOG_CONCE) {
    	if(response) {
    		switch(listitem) {
    			case 0: {
    				for(new i = 0; i < sizeof(VeiculosT); i ++)
					{
						if(GetPlayerMoney(playerid) < VeiculosT[i][Preco]) {
							SendClientMessage(playerid, -1, "Você não tem dinheiro suficiente!");
							return 1;
						}
    					CreateVehicle(VeiculosT[i][VeiculosID], SPAWN_X, SPAWN_Y, SPAWN_Z, ANGULO, 1, 2, 0);
    					GivePlayerMoney(playerid, -VeiculosT[i][Preco]);
    					break;
    				}
    				return 1;
    			}
    			case 1: {
    				for(new i = 1; i < sizeof(VeiculosT); i ++)
					{
    					CreateVehicle(VeiculosT[i][VeiculosID], SPAWN_X, SPAWN_Y, SPAWN_Z, ANGULO, 1, 2, 0);
    					break;
    				}
    				return 1;
    			}
    			case 2: {
    				for(new i = 2; i < sizeof(VeiculosT); i ++)
					{
    					CreateVehicle(VeiculosT[i][VeiculosID], SPAWN_X, SPAWN_Y, SPAWN_Z, ANGULO, 1, 2, 0);
    					break;
    				}
    				return 1;
    			}
    			case 3: {
    				for(new i = 3; i < sizeof(VeiculosT); i ++)
					{
    					CreateVehicle(VeiculosT[i][VeiculosID], SPAWN_X, SPAWN_Y, SPAWN_Z, ANGULO, 1, 2, 0);
    					break;
    				}
    				return 1;
    			}
    			case 4: {
    				for(new i = 4; i < sizeof(VeiculosT); i ++)
					{
    					CreateVehicle(VeiculosT[i][VeiculosID], SPAWN_X, SPAWN_Y, SPAWN_Z, ANGULO, 1, 2, 0);
    					break;
    				}
    				return 1;
    			}
    			case 5: {
    				for(new i = 5; i < sizeof(VeiculosT); i ++)
					{
    					CreateVehicle(VeiculosT[i][VeiculosID], SPAWN_X, SPAWN_Y, SPAWN_Z, ANGULO, 1, 2, 0);
    					break;
    				}
    				return 1;
    			}
    		}
    	}
    }
    if(dialogid == DIALOG_SEMENTE) {
    	if(response) {
    		switch(listitem) {
    			case 0: {
    				if(GetPlayerMoney(playerid) < 3000) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem R$3000 para comprar sementes");
    					return 1;
    				}
    				if(PlayerLeo[playerid][Sementes] >= 60) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Limite máximo de sementes atingido.");
    					return 1;
    				}
    				SendClientMessage(playerid, -1, "| INFO | Você comprou {7CFC00}10 sementes{FFFFFF} no valor de {228B22}R$3000{FFFFFF}.");
    				PlayerLeo[playerid][Sementes] += 10;
    				GivePlayerMoney(playerid, -3000);
    				return 1;
    			}
    			case 1: {
    				if(GetPlayerMoney(playerid) < 5000) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem R$5000 para comprar sementes");
    					return 1;
    				}
    				if(PlayerLeo[playerid][Sementes] >= 60) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Limite máximo de sementes atingido.");
    					return 1;
    				}
    				SendClientMessage(playerid, -1, "| INFO | Você comprou {7CFC00}20 sementes{FFFFFF} no valor de {228B22}R$5000{FFFFFF}.");
    				PlayerLeo[playerid][Sementes] += 20;
    				GivePlayerMoney(playerid, -5000);
    				return 1;
    			}
    			case 2: {
    				if(GetPlayerMoney(playerid) < 8000) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem R$8000 para comprar sementes");
    					return 1;
    				}
    				if(PlayerLeo[playerid][Sementes] >= 60) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Limite máximo de sementes atingido.");
    					return 1;
    				}
    				SendClientMessage(playerid, -1, "| INFO | Você comprou {7CFC00}30 sementes {FFFFFF}no valor de {228B22}R$8000{FFFFFF}.");
    				PlayerLeo[playerid][Sementes] += 30;
    				GivePlayerMoney(playerid, -8000);
    				return 1;
    			}
    		}
    	}
    }
    if(dialogid == DIALOG_HOSPITAL) {
    	if(response) {
    		switch(listitem) {
    			case 0: {
    				if(GetPlayerMoney(playerid) < 5000) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem R$5000.");
    					return 1;
    				}
    				if(PlayerLeo[playerid][PlanoMedico] == 1) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Você já tem plano médico.");
    					return 1;
    				}
    				SendClientMessage(playerid, -1, "| HOSPITAL | Você adquiriu {1E90FF}Kit-Médico{FFFFFF}.");
    				PlayerLeo[playerid][PlanoMedico] = 1;
    				GivePlayerMoney(playerid, -5000);
    				return 1;
    			}
    		}
    	}
    }
    if(dialogid == DIALOG_UTILITARIOS) {
    	if(response) {
    		switch(listitem) {
    			case 0: {
    				if(GetPlayerMoney(playerid) < 3000) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem R$3000.");
    					return 1;
    				}
    				if(PlayerLeo[playerid][Celular] == 1) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Você já tem um celular.");
    					return 1;
    				}
    				SendClientMessage(playerid, -1, "| UTILITARIOS | Você adquiriu um celular. Para mais informações digite /Ajuda.");
    				PlayerLeo[playerid][Celular] = 1;
    				GivePlayerMoney(playerid, -3000);
    				return 1;
    			}
    			case 1: {
    				if(GetPlayerMoney(playerid) < 300) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem créditos para mandar mensagem, compre na Loja de Utilitarios!");
    					return 1;
    				}
    				if(PlayerLeo[playerid][Creditos] == 200) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Limite de créditos atingido!");
    					return 1;
    				}
    				SendClientMessage(playerid, -1, "| UTILITARIOS | Você adquiriu 50 de créditos, para mais informações /Ajuda.");
    				PlayerLeo[playerid][Creditos] += 50;
    				GivePlayerMoney(playerid, -300);
    				return 1;
    			}
    		}
    	}
    }
    if(dialogid == DIALOG_SEMPARAR) {
    	if(response) {
    		switch(listitem) {
    			case 0: {
    				if(GetPlayerMoney(playerid) < 900) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem R$900");
    					return 1;
    				}
    				SendClientMessage(playerid, COR_VERDE, "| SEM-PARAR | Você comprou 10 passagens para o SEM PARAR!");
    				SemParar[playerid] += 10;
    				GivePlayerMoney(playerid, -900);
    				return 1;
    			}
    			case 1: {
    				if(GetPlayerMoney(playerid) < 1700) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem R$1700");
    					return 1;
    				}
    				SendClientMessage(playerid, COR_VERDE, "| SEM-PARAR | Você comprou 20 passagens para o SEM PARAR!");
    				SemParar[playerid] += 20;
    				GivePlayerMoney(playerid, -1700);
    				return 1;
    			}
    			case 2: {
    				if(GetPlayerMoney(playerid) < 3200) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem R$3200");
    					return 1;
    				}
    				SendClientMessage(playerid, COR_VERDE, "| SEM-PARAR | Você comprou 30 passagens para o SEM PARAR!");
    				SemParar[playerid] += 30;
    				GivePlayerMoney(playerid, -3200);
    				return 1;
    			}
    			case 3: {
    				if(GetPlayerMoney(playerid) < 6200) {
    					SendClientMessage(playerid, COR_ERRO, "| ERRO | Você não tem R$6200");
    					return 1;
    				}
    				SendClientMessage(playerid, COR_VERDE, "| SEM-PARAR | Você comprou 40 passagens para o SEM PARAR!");
    				SemParar[playerid] += 40;
    				GivePlayerMoney(playerid, -6200);
    				return 1;
    			}
    		}
    	}
    }
    return 1;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public Sumiu(playerid)
{
	foreach(Player, i)
	{
		TextDrawHideForPlayer(playerid, Aviso[i]);
	}
	return 1;
}

public Plantar1(playerid)
{
	new Float:Gz[3];
	GetPlayerPos(playerid, Gz[0], Gz[1], Gz[2]);
	Maconha = CreateObject(3409, Gz[0]+2, Gz[1] , Gz[2]-1.8, 0, 0, 0);
	Colher[playerid] = 0;
	ClearAnimations(playerid);
	SendClientMessage(playerid, 0xFFFFFFFF, "| INFO | {FF0000}Maconha{FFFFFF} pronta para ser colhida.");
	return 1;
}

forward Carregando(playerid);
public Carregando(playerid)
{
	TogglePlayerControllable(playerid, 1);
	SendClientMessage(playerid, 0xFFFFFFFF, "| INFO | Malotes carregados, siga o {FF0000}checkpoint{FFFFFF} marcado em seu mapa!");
	GameTextForPlayer(playerid, "~w~~h~LIBERADO", 3000, 4);
	return 1;
}

public PassageirosE(playerid)
{
	TogglePlayerControllable(playerid, 1);
	SendClientMessage(playerid, 0xFFFFFFFF, "| INFO | Passageiros embarcados, siga o próximo {FF0000}checkpoint{FFFFFF}!");
	GameTextForPlayer(playerid, "~w~~h~LIBERADO", 4000, 4);
	return 1;
}
public PassageirosD(playerid)
{
	TogglePlayerControllable(playerid, 1);
	new Frase[128];
	new Grana = random(6000 - 4000)+ 4000;
	GivePlayerMoney(playerid, Grana);
	EmRota[playerid] = 0;
	format(Frase,sizeof(Frase), "| RODOVIARIA | Você completou a rota {1E90FF}LAS VENTURAS - SAN FIERRO{FFFFFF}, e recebeu [{228B22}R$%d{FFFFFF}]", Grana);
	SendClientMessage(playerid, -1 ,Frase);
	return 1;
}
public DescarregarA(playerid)
{
	TogglePlayerControllable(playerid, 1);
	SendClientMessage(playerid, 0xFFFFFFFF, "| AEROPORTO | Você descarregou mercadorias, siga o próximo {FF0000}checkpoint{FFFFFF}!");
	return 1;
}
public DescarregouT(playerid)
{
    TogglePlayerControllable(playerid, 1);
    new Frase[128];
    new Grana = random(4000 - 3000)+ 3000;
    GivePlayerMoney(playerid, Grana);
    Carregado[playerid] = 0;
    format(Frase,sizeof(Frase), "| AEROPORTO | Você descarregou todas as mercadorias, e recebeu [{228B22}R$%d{FFFFFF}]", Grana);
    SendClientMessage(playerid, -1 ,Frase);
    return 1;
}

forward CorrigirSementes(playerid);
public CorrigirSementes(playerid)
{
	if(PlayerLeo[playerid][Sementes] >= 60)
	{
		PlayerLeo[playerid][Sementes] = 60;
		return 1;
	}
	return 1;
}

forward CheckSemParar();
public CheckSemParar()
{
	for(new i; i != GetMaxPlayers(); i++) {
		if(IsPlayerConnected(i)) {
			if(IsPlayerInAnyVehicle(i)) {
				if(IsPlayerInRangeOfPoint(i, 6.5, -1125.2976,-2863.8716,67.7188) && PassouPedagio[i] == false) {
					if(SemParar[i]) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SetTimerEx("PassouPedagioP", 3000, false, "i", i);
							SetTimerEx("FecharCancelaP", 3000, false, "i", i);
							SendClientMessage(i, COR_VERDE, "| SEM-PARAR | Você possui Sem Parar e foi feita uma cobrança automática!");
							SemParar[i] --;
						}
						MovePlayerObject(i, CancelaP[i][0], -1120.59277, -2860.23462, 67.43290, 0.0001, 0.0000, 0.0000, 272.3800);
						return 1;
					}
					if(!SemParar[i] && GetPlayerMoney(i) >= 100) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SendClientMessage(i, COR_VERDE, "| PEDAGIO | Você não pussui SEM PARAR e precisará parar na cabine!");
							TogglePlayerControllable(i, false);
							GivePlayerMoney(i, -100);
							SetTimerEx("MoveCancela1", 3000, false, "i", i);
							break;
						}
					}
					else {
						PassouPedagio[i] = true;
					    SetTimerEx("PassouPedagioP", 3000, false, "i", i);
					    SendClientMessage(i, COR_ERRO,"| ERRO | Você não possui R$100 reais para o pedágio!");
					    break;
					}
				} else if(IsPlayerInRangeOfPoint(i, 6.5, -1114.5270,-2851.4023,67.7188) && PassouPedagio[i] == false) {
					if(SemParar[i]) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SetTimerEx("PassouPedagioP", 3000, false, "i", i);
							SetTimerEx("FecharCancelaP", 3000, false, "i", i);
							SendClientMessage(i, COR_VERDE, "| SEM-PARAR | Você possui Sem Parar e foi feita uma cobrança automática!");
							SemParar[i] --;
						}
						MovePlayerObject(i, CancelaP[i][1], -1121.28052, -2855.66870, 67.43290, 0.0001, 0.0000, 0.0000, 92.1800);
						return 1;
					} else if(!SemParar[i] && GetPlayerMoney(i) >= 100) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
		  					SendClientMessage(i, COR_VERDE, "| PEDAGIO | Você não pussui SEM PARAR e precisará parar na cabine!");
		    				TogglePlayerControllable(i, false);
		                  	GivePlayerMoney(i, -100);
		                  	SetTimerEx("MoveCancela2", 3000, false, "i", i);
		                  	break;
						}
					}
					else
					{
						PassouPedagio[i] = true;
						SetTimerEx("PassouPedagioP", 3000, false, "i", i);
						SendClientMessage(i, COR_ERRO, "Você não possui R$100 reais para o pedágio!");
						break;
					}
				}
				if(IsPlayerInRangeOfPoint(i, 6.5, 1743.8019, 522.3286, 27.8644) && PassouPedagio[i] == false) {
					if(SemParar[i]) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SetTimerEx("PassouPedagioP", 3000, false, "i", i);
							SetTimerEx("FecharCancelaP", 3000, false, "i", i);
							SendClientMessage(i, COR_VERDE, "| SEM-PARAR | Você possui Sem Parar e foi feita uma cobrança automática!");
							SemParar[i] --;
						}
						MovePlayerObject(i, CancelaP[i][3], 1743.69641, 532.61810, 27.08570, 0.0001, 0.0000, 0.0000, -21.5200);
						return 1;
					}
					if(!SemParar[i] && GetPlayerMoney(i) >= 100) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
		  					SendClientMessage(i, COR_VERDE, "| PEDAGIO | Você não pussui SEM PARAR e precisará parar na cabine!");
		    				TogglePlayerControllable(i, false);
		                  	GivePlayerMoney(i, -100);
		                  	SetTimerEx("MoveCancela4", 3000, false, "i", i);
		                  	break;
		                }
					}
					else
					{
						PassouPedagio[i] = true;
						SetTimerEx("PassouPedagioP", 3000, false, "i", i);
						SendClientMessage(i, COR_ERRO, "Você não possui R$100 reais para o pedágio!");
						break;
					}
				} else if(IsPlayerInRangeOfPoint(i, 6.5, 1753.6305, 520.3472, 27.7972) && PassouPedagio[i] == false) {
					if(SemParar[i]) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SetTimerEx("PassouPedagioP", 3000, false, "i", i);
							SetTimerEx("FecharCancelaP", 3000, false, "i", i);
							SendClientMessage(i, COR_VERDE, "| SEM-PARAR | Você possui Sem Parar e foi feita uma cobrança automática!");
							SemParar[i] --;
						}
						MovePlayerObject(i, CancelaP[i][2], 1752.64233, 529.21753, 27.08570, 0.0001, 0.0000, 0.0000, -21.5200);
						return 1;
					} else if(!SemParar[i] && GetPlayerMoney(i) >= 100) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
		  					SendClientMessage(i, COR_VERDE, "| PEDAGIO | Você não pussui SEM PARAR e precisará parar na cabine!");
		    				TogglePlayerControllable(i, false);
		                  	GivePlayerMoney(i, -100);
		                  	SetTimerEx("MoveCancela3", 3000, false, "i", i);
		                  	break;
		                }
					}
					else
					{
						PassouPedagio[i] = true;
						SetTimerEx("PassouPedagioP", 3000, false, "i", i);
						SendClientMessage(i, COR_ERRO, "Você não possui R$100 reais para o pedágio!");
						break;
					}
				} 
				if(IsPlayerInRangeOfPoint(i, 6.5, 1737.3971, 530.7954, 27.5291) && PassouPedagio[i] == false) {
					if(SemParar[i]) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SetTimerEx("PassouPedagioP", 3000, false, "i", i);
							SetTimerEx("FecharCancelaP", 3000, false, "i", i);
							SendClientMessage(i, COR_VERDE, "| SEM-PARAR | Você possui Sem Parar e foi feita uma cobrança automática!");
							SemParar[i] --;
						}
						MovePlayerObject(i, CancelaP[i][4], 1738.31946, 523.43921, 27.62790, 0.0001, 0.0000, 0.0000, 162.1799);
						return 1;
					} else if(!SemParar[i] && GetPlayerMoney(i) >= 100) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
		  					SendClientMessage(i, COR_VERDE, "| PEDAGIO | Você não pussui SEM PARAR e precisará parar na cabine!");
		    				TogglePlayerControllable(i, false);
		                  	GivePlayerMoney(i, -100);
		                  	SetTimerEx("MoveCancela5", 3000, false, "i", i);
		                  	break;
		                }
					}
					else
					{
						PassouPedagio[i] = true;
						SetTimerEx("PassouPedagioP", 3000, false, "i", i);
						SendClientMessage(i, COR_ERRO, "Você não possui R$100 reais para o pedágio!");
						break;
					}
				} else if(IsPlayerInRangeOfPoint(i, 6.5, 1729.5702,535.3495,27.4266) && PassouPedagio[i] == false) {
					if(SemParar[i]) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
							SetTimerEx("PassouPedagioP", 3000, false, "i", i);
							SetTimerEx("FecharCancelaP", 3000, false, "i", i);
							SendClientMessage(i, COR_VERDE, "| SEM-PARAR | Você possui Sem Parar e foi feita uma cobrança automática!");
							SemParar[i] --;
						}
						MovePlayerObject(i, CancelaP[i][5], 1729.92896, 526.36902, 27.62790, 0.0001, 0.0000, 0.0000, 162.1799);
						return 1;
					} else if(!SemParar[i] && GetPlayerMoney(i) >= 100) {
						if(GetPlayerState(i) == PLAYER_STATE_DRIVER) {
							PassouPedagio[i] = true;
		  					SendClientMessage(i, COR_VERDE, "| PEDAGIO | Você não pussui SEM PARAR e precisará parar na cabine!");
		    				TogglePlayerControllable(i, false);
		                  	GivePlayerMoney(i, -100);
		                  	SetTimerEx("MoveCancela6", 3000, false, "i", i);
		                  	break;
		                }
					}
					else
					{
						PassouPedagio[i] = true;
						SetTimerEx("PassouPedagioP", 3000, false, "i", i);
						SendClientMessage(i, COR_ERRO, "Você não possui R$100 reais para o pedágio!");
						break;
					}
				}
			}
		}
	}
	return 1;
}

forward MoveCancela1(playerid);
public MoveCancela1(playerid)
{
	MovePlayerObject(playerid, CancelaP[playerid][0], -1120.59277, -2860.23462, 67.43290, 0.0001, 0.0000, 0.0000, 272.3800);
	TogglePlayerControllable(playerid, true);
	SetTimerEx("FecharCancelaP", 3000, false, "i", playerid);
	SetTimerEx("PassouPedagioP", 4000, false, "i", playerid);
	return 1;
}

forward MoveCancela2(playerid);
public MoveCancela2(playerid)
{
	MovePlayerObject(playerid, CancelaP[playerid][1], -1121.28052, -2855.66870, 67.43290, 0.0001, 0.0000, 0.0000, 92.1800);
	TogglePlayerControllable(playerid, true);
	SetTimerEx("FecharCancelaP", 3000, false, "i", playerid);
	SetTimerEx("PassouPedagioP", 4000, false, "i", playerid);
	return 1;
}

forward MoveCancela3(playerid);
public MoveCancela3(playerid)
{
	MovePlayerObject(playerid, CancelaP[playerid][2], 1752.64233, 529.21753, 27.08570+0.0001, 0.0001, 0.0000, 0.0000, -21.5200);
	TogglePlayerControllable(playerid, true);
	SetTimerEx("FecharCancelaP", 3000, false, "i", playerid);
	SetTimerEx("PassouPedagioP", 4000, false, "i", playerid);
	return 1;
}

forward MoveCancela4(playerid);
public MoveCancela4(playerid)
{
	MovePlayerObject(playerid, CancelaP[playerid][3], 1743.69641, 532.61810, 27.08570+0.0001, 0.0001, 0.0000, 0.0000, -21.5200);
	TogglePlayerControllable(playerid, true);
	SetTimerEx("FecharCancelaP", 3000, false, "i", playerid);
	SetTimerEx("PassouPedagioP", 4000, false, "i", playerid);
	return 1;
}

forward MoveCancela5(playerid);
public MoveCancela5(playerid)
{
	MovePlayerObject(playerid, CancelaP[playerid][4], 1738.31946, 523.43921, 27.62790+0.0001, 0.0001, 0.0000, 0.0000, 162.1799);
	TogglePlayerControllable(playerid, true);
	SetTimerEx("FecharCancelaP", 3000, false, "i", playerid);
	SetTimerEx("PassouPedagioP", 4000, false, "i", playerid);
	return 1;
}

forward MoveCancela6(playerid);
public MoveCancela6(playerid)
{
	MovePlayerObject(playerid, CancelaP[playerid][5], 1729.92896, 526.36902, 27.62790+0.0001, 0.0001, 0.0000, 0.0000, 162.1799);
	TogglePlayerControllable(playerid, true);
	SetTimerEx("FecharCancelaP", 3000, false, "i", playerid);
	SetTimerEx("PassouPedagioP", 4000, false, "i", playerid);
	return 1;
}

forward PassouPedagioP(playerid);
public PassouPedagioP(playerid)
{
	PassouPedagio[playerid] = false;
	return 1;
}

forward FecharCancelaP(playerid);
public FecharCancelaP(playerid)
{
	MovePlayerObject(playerid, CancelaP[playerid][0], -1120.59277, -2860.23462, 67.43290, 0.0001, 0.0000, 90.0000, 272.3800);
	MovePlayerObject(playerid, CancelaP[playerid][1], -1121.28052, -2855.66870, 67.43290, 0.0001, 0.0000, 90.0000, 92.1800);
	MovePlayerObject(playerid, CancelaP[playerid][2], 1752.64233, 529.21753, 27.08570, 0.0001, 0.0000, 90.0000, -21.5200);
	MovePlayerObject(playerid, CancelaP[playerid][3], 1743.69641, 532.61810, 27.08570, 0.0001, 0.0000, 90.0000, -21.5200);
	MovePlayerObject(playerid, CancelaP[playerid][4], 1738.31946, 523.43921, 27.62790, 0.0001, 0.0000, 90.0000, 162.1799);
	MovePlayerObject(playerid, CancelaP[playerid][5], 1729.92896, 526.36902, 27.62790, 0.0001, 0.0000, 90.0000, 162.1799);
	return 1;
}


forward MsgPassagem(playerid);
public MsgPassagem(playerid)
{
	if(PassagemMensagem[playerid] >= 5)
	{
		KillTimer(PassagemTimer[playerid]); KillTimer(PassagemTimer[PassagemID[playerid]]);
		SendClientFormat(playerid, COR_ERRO, "| PASSAGEM | Você demorou muito para responder %s e a oferta da passagem foi cancelada!", GetPlayerNome(PassagemID[playerid]));
		SendClientFormat(PassagemID[playerid], COR_ERRO, "| PASSAGEM | %s demorou para responder e sua oferta foi cancelada.", GetPlayerNome(playerid));
		PassagemOferecido[PassagemID[playerid]] = 0;
		PassagemRecebido[playerid] = 0;
		PassagemMensagem[playerid] = 0;
		PassagemValor[playerid] = 0;
		PassagemJa[playerid] = 0;
		PassagemID[playerid] = -1;
		return 1;
	}
	if(PassagemMensagem[playerid] < 5)
	{
		SendClientFormat(playerid, COR_MOTORISTABUS, "| PASSAGEM | O(A) Motorista de Ônibus %s esta te oferecendo uma passagem por R$%d. (/pAceitar | /pRecusar).", GetPlayerNome(PassagemID[playerid]), PassagemValor[playerid]);
		SendClientFormat(PassagemID[playerid], COR_MOTORISTABUS, "Aguardando a reposta de %s... [Oferta de Passagem]", GetPlayerNome(playerid));
		PassagemMensagem[playerid] ++;	PassagemTimer[playerid] = SetTimerEx("MsgPassagem", 4000, false, "d", playerid);
		return 1;
	}
	return 1;

}

forward AtualizarText();
public AtualizarText()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(PlayerLeo[i][Admin] == 5)
		{
			SetPlayerChatBubble(i, "Staff", 0x228B22FF, 20.0, 10000);
		}
		else if(PlayerLeo[i][Admin] == 4)
		{
			SetPlayerChatBubble(i, "Sub-Staff", 0xB8860BFF, 20.0, 10000);
		}
		else if(PlayerLeo[i][Admin] == 3)
		{
			SetPlayerChatBubble(i, "Administrador(a)", 0x1E90FFFF, 20.0, 10000);
		}
		else if(PlayerLeo[i][Admin] == 2)
		{
			SetPlayerChatBubble(i, "Moderador(a)", 0xFFA500FF, 20.0, 10000);
		}
		else if(PlayerLeo[i][Admin] == 1)
		{
			SetPlayerChatBubble(i, "Ajudante", 0xFFFF00FF, 20.0, 10000);
		}
		else if(PlayerLeo[i][Admin] == 0)
		{
			SetPlayerChatBubble(i, "Jogador", 0xFFFF00FF, 0.0, 0000);
		}
	}
} 

forward MutadoTimer(playerid);
public MutadoTimer(playerid)
{
	SendClientMessage(playerid, 0xFF0000FF, "| INFO | Você foi descalado não quebre as regras novamente!");
	Calado[playerid] = 0;
	return 1;
}

public Horas(playerid) {
	new Str[128], str2[128], ano, mes, dia, horas, minutos, segundos;
	getdate(ano, mes, dia);
	gettime(horas, minutos, segundos);
	new mess[12];
	if(mes == 1) { mess = "1";}
	else if(mes == 2) { mess = "2";}
	else if(mes == 3) { mess = "3";}
	else if(mes == 4) { mess = "4";}
	else if(mes == 5) { mess = "5";}
	else if(mes == 6) { mess = "6";}
	else if(mes == 7) { mess = "7";}
	else if(mes == 8) { mess = "8";}
	else if(mes == 9) { mess = "9";}
	else if(mes == 10) { mess = "10";}
	else if(mes == 11) { mess = "11";}
	else if(mes == 12) { mess = "12";}
	format(Str, sizeof(Str), "%02d/%02d/%02d", dia, mes, ano);
	TextDrawSetString(Text:Textdraw0, Str);
	format(str2, sizeof(str2), "%02d:%02d:%02d", horas, minutos, segundos);
    TextDrawSetString(Text:Textdraw1, str2);
}

stock ComandosProf(playerid) {
	new stg[1500], gstring[500];

	if(PlayerLeo[playerid][Profissao] == PILOTO) {
		format(gstring, sizeof(gstring), "\n{6495ED}/Carregar {FFFFFF}- Inicia o trabalho, carregando o avião.");
		strcat(stg, gstring);
		format(gstring, sizeof(gstring), "\n\n{1E90FF}/CP [Texto]{FFFFFF} - Chat Profissão - Falar com todos os jogadores da profissão atual.");
		strcat(stg, gstring);
		ShowPlayerDialog(playerid, DIALOG_PROFISSOES, DIALOG_STYLE_MSGBOX, "{FFFFFF}Comandos de Profissão", stg, "Fechar", "");
	}
	else if(PlayerLeo[playerid][Profissao] == MOTORISTA_ONIBUS)	{
		format(gstring, sizeof(gstring), "\n{009ACD}/VenderPassagem {FFFFFF}- Poderá vender passagens.");
		strcat(stg, gstring);
		format(gstring, sizeof(gstring), "\n\n{009ACD}/IniciarRota {FFFFFF}- Inicia a rota escolhida.");
		strcat(stg, gstring);
		format(gstring, sizeof(gstring), "\n\n{1E90FF}/CP [Texto]{FFFFFF} - Chat Profissão - Falar com todos os jogadores da profissão atual.");
		strcat(stg, gstring);
	}
	else if(PlayerLeo[playerid][Profissao] == FAZENDEIRO)	{
		format(gstring, sizeof(gstring), "\n{EE0000}/PlantarMaconha {FFFFFF}- Inicia a plantação da erva.");
		strcat(stg, gstring);
		format(gstring, sizeof(gstring), "\n\n{EE0000}/Colher {FFFFFF}- Quando pronto para colher a erva.");
		strcat(stg, gstring);
		format(gstring, sizeof(gstring), "\n\n{EE0000}/ComprarSementes {FFFFFF}- Para comprar sementes no beco.");
		strcat(stg, gstring);
		format(gstring, sizeof(gstring), "\n\n{EE0000}/MinhasSementes {FFFFFF}- Lhe mostra a quantidade de sementes ainda restante.");
		strcat(stg, gstring);
		format(gstring, sizeof(gstring), "\n\n{1E90FF}/CP [Texto]{FFFFFF} - Chat Profissão - Falar com todos os jogadores da profissão atual.");
		strcat(stg, gstring);
	}
	else if(PlayerLeo[playerid][Profissao] == MOTORISTA_CARROFORTE)	{
		format(gstring, sizeof(gstring), "\n{5F9EA0}/CarregarM {FFFFFF}- Para carregar os malotes.");
		strcat(stg, gstring);
		format(gstring, sizeof(gstring), "\n\n{1E90FF}/CP [Texto]{FFFFFF} - Chat Profissão - Falar com todos os jogadores da profissão atual.");
		strcat(stg, gstring);
	}
	format(gstring, sizeof(gstring), "\n\n\n\t\t{FFFFFF}Todos direitos reservados a {32CD32}LB.Games");
	strcat(stg, gstring);
	new string2[128];
	format(string2, sizeof(string2), "{FFFFFF}Comandos da profissão %s", CheckProfissao(playerid));
	ShowPlayerDialog(playerid, DIALOG_PROFISSOES, DIALOG_STYLE_MSGBOX, string2, stg, "Fechar", "");
	return 1;
}

stock Contas(playerid) {
	new file[128];
	format(file, sizeof(file), PASTA_CONTAS, GetPlayerNome(playerid));
	return file;
}


stock GetPlayerNome(playerid) {
	new aname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, aname, sizeof(aname));
	return aname;
}

stock SalvarContas(playerid)
{
    if(!DOF2_FileExists(Contas(playerid))) DOF2_CreateFile(Contas(playerid));
    else
    {
    	new Float:Pos[4];
    	new ano, mes, dia;
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		GetPlayerFacingAngle(playerid, Pos[3]);
		getdate(ano, mes, dia);
		DOF2_SetFloat(Contas(playerid), "UltimaPosX", Pos[0]);
		DOF2_SetFloat(Contas(playerid), "UltimaPosY", Pos[1]);
		DOF2_SetFloat(Contas(playerid), "UltimaPosZ", Pos[2]);
		DOF2_SetFloat(Contas(playerid), "UltimaPosA", Pos[3]);
        PlayerLeo[playerid][Dinheiro] = GetPlayerMoney(playerid);
        DOF2_SetInt(Contas(playerid), "UltimoLoginD", dia);
        DOF2_SetInt(Contas(playerid), "UltimoLoginM", mes);
        DOF2_SetInt(Contas(playerid), "UltimoLoginA", ano);
        DOF2_SetInt(Contas(playerid), "Senha", PlayerLeo[playerid][Senha]);
        DOF2_SetInt(Contas(playerid), "Matou", PlayerLeo[playerid][Matou]);
        DOF2_SetInt(Contas(playerid), "Morreu", PlayerLeo[playerid][Morreu]);
        DOF2_SetInt(Contas(playerid), "Dinheiro", GetPlayerMoney(playerid));
        DOF2_SetInt(Contas(playerid), "Profissao", PlayerLeo[playerid][Profissao]);
        PlayerLeo[playerid][Level] = GetPlayerScore(playerid);
        DOF2_SetInt(Contas(playerid), "Sementes", PlayerLeo[playerid][Sementes]);
        DOF2_SetInt(Contas(playerid), "PlanoMedico", PlayerLeo[playerid][PlanoMedico]);
        DOF2_SetInt(Contas(playerid), "Celular", PlayerLeo[playerid][Celular]);
        DOF2_SetInt(Contas(playerid), "Creditos", PlayerLeo[playerid][Creditos]);
        DOF2_SetInt(Contas(playerid), "Admin", PlayerLeo[playerid][Admin]);
        DOF2_SetInt(Contas(playerid), "SemParar", SemParar[playerid]);
        DOF2_SaveFile();
    }
    return 1;
}

stock CarregarConta(playerid)
{
	SemParar[playerid] = DOF2_GetInt(Contas(playerid), "SemParar");
    PlayerLeo[playerid][Level] = DOF2_GetInt(Contas(playerid), "Level");
    PlayerLeo[playerid][Dinheiro] = DOF2_GetInt(Contas(playerid), "Dinheiro");
	PlayerLeo[playerid][Matou] = DOF2_GetInt(Contas(playerid), "Matou");
    PlayerLeo[playerid][Morreu] = DOF2_GetInt(Contas(playerid), "Morreu");
    PlayerLeo[playerid][Profissao] = DOF2_GetInt(Contas(playerid), "Profissao");
    PlayerLeo[playerid][Sementes] = DOF2_GetInt(Contas(playerid), "Sementes");
    PlayerLeo[playerid][PlanoMedico] = DOF2_GetInt(Contas(playerid), "PlanoMedico");
    PlayerLeo[playerid][Celular] = DOF2_GetInt(Contas(playerid), "Celular");
    PlayerLeo[playerid][Creditos] = DOF2_GetInt(Contas(playerid), "Creditos");
    PlayerLeo[playerid][Admin] = DOF2_GetInt(Contas(playerid), "Admin");
    PlayerLeo[playerid][UltimoLoginA] = DOF2_GetInt(Contas(playerid), "UltimoLoginA");
    PlayerLeo[playerid][UltimoLoginM] = DOF2_GetInt(Contas(playerid), "UltimoLoginM");
    PlayerLeo[playerid][UltimoLoginD] = DOF2_GetInt(Contas(playerid), "UltimoLoginD");

    SetPlayerScore(playerid, PlayerLeo[playerid][Level]);
    GivePlayerMoney(playerid, PlayerLeo[playerid][Dinheiro]);
    return 1;
}

stock LimparChat(playerid, linhas)
{
	for(new i; i < linhas; i++)
	{
		SendClientMessage(playerid, 0xFFFFFFAA, "  ");
	}
	return 1;
}

stock CorProfissao(playerid) 
{
	if(PlayerLeo[playerid][Profissao] == DESEMPREGADO)
	{
		SetPlayerColor(playerid, COR_DESEMPREGADO);
		return 1;
	}
	else if(PlayerLeo[playerid][Profissao] == MOTORISTA_ONIBUS)
	{
		SetPlayerColor(playerid, COR_MOTORISTABUS);
		return 1;
	}
	else if(PlayerLeo[playerid][Profissao] == PILOTO)
	{
		SetPlayerColor(playerid, COR_PILOTO);
		return 1;
	}
	else if(PlayerLeo[playerid][Profissao] == FAZENDEIRO)
	{
		SetPlayerColor(playerid, COR_FAZENDEIRO);
		return 1;
	}
	else if(PlayerLeo[playerid][Profissao] == MOTORISTA_CARROFORTE)
	{
		SetPlayerColor(playerid, COR_CARROFORTE);
		return 1;
	}
	return 1;
}

stock AdminLevel(playerid)
{
    new name[32];
    if(PlayerLeo[playerid][Admin] == 0) format(name, sizeof(name), "Jogador");
    else if(PlayerLeo[playerid][Admin] == 1) format(name, sizeof(name), "Ajudante");
    else if(PlayerLeo[playerid][Admin] == 2) format(name, sizeof(name), "Moderador");
    else if(PlayerLeo[playerid][Admin] == 3) format(name, sizeof(name), "Administrador");
    else if(PlayerLeo[playerid][Admin] == 4) format(name, sizeof(name), "Sub-Staff");
    else if(PlayerLeo[playerid][Admin] == 5) format(name, sizeof(name), "Staff");
    return name;
}

stock CheckProfissao(playerid)
{
	new name[128];
	if(PlayerLeo[playerid][Profissao] == DESEMPREGADO) format(name, sizeof(name), "{FFFFFF}Desempregado");
	else if(PlayerLeo[playerid][Profissao] == PILOTO) format(name, sizeof(name), "{6495ED}Piloto");
	else if(PlayerLeo[playerid][Profissao] == FAZENDEIRO) format(name, sizeof(name), "{EE0000}Fazendeiro");
	else if(PlayerLeo[playerid][Profissao] == MOTORISTA_ONIBUS) format(name, sizeof(name), "{009ACD}Motorista de Ônibus");
	else if(PlayerLeo[playerid][Profissao] == MOTORISTA_CARROFORTE) format(name, sizeof(name), "{5F9EA0}Motorista de Carro Forte");
	return name;
}


stock ReturnVehicleID(vName[])
{
    for(new x; x != 211; x++) if(strfind(vNames[x], vName, true) != -1) return x + 400;
    return INVALID_VEHICLE_ID;
}

stock IsPlayerInPlace(playerid, Float:XMin, Float:YMin, Float:XMax, Float:YMax)
{
	new
		RetValue = 0,
		Float:aX,
		Float:aY,
		Float:aZ
	;
    GetPlayerPos(playerid, aX, aY, aZ);
    if(aX >= XMin && aY >= YMin && aX < XMax && aY < YMax)
    {
		RetValue = 1;
    }
	return RetValue;
}
