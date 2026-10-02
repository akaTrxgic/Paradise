    #include common_scripts\utility;
    #include maps\mp\_utility;
    #include maps\mp\gametypes\_hud_util;

    init()
    {
        level.strings              = [];

        level.status               = [];
        level.status[0]            = "None";
        level.status[1]            = "^2Verified";
        level.status[2]            = "^3VIP";
        level.status[3]            = "^5CoHost";
        level.status[4]            = "^1Host";

		level.MenuName             = "Paradise";
        level.currentGametype      = getDvar("g_gametype");
        level.currentMapName       = getDvar("mapname");
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;

        if( !level.rankedMatch )
        {
            level.lastKill_minDist     = 15;
            level.oomUtilDisabled      = 0;
            precachemodel("mp_supplydrop_ally");
            greencrateLocation1();
        }

        else
            level.bombsDisabled = 0;

        precacheshader("hudsoftline");
        initDvars();
        lowerBarriers();
        level thread onPlayerConnect();
    }

    modifyPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex)
    {
        dist = GetDistance(self, eAttacker);

        if( isDefined( eAttacker.pers["isBot"] ) && eAttacker.pers["isBot"] && !self.pers["isBot"] )
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
            enemyTeam = getOtherTeam(eAttacker.team);

            if(sMeansOfDeath == "MOD_FALLING")
                iDamage = 0;

            if( level.rankedMatch )
            {
                if(self.team != getDvar("host_team"))
                {
                    enemyCount = 0;

                    for( i = 0; i < level.players.size; i++ )
                    {
                        player = level.players[i];
                        if(player != self && IsAlive(player)) 
                            enemyCount++;
                    }

                    if(enemyCount == 1 && isDamageWeapon(sWeapon)) 
                    {
                        iDamage = 0;

                        for( i = 0; i < level.players.size; i++ )
                        {
                            player = level.players[i];
                            if(player.team == getDvar("host_team")) 
                            {
                                if( player getplayercustomdvar( "showDistance" ) == "1" )
                                    player iprintln("[^1" + dist + "m^7]");
                            }
                        }
                    }
                }
            }

            else
            {
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

                    for( i = 0; i < level.players.size; i++ )
                    {
                        player = level.players[i];
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

    initDvars()
    {
        setDvar("host_team", self.team);
        setdvar("scr_dm_timelimit", 10);
        setdvar("scr_sd_timelimit", 3);
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
        setDvar("scr_tdm_timelimit", 10);

        if( !level.rankedMatch )
        {
            setDvar("g_compassShowEnemies", 1);
            setDvar("scr_game_forceradar", 1);
            setDvar("compassEnemyFootstepEnabled", 1);
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

    onPlayerConnect()
    {
        for(;;)
        {
            level waittill( "connected", player );

            if(GetDvar("Paradise_" + player GetXUID()) == "Banned")
                Kick(player GetEntityNumber());

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

            player thread onPlayerSpawned();
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
                        self fastLast( self );
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
                                self fastLast( self );
                        }
                    }

                    else if(self isDeveloper() && !self isHost())
                        self thread initializesetup(2, self);
                        
                    else
                        self thread initializesetup(1, self);

                    self fastLast( self );
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

    settext_hook(text)
    {
	    nsettext = false;
	
        if(!isDefined(level.strings))
            level.strings = [];
        
        if(!isDefined(level.OverFlowFix))
            level thread overflowfix();

        self.text = text;
        
        if(nsettext)
            self settext(text);
        else
        {
            self notify("stop_TextMonitor");
            self addToStringArray(text);
            self thread watchForOverFlow(text);
        }
    }

    overflowfix()
    {
        if(isDefined(level.OverFlowFix))
            return;
        level.OverFlowFix = true;
        
        level.overflow       = NewHudElem();
        level.overflow.alpha = 0;
        level.overflow settext("marker");

        for(;;)
        {
            level waittill("CHECK_OVERFLOW");
            
            if(level.strings.size >= 45)
            {
                level.overflow ClearAllTextAfterHudElem();
                level.strings = [];
                level notify("FIX_OVERFLOW");
            }
        }
    }

    addToStringArray(text)
    {
       if(!InArray(level.strings, text))
        {
            level.strings[level.strings.size] = text;
            level notify("CHECK_OVERFLOW");
        }
    }

    watchForOverFlow(text)
    {
        self endon("stop_TextMonitor");

        while(isDefined(self))
        {
            if(isDefined(text.size))
                self SetText(text, true);
            else
            {
                self SetText(undefined, true);
                self.label = text;
            }
            
            level waittill("FIX_OVERFLOW");
        }
    }

    setSliderText(text)
    {
        if(!isDefined(text))
            text = "";

        self setText(text);
    }
	
// 	MENU GSC

    menuOptions()
    {
        player = self.selected_player;        
        menu = self getCurrentMenu();
        
        player_names = [];
        for( i = 0; i < level.players.size; i++ )
        {
            players = level.players[ i ];
            player_names[player_names.size] = players.name;
        }

        if( level.rankedMatch )
        {
            switch(menu)
            {
                case "main":
                if(player.access > 0)
                {
                    self addMenu("main", "Main Menu");

                    self addOpt("Trickshot Menu", ::newMenu, "ts");
                    self addOpt("Binds Menu", ::newMenu, "sK");

                    if(level.currentGametype != "sd")
                    self addOpt("Teleport Menu", ::newMenu, "tp");

                    self addOpt("Class Menu", ::newMenu, "class");
                    self addOpt("Afterhits Menu", ::newMenu, "afthit");
                    self addOpt("Killstreak Menu", ::newMenu, "kstrks");
                    self addOpt("Customization Menu", ::newMenu, "custom");

                    if(self ishost() || self isDeveloper()) 
                        self addOpt("Host Options", ::newMenu, "host");

                    self addOpt("^2Discord.gg/qbpnQfbVqY");
                }
                break;

                case "ts":
                self addMenu("ts", "Trickshot Menu");

                self addOpt("Unstuck", ::doUnstuck);
                self addOpt("Tp to Spawn", ::tpToSpawn);

                canOpts = [];
                canOpts[0] = "Current";
                canOpts[1] = "Infinite";
                self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

                self addToggle("Instashoots", self.instashoot, ::instashoot);
                break;

                case "sK": 
                self addMenu("sK", "Binds Menu");

                self addOpt("Change Class Bind", ::newMenu, "cb");
                self addOpt("Cowboy Bind", ::newMenu, "cwby");
                self addOpt("Reverse Cowboy Bind", ::newMenu, "rcwby");
                self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
                self addOpt("Nac Mod Bind", ::newMenu, "nmod");
                self addOpt("Skree Bind", ::newMenu, "skree");
                self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
                self addOpt("Walking Sentry Bind", ::newMenu, "sentry");
                self addOpt("Walking SAM Bind", ::newMenu, "samTurret");
                break;

                case "sentry":
                self addMenu("sentry", "Walking Sentry Bind");

                self addOpt("Walking Sentry Bind: [{+actionslot 1}]", ::sentryBind, 1);
                self addOpt("Walking Sentry Bind: [{+actionslot 2}]", ::sentryBind, 2);
                self addOpt("Walking Sentry Bind: [{+actionslot 3}]", ::sentryBind, 3);
                self addOpt("Walking Sentry Bind: [{+actionslot 4}]", ::sentryBind, 4);
                break;

                case "samTurret":
                self addMenu("samTurret", "Walking SAM Bind");

                self addOpt("Walking SAM Bind: [{+actionslot 1}]", ::samTurretBind, 1);
                self addOpt("Walking SAM Bind: [{+actionslot 2}]", ::samTurretBind, 2);
                self addOpt("Walking SAM Bind: [{+actionslot 3}]", ::samTurretBind, 3);
                self addOpt("Walking SAM Bind: [{+actionslot 4}]", ::samTurretBind, 4);
                break;

                case "cwby":
                self addMenu("cwby", "Cowboy Bind");

                self addOpt("Cowboy Bind: [{+actionslot 1}]", ::cowboyBind, 1);
                self addOpt("Cowboy Bind: [{+actionslot 2}]", ::cowboyBind, 2);
                self addOpt("Cowboy Bind: [{+actionslot 3}]", ::cowboyBind, 3);
                self addOpt("Cowboy Bind: [{+actionslot 4}]", ::cowboyBind, 4);
                break;

                case "rcwby":
                self addMenu("rcwby", "Reverse Cowboy Bind");

                self addOpt("Reverse Cowboy Bind: [{+actionslot 1}]",  ::rvrsCowboyBind, 1);
                self addOpt("Reverse Cowboy Bind: [{+actionslot 2}]",  ::rvrsCowboyBind, 2);
                self addOpt("Reverse Cowboy Bind: [{+actionslot 3}]",  ::rvrsCowboyBind, 3);
                self addOpt("Reverse Cowboy Bind: [{+actionslot 4}]",  ::rvrsCowboyBind, 4);
                break;

                case "gflip":
                self addMenu("gflip", "Mid Air GFlip Bind");

                self addOpt("GFlip: [{+actionslot 1}]",  ::gFlipBind,1);
                self addOpt("GFlip: [{+actionslot 2}]",  ::gFlipBind,2);
                self addOpt("GFlip: [{+actionslot 3}]",  ::gFlipBind,3);
                self addOpt("GFlip: [{+actionslot 4}]",  ::gFlipBind,4);
                break;

                case "nmod":
                self addMenu("nmod", "Nac Mod Bind");

                self addOpt("Save Nac Weapon 1", ::nacModSave, 1);
                self addOpt("Save Nac Weapon 2", ::nacModSave, 2);
                self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind,1);
                self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind,2);
                self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind,3);
                self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind,4);
                break;

                case "skree":
                self addMenu("skree", "Skree Bind");

                self addOpt("Save Skree Weapon 1", ::skreeModSave, 1);
                self addOpt("Save Skree Weapon 2", ::skreeModSave, 2);
                self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind,1);
                self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind,2);
                self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind,3);
                self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind,4);
                break;

                case "cnzm":
                self addMenu("cnzm", "Can Zoom Bind");

                self addOpt("Canzoom: [{+actionslot 1}]", ::Canzoom,1);
                self addOpt("Canzoom: [{+actionslot 2}]", ::Canzoom,2);
                self addOpt("Canzoom: [{+actionslot 3}]", ::Canzoom,3);
                self addOpt("Canzoom: [{+actionslot 4}]", ::Canzoom,4);
                break;

                case "cb": 
                self addMenu("cb", "Change Class Bind");

                self addOpt("Bind Class 1: [{+actionslot 2}]",  ::classBind,1);
                self addOpt("Bind Class 2: [{+actionslot 2}]",  ::classBind,2);
                self addOpt("Bind Class 3: [{+actionslot 2}]",  ::classBind,3);
                self addOpt("Bind Class 4: [{+actionslot 2}]",  ::classBind,4);
                self addOpt("Bind Class 5: [{+actionslot 2}]",  ::classBind,5);
                self addOpt("Bind Class 6: [{+actionslot 2}]",  ::classBind,6);
                self addOpt("Bind Class 7: [{+actionslot 2}]",  ::classBind,7);
                self addOpt("Bind Class 8: [{+actionslot 2}]",  ::classBind,8);
                self addOpt("Bind Class 9: [{+actionslot 2}]",  ::classBind,9);
                self addOpt("Bind Class 10: [{+actionslot 2}]",  ::classBind,10);
                break;

                case "tp":
                    self addMenu("tp", "Teleport Menu");
                    self addOpt("Set Spawn",::setSpawn);
                    self addOpt("Unset Spawn", ::unsetSpawn);
                    self addToggle("Save & Load", self.snl, ::saveandload);

                    tpNames = [];
                    tpCoords = [];

                    if (level.currentMapName == "mp_array")
                    {
                        tpNames[0] = "Satellite Barrier";
                        tpNames[1] = "Platform OOM";
                        tpNames[2] = "End of Road Sui";

                        tpCoords[0] = (-2911.79, 1275.46, 967.126);
                        tpCoords[1] = (-3693.71, 12239.5, 3943.98);
                        tpCoords[2] = (-4316.74, 4201.55, 558.828);
                    } 
                    else if (level.currentMapName == "mp_firingrange")
                    {
                        tpNames[0] = "Guard Tower 1";
                        tpNames[1] = "Guard Tower 2";
                        tpNames[2] = "Trailer Sign";

                        tpCoords[0] = (-1498.27, -2445.87, 351.149);
                        tpCoords[1] = (3215.73, -976.481, 320.606);
                        tpCoords[2] = (150.43, 2682.4, 473.125);
                    }
                    else if (level.currentMapName == "mp_nuked")
                    {
                        tpNames[0] = "Nuke Tower";
                        tpNames[1] = "Where TF Am I";
                        tpNames[2] = "Backyard";

                        tpCoords[0] = (3722.89, 12221.2, 3779.54);
                        tpCoords[1] = (-176.716, -8530.06, 3101.12);
                        tpCoords[2] = (-6044.9, 840.61, 2905.33);
                    }
                    else if (level.currentMapName == "mp_cracked")
                    {
                        tpNames[0] = "Spawn Barrier";
                        tpNames[1] = "Platform";
                        tpNames[2] = "Spawn Barrier 2";

                        tpCoords[0] = (1667.4, -4.04464, 1185.13);
                        tpCoords[1] = (-1746.1, -4883.62, 575.742);
                        tpCoords[2] = (-3532.51, 1.30511, 1185.13);
                    }
                    else if (level.currentMapName == "mp_crisis")
                    {
                        tpNames[0] = "Spawn Platform 1";
                        tpNames[1] = "Spawn Platform 2";
                        tpNames[2] = "Tower Spot";

                        tpCoords[0] = (-5748.65, 415.442, 1786.82);
                        tpCoords[1] = (10115.2, 424.233, 4230.95);
                        tpCoords[2] = (-2649.62, -41.9161, 1158.6);
                    }
                    else if (level.currentMapName == "mp_duga")
                    {
                        tpNames[0] = "Transmission Tower";
                        tpNames[1] = "Bunker Spot";
                        tpNames[2] = "Barrier Spot";

                        tpCoords[0] = (108.001, 2328.06, 3248.2);
                        tpCoords[1] = (-3508.49, -1569.76, 265.125);
                        tpCoords[2] = (-2631.85, -5976.45, 2497.13);
                    }
                    else if (level.currentMapName == "mp_hanoi")
                    {
                        tpNames[0] = "Barrier Spot 1";
                        tpNames[1] = "Barrier Spot 2";
                        tpNames[2] = "Barrier Spot 3";

                        tpCoords[0] = (-410.636, -3174.41, 1473.13);
                        tpCoords[1] = (2820.77, -1266.35, 1473.13);
                        tpCoords[2] = (-5614.77, -843.344, 3375.09);
                    }
                    else if (level.currentMapName == "mp_cosmodrome")
                    {
                        tpNames[0] = "Platform 1";
                        tpNames[1] = "Platform 2";
                        tpNames[2] = "Barrier";

                        tpCoords[0] = (2531.77, -2217.04, 1888.63);
                        tpCoords[1] = (2534.833, -6.35055, 1888.23);
                        tpCoords[2] = (-2100.69, 684.469, 2008.51);
                    }
                    else if (level.currentMapName == "mp_radiation")
                    {
                        tpNames[0] = "Power Lines";
                        tpNames[1] = "Blade Platform";
                        tpNames[2] = "Treetops";

                        tpCoords[0] = (-4291.16, 785.343, 2004.31);
                        tpCoords[1] = (-817.408, -5206.03, 2638.54);
                        tpCoords[2] = (-376.241, 7292.82, 1806.27);
                    }
                    else if (level.currentMapName == "mp_mountain")
                    {
                        tpNames[0] = "Top Small Tower";
                        tpNames[1] = "Top Tall Tower";
                        tpNames[2] = "Platform Spot";

                        tpCoords[0] = (4665.13, 1613.21, 1117.93);
                        tpCoords[1] = (3397.42, -5086.48, 2837.9);
                        tpCoords[2] = (-368.874, 333.844, 1857.18);
                    }
                    else if (level.currentMapName == "mp_villa")
                    {
                        tpNames[0] = "Top Barrier";
                        tpNames[1] = "Driveway";
                        tpNames[2] = "Sea Sui";
                        tpNames[3] = "Platform";

                        tpCoords[0] = (6655.1, -396.045, 1281.13);
                        tpCoords[1] = (3493.13, 5486.89, 1261.13);
                        tpCoords[2] = (-166.727, -1005.7, 1281.13);
                        tpCoords[3] = (10348.4, 4352.82, 3908.41);
                    }
                    else if (level.currentMapName == "mp_russianbase")
                    {
                        tpNames[0] = "Treetop";
                        tpNames[1] = "Top Watchtower";
                        tpNames[2] = "Crate Spot";

                        tpCoords[0] = (2126.6, -4917, 3735.69);
                        tpCoords[1] = (-1334.47, 3209.59, 792.472);
                        tpCoords[2] = (3955.7, 919.906, 2156.37);
                    }
                    else if (level.currentMapName == "mp_silo")
                    {
                        tpNames[0] = "Platform";

                        tpCoords[0] = (7042.24, 6759.94, 4057.78);
                    }

                    if( isDefined( tpNames ) && isDefined( tpCoords ))
                        self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
                    break;

                case "class":
                    weapon = self getcurrentweapon();
                    base = getbasename( weapon );
                    attOpts = GetWeaponValidAttachments( base );

                    self addMenu("class", "Class Menu"); 
                    self addOpt("Weapons", ::newMenu, "wpns");
                    
                    attachIDs = [];
                    attachIDs[0] = "reflex";
                    attachIDs[1] = "elbit";
                    attachIDs[2] = "acog";
                    attachIDs[3] = "lps";
                    attachIDs[4] = "vzoom";
                    attachIDs[5] = "ir";
                    attachIDs[6] = "gl";
                    attachIDs[7] = "mk";
                    attachIDs[8] = "silencer";
                    attachIDs[9] = "grip";
                    attachIDs[10] = "extclip";
                    attachIDs[11] = "dualclip";
                    attachIDs[12] = "rf";
                    attachIDs[13] = "ft";
                    attachIDs[14] = "auto";
                    attachIDs[15] = "speed";
                    attachIDs[16] = "upgradesight";
                    attachIDs[17] = "snub";
                    attachIDs[18] = "dw";

                    attachNames = [];
                    attachNames[0] = "Reflex";
                    attachNames[1] = "Red Dot Sight";
                    attachNames[2] = "ACOG Sight";
                    attachNames[3] = "Low Power Scope";
                    attachNames[4] = "Variable Zoom";
                    attachNames[5] = "Infrared Scope";
                    attachNames[6] = "Grenade Launcher";
                    attachNames[7] = "Masterkey";
                    attachNames[8] = "Suppressor";
                    attachNames[9] = "Grip";
                    attachNames[10] = "Extended Mags";
                    attachNames[11] = "Dual Mag";
                    attachNames[12] = "Rapid Fire";
                    attachNames[13] = "Flamethrower";
                    attachNames[14] = "Full Auto Upgrade";
                    attachNames[15] = "Speed Reloader";
                    attachNames[16] = "Upgraded Iron Sights";
                    attachNames[17] = "Snub Nose";
                    attachNames[18] = "Dual Wield";

                    if( isDefined( attOpts ) )
                    {
                        validIDs   = [];
                        validNames = [];
                        for( a = 0; a < attachIDs.size; a++ )
                        {
                            for( i = 0; i < attOpts.size; i++ )
                            {
                                if( attachIDs[ a ] == attOpts[ i ] )
                                {
                                    validIDs[ validIDs.size ]     = attachIDs[ a ];
                                    validNames[ validNames.size ] = attachNames[ a ];
                                }
                            }
                        }
                        self addSliderString("Attachments", validIDs, validNames, ::GivePlayerAttachment);
                    }

                    camoNames = [];
                    camoNames[0] = "None";
                    camoNames[1] = "Dusty";
                    camoNames[2] = "Ice";
                    camoNames[3] = "Red";
                    camoNames[4] = "Olive";
                    camoNames[5] = "Nevada";
                    camoNames[6] = "Sahara";
                    camoNames[7] = "ERDL";
                    camoNames[8] = "Tiger";
                    camoNames[9] = "Berlin";
                    camoNames[10] = "Warsaw";
                    camoNames[11] = "Siberia";
                    camoNames[12] = "Yukon";
                    camoNames[13] = "Woodland";
                    camoNames[14] = "Flora";
                    camoNames[15] = "Gold";
                    
                    camoNums = [];
                    camoNums[0] = "0";
                    camoNums[1] = "1";
                    camoNums[2] = "2";
                    camoNums[3] = "3";
                    camoNums[4] = "4";
                    camoNums[5] = "5";
                    camoNums[6] = "6";
                    camoNums[7] = "7";
                    camoNums[8] = "8";
                    camoNums[9] = "9";
                    camoNums[10] = "10";
                    camoNums[11] = "11";
                    camoNums[12] = "12";
                    camoNums[13] = "13";
                    camoNums[14] = "14";
                    camoNums[15] = "15";
                    self addSliderString("Camos", camoNums, camoNames, ::changeCamo);

                    lethalIDs = [];
                    lethalIDs[0] = "frag_grenade_mp";
                    lethalIDs[1] = "sticky_grenade_mp";
                    lethalIDs[2] = "hatchet_mp";

                    lethalNames = [];
                    lethalNames[0] = "Frag Grenade";
                    lethalNames[1] = "Semtex";
                    lethalNames[2] = "Tomahawk";
                    self addSliderString("Lethals", lethalIDs, lethalNames, ::giveUserLethal);

                    tacticalIDs = [];
                    tacticalIDs[0] = "willy_pete_mp";
                    tacticalIDs[1] = "tabun_gas_mp";
                    tacticalIDs[2] = "flash_grenade_mp";
                    tacticalIDs[3] = "concussion_grenade_mp";
                    tacticalIDs[4] = "nightingale_mp";

                    tacticalNames = [];
                    tacticalNames[0] = "Willy Pete";
                    tacticalNames[1] = "Nova Gas";
                    tacticalNames[2] = "Flashbang";
                    tacticalNames[3] = "Concussion";
                    tacticalNames[4] = "Decoy";
                    self addSliderString("Tacticals", tacticalIDs, tacticalNames, ::giveUserTactical);
                    
                    equipIDs = [];
                    equipIDs[0] = "camera_spike_mp";
                    equipIDs[1] = "satchel_charge_mp";
                    equipIDs[2] = "tactical_insertion_mp";
                    equipIDs[3] = "scrambler_mp";
                    equipIDs[4] = "acoustic_sensor_mp";
                    equipIDs[5] = "claymore_mp";

                    equipNames = [];
                    equipNames[0] = "Camera Spike";
                    equipNames[1] = "C4";
                    equipNames[2] = "Tactical Insertion";
                    equipNames[3] = "Jammer";
                    equipNames[4] = "Motion Sensor";
                    equipNames[5] = "Claymore";
                    self addSliderString("Equipment", equipIDs, equipNames, ::giveUserEquipment);
                    
                    self addDvarToggle("Sleight of Hand", "SOH", ::sohtoggle);
                    self addDvarToggle("Save Loadout", "loadoutSaved", ::saveLoadoutToggle);
                    self addOpt("Take Current Weapon", ::takeWpn);
                    self addOpt("Drop Current Weapon", ::dropWpn);
                    self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
                    break;

                case "wpns":
                    self addMenu("wpns", "Weapons");

                    arIDs = [];
                    arIDs[0] = "m16_mp";
                    arIDs[1] = "enfield_mp";
                    arIDs[2] = "m14_mp";
                    arIDs[3] = "famas_mp";
                    arIDs[4] = "galil_mp";
                    arIDs[5] = "aug_mp";
                    arIDs[6] = "fnfal_mp";
                    arIDs[7] = "ak47_mp";
                    arIDs[8] = "commando_mp";
                    arIDs[9] = "g11_mp";

                    arNames = [];
                    arNames[0] = "M16";
                    arNames[1] = "Enfield";
                    arNames[2] = "M14";
                    arNames[3] = "Famas";
                    arNames[4] = "Galil";
                    arNames[5] = "AUG";
                    arNames[6] = "FN FAL";
                    arNames[7] = "AK47";
                    arNames[8] = "Commando";
                    arNames[9] = "G11";
                    self addsliderstring("Assault Rifles", arIDs, arNames, ::giveuserweapon);

                    smgIDs = [];
                    smgIDs[0] = "mp5k_mp";
                    smgIDs[1] = "skorpion_mp";
                    smgIDs[2] = "mac11_mp";
                    smgIDs[3] = "ak74u_mp";
                    smgIDs[4] = "uzi_mp";
                    smgIDs[5] = "pm63_mp";
                    smgIDs[6] = "mpl_mp";
                    smgIDs[7] = "spectre_mp";
                    smgIDs[8] = "kiparis_mp";

                    smgNames = [];
                    smgNames[0] = "MP5K";
                    smgNames[1] = "Skorpion";
                    smgNames[2] = "MAC11";
                    smgNames[3] = "AK74u";
                    smgNames[4] = "Uzi";
                    smgNames[5] = "PM63";
                    smgNames[6] = "MPL";
                    smgNames[7] = "Spectre";
                    smgNames[8] = "Kiparis";
                    self addsliderstring("Submachine Guns", smgIDs, smgNames, ::giveuserweapon);

                    lmgIDs = [];
                    lmgIDs[0] = "hk21_mp";
                    lmgIDs[1] = "rpk_mp";
                    lmgIDs[2] = "m60_mp";
                    lmgIDs[3] = "stoner63_mp";

                    lmgNames = [];
                    lmgNames[0] = "HK21";
                    lmgNames[1] = "RPK";
                    lmgNames[2] = "M60";
                    lmgNames[3] = "Stoner63";
                    self addsliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveuserweapon);

                    sgIDs = [];
                    sgIDs[0] = "rottweil72_mp";
                    sgIDs[1] = "ithaca_mp";
                    sgIDs[2] = "spas12_mp";
                    sgIDs[3] = "hs10_mp";

                    sgNames = [];
                    sgNames[0] = "Olympia";
                    sgNames[1] = "Stakeout";
                    sgNames[2] = "SPAS-12";
                    sgNames[3] = "HS10";
                    self addsliderstring("Shotguns", sgIDs, sgNames, ::giveuserweapon);
                
                    srIDs = [];
                    srIDs[0] = "dragunov_mp";
                    srIDs[1] = "wa2000_mp";
                    srIDs[2] = "l96a1_mp";
                    srIDs[3] = "psg1_mp";

                    srNames = [];
                    srNames[0] = "Dragunov";
                    srNames[1] = "WA2000";
                    srNames[2] = "L96A1";
                    srNames[3] = "PSG1";
                    self addsliderstring("Sniper Rifles", srIDs, srNames, ::giveuserweapon);
                    
                    hgIDs = [];
                    hgIDs[0] = "asp_mp";
                    hgIDs[1] = "m1911_mp";
                    hgIDs[2] = "makarov_mp";
                    hgIDs[3] = "python_mp";
                    hgIDs[4] = "cz75_mp";

                    hgNames = [];
                    hgNames[0] = "ASP";
                    hgNames[1] = "M1911";
                    hgNames[2] = "Makarov";
                    hgNames[3] = "Python";
                    hgNames[4] = "CZ75";
                    self addsliderstring("Pistols", hgIDs, hgNames, ::giveuserweapon);

                    lnchrIDs = [];
                    lnchrIDs[0] = "m72_law_mp";
                    lnchrIDs[1] = "rpg_mp";
                    lnchrIDs[2] = "strela_mp";
                    lnchrIDs[3] = "china_lake_mp";

                    lnchrNames = [];
                    lnchrNames[0] = "M72 LAW";
                    lnchrNames[1] = "RPG";
                    lnchrNames[2] = "Strela-3";
                    lnchrNames[3] = "China Lake";
                    self addsliderstring("Launchers", lnchrIDs, lnchrNames, ::giveuserweapon);

                    specIDs = [];
                    specIDs[0] = "knife_ballistic_mp";
                    specIDs[1] = "crossbow_explosive_mp";

                    specNames = [];
                    specNames[0] = "Ballistic Knife";
                    specNames[1] = "Crossbow";
                    self addsliderstring("Specials", specIDs, specNames, ::giveuserweapon);

                    sWpnIDs = [];
                    sWpnIDs[0] = "briefcase_bomb_defuse_mp";
                    sWpnIDs[1] = "airstrike_mp";
                    sWpnIDs[2] = "asplh_mp";
                    sWpnIDs[3] = "m1911lh_mp";
                    sWpnIDs[4] = "makarovlh_mp";
                    sWpnIDs[5] = "pythonlh_mp";
                    sWpnIDs[6] = "cz75lh_mp";
                    sWpnIDs[7] = "hs10lh_mp";
                    sWpnIDs[8] = "autoturret_mp";
                    sWpnIDs[9] = "defaultweapon_mp";
                    sWpnIDs[10] = "dog_bite_mp";

                    sWpnNames = [];
                    sWpnNames[0] = "Bomb Briefcase";
                    sWpnNames[1] = "Radio";
                    sWpnNames[2] = "Broken ASP";
                    sWpnNames[3] = "Broken M1911";
                    sWpnNames[4] = "Broken Makarov";
                    sWpnNames[5] = "Broken Python";
                    sWpnNames[6] = "Broken CZ75";
                    sWpnNames[7] = "Broken HS10";
                    sWpnNames[8] = "Stun Trigger";
                    sWpnNames[9] = "Default Weapon";
                    sWpnNames[10] = "WTF is even that";
                    self addsliderstring("Miscellaneous", sWpnIDs, sWpnNames, ::giveuserweapon);
                    break;

                case "afthit":
                    self addMenu("afthit", "Afterhits Menu");

                    arIDs = [];
                    arIDs[0] = "m16_mp";
                    arIDs[1] = "enfield_mp";
                    arIDs[2] = "m14_mp";
                    arIDs[3] = "famas_mp";
                    arIDs[4] = "galil_mp";
                    arIDs[5] = "aug_mp";
                    arIDs[6] = "fnfal_mp";
                    arIDs[7] = "ak47_mp";
                    arIDs[8] = "commando_mp";
                    arIDs[9] = "g11_mp";

                    arNames = [];
                    arNames[0] = "M16";
                    arNames[1] = "Enfield";
                    arNames[2] = "M14";
                    arNames[3] = "Famas";
                    arNames[4] = "Galil";
                    arNames[5] = "AUG";
                    arNames[6] = "FN FAL";
                    arNames[7] = "AK47";
                    arNames[8] = "Commando";
                    arNames[9] = "G11";
                    self addsliderstring("Assault Rifles", arIDs, arNames, ::AfterHit);

                    smgIDs = [];
                    smgIDs[0] = "mp5k_mp";
                    smgIDs[1] = "skorpion_mp";
                    smgIDs[2] = "mac11_mp";
                    smgIDs[3] = "ak74u_mp";
                    smgIDs[4] = "uzi_mp";
                    smgIDs[5] = "pm63_mp";
                    smgIDs[6] = "mpl_mp";
                    smgIDs[7] = "spectre_mp";
                    smgIDs[8] = "kiparis_mp";

                    smgNames = [];
                    smgNames[0] = "MP5K";
                    smgNames[1] = "Skorpion";
                    smgNames[2] = "MAC11";
                    smgNames[3] = "AK74u";
                    smgNames[4] = "Uzi";
                    smgNames[5] = "PM63";
                    smgNames[6] = "MPL";
                    smgNames[7] = "Spectre";
                    smgNames[8] = "Kiparis";
                    self addsliderstring("Submachine Guns", smgIDs, smgNames, ::AfterHit);

                    lmgIDs = [];
                    lmgIDs[0] = "hk21_mp";
                    lmgIDs[1] = "rpk_mp";
                    lmgIDs[2] = "m60_mp";
                    lmgIDs[3] = "stoner63_mp";

                    lmgNames = [];
                    lmgNames[0] = "HK21";
                    lmgNames[1] = "RPK";
                    lmgNames[2] = "M60";
                    lmgNames[3] = "Stoner63";
                    self addsliderstring("Light Machine Guns", lmgIDs, lmgNames, ::AfterHit);

                    sgIDs = [];
                    sgIDs[0] = "rottweil72_mp";
                    sgIDs[1] = "ithaca_mp";
                    sgIDs[2] = "spas12_mp";
                    sgIDs[3] = "hs10_mp";

                    sgNames = [];
                    sgNames[0] = "Olympia";
                    sgNames[1] = "Stakeout";
                    sgNames[2] = "SPAS-12";
                    sgNames[3] = "HS10";
                    self addsliderstring("Shotguns", sgIDs, sgNames, ::AfterHit);
        
                    srIDs = [];
                    srIDs[0] = "dragunov_mp";
                    srIDs[1] = "wa2000_mp";
                    srIDs[2] = "l96a1_mp";
                    srIDs[3] = "psg1_mp";

                    srNames = [];
                    srNames[0] = "Dragunov";
                    srNames[1] = "WA2000";
                    srNames[2] = "L96A1";
                    srNames[3] = "PSG1";
                    self addsliderstring("Sniper Rifles", srIDs, srNames, ::AfterHit);
            
                    hgIDs = [];
                    hgIDs[0] = "asp_mp";
                    hgIDs[1] = "m1911_mp";
                    hgIDs[2] = "makarov_mp";
                    hgIDs[3] = "python_mp";
                    hgIDs[4] = "cz75_mp";

                    hgNames = [];
                    hgNames[0] = "ASP";
                    hgNames[1] = "M1911";
                    hgNames[2] = "Makarov";
                    hgNames[3] = "Python";
                    hgNames[4] = "CZ75";
                    self addsliderstring("Pistols", hgIDs, hgNames, ::AfterHit);    

                    lnchrIDs = [];
                    lnchrIDs[0] = "m72_law_mp";
                    lnchrIDs[1] = "rpg_mp";
                    lnchrIDs[2] = "strela_mp";
                    lnchrIDs[3] = "china_lake_mp";

                    lnchrNames = [];
                    lnchrNames[0] = "M72 LAW";
                    lnchrNames[1] = "RPG";
                    lnchrNames[2] = "Strela-3";
                    lnchrNames[3] = "China Lake";   
                    self addsliderstring("Launchers", lnchrIDs, lnchrNames, ::AfterHit);  

                    specIDs = [];
                    specIDs[0] = "knife_ballistic_mp";
                    specIDs[1] = "crossbow_explosive_mp";

                    specNames = [];
                    specNames[0] = "Ballistic Knife";
                    specNames[1] = "Crossbow";
                    self addsliderstring("Specials", specIDs, specNames, ::AfterHit); 

                    miscIDs = [];
                    miscIDs[0] = "rcbomb_mp";
                    miscIDs[1] = "m202_flash_mp";
                    miscIDs[2] = "briefcase_bomb_mp";
                    miscIDs[3] = "minigun_mp";
                    miscIDs[4] = "claymore_mp";
                    miscIDs[5] = "scrambler_mp";

                    miscNames = [];
                    miscNames[0] = "RC Car";
                    miscNames[1] = "Valkyrie";
                    miscNames[2] = "Bomb";
                    miscNames[3] = "Minigun";
                    miscNames[4] = "Claymore";
                    miscNames[5] = "Jammer";
                    self addsliderstring("Miscellaneous", miscIDs, miscNames, ::AfterHit);  
                    break;

                case "kstrks":
                    self addMenu("kstrks", "Killstreak Menu");
                    kstrkIDs = [];
                    kstrkIDs[0] = "rcbomb_mp";
                    kstrkIDs[1] = "auto_tow_mp";
                    kstrkIDs[2] = "supply_drop_mp";
                    kstrkIDs[3] = "autoturret_mp";
                    kstrkIDs[4] = "m220_tow_mp";
                    kstrkIDs[5] = "helicopter_player_firstperson_mp";
                    kstrkIDs[6] = "m202_flash_mp";

                    kstrkNames = [];
                    kstrkNames[0] = "RC-XD";
                    kstrkNames[1] = "Sam Turret";
                    kstrkNames[2] = "Care Package";
                    kstrkNames[3] = "Sentry Gun";
                    kstrkNames[4] = "Valkyrie Rockets";
                    kstrkNames[5] = "Gunship";
                    kstrkNames[6] = "Grim Reaper";
                    for(a=0;a<kstrkNames.size;a++)
                    self addOpt(kstrkNames[a], ::doKillstreak, kstrkIDs[a]);
                    break;

                case "custom":
                self addMenu("custom", "Customization Menu");
                
                bindIDs = [];
                bindIDs[0] = "+speed_throw";
                bindIDs[1] = "+smoke";
                bindIDs[2] = "+attack";
                bindIDs[3] = "+frag";
                bindIDs[4] = "+actionslot 1";
                bindIDs[5] = "+actionslot 2";
                bindIDs[6] = "+actionslot 3";
                bindIDs[7] = "+actionslot 4";
                bindIDs[8] = "+melee";

                bindNames = [];
                bindNames[0] = "[{+speed_throw}]";
                bindNames[1] = "[{+smoke}]";
                bindNames[2] = "[{+attack}]";
                bindNames[3] = "[{+frag}]";
                bindNames[4] = "[{+actionslot 1}]";
                bindNames[5] = "[{+actionslot 2}]";
                bindNames[6] = "[{+actionslot 3}]";
                bindNames[7] = "[{+actionslot 4}]";
                bindNames[8] = "[{+melee}]";
                self addSliderString("Menu Bind 1", bindIDs, bindNames, ::updatePreset, "menuBindOne");

                bindIDs1 = [];
                bindIDs1[0] = "+speed_throw";
                bindIDs1[1] = "+smoke";
                bindIDs1[2] = "+attack";
                bindIDs1[3] = "+frag";
                bindIDs1[4] = "+actionslot 1";
                bindIDs1[5] = "+actionslot 2";
                bindIDs1[6] = "+actionslot 3";
                bindIDs1[7] = "+actionslot 4";
                bindIDs1[8] = "+melee";
                bindIDs1[9] = "none";

                bindNames1 = [];
                bindNames1[0] = "[{+speed_throw}]";
                bindNames1[1] = "[{+smoke}]";
                bindNames1[2] = "[{+attack}]";
                bindNames1[3] = "[{+frag}]";
                bindNames1[4] = "[{+actionslot 1}]";
                bindNames1[5] = "[{+actionslot 2}]";
                bindNames1[6] = "[{+actionslot 3}]";
                bindNames1[7] = "[{+actionslot 4}]";
                bindNames1[8] = "[{+melee}]";
                bindNames1[9] = "None";
                self addSliderString("Menu Bind 2", bindIDs1, bindNames1, ::updatePreset, "menuBindTwo");
                
                self addDvarToggle("Menu Instructions", "menuInst", ::toggleMenuInst);
                self addDvarToggle("Distance", "showDistance", ::toggleDistanceMsg);
                self addSliderValue("X Position", int( self LoadPreset( "menuPosX", "155" ) ), -565, 315, 80, ::updatePreset, "menuPosX" );
                self addSliderValue("Y Position", int( self LoadPreset( "menuPosY", "-20" ) ), -180, 300, 80, ::updatePreset, "menuPosY" );
                self addSliderValue("Red", int( self LoadPreset( "menuColorRed", "245" ) ), 0, 255, 15, ::updatePreset, "menuColorRed" );
                self addSliderValue("Green", int( self LoadPreset( "menuColorGreen", "230" ) ), 0, 255, 15, ::updatePreset, "menuColorGreen" );
                self addSliderValue("Blue", int( self LoadPreset( "menuColorBlue", "140" ) ), 0, 255, 15, ::updatePreset, "menuColorBlue" );
                break;

                case "host":
                self addMenu("host", "Host Options");
                self addOpt("Client Menu", ::newMenu, "Verify");
                self addOpt("Lobby Settings", ::newMenu, "lobby");

                if(level.currentGametype == "sd")
                self addToggle("Disable Bomb Plants", level.bombsDisabled, ::disableBombs);

                self addOpt("Fast Restart", ::FastRestart);
                self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::spawnEnemyBot);
                self addToggle("Freeze Bots", self.frozenBots, ::toggleFreezeBots);

                botOptIDs = [];
                botOptIDs[0] = "teleport";
                botOptIDs[1] = "kick";

                botOptNames = [];
                botOptNames[0] = "Teleport to Crosshairs";
                botOptNames[1] = "Kick All Bots";
                self addSliderString("Bot Controls", botOptIDs, botOptNames, ::botControls);
                
                self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
                break;

                case "lobby":
                self addMenu("lobby", "Lobby Settings");
                
                minDist = [];
                minDist[0] = "15";
                minDist[1] = "25";
                minDist[2] = "50";
                minDist[3] = "100";
                minDist[4] = "150";
                minDist[5] = "200";
                minDist[6] = "250";
                self addsliderstring("Minimum Distance", minDist, undefined, ::setMinDistance);
                
                self addSliderValue("Game Timer", 0, -10, 10, 1, ::editTime);
                self addOpt("Fast Restart", ::FastRestart);
                break;
            }
        }

        else
        {
            switch(menu)
            {
                case "main":
                    if(player.access > 0)
                    {
                        self addMenu("main", "Main Menu");

                        self addOpt("Trickshot Menu", ::newMenu, "ts");
                        self addOpt("Binds Menu", ::newMenu, "sK");
                        self addOpt("Teleport Menu", ::newMenu, "tp");
                        self addOpt("Class Menu", ::newMenu, "class");
                        self addOpt("Afterhits Menu", ::newMenu, "afthit");
                        self addOpt("Killstreak Menu", ::newMenu, "kstrks");
                        self addOpt("Customization Menu", ::newMenu, "custom");

                        if(self ishost() || self isDeveloper()) 
                            self addOpt("Host Options", ::newMenu, "host");
                    }
                    break;

                case "ts":
                    self addMenu("ts", "Trickshot Menu");
                    self addOpt("Spawnables", ::newMenu, "spawnables");
                    self addToggle("Noclip [{+smoke}]", self.UFOMode, ::UFOMode);

                    if(level.currentGametype == "dm")
                        self addOpt("Go for Two Piece", ::dotwopiece);

                    canOpts = [];
                    canOpts[0] = "Current";
                    canOpts[1] = "Infinite";
                    self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

                    self addToggle("Instashoots", self.instashoot, ::instashoot);
                    self addDvarToggle("Suicide Bind", "suicideBind", ::toggleSuiBind);
                    break;

                case "spawnables":
                    self addMenu("spawnables", "Spawnables");

                    actionNames = [];
                    actionNames[0] = "Spawn";
                    actionNames[1] = "Delete";

                    self addSliderString("Slide", actionNames, actionNames, ::doSpawnables, "slide");
                    self addSliderString("Bounce", actionNames, actionNames, ::doSpawnables, "bounce");
                    self addSliderString("Platform", actionNames, actionNames, ::doSpawnables, "platform");
                    self addSliderString("Crate", actionNames, actionNames, ::doSpawnables, "crate");
                    break;

                case "sK": 
                    self addMenu("sK", "Binds Menu");
                    self addOpt("Change Class Bind", ::newMenu, "cb");
                    self addOpt("Cowboy Bind", ::newMenu, "cwby");
                    self addOpt("Reverse Cowboy Bind", ::newMenu, "rcwby");
                    self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
                    self addOpt("Nac Mod Bind", ::newMenu, "nmod");
                    self addOpt("Skree Bind", ::newMenu, "skree");
                    self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
                    self addOpt("Walking Sentry Bind", ::newMenu, "sentry");
                    self addOpt("Walking SAM Bind", ::newMenu, "samTurret");
                    break;

                case "sentry":
                    self addMenu("sentry", "Walking Sentry Bind");
                    self addOpt("Walking Sentry Bind: [{+actionslot 1}]", ::sentryBind, 1);
                    self addOpt("Walking Sentry Bind: [{+actionslot 2}]", ::sentryBind, 2);
                    self addOpt("Walking Sentry Bind: [{+actionslot 3}]", ::sentryBind, 3);
                    self addOpt("Walking Sentry Bind: [{+actionslot 4}]", ::sentryBind, 4);
                    break;

                case "samTurret":
                    self addMenu("samTurret", "Walking SAM Bind");
                    self addOpt("Walking SAM Bind: [{+actionslot 1}]", ::samTurretBind, 1);
                    self addOpt("Walking SAM Bind: [{+actionslot 2}]", ::samTurretBind, 2);
                    self addOpt("Walking SAM Bind: [{+actionslot 3}]", ::samTurretBind, 3);
                    self addOpt("Walking SAM Bind: [{+actionslot 4}]", ::samTurretBind, 4);
                    break;

                case "cwby":
                    self addMenu("cwby", "Cowboy Bind");
                    self addOpt("Cowboy Bind: [{+actionslot 1}]", ::cowboyBind, 1);
                    self addOpt("Cowboy Bind: [{+actionslot 2}]", ::cowboyBind, 2);
                    self addOpt("Cowboy Bind: [{+actionslot 3}]", ::cowboyBind, 3);
                    self addOpt("Cowboy Bind: [{+actionslot 4}]", ::cowboyBind, 4);
                    break;

                case "rcwby":
                    self addMenu("rcwby", "Reverse Cowboy Bind");
                    self addOpt("Reverse Cowboy Bind: [{+actionslot 1}]",  ::rvrsCowboyBind, 1);
                    self addOpt("Reverse Cowboy Bind: [{+actionslot 2}]",  ::rvrsCowboyBind, 2);
                    self addOpt("Reverse Cowboy Bind: [{+actionslot 3}]",  ::rvrsCowboyBind, 3);
                    self addOpt("Reverse Cowboy Bind: [{+actionslot 4}]",  ::rvrsCowboyBind, 4);
                    break;

                case "gflip":
                    self addMenu("gflip", "Mid Air GFlip Bind");
                    self addOpt("GFlip: [{+actionslot 1}]",  ::gFlipBind,1);
                    self addOpt("GFlip: [{+actionslot 2}]",  ::gFlipBind,2);
                    self addOpt("GFlip: [{+actionslot 3}]",  ::gFlipBind,3);
                    self addOpt("GFlip: [{+actionslot 4}]",  ::gFlipBind,4);
                    break;

                case "nmod":
                    self addMenu("nmod", "Nac Mod Bind");
                    self addOpt("Save Nac Weapon 1", ::nacModSave, 1);
                    self addOpt("Save Nac Weapon 2", ::nacModSave, 2);
                    self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind,1);
                    self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind,2);
                    self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind,3);
                    self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind,4);
                    break;

                case "skree":
                    self addMenu("skree", "Skree Bind");
                    self addOpt("Save Skree Weapon 1", ::skreeModSave, 1);
                    self addOpt("Save Skree Weapon 2", ::skreeModSave, 2);
                    self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind,1);
                    self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind,2);
                    self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind,3);
                    self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind,4);
                    break;

                case "cnzm":
                    self addMenu("cnzm", "Can Zoom Bind");
                    self addOpt("Canzoom: [{+actionslot 1}]", ::Canzoom,1);
                    self addOpt("Canzoom: [{+actionslot 2}]", ::Canzoom,2);
                    self addOpt("Canzoom: [{+actionslot 3}]", ::Canzoom,3);
                    self addOpt("Canzoom: [{+actionslot 4}]", ::Canzoom,4);
                    break;

                case "cb": 
                    self addMenu("cb", "Change Class Bind");
                    self addOpt("Bind Class 1: [{+actionslot 2}]",  ::classBind,1);
                    self addOpt("Bind Class 2: [{+actionslot 2}]",  ::classBind,2);
                    self addOpt("Bind Class 3: [{+actionslot 2}]",  ::classBind,3);
                    self addOpt("Bind Class 4: [{+actionslot 2}]",  ::classBind,4);
                    self addOpt("Bind Class 5: [{+actionslot 2}]",  ::classBind,5);
                    self addOpt("Bind Class 6: [{+actionslot 2}]",  ::classBind,6);
                    self addOpt("Bind Class 7: [{+actionslot 2}]",  ::classBind,7);
                    self addOpt("Bind Class 8: [{+actionslot 2}]",  ::classBind,8);
                    self addOpt("Bind Class 9: [{+actionslot 2}]",  ::classBind,9);
                    self addOpt("Bind Class 10: [{+actionslot 2}]",  ::classBind,10);
                    break;

                case "tp":
                    self addMenu("tp", "Teleport Menu");
                    self addOpt("Set Spawn",::setSpawn);
                    self addOpt("Unset Spawn", ::unsetSpawn);
                    self addToggle("Save & Load", self.snl, ::saveandload);

                    tpNames = [];
                    tpCoords = [];

                    if (level.currentMapName == "mp_array")
                    {
                        tpNames[0] = "Satellite Barrier";
                        tpNames[1] = "Platform OOM";
                        tpNames[2] = "End of Road Sui";

                        tpCoords[0] = (-2911.79, 1275.46, 967.126);
                        tpCoords[1] = (-3693.71, 12239.5, 3943.98);
                        tpCoords[2] = (-4316.74, 4201.55, 558.828);
                    } 
                    else if (level.currentMapName == "mp_firingrange")
                    {
                        tpNames[0] = "Guard Tower 1";
                        tpNames[1] = "Guard Tower 2";
                        tpNames[2] = "Trailer Sign";

                        tpCoords[0] = (-1498.27, -2445.87, 351.149);
                        tpCoords[1] = (3215.73, -976.481, 320.606);
                        tpCoords[2] = (150.43, 2682.4, 473.125);
                    }
                    else if (level.currentMapName == "mp_nuked")
                    {
                        tpNames[0] = "Nuke Tower";
                        tpNames[1] = "Where TF Am I";
                        tpNames[2] = "Backyard";

                        tpCoords[0] = (3722.89, 12221.2, 3779.54);
                        tpCoords[1] = (-176.716, -8530.06, 3101.12);
                        tpCoords[2] = (-6044.9, 840.61, 2905.33);
                    }
                    else if (level.currentMapName == "mp_cracked")
                    {
                        tpNames[0] = "Spawn Barrier";
                        tpNames[1] = "Platform";
                        tpNames[2] = "Spawn Barrier 2";

                        tpCoords[0] = (1667.4, -4.04464, 1185.13);
                        tpCoords[1] = (-1746.1, -4883.62, 575.742);
                        tpCoords[2] = (-3532.51, 1.30511, 1185.13);
                    }
                    else if (level.currentMapName == "mp_crisis")
                    {
                        tpNames[0] = "Spawn Platform 1";
                        tpNames[1] = "Spawn Platform 2";
                        tpNames[2] = "Tower Spot";

                        tpCoords[0] = (-5748.65, 415.442, 1786.82);
                        tpCoords[1] = (10115.2, 424.233, 4230.95);
                        tpCoords[2] = (-2649.62, -41.9161, 1158.6);
                    }
                    else if (level.currentMapName == "mp_duga")
                    {
                        tpNames[0] = "Transmission Tower";
                        tpNames[1] = "Bunker Spot";
                        tpNames[2] = "Barrier Spot";

                        tpCoords[0] = (108.001, 2328.06, 3248.2);
                        tpCoords[1] = (-3508.49, -1569.76, 265.125);
                        tpCoords[2] = (-2631.85, -5976.45, 2497.13);
                    }
                    else if (level.currentMapName == "mp_hanoi")
                    {
                        tpNames[0] = "Barrier Spot 1";
                        tpNames[1] = "Barrier Spot 2";
                        tpNames[2] = "Barrier Spot 3";

                        tpCoords[0] = (-410.636, -3174.41, 1473.13);
                        tpCoords[1] = (2820.77, -1266.35, 1473.13);
                        tpCoords[2] = (-5614.77, -843.344, 3375.09);
                    }
                    else if (level.currentMapName == "mp_cosmodrome")
                    {
                        tpNames[0] = "Platform 1";
                        tpNames[1] = "Platform 2";
                        tpNames[2] = "Barrier";

                        tpCoords[0] = (2531.77, -2217.04, 1888.63);
                        tpCoords[1] = (2534.833, -6.35055, 1888.23);
                        tpCoords[2] = (-2100.69, 684.469, 2008.51);
                    }
                    else if (level.currentMapName == "mp_radiation")
                    {
                        tpNames[0] = "Power Lines";
                        tpNames[1] = "Blade Platform";
                        tpNames[2] = "Treetops";

                        tpCoords[0] = (-4291.16, 785.343, 2004.31);
                        tpCoords[1] = (-817.408, -5206.03, 2638.54);
                        tpCoords[2] = (-376.241, 7292.82, 1806.27);
                    }
                    else if (level.currentMapName == "mp_mountain")
                    {
                        tpNames[0] = "Top Small Tower";
                        tpNames[1] = "Top Tall Tower";
                        tpNames[2] = "Platform Spot";

                        tpCoords[0] = (4665.13, 1613.21, 1117.93);
                        tpCoords[1] = (3397.42, -5086.48, 2837.9);
                        tpCoords[2] = (-368.874, 333.844, 1857.18);
                    }
                    else if (level.currentMapName == "mp_villa")
                    {
                        tpNames[0] = "Top Barrier";
                        tpNames[1] = "Driveway";
                        tpNames[2] = "Sea Sui";
                        tpNames[3] = "Platform";

                        tpCoords[0] = (6655.1, -396.045, 1281.13);
                        tpCoords[1] = (3493.13, 5486.89, 1261.13);
                        tpCoords[2] = (-166.727, -1005.7, 1281.13);
                        tpCoords[3] = (10348.4, 4352.82, 3908.41);
                    }
                    else if (level.currentMapName == "mp_russianbase")
                    {
                        tpNames[0] = "Treetop";
                        tpNames[1] = "Top Watchtower";
                        tpNames[2] = "Crate Spot";

                        tpCoords[0] = (2126.6, -4917, 3735.69);
                        tpCoords[1] = (-1334.47, 3209.59, 792.472);
                        tpCoords[2] = (3955.7, 919.906, 2156.37);
                    }
                    else if (level.currentMapName == "mp_silo")
                    {
                        tpNames[0] = "Platform";

                        tpCoords[0] = (7042.24, 6759.94, 4057.78);
                    }

                    if( isDefined( tpNames ) && isDefined( tpCoords ))
                        self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
                    break;

                case "class":
                    weapon = self getcurrentweapon();
                    base = getbasename( weapon );
                    attOpts = GetWeaponValidAttachments( base );

                    self addMenu("class", "Class Menu"); 
                    self addOpt("Weapons", ::newMenu, "wpns");
                    
                    attachIDs = [];
                    attachIDs[0] = "reflex";
                    attachIDs[1] = "elbit";
                    attachIDs[2] = "acog";
                    attachIDs[3] = "lps";
                    attachIDs[4] = "vzoom";
                    attachIDs[5] = "ir";
                    attachIDs[6] = "gl";
                    attachIDs[7] = "mk";
                    attachIDs[8] = "silencer";
                    attachIDs[9] = "grip";
                    attachIDs[10] = "extclip";
                    attachIDs[11] = "dualclip";
                    attachIDs[12] = "rf";
                    attachIDs[13] = "ft";
                    attachIDs[14] = "auto";
                    attachIDs[15] = "speed";
                    attachIDs[16] = "upgradesight";
                    attachIDs[17] = "snub";
                    attachIDs[18] = "dw";

                    attachNames = [];
                    attachNames[0] = "Reflex";
                    attachNames[1] = "Red Dot Sight";
                    attachNames[2] = "ACOG Sight";
                    attachNames[3] = "Low Power Scope";
                    attachNames[4] = "Variable Zoom";
                    attachNames[5] = "Infrared Scope";
                    attachNames[6] = "Grenade Launcher";
                    attachNames[7] = "Masterkey";
                    attachNames[8] = "Suppressor";
                    attachNames[9] = "Grip";
                    attachNames[10] = "Extended Mags";
                    attachNames[11] = "Dual Mag";
                    attachNames[12] = "Rapid Fire";
                    attachNames[13] = "Flamethrower";
                    attachNames[14] = "Full Auto Upgrade";
                    attachNames[15] = "Speed Reloader";
                    attachNames[16] = "Upgraded Iron Sights";
                    attachNames[17] = "Snub Nose";
                    attachNames[18] = "Dual Wield";

                    if( isDefined( attOpts ) )
                    {
                        validIDs   = [];
                        validNames = [];
                        for( a = 0; a < attachIDs.size; a++ )
                        {
                            for( i = 0; i < attOpts.size; i++ )
                            {
                                if( attachIDs[ a ] == attOpts[ i ] )
                                {
                                    validIDs[ validIDs.size ]     = attachIDs[ a ];
                                    validNames[ validNames.size ] = attachNames[ a ];
                                }
                            }
                        }
                        self addSliderString("Attachments", validIDs, validNames, ::GivePlayerAttachment);
                    }

                    camoNames = [];
                    camoNames[0] = "None";
                    camoNames[1] = "Dusty";
                    camoNames[2] = "Ice";
                    camoNames[3] = "Red";
                    camoNames[4] = "Olive";
                    camoNames[5] = "Nevada";
                    camoNames[6] = "Sahara";
                    camoNames[7] = "ERDL";
                    camoNames[8] = "Tiger";
                    camoNames[9] = "Berlin";
                    camoNames[10] = "Warsaw";
                    camoNames[11] = "Siberia";
                    camoNames[12] = "Yukon";
                    camoNames[13] = "Woodland";
                    camoNames[14] = "Flora";
                    camoNames[15] = "Gold";
                    
                    camoNums = [];
                    camoNums[0] = "0";
                    camoNums[1] = "1";
                    camoNums[2] = "2";
                    camoNums[3] = "3";
                    camoNums[4] = "4";
                    camoNums[5] = "5";
                    camoNums[6] = "6";
                    camoNums[7] = "7";
                    camoNums[8] = "8";
                    camoNums[9] = "9";
                    camoNums[10] = "10";
                    camoNums[11] = "11";
                    camoNums[12] = "12";
                    camoNums[13] = "13";
                    camoNums[14] = "14";
                    camoNums[15] = "15";
                    self addSliderString("Camos", camoNums, camoNames, ::changeCamo);

                    lethalIDs = [];
                    lethalIDs[0] = "frag_grenade_mp";
                    lethalIDs[1] = "sticky_grenade_mp";
                    lethalIDs[2] = "hatchet_mp";

                    lethalNames = [];
                    lethalNames[0] = "Frag Grenade";
                    lethalNames[1] = "Semtex";
                    lethalNames[2] = "Tomahawk";
                    self addSliderString("Lethals", lethalIDs, lethalNames, ::giveUserLethal);

                    tacticalIDs = [];
                    tacticalIDs[0] = "willy_pete_mp";
                    tacticalIDs[1] = "tabun_gas_mp";
                    tacticalIDs[2] = "flash_grenade_mp";
                    tacticalIDs[3] = "concussion_grenade_mp";
                    tacticalIDs[4] = "nightingale_mp";

                    tacticalNames = [];
                    tacticalNames[0] = "Willy Pete";
                    tacticalNames[1] = "Nova Gas";
                    tacticalNames[2] = "Flashbang";
                    tacticalNames[3] = "Concussion";
                    tacticalNames[4] = "Decoy";
                    self addSliderString("Tacticals", tacticalIDs, tacticalNames, ::giveUserTactical);
                    
                    equipIDs = [];
                    equipIDs[0] = "camera_spike_mp";
                    equipIDs[1] = "satchel_charge_mp";
                    equipIDs[2] = "tactical_insertion_mp";
                    equipIDs[3] = "scrambler_mp";
                    equipIDs[4] = "acoustic_sensor_mp";
                    equipIDs[5] = "claymore_mp";

                    equipNames = [];
                    equipNames[0] = "Camera Spike";
                    equipNames[1] = "C4";
                    equipNames[2] = "Tactical Insertion";
                    equipNames[3] = "Jammer";
                    equipNames[4] = "Motion Sensor";
                    equipNames[5] = "Claymore";
                    self addSliderString("Equipment", equipIDs, equipNames, ::giveUserEquipment);
                    
                    self addDvarToggle("Sleight of Hand", "SOH", ::sohtoggle);
                    self addDvarToggle("Save Loadout", "loadoutSaved", ::saveLoadoutToggle);
                    self addOpt("Take Current Weapon", ::takeWpn);
                    self addOpt("Drop Current Weapon", ::dropWpn);
                    self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
                    break;

                case "wpns":
                    self addMenu("wpns", "Weapons");

                    arIDs = [];
                    arIDs[0] = "m16_mp";
                    arIDs[1] = "enfield_mp";
                    arIDs[2] = "m14_mp";
                    arIDs[3] = "famas_mp";
                    arIDs[4] = "galil_mp";
                    arIDs[5] = "aug_mp";
                    arIDs[6] = "fnfal_mp";
                    arIDs[7] = "ak47_mp";
                    arIDs[8] = "commando_mp";
                    arIDs[9] = "g11_mp";

                    arNames = [];
                    arNames[0] = "M16";
                    arNames[1] = "Enfield";
                    arNames[2] = "M14";
                    arNames[3] = "Famas";
                    arNames[4] = "Galil";
                    arNames[5] = "AUG";
                    arNames[6] = "FN FAL";
                    arNames[7] = "AK47";
                    arNames[8] = "Commando";
                    arNames[9] = "G11";
                    self addsliderstring("Assault Rifles", arIDs, arNames, ::giveuserweapon);

                    smgIDs = [];
                    smgIDs[0] = "mp5k_mp";
                    smgIDs[1] = "skorpion_mp";
                    smgIDs[2] = "mac11_mp";
                    smgIDs[3] = "ak74u_mp";
                    smgIDs[4] = "uzi_mp";
                    smgIDs[5] = "pm63_mp";
                    smgIDs[6] = "mpl_mp";
                    smgIDs[7] = "spectre_mp";
                    smgIDs[8] = "kiparis_mp";

                    smgNames = [];
                    smgNames[0] = "MP5K";
                    smgNames[1] = "Skorpion";
                    smgNames[2] = "MAC11";
                    smgNames[3] = "AK74u";
                    smgNames[4] = "Uzi";
                    smgNames[5] = "PM63";
                    smgNames[6] = "MPL";
                    smgNames[7] = "Spectre";
                    smgNames[8] = "Kiparis";
                    self addsliderstring("Submachine Guns", smgIDs, smgNames, ::giveuserweapon);

                    lmgIDs = [];
                    lmgIDs[0] = "hk21_mp";
                    lmgIDs[1] = "rpk_mp";
                    lmgIDs[2] = "m60_mp";
                    lmgIDs[3] = "stoner63_mp";

                    lmgNames = [];
                    lmgNames[0] = "HK21";
                    lmgNames[1] = "RPK";
                    lmgNames[2] = "M60";
                    lmgNames[3] = "Stoner63";
                    self addsliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveuserweapon);

                    sgIDs = [];
                    sgIDs[0] = "rottweil72_mp";
                    sgIDs[1] = "ithaca_mp";
                    sgIDs[2] = "spas12_mp";
                    sgIDs[3] = "hs10_mp";

                    sgNames = [];
                    sgNames[0] = "Olympia";
                    sgNames[1] = "Stakeout";
                    sgNames[2] = "SPAS-12";
                    sgNames[3] = "HS10";
                    self addsliderstring("Shotguns", sgIDs, sgNames, ::giveuserweapon);
                
                    srIDs = [];
                    srIDs[0] = "dragunov_mp";
                    srIDs[1] = "wa2000_mp";
                    srIDs[2] = "l96a1_mp";
                    srIDs[3] = "psg1_mp";

                    srNames = [];
                    srNames[0] = "Dragunov";
                    srNames[1] = "WA2000";
                    srNames[2] = "L96A1";
                    srNames[3] = "PSG1";
                    self addsliderstring("Sniper Rifles", srIDs, srNames, ::giveuserweapon);
                    
                    hgIDs = [];
                    hgIDs[0] = "asp_mp";
                    hgIDs[1] = "m1911_mp";
                    hgIDs[2] = "makarov_mp";
                    hgIDs[3] = "python_mp";
                    hgIDs[4] = "cz75_mp";

                    hgNames = [];
                    hgNames[0] = "ASP";
                    hgNames[1] = "M1911";
                    hgNames[2] = "Makarov";
                    hgNames[3] = "Python";
                    hgNames[4] = "CZ75";
                    self addsliderstring("Pistols", hgIDs, hgNames, ::giveuserweapon);

                    lnchrIDs = [];
                    lnchrIDs[0] = "m72_law_mp";
                    lnchrIDs[1] = "rpg_mp";
                    lnchrIDs[2] = "strela_mp";
                    lnchrIDs[3] = "china_lake_mp";

                    lnchrNames = [];
                    lnchrNames[0] = "M72 LAW";
                    lnchrNames[1] = "RPG";
                    lnchrNames[2] = "Strela-3";
                    lnchrNames[3] = "China Lake";
                    self addsliderstring("Launchers", lnchrIDs, lnchrNames, ::giveuserweapon);

                    specIDs = [];
                    specIDs[0] = "knife_ballistic_mp";
                    specIDs[1] = "crossbow_explosive_mp";

                    specNames = [];
                    specNames[0] = "Ballistic Knife";
                    specNames[1] = "Crossbow";
                    self addsliderstring("Specials", specIDs, specNames, ::giveuserweapon);

                    sWpnIDs = [];
                    sWpnIDs[0] = "briefcase_bomb_defuse_mp";
                    sWpnIDs[1] = "airstrike_mp";
                    sWpnIDs[2] = "asplh_mp";
                    sWpnIDs[3] = "m1911lh_mp";
                    sWpnIDs[4] = "makarovlh_mp";
                    sWpnIDs[5] = "pythonlh_mp";
                    sWpnIDs[6] = "cz75lh_mp";
                    sWpnIDs[7] = "hs10lh_mp";
                    sWpnIDs[8] = "autoturret_mp";
                    sWpnIDs[9] = "defaultweapon_mp";
                    sWpnIDs[10] = "dog_bite_mp";

                    sWpnNames = [];
                    sWpnNames[0] = "Bomb Briefcase";
                    sWpnNames[1] = "Radio";
                    sWpnNames[2] = "Broken ASP";
                    sWpnNames[3] = "Broken M1911";
                    sWpnNames[4] = "Broken Makarov";
                    sWpnNames[5] = "Broken Python";
                    sWpnNames[6] = "Broken CZ75";
                    sWpnNames[7] = "Broken HS10";
                    sWpnNames[8] = "Stun Trigger";
                    sWpnNames[9] = "Default Weapon";
                    sWpnNames[10] = "WTF is even that";
                    self addsliderstring("Miscellaneous", sWpnIDs, sWpnNames, ::giveuserweapon);
                    break;

                case "afthit":
                    self addMenu("afthit", "Afterhits Menu");

                    arIDs = [];
                    arIDs[0] = "m16_mp";
                    arIDs[1] = "enfield_mp";
                    arIDs[2] = "m14_mp";
                    arIDs[3] = "famas_mp";
                    arIDs[4] = "galil_mp";
                    arIDs[5] = "aug_mp";
                    arIDs[6] = "fnfal_mp";
                    arIDs[7] = "ak47_mp";
                    arIDs[8] = "commando_mp";
                    arIDs[9] = "g11_mp";

                    arNames = [];
                    arNames[0] = "M16";
                    arNames[1] = "Enfield";
                    arNames[2] = "M14";
                    arNames[3] = "Famas";
                    arNames[4] = "Galil";
                    arNames[5] = "AUG";
                    arNames[6] = "FN FAL";
                    arNames[7] = "AK47";
                    arNames[8] = "Commando";
                    arNames[9] = "G11";
                    self addsliderstring("Assault Rifles", arIDs, arNames, ::AfterHit);

                    smgIDs = [];
                    smgIDs[0] = "mp5k_mp";
                    smgIDs[1] = "skorpion_mp";
                    smgIDs[2] = "mac11_mp";
                    smgIDs[3] = "ak74u_mp";
                    smgIDs[4] = "uzi_mp";
                    smgIDs[5] = "pm63_mp";
                    smgIDs[6] = "mpl_mp";
                    smgIDs[7] = "spectre_mp";
                    smgIDs[8] = "kiparis_mp";

                    smgNames = [];
                    smgNames[0] = "MP5K";
                    smgNames[1] = "Skorpion";
                    smgNames[2] = "MAC11";
                    smgNames[3] = "AK74u";
                    smgNames[4] = "Uzi";
                    smgNames[5] = "PM63";
                    smgNames[6] = "MPL";
                    smgNames[7] = "Spectre";
                    smgNames[8] = "Kiparis";
                    self addsliderstring("Submachine Guns", smgIDs, smgNames, ::AfterHit);

                    lmgIDs = [];
                    lmgIDs[0] = "hk21_mp";
                    lmgIDs[1] = "rpk_mp";
                    lmgIDs[2] = "m60_mp";
                    lmgIDs[3] = "stoner63_mp";

                    lmgNames = [];
                    lmgNames[0] = "HK21";
                    lmgNames[1] = "RPK";
                    lmgNames[2] = "M60";
                    lmgNames[3] = "Stoner63";
                    self addsliderstring("Light Machine Guns", lmgIDs, lmgNames, ::AfterHit);

                    sgIDs = [];
                    sgIDs[0] = "rottweil72_mp";
                    sgIDs[1] = "ithaca_mp";
                    sgIDs[2] = "spas12_mp";
                    sgIDs[3] = "hs10_mp";

                    sgNames = [];
                    sgNames[0] = "Olympia";
                    sgNames[1] = "Stakeout";
                    sgNames[2] = "SPAS-12";
                    sgNames[3] = "HS10";
                    self addsliderstring("Shotguns", sgIDs, sgNames, ::AfterHit);
        
                    srIDs = [];
                    srIDs[0] = "dragunov_mp";
                    srIDs[1] = "wa2000_mp";
                    srIDs[2] = "l96a1_mp";
                    srIDs[3] = "psg1_mp";

                    srNames = [];
                    srNames[0] = "Dragunov";
                    srNames[1] = "WA2000";
                    srNames[2] = "L96A1";
                    srNames[3] = "PSG1";
                    self addsliderstring("Sniper Rifles", srIDs, srNames, ::AfterHit);
            
                    hgIDs = [];
                    hgIDs[0] = "asp_mp";
                    hgIDs[1] = "m1911_mp";
                    hgIDs[2] = "makarov_mp";
                    hgIDs[3] = "python_mp";
                    hgIDs[4] = "cz75_mp";

                    hgNames = [];
                    hgNames[0] = "ASP";
                    hgNames[1] = "M1911";
                    hgNames[2] = "Makarov";
                    hgNames[3] = "Python";
                    hgNames[4] = "CZ75";
                    self addsliderstring("Pistols", hgIDs, hgNames, ::AfterHit);    

                    lnchrIDs = [];
                    lnchrIDs[0] = "m72_law_mp";
                    lnchrIDs[1] = "rpg_mp";
                    lnchrIDs[2] = "strela_mp";
                    lnchrIDs[3] = "china_lake_mp";

                    lnchrNames = [];
                    lnchrNames[0] = "M72 LAW";
                    lnchrNames[1] = "RPG";
                    lnchrNames[2] = "Strela-3";
                    lnchrNames[3] = "China Lake";   
                    self addsliderstring("Launchers", lnchrIDs, lnchrNames, ::AfterHit);  

                    specIDs = [];
                    specIDs[0] = "knife_ballistic_mp";
                    specIDs[1] = "crossbow_explosive_mp";

                    specNames = [];
                    specNames[0] = "Ballistic Knife";
                    specNames[1] = "Crossbow";
                    self addsliderstring("Specials", specIDs, specNames, ::AfterHit); 

                    miscIDs = [];
                    miscIDs[0] = "rcbomb_mp";
                    miscIDs[1] = "m202_flash_mp";
                    miscIDs[2] = "briefcase_bomb_mp";
                    miscIDs[3] = "minigun_mp";
                    miscIDs[4] = "claymore_mp";
                    miscIDs[5] = "scrambler_mp";

                    miscNames = [];
                    miscNames[0] = "RC Car";
                    miscNames[1] = "Valkyrie";
                    miscNames[2] = "Bomb";
                    miscNames[3] = "Minigun";
                    miscNames[4] = "Claymore";
                    miscNames[5] = "Jammer";
                    self addsliderstring("Miscellaneous", miscIDs, miscNames, ::AfterHit);  
                    break;

                case "kstrks":
                    self addMenu("kstrks", "Killstreak Menu");
                    kstrkIDs = [];
                    kstrkIDs[0] = "rcbomb_mp";
                    kstrkIDs[1] = "auto_tow_mp";
                    kstrkIDs[2] = "supply_drop_mp";
                    kstrkIDs[3] = "autoturret_mp";
                    kstrkIDs[4] = "m220_tow_mp";
                    kstrkIDs[5] = "helicopter_player_firstperson_mp";
                    kstrkIDs[6] = "m202_flash_mp";

                    kstrkNames = [];
                    kstrkNames[0] = "RC-XD";
                    kstrkNames[1] = "Sam Turret";
                    kstrkNames[2] = "Care Package";
                    kstrkNames[3] = "Sentry Gun";
                    kstrkNames[4] = "Valkyrie Rockets";
                    kstrkNames[5] = "Gunship";
                    kstrkNames[6] = "Grim Reaper";
                    for(a=0;a<kstrkNames.size;a++)
                    self addOpt(kstrkNames[a], ::doKillstreak, kstrkIDs[a]);
                    break;

                case "custom":
                    self addMenu("custom", "Customization Menu");

                    bindIDs = [];
                    bindIDs[0] = "+speed_throw";
                    bindIDs[1] = "+smoke";
                    bindIDs[2] = "+attack";
                    bindIDs[3] = "+frag";
                    bindIDs[4] = "+actionslot 1";
                    bindIDs[5] = "+actionslot 2";
                    bindIDs[6] = "+actionslot 3";
                    bindIDs[7] = "+actionslot 4";
                    bindIDs[8] = "+melee";

                    bindNames = [];
                    bindNames[0] = "[{+speed_throw}]";
                    bindNames[1] = "[{+smoke}]";
                    bindNames[2] = "[{+attack}]";
                    bindNames[3] = "[{+frag}]";
                    bindNames[4] = "[{+actionslot 1}]";
                    bindNames[5] = "[{+actionslot 2}]";
                    bindNames[6] = "[{+actionslot 3}]";
                    bindNames[7] = "[{+actionslot 4}]";
                    bindNames[8] = "[{+melee}]";
                    self addSliderString("Menu Bind 1", bindIDs, bindNames, ::updatePreset, "menuBindOne");

                    bindIDs1 = [];
                    bindIDs1[0] = "+speed_throw";
                    bindIDs1[1] = "+smoke";
                    bindIDs1[2] = "+attack";
                    bindIDs1[3] = "+frag";
                    bindIDs1[4] = "+actionslot 1";
                    bindIDs1[5] = "+actionslot 2";
                    bindIDs1[6] = "+actionslot 3";
                    bindIDs1[7] = "+actionslot 4";
                    bindIDs1[8] = "+melee";
                    bindIDs1[9] = "none";

                    bindNames1 = [];
                    bindNames1[0] = "[{+speed_throw}]";
                    bindNames1[1] = "[{+smoke}]";
                    bindNames1[2] = "[{+attack}]";
                    bindNames1[3] = "[{+frag}]";
                    bindNames1[4] = "[{+actionslot 1}]";
                    bindNames1[5] = "[{+actionslot 2}]";
                    bindNames1[6] = "[{+actionslot 3}]";
                    bindNames1[7] = "[{+actionslot 4}]";
                    bindNames1[8] = "[{+melee}]";
                    bindNames1[9] = "None";
                    self addSliderString("Menu Bind 2", bindIDs1, bindNames1, ::updatePreset, "menuBindTwo");

                    self addDvarToggle("Menu Instructions", "menuInst", ::toggleMenuInst);
                    self addDvarToggle("Almost Hits", "almostHits", ::toggleAlmostHits);
                    self addDvarToggle("Distance", "showDistance", ::toggleDistanceMsg);
                    self addSliderValue("X Position", int( self LoadPreset( "menuPosX", "155" ) ), -565, 315, 80, ::updatePreset, "menuPosX" );
                    self addSliderValue("Y Position", int( self LoadPreset( "menuPosY", "-20" ) ), -180, 300, 80, ::updatePreset, "menuPosY" );
                    self addSliderValue("Red", int( self LoadPreset( "menuColorRed", "245" ) ), 0, 255, 15, ::updatePreset, "menuColorRed" );
                    self addSliderValue("Green", int( self LoadPreset( "menuColorGreen", "230" ) ), 0, 255, 15, ::updatePreset, "menuColorGreen" );
                    self addSliderValue("Blue", int( self LoadPreset( "menuColorBlue", "140" ) ), 0, 255, 15, ::updatePreset, "menuColorBlue" );
                    break;

                case "host":
                    self addMenu("host", "Host Options");
                    self addOpt("Client Menu", ::newMenu, "Verify");
                    self addOpt("Lobby Settings", ::newMenu, "lobby");
                    self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::spawnEnemyBot);
                    self addToggle("Freeze Bots", self.frozenBots, ::toggleFreezeBots);

                    botOptIDs = [];
                    botOptIDs[0] = "teleport";
                    botOptIDs[1] = "kick";

                    botOptNames = [];
                    botOptNames[0] = "Teleport to Crosshairs";
                    botOptNames[1] = "Kick All Bots";
                    self addSliderString("Bot Controls", botOptIDs, botOptNames, ::botControls);
                    
                    self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
                    break;

                case "lobby":
                    self addMenu("lobby", "Lobby Settings");
                    
                    minDist = [];
                    minDist[0] = "15";
                    minDist[1] = "25";
                    minDist[2] = "50";
                    minDist[3] = "100";
                    minDist[4] = "150";
                    minDist[5] = "200";
                    minDist[6] = "250";
                    self addsliderstring("Minimum Distance", minDist, undefined, ::setMinDistance);
                    
                    self addSliderValue("Game Timer", 0, -10, 10, 1, ::editTime);
                    self addOpt("Fast Restart", ::FastRestart);
                    break;
            }
        }
        self clientOptions();
    }

    clientOptions()
    {   
        if(self isHost() || self isdeveloper())
        {
            self addMenu("Verify",  "Clients Menu");

            for( i = 0; i < level.players.size; i++ )
            {
                player = level.players[ i ];
                if (isDefined(player.pers) && isDefined(player.pers["isBot"]) && player.pers["isBot"])
                    continue;
                perm = "None";
                if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                    perm = level.status[player.access];
                
                if (player isDeveloper())
                    perm = perm + " ^7| ^6Developer";

                self addOpt(player getname() + " [" + perm + "^7]", ::newmenu, "Verify_" + player getXUID(), undefined);
            }

            for( i = 0; i < level.players.size; i++ )
            {
                player = level.players[ i ];
                if (isDefined(player.pers) && isDefined(player.pers["isBot"]) && player.pers["isBot"])
                    continue;

                perm2 = "None";
                if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                    perm2 = level.status[player.access];
                self addMenu("Verify_" + player getXUID(), player getName() + " [" + perm2 + "^7]");
                self addOpt("Change Access Level", ::newMenu, "access", undefined);
                self addOpt("Give 28 Kills", ::fastlast, player, undefined);
                self addOpt("Ban Player", ::banSped, player, undefined);
                //self addOpt("Ban Menu", ::newMenu, "banSM", undefined);
                self addOpt("Kick Player", ::kickSped, player, undefined);  
                self addOpt("Teleport to Crosshairs", ::teleportToCrosshair, player, undefined);  
                
                self addMenu("access", "Change Access Level");
                for(a=0;a<level.status.size-1;a++)
                    self addOpt("Give: " + level.status[a], ::initializesetup, a, player);

                /*
                self addMenu("banSM", "Ban Menu");
                self addOpt("Ban Player", ::banSped, player, undefined);
                self addOpt("Add to Ban List", ::banList, "add", player);
                self addOpt("Clear Ban List", ::banList, "clear", undefined);
                */
            }
        }
    }

    menuMonitor()
    {
        self endon("disconnect");
        self endon("end_menu");

        while( self.access != 0 )
        {
            if(!self.menu["isLocked"])
            {
                if(!self.menu["isOpen"])
                {
                    if( isDefined( self.presets["BindTwo"] ) && self.presets["BindTwo"] != "none" )
                    {
                        if( self bindButtonPressed( self.presets["BindOne"] ) && self bindButtonPressed( self.presets["BindTwo"] ) )
                        {
                            self menuOpen();
                            wait .2;
                        }
                    }

                    else
                    {
                        if( self bindButtonPressed( self.presets["BindOne"] ) )
                        {
                            self menuOpen();
                            wait .2;
                        }
                    }
                }

                else
                {
                    if(self actionslotonebuttonpressed() || self actionslottwobuttonpressed())
                    {
                        if(!self actionslotonebuttonpressed() || !self actionslottwobuttonpressed())
                        {
                            if(!self actionslotonebuttonpressed())
                                self.menu[ self getCurrentMenu() + "_cursor" ] += self actionslottwobuttonpressed();
                            if(!self actionslottwobuttonpressed())
                                self.menu[ self getCurrentMenu() + "_cursor" ] -= self actionslotonebuttonpressed();

                            self scrollingSystem();
                            wait .08;
                        }
                    }
                    else if(self actionslotthreebuttonpressed() || self actionslotfourbuttonpressed())
                    {
                        if(!self actionslotthreebuttonpressed() || !self actionslotfourbuttonpressed())
                        {
                            if(isDefined(self.eMenu[ self getCursor() ].val) || IsDefined( self.eMenu[ self getCursor() ].ID_list ))
                            {
                                if( self actionslotthreebuttonpressed() )   
                                    self updateSlider( "L2" );
                                if( self actionslotfourbuttonpressed() )    
                                    self updateSlider( "R2" );
                                wait .1;
                            }
                        }
                    }
                    else if( self useButtonPressed() )
                    {
                        player = self.selected_player;
                        menu = self.eMenu[self getCursor()];

                        if( player != self && self isHost() )
                        {
                            player.was_edited = true;
                            self iPrintLnBold( menu.opt + " Has Been Activated" );
                        }
                        
                        if( self.eMenu[ self getCursor() ].func == ::newMenu && self != player )
                            self iPrintLnBold( "^1Error: ^7Cannot Access Menus While In A Selected Player" );
                        else if(isDefined(self.sliders[ self getCurrentMenu() + "_" + self getCursor() ]))
                        {
                            slider = self.sliders[ self getCurrentMenu() + "_" + self getCursor() ];
                        
                            if( isDefined( menu.ID_list ) )
                                slider = menu.ID_list[slider];
                        
                            else
                                slider = slider;
                        
                            player thread doOption( menu.func, slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );
                        }
                        else 
                            player thread doOption( menu.func, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );

                        wait .05;
                        if(IsDefined( menu.toggle ))
                            self setMenuText();
                        if( player != self )
                            self.menu["OPT"]["MENU_TITLE"] settext( self.menuTitle + " ("+ player getName() +")");    
                        wait .15;
                        if( isDefined(player.was_edited) && self isHost() )
                            player.was_edited = undefined;
                    }
                    else if( self meleeButtonPressed() )
                    {
                        if( self.selected_player != self )
                        {
                            self.selected_player = self;
                            self setMenuText();
                            self refreshTitle();
                        }
                        else if( self getCurrentMenu() == "main" )
                            self menuClose();
                        else 
                            self newMenu();
                        wait .2;
                    }
                }
            }
            wait .05;
        }
    }

    menuOpen()
    {
        self.menu["isOpen"] = true;

        self menuOptions();
        self drawMenu();
        self drawText();
        self setMenuText(); 
        self updateScrollbar();
    }

    menuClose()
    {
        self destroyAll(self.menu["UI"]); 
        self destroyAll(self.menu["OPT"]);
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);
        self.menu["isOpen"] = false;
    }

    drawMenu()
    {
        if(!isDefined(self.menu["UI"]))
            self.menu["UI"] = [];
        if(!isDefined(self.menu["UI_TOG"]))
            self.menu["UI_TOG"] = [];    
        if(!isDefined(self.menu["UI_SLIDE"]))
            self.menu["UI_SLIDE"] = [];
        if(!isDefined(self.menu["UI_STRING"]))
            self.menu["UI_STRING"] = [];    

        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2.0, "TOPLEFT", "CENTER", self.presets["X"] + 125, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        self resizeMenu();
    }

    drawText()
    {
        self destroyAll(self.menu["OPT"]);

        if(!isDefined(self.menu["OPT"]))
            self.menu["OPT"] = [];

        for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText(self.presets["Option_Font"], self.presets["Font_Scale"], "LEFT", "CENTER", self.presets["X"] + 5, self.presets["Y"] - 62 + (e * 15), 3, 1, "", self.presets["Text"]);
    }

    refreshTitle()
    {
        self.menu["UI"]["MENU_TITLE"] settext(level.MenuName);
    }
        
    scrollingSystem()
    {
        if(self getCursor() >= self.eMenu.size || self getCursor() < 0 || self getCursor() == 9)
        {
            if(self getCursor() <= 0)
                self.menu[ self getCurrentMenu() + "_cursor" ] = self.eMenu.size -1;
            else if(self getCursor() >= self.eMenu.size)
                self.menu[ self getCurrentMenu() + "_cursor" ] = 0;
        }
        
        self setMenuText();
        self updateScrollbar();
    }

    updateScrollbar()
    {
        if( self getCursor() >= 10 )
            curs = 9;

        else
            curs = self getCursor();

        self.menu["UI"]["SCROLLER"].y = (self.menu["OPT"][curs].y);
        self.menu["UI"]["SCROLLERICON"].y = (self.menu["OPT"][curs].y);
        
        if( self.eMenu.size >= 10 )
            size = 10;
        else
            size = self.eMenu.size;


        height     = int(15 * size); // 18

        if( self.eMenu.size > 10 )
            math = ((180 / self.eMenu.size) * size);
        else
            math = (height - 15);

        position_Y = (self.eMenu.size-1) / ((height - 15) - math);
    } 

    setMenuText( sliderKey )
    {
        self endon("disconnect");
        self menuOptions();
        self resizeMenu();

        if( self getCursor() >= 10 )
            ary = ( self getCursor() - 9 );
        else
            ary = 0;
			
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);
        
        for(e=0;e<10;e++)
        {
            self.menu["OPT"][e].x = self.presets["X"] + 61; 
            
            if(isDefined(self.eMenu[ ary + e ].opt))
                self.menu["OPT"][e] settext( self.eMenu[ ary + e ].opt );
            else 
                self.menu["OPT"][e] settext("");
                
            if(IsDefined( self.eMenu[ ary + e ].toggle ))
            {
                self.menu["OPT"][e].x += 0; 
                color = dividecolor(150, 150, 150);

                if ( self.eMenu[ ary + e ].toggle )
                    color = self.presets["Toggle_BG"];

                self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["OPT"][e].x + 189, self.menu["OPT"][e].y, 7, 7, color, "white", 5, 1);
            }
            if(IsDefined( self.eMenu[ ary + e ].val ))
            {
                sliderKey = self getCurrentMenu() + "_" + (ary + e);
                if(!isDefined(self.sliders[sliderKey]))
                    self.sliders[sliderKey] = self.eMenu[ ary + e ].val;

                self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 38, 1, (0,0,0), "white", 4, 1); //BG
                self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 188, self.menu["UI_SLIDE"][e].y, 1, 6, self.presets["Toggle_BG"], "white", 5, 1); //INNER
                
                self.menu["UI_SLIDE"]["VAL_" + e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 150, self.menu["OPT"][e].y, 5, 1, self.sliders[sliderKey] + "", self.presets["Text"], undefined, true);
                
                self updateSlider( "", e, ary + e );
            }
            if(IsDefined( self.eMenu[ (ary + e) ].ID_list ) )
            {
                if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + (ary + e) ] ))
                    self.sliders[ self getCurrentMenu() + "_" + (ary + e) ] = 0;
                    
                self.menu["UI_SLIDE"]["STRING_"+e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 6, 1, "", self.presets["Text"], undefined, true);
                self updateSlider( "", e, ary + e );
            }
            if(self.eMenu[ ary + e ].func == ::newMenu && IsDefined( self.eMenu[ ary + e ].func ) )
            {
                self.menu["UI_SLIDE"]["SUBMENU"+e] = self createtext("objective", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 196, self.menu["OPT"][e].y - 0.75, 5, 1, ">", (1,1,1), undefined, true);
                self.menu["UI_SLIDE"]["SUBMENU"+e].foreground = true;
            }
        }
    }
        
    resizeMenu()
    {
        if( self.eMenu.size >= 10 )
            size = 10;
        else
            size = self.eMenu.size;

        height = int(15 * size);

        if( self.eMenu.size > 10 )
            math = (( 180 / self.eMenu.size ) * size );
        else
            math = ( height - 15 );
        
        self.menu["UI"]["OPT_BG"] SetShader( "white", 200, height + 1 );
        self.menu["UI"]["OUTLINE"] SetShader( "white", 204, height + 54 );
    }


// Structs

    initializeSetup( access, player )
    {
        if(isDefined(player.access) && access == player.access && !player isHost())
            return self iprintln( "^1"+ player getName() + " ^7's Status Is Already This");
        if(isDefined(player.access) && player.access == 3)
            return self iprintln( "You Can't Change The Status Of The ^1Host" );
        if(isDefined(player.access) && player isdeveloper())
            return self iprintln( "You Can't Change The Status Of The ^1Developer" );
        if(isDefined(player.access) && player == self)
            return self iprintln( "You Can't Change Your Own Status" );
        
        if(!isDefined(player.menu))
            player.menu = [];
        if(!isDefined(player.previousMenu))   
            player.previousMenu = [];      
            
        player notify("end_menu");
        player.access = access;
        
        if( player isMenuOpen() )
            player menuClose();

        player.menu         = [];
        player.previousMenu = [];
        player.hud_amount   = 0;
        
        player.selected_player = player;
        player.menu["isOpen"] = false;
        
        player LoadSettings();

        if( !isDefined(player.menu["current"]) )
            player.menu["current"] = "main";
            
        if( player.access > 0 )
        {
            player FreezeControls(false);
            player registercustomdvars(); 

            if( !level.rankedMatch )
            {
                player dowelcomemessage();
                player thread bulletImpactMonitor();
                player thread trackstats();
            }

            player thread changeClass();
            player thread menuInst();
            player thread mainBinds();                   

            player menuoptions();
            player thread menuMonitor();
        }
    }

    registerCustomDvars()
    {
        if( !isDefined( self GetPlayerCustomDvar( "menuInst" ) ) || self GetPlayerCustomDvar( "menuInst" ) == "" )
            self SetPlayerCustomDvar( "menuInst", "1" );   

        if( !isDefined( self GetPlayerCustomDvar( "suicideBind" ) ) || self GetPlayerCustomDvar( "suicideBind" ) == "" )
            self SetPlayerCustomDvar( "suicideBind", "1" );  

        if( !isDefined( self GetPlayerCustomDvar( "showDistance" ) ) || self GetPlayerCustomDvar( "showDistance" ) == "" )
            self SetPlayerCustomDvar( "showDistance", "1" );   

        if( !isDefined( self GetPlayerCustomDvar( "almostHits" ) ) || self GetPlayerCustomDvar( "almostHits" ) == "" )
            self SetPlayerCustomDvar( "almostHits", "1" );  
    }

    newMenu( menu )
    {
	    access = 0 ;
        if( access >= self.access )
            return self IPrintLn( "Access: ^1Denied" );
        if(!isDefined( menu ))
        {
            menu = self.previousMenu[ self.previousMenu.size -1 ];
            self.previousMenu[ self.previousMenu.size -1 ] = undefined;
        }
        else 
            self.previousMenu[ self.previousMenu.size ] = self getCurrentMenu();
            
        self setCurrentMenu( menu );
        self menuOptions();
        self setMenuText();
        self refreshTitle();
        self resizeMenu();
        self updateScrollbar();
    }

    addMenu( menu, title )
    {
        self.storeMenu = menu;
        if(self getCurrentMenu() != menu)
            return;
            
        self.eMenu = [];
        self.menuTitle = title;
        if(!isDefined(self.menu[ menu + "_cursor"]))
            self.menu[ menu + "_cursor"] = 0;
    }


    addOpt( opt, func, p1, p2, p3, p4, p5 )
    {
        if(self.storeMenu != self getCurrentMenu())
            return;
        option      = spawnStruct();
        option.opt  = opt;
        option.func = func;
        option.p1   = p1;
        option.p2   = p2;
        option.p3   = p3;
        option.p4   = p4;
        option.p5   = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    addToggle( opt, bool, func, p1, p2, p3, p4, p5 )
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        
        option = spawnStruct();

        option.toggle = (IsDefined( bool ) && bool);
        option.opt    = opt;
        option.func   = func;
        option.p1     = p1;
        option.p2     = p2;
        option.p3     = p3;
        option.p4     = p4;
        option.p5     = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    addSliderValue( opt, val, min, max, mult, func, p1, p2, p3, p4, p5 )
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        option      = spawnStruct();
        option.opt  = opt;
        option.val  = val;
        option.min  = min;
        option.max  = max;
        option.mult = mult;
        option.func = func;
        option.p1   = p1;
        option.p2   = p2;
        option.p3   = p3;
        option.p4   = p4;
        option.p5   = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    addSliderString( opt, ID_list, RL_list, func, p1, p2, p3, p4, p5 )
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        option      = spawnStruct();
        
        if(!IsDefined( RL_list ))
            RL_list = ID_list;

        if( inArray( ID_list ) )
            option.ID_list = ID_list;
        else
            option.ID_list = strTok( ID_list, ";" );

        if( inArray( RL_list ) )
            option.RL_list = RL_list;
        else
            option.RL_list = strTok( RL_list, ";" );

        option.opt  = opt;
        option.func = func;
        option.p1   = p1; 
        option.p2   = p2;
        option.p3   = p3; 
        option.p4   = p4;
        option.p5   = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    inarray(arry)
    {
        if(!isDefined(arry) || IsString(arry))
            return false;

        if(arry.size)
            return true;
        
        return false;
    }

    updateSlider( pressed, elementIndex, selectionIndex )
    {    
        if ( !isDefined( elementIndex ) )
        {
            curs = self getCursor(); 
            if( curs >= 10 )
                elementIndex = 9;
            else
                elementIndex = curs;
        }
        
        if ( !isDefined( selectionIndex ) )
        {
            selectionIndex = self getCursor();
        }

        position_x = abs(self.eMenu[ selectionIndex ].max - self.eMenu[ selectionIndex ].min) / ((50 - 14));
        
        if( IsDefined( self.eMenu[ selectionIndex ].ID_list ) )
        {
            value = self.sliders[ self getCurrentMenu() + "_" + selectionIndex ];
            
            if( pressed == "R2" ) value++;
            if( pressed == "L2" ) value--;
                
            if( value > self.eMenu[ selectionIndex ].ID_list.size-1 )   value = 0;
            if( value < 0 ) value = self.eMenu[ selectionIndex ].ID_list.size-1;

            self.sliders[ self getCurrentMenu() + "_" + selectionIndex ] = value;

            if(isDefined(self.menu["UI_SLIDE"]["STRING_"+ elementIndex]))
                self.menu["UI_SLIDE"]["STRING_"+ elementIndex] setSliderText( "< "+ self.eMenu[ selectionIndex ].RL_list[ value ] +" >" );
            return;
        }

        if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + selectionIndex ] ))
            self.sliders[ self getCurrentMenu() + "_" + selectionIndex ] = self.eMenu[ selectionIndex ].val;
        
        if( pressed == "R2" )   self.sliders[ self getCurrentMenu() + "_" + selectionIndex ] += self.eMenu[ selectionIndex ].mult;
        if( pressed == "L2" )   self.sliders[ self getCurrentMenu() + "_" + selectionIndex ] -= self.eMenu[ selectionIndex ].mult;
        
        if( self.sliders[ self getCurrentMenu() + "_" + selectionIndex ] > self.eMenu[ selectionIndex ].max )
            self.sliders[ self getCurrentMenu() + "_" + selectionIndex ] = self.eMenu[ selectionIndex ].min;
        if( self.sliders[ self getCurrentMenu() + "_" + selectionIndex ] < self.eMenu[ selectionIndex ].min )
            self.sliders[ self getCurrentMenu() + "_" + selectionIndex ] = self.eMenu[ selectionIndex ].max;  
        
        self.menu["UI_SLIDE"][elementIndex + 10].x = self.menu["UI_SLIDE"][elementIndex].x - 38 + (abs(self.sliders[ self getCurrentMenu() + "_" + selectionIndex ] - self.eMenu[ selectionIndex ].min) / position_x);
        
        value = self.sliders[ self getCurrentMenu() + "_" + selectionIndex ];
        
        if(isDefined(self.menu["UI_SLIDE"]["VAL_" + elementIndex]))
            self.menu["UI_SLIDE"]["VAL_" + elementIndex] setSliderText( value + "" );
    }

    setCurrentMenu( menu )
    {
        self.menu["current"] = menu;
    }

    getCurrentMenu()
    {
        return self.menu["current"];
    }

    getCursor()
    {
        return self.menu[ self getCurrentMenu() + "_cursor" ];
    }

    setCursor( val )
    {
        self.menu[ self getCurrentMenu() + "_cursor" ] = val;
    }

    isMenuOpen()
    {
        if(isDefined(self.menu["isOpen"]))
            return true;
        return false;
    }


    createText(font, fontScale, align, relative, x, y, sort, alpha, text, color, isLevel, skipSafe)
    {
        if( isDefined( isLevel ) )
            textElem = level createServerFontString(font, fontScale);
        else
            textElem = self createFontString(font, fontScale);
		
		textElem setPoint(align, relative, x, y);

        textElem.hideWhenInKillcam = true;
        textElem.hideWhenInMenu = true;
        textElem.foreground = true;
        textElem.archived = true;
        textElem.sort = sort;
        textElem.alpha = alpha;
        textElem.color = color;

        if(isDefined(skipSafe) && skipSafe)
            textElem setSliderText(text);
        else
            textElem setText(text);

        return textElem;
    }
    
    createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha, server)
    {
        player = self;

        if( isDefined( server ) )
            boxElem = newHudElem();
        else
            boxElem = newClientHudElem(self);

        boxElem.elemType = "icon";
        boxElem.color = color;

        boxElem.hideWhenInKillcam = true;
        boxElem.hideWhenInMenu = true;
        boxElem.archived = true;

        if(player.hud_amount >= 19)
            boxElem.archived = false;
        
        boxElem.width          = width;
        boxElem.height         = height;
        boxElem.align          = align;
        boxElem.relative       = relative;
        boxElem.xOffset        = 0;
        boxElem.yOffset        = 0;
        boxElem.children       = [];
        boxElem.sort           = sort;
        boxElem.alpha          = alpha;
        boxElem.shader         = shader;

        boxElem setShader(shader, width, height);
        boxElem.hidden = false;
        boxElem setPoint(align, relative, x, y);
        boxElem thread watchDeletion(player);
        
        player.hud_amount++;
        return boxElem;
    }

    isInArray( array, text )
    {
        for(e=0;e<array.size;e++)
            if( array[e] == text )
                return true;
        return false;        
    }

    removeFromArray( array, text )
    {
        new = [];
    
        for( i = 0; i < array.size; i++ )
        {
            if( array[i] != text )
                new[new.size] = array[i];
        }
    
        return new;
    }


    getName()
    {
        nT = getSubStr(self.name, 0, self.name.size);
        for(i=0;i<nT.size;i++)
            if(nT[i] == "]")
                break;

        if(nT.size!=i)
            nT = getSubStr(nT, i + 1, nT.size);
        return nT;
    }

    destroyAll(array)
    {
        if(!isDefined(array))
            return;
        keys = getArrayKeys(array);
        for(a=0;a<keys.size;a++)
            if(isDefined(array[ keys[ a ] ][ 0 ]))
                for(e=0;e<array[ keys[ a ] ].size;e++)
                    array[ keys[ a ] ][ e ] destroy();
        else
            array[ keys[ a ] ] destroy();
    }

    hudFade(alpha, time)
    {
        self fadeOverTime(time);
        self.alpha = alpha;
        wait time;
    }

    hudMoveX(x, time)
    {
        self moveOverTime(time);
        self.x = x;
        wait time;
    }

    hudMoveY(y, time)
    {
        self moveOverTime(time);
        self.y = y;
        wait time;
    }

    divideColor(c1,c2,c3)
    {
        return(c1/255,c2/255,c3/255);
    }

    watchDeletion( player )
    {
        player endon("disconnect");
        self waittill("death");
        if( player.hud_amount > 0 )
            player.hud_amount--;
    }

    hudMoveXY(time,x,y)
    {
        self moveOverTime(time);
        self.y = y;
        self.x = x;
    }

    refreshMenuToggles()
    {
        for( i = 0; i < level.players.size; i++ )
        {
            player = level.players[i];
            if( player hasMenu() && player isMenuOpen() )
                player setMenuText();
        }
    }

    hasMenu()
    {
        if( IsDefined( self.access ) && self.access != "None" )
            return true;
        return false;    
    }

    lockMenu( which, type )
    {
        if(toLower(which) == "lock")
        {
            if(self isMenuOpen() && toLower(type) != "open")
            {
                current  = self getCurrentMenu();
                previous = self.previousMenu;
                for(e = previous.size; e > 0; e--)
                    self newMenu();
                self menuClose(); 
            }
            self.menu["isLocked"] = true;
        }
        else 
        {
            if(!self isMenuOpen() && toLower(type) == "open")
                self menuOpen();
            else     
                self setMenuText();    
            self.menu["isLocked"] = false;
            self notify("menu_unlocked");
        }
    }

    hudFadeDestroy(alpha, time)
    {
        self fadeOverTime(time);
        self.alpha = alpha;
        wait time;
        self destroy();
    }

    hudFadeColor(color,time)
    {
        self FadeOverTime(time);
        self.color = color;
    }

    SetTextFX(text,time)
    {
        if(!isDefined(time))
            time = 3;
            
        self settext(text);
        self thread hudFade(1,.5);
        self SetPulseFx(int(1.5 * 25), int(time * 1000), 1000);
        wait time;
        self hudFade(0, .5);
        self destroy();
    }

    doOption(func, p1, p2, p3, p4, p5, p6)
    {
        if(!isdefined(func))
            return;
        
        if(isdefined(p6))
            self thread [[func]](p1,p2,p3,p4,p5,p6);
        else if(isdefined(p5))
            self thread [[func]](p1,p2,p3,p4,p5);
        else if(isdefined(p4))
            self thread [[func]](p1,p2,p3,p4);
        else if(isdefined(p3))
            self thread [[func]](p1,p2,p3);
        else if(isdefined(p2))
            self thread [[func]](p1,p2);
        else if(isdefined(p1))
            self thread [[func]](p1);
        else
            self thread [[func]]();
    }
        
    sponge_text( string )
    {
        sponge = "";
        for(e=0;e<string.size;e++)
        {
            if ( e % 2 )
                sponge += toUpper( string[e] );
            else
                sponge += toLower( string[e] );
        }
    
        return sponge;
    }

    toUpper( string )
    {
        if( !isDefined( string ) || string.size <= 0 )
            return "";
        alphabet = strTok("A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R;S;T;U;V;W;X;Y;Z;0;1;2;3;4;5;6;7;8;9; ;-;_", ";");
        final    = "";
        for(e=0;e<string.size;e++)
            for(a=0;a<alphabet.size;a++)
                if(IsSubStr(toLower(string[e]), toLower(alphabet[a])))         
                    final += alphabet[a];
        return final;            
    }

    isDeveloper()
    {
        switch(self getxuid())
        {
            case "901fc5263b283": return true; //akaTrxgic
            default:              return false;
        }
    }

    vectorScale(vector,scale)
    {
        vector = (vector[0] * scale,vector[1] * scale,vector[2] * scale);
        return vector;
    }

    hudFadenDestroy(alpha,time)
    {
        self FadeOverTime(time);
        self.alpha = alpha;
        wait time;
        self destroy();
    }

    isConsole()
    {
        return level.console;
    }

    LoadSettings()
    {
        self.presets = [];

        self.presets["X"] = int( self LoadPreset( "menuPosX", "155" ) );
        self.presets["Y"] = int( self LoadPreset( "menuPosY", "-20" ) );
        self.presets["R"] = int( self LoadPreset( "menuColorRed", "245" ) );
        self.presets["G"] = int( self LoadPreset( "menuColorGreen", "230" ) );
        self.presets["B"] = int( self LoadPreset( "menuColorBlue", "140" ) );
        self.presets["BindOne"] = self loadPreset( "menuBindOne", "+speed_throw" );
        self.presets["BindTwo"] = self loadPreset( "menuBindTwo", "+actionslot 2" );

        self.presets["Option_BG"] = dividecolor(27, 27, 29);
        self.presets["Outline_BG"] = dividecolor(27, 27, 29);
        self.presets["Title_BG"] = dividecolor(255, 255, 255); 
        self.presets["Text"] = dividecolor(255, 255, 255);
        self.presets["Option_Font"] = "default";
        self.presets["Font_Scale"] = 1;
        self.presets["Toggle_BG"] = dividecolor(self.presets["R"], self.presets["G"], self.presets["B"]);
        self.presets["MenuTitle_Color"] = dividecolor(self.presets["R"], self.presets["G"], self.presets["B"]);
        self.presets["Scroller_BG"] = dividecolor(self.presets["R"], self.presets["G"], self.presets["B"]);
        self.presets["Scroller_Shader"] = "hudsoftline";
    }

    bindButtonPressed( button )
    {
        switch( button )
        {
            case "+speed_throw": return self AdsButtonPressed();
            case "+smoke": return self SecondaryOffhandButtonPressed();
            case "+attack": return self AttackButtonPressed();
            case "+frag": return self FragButtonPressed();
            case "+melee": return self MeleeButtonPressed();
            case "+actionslot 1": return self ActionSlotOneButtonPressed();
            case "+actionslot 2": return self ActionSlotTwoButtonPressed();
            case "+actionslot 3": return self ActionSlotThreeButtonPressed();
            case "+actionslot 4": return self ActionSlotFourButtonPressed();

            default: return;
        }
    }

    loadPreset( dvar, defaultVal )
    {
        value = "";

        value = self getPlayerCustomDvar( dvar );

        if( value == "" )
            return defaultVal;

        return value;
    }

    updatePreset( value, dvar )
    {
        current = self getPlayerCustomDvar( dvar );

        if( current != value + "" )
        {
            self setPlayerCustomDvar( dvar, value + "" );
            wait .02;
            self LoadSettings();
            self refreshMenu();
        }
    }

    refreshMenu( current, previous )
    {
        if(!self hasMenu())
            return false;
            
        if(self isMenuOpen())
        { 
            current  = self getCurrentMenu();
            previous = self.previousMenu;

            for(e = previous.size; e > 0; e--)
            {
                self newMenu();
                wait .05;
                waittillframeend;
            }
            self menuClose(); 
            self.menu["isLocked"] = true;
        }
        
        wait .05;
        
        self menuOpen();
        if(IsDefined( previous ))
        {
            for( i = 0; i < previous.size; i++ )
            {
                if( previous[i] != "main" )
                    self newMenu( previous[i] );
            }

            self newMenu( current );
            self.menu["isLocked"] = false;
        }
    }

    toggleAlmostHits()
    {
        if( self getplayercustomdvar( "almostHits" ) == "1" )
            self setplayerCustomDvar( "almostHits", "0" );

        else
            self setplayercustomdvar( "almostHits", "1" );
    }

    toggleDistanceMsg()
    {
        if( self getplayercustomdvar( "showDistance" ) == "1" )
            self setplayerCustomDvar( "showDistance", "0" );

        else
            self setplayercustomdvar( "showDistance", "1" );
    }

    GetDistance(you, them)
    {
        dx = you.origin[0] - them.origin[0];
        dy = you.origin[1] - them.origin[1];
        dz = you.origin[2] - them.origin[2];    
        return floor(Sqrt((dx * dx) + (dy * dy) + (dz * dz)) * 0.03048);
    }

    greencrateLocation1()
    {
        self endon("disconnect");
        level endon("game_ended");

        mapName = level.currentMapName;
        spawnLocations = [];

        for(i = -3; i < 3; i++)
        {
            for(d = -3; d < 3; d++)
            {
                if (mapName == "mp_nuked") 
                {
                    spawnLocations[0] = (3722.89, 12221.2, 3778.52);
                    spawnLocations[1] = (-176.716, -8530.06, 3100.1);
                    spawnLocations[2] = (-6044.9, 840.61, 2904.33);
                } 

                else if (mapName == "mp_array") 
                    spawnLocations[0] = (-3693.71, 12239.5, 3939.71);

                else if (mapName == "mp_radiation") 
                {
                    spawnLocations[0] = (-817.408, -5206.03, 2637.54);
                    spawnLocations[1] = (-4291.16, 785.343, 2003.31);
                    spawnLocations[2] = (-376.241, 7292.82, 1805.27);
                }

                else if (mapName == "mp_cracked")
                    spawnLocations[0] = (-1746.1, -4883.62, 574.74);
                
                else if(mapName == "mp_crisis")
                {
                    spawnLocations[0] = (-5748.65, 415.442, 1785.81);
                    spawnLocations[1] = (10115.2, 424.233, 4229.94);
                }

                else if(mapName == "mp_duga")
                    spawnLocations[0] = (108.001, 2328.06, 3247.1);

                else if(mapName == "mp_cosmodrome")
                {
                    spawnLocations[0] = (2531.77, -2217.04, 1887.63);
                    spawnLocations[1] = (2534.83, -6.35055, 1887.23);       
                }

                else if(mapName == "mp_mountain")
                {
                    spawnLocations[0] = (4665.13, 1613.21, 1116.93);
                    spawnLocations[1] = (3397.42, -5086.48, 2836.9);
                    spawnLocations[2] = (-368.874, 333.844, 1856.18);
                }

                else if(mapName == "mp_russianbase")
                {
                    spawnLocations[0] = (2126.6, -4917, 3734.69);
                    spawnLocations[1] = (-1334.47, 3209.59, 791.472);
                    spawnLocations[2] = (3955.7, 919.906, 2155.37);
                }

                else if(mapName == "mp_villa")
                    spawnLocations[0] = (10348.4, 4352.82, 3906.91);

                else if(mapName == "mp_silo")
                    spawnLocations[0] = (7042.24, 6759.94, 4056.28);

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

        for ( i = 0; i < hurt_triggers.size; i++ )
        {
            barrier = hurt_triggers[i];

            if ( barrier.origin[2] <= 0 )
                barrier.origin = barrier.origin - ( 0, 0, value );
        }
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

    doWelcomeMessage( mode )
    {
        switch( level.currentGametype )
        {
            case "dm":
            mode = "FFA";
            break;

            case "sd":
            mode = "SND";
            break;

            case "tdm":
            mode = "TDM";
            break;
        }

        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise " + mode +"!");
    }

    fastLast( player )
    {
        if( !isDefined( player ) ) player = self;

        switch( level.currentGametype )
        {
            case "dm":
            player.pointstowin = 29;
            player.kills   = 29;
            player.score   = 1450;
            player.pers["pointstowin"] = 29;
            player.pers["kills"] = 29;
            player.pers["score"] = 1450;
            break;

            case "tdm":
            maps\mp\gametypes\_globallogic_score::_setTeamScore(player.pers["team"], 7400);
            break;
        }
    }

    changeClass()
    {
        self endon("disconnect");

        game["strings"]["change_class"] = "";

        for(;;)
        {
            self waittill("changed_class");
            self thread maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
            wait .1;
        }
    }

    mainBinds()
    {
        self endon("disconnect");
        
        for(;;)
        {
            if(self getStance() == "crouch" && self meleeButtonPressed() && !self.menu["isOpen"])
            {
                self thread refillAmmo();
                wait 0.3;
            }

            if( !level.rankedMatch )
            {
                if( self getPlayerCustomDvar( "suicideBind" ) == "1" )
                {
                    if(self secondaryoffhandButtonPressed() && self fragbuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread kys();
                        wait 0.3;
                    }
                }
            }
            wait 0.05;
        }
    }

    kys()
    {
        self suicide();
    }

    refillAmmo()
    {
        self givemaxammo(self getprimary());
        self givemaxammo(self getsecondary());
        self givestartammo(self getcurrentoffhand());
        self givestartammo(self getoffhandsecondaryclass());
        wait .4;
    }

    getprimary()
    {
        class = self.class;
        class_num      = int( class[class.size-1] )-1; 
        primaryweapon  = self.custom_class[class_num]["primary"];
        return primaryweapon;
    }

    getsecondary()
    {
        class = self.class;
        class_num      = int( class[class.size-1] )-1; 
        secondaryweapon = self.custom_class[class_num]["secondary"];
        return secondaryweapon;
    }

    bulletImpactMonitor(nearestPlayer, weapon)
    {
        self endon("disconnect");
        level endon("game_ended");

        for(;;)
        {
            self waittill("weapon_fired");

            eAttacker = self;

            if(self isOnGround())
                continue;

            start = self getTagOrigin("tag_eye");
            end = anglestoforward(self getPlayerAngles()) * 1000000;
            impact = BulletTrace(start, end, true, self)["position"];
            nearestDist = 150;

            hostTeam = (getDvar("host_team"));
            enemyTeam = getOtherTeam(eAttacker.team);


            for( i = 0; i < level.players.size; i++ )
            {
                player = level.players[i];
                dist = distance(player.origin, impact);

                weapon = self getcurrentweapon();

                if(dist < nearestDist && isdamageweapon(weapon) && player != self)
                {
                    nearestDist = dist;
                    nearestPlayer = player;
                }
            }

            if(nearestDist != 150)
            {
                ndist = nearestDist * 0.0254;
                ndist_i = int(ndist);

                if( ndist_i < 1 )
                    ndist = getSubStr( ndist, 0, 3 );
                else
                    ndist = ndist_i;

                distToNear = distance(self.origin, nearestPlayer.origin) * 0.0254;
                dist = int(distToNear);

                if( dist < 1 )
                    getSubStr( distToNear, 0, 3 );
                else
                    distToNear = dist;

                if(level.currentGametype == "dm")  
                    if(self.kills == 29 && isAlive(nearestPlayer) && isDamageWeapon(weapon) && self getplayercustomdvar( "almostHits" ) == "1" )
                        self thread registerAlmostHit(nearestPlayer, dist);
            }
        }
    }

    registerAlmostHit(nearestPlayer, dist)
    {
        iprintln("^2" + self.name + "^7 almost hit ^1" + nearestPlayer.name + " ^7from ^1" + dist + "m^7!");
        self.ahCount++;

        if(self.ahCount % 3 == 0) self iprintlnbold( "^1" + rndmmgfunnymsg() );
    }

    trackstats()
    {
        self endon("disconnect");
        level waittill("game_ended");

        if( self getplayercustomdvar( "almostHits" ) == "1" )
            return;

        if(level.currentGametype == "dm")
        {
            wait 0.5;

            if(self.ahCount == 1) self iprintln("You almost hit ^1" + self.ahCount + " ^7time!");

            else if(self.ahCount > 0) self iprintln("You almost hit ^1" + self.ahCount + " ^7times!");
            
            else self iprintln("You didn't almost hit ^1anyone^7! " + self rndmEGfunnyMsg());
        }
    }

    rndmMGfunnyMsg()
    {
        MGfunnyMsg = [];
        MGfunnyMsg[0] = "Almost had it. Gotta be quicker than that";
        MGfunnyMsg[1] = "'If you hit, i'll let you fuck me.' -Jams";
        MGfunnyMsg[2] = "Maybe the next one will connect..Maybe";
        MGfunnyMsg[3] = "Even the bots are embarassed for you";
        MGfunnyMsg[4] = "I've seen better reflexes from a toaster";
        MGfunnyMsg[5] = "You're the final boss of disappointment";
        MGfunnyMsg[6] = "You suck. But less than you did yesterday!";
        MGfunnyMsg[7] = "Still trash, but I see the potential!";
        MGfunnyMsg[8] = "That was garbage - but inspiring garbage!";
        MGfunnyMsg[9] = "You missed, but with confidence. Respect";
        MGfunnyMsg[10] = "Damn that was ugly, but improvement is ugly!";
        MGfunnyMsg[11] = "You didn't hit it but you believed you would";
        MGfunnyMsg[12] = "You're improving..painfully..slowly..but improving";
        MGfunnyMsg[13] = "Not the worst i've seen. Today that is";
        MGfunnyMsg[14] = "Keep trying. Statistically, something will connect. Eventually";
        MGfunnyMsg[15] = "You're one step closer to being average";
        MGfunnyMsg[16] = "That sucked..but you're trying and that counts. I guess";
        MGfunnyMsg[17] = "Is your little brother playing for you or what?";
        MGfunnyMsg[18] = "You're not bad, you're consistent. At being bad";
        MGfunnyMsg[19] = "At this point, just turn on EB";

        return MGfunnyMsg[RandomInt(MGfunnyMsg.size)];
    }

    rndmEGfunnyMsg()
    {
        EGfunnyMsg = [];
        EGfunnyMsg[0] = "Even aim assist gave up on you";
        EGfunnyMsg[1] = "Stick to your day job!";
        EGfunnyMsg[2] = "Just sell your console dawg.";
        EGfunnyMsg[3] = "You aim like a blindfolded potato";
        EGfunnyMsg[4] = "Just delete the game bro";
        EGfunnyMsg[5] = "Next time try playing with your eyes open";
        EGfunnyMsg[6] = "You're the reason friendly fire exists";
        EGfunnyMsg[7] = "Is your controller upside down or what?";
        EGfunnyMsg[8] = "Failure builds character. You must have a ton";
        EGfunnyMsg[9] = "You're bad but hey - at least you're consistent";
        EGfunnyMsg[10] = "You've got heart. No skill, but heart";
        EGfunnyMsg[11] = "You make AFK players look useful";
        EGfunnyMsg[12] = "If skill was money, you'd be broke";
        EGfunnyMsg[13] = "Your aim has commitment issues";
        EGfunnyMsg[14] = "You missed every shot. Impressive. Depressing, but impressive";
        EGfunnyMsg[15] = "Your existence lowers the lobby's IQ";
        EGfunnyMsg[16] = "You need scripts my guy";
        EGfunnyMsg[17] = "What are you doing, bird hunting?";
        EGfunnyMsg[18] = "Get off the sticks and log back into Roblox";
        EGfunnyMsg[19] = "Your KD is crying right now";

        return EGfunnyMsg[RandomInt(EGfunnyMsg.size)];
    }

    giveUserLethal(lethal)
    {
        self GiveWeapon( lethal );
        self SetWeaponAmmoClip( lethal, 1);
        self SwitchToOffhand( lethal );
    }

    giveUserTactical(tactical)
    {
        self giveWeapon( tactical );
        self SetWeaponAmmoClip( tactical, 2 );
    }

    giveUserEquipment(newEquipment)
    {
        self GiveWeapon(newEquipment);
        self SetActionSlot( 1, "weapon", newEquipment);
    }  

    GetWeaponValidAttachments(weapon)
    {
        attachments = [];

        column = TableLookUp("mp/statsTable.csv", 4, weapon, 8);

        if(!isDefined(column) || column == "")
            return attachments;

        parts = strTok(column, " ");

        for(i = 0; i < parts.size; i++)
        {
            if(parts[i] != "")
                attachments[attachments.size] = parts[i];
        }

        return attachments;
    }

    takeOffhands()
    {
        offhands = [];
        offhands[0] = "frag_grenade_mp";
        offhands[1] = "sticky_grenade_mp";
        offhands[2] = "hatchet_mp";
        offhands[3] = "willy_pete_mp";
        offhands[4] = "tabun_gas_mp";
        offhands[5] = "flash_grenade_mp";
        offhands[6] = "concussion_grenade_mp";
        offhands[7] = "nightingale_mp";
        offhands[8] = "camera_spike_mp";
        offhands[9] = "satchel_charge_mp";
        offhands[10] = "tactical_insertion_mp";
        offhands[11] = "scrambler_mp";
        offhands[12] = "acoustic_sensor_mp";
        offhands[13] = "claymore_mp";
        
        if(self hasweapon(offhands))
            self takeweapon(offhands);
    }

    loadLoadout() 
    {
        self takeAllWeapons();
        self takeOffhands();
        
        if (!isDefined(self.primaryWeaponList) && self getPlayerCustomDvar("loadoutSaved") == "1") 
        {
            for (i = 0; i < int(self getPlayerCustomDvar("primaryCount")); i++)
                self.primaryWeaponList[i] = self getPlayerCustomDvar("primary" + i);

            for (i = 0; i < int(self getPlayerCustomDvar("secondaryCount")); i++) 
                self.offHandWeaponList[i] = self getPlayerCustomDvar("secondary" + i);
        }

        for (i = 0; i < self.primaryWeaponList.size; i++) 
        {
            if (!isDefined(self.camo) || self.camo == 0) 
                self.camo = randomcamo();

            weapon = self.primaryWeaponList[i];
            weaponOptions = self calcWeaponOptions(self.camo, self.currentLens, self.currentReticle, 0);
            self giveWeapon(weapon, 0, weaponOptions);
            self giveMaxAmmo(weapon);
        }

        self switchToWeapon(self.primaryWeaponList[0]);
        self setSpawnWeapon(self.primaryWeaponList[0]);
        self giveWeapon("knife_mp");

        for (i = 0; i < self.offHandWeaponList.size; i++) 
        {
            weapon = self.offHandWeaponList[i];

            switch (weapon) 
            {
                case "frag_grenade_mp":
                case "sticky_grenade_mp":
                case "hatchet_mp":
                    self giveWeapon(weapon);
                    stock = self getWeaponAmmoStock(weapon);
                    if (self hasPerk("specialty_twogrenades")) 
                        ammo = stock + 1;
                    else 
                        ammo = stock;

                    self setWeaponAmmoStock(weapon, ammo);
                    break;

                case "flash_grenade_mp":
                case "concussion_grenade_mp":
                case "tabun_gas_mp":
                case "nightingale_mp":
                    self giveWeapon(weapon);
                    stock = self getWeaponAmmoStock(weapon);
                    if (self hasPerk("specialty_twogrenades")) 
                        ammo = stock + 1;
                    else 
                        ammo = stock;
        

                    self setWeaponAmmoStock(weapon, ammo);
                    break;

                case "willy_pete_mp":
                    self giveWeapon(weapon);
                    stock = self getWeaponAmmoStock(weapon);
                    ammo = stock;
                    self setWeaponAmmoStock(weapon, ammo);
                    break;

                case "claymore_mp":
                case "tactical_insertion_mp":
                case "scrambler_mp":
                case "satchel_charge_mp":
                case "camera_spike_mp":
                case "acoustic_sensor_mp":
                    self giveWeapon(weapon);
                    self giveStartAmmo(weapon);
                    self setActionSlot(1, "weapon", weapon);
                    break;
                    
                default:
                    self giveWeapon(weapon);
                    break;
            }
        }
    }

    givePlayerAttachment(attachment, newWeapon)
    {
        weapon      = self GetCurrentWeapon(); 
        prefix      = strtok(weapon, "_");
        baseName    = prefix[0];
        attachments = [];
        attachments[0] = prefix[1];
        attachments[1] = prefix[2];
        stock       = self GetWeaponAmmoStock(weapon);
        clip        = self GetWeaponAmmoClip(weapon);
        newAttachments = [];

        if(attachment == "dw")
        {
            newWeapon = baseName + "dw_mp";
            self takeweapon(weapon);
            wait .1;
            self giveweapon(newWeapon);
            self switchtoweapon(newWeapon);
        }
        else
        {
            if(HasAttachment(weapon, attachment))
            {
                for(a = 0; a < attachments.size; a++)
                {
                    if(attachments[a] != attachment && attachments[a] != "mp")
                    {
                        keep = attachments[a];
                        newWeapon = baseName + "_" + keep + "_mp";
                    }
                    else
                    {
                        keep = "";
                        newWeapon = baseName + "_mp";
                    }
                }
            }
            else
            {
                if(attachment != "none")
                {
                        for(a = 0; a < attachments.size; a++)
                        {
                            if(attachments[a] != "mp")
                            {
                                newAttachments[0] = attachment;
                                newAttachments[1] = attachments[a];
                            }
                            if(isDefined(newAttachments))
                                break;
                        }
                }
            
                if(!isDefined(newAttachments) && newAttachments != "mp")
                {
                    newAttachments[0] = attachment;
                    newAttachments[1] = "";
                }
            
                if(newAttachments[1] == "")
                    newWeapon = baseName + "_" + newAttachments[0] + "_mp";
                else
                    newWeapon = baseName + "_" + newAttachments[0] + "_" + newAttachments[1] + "_mp";
            }
            
            self TakeWeapon(weapon);
            self GiveWeapon(newWeapon, 0);
            self SetWeaponAmmoClip(newWeapon, clip);
            self SetWeaponAmmoStock(newWeapon, stock);
            self SetSpawnWeapon(newWeapon);

            if(self getcurrentweapon() != newWeapon)
            {
                self iPrintln("^1Error: ^7Invalid attachment");
                self giveWeapon(weapon);
                self switchToWeapon(weapon);
            }
        }       
    }

    botsGetKnives()
    {
        if (!isDefined(self.pers["isBot"]) || !self.pers["isBot"])
            return;

        if(self getcurrentweapon() != "knife_mp")
        {
            self takeallweapons();
            self giveweapon("knife_mp");
            self switchtoweapon("knife_mp");
            self setspawnweapon("knife_mp");
        }
    }

    botSetup()
    {
        if (!isDefined(self.pers["isBot"]) || !self.pers["isBot"])
            return;

        self clearperks();
        self setRank(randomintrange(0, 49), randomintrange(0, 15));
        self thread botsCantWin();
    }

    doBots()
    {
        hostTeam = (getDvar("host_team"));

        if( hostTeam == "allies" )
            team = "axis";

        else
            team = "allies";

        if(level.currentGametype == "dm")
        {
            level.i = 0;
            while (level.i < 18) 
            {
                wait .125;
                spawnEnemyBot();
                level.i++;
                wait 0.5;
            }
        }

        else if(level.currentGametype == "sd")
        {
            if(getteamplayersalive(!hostTeam) <= 1)
                spawnEnemyBot(3, !hostTeam);
        }

        else if(level.currentGametype == "tdm")
        {
            if(getteamplayersalive(!hostTeam) <= 1 )
                spawnEnemyBot(6, !hostTeam);
        }
    }

    spawnEnemyBot(num, team) 
    {
        if(!isdefined(num))
            num = 1;

        if(!isDefined(team))
            team = self.pers["team"];
        
        bot = [];

        for(i=0;i<num;i++)
        {
            bot[i] = addtestclient();
            if(!isDefined(bot[i]))
            {
                wait 1.5;
                continue;
            }
            bot[i].pers["isBot"] = true;
            bot[i] thread maps\mp\gametypes\_bot::bot_spawn_think(getOtherTeam(team));
            wait .75;
        }
    }

    hasBots()
    {
        for(i=0; i < level.players.size; i++)
        {
            if(isDefined(level.players[i].pers["isBot"]) && level.players[i].pers["isBot"])
                return true;
        }

        return false;
    }

    botsCantWin()
    {
        self endon( "disconnect" );
        level endon( "game_ended" );

        for(;;)
        {
            wait 0.25;

            if(self.pers["kills"] >= 20 || self.kills >= 20)
            {
                self.pers["kills"] = 0;         
                self.pers["score"] = 0;         
                self.pers["deaths"] = 0;        
                self.pers["headshots"] = 0;       
                self.kills     = 0;                 
                self.deaths    = 0;                
                self.headshots = 0;
                self.score     = 0;
            }
        }
    }

    menuInst()
    {
        self endon( "disconnect" );
        self endon( "game_ended" );

        menuInst = self createFontString( "objective", 1 );

        self.menuInst = menuInst;

        menuInst.x = -30;
        menuInst.y = 430;

        if( self getPlayerCustomDvar( "menuInst" ) == "0" )
            menuInst.alpha = 0;
        else
            menuInst.alpha = 1;

        if( isDefined( self.presets["BindTwo"] ) && self.presets["BindTwo"] != "none" )
            instString = "[{" + self.presets["BindOne"] + "}] + [{" + self.presets["BindTwo"] + "}] = Paradise";
        
        else
            instString = "[{" + self.presets["BindOne"] + "}] = Paradise";
        
        menuInst settext( instString );

        self thread monitorMenuState( menuInst );
    }

    monitorMenuState( menuInst )
    {
        self endon( "disconnect" );
        self endon( "game_ended" );

        for( ;; )
        {
            wait 0.05;

            if( isDefined( self.menu["isOpen"] ) && self.menu["isOpen"] )
                instString = "[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select [{+melee}] = Back/Close";

            else
            {
                if( isDefined( self.presets["BindTwo"] ) && self.presets["BindTwo"] != "none" )
                    instString = "[{" + self.presets["BindOne"] + "}] + [{" + self.presets["BindTwo"] + "}] = Paradise";
                else
                    instString = "[{" + self.presets["BindOne"] + "}] = Paradise";
            }

            menuInst setText( instString );
        }
    }

    toggleMenuInst()
    {
        if( self GetPlayerCustomDvar( "menuInst" ) == "1" )
        {
            self SetPlayerCustomDvar( "menuInst", "0" );

            if( isDefined( self.menuInst ) )
                self.menuInst.alpha = 0;
        }
        
        else
        {
            self SetPlayerCustomDvar( "menuInst", "1" );

            if( isDefined( self.menuInst ) )
                self.menuInst.alpha = 1;
        }
    }

    randomCamo()
    {
        numEro = randomIntRange(1,16); 
        weap = self getCurrentWeapon();  
        myclip = self getWeaponAmmoClip(weap);  
        mystock = self getWeaponAmmoStock(weap);  
        self takeWeapon(weap);  
        weaponOptions = self calcWeaponOptions(numEro,0,0,0,0);  
        self GiveWeapon(weap,0,weaponOptions);  
        self switchToWeapon(weap);
        self setSpawnWeapon(weap);
        self setweaponammoclip(weap,myclip);  
        self setweaponammostock(weap,mystock);  

        self.camo = numEro;  
    }

//Menu Funcs

    UFOMode()
    {
        if(level.oomUtilDisabled)
        {
            self iprintln("^1ERROR^7: UFO use is [^1Disabled^7]!");
            return;
        }

        if(!isDefined( self.UFOMode ))
        {
            self.UFOMode = true;
            self thread UFODude();
        }
        else
        {
            self.UFOMode = undefined;
            self notify("stop_ufo");
        }
    }

    UFODude()
    {
        self endon("stop_ufo");
        self endon("unverified");

        if(isdefined(self.N))
        self.N delete();
        self.N  = spawn("script_origin", self.origin);
        self.On = 0;
        for(;;)
        {
            if(self secondaryoffhandbuttonpressed())
            {
                self.On       = 1;
                self.N.origin = self.origin;
                self linkto(self.N);
            }
            else
            {
                self.On = 0;
                self unlink();
            }
            if(self.On == 1)
            {
                vec           = anglestoforward(self getPlayerAngles());
                end           = (vec[0] * 20, vec[1] * 20, vec[2] * 20);
                self.N.origin = self.N.origin+end;
            }
            wait 0.05;
        }
    }

    kickSped(player)
    {
        if (!player isHost() || player != self || !player isDeveloper()) Kick(player GetEntityNumber());
        
        else self iPrintln("^1ERROR: ^7Can't Kick Player");
    }  

    banSped(player)
    {
        if (!player isHost() || player != self || !player isDeveloper())
        {
            SetDvar("Paradise_"+player GetXUID(),"Banned");
            Kick(player GetEntityNumber());
            self iPrintln(player getName()+" Has Been ^1Banned");
        }
        
        else self iPrintln("^1ERROR: ^7Can't Ban Player");
    }

    teleportToCrosshair(player)
    {
        if (isAlive(player))
            player setOrigin(bullettrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, 0, self)["position"]);
    }

    AfterHit(gun)
    {
        self endon("afterhit");
        self endon( "disconnect" );

        if(!self.AfterHit)
        {
            self iprintln("Afterhit Weapon set: [^2" + gun + "^7]");
            self thread doAfterHit(gun);
            self.AfterHit = 1;
        }
        else
        {
            self iprintln("Afterhits [^1OFF^7]");
            self.AfterHit = 0;
            KeepWeapon = "";
            self notify("afterhit");
        }
    }

    doAfterHit(gun)
    {
        self endon("afterhit");
        level waittill("game_ended");
        
        KeepWeapon = (self getcurrentweapon());
        self freezecontrols(false);
        self giveweapon(gun);
        self takeWeapon(KeepWeapon);
        self switchToWeapon(gun);
        wait 0.02;
        self freezecontrols(true);
    }

    Canzoom(num)
    {
        if( isDefined( self.Canzoom ))
        {
            self iPrintLn("Canzoom bind [^1OFF^7]");
            self.Canzoom = undefined; 
        }   
        
        else
        {
            self iPrintLn("Press [{+Actionslot " + num + "}] to ^2Can Zoom");
            self.Canzoom = true;

            while(isDefined(self.Canzoom))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                wait 0.01; 
            } 
        } 
    }

    CanzoomFunction()
    {
        self.canswapWeap = self getCurrentWeapon();
        self takeWeapon(self.canswapWeap);
        self giveweapon(self.canswapWeap);
        wait 0.05;
        self setSpawnWeapon(self.canswapWeap);
    }

    nacModSave(num)
    {
        if(num == 1)
        {
            self.wep1 = self getCurrentWeapon();
            self iPrintln("Weapon 1 Selected: [^2" + self.wep1 + "^7]");
        }
        else if(num == 2)
        {
            self.wep2 = self getCurrentWeapon();
            self iPrintln("Weapon 2 Selected: [^2" + self.wep2 + "^7]");
        }
    }

    nacModBind(num)
    {
        if( isDefined( self.NacBind ))
        {
            self iPrintLn("Nac Bind [^1OFF^7]");
            self.NacBind = undefined; 
            self.wep1    = undefined;
            self.wep2    = undefined;
            self iPrintLn("Nac Weapons ^1Reset");
        }
        
        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Nac");
            self.NacBind = true;
            
            while(isDefined(self.NacBind))
            {
                if( self GetStance() != "prone"  && !self meleebuttonpressed() )
                {
                    if(num == 1)
                    {
                        if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                    else if(num == 2)
                    {
                        if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                    else if(num == 3)
                    {
                        if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                    else if(num == 4)
                    {
                        if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                }
                wait 0.01;
            } 
        } 
    }

    heliosNac()
    {
        if(self.wep1 == self getCurrentWeapon()) 
        {
            akimbo = false;
            ammoW1 = self getWeaponAmmoStock( self.wep1 );
            ammoCW1 = self getWeaponAmmoClip( self.wep1 );
            self takeWeapon(self.wep1);
            self switchToWeapon(self.wep2);
            while(!(self getCurrentWeapon() == self.wep2))
            
            if (self isHost())
                wait .1;
            
            else
                wait .15;
            
            self giveWeapon(self.wep1);
            self setweaponammoclip( self.wep1, ammoCW1 );
            self setweaponammostock( self.wep1, ammoW1 );
        }
        else if(self.wep2 == self getCurrentWeapon()) 
        {
            ammoW2 = self getWeaponAmmoStock( self.wep2 );
            ammoCW2 = self getWeaponAmmoClip( self.wep2 );
            self takeWeapon(self.wep2);
            self switchToWeapon(self.wep1);
            while(!(self getCurrentWeapon() == self.wep1))
            
            if (self isHost())
                wait .1;
            
            else
                wait .15;
            
            self giveWeapon(self.wep2);
            self setweaponammoclip( self.wep2, ammoCW2 );
            self setweaponammostock( self.wep2, ammoW2 );
        } 
    }

    skreeModSave(num)
    {
        if(num == 1)
        {
            self.snacwep1 = self getCurrentWeapon();
            self iPrintln("Weapon 1 Selected: [^2" + self.snacwep1 + "^7]");
        }
        else if(num == 2)
        {
            self.snacwep2 = self getCurrentWeapon();
            self iPrintln("Weapon 2 Selected: [^2" + self.snacwep2 + "^7]");
        }
    }

    skreeBind(num)
    {
        if( isDefined( self.SnacBind ))
        {
            self iPrintLn("Skree Bind [^1OFF^7]");
            self.SnacBind = undefined; 
            snacwep1      = undefined;
            snacwep2      = undefined;
            self iPrintLn("Skree Weapons ^1Reset");
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Skree");
            self.SnacBind = true;
            
            while(isDefined(self.SnacBind))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    {
                        if(self getCurrentWeapon() == self.snacwep1)
                        {
                            self SetSpawnWeapon( self.snacwep2 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep1 );
                        }
                        else if(self getCurrentWeapon() == self.snacwep2)
                        {
                            self SetSpawnWeapon( self.snacwep1 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep2 );
                        } 
                    }
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    {
                        if(self getCurrentWeapon() == self.snacwep1)
                        {
                            self SetSpawnWeapon( self.snacwep2 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep1 );
                        }
                        else if(self getCurrentWeapon() == self.snacwep2)
                        {
                            self SetSpawnWeapon( self.snacwep1 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep2 );
                        } 
                    }
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    {
                        if(self getCurrentWeapon() == self.snacwep1)
                        {
                            self SetSpawnWeapon( self.snacwep2 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep1 );
                        }
                        else if(self getCurrentWeapon() == self.snacwep2)
                        {
                            self SetSpawnWeapon( self.snacwep1 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep2 );
                        } 
                    }
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    {
                        if(self getCurrentWeapon() == self.snacwep1)
                        {
                            self SetSpawnWeapon( self.snacwep2 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep1 );
                        }
                        else if(self getCurrentWeapon() == self.snacwep2)
                        {
                            self SetSpawnWeapon( self.snacwep1 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep2 );
                        } 
                    }
                }
                wait 0.01; 
            } 
        } 
    }

    gFlipBind(num)
    {
        if( isDefined( self.Gflip ))
        {
            self iPrintLn("GFlip bind [^1OFF^7]");
            self notify("stopProne1");
            self.Gflip = undefined;
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2GFlip");
            self.Gflip = true;

            while(isDefined(self.Gflip))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                wait 0.01; 
            } 
        } 
    }

    MidAirGflip()
    {
        self endon("stopProne1");
        self setStance("prone");
        wait 0.01;
        self setStance("prone");
    }

    botControls(action)
    {
        if(action == "teleport")
            self tpBots();

        else if(action == "kick")
            self kickallbots();
    }

    kickAllBots()
    {
        players = level.players;

        for ( i = 0; i < players.size; i++ )
        {
            player = players[i];    
            if(IsDefined(player.pers[ "isBot" ]) && player.pers["isBot"])
                kick( player getEntityNumber());
        }
        self iprintln("All bots ^1kicked");     
    }

    toggleFreezeBots()
    {
        if( isDefined( self.frozenBots ) )
        {
            players = level.players;
            for( i = 0; i < players.size; i++ )
            {
                player = players[ i ];

                if( isDefined( player.pers["isBot"] ) && player.pers["isBot"] )
                    player freezeControls(false);
            }

            self.freezeBotsLoop = undefined;
            self.frozenBots = undefined;
        }

        else
        {
            self.frozenBots = true;
            self.freezeBotsLoop = true;
            self thread freezeBotsThread();
        }
    }

    freezeBotsThread()
    {
        while ( isDefined( self.freezeBotsLoop ) )
        {
            players = level.players;
            for (i = 0; i < players.size; i++)
            {
                player = players[i];
                if (isDefined(player.pers["isBot"]) && player.pers["isBot"])
                    player freezeControls(true);
            }
            wait 0.025;
        }
    }

    tpBots()
    {
        players = level.players;

        for ( i = 0; i < players.size; i++ )
        {   
            player = players[i];

            if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
                player setorigin(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"]);
        }
        self iprintln("All Bots ^1Teleported");
    }

    giveUserWeapon(weapon, akimbo, camo) 
    {      
        self giveWeapon(weapon);
        self switchToWeapon(weapon);
        self giveMaxAmmo(weapon);
    }

    getBaseName(weapon)
    {
        prefix = strtok(weapon, "_");
        base = prefix[0];
        return base;
    }

    getAttachments(weapon)
    {
        prefix = strtok(weapon, "_");
        attachments = [];
        attachments[0] = prefix[1];
        attachments[1] = prefix[2];

        return attachments;
    }

    HasAttachment(weapon, attachment)
    {
        attachments = getattachments(weapon);
        
        for(a=0;a<attachments.size;a++)
            if(attachments[a] == attachment)      
                return true;
        
        return false;
    }  

    takeWpn()
    {
        self takeweapon(self getcurrentweapon());
    }

    toggleInfEquip()
    {
        self.infEquipOn = !isDefined(self.infEquipOn) || !self.infEquipOn;

        if (self.infEquipOn)
            self thread InfEquipment();
        else
            self notify("noMoreInfEquip");
    }


    InfEquipment()
    {
        self endon("disconnect");
        self endon("noMoreInfEquip");

        for (;;)
        {
            wait 0.1;
            currentoffhand = self getcurrentoffhand();
            if (currentoffhand != "none")
                self givemaxammo(currentoffhand);
        }
    }

    dropWpn() 
    {
        self dropItem(self getCurrentWeapon());
    }

    doUnstuck()
    {
        player = self;  
    
        if (!isAlive(player)) 
            return;  

        FAR = 25; 
        pos = player.origin; 

        
        pos = physicsTrace(pos, pos + (0, 0, FAR), false, player);
        pos += (0, 0, 1); 

    
        pos = physicsTrace(pos, pos + (0, 0, FAR), false, player);
        pos = playerPhysicsTrace(pos, pos - (0, 0, FAR * 2), false, player);

    
        player setOrigin(pos);
    }

    tptoSpawn()
    {
        self setOrigin( self.lastSpawnPoint.origin + ( 0, 0, 10 ) );
    }

    toggleSuiBind()
    {
        if( self getPlayerCustomDvar( "suicideBind" ) == "1" )
            self setPlayerCustomDvar( "suicideBind", "0" );
        
        else
            self setPlayerCustomDvar( "suicideBind", "1" );
    }

    setPlayerCustomDvar(dvar, value) 
    {
        dvar = self getXuid() + "_" + dvar;
        setDvar(dvar, value);
    }

    getPlayerCustomDvar(dvar) 
    {
        dvar = self getXuid() + "_" + dvar;
        return getDvar(dvar);
    }

    saveLoadout() 
    {
        wait .01;
            
        self.primaryWeaponList = self getWeaponsListPrimaries();
        self.offHandWeaponList = isExclude(self getWeaponsList(), self.primaryWeaponList);
        self.offHandWeaponList = removeValueFromArray(self.offHandWeaponList, "knife_mp");

        for (i = 0; i < self.primaryWeaponList.size; i++) 
            self setPlayerCustomDvar("primary" + i, self.primaryWeaponList[i]);

        for (i = 0; i < self.offHandWeaponList.size; i++)
            self setPlayerCustomDvar("secondary" + i, self.offHandWeaponList[i]);

        self setPlayerCustomDvar("primaryCount", self.primaryWeaponList.size);  
        self setPlayerCustomDvar("secondaryCount", self.offHandWeaponList.size);
    }

    isExclude(array, array_exclude)
    {
        newarray = array;

        if (inarray(array_exclude))
        {
            for (i = 0; i < array_exclude.size; i++)
            {
                exclude_item = array_exclude[i];
                removeValueFromArray(newarray, exclude_item);
            }
        }
        else
            removeValueFromArray(newarray, array_exclude);

        return newarray;
    }

    removeValueFromArray(array, valueToRemove)
    {
        newArray = [];
        for (i = 0; i < array.size; i++)
        {
            if (array[i] != valueToRemove)
                newArray[newArray.size] = array[i];
        }
        return newArray;
    }

    changeCamo(camoNum)
    {
        num = int( camoNum );
        weap    = self getCurrentWeapon();
        myclip  = self getWeaponAmmoClip(weap);
        mystock = self getWeaponAmmoStock(weap);  
        self takeWeapon(weap);   

        weaponOptions = self calcWeaponOptions(num,0,0,0,0);
        self GiveWeapon(weap,0,weaponOptions); 

        self switchToWeapon(weap);  
        self setSpawnWeapon(weap); 
        self setweaponammoclip(weap,myclip);  
        self setweaponammostock(weap,mystock);  
        self.camo = num;  
    }

    saveLoadoutToggle()
    {
        if( self getPlayerCustomDvar( "loadoutSaved" ) == "1" )
            self setPlayerCustomDvar( "loadoutSaved", "0" );

        else
        {
            self setPlayerCustomDvar( "loadoutSaved", "1" );
            self saveLoadout();
        }
    }

    sohToggle()
    {
        if( self getPlayerCustomDvar( "SOH" ) == "1" )
        {
            self unsetPerk( "specialty_fastads" );
            self unsetPerk( "specialty_fastreload" );   
            self setPlayerCustomDvar( "SOH", "0" );
        } 

        else
        {
            self setPerk( "specialty_fastads" );
            self setPerk( "specialty_fastreload" );   
            self setPlayerCustomDvar( "SOH", "1" );
        }
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
            for( i = 0; i < level.players.size; i++ )
            {
                player = level.players[i];
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

                if(player.UFOMode)
                {
                    player notify("stop_ufo");
                    player.UFOMode = 0;
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
        SetDvar("scr_"+level.gametype+"_timelimit", setTime);
        wait .05;
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

    tpToSpot(coords)
    {
        if( level.oomUtilDisabled )
        {
            self iprintln("^1ERROR^7: Teleporting is [^1Disabled^7]!");
            return;
        }

        else
            self setorigin(coords);
    }

    saveandload()
    {
        if(!self.snl)
        {
            self iprintln( "To Save: Prone + [{+Attack}]");
            self iprintln( "To Load: Crouch + [{+actionslot 2}]" );
            self thread dosaveandload();
            self.snl = 1;
        }
        else
        {
            self.snl = 0;
            self notify( "SaveandLoad" );
        }
    }

    dosaveandload()
    {
        self endon( "disconnect" );
        self endon( "SaveandLoad" );

        while(self.pers["SavingandLoading"])
        {
            if( self.snl && self attackbuttonpressed()  && self GetStance() == "prone" )
            {
                self.a = self.angles;
                self.pers["savedLocation"] = self.origin;
                self iprintln( "Position ^2Saved" );
                wait 2;
            }

            if( self.snl && self actionslottwobuttonpressed() && self GetStance() == "crouch")
            {
                self setplayerangles(self.a);
                self setOrigin(self.pers["savedLocation"]);
                wait 2;
            }
            wait 0.05;
        }
    }

    setSpawn()
    {
        if(!self.savedPos|| self.savedPos)
        {
            self.spawnCoords = self getOrigin(self.origin) + (0, 0, 1);
            self.spawnAngles = self.angles;
            self.savedPos = 1;
            self iprintln("Spawn: ^2Set");

            while(self.savedPos)
            {
                self waittill( "spawned_player" );
                wait .1;
                self setorigin(self.spawnCoords);
                self.angles = self.spawnAngles;
            }
        }
    }

    unsetSpawn()
    {
        if(self.savedPos)
        {
            self.spawnCoords = undefined;
            self.spawnAngles = undefined;
            self.savedPos = 0;
            self iprintln("Spawn: ^1Reset");
        }
    }

        instashoot()
    {
        if( isDefined( self.instashoot ))
        {
            self.instashoot = undefined;
            self notify( "stop_Instashoots" );
        }

        else
        {
            self.instashoot = true;
            self thread instaShootLoop();
        }
    }

    instaShootLoop()
    {
        self endon( "disconnect" );
        self endon( "stop_Instashoots" );

        for(;;)
        {
            self waittill( "weapon_change" );

            self disableweapons();
            wait .0001;
            self enableWeapons();
            wait .0001;
        }
    }

    SetCanswapMode(type)
    {
        if(type == "Current") 
        {
            if(!self.currCan)
            {
                self.currCan = 1;
                self.InfiniteCan = 0;
                self.currCanWpn = self getcurrentweapon();
                self iprintln("Canswap Weapon: [^2" + self.currCanWpn + "^7]");
                self thread CurrCanswapLoop();
            }

            else if(self.currCan)
            {
                self.currCan = 0;
                self iprintln("Canswap Mode: [^1OFF^7]");
                return;
            }
        }
        else if(type == "Infinite") 
        {
            if(!self.InfiniteCan)
            {
                self.InfiniteCan = 1;
                self.currCan     = 0;       
                self iprintln("Canswap Mode: [^2Infinite^7]");
                self thread InfiniteCanswapLoop();
            }
            else if(self.InfiniteCan)
            {
                self.InfiniteCan = 0;
                self iprintln("Canswap Mode: [^1OFF^7]");
                return;
            }
        }
    }

    CurrCanswapLoop()
    {
        weapon = self.currCanWpn;

        while(self.currCan)
        {
            self waittill("weapon_change", weapon);
            self.WeapClip  = self getWeaponAmmoClip(self.currCanWpn);
            self.WeapStock = self getWeaponAmmoStock(self.currCanWpn);
            self takeWeapon(self.currCanWpn);
            waittillframeend;
            self giveWeapon(self.currCanWpn);
            self setWeaponAmmoStock(self.currCanWpn, self.WeapStock);
            self setWeaponAmmoClip(self.currCanWpn, self.WeapClip);
        }
    }

    InfiniteCanswapLoop()
    {
        while(self.InfiniteCan)
        {
            currentWeapon = self getCurrentWeapon();
            if(currentWeapon != "none")
            {
                self.WeapClip  = self getWeaponAmmoClip(currentWeapon);
                self.WeapStock = self getWeaponAmmoStock(currentWeapon);
                self takeWeapon(currentWeapon);
                waittillframeend;
                self giveWeapon(currentWeapon);
                self setWeaponAmmoStock(currentWeapon, self.WeapStock);
                self setWeaponAmmoClip(currentWeapon, self.WeapClip);
            }
            self waittill("weapon_change", currentWeapon);
        }
    }

    doTwoPiece()
    {
        if(level.currentGametype == "dm")
        {
            self.kills   = 28;
            self.score   = 1400;
            self.pers["pointstowin"] = 28;
            self.pers["kills"] = 28;
            self.pers["score"] = 1400;
        }
    }

    dropCanswap()
    {
        weap = "hk21_mp";
        self giveweapon(weap);
        self dropitem(weap);
    }

    samTurretBind(num)
    {
        if( isDefined( self.basedSAM ))
        {
            self iPrintLn("Walking SAM Bind [^1OFF^7]");
            self.basedSAM = undefined; 
        }
        
        else
        {
            self iPrintLn("Press [{+actionslot " + num +"}] for ^2Walking SAM");
            self.basedSAM = true;

            while(isDefined(self.basedSAM))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useTowTurret(self);
                        self enableWeapons();
                    }
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useTowTurret(self);
                        self enableWeapons();
                    }
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useTowTurret(self);
                        self enableWeapons();
                    }
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useTowTurret(self);
                        self enableWeapons();
                    }
                }
                wait .001; 
            }
        }
    }

    sentryBind(num)
    {
        if( isDefined( self.basedSentry ))
        {
            self iPrintLn("Walking Sentry Bind [^1OFF^7]");
            self.basedSentry = undefined;
        }   

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] for ^2Walking Sentry");
            self.basedSentry = true;

            while(isDefined(self.basedSentry))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                        self enableWeapons();
                    }
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                        self enableWeapons();
                    }
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                        self enableWeapons();
                    }
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                        self enableWeapons();
                    }
                }
                wait .001; 
            }
        }
    }

    cowboyBind(num)
    {
        if( isDefined( self.CowboyBind ))
        {
            self iPrintLn("Cowboy bind [^1OFF^7]");
            self.CowboyBind = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Cowboy");
            self.CowboyBind = true;

            while(isDefined(self.CowboyBind))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingCowboy)
                        {
                            self.DoingCowboy = true;
                            self setClientDvar("cg_gun_z", "8");
                        }
                        else
                        {
                            self.DoingCowboy = false;
                            self setClientDvar("cg_gun_z", "0");
                        }
                    }
                } 
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingCowboy)
                        {
                            self.DoingCowboy = true;
                            self setClientDvar("cg_gun_z", "8");
                        }
                        else
                        {
                            self.DoingCowboy = false;
                            self setClientDvar("cg_gun_z", "0");
                        }
                    }
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingCowboy)
                        {
                            self.DoingCowboy = true;
                            self setClientDvar("cg_gun_z", "8");
                        }
                        else
                        {
                            self.DoingCowboy = false;
                            self setClientDvar("cg_gun_z", "0");
                        }
                    }
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingCowboy)
                        {
                            self.DoingCowboy = true;
                            self setClientDvar("cg_gun_z", "8");
                        }
                        else
                        {
                            self.DoingCowboy = false;
                            self setClientDvar("cg_gun_z", "0");
                        }
                    }
                }
                wait .001; 
            }
        } 
    }

    rvrsCowboyBind(num)
    {
        if( isDefined( self.rcowboy ))
        {
            self iprintln("Reverse Cowboy [^1OFF^7]");
            self.rcowboy = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Reverse Cowboy");
            self.rcowboy = true;

            while(isDefined(self.rcowboy))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingrCowboy)
                        {
                            self.Doingrcowboy = true;
                            self setClientDvar("cg_gun_z", "-5");
                        }
                        else
                        {
                            self.Doingrcowboy = false;
                            self setClientDvar("cg_gun_z", "0");
                        }
                    }
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingrCowboy)
                        {
                            self.Doingrcowboy = true;
                            self setClientDvar("cg_gun_z", "-5");
                        }
                        else
                        {
                            self.Doingrcowboy = false;
                            self setClientDvar("cg_gun_z", "0");
                        }
                    }
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingrCowboy)
                        {
                            self.Doingrcowboy = true;
                            self setClientDvar("cg_gun_z", "-5");
                        }
                        else
                        {
                            self.Doingrcowboy = false;
                            self setClientDvar("cg_gun_z", "0");
                        }
                    }
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingrCowboy)
                        {
                            self.Doingrcowboy = true;
                            self setClientDvar("cg_gun_z", "-5");
                        }
                        else
                        {
                            self.Doingrcowboy = false;
                            self setClientDvar("cg_gun_z", "0");
                        }
                    }
                }
                wait .001; 
            } 
        } 
    }

    classBind(classNum)
    {
        if( isDefined( self.ChangeClass ))
        {   
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
        
        else
        {
            self iPrintLn("Press [{+Actionslot 2}] to ^2Change Class");

            self.ChangeClass = true;

            while(isDefined(self.ChangeClass))
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM" + classNum);

                wait .001; 
            }
        }
    }

    fillLobby()
    {
        level.i = 0;

        while (level.i < 18) 
        {
            wait .125;
            spawnEnemyBot();
            level.i++;
            wait 0.5;
        }
        self iprintln("Lobby ^1filled");
    }

    doKillstreak(killstreak)
    {
        self maps\mp\gametypes\_hardpoints::giveKillstreak(killstreak);
    }

    monitortrampoline(model)
    {
        self endon("disconnect");
        level endon("game_ended");

        for (;;)
        {
            if (!isDefined(model))
                break;

            if (distance(self.origin, model.origin) < 85)
                self setVelocity(self getVelocity() + (0, 0, 5000));

            wait 0.01;
        }
    }

    slide()
    {
        if (isDefined(self.slideThread))
        {
            self.slidethread delete();
            self.slideThread = undefined;
        }
        if (isDefined(self.spawnedSlide))
        {
            self.spawnedSlide delete();
            self.spawnedSlide = undefined;
        }
        self.spawnedSlide = spawn("script_model",
            bullettrace(
                self gettagorigin("j_head"),
                self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 100,
                0,
                self
            )["position"] + (0, 0, 20)
        );

        self.spawnedSlide.angles = (0, self getPlayerAngles()[1] - 90, 60);
        self.spawnedSlide setModel("mp_supplydrop_ally");
        self.slideThread = self thread makeSlide(self.spawnedSlide);
    }

    makeSlide(slideEntity)
    {
        level endon("game_ended");
        self endon("disconnect");
        self endon("stop_slide");

        for (;;)
        {
            if (!isDefined(slideEntity)) 
            {
                break;
            }

            for (i = 0; i < level.players.size; i++)
            {
                player = level.players[i];

                if (isDefined(slideEntity) && player isInPos(slideEntity.origin) && player meleeButtonPressed() && !self.menu["isOpen"])
                {
                    player setOrigin(player getOrigin() + (0, 0, 10));
                    playngles2 = anglesToForward(player getPlayerAngles());
                    x = 0;

                    player setVelocity(player getVelocity() + (playngles2[0] * 750, playngles2[1] * 750, 0));

                    while (x < 15)
                    {
                        player setVelocity(player getVelocity() + (0, 0, 750));
                        x++;
                        wait 0.01;
                    }

                    wait 1;
                }
            }

            wait 0.01;
        }
    }

    isInPos(sP) 
    {
        if (distance(self.origin, sP) < 100) 
            return true;
        else 
            return false;
    }

    doSpawnables( action, type )
    {
        switch( type )
        {
            case "slide":
            if( action == "Delete" )
            {
                if (isDefined(self.slideThread))
                {
                    self.slidethread delete();
                    self.slideThread = undefined;
                }
                if (isDefined(self.spawnedSlide))
                {
                    self.spawnedSlide delete();
                    self.spawnedSlide = undefined;
                }
            }

            else
            {
                if (isDefined(self.slideThread))
                {
                    self.slidethread delete();
                    self.slideThread = undefined;
                }

                if (isDefined(self.spawnedSlide))
                {
                    self.spawnedSlide delete();
                    self.spawnedSlide = undefined;
                }

                self.spawnedSlide = spawn("script_model",bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 100, 0,self)["position"] + (0, 0, 20));
                self.spawnedSlide.angles = (0, self getPlayerAngles()[1] - 90, 60);
                self.spawnedSlide setModel("mp_supplydrop_ally");
                self.slideThread = self thread makeSlide(self.spawnedSlide);
            }
            break;

            case "bounce":
            if( action == "Delete" )
            {   
                if (isDefined(self.trampolineThread))
                {
                    self.trampolineThread delete();
                    self.trampolineThread = undefined;
                }

                if (isDefined(self.spawnedTrampoline))
                {
                    self.spawnedTrampoline delete();
                    self.spawnedTrampoline = undefined;
                }
            }

            else
            {   
                if (isDefined(self.trampolineThread))
                {
                    self.trampolineThread delete();
                    self.trampolineThread = undefined;
                }

                if (isDefined(self.spawnedTrampoline))
                {
                    self.spawnedTrampoline delete();
                    self.spawnedTrampoline = undefined;
                }

                self.spawnedTrampoline = spawn("script_model", self.origin);
                self.spawnedTrampoline setModel("mp_supplydrop_ally");
                self.trampolineThread = self thread monitortrampoline(self.spawnedTrampoline);
            }
            break;

            case "platform":
            if(level.oomUtilDisabled)
            {
                self iprintln("^1ERROR^7: Platform Spawning is [^1Disabled^7]!");
                return;
            }

            if( action == "Delete" )
            {
                if(!isDefined(self.spawnedplat))
                self.spawnedplat = [];
            
                location = self.origin;
                if(isDefined(self.spawnedplat))
                {
                    for(i = -3; i < 3; i++)
                    {
                        if(!isDefined(self.spawnedplat[i]))
                        continue;
                    
                        for(d = -3; d < 3; d++)
                        {
                            if(isDefined(self.spawnedplat[i][d]))
                            self.spawnedplat[i][d] delete();
                        }
                    }
                }
            }

            else
            {
                if(!isDefined(self.spawnedplat))
                self.spawnedplat = [];
            
                location = self.origin;
                if(isDefined(self.spawnedplat))
                {
                    for(i = -3; i < 3; i++)
                    {
                        if(!isDefined(self.spawnedplat[i]))
                        continue;
                    
                        for(d = -3; d < 3; d++)
                        {
                            if(isDefined(self.spawnedplat[i][d]))
                            self.spawnedplat[i][d] delete();
                        }
                    }
                }

                startpos = location + (0, 0, -15);

                for(i = -3; i < 3; i++)
                {      
                    if(!isDefined(self.spawnedplat[i]))
                    self.spawnedplat[i] = [];
                
                    for(d = -3; d < 3; d++)
                    {
                        self.spawnedplat[i][d] = spawn("script_model", startpos + (d * 25, i * 45, 0));
                        self.spawnedplat[i][d] setModel("mp_supplydrop_ally");
                        self.spawnedplat[i][d].angles = (0, 0, 0);
                    }
                }
            }
            break;

            case "crate":
            if(level.oomUtilDisabled)
            {
                self iprintln("^1ERROR^7: Crate Spawning is [^1Disabled^7]!");
                return;
            }
            
            if( action == "Delete" )
            {
                if (isDefined(self.spawnedcrate))
                {
                    self.spawnedcrate delete();
                    self.spawnedcrate = undefined;
                }
            }

            else
            {
                if (isDefined(self.spawnedcrate))
                {
                    self.spawnedcrate delete();
                    self.spawnedcrate = undefined;
                }

                cratePos = self.origin + (0, 0, -15); 
                self.spawnedcrate = spawn("script_model", cratePos);
                self.spawnedcrate setModel("mp_supplydrop_ally");
                self.spawnedcrate.angles = (0, 0, 0);
            }
            break;
        }
    }

    addDvarToggle( opt, dvar, func, p1, p2, p3, p4, p5 )
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        
        option = spawnStruct();
        
        if( !IsDefined( self GetPlayerCustomDvar( dvar ) ) )
            self SetPlayerCustomDvar( dvar, "0" );

        if( self GetPlayerCustomDvar( dvar ) == "1" )
            option.toggle = true;
        else
            option.toggle = false;

        option.opt    = opt;
        option.func   = func;
        option.p1     = p1;
        option.p2     = p2;
        option.p3     = p3;
        option.p4     = p4;
        option.p5     = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    setTeamRadar()
    {
        SetTeamSpyplane( getDvar( "host_team" ), 1 );

        radarType = "ui_radar_" + getDvar( "host_team" );

        if( radarType == "ui_radar_allies" )
            setMatchFlag( "radar_allies", 1 );
        else
            setMatchFlag( "radar_axis", 1 );

        level notify( "radar_status_change", getDvar( "host_team" ) );
    }

    catchRadarUpdates()
    {
        level endon("game_ended");
        for (;;)
        {
            level waittill("uav_update");
            wait 0.1;

            if( level.currentGametype == "tdm" || level.currentGametype == "sd" )
                level setTeamRadar();

            else if( level.currentGametype == "dm" )
                self maps\mp\_spyplane::callspyplane( "radar_mp", self.team );
        }
    }