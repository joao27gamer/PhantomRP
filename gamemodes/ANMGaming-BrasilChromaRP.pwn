//Includes
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
//Includes

//VARIAVEIS//
new emaill[128];

enum pInfo
{
	PermLevel,
	Level,
	Experiencia,
	LvlProcurado,
	Dinheiro, 

	Senha[128], 
	sexo,
	skin,

	float:posX, 
	float:posY, 
	float:posZ, 
	float:rot,
	
	kills, 
	deaths, 
	
	fome, 
	sede, 
	doenca,
	sono,

	Saude,

	HabTerrestre,
	HabAr,
	HabAquatica,

	MultasT,
	MultasAr,
	MultasAq,

	bool:trabalhando,

	bool:staff,
	
	tVelocimetro
}
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

new float:inicialX[10000] = 1481.060546;
new float:inicialY[10000] = -1767.387573; 
new float:inicialZ[10000] = 18.795755;
new PlayerInfo[MAX_PLAYERS][pInfo];
new bool:Logado[MAX_PLAYERS];
new Exp[MAX_PLAYERS];

new PlayerText:ClockTD[MAX_PLAYERS][2];

new bool:ft[MAX_PLAYERS];

#define DIALOG_REGISTRO 1
#define DIALOG_CONF_SENHA 2
#define DIALOG_LOGIN 3
#define DIALOG_EMAIL 4
#define DIALOG_GENERO 5
#define DIALOG_COMANDOS 6
#define DIALOG_TUTORIAL 7
#define CONTAS "contas/%s.ini"
#define RADARES "Radares/%d.ini"


//cores//
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

//cores//


//VARIAVEIS//
new minutos[MAX_PLAYERS], segundos[MAX_PLAYERS];
new PlayerText:PlayerTD3[MAX_PLAYERS][13];
new float:lastx[MAX_PLAYERS],float:lasty[MAX_PLAYERS],float:lastz[MAX_PLAYERS];


new VehicleNames[][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",
    "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
    "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection",
    "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
    "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
    "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
    "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
    "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van",
    "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale",
    "Oceanic","Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy",
    "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
    "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper",
    "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
    "Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin",
    "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT",
    "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt",
    "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
    "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
    "Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer",
    "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent",
    "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo",
    "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite",
    "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratium",
    "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper",
    "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
    "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car",
    "Police Car", "Police Car", "Police Ranger", "Picador", "S.W.A.T", "Alpha",
    "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs", "Boxville",
    "Tiller", "Utility Trailer"
};
forward Clock(playerid);
public Clock(playerid){
	new s1[128], s2[128], dia, mes, ano, seg, minu,hr;
	getdate(ano, mes, dia);
	gettime(hr, minu, seg);
	PlayerTextDrawHide(playerid, ClockTD[playerid][0]);
	PlayerTextDrawHide(playerid, ClockTD[playerid][1]);

	format(s1, sizeof(s1), "%02d/%02d/%02d", dia, mes, ano);
	format(s2, sizeof(s2), "%02d:%02d", hr, minu);

	
	PlayerTextDrawSetString(playerid, ClockTD[playerid][0], s2);
	PlayerTextDrawSetString(playerid, ClockTD[playerid][1], s1);

	
	PlayerTextDrawShow(playerid, ClockTD[playerid][1]);
	PlayerTextDrawShow(playerid, ClockTD[playerid][0]);
	return 1;
}

stock createtd(playerid){
	ClockTD[playerid][0] = CreatePlayerTextDraw(playerid, 577.000000, 31.000000, "00:00");
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

	ClockTD[playerid][1] = CreatePlayerTextDraw(playerid, 500.000000, 1.000000, "00/00/0000");
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
}
stock GetVehicleName(vehicleid)
{
	new String[10000]
    format(String,sizeof(String),"%s",VehicleNames[GetVehicleModel(vehicleid) - 400]);
    return String;
}


forward LastPlayerLocation(playerid);
public LastPlayerLocation(playerid){
	//PlayerTextDrawDestroy(playerid, PlayerTD[playerid][qtd]);
	TogglePlayerSpectating(playerid, 0);
	SetPlayerSkin(playerid, PlayerInfo[playerid][skin]);
	SetPlayerPos(playerid, lastx[playerid], lasty[playerid], lastz[playerid]);
	
}
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
			format(strradar, sizeof(strradar),"{FF0000}Radar\n{FFFFFF}Limite de velocidade: %d KM/H",InfoRadar[i][lVelocidade]);
			CreateObject(18880, InfoRadar[i][lPosX], InfoRadar[i][lPosY], InfoRadar[i][lPosZ], 0.0, 0.0, InfoRadar[i][lAngulo]);
			CreateObject(18880, InfoRadar[i][lPosX], InfoRadar[i][lPosY], InfoRadar[i][lPosZ], 0.0, 0.0, InfoRadar[i][lAngulo] + 180.0);
			TRadar[i] = Text3D:Create3DTextLabel(strradar, -1, InfoRadar[i][lPosX], InfoRadar[i][lPosY], InfoRadar[i][lPosZ]+4, 50.0, 0);
			qtdRadares = i;
		}else{
			break;
		}
		
	}
	RadarID[idDoRadar] = qtdRadares + 1;
	printf("        %d Radares Carregados.    ", qtdRadares);
	RadarID[idDoRadar] = qtdRadares;

}


new Msgss[][128] = {
	{"{00FF00}Digite {FF0000}/regras {00FF00}para ver as regras do servidor."},
	{"{00FF00}Ofensa a staff será punida com {9D0000}ban{00FF00}."},
	{"{00FF00}Evite fazer DM em locais publicos, caso contrario sera preso."},
	{"{00FF00}Digite {FF0000}/arena {00FF00}para ir para a arena DeathMatch."},
	{"{00FF00}Caso esteja precisando de um emprego, va ate a agencia de empregos, tem uma em cada cidade de San Andreas."}
};

forward Msgs();

public Msgs()
    return SendClientMessageToAll(0xFFFF00FF, Msgss[random(sizeof Msgss)]); 

main()
{
	print("\n=========Anonymous Gaming RPG=========");
	print(" ");
	print("         Servidor iniciando		  ");
	print("       Aguarde o carregamento.	      ");
	LoadRadares();
	print(" ");
	print("=========Anonymous Gaming RPG=========\n");


	
}

public OnGameModeInit()
{
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	SetGameModeText("ANM Gaming - Brasil Chroma RPG v0.01");

	SetTimer("Msgs", 90000, true);
	SetTimer("CheckRadar", 250, true);
	

	return 1;
}



public OnGameModeExit()
{
	DOF2_Exit();
	return 1;
}

public OnPlayerSpawn(playerid){
	new Float:x, Float:y, Float:z;
	new file[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	if(DOF2_FileExists(file)){
		CarregarConta(playerid);
	}else{
		PlayerInfo[playerid][posX] = 1481.060546;
		PlayerInfo[playerid][posY] = -1767.387573;
		PlayerInfo[playerid][posZ] = 18.795755;
	}
	GetPlayerVelocity(playerid, x, y, z);
	// Add to current velocity
	new Float:increment = 10.0;
	floatadd(x, increment);
	floatadd(z, increment);
	// Set player's velocity to incremented velocity that we calculated
	SetPlayerVelocity(playerid, x, y, z);
	new s1[128];
	format(s1, sizeof(s1), "{FF0000}[{00FF00}Chroma{AAAAAA}RP{FF0000}] {00FF00}%s {FFFFFF}Entrou no servidor, seja bem vindo!", PlayerName(playerid));
	SendClientMessageToAll(-1, s1);
	SetPlayerSkin(playerid, DOF2_GetInt(file, "Skin"));
	SetPlayerPos(playerid, PlayerInfo[playerid][posX], PlayerInfo[playerid][posY], floatadd(PlayerInfo[playerid][posZ],1.0));
	Logado[playerid] = true;
	if(IsPlayerNPC(playerid)) return 1;
	return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
	InterpolateCameraPos(playerid, -213.469284, -877.230651, 111.213104, 1248.799804, -1216.649047, 160.182632, 100000);
	InterpolateCameraLookAt(playerid, -214.413848, -881.871887, 109.611007, 1245.679321, -1220.093872, 158.339920, 100000);
	ClearPlayerChat(playerid);
	if(IsPlayerNPC(playerid)) return 1;

	return 1;
}


stock ClearPlayerChat(playerid){
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");
	SendClientMessage(playerid, 0x66CD00, " ");


}



public OnPlayerConnect(playerid)
{
	InterpolateCameraPos(playerid, -213.469284, -877.230651, 111.213104, 1248.799804, -1216.649047, 160.182632, 100000);
	InterpolateCameraLookAt(playerid, -214.413848, -881.871887, 109.611007, 1245.679321, -1220.093872, 158.339920, 100000);
	ClearPlayerChat(playerid);
	//CreateInitial(playerid);
	createtd(playerid);
	CarregarConta(playerid);
	if(IsPlayerNPC(playerid)) SpawnPlayer(playerid);

	return 1;
}
public OnPlayerDisconnect(playerid, reason){
	if(Logado[playerid]){
		SalvarConta(playerid);
		Logado[playerid] = false;
		
		minutos[playerid] = 3;
		segundos[playerid] = 0;
		
	}
	return 1;

}


stock PlayerName(playerid){
	new string[MAX_PLAYER_NAME];
	GetPlayerName(playerid, string, sizeof(string));
	return string;

}
stock CarregarConta(playerid){
	new file[124];
	format(file, sizeof(file),CONTAS, PlayerName(playerid));

	PlayerInfo[playerid][Level] = DOF2_GetInt(file, "Level");
	PlayerInfo[playerid][Experiencia] = DOF2_GetInt(file, "Exp");
	PlayerInfo[playerid][LvlProcurado] = DOF2_GetInt(file, "Nivel de procurado");
	PlayerInfo[playerid][Dinheiro] = DOF2_GetInt(file, "Money");
	PlayerInfo[playerid][posX] = DOF2_GetFloat(file, "X");
	PlayerInfo[playerid][posY] = DOF2_GetFloat(file, "Y");
	PlayerInfo[playerid][posZ] = DOF2_GetFloat(file, "Z");
	PlayerInfo[playerid][Saude] = DOF2_GetFloat(file, "Vida");
	PlayerInfo[playerid][skin] = DOF2_GetInt(file, "Skin");
	PlayerInfo[playerid][Saude] = DOF2_GetFloat(file, "Vida");
	PlayerInfo[playerid][fome] = DOF2_GetInt(file, "Fome");
	PlayerInfo[playerid][sede] = DOF2_GetInt(file, "Sede");
	PlayerInfo[playerid][sono] = DOF2_GetInt(file, "Sono");
	PlayerInfo[playerid][HabAquatica] = DOF2_GetInt(file, "HabAquatica");
	PlayerInfo[playerid][HabTerrestre] = DOF2_GetInt(file, "HabTerrestre");
	PlayerInfo[playerid][HabAr] = DOF2_GetInt(file, "HabAerea");
	PlayerInfo[playerid][MultasT] = DOF2_GetInt(file, "MultasT");
	PlayerInfo[playerid][MultasAq] = DOF2_GetInt(file, "MultasAq");
	PlayerInfo[playerid][MultasAr] = DOF2_GetInt(file, "MultasAr");
	emaill = DOF2_GetString(file, "Email");
	PlayerInfo[playerid][Senha] = DOF2_GetString(file, "Password");
	minutos[playerid] = DOF2_GetInt(file,"MinUp");
	segundos[playerid] = DOF2_GetInt(file,"SegUp");
	//senhalogin = PlayerInfo[playerid][Senha];
	return 0;
}
stock SalvarConta(playerid){
	new float:x[MAX_PLAYERS],float:y[MAX_PLAYERS],float:z[MAX_PLAYERS],float:health[MAX_PLAYERS];
	GetPlayerHealth(playerid, health[playerid]);
	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	new file[124];
	format(file, sizeof(file),CONTAS, PlayerName(playerid));

	DOF2_SetInt(file, "Level", GetPlayerScore(playerid));
	DOF2_SetInt(file, "Exp", Exp[playerid]);
	DOF2_SetInt(file, "Nivel de procurado", PlayerInfo[playerid][LvlProcurado]);
	DOF2_SetInt(file, "Money", GetPlayerMoney(playerid));
	DOF2_SetFloat(file, "X", x[playerid]);
	DOF2_SetFloat(file, "Y", y[playerid]);
	DOF2_SetFloat(file, "Z", z[playerid]);
	DOF2_SetInt(file, "Vida", health[playerid]); 
	DOF2_SetInt(file, "Skin", GetPlayerSkin(playerid)); 
	DOF2_SetInt(file, "Fome", PlayerInfo[playerid][fome]); 
	DOF2_SetInt(file, "Sede", PlayerInfo[playerid][sede]);
	DOF2_SetInt(file, "Sono", PlayerInfo[playerid][sono]); 
	DOF2_SetInt(file, "HabTerrestre", PlayerInfo[playerid][HabTerrestre]); 
	DOF2_SetInt(file, "HabAerea", PlayerInfo[playerid][HabAr]); 
	DOF2_SetInt(file, "HabAquatica", PlayerInfo[playerid][HabAquatica]);
	DOF2_SetInt(file, "MultasT" ,  PlayerInfo[playerid][MultasT]); 
	DOF2_SetInt(file, "MultasAr" ,  PlayerInfo[playerid][MultasAr]); 
	DOF2_SetInt(file, "MultasAq" ,  PlayerInfo[playerid][MultasAq]); 
	DOF2_SaveFile();


	return 0;
}

public OnPlayerRequestSpawn(playerid){
	if(IsPlayerNPC(playerid)) return 1;
	return 0;
}
new bool:onvehicle[MAX_PLAYERS];
forward EjectPlayerFromVehicle(playerid);
public EjectPlayerFromVehicle(playerid){
	TogglePlayerControllable(playerid, false);
	RemovePlayerFromVehicle(playerid);
	
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){

	if(!IsPlayerNPC(playerid)){
		if((vehicleid == 417) || (vehicleid == 425 ) || (vehicleid == 460 ) || (vehicleid == 469 ) || (vehicleid == 476 ) ||(vehicleid == 417) || (vehicleid == 487 ) || (vehicleid == 497 ) || (vehicleid == 511 ) || (vehicleid == 512 ) || (vehicleid == 513 ) ||(vehicleid == 520  ) ||(vehicleid == 553  ) ||(vehicleid == 563  ) ||(vehicleid == 577  ) ||(vehicleid == 593)){
			if(PlayerInfo[playerid][HabAr] == 0){
			SendClientMessage(playerid, -1, "{FF0000} Voce nao possui habilitacao para avioes e veiculos voadores.")
			TogglePlayerControllable(playerid, false);
			TogglePlayerControllable(playerid, true);
			}else{
				onvehicle[playerid] = true;
			}
		}else if((vehicleid == 430 ) || (vehicleid == 446  ) || (vehicleid == 452  ) || (vehicleid == 453  ) || (vehicleid == 454  ) ||(vehicleid == 472 ) || (vehicleid == 473  ) || (vehicleid == 484  ) || (vehicleid == 493  ) || (vehicleid == 539  ) || (vehicleid == 595 )){
			if(PlayerInfo[playerid][HabAquatica] == 0){
			SendClientMessage(playerid, -1, "{FF0000} Voce nao possui habilitacao para barcos e veiculos aquaticos.")
			TogglePlayerControllable(playerid, false);
			TogglePlayerControllable(playerid, true);
			}else{
				onvehicle[playerid] = true;
			}
		}else if((vehicleid == 510) || (vehicleid == 509) || (vehicleid == 481) || (vehicleid == 509)){
			
		}else{
			if(PlayerInfo[playerid][HabTerrestre] == 0){
			SendClientMessage(playerid, -1, "{FF0000} Voce nao possui habilitacao para veiculos terrestres.")
			TogglePlayerControllable(playerid, false);
			TogglePlayerControllable(playerid, true);
			}else{
				onvehicle[playerid] = true;
			}
		}
	}
}


public OnPlayerUpdate(playerid){
	if(PlayerInfo[playerid][MultasT] == 10){
		SendClientMessage(playerid, -1, "{FF0000}[MULTAS] {FFFFFF}Voce levou 10 multas, por isso perdeu sua Habilitacao terrestre e ganhou um nivel de procurado.");
		PlayerInfo[playerid][MultasT] = 0;
		PlayerInfo[playerid][HabTerrestre] = 0;
		PlayerInfo[playerid][LvlProcurado]++;
	}

	// if(onvehicle[playerid] == true){
	// 	PlayerInfo[playerid][tVelocimetro] = SetTimer("Velocimetro", 500, true);
	// }else{
	// 	KillTimer(PlayerInfo[playerid][tVelocimetro]);
	// 	TextDrawDestroy(VelocimetroTD[0]);
	// 	TextDrawDestroy(VelocimetroTD[1]);
	// }
}

//ls ,lv, ap, ls, redcounty

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
	CarregarConta(playerid);
	GetVehicleVelocity(GetPlayerVehicleID(playerid), ppx, ppy, ppz);
	PlayerSpeedDistance = floatmul(floatsqroot(floatadd(floatadd(floatpower(ppx, 2), floatpower(ppy, 2)),  floatpower(ppz, 2))), 160.0);
	new spe = floatround(PlayerSpeedDistance * 1);
	VelocidadeDoPlayer[playerid] = spe;
	new vehicle;
	vehicle = GetPlayerVehicleID(playerid);
	if(vehicle > 0){
	for(new i = 0; i < MAX_RADAR; i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 15.0, InfoRadar[i][lPosX],InfoRadar[i][lPosY],InfoRadar[i][lPosZ]))
		{
			if(PlayerInfo[playerid][HabTerrestre] == 1){
				if(VelocidadeDoPlayer[playerid] > InfoRadar[i][lVelocidade])
				{
					if(gettime() > Variavel[playerid])
					{
					
							DOF2_SetInt(file, "MultasT", DOF2_GetInt(file, "MultasT") + 1);
     						Variavel[playerid] = (gettime() + 1);
							new s1[128], s2[128], s3[128];
							format(s2, sizeof(s2), "{FF0000}Id do radar: {FFFFFF}%d" , i);
							format(s2, sizeof(s2), "{FF0000}Limite: {FFFFFF}%dKM/h" , InfoRadar[i][lVelocidade]);
							format(s1, sizeof(s1), "{FF0000}Velocidade Registrada: {FFFFFF}%dKM/h", VelocidadeDoPlayer[playerid]);
							format(s3, sizeof(s3), "{FF0000}Multas na CNH: {FFFFFF}%d",  DOF2_GetInt(file, "MultasT"));
							SendClientMessage(playerid, -1, "{FFFFFF}==================== {FF0000}MULTA {FFFFFF}====================");
							SendClientMessage(playerid, -1, "{FF0000}Motivo: {FFFFFF}Excesso de velocidade");
							SendClientMessage(playerid, -1, s2);
							SendClientMessage(playerid, -1, s1);
							SendClientMessage(playerid, -1, s3);
							SendClientMessage(playerid, -1, "{FFFFFF}==================== {FF0000}MULTA {FFFFFF}====================");
							
							
							return 1;
					}
				}
			}
		}
	}

	}
	return 1;
}



public OnPlayerStateChange(playerid, newstate, oldstate){
	
	return 1;
}



//===============================comandos===============================//
CMD:sethab(playerid, params[]){
	new velo, file[128];
	format(file, sizeof(file), CONTAS, PlayerName(playerid));
	if(sscanf(params,"d",velo)) return SendClientMessage(playerid, -1, "{FF0000}[ERRO] {FFFFFF}Digite: /sethab [0/1]");
	if((velo > 1) || (velo < 0)) return SendClientMessage(playerid, -1, "{FF0000}[ERRO] {FFFFFF}Digite: /sethab [0/1]");
	
	if(velo == 1){
		PlayerInfo[playerid][HabTerrestre] = velo;
		DOF2_SetInt(file, "HabTerrestre", 1);
		return SendClientMessage(playerid, -1, "{00FF00}[HABILITACAO] {FFFFFF}Habilitacao concedida.");
	} 
	if(velo == 0){
		PlayerInfo[playerid][HabTerrestre] = velo;
		DOF2_SetInt(file, "HabTerrestre", 0);
		return SendClientMessage(playerid, -1, "{00FF00}[HABILITACAO] {FFFFFF}Habilitacao removida.");
	}
	
	return 1;
}
CMD:moto(playerid, params[]){
	if(!Logado[playerid]) return SendClientMessage(playerid, -1, "{FF0000}[Erro] {FFFFFF}Voce nao se logou/registrou, por isso nao pode digitar comandos.");

	new float:x[MAX_PLAYERS],float:y[MAX_PLAYERS],float:z[MAX_PLAYERS],float:rotation[MAX_PLAYERS];
	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	AddStaticVehicle(522, x[playerid], y[playerid], z[playerid], rotation[playerid], WHITE, WHITE);
	
	SendClientMessage(playerid, AZUL, "[MOTO] Moto spawnada!");
SendClientMessage(playerid, -1, "{FF0000}[Erro] {FFFFFF}Voce nao se logou/registrou, por isso nao pode digitar comandos.");

	return 1;
}
CMD:createradar(playerid, params[]){
	new file[256], strradar[2500];
	new velo;
	if(sscanf(params,"d",velo)) return SendClientMessage(playerid, -1,"{FF0000}[ERRO] {FFFFFF}Digite: /createradar [velocidade]");
	format(strradar, sizeof(strradar),"{FF0000}Radar\n{FFFFFF}Limite de velocidade: %d KM/H",InfoRadar[radarid[playerid]][lVelocidade]);
	format(file, sizeof(file), RADARES, RadarID[idDoRadar]);
	new float:RadarX,float:RadarY,float:RadarZ, float:Angle;
	GetPlayerPos(playerid, RadarX, RadarY, RadarZ);
	GetPlayerFacingAngle(playerid, Angle);
	new float:ppx[MAX_PLAYERS], float:ppy[MAX_PLAYERS], float:ppz[MAX_PLAYERS];
	GetPlayerPos(playerid, ppx[playerid], ppy[playerid], ppz[playerid]);
	SetPlayerPos(playerid, floatadd(ppx[playerid], 3), floatadd(ppy[playerid], 3), ppz[playerid] );
	SetPlayerInterior(playerid, 0);
	InfoRadar[radarid[playerid]][lPosX] = RadarX;
	InfoRadar[radarid[playerid]][lPosY] = RadarY;
	InfoRadar[radarid[playerid]][lPosZ] = RadarZ-1.5;
	InfoRadar[radarid[playerid]][lAngulo] = Angle;
	InfoRadar[radarid[playerid]][lVelocidade] = velo;
	
	CreateObject(18880, RadarX, RadarY, floatsub(RadarZ, 1.5), 0.0, 0.0, Angle);
	TRadar[RadarID[idDoRadar]] = Text3D:Create3DTextLabel(strradar, -1, RadarX, RadarY, RadarZ+4, 50.0, 0);

	DOF2_CreateFile(file);
	DOF2_SetInt(file,"Velocidade",velo);
	DOF2_SetFloat(file,"PosX", RadarX);
	DOF2_SetFloat(file,"PosY",RadarY);
	DOF2_SetFloat(file,"PosZ",floatsub(RadarZ, 1.5));
	DOF2_SetFloat(file,"Angulo",Angle);
	DOF2_SetInt(file,"ID",RadarID[idDoRadar]);
	DOF2_SaveFile();
	RadarID[idDoRadar]++;
	new radarStr[1000];

	SendClientMessage(playerid, -1,"{00FF00}[RADARES] {FFFFFF}Radar Criado.");

	format(radarStr, sizeof(radarStr),"{00FF00}[RADARES] {FFFFFF}id:{00FF00} %d",RadarID[idDoRadar]);
	SendClientMessage(playerid, -1,radarStr);
	format(radarStr, sizeof(radarStr),"{00FF00}[RADARES] {FFFFFF}Limite de velocidade: {00FF00}%dKM/H",InfoRadar[radarid[playerid]][lVelocidade]);
	SendClientMessage(playerid, -1,radarStr);
	format(radarStr, sizeof(radarStr),"{00FF00}[RADARES] {FFFFFF}X: {00FF00}%f  {FFFFFF}Y: {00FF00}%f  {FFFFFF}Z: {00FF00}%f",RadarX, RadarY, floatsub(RadarZ, 1.5));
	SendClientMessage(playerid, -1,radarStr);
	return 1;
}
CMD:hidecell(playerid, params[]){
	DestroyCellphone(playerid);
	DestroyLockCellphone(playerid);
	return 1;
}
CMD:reload(playerid, params[]){
	if(!Logado[playerid]) return SendClientMessage(playerid, -1, "{FF0000}[Erro] {FFFFFF}Voce nao se logou/registrou, por isso nao pode digitar comandos.");

	SendClientMessage(playerid,VERDE,"O servidor está sendo reiniciado");
	return SendRconCommand("gmx");

	
}
CMD:ajuda(playerid, params[]){
	new str[5000];
	if(!Logado[playerid]) return SendClientMessage(playerid, -1, "{FF0000}[Erro] {FFFFFF}Voce nao se logou/registrou, por isso nao pode digitar comandos.");

	//strcat(str, "{FF0000}/ajuda{FFFFFF}: Ajuda sobre o servidor.");
	strcat(str, "{FF0000}/sethab [0/1]{FFFFFF}: Ativa/desativa a habilitacao");
	strcat(str, "\n{FF0000}/moto{FFFFFF}: Gera uma moto");
	//strcat(str, "\n{FF0000}/admins{FFFFFF}: Mostra todos os admins online");
	//strcat(str, "\n{FF0000}/celular{FFFFFF}: Exibe o seu celular");
	//strcat(str, "\n{FF0000}/changename [novo nick]{FFFFFF}: Muda o seu nick atual.");
	strcat(str, "\n{FF0000}/cores{FFFFFF}: Mostra as cores disponiveis.");
	strcat(str, "\n{FF0000}/ppos{FFFFFF}: exibe a sua posicao atual no chat.");
	//strcat(str, "\n{FF0000}/sms [id do jogador]{FFFFFF}: Envia uma mensagem privada");
	//strcat(str, "\n{FF0000}/report [id do acusado] [motivo]{FFFFFF}: Envia uma acusacao sobre o jogador especificado.");
	//strcat(str, "\n{FF0000}/regras{FFFFFF}: Mostra as regras do servidor.");
	strcat(str, "\n{FF0000}/tutorial{FFFFFF}: Mostra os locais publicos, regras, e comandos basicos para iniciar no servidor.");
	
	ShowPlayerDialog(playerid, DIALOG_COMANDOS, DIALOG_STYLE_MSGBOX, "Comandos", str, "Ok");
	return 1;
	
	
		
	
	
	
}

// CMD:tutorial(playerid, params[]){
// 	if(Logado[playerid]){
// 	//format(str[0],sizeof(str[0]), "================[Comandos]================");
// 	ShowTutorial(playerid);
// 	//ShowPlayerDialog(playerid, DIALOG_COMANDOS, DIALOG_STYLE_MSGBOX, "Comandos", str, "Ok");
// 	}else{
// 		SendClientMessage(playerid, -1, "{FF0000}[Erro] {FFFFFF}Voce nao se logou/registrou, por isso nao pode digitar comandos.");
// 	}
// 	return 1;
// }

CMD:ppos(playerid, params[]){
	if(!Logado[playerid]) return SendClientMessage(playerid, -1, "{FF0000}[Erro] {FFFFFF}Voce nao se logou/registrou, por isso nao pode digitar comandos.");

	new float:x[MAX_PLAYERS],float:y[MAX_PLAYERS],float:z[MAX_PLAYERS], float:angle[MAX_PLAYERS];
	GetPlayerVirtualWorld(playerid);
	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	GetPlayerFacingAngle(playerid, angle[playerid]);
	new texto[128];
	format(texto, sizeof(texto), "[POSICAO] X: %f  Y: %f  Z: %f  Rotation: %f  VW: %d", x[playerid], y[playerid], z[playerid], angle[playerid], GetPlayerVirtualWorld(playerid));
	SendClientMessage(playerid, VERDE, "Esta e sua posicao atual:");
	SendClientMessage(playerid, VERDE, texto);
	
	
	return 1;
}

CMD:cores(playerid, params[]){
	if(!Logado[playerid]) return SendClientMessage(playerid, -1, "{FF0000}[Erro] {FFFFFF}Voce nao se logou/registrou, por isso nao pode digitar comandos.");

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
//===============================comandos===============================//