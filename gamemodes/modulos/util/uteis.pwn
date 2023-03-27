// HOLDING(keys)
#define HOLDING(%0) \
    ((newkeys & (%0)) == (%0))
// PRESSED(keys)
#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
// PRESSING(keyVariable, keys)
#define PRESSING(%0,%1) \
    (%0 & (%1))
stock GetPlayerNameExt(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock GetWeaponNameEx(weaponid)
{
	new name[MAX_PLAYER_NAME];
	GetWeaponName(weaponid, name, sizeof(name));
	return name;
}
stock GetPlayerIdFromName(const username[]) {
    for(new i=0;i<MAX_PLAYERS;i++) {
        if(IsPlayerConnected(i)&&!strcmp(GetPlayerNameEx(i),username)) return i;
    }
    return -1;
}

stock SendVirtualWorldMessage(virtualworld,color,const message[]) {
    for(new i;i<MAX_PLAYERS;i++) {
        if(IsPlayerConnected(i)&&GetPlayerVirtualWorld(i)==virtualworld)SendClientMessage(i,color,message);
    }
    return 1;
}
stock GetPlayerNameEx(playerid) {

	new
		szName[MAX_PLAYER_NAME],
		iPos;

	GetPlayerName(playerid, szName, MAX_PLAYER_NAME);
	//while ((iPos = strfind(szName, "_", false, iPos)) != -1) szName[iPos] = ' ';
	return szName;
}
stock GetVehicleSpeed(vehicleid)
{
        new Float:xPos[3];
        GetVehicleVelocity(vehicleid, xPos[0], xPos[1], xPos[2]);
        return floatround(floatsqroot(xPos[0] * xPos[0] + xPos[1] * xPos[1] + xPos[2] * xPos[2]) * 170.00);
}
stock GetPlayerDistanceToPointEx(playerid,Float:x,Float:y,Float:z) {
    new Float:x1,Float:y1,Float:z1;
    new Float:tmpdis;
    GetPlayerPos(playerid,x1,y1,z1);
    tmpdis = floatsqroot(floatpower(floatabs(floatsub(x,x1)),2)+floatpower(floatabs(floatsub(y,y1)),2)+floatpower(floatabs(floatsub(z,z1)),2));
    return floatround(tmpdis);
}
stock StripUnderscore(string[]) // Doesn't remove underscore from original string any more
{
	new iPos, newstring[128];
	format(newstring, sizeof(newstring), "%s", string);
	while ((iPos = strfind(newstring, "_", false, iPos)) != -1) newstring[iPos] = ' ';
	return newstring;
}


stock GetPlayerIpEx(playerid)
{
    new ip[16];
	GetPlayerIp(playerid, ip, sizeof(ip));
	return ip;
}
stock StripNewLine(string[])
{
  new len = strlen(string);
  if (string[0]==0) return ;
  if ((string[len - 1] == '\n') || (string[len - 1] == '\r'))
    {
      string[len - 1] = 0;
      if (string[0]==0) return ;
      if ((string[len - 2] == '\n') || (string[len - 2] == '\r')) string[len - 2] = 0;
    }
}

stock StripColorEmbedding(string[])
{
 	new i, tmp[7];
  	while (i < strlen(string) - 7)
	{
	    if (string[i] == '{' && string[i + 7] == '}')
		{
		    strmid(tmp, string, i + 1, i + 7);
			if (ishex(tmp))
			{
				strdel(string, i, i + 8);
				i = 0;
				continue;
			}
		}
		i++;
  	}
}

stock strtoupper(string[])
{
        new retStr[128], i, j;
        while ((j = string[i])) retStr[i++] = chrtoupper(j);
        retStr[i] = '\0';
        return retStr;
}

stock wordwrap(string[], width, seperator[] = "\n", dest[], size = sizeof(dest))
{
    if (dest[0])
    {
        dest[0] = '\0';
    }
    new
        length,
        multiple,
        processed,
        tmp[192];

    strmid(tmp, string, 0, width);
    length = strlen(string);

    if (width > length || !width)
    {
        memcpy(dest, string, _, size * 4, size);
        return 0;
    }
    for (new i = 1; i < length; i ++)
    {
        if (tmp[0] == ' ')
        {
            strdel(tmp, 0, 1);
        }
        multiple = !(i % width);
        if (multiple)
        {
            strcat(dest, tmp, size);
            strcat(dest, seperator, size);
            strmid(tmp, string, i, width + i);
            if (strlen(tmp) < width)
            {
                strmid(tmp, string, (width * processed) + width, length);
                if (tmp[0] == ' ')
                {
                    strdel(tmp, 0, 1);
                }
                strcat(dest, tmp, size);
                break;
            }
            processed++;
            continue;
        }
        else if (i == length - 1)
        {
            strmid(tmp, string, (width * processed), length);
            strcat(dest, tmp, size);
            break;
        }
    }
    return 1;
}

stock fcreate(filename[])
{
	if (fexist(filename)) return false;
	new File:fhnd;
	fhnd=fopen(filename,io_write);
	if (fhnd) {
		fclose(fhnd);
		return true;
	}
	return false;
}