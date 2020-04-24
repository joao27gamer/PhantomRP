/*
		Velocimetro estilo GTA V
       by: ForT ou dimmy_scarface
              17/07/2015
*/

#include <a_samp>

// (Global Textdraws velocimetro)
new Text:textVelocimetro[5];

// (Player Textdraws velocimetro)
new PlayerText:textPlayerVelocimetro[4][MAX_PLAYERS];

// (Vendo o velocimetro ou não)
new bool:PlayerVelocimetro[MAX_PLAYERS];

// (Timer velocimetro)
new PlayerVelocimetroTimer[MAX_PLAYERS];

stock Float:GetVehicleHealthEx(vehicleid)
{
	new Float:health;
	GetVehicleHealth(vehicleid, health);
	
	if ( health > 900.0) {
		return health / 10.0;
	}
	else return ( health / 10.0 )-(24);
}

public UpdatePlayerVelocimetro(playerid) {

	new playervehicle;

	if ( (playervehicle = GetPlayerVehicleID(playerid)) != INVALID_VEHICLE_ID) {

	    new string_velo[15];

	    format(string_velo, sizeof (string_velo), "%02d km/h", GetVehicleSpeed(playervehicle));
	    PlayerTextDrawSetString(playerid, textPlayerVelocimetro[1][playerid], string_velo);

	    format(string_velo, sizeof (string_velo), "%.0f%", GetVehicleHealthEx(playervehicle));
	    PlayerTextDrawSetString(playerid, textPlayerVelocimetro[3][playerid], string_velo);
	    
	    /* Desativado:
	    format(string_velo, sizeof (string_velo), "%02d Litros", Combustivel[playervehicle]);
	    PlayerTextDrawSetString(playerid, textPlayerVelocimetro[2][playerid], string_velo);
		*/
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate) {

	if ( newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) {
	    ShowPlayerVelocimetro(playerid) ;
	} else {
	    HidePlayerVelocimetro(playerid) ;
	}
	return 1;
}

stock ShowPlayerVelocimetro(playerid) {
	if ( PlayerVelocimetro[playerid] ) {
	    return 0;
	}
	
	PlayerTextDrawSetString(playerid, textPlayerVelocimetro[0][playerid], getVehicleName(GetPlayerVehicleID(playerid)));
	
	for( new text; text != 5; text++) TextDrawShowForPlayer(playerid, textVelocimetro[text]);
	for( new text; text != 4; text++) PlayerTextDrawShow(playerid, textPlayerVelocimetro[text][playerid]);
	PlayerVelocimetro[playerid] = true ;
	PlayerVelocimetroTimer[playerid] = SetTimerEx("UpdatePlayerVelocimetro", 100, true, "i", playerid);
	return 1;
}

stock HidePlayerVelocimetro(playerid) {
	if ( !PlayerVelocimetro[playerid] ) {
	    return 0;
	}
	for( new text; text != 5; text++) TextDrawHideForPlayer(playerid, textVelocimetro[text]);
	for( new text; text != 4; text++) PlayerTextDrawHide(playerid, textPlayerVelocimetro[text][playerid]);
	PlayerVelocimetro[playerid] = false ;
	KillTimer(PlayerVelocimetroTimer[playerid]);
	return 1;
}

public OnPlayerConnect(playerid) {

    PlayerVelocimetro[playerid] = false ;

	textPlayerVelocimetro[0][playerid] = CreatePlayerTextDraw(playerid,615.000000, 385.000000, "Nenhum");
	PlayerTextDrawAlignment(playerid,textPlayerVelocimetro[0][playerid], 3);
	PlayerTextDrawBackgroundColor(playerid,textPlayerVelocimetro[0][playerid], 0);
	PlayerTextDrawFont(playerid,textPlayerVelocimetro[0][playerid], 1);
	PlayerTextDrawLetterSize(playerid,textPlayerVelocimetro[0][playerid], 0.330000, 1.299999);
	PlayerTextDrawColor(playerid,textPlayerVelocimetro[0][playerid], -156);
	PlayerTextDrawSetOutline(playerid,textPlayerVelocimetro[0][playerid], 0);
	PlayerTextDrawSetProportional(playerid,textPlayerVelocimetro[0][playerid], 1);
	PlayerTextDrawSetShadow(playerid,textPlayerVelocimetro[0][playerid], 1);
	PlayerTextDrawSetSelectable(playerid,textPlayerVelocimetro[0][playerid], 0);

	textPlayerVelocimetro[1][playerid] = CreatePlayerTextDraw(playerid,615.000000, 399.000000, "000 km/h");
	PlayerTextDrawAlignment(playerid,textPlayerVelocimetro[1][playerid], 3);
	PlayerTextDrawBackgroundColor(playerid,textPlayerVelocimetro[1][playerid], 0);
	PlayerTextDrawFont(playerid,textPlayerVelocimetro[1][playerid], 2);
	PlayerTextDrawLetterSize(playerid,textPlayerVelocimetro[1][playerid], 0.250000, 1.299999);
	PlayerTextDrawColor(playerid,textPlayerVelocimetro[1][playerid], -156);
	PlayerTextDrawSetOutline(playerid,textPlayerVelocimetro[1][playerid], 0);
	PlayerTextDrawSetProportional(playerid,textPlayerVelocimetro[1][playerid], 1);
	PlayerTextDrawSetShadow(playerid,textPlayerVelocimetro[1][playerid], 1);
	PlayerTextDrawSetSelectable(playerid,textPlayerVelocimetro[1][playerid], 0);

	textPlayerVelocimetro[2][playerid] = CreatePlayerTextDraw(playerid,615.000000, 413.000000, "0 litros");
	PlayerTextDrawAlignment(playerid,textPlayerVelocimetro[2][playerid], 3);
	PlayerTextDrawBackgroundColor(playerid,textPlayerVelocimetro[2][playerid], 0);
	PlayerTextDrawFont(playerid,textPlayerVelocimetro[2][playerid], 2);
	PlayerTextDrawLetterSize(playerid,textPlayerVelocimetro[2][playerid], 0.250000, 1.299999);
	PlayerTextDrawColor(playerid,textPlayerVelocimetro[2][playerid], -156);
	PlayerTextDrawSetOutline(playerid,textPlayerVelocimetro[2][playerid], 0);
	PlayerTextDrawSetProportional(playerid,textPlayerVelocimetro[2][playerid], 1);
	PlayerTextDrawSetShadow(playerid,textPlayerVelocimetro[2][playerid], 1);
	PlayerTextDrawSetSelectable(playerid,textPlayerVelocimetro[2][playerid], 0);

	textPlayerVelocimetro[3][playerid] = CreatePlayerTextDraw(playerid,615.000000, 427.000000, "0%");
	PlayerTextDrawAlignment(playerid,textPlayerVelocimetro[3][playerid], 3);
	PlayerTextDrawBackgroundColor(playerid,textPlayerVelocimetro[3][playerid], 0);
	PlayerTextDrawFont(playerid,textPlayerVelocimetro[3][playerid], 2);
	PlayerTextDrawLetterSize(playerid,textPlayerVelocimetro[3][playerid], 0.250000, 1.299999);
	PlayerTextDrawColor(playerid,textPlayerVelocimetro[3][playerid], -156);
	PlayerTextDrawSetOutline(playerid,textPlayerVelocimetro[3][playerid], 0);
	PlayerTextDrawSetProportional(playerid,textPlayerVelocimetro[3][playerid], 1);
	PlayerTextDrawSetShadow(playerid,textPlayerVelocimetro[3][playerid], 1);
	PlayerTextDrawSetSelectable(playerid,textPlayerVelocimetro[3][playerid], 0);
	return 1;
}

public OnPlayerDisconnect(playerid) {

	if (PlayerVelocimetro[playerid]) {
	    KillTimer(PlayerVelocimetroTimer[playerid]);
	}
	return 1;
}

public OnFilterScriptInit() {

	textVelocimetro[0] = TextDrawCreate(379.000000, 378.000000, "i");
	TextDrawBackgroundColor(textVelocimetro[0], 0);
	TextDrawFont(textVelocimetro[0], 2);
	TextDrawLetterSize(textVelocimetro[0], 28.800073, 2.600000);
	TextDrawColor(textVelocimetro[0], 80);
	TextDrawSetOutline(textVelocimetro[0], 0);
	TextDrawSetProportional(textVelocimetro[0], 1);
	TextDrawSetShadow(textVelocimetro[0], 1);
	TextDrawSetSelectable(textVelocimetro[0], 0);

	textVelocimetro[1] = TextDrawCreate(379.000000, 392.000000, "i");
	TextDrawBackgroundColor(textVelocimetro[1], 0);
	TextDrawFont(textVelocimetro[1], 2);
	TextDrawLetterSize(textVelocimetro[1], 28.800073, 2.600000);
	TextDrawColor(textVelocimetro[1], 80);
	TextDrawSetOutline(textVelocimetro[1], 0);
	TextDrawSetProportional(textVelocimetro[1], 1);
	TextDrawSetShadow(textVelocimetro[1], 1);
	TextDrawSetSelectable(textVelocimetro[1], 0);

	textVelocimetro[2] = TextDrawCreate(379.000000, 406.000000, "i");
	TextDrawBackgroundColor(textVelocimetro[2], 0);
	TextDrawFont(textVelocimetro[2], 2);
	TextDrawLetterSize(textVelocimetro[2], 28.800073, 2.600000);
	TextDrawColor(textVelocimetro[2], 80);
	TextDrawSetOutline(textVelocimetro[2], 0);
	TextDrawSetProportional(textVelocimetro[2], 1);
	TextDrawSetShadow(textVelocimetro[2], 1);
	TextDrawSetSelectable(textVelocimetro[2], 0);

	textVelocimetro[3] = TextDrawCreate(379.000000, 420.000000, "i");
	TextDrawBackgroundColor(textVelocimetro[3], 0);
	TextDrawFont(textVelocimetro[3], 2);
	TextDrawLetterSize(textVelocimetro[3], 28.800073, 2.600000);
	TextDrawColor(textVelocimetro[3], 80);
	TextDrawSetOutline(textVelocimetro[3], 0);
	TextDrawSetProportional(textVelocimetro[3], 1);
	TextDrawSetShadow(textVelocimetro[3], 1);
	TextDrawSetSelectable(textVelocimetro[3], 0);

	textVelocimetro[4] = TextDrawCreate(531.000000, 387.000000, "Carro~n~~n~Velocidade~n~~n~Combustivel~n~~n~Lataria");
	TextDrawAlignment(textVelocimetro[4], 3);
	TextDrawBackgroundColor(textVelocimetro[4], 0);
	TextDrawFont(textVelocimetro[4], 2);
	TextDrawLetterSize(textVelocimetro[4], 0.210000, 0.799999);
	TextDrawColor(textVelocimetro[4], -186);
	TextDrawSetOutline(textVelocimetro[4], 0);
	TextDrawSetProportional(textVelocimetro[4], 1);
	TextDrawSetShadow(textVelocimetro[4], 1);
	TextDrawSetSelectable(textVelocimetro[4], 0);
	
	print("*****************************");
	print("*** Velocimetro carregado ***");
	print("*****************************");
	return 1;
}

new VehicleNames[212][] =
{
    {"Landstalker"},{"Bravura"},{"Buffalo"},{"Linerunner"},{"Perrenial"},{"Sentinel"},{"Dumper"},
    {"Firetruck"},{"Trashmaster"},{"Stretch"},{"Manana"},{"Infernus"},{"Voodoo"},{"Pony"},{"Mule"},
    {"Cheetah"},{"Ambulance"},{"Leviathan"},{"Moonbeam"},{"Esperanto"},{"Taxi"},{"Washington"},
    {"Bobcat"},{"Mr Whoopee"},{"BF Injection"},{"Hunter"},{"Premier"},{"Enforcer"},{"Securicar"},
    {"Banshee"},{"Predator"},{"Bus"},{"Rhino"},{"Barracks"},{"Hotknife"},{"Trailer 1"},{"Previon"},
    {"Coach"},{"Cabbie"},{"Stallion"},{"Rumpo"},{"RC Bandit"},{"Romero"},{"Packer"},{"Monster"},
    {"Admiral"},{"Squalo"},{"Seasparrow"},{"Pizzaboy"},{"Tram"},{"Trailer 2"},{"Turismo"},
    {"Speeder"},{"Reefer"},{"Tropic"},{"Flatbed"},{"Yankee"},{"Caddy"},{"Solair"},{"Berkley's RC Van"},
    {"Skimmer"},{"PCJ-600"},{"Faggio"},{"Freeway"},{"RC Baron"},{"RC Raider"},{"Glendale"},{"Oceanic"},
    {"Sanchez"},{"Sparrow"},{"Patriot"},{"Quad"},{"Coastguard"},{"Dinghy"},{"Hermes"},{"Sabre"},
    {"Rustler"},{"ZR-350"},{"Walton"},{"Regina"},{"Comet"},{"BMX"},{"Burrito"},{"Camper"},{"Marquis"},
    {"Baggage"},{"Dozer"},{"Maverick"},{"News Chopper"},{"Rancher"},{"FBI Rancher"},{"Virgo"},{"Greenwood"},
    {"Jetmax"},{"Hotring"},{"Sandking"},{"Blista Compact"},{"Police Maverick"},{"Boxville"},{"Benson"},
    {"Mesa"},{"RC Goblin"},{"Hotring Racer A"},{"Hotring Racer B"},{"Bloodring Banger"},{"Rancher"},
    {"Super GT"},{"Elegant"},{"Journey"},{"Bike"},{"Mountain Bike"},{"Beagle"},{"Cropdust"},{"Stunt"},
    {"Tanker"}, {"Roadtrain"},{"Nebula"},{"Majestic"},{"Buccaneer"},{"Shamal"},{"Hydra"},{"FCR-900"},
    {"NRG-500"},{"HPV1000"},{"Cement Truck"},{"Tow Truck"},{"Fortune"},{"Cadrona"},{"FBI Truck"},
    {"Willard"},{"Forklift"},{"Tractor"},{"Combine"},{"Feltzer"},{"Remington"},{"Slamvan"},
    {"Blade"},{"Freight"},{"Streak"},{"Vortex"},{"Vincent"},{"Bullet"},{"Clover"},{"Sadler"},
    {"Firetruck LA"},{"Hustler"},{"Intruder"},{"Primo"},{"Cargobob"},{"Tampa"},{"Sunrise"},{"Merit"},
    {"Utility"},{"Nevada"},{"Yosemite"},{"Windsor"},{"Monster A"},{"Monster B"},{"Uranus"},{"Jester"},
    {"Sultan"},{"Stratum"},{"Elegy"},{"Raindance"},{"RC Tiger"},{"Flash"},{"Tahoma"},{"Savanna"},
    {"Bandito"},{"Freight Flat"},{"Streak Carriage"},{"Kart"},{"Mower"},{"Duneride"},{"Sweeper"},
    {"Broadway"},{"Tornado"},{"AT-400"},{"DFT-30"},{"Huntley"},{"Stafford"},{"BF-400"},{"Newsvan"},
    {"Tug"},{"Trailer 3"},{"Emperor"},{"Wayfarer"},{"Euros"},{"Hotdog"},{"Club"},{"Freight Carriage"},
    {"Trailer 3"},{"Andromada"},{"Dodo"},{"RC Cam"},{"Launch"},{"Police Car (LSPD)"},{"Police Car (SFPD)"},
    {"Police Car (LVPD)"},{"Police Ranger"},{"Picador"},{"S.W.A.T. Van"},{"Alpha"},{"Phoenix"},{"Glendale"},
    {"Sadler"},{"Luggage Trailer A"},{"Luggage Trailer B"},{"Stair Trailer"},{"Boxville"},{"Farm Plow"},
    {"Utility Trailer"}
};

stock getVehicleName(vehicleid){
	new vehmodel = GetVehicleModel(vehicleid);
	new nameVeh[75];

	if (vehmodel < 400 || vehmodel > 611) {
		strcat(nameVeh, "Nenhum");
		return nameVeh;
	}
	strcat(nameVeh, VehicleNames[vehmodel - 400]);
	return nameVeh;
}

stock GetVehicleSpeed(vehicleid)
{
	new Float:xPos[3];
	GetVehicleVelocity(vehicleid, xPos[0], xPos[1], xPos[2]);
	return floatround(floatsqroot(xPos[0] * xPos[0] + xPos[1] * xPos[1] + xPos[2] * xPos[2]) * 170.00);
}

forward UpdatePlayerVelocimetro(playerid);
