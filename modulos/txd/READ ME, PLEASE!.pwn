/*
        Name-Culture rules for textdraws
        Starting at 18/03/2023 all  new textdraws for the server should respect the following rules:
        The textdraw file should handle their creation onplayerconnect and destroyment onplayerdisconnect
        They should the provide following interface for developers:
        Where NAME is the name of the textdraw:
        ShowPlayerTxdNAME(playerid),
        SetPlayerTxdNAMEText(playerid,const string[]),
        SetPlayerTxdNAMEProgress(playerid,newprogress),
        HidePlayerTxdNAME(playerid)
                                            */