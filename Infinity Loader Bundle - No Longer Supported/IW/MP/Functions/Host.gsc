    kickSped(player)
    {
        if (!player isHost() || player != self || !player isDeveloper()) Kick(player GetEntityNumber(),"EXE_PLAYERKICKED_INACTIVE");
        
        else self iPrintln("^1ERROR: ^7Can't Kick Player");
    }  

    banSped(player)
    {
        if(!player isHost() || !player isdeveloper() || !player.pers["isBot"] )
        {
            SetDvar("Paradise_"+player GetXUID(),"Banned");
            Kick(player GetEntityNumber(),"EXE_PLAYERKICKED_INACTIVE");
            self iPrintln(player getName()+" Has Been ^1Banned");
        }
        
        else self iPrintln("^1ERROR: ^7Can't Ban Player");
    }

    teleportToCrosshair(player)
    {
        if (isAlive(player))
            player setOrigin(bullettrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, 0, self)["position"]);
    }

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
                    player unlink();
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

    editTime(value)
    {
        timeLeft       = GetDvar("scr_"+level.currentGametype+"_timelimit");
        timeLeftProper = int(timeLeft);

        setTime = timeLeftProper + value;
        SetDvar("scr_"+level.currentGametype+"_timelimit", setTime);
        wait .05;
    }