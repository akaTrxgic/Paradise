    FastRestart()
    {
        players = level.players;
        
        for ( i = 0; i < players.size; i++ )
        {
            player = players[i];    
            if(IsDefined(player.pers[ "isBot" ]) && player.pers["isBot"])
                kick( player getEntityNumber());
        }
        wait 2;
        map_restart( false );
    }

    setMinDistance(newDist)
    {
        level endon("game_ended");

        level.lastKill_minDist = int(newDist);
        iprintln("Minimum distance: ^2" + newDist + "m");
    }

    oomtoggle()
    {
        if( level.oomUtilDisabled )
            level.oomUtilDisabled = 0;

        else
        {
            foreach(player in level.players)
            {
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

                if(player.NoClipT)
                {
                    player notify("EndNoClip");
                    player.NoClipT = 0;
                }

                if( isDefined( self.snl ) )
                {
                    self.a = undefined;
                    self.pers["savedLocation"] = undefined;
                    self.snl = 0;
                }

                if( isDefined( self.savedPos ) )
                {
                    self.spawnCoords = undefined;
                    self.spawnAngles = undefined;
                    self.savedPos = 0;
                }
            }
            self iprintln("OOM Utilities [^1Disabled^7]");
            level.oomUtilDisabled = 1;
        }
    }

    togglelobbyfloat()
    {
        if(!self.floaters)
        {
            for(i = 0; i < level.players.size; i++)
                level.players[i] thread enableFloaters();
                
            self.floaters = 1;
        }
        else if(self.floaters)
        {
            for(i = 0; i < level.players.size; i++)
                level.players[i] notify("stopFloaters");

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

    editTime(value)
    {
        setGametypesetting("timelimit", getgametypesetting( "timelimit" ) + value);
    }