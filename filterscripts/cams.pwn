/*
This system is created by LazzyBoy please do not take it as your own job and hope you enjoy it. :D
*/

#include <a_samp>
#include <streamer>
#include <zcmd>
#include <a_mysql>
#include <sscanf>
new MySQLPipeliner; // Main MySQL pipeline handler

#define SQL_HOST "localhost"
#define SQL_USER "root"
#define SQL_PASS ""
#define SQL_DATA "cams"
#define MAX_CAMS       80
#define CamsLoop(%1) for(new %1 = 0; %1 < MAX_CAMS; %1++)
#define 	function:%1(%2) forward %1(%2); public %1(%2)
#define PlayerLoops(%1) for(new %1 = 0, pMax = MAX_PLAYERS; %1 < pMax; %1++) if(IsPlayerConnected(%1) && !IsPlayerNPC(%1))
#define COLOR_RED 0xCC3300FF
new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;
public OnFilterScriptInit()
{
    ConnectToDatabase();
	LoadCams();
	SetTimer("CheckSpeed", 400, 1);
    return 1;
}

public OnFilterScriptExit()
{
    mysql_close(MySQLPipeliner);
	return 1;
}


main()
{
	print("\n----------------------------------");
	print(" Speed Cam System - LazzyBoy");
	print("----------------------------------\n");
}

public OnPlayerConnect(playerid)
{

Textdraw0 = TextDrawCreate(641.199951, 176.220001, "usebox");
TextDrawLetterSize(Textdraw0, 0.015999, 14.463177);
TextDrawTextSize(Textdraw0, 454.799987, 0.000000);
TextDrawAlignment(Textdraw0, 1);
TextDrawColor(Textdraw0, 0);
TextDrawUseBox(Textdraw0, true);
TextDrawBoxColor(Textdraw0, 102);
TextDrawSetShadow(Textdraw0, 0);
TextDrawSetOutline(Textdraw0, 0);
TextDrawFont(Textdraw0, 0);

Textdraw1 = TextDrawCreate(527.200012, 176.213317, "Ticket");
TextDrawLetterSize(Textdraw1, 0.449999, 1.600000);
TextDrawAlignment(Textdraw1, 1);
TextDrawColor(Textdraw1, -16776961);
TextDrawSetShadow(Textdraw1, 0);
TextDrawSetOutline(Textdraw1, 1);
TextDrawBackgroundColor(Textdraw1, 51);
TextDrawFont(Textdraw1, 1);
TextDrawSetProportional(Textdraw1, 1);

Textdraw2 = TextDrawCreate(463.199981, 198.613372, "Ticket Reason:");
TextDrawLetterSize(Textdraw2, 0.237999, 1.413333);
TextDrawTextSize(Textdraw2, -304.000000, 205.333328);
TextDrawAlignment(Textdraw2, 1);
TextDrawColor(Textdraw2, -1);
TextDrawSetShadow(Textdraw2, 0);
TextDrawSetOutline(Textdraw2, 1);
TextDrawBackgroundColor(Textdraw2, 51);
TextDrawFont(Textdraw2, 1);
TextDrawSetProportional(Textdraw2, 1);
return 1;
}

enum sCams
{
	sObject,
	Text3D:sLabel,
	Float:sX,
	Float:sY,
	Float:sZ,
	sSpeed,
	sArea,
	sVW,
	bool:sActive,
}
new CamInfos[MAX_CAMS][sCams];

stock ConnectToDatabase()
{
	printf("[ConnectToMainPipeline:] Connecting to %s...", SQL_DATA);
	mysql_log(LOG_ERROR | LOG_WARNING | LOG_DEBUG);

	MySQLPipeliner = mysql_connect(SQL_HOST, SQL_USER, SQL_DATA, SQL_PASS, 3306, true, 2);
	if(mysql_errno(MySQLPipeliner) != 0)
	{
		printf("[MySQL] (MySQLPipeline) Fatal Error! Could not connect to MySQL: Host %s - DB: %s - User: %s", SQL_HOST, SQL_DATA, SQL_USER);
		print("[MySQL] Note: Make sure that you have provided the correct connection credentials.");
		printf("[MySQL] Error number: %d", mysql_errno(MySQLPipeliner));
		SendRconCommand("exit");
	}
	return 1;
}
stock GetVehicleSpeed(playerid)
{
    new Float:Pos[4];
    GetVehicleVelocity(GetPlayerVehicleID(playerid), Pos[0], Pos[1], Pos[2]);
    Pos[3] = floatsqroot(floatpower(floatabs(Pos[0]), 2) + floatpower(floatabs(Pos[1]), 2) + floatpower(floatabs(Pos[2]), 2)) * 181.5;
    return floatround(Pos[3]);
}
forward CheckSpeed(playerid);
public CheckSpeed(playerid)
{
for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(IsPlayerInAnyVehicle(i))
			{
  new vspeed[25];
  format(vspeed, sizeof(vspeed), "~w~Velocidade: ~y~%d ~g~KM/H", GetSpeed(i));
  GameTextForPlayer(i,vspeed,3000,4);
		   }
		}
	}
CamsLoop(p)
	{

	   if(IsPlayerInRangeOfPoint(playerid,30,CamInfos[p][sX],CamInfos[p][sY],CamInfos[p][sZ]))
	   {
		  new speed = GetSpeed(playerid);
		  if(speed > CamInfos[p][sSpeed] )
		  {
		  new string[128];
		  format(string,sizeof(string),"~y~Razao:~w~Excesso de velocidade~n~~y~Amount:~w~%d$~n~~y~Velocidade:~w~%d",speed*2,speed);
		  TextDrawSetString(Textdraw2,string);
		  TextDrawShowForPlayer(playerid,Textdraw2);
		  TextDrawShowForPlayer(playerid,Textdraw1);
		  TextDrawShowForPlayer(playerid,Textdraw0);
		  SetTimer("HideTD", 40000, 0);
		  return 1;
		  }

	   }
	}
return 1;
}
function:HideTD(playerid,params[])
{
  TextDrawHideForPlayer(playerid,Textdraw0);
  TextDrawHideForPlayer(playerid,Textdraw1);
  TextDrawHideForPlayer(playerid,Textdraw2);
  return 1;
}
function: LoadCams()
{
	mysql_tquery(MySQLPipeliner, "SELECT * FROM `CamInfo`", "OnLoadCams", "d", 1);
	return 1;
}
function:OnReloadCams(speedcamid)
{
	new iQuery[128];
	mysql_format(MySQLPipeliner, iQuery, sizeof(iQuery), "SELECT * FROM `CamInfo` WHERE `ID` = %d LIMIT 1", speedcamid);
    mysql_tquery(MySQLPipeliner, iQuery, "LoadCams", "d", 0);
	return 1;
}
function:OnLoadCams(FromStart)
{
	if(FromStart == 1)
	{
		CamsLoop(b) CamInfos[b][sActive] = false;
	}
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeliner);
	if(rows)
	{
		for(new c = 0; c < rows; c++)
		{
			new iGet[150];
			cache_get_field_content(c, "ID", iGet, MySQLPipeliner); new CamID = strval(iGet);
			cache_get_field_content(c, "sLimits", iGet,MySQLPipeliner); CamInfos[CamID][sSpeed] = strval(iGet);
			cache_get_field_content(c, "VirtualWorld", iGet,MySQLPipeliner); CamInfos[CamID][sVW] = strval(iGet);
			cache_get_field_content(c, "X", iGet, MySQLPipeliner); CamInfos[CamID][sX] = floatstr(iGet);
			cache_get_field_content(c, "Y", iGet, MySQLPipeliner); CamInfos[CamID][sY] = floatstr(iGet);
			cache_get_field_content(c, "Z", iGet, MySQLPipeliner); CamInfos[CamID][sZ] = floatstr(iGet);
            CamInfos[CamID][sObject] = CreateDynamicObject(18880,CamInfos[CamID][sX],CamInfos[CamID][sY],CamInfos[CamID][sZ]-0.5 ,0.00, 0.00, 0.00);
            new string[50];
            format(string,sizeof(string),"Speed Limit : %d",CamInfos[CamID][sSpeed]);
            CamInfos[CamID][sLabel] = CreateDynamic3DTextLabel(string, -1, CamInfos[CamID][sX], CamInfos[CamID][sY], CamInfos[CamID][sZ]+0.3, 10.0);
            CamInfos[CamID][sArea] = CreateDynamicCircle(CamInfos[CamID][sX], CamInfos[CamID][sY], 2.0);
		    CamInfos[CamID][sActive] = true;
		}
	}
	return 1;
}
stock SaveCams(cid)
{
	new iQuery[1400], iFormat[175];
	strcat(iQuery, "UPDATE `CamInfo` SET ");
	mysql_format(MySQLPipeliner, iFormat, sizeof(iFormat), "`sLimits` = '%d', ", CamInfos[cid][sSpeed]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeliner, iFormat, sizeof(iFormat), "`X` = '%f', ",CamInfos[cid][sX]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeliner, iFormat, sizeof(iFormat), "`Y` = '%f', ",CamInfos[cid][sY]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeliner, iFormat, sizeof(iFormat), "`Z` = '%f', ",CamInfos[cid][sZ]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeliner, iFormat, sizeof(iFormat), "`VirtualWorld` = '%d', ", CamInfos[cid][sVW]);
	strcat(iQuery, iFormat);
	mysql_tquery(MySQLPipeliner, iQuery);
	return 1;
}
stock GetPlayerDistanceToPointEx(playerid,Float:sx,Float:sy,Float:sz) //By Sacky
{
	new Float:x1,Float:y1,Float:z1;
	new Float:tmpdis;
	GetPlayerPos(playerid,x1,y1,z1);
	tmpdis = floatsqroot(floatpower(floatabs(floatsub(sx,x1)),2)+floatpower(floatabs(floatsub(sy,y1)),2)+floatpower(floatabs(floatsub(sz,z1)),2));
	return floatround(tmpdis);
}
stock GetClosestCam( playerid )
{
	new cl_ID = -1, Float:cl_DIST = 9999.0;
	CamsLoop(i)
	{
	    if(CamInfos[i][sActive] != true) continue;
		if( GetPlayerDistanceToPointEx(playerid, CamInfos[i][sX], CamInfos[i][sY], CamInfos[i][sZ]) < cl_DIST )
		{
		    cl_ID = i;
		    cl_DIST = GetPlayerDistanceToPointEx(playerid, CamInfos[i][sX], CamInfos[i][sY], CamInfos[i][sZ]);
		}
	}
	return cl_ID;
}
stock GetUnusedSpeedCam()
{
	CamsLoop(b)
	{
	    if(CamInfos[b][sActive] != true) return b;
	}
	return -1;
}
#define MPH_KMH 1.609344
CMD:deletecam(playerid,params[])
{
        new camid = GetClosestCam(playerid);
		if(camid == -1) return SendClientMessage(playerid,-1, "No Cams found!");
		if(GetPlayerDistanceToPointEx(playerid, CamInfos[camid][sX], CamInfos[camid][sY], CamInfos[camid][sZ]) < 8)
		{
		    DeleteCam(camid);
		}
		else return SendClientMessage(playerid,COLOR_RED, "You are not close enough to an Cam right now!");
		return 1;
}
stock DeleteCam(camid)
{
	new iQuery[182];
	mysql_format(MySQLPipeliner, iQuery, sizeof(iQuery), "DELETE FROM `CamInfo` WHERE `ID` = %d", camid);
	mysql_tquery(MySQLPipeliner, iQuery);

	DestroyDynamicObject(CamInfos[camid][sObject]);
    DestroyDynamic3DTextLabel(CamInfos[camid][sLabel]);
    DestroyDynamicObject(CamInfos[camid][sObject]);
    DestroyDynamic3DTextLabel(CamInfos[camid][sLabel]);

    CamInfos[camid][sX] = 0.0;
    CamInfos[camid][sSpeed] = -1;
    CamInfos[camid][sY] = 0.0;
    CamInfos[camid][sZ] = 0.0;
    CamInfos[camid][sVW] = 0;
    CamInfos[camid][sActive] = false;
	return 1;
}
stock ReloadCams(camid, bool:tosave = true)
{
	if(tosave == true) SaveCams(camid);
	SetTimerEx("OnReloadCams", 500, 0, "i", camid);
}


stock CreateSpeedCam(camSpeed, Float:camX, Float:camY, Float:camZ,VirtualWorld)
{
	new camid = GetUnusedSpeedCam();
	if(camid == -1) return printf("[ERROR] - Maximum Speed Cams limit has been reached. %d/%d", camid, MAX_CAMS);
	new iQuery[250];
	mysql_format(MySQLPipeliner, iQuery, sizeof(iQuery), "INSERT INTO `CamInfo` (`ID`,`sLimits`,`X`, `Y`, `Z`,`VirtualWorld`) VALUES (%d, %d, %f, %f, %f, %d)", camid,camSpeed,camX,camY,camZ,VirtualWorld);
	mysql_tquery(MySQLPipeliner, iQuery);
	ReloadCams(camid, true);
	return 1;
}
CMD:createcam(playerid,params[])
{
        new cam = GetUnusedSpeedCam(), speed;
		if(cam == -1) return SendClientMessage(playerid,COLOR_RED, "The limit has been reached");
		if( sscanf ( params, "d",speed)) return SendClientMessage(playerid, -1,"[Speed Limit]");
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		CreateSpeedCam(speed, x, y, z,GetPlayerVirtualWorld(playerid));
		CamInfos[cam][sSpeed] = speed;
		return 1;
}
CMD:createcar(playerid,params[])
{
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	AddStaticVehicle(411,x,y,z,356.2596,7,3);
	return 1;
}
stock IsPlayerNearCamSpeed(playerid, extra = 0)
{
	new temp = -1, iSize;
	if(extra) iSize = 80;
	else iSize = 2;
	CamsLoop(b)
	{
	    if(CamInfos[b][sActive] != true) continue;
		if(GetPlayerVirtualWorld(playerid) != CamInfos[b][sVW]) continue;
	    if(IsPlayerInRangeOfPoint(playerid, iSize, CamInfos[b][sX], CamInfos[b][sY], CamInfos[b][sZ])) return b;
	}
	return temp;
}
stock GetSpeed(playerid)
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid))
    GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
    else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 178.8617875;
    return floatround(ST[3]);
}
CMD:createdcams(playerid , params[])
{
   CamsLoop(p)
   {
   if(CamInfos[p][sActive] != true) continue;
   new string[30];
   format(string,sizeof(string),"Speed Cam ID - %d",p);
   SendClientMessage(playerid,-1,string);
   }
   return 1;
}
