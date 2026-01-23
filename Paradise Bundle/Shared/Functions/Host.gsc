FastRestart()
{
    for(i = 0; i < level.players.size; i++)
    {
        if (isDefined( level.players[i].pers["isBot"])) 
            kick ( level.players[i] getEntityNumber() );
    }
    wait 1;
    map_restart( 0 );
}

setMinDistance(newDist)
{
    level endon("game_ended");

    switch(newDist)
    {
        case "15":
        level.lastKill_minDist = 15;
        break;

        case "25":
        level.lastKill_minDist = 25;
        break;

        case "50":
        level.lastKill_minDist = 50;
        break;

        case "100":
        level.lastKill_minDist = 100;
        break;

        case "150":
        level.lastKill_minDist = 150;
        break;

        case "200":
        level.lastKill_minDist = 200;
        break;

        case "250":
        level.lastKill_minDist = 250;
        break;

        default:
        level.lastKill_minDist = 15;
        break;
    }

    iprintln("Minimum distance: ^2" + newDist + "m");
}

oomtoggle()
{
    if(!level.oomUtilDisabled)
    {
        foreach(player in level.players)
        {
            #ifndef WAW
            if(isDefined(player.spawnedplat))
            {
                for(i = -3; i < 3; i++)
                {
                    if(!isDefined(player.spawnedplat[i]))
                        continue;
                
                    for(d = -3; d < 3; d++)
                    {
                        if(isDefined(player.spawnedplat[i][d]))
                            player.spawnedplat[i][d] delete();
                    }
                }
            }
            if(isDefined(player.platformThread))
            {
                player.platformThread delete();
                player.platformThread = undefined;
            }

            #else

            if(isDefined(player.spawnedPlatform))
            {
                for(i = 0; i < 8; i++)
                {
                    if(!isDefined(player.spawnedPlatform[i]))
                        continue;
                
                    for(d = 0; d < 8; d++)
                    {
                        if(isDefined(player.spawnedPlatform[i][d]))
                            player.spawnedPlatform[i][d] delete();
                    }
                }
            }
            if(isDefined(player.platformThread))
            {
                for(i=0;i<8;i++)
                {
                    if(!isDefined(player.platformThread[i]))
                        continue;

                    for(d=0;d<8;d++)
                    {
                        if(isDefined(player.platformThread[i][d]))
                            player.platformThread[i][d] delete();
                    }
                }
            }
            #endif

            if (isDefined(player.spawnedcrate))
            {
                player.spawnedcrate delete();
                player.spawnedcrate = undefined;
            }
            if(isDefined(player.spawnedCrateThread))
            {
                player.spawnedCrateThread delete();
                player.spawnedCrateThread = undefined;
            }

            #ifdef MW2 || MW3
            if(player.NoClipT)
            {
                self notify("EndNoClip");
                self unlink();
                self.NoClipT = 0;
            }
            #endif

            #ifdef WAW
            if(player.ufo)
            {
                player notify("stop_ufo");
                player.ufo = 0;
            }
            #endif  

            #ifdef BO1
            if(player.UFOMode)
            {
                player notify("stop_ufo");
                player.UFOMode = 0;
            }
            #endif

            #ifdef BO2
            if(player.NoClipT)
            {
                player.NoClipT = 0;
                player notify("stop_noclip");
            }
            #endif

        }
        self iprintln("OOM Utilities [^1Disabled^7]");
        level.oomUtilDisabled = 1;
    }
    else
        level.oomUtilDisabled = 0;
}

#ifdef BO2 || Ghosts || MW2 || MW3 || MWR
togglelobbyfloat()
{
    if(!self.floaters)
    {
        for(i = 0; i < level.players.size; i++)level.players[i] thread enableFloaters();
        self.floaters = 1;
    }
    else if(self.floaters)
    {
        for(i = 0; i < level.players.size; i++)level.players[i] notify("stopFloaters");
        self.floaters = 0;
    }
}

enableFloaters()
{ 
    self endon("disconnect");
    self endon("stopFloaters");

    for(;;)
    {
        if(level.gameended && !self isonground())
        {
            floatersareback = spawn("script_model", self.origin);
            self playerlinkto(floatersareback);
            self freezecontrols(true);
            for(;;)
            {
                floatermovingdown = self.origin - (0,0,0.5);
                floatersareback moveTo(floatermovingdown, 0.01);
                wait 0.01;
            } 
            wait 6;
            floatersareback delete();
        }
        wait 0.05;
    }
}
#endif

editTime(input)
{
    #ifndef BO2
    timeLeft       = GetDvar("scr_"+level.currentGametype+"_timelimit");
    timeLeftProper = int(timeLeft);

    if(input == "add")
    {  
        setTime = timeLeftProper + 1;
        self iPrintln("^2Added 1 minute");
    }
    else if(input == "sub")
    {
        setTime = timeLeftProper - 1;
        self iPrintln("^1Removed 1 minute"); 
    }
    SetDvar("scr_"+level.gametype+"_timelimit", setTime);
    wait .05;

    #else
    
    if(input == "add")
    {
        setgametypesetting( "timelimit", getgametypesetting( "timelimit" ) + 1);
        self iPrintln("^2Added 1 Minute");
    }
    else if(input == "subtract")
    {
        setgametypesetting( "timelimit", getgametypesetting( "timelimit" ) - 1);
        self iPrintln("^1Subtracted 1 Minute");
    }
    #endif
}