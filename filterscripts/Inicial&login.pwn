/*
This file was generated by Nickk's TextDraw editor script
Nickk888 is the author of the NTD script
*/

#include <a_samp>

new PlayerText:PlayerTD[MAX_PLAYERS][28];

public OnFilterScriptInit()
{
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
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

	PlayerTD[playerid][4] = CreatePlayerTextDraw(playerid, 267.000000, 97.000000, "Chroma");
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

	PlayerTD[playerid][5] = CreatePlayerTextDraw(playerid, 346.000000, 97.000000, "RP");
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

	PlayerTD[playerid][10] = CreatePlayerTextDraw(playerid, 226.000000, 201.000000, "Username");
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

	PlayerTD[playerid][18] = CreatePlayerTextDraw(playerid, 347.000000, 201.000000, "Username");
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

	return 1;
}

public OnPlayerDisconnect(playerid)
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

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(!strcmp(cmdtext, "/tdtest", true))
	{
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
	return 0;
}
