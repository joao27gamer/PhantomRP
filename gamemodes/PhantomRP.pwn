
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

new tmrclock[MAX_PLAYERS];
new bool:Logado[MAX_PLAYERS];
new senha[128], confsenha[128], senhalogin[128];
//variaveis//

//Dialogs//
#define DIALOG_REGISTRO 0
#define DIALOG_CONFREGISTRO 1

#define DIALOG_LOGIN 2


new PlayerText:PlayerTD[MAX_PLAYERS][28];
new PlayerText:ClockTD[MAX_PLAYERS][2];
//Dialogs//


//funções//
main()
{
    printf("==================[PhantomRP]==================");
    printf("=                                             =");
    printf("=             Servidor carregado.             =");
    printf("=                                             =");
    printf("==================[PhantomRP]==================");
}

forward start(playerid);
public start(playerid){
	new file[128];
	format(file, sizeof(file), "contas/%s.ini", PlayerName(playerid));
	CreateInicial(playerid);

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

public OnGameModeInit(){
    EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	SetGameModeText("RPG|Brasil PRP[PT-BR]v0.1|");
    return 1;
}

public OnGameModeExit(){
    DOF2_Exit();
    return 1;
}

public OnPlayerConnect(playerid){
    new cam, file[128];
    cam = random(3);
	format(file, sizeof(file), "contas/%s.ini", PlayerName(playerid));
	if(IsPlayerNPC(playerid)) SpawnPlayer(playerid);

	SetTimer("start", 2500, false);
	CreateClock(playerid);
	//SetSpawnInfo(playerid, GetPlayerTeam(playerid), 0, 0.0, 0.0, 0.0, 0.0);

    if(cam == 0){
        InterpolateCameraPos(playerid, -16.776363, -2071.549804, 145.789672, 2504.847412, -1481.552246, 125.794448, 50000);
        InterpolateCameraLookAt(playerid, -13.651768, -2068.070312, 144.020263, 2501.822265, -1478.139770, 123.743972, 50000);
    }else if(cam == 1){
        InterpolateCameraPos(playerid, 854.839782, -1215.568115, 196.104782, 1336.177246, -1232.114501, 16.122467, 35000);
        InterpolateCameraLookAt(playerid, 856.604492, -1219.503173, 193.574676, 1338.891235, -1236.301513, 16.443048, 35000);
    }else if(cam == 2){
        InterpolateCameraPos(playerid, 1834.899902, -1040.523315, 216.126510, 88.353263, -1124.242919, 176.513442, 50000);
        InterpolateCameraLookAt(playerid, 1832.391601, -1036.634399, 214.233062, 90.477981, -1119.991699, 174.960220, 50000);
    }else if(cam == 3){
        InterpolateCameraPos(playerid, 291.758850, -737.588134, 157.044021, 169.185165, 1025.968872, 107.048583, 50000);
        InterpolateCameraLookAt(playerid, 296.282165, -736.465576, 155.233123, 174.012939, 1025.364624, 105.896438, 50000);
    }
    
    return 1;
}

public OnPlayerDisconnect(playerid, reason){
    KillTimer(tmrclock[playerid]);
	if(Logado[playerid]) SalvarConta(playerid);
    
    return 1;
}

public OnPlayerSpawn(playerid){
	if(IsPlayerNPC(playerid)) return 1;
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
//comandos//


