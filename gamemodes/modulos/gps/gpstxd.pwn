/*
This file was generated by Nickk's TextDraw editor script
Nickk888 is the author of the NTD script
*/



#include <YSI_Coding\y_hooks>
hook OnPlayerConnect(playerid)
{
	txdGPS_background[playerid] = CreatePlayerTextDraw(playerid, 424.000000, 181.000000, "Distancia:");
	PlayerTextDrawFont(playerid, txdGPS_background[playerid], 1);
	PlayerTextDrawLetterSize(playerid, txdGPS_background[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, txdGPS_background[playerid], 640.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, txdGPS_background[playerid], 1);
	PlayerTextDrawSetShadow(playerid, txdGPS_background[playerid], 0);
	PlayerTextDrawAlignment(playerid, txdGPS_background[playerid], 1);
	PlayerTextDrawColor(playerid, txdGPS_background[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, txdGPS_background[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdGPS_background[playerid], 50);
	PlayerTextDrawUseBox(playerid, txdGPS_background[playerid], 1);
	PlayerTextDrawSetProportional(playerid, txdGPS_background[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdGPS_background[playerid], 0);

	txdGPS_distance[playerid] = CreatePlayerTextDraw(playerid, 525.000000, 181.000000, "500m");
	PlayerTextDrawFont(playerid, txdGPS_distance[playerid], 2);
	PlayerTextDrawLetterSize(playerid, txdGPS_distance[playerid], 0.391665, 2.000000);
	PlayerTextDrawTextSize(playerid, txdGPS_distance[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, txdGPS_distance[playerid], 1);
	PlayerTextDrawSetShadow(playerid, txdGPS_distance[playerid], 3);
	PlayerTextDrawAlignment(playerid, txdGPS_distance[playerid], 1);
	PlayerTextDrawColor(playerid, txdGPS_distance[playerid], 16711935);
	PlayerTextDrawBackgroundColor(playerid, txdGPS_distance[playerid], 255);
	PlayerTextDrawBoxColor(playerid, txdGPS_distance[playerid], 50);
	PlayerTextDrawUseBox(playerid, txdGPS_distance[playerid], 0);
	PlayerTextDrawSetProportional(playerid, txdGPS_distance[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, txdGPS_distance[playerid], 0);

	return 1;
}
#include <YSI_Coding\y_hooks>
hook OnPlayerDisconnect(playerid,reason)
{
	PlayerTextDrawDestroy(playerid, txdGPS_background[playerid]);
	PlayerTextDrawDestroy(playerid, txdGPS_distance[playerid]);
	return 1;
}
