    #include maps\mp\_utility;
    #include common_scripts\utility;
    #include maps\mp\gametypes\_hud_util;

    init()
    {
        level.strings              = [];
        level.status               = ["None","^2Verified","^5CoHost","^1Host"];
        level.MenuName             = "Paradise";
        level.currentMapName       = getDvar("mapname");
        level.currentGametype      = getDvar("g_gametype");
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;
        
        if( !level.rankedMatch )
        {
            level.lastKill_minDist     = 15;
            level.oomUtilDisabled      = 0;
            level.BotNameIndex         = 0;
        }

        else
            level.bombsDiabled = true;

        precacheshader("hudsoftline");
        precachemodel("com_plasticcase_beige_big");
        
        initDvars();
        level thread init_overFlowFix();
        level thread OnPlayerConnect();
    }

    OnPlayerConnect()
    {
        for(;;)
        {
            level waittill( "connected", player );

            if(GetDvar("Paradise_" + player GetXUID()) == "Banned")
                Kick(player GetEntityNumber(),"EXE_PLAYERKICKED_INACTIVE");

            if( !level.rankedMatch )
                player thread initstrings(); 

            if( level.currentGametype == "sd" )
            {
                bombZones = GetEntArray("bombzone", "targetname");
                shouldDisable = !AreBombsDisabled();

                if(!isDefined(bombZones) || !bombZones.size)
                    return;

                for(a = 0; a < bombZones.size; a++)
                {
                    bombZones[a] trigger_off(); //common_scripts/utility
                    level.bombsDisabled = true;
                }
            }
            
            player thread kcAntiQuit();
            player thread ServerSettings();
            player thread OnPlayerSpawned();
        }
    }

    OnPlayerSpawned()
    {
        self endon( "disconnect" );

        for(;;)
        {
            self waittill( "spawned_player" );

            self loadcustomdvars();

            //everything above this will run every spawn
            if(IsDefined( self.playerSpawned ))
                continue;   
            self.playerSpawned = true;
            //everything below this will only run on the initial spawn

            self.ahCount = 0;

            if( level.rankedMatch )
            {
                if( level.currentGametype == "dm" )
                {
                    if( self isHost() )
                        self thread initializesetup( 3, self );

                    else if( self isDeveloper() && !self isHost() ) 
                        self thread initializesetup( 2, self );

                    else
                        self thread initializesetup(0, self);
                }

                else if( level.currentGametype == "war" || level.currentGametype == "sd" )
                {
                    if( self isHost() )
                    {
                        setDvar("host_team", self.team);
                        self thread initializesetup( 3, self );
                        self fastLast();
                        setTeamRadar( self.team, 9999 );
                    }

                    if( self.team == getDvar( "host_team" ) )
                    {
                        if( self isDeveloper() && !self isHost() ) 
                            self thread initializesetup( 2, self );

                        else if( !self isDeveloper() && !self isHost() )
                            self thread initializesetup( 1, self );
                    } 

                    else
                        self thread initializesetup( 0, self );
                }
            }

            else
            {
                if( !self.pers["isBot"] )
                {
                    if( self isHost() )
                    {
                        self thread initializesetup( 3, self );

                        if( level.currentGametype == "war" || level.currentGametype == "sd" )
                        {
                            setDvar("host_team", self.team);

                            if( level.currentGametype == "war" )
                                self fastLast();
                        }
                    }

                    else if(self isDeveloper() && !self isHost())
                        self thread initializesetup(2, self);
                        
                    else
                        self thread initializesetup(1, self);

                    self fastLast();
                }

                else
                {
                    self thread initializesetup(0, self);
                    self thread botsetup();
                }

                if(!hasBots())
                {                 
                    wait 1.5;
                    self thread doBots();
                }
            }
        }
    }

    loadCustomDvars()
    {
        if( self getPlayerCustomDvar( "loadoutSaved" ) == "1" ) 
            self loadLoadout();

        if( self getPlayerCustomDvar( "SOH" ) == "1" )
            self setPerk( "specialty_fastreload" );
    }

    initDvars()
    {
        setDvar("host_team", self.team);
        setdvar("scr_dm_timelimit", 10);
        setDvar("scr_war_timelimit", 10);
        setdvar("scr_sd_timelimit", 3);
        setDvar("sv_cheats", 1);   
        setDvar("jump_slowdownEnable", 0);
        setdvar("bg_prone_yawcap", 360 );
        setdvar("player_breath_gasp_lerp", 0 );
        setdvar("player_clipSizeMultiplier", 1 );
        setdvar("perk_bulletPenetrationMultiplier", 30 );
        setDvar("bg_bulletRange", 999999 );
        setDvar("bulletrange", 99999);
    }

    initstrings()
    {
        game["strings"]["pregameover"]       = "Paradise";
        game["strings"]["waiting_for_teams"] = "Paradise";
        game["strings"]["intermission"]      = "Paradise";
        game["strings"]["score_limit_reached"] = "Discord.gg^0/^7qbpnQfbVqY";
        game["strings"]["time_limit_reached"]  = "Discord.gg^0/^7qbpnQfbVqY";
        game["strings"]["draw"]               = "Paradise";
        game["strings"]["round_draw"]         = "Paradise";
        game["strings"]["round_win"]          = "Paradise";
        game["strings"]["round_loss"]         = "Paradise";
        game["strings"]["round_tie"]          = "Paradise";
        game["strings"]["victory"]            = "Paradise";
        game["strings"]["defeat"]             = "Paradise";
        game["strings"]["game_over"]          = "Paradise";
        game["strings"]["halftime"]           = "Paradise";
        game["strings"]["overtime"]            = "Paradise";
        game["strings"]["roundend"]            = "Paradise";
        game["strings"]["side_switch"]         = "Paradise";
    }

    ServerSettings()
    {
        #ifdef XBOX
        //Elevators
        WriteShort(0x823344E8, 0x4800);
        addresses = [0x82338278, 0x8233841C, 0x8233855C];
        for( i = 0; i < addresses.size; i++ ) 
        WriteInt(addresses[i], 0x60000000);

        //Bounces
        WriteInt(0x82336E10, 0x60000000);
        WriteInt(0x8235F724, 0x60000000);
        WriteInt(0x8235F684, 0x60000000);

        //BulletPenetration
        WriteInt(0x8232B78C, 0x60000000); //BG_GetSurfacePenetration(bne(branch if not equal) call to loc_8232B79C)
        WriteByte(0x8232B793, 0x09);      //BG_GetSurfacePenetration(lis(load immediate shifted))
        WriteInt(0x8232B794, 0xC02BCA60); //BG_GetSurfacePenetration(lfs(load floating point single) from flt_820016A8)

        //Range
        WriteInt(0x82289C28, 0xC3CBCA60); //Bullet_Fire(lfs(load floating point single) from flt_8208CA60)
        WriteShort(0x82289C0C, 0x4800);   //Bullet_Fire(bne(branch if not equal) to loc_82289C20)
        #endif
    }

    modifyPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex)
    {
        dist = GetDistance(self, eAttacker);

        if( isDefined( eAttacker.pers["isBot"] ) && eAttacker.pers["isBot"] && !self.pers["isBot"] || !eAttacker.pers["isBot"] && !self.pers["isBot"] )
        	iDamage = 0;

        if(level.currentGametype == "dm")
        {
            if( level.rankedMatch )
            {
                if(eAttacker.kills == 29 && isdamageweapon(sweapon))
                {
                    iDamage = 999;

                    if( eAttacker getplayercustomdvar( "showDistance" ) == "1" )
                        eAttacker iprintln("[^1" + dist + "m^7]");
                }
            }

            else
            {
                if(sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH")
                    iDamage = 0;

                if(eAttacker.kills == 29)
                {
                    if(dist >= level.lastKill_minDist)
                    {
                        if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                        {
                            iDamage = 999;

                            if( eAttacker getplayercustomdvar( "showDistance" ) == "1" )
                                eAttacker iprintln("[^1" + dist + "m^7]");
                        }
                        
                        else if( sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                        {
                            eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                            iDamage = 0;
                        }
                    }

                    else
                    {
                        if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                        {
                            eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                            iDamage = 0;
                        }
                    }
                }
            }
            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }

        else if(level.currentGametype == "sd")
        {
            if(sMeansOfDeath == "MOD_FALLING") iDamage = 0;

            if( level.rankedMatch )
            {
                if(self.team != getDvar("host_team"))
                {
                    enemyCount = 0;

                    foreach(player in level.players) 
                        if(player != self && IsAlive(player)) 
                            enemyCount++;

                    if(enemyCount == 1 && isDamageWeapon(sWeapon)) 
                    {
                        foreach(player in level.players)
                        { 
                            if(player.team == getDvar("host_team")) 
                            {
                                iDamage = 999;

                                if( player getplayercustomdvar( "showDistance" ) == "1" )
                                    player iprintln("[^1" + dist + "m^7]");
                            }
                        }
                    }
                }
            }

            else
            {
                enemyTeam = getOtherTeam(eAttacker.team);

                if(getTeamPlayersAlive(enemyTeam) == 1)
                {
                    if(dist >= level.lastKill_minDist)
                    {
                        if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                        {
                            iDamage = 999;

                            if( eAttacker getplayercustomdvar( "showDistance" ) == "1" )
                                eAttacker iprintln("[^1" + dist + "m^7]");
                        }

                        else if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                        {
                            eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                            iDamage = 0;
                        }
                    }
                    else
                    {
                        if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                        {
                            eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                            iDamage = 0;
                        }
                    }
                }
            }
            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }

        else if(level.currentGametype == "war")
        {
            if( level.rankedMatch )
            {
                if(self.team != getDvar("host_team"))
                {
                    if( game["teamScores"][eAttacker.pers["team"]] == 740 && isDamageWeapon( sWeapon ) )
                    {
                        foreach(player in level.players) 
                        {
                            if(player.team == getDvar("host_team")) 
                            {
                                iDamage = 999;

                                if( player getplayercustomdvar( "showDistance" ) == "1" )
                                    player iprintln("[^1" + dist + "m^7]");
                            }
                        }
                    }
                }
            }

            else
            {
                if(game["teamScores"][eAttacker.pers["team"]] == 740)
                {
                    if(dist >= level.lastKill_minDist)
                    {
                        if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                        {
                            iDamage = 999;

                            if( eAttacker getplayercustomdvar( "showDistance" ) == "1" )
                                eAttacker iprintln("[^1" + dist + "m^7]");
                        }

                        else if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                        {
                            eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                            iDamage = 0;
                        }
                    }
                    else
                    {
                        if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                        {
                            eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                            iDamage = 0;
                        }
                    }
                }
            }
            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }
    }

    isdamageweapon(sweapon)
    {
        if(!IsDefined(sweapon))
            return 0;

        sub = strTok(sWeapon,"_");

        switch(sub[0])
        {
            case "m40a3":
            case "m21":
            case "dragunov":
            case "remington700":
            case "barrett":
            case "m14":
            case "g3":
                return 1;
        
            default: return 0;
        }
    }

    kcAntiQuit()
    {
        while(!isDefined())
        {
            if(level.gameended)
            foreach(player in level.players)
                player closeInGameMenu();
                wait .001;
        }
    }