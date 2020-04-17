#include <a_samp>
#include <zcmd>
#include <sscanf>
#include <dof2>
#define MAX_RADAR   100

#define PastaRadares        "Radares/Radar%d.ini"

static
	lString[256],
	radarid[MAX_PLAYERS],
	vel,
	Text3D:TRadar[MAX_RADAR],
	Variavel[MAX_PLAYERS],
	ObjetoRadar[2][MAX_RADAR],
	CriandoRadar,
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:Angulo;
enum radar {
	Float:lPosX,
	Float:lPosY,
	Float:lPosZ,
	Float:lAngulo,
	lVelocidade,
};
new InfoRadar[MAX_RADAR][radar];


public OnFilterScriptInit()
{
    CarregarRadares();
	return 1;
}

public OnFilterScriptExit()
{
	SalvarRadares();
    DOF2_Exit();
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 3030)
	{
		if(response)
		{
			static
				strradar[100];
			GetPlayerPos(playerid, PosX,PosY,PosZ);
			GetPlayerFacingAngle(playerid, Angulo);
			IdRadarLivre(playerid);
			InfoRadar[radarid[playerid]][lPosX] = PosX;
			InfoRadar[radarid[playerid]][lPosY] = PosY;
			InfoRadar[radarid[playerid]][lPosZ] = PosZ-1.5;
			InfoRadar[radarid[playerid]][lAngulo] = Angulo;
			InfoRadar[radarid[playerid]][lVelocidade] = vel;
		    ObjetoRadar[0][radarid[playerid]] = CreateObject(18880, InfoRadar[radarid[playerid]][lPosX], InfoRadar[radarid[playerid]][lPosY], InfoRadar[radarid[playerid]][lPosZ], 0.0, 0.0, InfoRadar[radarid[playerid]][lAngulo]);
		    ObjetoRadar[1][radarid[playerid]] = CreateObject(18880, InfoRadar[radarid[playerid]][lPosX], InfoRadar[radarid[playerid]][lPosY], InfoRadar[radarid[playerid]][lPosZ], 0.0, 0.0, InfoRadar[radarid[playerid]][lAngulo] + 180.0);
			format(strradar, sizeof(strradar),"{FF0000}Radar\nLimite de velocidade: %d KM/H",InfoRadar[radarid[playerid]][lVelocidade]);
			TRadar[radarid[playerid]] = Text3D:Create3DTextLabel(strradar, -1, InfoRadar[radarid[playerid]][lPosX], InfoRadar[radarid[playerid]][lPosY], InfoRadar[radarid[playerid]][lPosZ]+1, 50.0, 0);
			format(lString, sizeof(lString),"Radar ID: %d criado.",radarid[playerid]);
			SendClientMessage(playerid, 0x004C00FF, lString);
			SetPlayerPos(playerid, PosX+1,PosY+1,PosZ+1);
			CriandoRadar = 0;
			SalvarRadares();
		}
		else
		{
			CriandoRadar = 0;
		    SendClientMessage(playerid, 0xFFFFFFFF,"Você fechou o dialog de criar radar!");
		}
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	CheckRadar(playerid);
	return 1;
}

CMD:v(playerid)
{
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x,y,z);
	CreateVehicle(522,x,y,z,0,-1,-1,-1);
	return 1;
}

CMD:comandos(playerid)
{
	SendClientMessage(playerid, -1,"/criarradar | /deletarradar - Comandos apenas para admin rcon!");
	SendClientMessage(playerid, -1, "Sistema de criar radar por Living(Living_22) qualquer erro entre em contato com o mesmo!");
	return true;
}

CMD:deletarradar(playerid, params[])
{
	new id, strpasta[200];
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, 0xB40000FF,"Você não é um administrador!");
	if(sscanf(params, "d", id)) return SendClientMessage(playerid, -1, "Digite: /deletarradar [Id do radar]");
	format(strpasta, sizeof(strpasta), PastaRadares, id);
	if(DOF2_FileExists(strpasta))
	{
	    DOF2_RemoveFile(strpasta);
		format(lString, sizeof(lString), "Você deletou o radar de ID: %d.", id);
	    SendClientMessage(playerid, 0xFF0000FF,lString);
	    DestroyObject(ObjetoRadar[0][id]);
	    DestroyObject(ObjetoRadar[1][id]);
	    Delete3DTextLabel(TRadar[id]);
		InfoRadar[id][lPosX] = 0;
		InfoRadar[id][lPosY] = 0;
		InfoRadar[id][lPosZ] = 0;
		InfoRadar[id][lAngulo] = 0;
		InfoRadar[id][lVelocidade] = 999;
		return 1;
	}
	else
	{
        format(lString, sizeof(lString), "O radar de ID: %d não existe.", id);
		SendClientMessage(playerid, 0xFF0000FF, lString);
	}
	return 1;
}

CMD:criarradar(playerid, params[])
{
	new velocidade;
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, 0xB40000FF,"Você não é um administrador!");
	if(CriandoRadar == 1) return SendClientMessage(playerid,0xB40000FF, "Já tem alguém criando um radar, aguarde por favor!");
	if(sscanf(params,"d",velocidade)) return SendClientMessage(playerid, 0x999C9BFF,"Digite: /criarradar [velocidade]");
	vel = velocidade;
	GetPlayerPos(playerid, PosX,PosY,PosZ);
	GetPlayerFacingAngle(playerid, Angulo);
	TogglePlayerControllable(playerid, true);
	SetPlayerPos(playerid, PosX,PosY,PosZ);
	format(lString, sizeof(lString),"{FFFFFF}Você deseja mesmo criar um radar neste local?\n\n");
	format(lString, sizeof(lString),"%s{00B4FF}Posição X: {FFFFFF}%0.4f\n{00B4FF}Posição Y: {FFFFFF} %0.4f\n{00B4FF}Posição Z: {FFFFFF} %0.4f\n{00B4FF}Angulo: {FFFFFF}%0.4f\n{00B4FF}Velocidade: {FFFFFF}%d",lString,PosX,PosY,PosZ,Angulo,velocidade);
	CriandoRadar = 1;
	ShowPlayerDialog(playerid, 3030, DIALOG_STYLE_MSGBOX, "Criador de radar",lString, "Criar","Cancelar");
	return 1;
}

forward CarregarRadares();
public CarregarRadares()
{
	new
		strradar[100],
		strpasta[200];

	for(new rad=0;rad<MAX_RADAR; rad++)
	{
		format(strpasta,sizeof(strpasta),PastaRadares,rad);
	    if(DOF2_FileExists(strpasta))
	    {
			InfoRadar[rad][lVelocidade] = DOF2_GetInt(strpasta,"Velocidade");
			InfoRadar[rad][lPosX] = DOF2_GetFloat(strpasta,"PosX");
			InfoRadar[rad][lPosY] = DOF2_GetFloat(strpasta,"PosY");
			InfoRadar[rad][lPosZ] = DOF2_GetFloat(strpasta,"PosZ");
			InfoRadar[rad][lAngulo] = DOF2_GetFloat(strpasta,"Angulo");
		    ObjetoRadar[0][rad] = CreateObject(18880, InfoRadar[rad][lPosX], InfoRadar[rad][lPosY], InfoRadar[rad][lPosZ], 0.0, 0.0, InfoRadar[rad][lAngulo]);
		    ObjetoRadar[1][rad] = CreateObject(18880, InfoRadar[rad][lPosX], InfoRadar[rad][lPosY], InfoRadar[rad][lPosZ], 0.0, 0.0, InfoRadar[rad][lAngulo] + 180.0);
			format(strradar, sizeof(strradar),"{FF0000}Radar\nLimite de velocidade: %d KM/H",InfoRadar[rad][lVelocidade]);
			TRadar[rad] = Text3D:Create3DTextLabel(strradar, -1, InfoRadar[rad][lPosX], InfoRadar[rad][lPosY], InfoRadar[rad][lPosZ]+1, 50.0, 0);
		}
	}
	return 1;
}

forward SalvarRadares();
public SalvarRadares()
{
	new
		strpasta[200];

	for(new rad=0;rad<MAX_RADAR; rad++)
	{
		format(strpasta,sizeof(strpasta),PastaRadares,rad);
	    if(DOF2_FileExists(strpasta))
	    {
			DOF2_SetInt(strpasta,"Velocidade",InfoRadar[rad][lVelocidade]);
			DOF2_SetFloat(strpasta,"PosX",InfoRadar[rad][lPosX]);
			DOF2_SetFloat(strpasta,"PosY",InfoRadar[rad][lPosY]);
			DOF2_SetFloat(strpasta,"PosZ",InfoRadar[rad][lPosZ]);
			DOF2_SetFloat(strpasta,"Angulo",InfoRadar[rad][lAngulo]);
		}
	}
	return 1;
}

forward CheckRadar(playerid);
public CheckRadar(playerid)
{
	new
		Float:PlayerSpeedDistance,
		VelocidadeDoPlayer[MAX_PLAYERS];

	GetVehicleVelocity(GetPlayerVehicleID(playerid), PosX, PosY, PosZ);
	PlayerSpeedDistance = floatmul(floatsqroot(floatadd(floatadd(floatpower(PosX, 2), floatpower(PosY, 2)),  floatpower(PosZ, 2))), 170.0);
	new spe = floatround(PlayerSpeedDistance * 1);
	VelocidadeDoPlayer[playerid] = spe;
	for(new rad = 0; rad < MAX_RADAR; rad++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 8.0, InfoRadar[rad][lPosX],InfoRadar[rad][lPosY],InfoRadar[rad][lPosZ]))
		{
			if(VelocidadeDoPlayer[playerid] > InfoRadar[rad][lVelocidade])
			{
				if(gettime() > Variavel[playerid])
				{
     				Variavel[playerid] = (gettime() + 1);
     				format(lString, sizeof(lString),"(Radar) Você ultrapassou o limite de velocidade, o limite é {FFFFFF}%d KM/H{FD0600} e você passou a {FFFFFF}%d KM/H!",InfoRadar[rad][lVelocidade],VelocidadeDoPlayer[playerid]);
					SendClientMessage(playerid, 0xFD0600FF,lString);
					
				}
			}
		}
	}
	return 1;
}

stock IdRadarLivre(playerid)
{
	static
	    rstring[74];
	for(new i; i< MAX_RADAR; i++)
	{
	    format(rstring, sizeof rstring, PastaRadares, i);
	    if(!DOF2_FileExists(rstring))
	    {
			radarid[playerid] = i;
			DOF2_CreateFile(rstring);
			return 1;
		}
	}
	return 0;
}

CMD:moto(playerid, params[]){
	new float:x[10000],float:y[10000],float:z[10000],float:rotation[500];
	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	AddStaticVehicle(522, x[playerid], y[playerid], z[playerid], rotation[playerid], -1, -1);
	
	SendClientMessage(playerid, 0x0000FFFF, "[MOTO] Moto spawnada!");

	return 1;
}