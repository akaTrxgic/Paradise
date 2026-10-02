    #include maps\mp\_utility;
    #include common_scripts\utility;
    #include maps\mp\gametypes\_hud_util;
    #include maps\mp\gametypes\_hud_message;
    #include maps\mp\killstreaks\_killstreaks;
    #include maps\mp\gametypes\_globallogic;

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
            precachemodel("mp_supplydrop_ally");
        }

        else
            level.bombsDisabled = 0;

        precacheshader("hudsoftline");

        initDvars();
        lowerBarriers();
        greencrateLocation1();
        level thread onPlayerConnect();
    }

    onPlayerConnect()
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
            
            player thread kcantiquit();
            player thread ServerSettings();
            player thread OnPlayerSpawned();
        }
    }

    onPlayerSpawned()
    {
        self endon( "disconnect" );

        for(;;)
        {
            self waittill( "spawned_player" );

            self thread botsgetknives();

            if( self getPlayerCustomDvar( "loadoutSaved" ) == "1" ) 
                self loadLoadout();

            if( self getPlayerCustomDvar( "SOH" ) == "1" )
            {
                self setPerk( "specialty_fastads" );
                self setPerk( "specialty_fastreload" );  
            }

            if( !isDefined( self GetPlayerCustomDvar( "menuInst" ) ) )
                self SetPlayerCustomDvar( "menuInst", "1" );

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

                else if( level.currentGametype == "tdm" || level.currentGametype == "sd" )
                {
                    if( self isHost() )
                    {
                        setDvar("host_team", self.team);
                        self thread initializesetup( 3, self );
                        self fastLast();
                        setTeamRadar();
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

                        if( level.currentGametype == "tdm" || level.currentGametype == "sd" )
                        {
                            setDvar("host_team", self.team);

                            if( level.currentGametype == "tdm" )
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

                        else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                        {
                            iDamage = 999;

                            if( eAttacker getplayercustomdvar( "showDistance" ) == "1" )
                                eAttacker iprintln("[^1" + dist + "m^7]");
                        }

                        else if( sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                        {
                            iDamage = 0;
                            eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        }
                    }

                    else
                    {
                        if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                        {
                            iDamage = 0;
                            eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        }
                    }
                }

                if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
                {
                    if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
                    {
                        iDamage = 1;
                        self thread semtex_bounce_physics(vDir);
                    }
                }
            }
            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }

        else if(level.currentGametype == "sd")
        {
            if(sMeansOfDeath == "MOD_FALLING")
                iDamage = 0;

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
                        iDamage = 0;

                        foreach(player in level.players) 
                            if(player.team == getDvar("host_team")) 
                            {
                                if( player getplayercustomdvar( "showDistance" ) == "1" )
                                    player iprintln("[^1" + dist + "m^7]");
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

                        else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                        {
                            iDamage = 999;

                            if( eAttacker getplayercustomdvar( "showDistance" ) == "1" )
                                eAttacker iprintln("[^1" + dist + "m^7]");
                        }

                        else if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                        {
                            iDamage = 0;
                            eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        }
                    }
                    else
                    {
                        if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                        {
                            iDamage = 0;
                            eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        }
                    }
                }

                if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
                {
                    if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
                    {
                        iDamage = 1;
                        self thread semtex_bounce_physics(vDir);
                    }
                }
            }
            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }

        else if(level.currentGametype == "tdm")
        {
            if( level.rankedMatch )
            {
                if( game["teamScores"][eAttacker.pers["team"]] == 7400 && isDamageWeapon( sWeapon ) )
                {
                    iDamage = 999;

                    foreach(player in level.players) 
                    {
                        if(player.team == getDvar("host_team")) 
                        {
                            if( player getplayercustomdvar( "showDistance" ) == "1" )
                                player iprintln("[^1" + dist + "m^7]");
                        }
                    }
                }
            }

            else
            {
                if(game["teamScores"][eAttacker.pers["team"]] == 7400)
                {
                    if(dist >= level.lastKill_minDist)
                    {
                        if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                        {
                            iDamage = 999;

                            if( eAttacker getplayercustomdvar( "showDistance" ) == "1" )
                                eAttacker iprintln("[^1" + dist + "m^7]");
                        }
                        
                        else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                        {
                            iDamage = 999;

                            if( eAttacker getplayercustomdvar( "showDistance" ) == "1" )
                                eAttacker iprintln("[^1" + dist + "m^7]");
                        }

                        else if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                        {
                            iDamage = 0;
                            eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        }
                    }
                    else
                    {
                        if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                        {
                            iDamage = 0;
                            eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        }
                    }
                }

                if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
                {
                    if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
                    {
                        iDamage = 1;
                        self thread semtex_bounce_physics(vDir);
                    }
                }
            }
            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }
    }

    semtex_bounce_physics(vdir)
    {
        e = 0;
        while( e < 6 )
        {
            self setorigin( self.origin );
            self setvelocity( self getvelocity() + ( vdir + ( 0, 0, 999 ) ) );
            wait 0.016667;
            e++;
        }
    }

    isdamageweapon(sweapon)
    {
        if(!IsDefined(sweapon))
            return 0;

        sub = strTok(sWeapon,"_");

        switch(sub[0])
        {
            case "dragunov":
            case "l96a1":
            case "wa2000":
            case "psg1":
            case "m14":
            case "fnfal":
                return 1;
        
            default: return 0;
        }
    }

    initDvars()
    {
        if( !level.rankedMatch )
        {
            setDvar("g_compassShowEnemies", 1);
            setDvar("scr_game_forceradar", 1);
            setDvar("compassEnemyFootstepEnabled", 1);
        }

        setDvar("host_team", self.team);
        setdvar("scr_dm_timelimit", 10);
        setdvar("scr_sd_timelimit", 3);
        setDvar("scr_tdm_timelimit", 10);
        setDvar("sv_cheats", 1);   
        setDvar("jump_slowdownEnable", 0);
        setdvar("bg_prone_yawcap", 360 );
        setdvar("player_breath_gasp_lerp", 0 );
        setdvar("player_clipSizeMultiplier", 1 );
        setdvar("perk_bulletPenetrationMultiplier", 30 );
        setDvar("bg_bulletRange", 999999 );
        setDvar("bulletrange", 99999);
        setDvar("sv_botTargetLeadBias", 10);
        setDvar("scr_killcam_time", 5);
        setDvar("scr_killcam_posttime", 2);
        setDvar("sv_botUseFriendNames", 0);
        setDvar("killcam_final", 1);
        setDvar("scr_game_prematchperiod", 10);
        setDvar("sv_botAllowGrenades", 0);
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

    greencrateLocation1()
    {
        self endon("disconnect");
        level endon("game_ended");

        mapName = level.currentMapName;
        spawnLocations = [];

        for(i = -3; i < 3; i++)
        {
            for(d = -3; d<3; d++)
            {
                if (mapName == "mp_nuked") 
                {
                    spawnLocations = [
                        (3722.89, 12221.2, 3778.52),
                        (-176.716, -8530.06, 3100.1),
                        (-6044.9, 840.61, 2904.33)
                    ];
                } 

                else if (mapName == "mp_array") 
                {
                    spawnLocations = [
                        (-3693.71, 12239.5, 3939.71)
                    ];
                } 

                else if (mapName == "mp_radiation") 
                {
                    spawnLocations = [
                        (-817.408, -5206.03, 2637.54),
                        (-4291.16, 785.343, 2003.31),
                        (-376.241, 7292.82, 1805.27)
                    ];
                }

                else if (mapName == "mp_cracked")
                {
                    spawnLocations   = [
                        (-1746.1, -4883.62, 574.74)
                    ];
                }

                else if(mapName == "mp_crisis")
                {
                    spawnLocations = [
                        (-5748.65, 415.442, 1785.81),
                        (10115.2, 424.233, 4229.94)
                    ];
                }

                else if(mapName == "mp_duga")
                {
                    spawnLocations = [
                        (108.001, 2328.06, 3247.1)
                    ];
                }

                else if(mapName == "mp_cosmodrome")
                {
                    spawnLocations = [
                        (2531.77, -2217.04, 1887.63),
                        (2534.83, -6.35055, 1887.23)
                    ];         
                }

                else if(mapName == "mp_mountain")
                {
                    spawnLocations = [
                        (4665.13, 1613.21, 1116.93),
                        (3397.42, -5086.48, 2836.9),
                        (-368.874, 333.844, 1856.18)
                    ];
                }

                else if(mapName == "mp_russianbase")
                {
                    spawnLocations = [
                        (2126.6, -4917, 3734.69),
                        (-1334.47, 3209.59, 791.472),
                        (3955.7, 919.906, 2155.37)
                    ];
                }

                else if(mapName == "mp_villa")
                    spawnLocations   = (10348.4, 4352.82, 3906.91);

                else if(mapName == "mp_silo")
                    spawnLocations   = (7042.24, 6759.94, 4056.28);

                for( a = 0; a < spawnLocations.size; a++)
                {
                    spawngreencrate1 = spawn("script_model", spawnLocations[ a ] + (d * 25, i * 45, 0));
                    spawngreencrate1 setmodel("mp_supplydrop_ally");
                }
            }
        }
    }

    lowerBarriers()
    {
        lowerbarrier("mp_array", 400);
        lowerbarrier("mp_firingrange", 130);
        lowerbarrier("mp_cosmodrome", 600);
        lowerbarrier("mp_radiation", 105);
        removeskybarrier();
    }

    lowerbarrier(map, value)
    {
        if(level.script != map)
            return;
        
        hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

        foreach(barrier in hurt_triggers)
            if(barrier.origin[2] <= 0 ) barrier.origin = barrier.origin - ( 0, 0, value );
    }

    removeSkyBarrier()
    {
        setDvar("g_deadZoneDamageMin", 999999);
        setDvar("g_deadZoneDamageMax", 999999);
        
        deathTriggers = getEntArray("trigger_hurt", "classname");
        
        for(i = 0; i < deathTriggers.size; i++)
        {
            if(deathTriggers[i].origin[2] > 180)
                deathTriggers[i] delete();

            else
            {
                deathTriggers[i].damage = 999999;
                deathTriggers[i].damagetype = "MOD_SUICIDE";
            }
        }
    }

    ServerSettings()
    {
        #ifdef XBOX
        //Bounces
        WriteShort(0x8217C76C, 0x4800); 
        WriteByte(0x821706B4, 0x42);
        #endif
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