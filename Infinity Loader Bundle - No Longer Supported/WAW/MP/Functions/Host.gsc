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

                if(player.ufo)
                {
                    player notify("stop_ufo");
                    player.ufo = 0;
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

    noBarriers()
    {
        //s/o to Broph and arkg0d for the addresses and values here

        if( isDefined( level.barriersOff ))
        {
            level.barriersOff = undefined;
            WriteInt(0x8213EE2C, 0x41980014);
            WriteInt(0x8213EE38, 0x554A01CA);
        }
        else
        {
            level.barriersOff = true;
            WriteInt(0x8213EE2C, 0x60000000);
            WriteInt(0x8213EE38, 0x554A041C);
        }
    }

    disableBombs()
    {
        bombZones = GetEntArray("bombzone", "targetname");
        shouldDisable = !AreBombsDisabled();

        if(!isDefined(bombZones) || !bombZones.size)
            return;

        for(a = 0; a < bombZones.size; a++)
        {
            if(shouldDisable)
            {
                bombZones[a] trigger_off(); //common_scripts/utility
                level.bombsDisabled = true;
            }

            else
            {
                bombZones[a] trigger_on();  //common_scripts/utility
                level.bombsDisabled = false;
            }
        }
    }

    AreBombsDisabled()
    {
        bombZones = GetEntArray("bombzone", "targetname");
        
        if(!isDefined(bombZones) || !bombZones.size)
            return false;
        
        for(a = 0; a < bombZones.size; a++)
            if(!isDefined(bombZones[a].trigger_off) || !bombZones[a].trigger_off)
                return false;
            
        return true;
    }