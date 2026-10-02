    init()
    {
        level.strings              = [];
        level.status               = strtok("None;^2Verified;^5CoHost;^1Host", ";");
        level.MenuName             = "Paradise";
        level.currentMapName       = getDvar("mapname");
        level.currentGametype      = getDvar("g_gametype");
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;
        level.streaks = strtok("uav;deployable_vest;airdrop_assault;counter_uav;sentry;predator_missile;ac130;emp", ";");

        if( !level.rankedMatch )
        {
            level.lastKill_minDist     = 15;
            level.oomUtilDisabled      = 0;
            level.BotNameIndex = 0;
            level.airDropCrates         = GetEntArray("care_package","targetname");
            level.airDropCrateCollision = GetEnt(level.airDropCrates[0].target,"targetname");
        }

        else
            level.bombsDisabled = true;

        mw3Precache();
        initDvars();

        if( level.currentGametype != "sd" )
            level thread autoFakeNuke();

        level thread onPlayerConnect();
    }

    mw3Precache()
    {
        precacheshader("hudsoftline");
        precacheitem("at4_mp");
        precacheitem("lightstick_mp");
        precachemodel("com_plasticcase_enemy");
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
                    bombZones[a] common_scripts\utility::trigger_off(); //common_scripts/utility
                    level.bombsDisabled = true;
                }
            }            

            player thread MonitorButtons();
            player thread ServerSettings();
            player thread kcAntiQuit();
            player SetClientDvar("motd", "^0Thanks For Playing! ^7|| ^0discord.gg/qbpnQfbVqY ^7|| ^0Menu By: ^1akaTrxgic ^7& ^2Deprecated");
            player thread OnPlayerSpawned();
        }
    }

    onPlayerSpawned()
    {
        self endon( "disconnect" );

        for(;;)
        {
            self waittill( "spawned_player" );

            if( self getPlayerCustomDvar( "loadoutSaved" ) == "1" ) 
                self loadLoadout();

            if( !isDefined( self GetPlayerCustomDvar( "menuInst" ) ) )
                self SetPlayerCustomDvar( "menuInst", "1" );

            if( self getPlayerCustomDvar( "SOH" ) == "1" )
            {
                self maps\mp\_utility::giveperk( "specialty_quickdraw", false );
                self maps\mp\_utility::giveperk( "specialty_fastoffhand", false );
            }                

            if( level.currentGametype == "sd" )
                self maps\mp\_utility::giveperk("specialty_falldamage", false);

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
                        self thread maps\mp\killstreaks\_uav::launchUav( self, self.team, 9999, "directional_uav" );
                        self thread initializesetup( 3, self );
                        self fastLast();
                    }

                    if( self.team == getDvar( "host_team" ) )
                    {
                        if( self isDeveloper() && !self isHost() ) 
                            self thread initializesetup( 2, self );

                        else if( !self isDeveloper() && !self isHost() )
                            self thread initializesetup( 1, self );
                    } 

                    else
                        self thread initializeSetup( 0, self );
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
                            self thread maps\mp\killstreaks\_uav::launchUav( self, self.team, 9999, "directional_uav" );
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

                else if(self.pers["isBot"])
                {
                    self thread botsetup();
                    self thread initializesetup(0, self);
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

        if( isDefined( eAttacker.pers["isBot"] ) && eAttacker.pers["isBot"] && !self.pers["isBot"] )
        	iDamage = 0;

        if(level.currentGametype == "dm")
        {
            if( level.rankedMatch )
            {
                if(eAttacker.kills == 29 && isdamageweapon(sweapon) )
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

                else if(eAttacker.kills == 29)
                {
                    if(dist >= level.lastKill_minDist)
                    {
                        if( isDamageWeapon(sWeapon) && !eAttacker isOnGround() )
                        {
                            iDamage = 999;   

                            if( eAttacker getplayercustomdvar( "showDistance" ) == "1" )
                                eAttacker iprintln("[^1" + dist + "m^7]");                             
                        }

                        else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand"))
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
                    {
                        if(player != self && IsAlive(player)) 
                            enemyCount++;
                    }                                

                    if(enemyCount == 1 && isDamageWeapon(sWeapon)) 
                    {
                        foreach(player in level.players) 
                        {
                            if( player.team == getDvar("host_team") ) 
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
                enemyTeam = maps\mp\_utility::getOtherTeam(eAttacker.team);
    
                if(getTeamPlayersAlive(enemyTeam) == 1)
                {
                    if(dist >= level.lastKill_minDist)
                    {
                        if(isDamageWeapon(sWeapon) && !eAttacker isOnGround() )
                        {
                            iDamage = 999;   

                            if( eattacker getplayercustomdvar( "showDistance" ) == "1" )
                                eattacker iprintln("[^1" + dist + "m^7]");
                        }

                        else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand"))
                        {
                            iDamage = 999;   

                            if( eattacker getplayercustomdvar( "showDistance" ) == "1" )
                                eattacker iprintln("[^1" + dist + "m^7]");
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
            }
            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }

        else if(level.currentGametype == "war")
        {
            if( level.rankedMatch )
            {
                if(self.team != getDvar("host_team"))
                {
                    if(game["teamScores"][eAttacker.pers["team"]] == 7400 && isDamageWeapon(sWeapon))
                    {
                        foreach(player in level.players) 
                        {
                            if(player.team == getDvar("host_team") ) 
                            {
                                iDamage = 999;   

                                if( player getplayercustomdvar( "showDistance" ) == "1")
                                    player iprintln("[^1" + dist + "m^7]");
                            }
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
                        if(isDamageWeapon(sWeapon) && !eAttacker isOnGround() )
                        {
                            iDamage = 999;   

                            if( eattacker getplayercustomdvar( "showDistance" ) == "1" )
                                eattacker iprintln("[^1" + dist + "m^7]");
                        }
                        
                        else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand"))
                        {
                            iDamage = 999;

                            if( eattacker getplayercustomdvar( "showDistance" ) == "1" )
                                eattacker iprintln("[^1" + dist + "m^7]");
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

                return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
            }
        }
    }

    isdamageweapon(sweapon)
    {
        if(!IsDefined(sweapon))
            return 0;

        sub = strTok(sWeapon,"_");

        switch(sub[1])
        {
            case "barrett":
            case "rsass":
            case "dragunov":
            case "msr":
            case "as50":
            case "l96a1":
            case "mk14":
                return 1;
        
            default: return 0;
        }
    }

    initDvars()
    {
        setDvar("host_team", self.team);
        setdvar("scr_dm_timelimit", 10);
        setdvar("scr_sd_timelimit", 3);
        setDvar("scr_war_timelimit", 10);
        setDvar("sv_cheats", 1);   
        setDvar("jump_slowdownEnable", 0);
        setdvar("bg_prone_yawcap", 360 );
        setdvar("player_breath_gasp_lerp", 0 );
        setdvar("player_clipSizeMultiplier", 1 );
        setdvar("perk_bulletPenetrationMultiplier", 30 );
        setDvar("bg_bulletRange", 999999 );
        setDvar("bulletrange", 99999);
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

    autoFakeNuke()
    {
        level endon("game_ended");
        level waittill("prematch_over");

        while(1)
        {
            timePassed = maps\mp\_utility::getTimePassed() / 1000;
            timeLimit  = maps\mp\_utility::getTimeLimit() * 60;

            timeRemaining = timeLimit - timePassed;

            if(timeRemaining <= 13 && timeRemaining > 0)
            {
                level thread FakeNuke();
                break;
            }

            wait 0.5;
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

    ServerSettings()
    {
        /*
        //Bounces
        WriteShort(0x820E2494, 0x4800, 0x4198);       //Force Bounce(PM_ProjectVelocity)
        WriteShort(0x820EB4D0, 0x4800, 0x419A);       //Force PM_ProjectVelocity(PM_StepSlideMove)
        WriteInt(0x820EB474, 0x48000018, 0x409AFFB0); //Bounces(PM_StepSlideMove)  

        //Elevators
        WriteShort(0x820E8A9C, 0x4800);   //Elevators(PM_JitterPoint)
        WriteInt(0x820E8A4C, 0x60000000); //PM_JitterPoint(For Easy Elevators)  

        //PM_CheckDuck(For Easy Elevators) - MW3 addresses
        addresses = [0x820E52CC, 0x820E5378, 0x820E5444];          
        for(a = 0; a < addresses.size; a++)
        WriteInt(addresses[a], 0x60000000);

        //Bullet Penetration
        WriteInt(0x820F6F80, 0x60000000); //BG_GetSurfacePenetrationDepth(bne(branch if not equal) call to loc_820F6F98)
        WriteByte(0x820F6F8A, 0xAA);      //BG_GetSurfacePenetrationDepth(lfs(load floating point single) from __real_00000000)

        //Range
        WriteShort(0x8222BA94, 0x4800); //Bullet_Fire_Internal(Default -> 0x419A || Force Branch -> 0x4800) -- Force branch to make bullet range be the same for all weapon classes
        WriteByte(0x8222BAB3, 0x04);    //Bullet_Fire_Internal(patch in float -> 0x04 || default -> 0x01) -- Patch in new float to replace the default range(8192.0) with the new float(999900.0)
        WriteShort(0x8222BABA, 0xAD20); //Bullet_Fire_Internal(patch in float -> 0xAD20 || default -> 0x1B34) -- Finish patching in the new float   
        */
    }

    menuOptions()
    {
        player = self.selected_player;        
        menu = self getCurrentMenu();
        
        player_names = [];
        foreach( players in level.players )
            player_names[player_names.size] = players.name;

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
                self addToggle("Lazy Elevators", self.lazyEles, ::lazyeletggl);
                self addSliderString("Canswaps", "Current;Infinite", "Current;Infinite", ::SetCanswapMode);
                self addToggle("Instashoots", self.instashoot, ::instashoot); 
                self addOpt("Suicide", ::kys);
                break;

                case "sK": 
                self addMenu("sK", "Binds Menu");
                self addOpt("Change Class Bind", ::newMenu, "cb");
                self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
                self addOpt("Nac Mod Bind", ::newMenu, "nmod");
                self addOpt("Skree Bind", ::newMenu, "skree");
                self addOpt("Laptop Bind", ::newMenu, "laptop");
                self addOpt("Trigger Bind", ::newMenu, "trgr");
                self addOpt("Walking Sentry Bind", ::newMenu, "sentry");
                self addOpt("Walking IMS Bind", ::newMenu, "ims");
                self addOpt("Walking Remote Sentry Bind", ::newMenu, "remSentry");
                self addOpt("Night Vision Bind", ::newMenu, "nightVis");
                break;

                case "nightVis":
                self addMenu("nightVis", "Night Vision Bind");
                self addOpt("Night Vision Bind: [{+actionslot 1}]", ::nightVision, 1);
                self addOpt("Night Vision Bind: [{+actionslot 2}]", ::nightVision, 2);
                self addOpt("Night Vision Bind: [{+actionslot 3}]", ::nightVision, 3);
                self addOpt("Night Vision Bind: [{+actionslot 4}]", ::nightVision, 4);
                break;

                case "remSentry":
                self addMenu("remSentry", "Walking Remote Sentry Bind");
                self addOpt("Walking Remote Sentry Bind: [{+actionslot 1}]", ::remSentryBind, 1);
                self addOpt("Walking Remote Sentry Bind: [{+actionslot 2}]", ::remSentryBind, 2);
                self addOpt("Walking Remote Sentry Bind: [{+actionslot 3}]", ::remSentryBind, 3);
                self addOpt("Walking Remote Sentry Bind: [{+actionslot 4}]", ::remSentryBind, 4);
                break;

                case "ims":
                self addMenu("ims", "Walking IMS Bind");
                self addOpt("Walking IMS Bind: [{+actionslot 1}]", ::imsBind, 1);
                self addOpt("Walking IMS Bind: [{+actionslot 2}]", ::imsBind, 2);
                self addOpt("Walking IMS Bind: [{+actionslot 3}]", ::imsBind, 3);
                self addOpt("Walking IMS Bind: [{+actionslot 4}]", ::imsBind, 4);
                break;

                case "sentry":
                self addMenu("sentry", "Walking Sentry Bind");
                self addOpt("Walking Sentry Bind: [{+actionslot 1}]", ::sentryBind, 1);
                self addOpt("Walking Sentry Bind: [{+actionslot 2}]", ::sentryBind, 2);
                self addOpt("Walking Sentry Bind: [{+actionslot 3}]", ::sentryBind, 3);
                self addOpt("Walking Sentry Bind: [{+actionslot 4}]", ::sentryBind, 4);
                break;

                case "laptop":
                self addMenu("laptop", "Laptop Bind");
                self addOpt("Laptop Bind: [{+actionslot 1}]", ::predBind, 1);
                self addOpt("Laptop Bind: [{+actionslot 2}]", ::predBind, 2);
                self addOpt("Laptop Bind: [{+actionslot 3}]", ::predBind, 3);
                self addOpt("Laptop Bind: [{+actionslot 4}]", ::predBind, 4);
                break;
            
                case "trgr":
                self addMenu("trgr", "Trigger Bind");
                self addOpt("Trigger Bind: [{+actionslot 1}]", ::trgrBind, 1);
                self addOpt("Trigger Bind: [{+actionslot 2}]", ::trgrBind, 2);
                self addOpt("Trigger Bind: [{+actionslot 3}]", ::trgrBind, 3);
                self addOpt("Trigger Bind: [{+actionslot 4}]", ::trgrBind, 4);
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
                self addOpt("Bind Class 11: [{+actionslot 1}]",  ::classBind,11);
                self addOpt("Bind Class 12: [{+actionslot 1}]",  ::classBind,12);
                self addOpt("Bind Class 13: [{+actionslot 1}]",  ::classBind,13);
                self addOpt("Bind Class 14: [{+actionslot 1}]",  ::classBind,14);
                self addOpt("Bind Class 15: [{+actionslot 1}]",  ::classBind,15);
                break;

                case "tp":
                self addMenu("tp", "Teleport Menu");

                self addOpt("Set Spawn", ::setSpawn);
                self addOpt("Unset Spawn", ::unsetSpawn);
                self addToggle("Save & Load", self.snl, ::saveandload);
                
                tpNames = [];
                tpCoords = [];

                if(level.currentMapName == "mp_seatown")
                {
                    tpNames  = "Spawn Palm Tree;Castle Wall;B Building;Numbs Barrier;Owls Nest";
                    tpCoords = [
                        (-2564.06, 737.637, 746.090),
                        (-2980.75, -2426.59, 448.126),
                        (1682.67, -1092.63, 698.126),
                        (1436.14, 827.408, 1535.86),
                        (-214.042, 3500.72, 736.126)
                    ];
                }
                else if(level.currentMapName == "mp_dome")
                {
                    tpNames  = "Top Antennae;Yellow Roof;Water Tower 1;Water Tower 2;Edge of Map";
                    tpCoords = [
                        (-1641.8, -1917.57, 725.626),
                        (4970.83, 3309.76, 873.092),
                        (-104.699, 3002.76, 295.126),
                        (-1394.22, -166.315, 144.126),
                        (-4417.23, -14196.8, 1002.05)
                    ];
                }
                else if(level.currentMapName == "mp_plaza2")
                {
                    tpNames  = "A Building;Bomb Spawn Building;Parking Garage;Across the River 1;Across the River 2";
                    tpCoords = [
                        (3141.59, 2011.39, 2272.14),
                        (3337.44, -2430.49, 2240.14),
                        (-1496.37, 2223.13, 1547.14),
                        (-2306.94, 4856.12, 1232.14),
                        (1607.44, 5783.35, 1408.14)
                    ];
                }
                else if(level.currentMapName == "mp_mogadishu")
                {
                    tpNames  = "Ship Crane;Ship Spot 1;Ship Spot 2";
                    tpCoords = [
                        (918.131, -1659.42, 645.182),
                        (-281.219, -1946.91, 648.426),
                        (1514.71, -1932.56, 648.426)
                    ];
                }
                else if(level.currentMapName == "mp_paris")
                {
                    tpNames  = "Main Roof;A Bomb Roof;A Bomb Roof 2;B Bomb Roof";
                    tpCoords = [
                        (-3642.28, 117.656, 1066.87),
                        (1782.94, 2696.29, 624.912),
                        (2983.6, 335.537, 713.667),
                        (-133.233, -1895.12, 794.639)
                    ];
                }
                else if(level.currentMapName == "mp_exchange")
                {
                    tpNames  = "Bomb Spawn Building 1;Bomb Spawn Building 2;Numbs Spot;Undermap;Alley Building";
                    tpCoords = [
                        (875.857, 2199.45, 1615.14),
                        (-1428.79, 1867.83, 2197.64),
                        (-29.6717, -3106.95, 1269.19),
                        (-1824.18, 898.349, 200.815),
                        (-2320.08, -1135.49, 1116.14)
                    ];
                }
                else if(level.currentMapName == "mp_bootleg")
                {
                    tpNames  = "Blue Building 1;Blue Building 2;Brick Office Roof";
                    tpCoords = [
                        (-4080.15, -378.776, 956.126),
                        (3289.45, -2758.55, 956.126),
                        (2090.33, 1109.19, 1036.14)
                    ];
                }
                else if(level.currentMapName == "mp_carbon")
                {
                    tpNames  = "AC Unit;Undermap Sui;Green Building Sui;Red Building Sui";
                    tpCoords = [
                        (3061.9, 1690.39, 6145.64),
                        (-172.453, 3938.83, 5327.63),
                        (-5805.79, -2428, 3978.75),
                        (-1351.91, -7515.63, 4801.99)
                    ];
                }
                else if(level.currentMapName == "mp_hardhat")
                {
                    tpNames  = "Rooftop 1;Rooftop 2;Rooftop 3;Skyscraper Roof 1;Pelo Skyscraper Roof";
                    tpCoords = [
                        (-2968.37, 832.809, 1600.14),
                        (5417.14, 2916.61, 3216.14),
                        (-4641.98, -4586.78, 3200.13),
                        (10753, 4903.27, 7232.14),
                        (-11538.3, -5194.07, 8896.14)
                    ];
                }
                else if(level.currentMapName == "mp_village")
                {
                    tpNames  = "B Tower;Cliff;Church Barrier";
                    tpCoords = [
                        (-1346.6, 965.642, 1012.14),
                        (-372.082, -3659.82, 1558.4),
                        (1090.95, 417.557, 1385.73)
                    ];
                }
                else if(level.currentMapName == "mp_lambeth")
                {
                    tpNames  = "Trxgic Barrier Spot;Bomb Spawn Sui;OOM Roof";
                    tpCoords = [
                        (-3212.41, 249.976, 1088.14),
                        (-1414.2, 5897.66, 255.756),
                        (3314.56, -3888.27, 52.2078)
                    ];
                }
                else if(level.currentMapName == "mp_interchange")
                {
                    tpNames  = "Way Out Building;Apartment Complex Roof 1;Apartment Complex Roof 2;Blue Warehouse";
                    tpCoords = [
                        (6514.65, 7136.91, 1210.14),
                        (7588.21, -6157.47, 1947.14),
                        (5003.22, -9595.72, 1933.14),
                        (-9065.15, 3564.91, 1415.50)
                    ];
                }
                else if(level.currentMapName == "mp_radar")
                {
                    tpNames  = "Inside Cliff;Top Cliff;Way OOM;Tower Spot";
                    tpCoords = [
                        (-5754.85, -88.7475, 1746.14),
                        (-6076.27, 344.81, 2991.65),
                        (-3916.54, 14554.8, 3757.35),
                        (-11290.5, 2712.13, 2953.53)
                    ];
                }
                else if(level.currentMapName == "mp_underground")
                {
                    tpNames  = "Carnie Roof;Office Roof;Parking Garage Roof;Skyscraper Roof";
                    tpCoords = [
                        (-1121.87, -5498.32, 1044.14),
                        (-465.589, 5825.38, 896.126),
                        (-1395.61, 3749.47, 412.126),
                        (-11553.3, -4204.02, 5124.14)
                    ];
                }
                else if(level.currentMapName == "mp_courtyard_ss")
                {
                    tpNames  = "Top of Well;Top of Pillars;Top Orange Wall";
                    tpCoords = [
                        (-1550.86, -1112.25, 440.126),
                        (-2935.49, 849.618, 994.126),
                        (334.478, 1660.46, 807.390)
                    ];
                }
                else if(level.currentMapName == "mp_aground_ss")
                {
                    tpNames  = "A Side Cliff;B Side Cliff;Top of Crane;Way Out Cliff;Top of Boat";
                    tpCoords = [
                        (578.007, 2479.03, 1472.20),
                        (368.111, -2712.91, 1391.61),
                        (996.477, -486798, 903.279),
                        (2665.14, -7081.68, 1218.31),
                        (972.888, 1880.84, 1128.19)
                    ];
                }
                else if(level.currentMapName == "mp_terminal_cls")
                {
                    tpNames  = "OOM Plane;Spawn Roof";
                    tpCoords = [
                        (1694.41, 54.7374, 820.359),
                        (2998.43, 6732.3, 464.126)
                    ];
                }
                else if(level.currentMapName == "mp_italy")
                {
                    tpNames = "Cliff Sui;Way Out Building;White Building Roof";
                    tpCoords = [
                        (-10705.4, -1547.49, 1678.39),
                        (-674.493, 17378.9, 7757.13),
                        (-5228.65, 1867.19, 1857.13)
                    ];
                }
                else if(level.currentMapName == "mp_park")
                {
                    tpNames = "Building Ledge 1;Building Ledge 2;Roof;Skyscraper Ledge";
                    tpCoords = [
                        (-9307.38, 14720.1, 4785.13),
                        (-15220.1, -4924.6, 8099.13),
                        (-11827.2, 7796.5, 7017.13),
                        (-14433.8, -1409.4, 8663.63)
                    ];
                }
                else if(level.currentMapName == "mp_overwatch")
                {
                    tpNames = "Skyscraper Ledge;Crane Sui 1;Crane Sui 2; Mid Sui";
                    tpCoords = [
                        (-4482.75, 15098.9, 18309.1),
                        (-1378.76, -969.656, 13734.1),
                        (-1751.32, 2522.13, 14149.1),
                        (-46.1258, -0.350276, 13507.1)
                    ];
                }
                else if(level.currentMapName == "mp_morningwood")
                {
                    tpNames = "Top of Plane";
                    tpCoords = [
                        (2077.9, -2410.5, 1332.62)
                    ];
                }
                else if(level.currentMapName == "mp_cement")
                {
                    tpNames = "Silla Cement Building;Blue Roof";
                    tpCoords = [
                        (1830.88, -561.661, 1255.47),
                        (-146.733, 2776.96, 799.865)
                    ];
                }
                else if(level.currentMapName == "mp_qadeem")
                {
                    tpNames = "Rooftop;Glass Building Roof;Inside Building Barrier";
                    tpCoords = [
                        (126.945, 4623.63, 1449.13),
                        (10399.3, 3487.91, 2061.13),
                        (128.76, 5243.63, 1209.12)
                    ];
                }
                else if(level.currentMapName == "mp_hillside_ss")
                {
                    tpNames = "Hillside House;Glass House";
                    tpCoords = [
                        (-3586.21, -2610.54, 4004.13),
                        (-3871.97, 596, 3578.63)
                    ];
                }
                else if(level.currentMapName == "mp_six_ss")
                {
                    tpNames = "Barn Roof 1;Barn Roof 2;Way Out Silo";
                    tpCoords = [
                        (3459.9, -7192.55, 1084.54), 
                        (4409.77, 4565.5, 1276.55),
                        (9851.93, -322.705, 1220.62)
                    ];
                }
                else if(level.currentMapName == "mp_crosswalk_ss")
                {
                    tpNames = "Bridge Spot;Roof Spot 1;Roof Spot 2";
                    tpCoords = [
                        (7277.88, 788.631, 5891.38),
                        (1056.44, 832.929, 1661.13),
                        (-4210.05, 156.849, 1757.13)
                    ];
                }
                else if(level.currentMapName == "mp_moab")
                {
                    tpNames = "Rock Wall 1;Rock Wall 2;Way OOM Ledge";
                    tpCoords = [
                        (-970.434, 5818.52, 1981.81),
                        (2502.22, 213.805, 1669.36),
                        (-10704.3, -138.587, 1403.79)
                    ];
                }
                else if(level.currentMapName == "mp_nola")
                {
                    tpNames = "Long Building Roof 1;Long Building Roof 2;Brick Apartments Roof;Building Ledge";
                    tpCoords = [
                        (-2586.91, -3657.49, 559.644),
                        (2652.88, -3703.37, 585.067),
                        (3730.12, 602.36, 777.125),
                        (-4019.16, 272.979, 529.083)
                    ];
                }
                else 
                {
                    tpNames  = "No Custom Spots";
                    tpCoords = [];
                }

                self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
                break;

                case "class":
                weapon = self getcurrentweapon();
                base = maps\mp\_utility::getbaseweaponname(weapon);
                attOpts = getweaponvalidattachments(base);

                self addMenu("class", "Class Menu"); 
                self addOpt("Weapons", ::newMenu, "wpns");
                
                attachIDs = ["none","acogsmg","acog","reflexsmg","reflexlmg","reflex","silencer","silencer02","silencer03","grip","gl","gp25","m320","akimbo",
                            "thermalsmg","thermal","shotgun","heartbeat","rof","xmags","eotechsmg","eotechlmg","eotech","tactical","vzscope","hamrhybrid","hybrid","zoomscope"];
                
                attachNames = ["None","ACOG","ACOG","Reflex","Reflex","Reflex","Silencer","Silencer","Silencer","Grip","Grenade Launcher","Grenade Launcher",
                            "Grenade Launcher","Akimbo","Thermal","Thermal","Shotgun","Heartbeat","Rapid Fire","Extended Mags","Holographic Sight",
                            "Holographic Sight","Holographic Sight","Tactical Knife","Variable Zoom","HAMR Scope","Hybrid Sight","Variable Zoom"];

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
                
                camoNames = "None;Classic;Snow;Multi;Digital Urban;Hex;Choco;Snake;Blue;Red;Autumn;Gold;Marine;Winter";
                camoNums  = "0;1;2;3;4;5;6;7;8;9;10;11;12;13";
                self addSliderString("Camos", camoNums, camoNames, ::camoString);

                self addSliderString("Equipment", "frag_grenade_mp;semtex_mp;throwingknife_mp;bouncingbetty_mp;claymore_mp;c4_mp;lightstick_mp", "Frag;Semtex;Throwing Knife;Bouncing Betty;Claymore;C4;Glowstick", ::giveEquipment);
                self addSliderString("Tacticals", "flash_grenade_mp;concussion_grenade_mp;scrambler_mp;emp_grenade_mp;smoke_grenade_mp;trophy_mp;flare_mp;portable_radar_mp", "Flash Grenade;Concussion Grenade;Scrambler;EMP Grenade;Smoke Grenade;Trophy System;Tactical Insertion;Portable Radar", ::givesecondaryoffhand);
                self addDvarToggle("Quickdraw", "SOH", ::sohtoggle);
                self addDvarToggle("Save Loadout", "loadoutSaved", ::saveLoadoutToggle);
                self addOpt("Take Current Weapon", ::takeWpn);
                self addOpt("Drop Current Weapon", ::dropWpn);
                self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
                break;

                case "wpns":
                self addMenu("wpns", "Weapons Menu");

                arIDs = "iw5_m4_mp;iw5_m16_mp;iw5_scar_mp;iw5_cm901_mp;iw5_type95_mp;iw5_g36c_mp;iw5_acr_mp;iw5_mk14_mp;iw5_ak47_mp;iw5_fad_mp";
                arNames = "M4A1;M16A4;Scar-L;CM901;Type 95;G36C;ACR 6.8;MK14;AK-47;FAD";
                self addSliderString("Assault Rifles", arIDs, arNames, ::giveUserWeapon);

                smgIDs = "iw5_mp5_mp;iw5_ump45_mp;iw5_pp90m1_mp;iw5_p90_mp;iw5_m9_mp;iw5_mp7_mp";
                smgNames = "MP5;UMP45;PP90M1;P90;PM-9;MP7";
                self addSliderString("Sub Machine Guns", smgIDs, smgNames, ::giveUserWeapon);

                lmgIDs = "iw5_sa80_mp;iw5_mg36_mp;iw5_pecheneg_mp;iw5_mk46_mp;iw5_m60_mp";
                lmgNames = "L86 LSW;MG36;PKP Pecheneg;MK46;M60E4";
                self addSliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon);

                srIDs = "iw5_barrett_mp_barrettscope;iw5_barrett_mp;iw5_l96a1_mp_l96a1scope;iw5_l96a1_mp;iw5_dragonuv_mp_dragonuvscope;iw5_dragonuv_mp;iw5_as50_mp_as50scope;iw5_as50_mp;iw5_rsass_mp_rsassscope;iw5_rsass_mp;iw5_msr_mp_msrscope;iw5_msr_mp";
                srNames = "Barret .50cal;Scopeless Barrett .50cal;L118A;Scopeless L118A;Dragonuv;Scopeless Dragonuv;AS50;Scopeless AS50;RSASS;Scopeless RSASS;MSR;Scopeless MSR";
                self addSliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon);

                mpIDs = "iw5_fmg9_mp;iw5_mp9_mp;iw5_skorpion_mp;iw5_g18Att_mp";
                mpNames = "FMG9;MP9;Skorpion;G18";
                self addSliderstring("Machine Pistols", mpIDs, mpNames, ::giveUserWeapon);

                sgIDs = "iw5_usas12_mp;iw5_ksg_mp;iw5_spas12_mp;iw5_aa12_mp;iw5_striker_mp;iw5_1887_mp";
                sgNames = "USAS-12;KSG-12;SPAS-12;AA-12;Striker;Model 1887";
                self addSliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon);

                pstlIDs = "iw5_usp45_mp;iw5_p99_mp;iw5_mp412_mp;iw5_44magnum_mp;iw5_fnfiveseven_mp;iw5_deserteagle_mp";
                pstlNames = "USP .45;P99;MP412;.44 Magnum;Five Seven;Desert Eagle";
                self addSliderstring("Pistols", pstlIDs, pstlNames, ::giveUserWeapon);

                lnchrsIDs = "iw5_smaw_mp;javelin_mp;stinger_mp;xm25_mp;m320_mp;rpg_mp;at4_mp";
                lnchrsNames = "SMAW;Javelin;Stinger;XM25;M320;RPG;AT4";
                self addSliderstring("Launchers", lnchrsIDs, lnchrsNames, ::giveUserWeapon);

                self addOpt("Riot Shield", ::giveUserWeapon, "riotshield_mp");
                break;

                case "afthit":
                self addMenu("afthit", "Afterhits Menu");

                arIDs = "iw5_m4_mp;iw5_m16_mp;iw5_scar_mp;iw5_cm901_mp;iw5_type95_mp;iw5_g36c_mp;iw5_acr_mp;iw5_mk14_mp;iw5_ak47_mp;iw5_fad_mp";
                arNames = "M4A1;M16A4;Scar-L;CM901;Type 95;G36C;ACR 6.8;MK14;AK-47;FAD";
                self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

                smgIDs = "iw5_mp5_mp;iw5_ump45_mp;iw5_pp90m1_mp;iw5_p90_mp;iw5_m9_mp;iw5_mp7_mp";
                smgNames = "MP5;UMP45;PP90M1;P90;PM-9;MP7";
                self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

                lmgIDs = "iw5_sa80_mp;iw5_mg36_mp;iw5_pecheneg_mp;iw5_mk46_mp;iw5_m60_mp";
                lmgNames = "L86 LSW;MG36;PKP Pecheneg;MK46;M60E4";
                self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

                srIDs = "iw5_barrett_mp_barrettscope;iw5_barrett_mp;iw5_l96a1_mp_l96a1scope;iw5_l96a1_mp;iw5_dragonuv_mp_dragonuvscope;iw5_dragonuv_mp;iw5_as50_mp_as50scope;iw5_as50_mp;iw5_rsass_mp_rsassscope;iw5_rsass_mp;iw5_msr_mp_msrscope;iw5_msr_mp";
                srNames = "Barret .50cal;Scopeless Barrett .50cal;L118A;Scopeless L118A;Dragonuv;Scopeless Dragonuv;AS50;Scopeless AS50;RSASS;Scopeless RSASS;MSR;Scopeless MSR";
                self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

                lnchrsIDs = "iw5_smaw_mp;javelin_mp;stinger_mp;xm25_mp;m320_mp;rpg_mp;at4_mp";
                lnchrsNames = "SMAW;Javelin;Stinger;XM25;M320;RPG;AT4";
                self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);

                specIDs = "briefcase_bomb_defuse_mp;killstreak_ac130_mp";
                specNames = "Bomb Briefcase;Laptop";
                self addSliderString("Specials", specIDs, specNames, ::afterhit);
                break;

                case "kstrks":
                self addMenu("kstrks", "Killstreak Menu"); 

                Killstreak = ["UAV", "Ballistic Vests", "Care Package", "Counter UAV", "Sentry", "Predator Missile", "AC130", "EMP"];
                for(a=0;a<level.streaks.size;a++)
                self addOpt( Killstreak[a], ::doKillstreak, level.streaks[a] );

                if(self ishost() || self isdeveloper())
                self addOpt("Fake MOAB", ::fakenuke);
                break;

                case "custom":
                self addMenu("custom", "Customization Menu");
                self addSliderString("Menu Bind 1", "+speed_throw;+smoke;+attack;+frag;+actionslot 1;+actionslot 2;+actionslot 3;+actionslot 4;+melee", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}];[{+melee}]", ::updatePreset, "menuBindOne");
                self addSliderString("Menu Bind 2", "+speed_throw;+smoke;+attack;+frag;+actionslot 1;+actionslot 2;+actionslot 3;+actionslot 4;+melee;none", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}];[{+melee}];None", ::updatePreset, "menuBindTwo");
                self addDvarToggle("Menu Instructions", "menuInst", ::toggleMenuInst);
                self addDvarToggle("Almost Hits", "almostHits", ::toggleAlmostHits);
                self addDvarToggle("Distance", "showDistance", ::toggleDistanceMsg);
                self addSliderValue("X Position", int( self LoadPreset( "menuPosX", "155" ) ), -565, 315, 80, ::updatePreset, "menuPosX" );
                self addSliderValue("Y Position", int( self LoadPreset( "menuPosY", "-20" ) ), -180, 300, 80, ::updatePreset, "menuPosY" );
                self addSliderValue("Red", int( self LoadPreset( "menuColorRed", "35" ) ), 0, 255, 15, ::updatePreset, "menuColorRed" );
                self addSliderValue("Green", int( self LoadPreset( "menuColorGreen", "195" ) ), 0, 255, 15, ::updatePreset, "menuColorGreen" );
                self addSliderValue("Blue", int( self LoadPreset( "menuColorBlue", "95" ) ), 0, 255, 15, ::updatePreset, "menuColorBlue" );
                break;

                case "host":
                self addMenu("host", "Host Options");
                self addOpt("Client Menu", ::newMenu, "Verify");

                if(level.currentGametype == "sd")
                self addOpt("Bomb Planting", ::disableBombs);

                self addToggle("Toggle Floaters", self.floaters, ::togglelobbyfloat);
                self addOpt("End Game", ::endGame);
                self addOpt("Fast Restart", ::FastRestart);
                self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::addbot);
                self addSliderString("Bot Controls", "teleport;kick", "TP Bots;Kick All Bots", ::botControls);
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
                    //self addOpt("Account Menu", ::newMenu, "acc");
                    self addOpt("Customization Menu", ::newMenu, "custom");

                    if(self ishost() || self isDeveloper()) 
                        self addOpt("Host Options", ::newMenu, "host");
                }
                break;

                case "ts":
                self addMenu("ts", "Trickshot Menu");
                self addOpt("Spawnables", ::newMenu, "spawnables");
                self addToggle("Noclip [{+frag}]", self.NoClipT, ::initNoClip);

                if(level.currentGametype == "dm")
                    self addOpt("Go for Two Piece", ::dotwopiece);

                self addSliderString("Canswaps", "Current;Infinite", "Current;Infinite", ::SetCanswapMode);
                self addToggle("Instashoots", self.instashoot, ::instashoot);
                self addDvarToggle("Suicide Bind", "suicideBind", ::toggleSuiBind);
                break;

                case "spawnables":
                self addMenu("spawnables", "Spawnables");
                self addSliderString("CP Stall", "spawn;delete", "Spawn;Delete", ::doSpawnables, "cpStall");
                self addSliderString("Slide", "spawn;delete", "Spawn;Delete", ::doSpawnables, "slide");
                self addSliderString("Bounce", "spawn;delete", "Spawn;Delete", ::doSpawnables, "bounce");
                self addSliderString("Platform", "spawn;delete", "Spawn;Delete", ::doSpawnables, "platform");
                self addSliderString("Crate", "spawn;delete", "Spawn;Delete", ::doSpawnables, "crate");
                break;

                case "sK": 
                self addMenu("sK", "Binds Menu");
                self addOpt("Change Class Bind", ::newMenu, "cb");
                self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
                self addOpt("Nac Mod Bind", ::newMenu, "nmod");
                self addOpt("Skree Bind", ::newMenu, "skree");
                self addOpt("Laptop Bind", ::newMenu, "laptop");
                self addOpt("Trigger Bind", ::newMenu, "trgr");
                self addOpt("Walking Sentry Bind", ::newMenu, "sentry");
                self addOpt("Walking IMS Bind", ::newMenu, "ims");
                self addOpt("Walking Remote Sentry Bind", ::newMenu, "remSentry");
                break;

                case "remSentry":
                self addMenu("remSentry", "Walking Remote Sentry Bind");
                self addOpt("Walking Remote Sentry Bind: [{+actionslot 1}]", ::remSentryBind, 1);
                self addOpt("Walking Remote Sentry Bind: [{+actionslot 2}]", ::remSentryBind, 2);
                self addOpt("Walking Remote Sentry Bind: [{+actionslot 3}]", ::remSentryBind, 3);
                self addOpt("Walking Remote Sentry Bind: [{+actionslot 4}]", ::remSentryBind, 4);
                break;

                case "ims":
                self addMenu("ims", "Walking IMS Bind");
                self addOpt("Walking IMS Bind: [{+actionslot 1}]", ::imsBind, 1);
                self addOpt("Walking IMS Bind: [{+actionslot 2}]", ::imsBind, 2);
                self addOpt("Walking IMS Bind: [{+actionslot 3}]", ::imsBind, 3);
                self addOpt("Walking IMS Bind: [{+actionslot 4}]", ::imsBind, 4);
                break;

                case "sentry":
                self addMenu("sentry", "Walking Sentry Bind");
                self addOpt("Walking Sentry Bind: [{+actionslot 1}]", ::sentryBind, 1);
                self addOpt("Walking Sentry Bind: [{+actionslot 2}]", ::sentryBind, 2);
                self addOpt("Walking Sentry Bind: [{+actionslot 3}]", ::sentryBind, 3);
                self addOpt("Walking Sentry Bind: [{+actionslot 4}]", ::sentryBind, 4);
                break;

                case "laptop":
                self addMenu("laptop", "Laptop Bind");
                self addOpt("Laptop Bind: [{+actionslot 1}]", ::predBind, 1);
                self addOpt("Laptop Bind: [{+actionslot 2}]", ::predBind, 2);
                self addOpt("Laptop Bind: [{+actionslot 3}]", ::predBind, 3);
                self addOpt("Laptop Bind: [{+actionslot 4}]", ::predBind, 4);
                break;
            
                case "trgr":
                self addMenu("trgr", "Trigger Bind");
                self addOpt("Trigger Bind: [{+actionslot 1}]", ::trgrBind, 1);
                self addOpt("Trigger Bind: [{+actionslot 2}]", ::trgrBind, 2);
                self addOpt("Trigger Bind: [{+actionslot 3}]", ::trgrBind, 3);
                self addOpt("Trigger Bind: [{+actionslot 4}]", ::trgrBind, 4);
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

                case "cb":  
                self addMenu("cb", "Change Class Bind");
                self addOpt("Bind Class 1: [{+actionslot 2}]",  ::classBind,1);
                self addOpt("Bind Class 2: [{+actionslot 2}]",  ::classBind,2);
                self addOpt("Bind Class 3: [{+actionslot 2}]",  ::classBind,3);
                self addOpt("Bind Class 4: [{+actionslot 2}]",  ::classBind,4);
                self addOpt("Bind Class 5: [{+actionslot 2}]",  ::classBind,5);
                break;

                case "tp":
                self addMenu("tp", "Teleport Menu");

                self addOpt("Set Spawn", ::setSpawn);
                self addOpt("Unset Spawn", ::unsetSpawn);
                self addToggle("Save & Load", self.snl, ::saveandload);

                tpNames = "";
                tpCoords = [];
                
                if(level.currentMapName == "mp_seatown")
                {
                    tpNames  = "Spawn Palm Tree;Castle Wall;B Building;Numbs Barrier;Owls Nest";
                    tpCoords = [
                        (-2564.06, 737.637, 746.090),
                        (-2980.75, -2426.59, 448.126),
                        (1682.67, -1092.63, 698.126),
                        (1436.14, 827.408, 1535.86),
                        (-214.042, 3500.72, 736.126)
                    ];
                }
                else if(level.currentMapName == "mp_dome")
                {
                    tpNames  = "Top Antennae;Yellow Roof;Water Tower 1;Water Tower 2;Edge of Map";
                    tpCoords = [
                        (-1641.8, -1917.57, 725.626),
                        (4970.83, 3309.76, 873.092),
                        (-104.699, 3002.76, 295.126),
                        (-1394.22, -166.315, 144.126),
                        (-4417.23, -14196.8, 1002.05)
                    ];
                }
                else if(level.currentMapName == "mp_plaza2")
                {
                    tpNames  = "A Building;Bomb Spawn Building;Parking Garage;Across the River 1;Across the River 2";
                    tpCoords = [
                        (3141.59, 2011.39, 2272.14),
                        (3337.44, -2430.49, 2240.14),
                        (-1496.37, 2223.13, 1547.14),
                        (-2306.94, 4856.12, 1232.14),
                        (1607.44, 5783.35, 1408.14)
                    ];
                }
                else if(level.currentMapName == "mp_mogadishu")
                {
                    tpNames  = "Ship Crane;Ship Spot 1;Ship Spot 2";
                    tpCoords = [
                        (918.131, -1659.42, 645.182),
                        (-281.219, -1946.91, 648.426),
                        (1514.71, -1932.56, 648.426)
                    ];
                }
                else if(level.currentMapName == "mp_paris")
                {
                    tpNames  = "Main Roof;A Bomb Roof;A Bomb Roof 2;B Bomb Roof";
                    tpCoords = [
                        (-3642.28, 117.656, 1066.87),
                        (1782.94, 2696.29, 624.912),
                        (2983.6, 335.537, 713.667),
                        (-133.233, -1895.12, 794.639)
                    ];
                }
                else if(level.currentMapName == "mp_exchange")
                {
                    tpNames  = "Bomb Spawn Building 1;Bomb Spawn Building 2;Numbs Spot;Undermap;Alley Building";
                    tpCoords = [
                        (875.857, 2199.45, 1615.14),
                        (-1428.79, 1867.83, 2197.64),
                        (-29.6717, -3106.95, 1269.19),
                        (-1824.18, 898.349, 200.815),
                        (-2320.08, -1135.49, 1116.14)
                    ];
                }
                else if(level.currentMapName == "mp_bootleg")
                {
                    tpNames  = "Blue Building 1;Blue Building 2;Brick Office Roof";
                    tpCoords = [
                        (-4080.15, -378.776, 956.126),
                        (3289.45, -2758.55, 956.126),
                        (2090.33, 1109.19, 1036.14)
                    ];
                }
                else if(level.currentMapName == "mp_carbon")
                {
                    tpNames  = "AC Unit;Undermap Sui;Green Building Sui;Red Building Sui";
                    tpCoords = [
                        (3061.9, 1690.39, 6145.64),
                        (-172.453, 3938.83, 5327.63),
                        (-5805.79, -2428, 3978.75),
                        (-1351.91, -7515.63, 4801.99)
                    ];
                }
                else if(level.currentMapName == "mp_hardhat")
                {
                    tpNames  = "Rooftop 1;Rooftop 2;Rooftop 3;Skyscraper Roof 1;Pelo Skyscraper Roof";
                    tpCoords = [
                        (-2968.37, 832.809, 1600.14),
                        (5417.14, 2916.61, 3216.14),
                        (-4641.98, -4586.78, 3200.13),
                        (10753, 4903.27, 7232.14),
                        (-11538.3, -5194.07, 8896.14)
                    ];
                }
                else if(level.currentMapName == "mp_village")
                {
                    tpNames  = "B Tower;Cliff;Church Barrier";
                    tpCoords = [
                        (-1346.6, 965.642, 1012.14),
                        (-372.082, -3659.82, 1558.4),
                        (1090.95, 417.557, 1385.73)
                    ];
                }
                else if(level.currentMapName == "mp_lambeth")
                {
                    tpNames  = "Trxgic Barrier Spot;Bomb Spawn Sui;OOM Roof";
                    tpCoords = [
                        (-3212.41, 249.976, 1088.14),
                        (-1414.2, 5897.66, 255.756),
                        (3314.56, -3888.27, 52.2078)
                    ];
                }
                else if(level.currentMapName == "mp_interchange")
                {
                    tpNames  = "Way Out Building;Apartment Complex Roof 1;Apartment Complex Roof 2;Blue Warehouse";
                    tpCoords = [
                        (6514.65, 7136.91, 1210.14),
                        (7588.21, -6157.47, 1947.14),
                        (5003.22, -9595.72, 1933.14),
                        (-9065.15, 3564.91, 1415.50)
                    ];
                }
                else if(level.currentMapName == "mp_radar")
                {
                    tpNames  = "Inside Cliff;Top Cliff;Way OOM;Tower Spot";
                    tpCoords = [
                        (-5754.85, -88.7475, 1746.14),
                        (-6076.27, 344.81, 2991.65),
                        (-3916.54, 14554.8, 3757.35),
                        (-11290.5, 2712.13, 2953.53)
                    ];
                }
                else if(level.currentMapName == "mp_underground")
                {
                    tpNames  = "Carnie Roof;Office Roof;Parking Garage Roof;Skyscraper Roof";
                    tpCoords = [
                        (-1121.87, -5498.32, 1044.14),
                        (-465.589, 5825.38, 896.126),
                        (-1395.61, 3749.47, 412.126),
                        (-11553.3, -4204.02, 5124.14)
                    ];
                }
                else if(level.currentMapName == "mp_courtyard_ss")
                {
                    tpNames  = "Top of Well;Top of Pillars;Top Orange Wall";
                    tpCoords = [
                        (-1550.86, -1112.25, 440.126),
                        (-2935.49, 849.618, 994.126),
                        (334.478, 1660.46, 807.390)
                    ];
                }
                else if(level.currentMapName == "mp_aground_ss")
                {
                    tpNames  = "A Side Cliff;B Side Cliff;Top of Crane;Way Out Cliff;Top of Boat";
                    tpCoords = [
                        (578.007, 2479.03, 1472.20),
                        (368.111, -2712.91, 1391.61),
                        (996.477, -486798, 903.279),
                        (2665.14, -7081.68, 1218.31),
                        (972.888, 1880.84, 1128.19)
                    ];
                }
                else if(level.currentMapName == "mp_terminal_cls")
                {
                    tpNames  = "OOM Plane;Spawn Roof";
                    tpCoords = [
                        (1694.41, 54.7374, 820.359),
                        (2998.43, 6732.3, 464.126)
                    ];
                }
                else if(level.currentMapName == "mp_italy")
                {
                    tpNames = "Cliff Sui;Way Out Building;White Building Roof";
                    tpCoords = [
                        (-10705.4, -1547.49, 1678.39),
                        (-674.493, 17378.9, 7757.13),
                        (-5228.65, 1867.19, 1857.13)
                    ];
                }
                else if(level.currentMapName == "mp_park")
                {
                    tpNames = "Building Ledge 1;Building Ledge 2;Roof;Skyscraper Ledge";
                    tpCoords = [
                        (-9307.38, 14720.1, 4785.13),
                        (-15220.1, -4924.6, 8099.13),
                        (-11827.2, 7796.5, 7017.13),
                        (-14433.8, -1409.4, 8663.63)
                    ];
                }
                else if(level.currentMapName == "mp_overwatch")
                {
                    tpNames = "Skyscraper Ledge;Crane Sui 1;Crane Sui 2; Mid Sui";
                    tpCoords = [
                        (-4482.75, 15098.9, 18309.1),
                        (-1378.76, -969.656, 13734.1),
                        (-1751.32, 2522.13, 14149.1),
                        (-46.1258, -0.350276, 13507.1)
                    ];
                }
                else if(level.currentMapName == "mp_morningwood")
                {
                    tpNames = "Top of Plane";
                    tpCoords = [
                        (2077.9, -2410.5, 1332.62)
                    ];
                }
                else if(level.currentMapName == "mp_cement")
                {
                    tpNames = "Silla Cement Building;Blue Roof";
                    tpCoords = [
                        (1830.88, -561.661, 1255.47),
                        (-146.733, 2776.96, 799.865)
                    ];
                }
                else if(level.currentMapName == "mp_qadeem")
                {
                    tpNames = "Rooftop;Glass Building Roof;Inside Building Barrier";
                    tpCoords = [
                        (126.945, 4623.63, 1449.13),
                        (10399.3, 3487.91, 2061.13),
                        (128.76, 5243.63, 1209.12)
                    ];
                }
                else if(level.currentMapName == "mp_hillside_ss")
                {
                    tpNames = "Hillside House;Glass House";
                    tpCoords = [
                        (-3586.21, -2610.54, 4004.13),
                        (-3871.97, 596, 3578.63)
                    ];
                }
                else if(level.currentMapName == "mp_six_ss")
                {
                    tpNames = "Barn Roof 1;Barn Roof 2;Way Out Silo";
                    tpCoords = [
                        (3459.9, -7192.55, 1084.54), 
                        (4409.77, 4565.5, 1276.55),
                        (9851.93, -322.705, 1220.62)
                    ];
                }
                else if(level.currentMapName == "mp_crosswalk_ss")
                {
                    tpNames = "Bridge Spot;Roof Spot 1;Roof Spot 2";
                    tpCoords = [
                        (7277.88, 788.631, 5891.38),
                        (1056.44, 832.929, 1661.13),
                        (-4210.05, 156.849, 1757.13)
                    ];
                }
                else if(level.currentMapName == "mp_moab")
                {
                    tpNames = "Rock Wall 1;Rock Wall 2;Way OOM Ledge";
                    tpCoords = [
                        (-970.434, 5818.52, 1981.81),
                        (2502.22, 213.805, 1669.36),
                        (-10704.3, -138.587, 1403.79)
                    ];
                }
                else if(level.currentMapName == "mp_nola")
                {
                    tpNames = "Long Building Roof 1;Long Building Roof 2;Brick Apartments Roof;Building Ledge";
                    tpCoords = [
                        (-2586.91, -3657.49, 559.644),
                        (2652.88, -3703.37, 585.067),
                        (3730.12, 602.36, 777.125),
                        (-4019.16, 272.979, 529.083)
                    ];
                }
                else if(level.currentMapName == "mp_shipbreaker")
                {
                    tpNames = "Lighthouse;Renko III Deck;Cliffside";
                    tpCoords = [
                        (-1672.26, -1495.47, 2288.13),
                        (2970.45, -3312.69, 1468.62),
                        (16528.6, -8081.71, 980.168)
                    ];
                }
                else if(level.currentMapName == "mp_roughneck")
                {
                    tpNames = "";
                    tpCoords = [
                        (-1078.55, 2991.25, 882.125),
                        (-2290.83, 2183.5, 662.263),
                        (2131.96, 1256.85, 1275.82),
                        (243.202, -1202.44, 2477.63),
                        (199.004, -2526.37, 1001.08)
                    ];
                }
                if( isDefined( tpNames ) && isDefined( tpCoords ))
                    self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
                
                break;

                case "class":
                weapon = self getcurrentweapon();
                base = maps\mp\_utility::getbaseweaponname(weapon);
                attOpts = getweaponvalidattachments(base);

                self addMenu("class", "Class Menu"); 
                self addOpt("Weapons", ::newMenu, "wpns");
                
                attachIDs = ["none","acogsmg","acog","reflexsmg","reflexlmg","reflex","silencer","silencer02","silencer03","grip","gl","gp25","m320","akimbo",
                            "thermalsmg","thermal","shotgun","heartbeat","rof","xmags","eotechsmg","eotechlmg","eotech","tactical","vzscope","hamrhybrid","hybrid","zoomscope"];
                
                attachNames = ["None","ACOG","ACOG","Reflex","Reflex","Reflex","Silencer","Silencer","Silencer","Grip","Grenade Launcher","Grenade Launcher",
                            "Grenade Launcher","Akimbo","Thermal","Thermal","Shotgun","Heartbeat","Rapid Fire","Extended Mags","Holographic Sight",
                            "Holographic Sight","Holographic Sight","Tactical Knife","Variable Zoom","HAMR Scope","Hybrid Sight","Variable Zoom"];

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
                
                camoNames = "None;Classic;Snow;Multi;Digital Urban;Hex;Choco;Snake;Blue;Red;Autumn;Gold;Marine;Winter";
                camoNums  = "0;1;2;3;4;5;6;7;8;9;10;11;12;13";
                self addSliderString("Camos", camoNums, camoNames, ::camoString);

                self addSliderString("Equipment", "frag_grenade_mp;semtex_mp;throwingknife_mp;bouncingbetty_mp;claymore_mp;c4_mp;lightstick_mp", "Frag;Semtex;Throwing Knife;Bouncing Betty;Claymore;C4;Glowstick", ::giveEquipment);
                self addSliderString("Tacticals", "flash_grenade_mp;concussion_grenade_mp;scrambler_mp;emp_grenade_mp;smoke_grenade_mp;trophy_mp;flare_mp;portable_radar_mp", "Flash Grenade;Concussion Grenade;Scrambler;EMP Grenade;Smoke Grenade;Trophy System;Tactical Insertion;Portable Radar", ::givesecondaryoffhand);
                self addDvarToggle("Quickdraw", "SOH", ::sohtoggle);
                self addDvarToggle("Save Loadout", "loadoutSaved", ::saveLoadoutToggle);
                self addOpt("Take Current Weapon", ::takeWpn);
                self addOpt("Drop Current Weapon", ::dropWpn);
                self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
                break;

                case "wpns":
                self addMenu("wpns", "Weapons Menu");

                arIDs = "iw5_m4_mp;iw5_m16_mp;iw5_scar_mp;iw5_cm901_mp;iw5_type95_mp;iw5_g36c_mp;iw5_acr_mp;iw5_mk14_mp;iw5_ak47_mp;iw5_fad_mp";
                arNames = "M4A1;M16A4;Scar-L;CM901;Type 95;G36C;ACR 6.8;MK14;AK-47;FAD";
                self addSliderString("Assault Rifles", arIDs, arNames, ::giveUserWeapon);

                smgIDs = "iw5_mp5_mp;iw5_ump45_mp;iw5_pp90m1_mp;iw5_p90_mp;iw5_m9_mp;iw5_mp7_mp";
                smgNames = "MP5;UMP45;PP90M1;P90;PM-9;MP7";
                self addSliderString("Sub Machine Guns", smgIDs, smgNames, ::giveUserWeapon);

                lmgIDs = "iw5_sa80_mp;iw5_mg36_mp;iw5_pecheneg_mp;iw5_mk46_mp;iw5_m60_mp";
                lmgNames = "L86 LSW;MG36;PKP Pecheneg;MK46;M60E4";
                self addSliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon);

                srIDs = "iw5_barrett_mp_barrettscope;iw5_barrett_mp;iw5_l96a1_mp_l96a1scope;iw5_l96a1_mp;iw5_dragonuv_mp_dragonuvscope;iw5_dragonuv_mp;iw5_as50_mp_as50scope;iw5_as50_mp;iw5_rsass_mp_rsassscope;iw5_rsass_mp;iw5_msr_mp_msrscope;iw5_msr_mp";
                srNames = "Barrett .50cal;Scopeless Barrett .50cal;L118A;Scopeless L118A;Dragonuv;Scopeless Dragonuv;AS50;Scopeless AS50;RSASS;Scopeless RSASS;MSR;Scopeless MSR";
                self addSliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon);

                mpIDs = "iw5_fmg9_mp;iw5_mp9_mp;iw5_skorpion_mp;iw5_g18Att_mp";
                mpNames = "FMG9;MP9;Skorpion;G18";
                self addSliderstring("Machine Pistols", mpIDs, mpNames, ::giveUserWeapon);

                sgIDs = "iw5_usas12_mp;iw5_ksg_mp;iw5_spas12_mp;iw5_aa12_mp;iw5_striker_mp;iw5_1887_mp";
                sgNames = "USAS-12;KSG-12;SPAS-12;AA-12;Striker;Model 1887";
                self addSliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon);

                pstlIDs = "iw5_usp45_mp;iw5_p99_mp;iw5_mp412_mp;iw5_44magnum_mp;iw5_fnfiveseven_mp;iw5_deserteagle_mp";
                pstlNames = "USP .45;P99;MP412;.44 Magnum;Five Seven;Desert Eagle";
                self addSliderstring("Pistols", pstlIDs, pstlNames, ::giveUserWeapon);

                lnchrsIDs = "iw5_smaw_mp;javelin_mp;stinger_mp;xm25_mp;m320_mp;rpg_mp;at4_mp";
                lnchrsNames = "SMAW;Javelin;Stinger;XM25;M320;RPG;AT4";
                self addSliderstring("Launchers", lnchrsIDs, lnchrsNames, ::giveUserWeapon);

                self addOpt("Riot Shield", ::giveUserWeapon, "riotshield_mp");
                break;

                case "afthit":
                self addMenu("afthit", "Afterhits Menu");

                arIDs = "iw5_m4_mp;iw5_m16_mp;iw5_scar_mp;iw5_cm901_mp;iw5_type95_mp;iw5_g36c_mp;iw5_acr_mp;iw5_mk14_mp;iw5_ak47_mp;iw5_fad_mp";
                arNames = "M4A1;M16A4;Scar-L;CM901;Type 95;G36C;ACR 6.8;MK14;AK-47;FAD";
                self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

                smgIDs = "iw5_mp5_mp;iw5_ump45_mp;iw5_pp90m1_mp;iw5_p90_mp;iw5_m9_mp;iw5_mp7_mp";
                smgNames = "MP5;UMP45;PP90M1;P90;PM-9;MP7";
                self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

                lmgIDs = "iw5_sa80_mp;iw5_mg36_mp;iw5_pecheneg_mp;iw5_mk46_mp;iw5_m60_mp";
                lmgNames = "L86 LSW;MG36;PKP Pecheneg;MK46;M60E4";
                self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

                srIDs = "iw5_barrett_mp_barrettscope;iw5_barrett_mp;iw5_l96a1_mp_l96a1scope;iw5_l96a1_mp;iw5_dragonuv_mp_dragonuvscope;iw5_dragonuv_mp;iw5_as50_mp_as50scope;iw5_as50_mp;iw5_rsass_mp_rsassscope;iw5_rsass_mp;iw5_msr_mp_msrscope;iw5_msr_mp";
                srNames = "Barret .50cal;Scopeless Barrett .50cal;L118A;Scopeless L118A;Dragonuv;Scopeless Dragonuv;AS50;Scopeless AS50;RSASS;Scopeless RSASS;MSR;Scopeless MSR";
                self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

                lnchrsIDs = "iw5_smaw_mp;javelin_mp;stinger_mp;xm25_mp;m320_mp;rpg_mp;at4_mp";
                lnchrsNames = "SMAW;Javelin;Stinger;XM25;M320;RPG;AT4";
                self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);

                specIDs = "briefcase_bomb_defuse_mp;killstreak_ac130_mp";
                specNames = "Bomb Briefcase;Laptop";
                self addSliderString("Specials", specIDs, specNames, ::afterhit);
                break;

                case "kstrks":
                self addMenu("kstrks", "Killstreak Menu"); 

                Killstreak = ["UAV", "Ballistic Vests", "Care Package", "Counter UAV", "Sentry", "Predator Missile", "AC130", "EMP"];
                for(a=0;a<level.streaks.size;a++)
                self addOpt( Killstreak[a], ::doKillstreak, level.streaks[a] );

                if(self ishost() || self isdeveloper())
                self addOpt("Fake MOAB", ::fakenuke);
                break;

                case "custom":
                self addMenu("custom", "Customization Menu");
                self addSliderString("Menu Bind 1", "+speed_throw;+smoke;+attack;+frag;+actionslot 1;+actionslot 2;+actionslot 3;+actionslot 4;+melee", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}];[{+melee}]", ::updatePreset, "menuBindOne");
                self addSliderString("Menu Bind 2", "+speed_throw;+smoke;+attack;+frag;+actionslot 1;+actionslot 2;+actionslot 3;+actionslot 4;+melee;none", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}];[{+melee}];None", ::updatePreset, "menuBindTwo");
                self addDvarToggle("Menu Instructions", "menuInst", ::toggleMenuInst);
                self addDvarToggle("Almost Hits", "almostHits", ::toggleAlmostHits);
                self addDvarToggle("Distance", "showDistance", ::toggleDistanceMsg);
                self addSliderValue("X Position", int( self LoadPreset( "menuPosX", "155" ) ), -565, 315, 80, ::updatePreset, "menuPosX" );
                self addSliderValue("Y Position", int( self LoadPreset( "menuPosY", "-20" ) ), -180, 300, 80, ::updatePreset, "menuPosY" );
                self addSliderValue("Red", int( self LoadPreset( "menuColorRed", "35" ) ), 0, 255, 15, ::updatePreset, "menuColorRed" );
                self addSliderValue("Green", int( self LoadPreset( "menuColorGreen", "195" ) ), 0, 255, 15, ::updatePreset, "menuColorGreen" );
                self addSliderValue("Blue", int( self LoadPreset( "menuColorBlue", "95" ) ), 0, 255, 15, ::updatePreset, "menuColorBlue" );
                break;

                case "host":
                self addMenu("host", "Host Options");
                self addOpt("Client Menu", ::newMenu, "Verify");
                self addOpt("Lobby Settings", ::newMenu, "lobby");
                self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::addbot);
                self addToggle("Freeze Bots", self.frozenBots, ::toggleFreezeBots);
                self addSliderString("Bot Controls", "teleport;kick", "Teleport to Crosshairs;Kick All Bots", ::botControls);
                self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
                break;

                case "lobby":
                self addMenu("lobby", "Lobby Settings");
                self addToggle("Toggle Floaters", self.floaters, ::togglelobbyfloat);
                self addsliderstring("Minimum Distance", "15;25;50;100;150;200;250", "15;25;50;100;150;200;250", ::setMinDistance);
                self addSliderValue("Game Timer", 0, -10, 10, 1, ::editTime);
                self addOpt("Fast Restart", ::FastRestart);
                break;
            }
        }
        self clientOptions();
    }

    clientOptions()
    {   
        if(!(self isHost() || self isdeveloper()))
            return;

        menu = self getCurrentMenu();
        
        if(menu != "Verify" && menu != "access" && !IsSubStr(menu, "Verify_"))
            return;

        self addMenu("Verify", "Clients Menu");

        foreach( player in level.players )
        {
            perm = self getPlayerPermLabel(player);
            self addOpt(player getName() + " [" + perm + "^7]", ::newMenu, "Verify_" + player GetEntityNumber());
        }

        targetPlayer = undefined;
        foreach( player in level.players )
        {
            if(menu == ("Verify_" + player GetEntityNumber()))
            {
                targetPlayer = player;
                break;
            }
        }

        if(isDefined(targetPlayer))
        {
            self.menuVerifyTarget = targetPlayer;

            perm = self getPlayerPermLabel(targetPlayer);
            self addMenu("Verify_" + targetPlayer GetEntityNumber(), targetPlayer getName() + " [" + perm + "^7]");

            self addOpt("Change Access Level", ::newMenu, "access");
            self addOpt("Give 29 Kills", ::fastlast, targetPlayer);
            self addOpt("Ban Player", ::banSped, targetPlayer);
            self addOpt("Kick Player", ::kickSped, targetPlayer);
            self addOpt("Teleport to Crosshairs", ::teleportToCrosshair, targetPlayer);
        }

        if(menu == "access" && isDefined(self.menuVerifyTarget))
        {
            self addMenu("access", self.menuVerifyTarget getName() + " - Access");

            for(i = 0; i < level.status.size - 1; i++)
                self addOpt("Give: " + level.status[i], ::initializesetup, i, self.menuVerifyTarget);
        }
    }

    getPlayerPermLabel(player)
    {
        perm = "None";

        if(isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
            perm = level.status[player.access];

        if(player isDeveloper())
            perm = perm + " ^7| ^6Developer";

        return perm;
    }

    getPlayerByXuid(xuid)
    {
        for(i = 0; i < level.players.size; i++)
        {
            if(level.players[i] getXUID() == xuid)
                return level.players[i];
        }

        return undefined;
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

        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2, "TOPLEFT", "CENTER", self.presets["X"] + 109, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        resizeMenu();
    }

    menuMonitor()
    {
        self endon("disconnect");
        self endon("end_menu");

        player = self;

        while(player.access != 0)
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
                if(self isButtonPressed("+actionslot 1") || self isButtonPressed("+actionslot 2"))
                {
                    if(!self isButtonPressed("+actionslot 1") || !self isButtonPressed("+actionslot 2"))
                    {
                        if(!self isButtonPressed("+actionslot 1"))
                            self.menu[ self getCurrentMenu() + "_cursor" ] += self isButtonPressed("+actionslot 2");
                        if(!self isButtonPressed("+actionslot 2"))
                            self.menu[ self getCurrentMenu() + "_cursor" ] -= self isButtonPressed("+actionslot 1");

                        self scrollingSystem();
                        wait .08;
                    }
                }
                else if(self isButtonPressed("+actionslot 3") || self isButtonPressed("+actionslot 4"))
                {
                    if(!self isButtonPressed("+actionslot 3") || !self isButtonPressed("+actionslot 4"))
                    {
                        if(isDefined(self.eMenu[ self getCursor() ].val) || IsDefined( self.eMenu[ self getCursor() ].ID_list ))
                        {
                            if( self isButtonPressed("+actionslot 3") )   
                                self updateSlider( "L2" );
                            if( self isButtonPressed("+actionslot 4") )    
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
                        self iPrintLnBold( "^1ERROR: ^7Cannot Access Menus While In A Selected Player" );
                    else if(isDefined(self.sliders[ self getCurrentMenu() + "_" + self getCursor() ])){
                        slider = self.sliders[ self getCurrentMenu() + "_" + self getCursor() ];
                        slider = (IsDefined( menu.ID_list ) ? menu.ID_list[slider] : slider);
                        player thread doOption( menu.func, slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );
                    }
                    else 
                        player thread doOption( menu.func, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5, undefined );

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
                        self newMenu(undefined);
                    wait .2;
                }
            }
            wait .05;
        }
    }

    menuOpen()
    {
        self.menu["isOpen"] = true;
        
        self menuoptions();
        self drawMenu();
        self drawText();
        self setMenuText(); 
        self updateScrollbar();
        self thread menuDeath();
    }

    menuDeath()
    {
        self endon("disconnect");
        self endon("menuClosed");

        while(self.menu["isOpen"])
        {
            self common_scripts\utility::waittill_any("death","game_ended","menuresponse");
            self menuClose();
        }
    }

    menuClose()
    {
        self destroyAll(self.menu["UI"]); 
        self destroyAll(self.menu["OPT"]);
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);
        self.menu["isOpen"] = false;
    }

    drawText()
    {
        self destroyAll(self.menu["OPT"]);

        if(!isDefined(self.menu["OPT"]))
            self.menu["OPT"] = [];

        for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText(self.presets["Option_Font"], self.presets["Font_Scale"], "LEFT", "CENTER", self.presets["X"] + 5, self.presets["Y"] - 62 + (e * 15), 3, 1, "", self.presets["Text"], undefined);
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
        curs = (self getCursor() >= 10) ? 9 : self getCursor();  
        self.menu["UI"]["SCROLLER"].y = (self.menu["OPT"][curs].y);
        //self.menu["UI"]["SCROLLERICON"].y = (self.menu["OPT"][curs].y);
        
        size       = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
        height     = int(15 * size); // 18
        math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
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
        size   = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
        height = int(15 * size);
        math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
        
        self.menu["UI"]["OPT_BG"] SetShader( "white", 200, height + 1 );
        self.menu["UI"]["OUTLINE"] SetShader( "white", 204, height + 54 );
    }

    LoadSettings()
    {
        self.presets = [];

        self.presets["X"] = int( self LoadPreset( "menuPosX", "155" ) );
        self.presets["Y"] = int( self LoadPreset( "menuPosY", "-20" ) );
        self.presets["R"] = int( self LoadPreset( "menuColorRed", "35" ) );
        self.presets["G"] = int( self LoadPreset( "menuColorGreen", "195" ) );
        self.presets["B"] = int( self LoadPreset( "menuColorBlue", "95" ) );
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

            default: return self isButtonPressed( button );
        }
    }

    loadPreset( dvar, defaultVal )
    {
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

    refreshMenu()
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
        
            wait .05;
        
            self menuOpen();

            foreach( menu in previous )
            {
                if( menu != "main" )
                    self newMenu( menu );
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

            if( !isDefined( player GetPlayerCustomDvar( "menuInst" ) ) || player GetPlayerCustomDvar( "menuInst" ) == "" )
                player SetPlayerCustomDvar( "menuInst", "1" );   

            if( !isDefined( player GetPlayerCustomDvar( "suicideBind" ) ) || player GetPlayerCustomDvar( "suicideBind" ) == "" )
                player SetPlayerCustomDvar( "suicideBind", "1" );  

            if( !isDefined( player GetPlayerCustomDvar( "showDistance" ) ) || player GetPlayerCustomDvar( "showDistance" ) == "" )
                player SetPlayerCustomDvar( "showDistance", "1" );   

            if( !isDefined( player GetPlayerCustomDvar( "almostHits" ) ) || player GetPlayerCustomDvar( "almostHits" ) == "" )
                player SetPlayerCustomDvar( "almostHits", "1" );         

            if( !level.rankedMatch )
            {
                player thread bulletImpactMonitor();
                player thread trackstats();
                player dowelcomemessage();
            }

            player thread changeClass();
            player thread menuInst();
            player thread mainBinds();         
            
            if( level.currentGametype == "dm" )
                player thread maps\mp\killstreaks\_uav::launchUav( player, player.team, 9999, "directional_uav" );

            player menuoptions();
            player thread menuMonitor();
        }
    }

    newMenu( menu )
    {
        player = self;
        
        access = 0;
        
        if( access >= player.access )
            return self IPrintLn( "Access: ^1Denied" );

        if(!isDefined( menu ))
        {
            menu = self.previousMenu[ self.previousMenu.size -1 ];
            self.previousMenu[ self.previousMenu.size -1 ] = undefined;
        }
        else 
            self.previousMenu[ self.previousMenu.size ] = self getCurrentMenu();
            
        self setCurrentMenu( menu );

        if(isDefined(menu) && IsSubStr(menu, "Verify_"))
        {
            xuid = getSubStr(menu, 7, menu.size);
            target = self getPlayerByXuid(xuid);
            if(isDefined(target))
                self.menuVerifyTarget = target;
        }
        
        self menuoptions();

        if(self shouldClearMenuStrings())
        {
            self clearMenuStrings();
            self notify("menuInstUpdate");
        }

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

    addOpt( opt, func, p1, p2, p3, p4, p5)
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

    addToggle( opt, bool, func, p1, p2, p3, p4, p5)
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

    addDvarToggle( opt, dvar, func, p1, p2, p3, p4, p5)
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        
        option = spawnStruct();
        
        if( !IsDefined( self GetPlayerCustomDvar( dvar ) ))
            self setPlayerCustomDvar( dvar, "0" );

        option.toggle = ( self GetPlayerCustomDvar( dvar ) == "1");

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

        option.ID_list = inarray(ID_list) ? ID_list : strTok(ID_list, ";");
        option.RL_list = inarray(RL_list) ? RL_list : strTok(RL_list, ";");

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
        textElem = isDefined( isLevel ) ? level maps\mp\gametypes\_hud_util::createServerFontString(font, fontScale) : self maps\mp\gametypes\_hud_util::createFontString(font, fontScale);
        textElem maps\mp\gametypes\_hud_util::setPoint(align, relative, x, y);

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
            textElem settext(text);

        return textElem;
    }

    setSliderText(text)
    {
        if(!isDefined(text))
            text = "";

        self setText(text);
    }
    
    createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha, server)
    {
        player = self;

        boxElem = isDefined(server) ? newHudElem() : newClientHudElem(self);

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
        boxElem maps\mp\gametypes\_hud_util::setPoint(align, relative, x, y);
        boxElem thread watchDeletion(player);
        
        player.hud_amount++;
        return boxElem;
    }

    removeFromArray( array, text )
    {
        new = [];
        foreach( index in array )
        {
            if( index != text )
                new[new.size] = index;
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

    hasMenu()
    {
        player = self;  
        if( IsDefined( player.access ) && player.access != "None" )
            return true;
        return false;    
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

    stringToHex( string )
    {
        if( !isDefined( string ) || string.size <= 0 )
            return "";

        final = "";

        for( i = 0; i < string.size; i++ )
        {
            char = string[i];

            switch( char )
            {
                case "0": final += "30"; break;
                case "1": final += "31"; break;
                case "2": final += "32"; break;
                case "3": final += "33"; break;
                case "4": final += "34"; break;
                case "5": final += "35"; break;
                case "6": final += "36"; break;
                case "7": final += "37"; break;
                case "8": final += "38"; break;
                case "9": final += "39"; break;

                case "A": final += "41"; break;
                case "a": final += "61"; break;

                case "B": final += "42"; break;
                case "b": final += "62"; break;

                case "C": final += "43"; break;
                case "c": final += "63"; break;

                case "D": final += "44"; break;
                case "d": final += "64"; break;

                case "E": final += "45"; break;
                case "e": final += "65"; break;

                case "F": final += "46"; break;
                case "f": final += "66"; break;

                case "G": final += "47"; break;
                case "g": final += "67"; break;

                case "H": final += "48"; break;
                case "h": final += "68"; break;

                case "I": final += "49"; break;
                case "i": final += "69"; break;

                case "J": final += "4A"; break;
                case "j": final += "6A"; break;

                case "K": final += "4B"; break;
                case "k": final += "6B"; break;

                case "L": final += "4C"; break;
                case "l": final += "6C"; break;

                case "M": final += "4D"; break;
                case "m": final += "6D"; break;

                case "N": final += "4E"; break;
                case "n": final += "6E"; break;

                case "O": final += "4F"; break;
                case "o": final += "6F"; break;

                case "P": final += "50"; break;
                case "p": final += "70"; break;

                case "Q": final += "51"; break;
                case "q": final += "71"; break;

                case "R": final += "52"; break;
                case "r": final += "72"; break;

                case "S": final += "53"; break;
                case "s": final += "73"; break;

                case "T": final += "54"; break;
                case "t": final += "74"; break;

                case "U": final += "55"; break;
                case "u": final += "75"; break;

                case "V": final += "56"; break;
                case "v": final += "76"; break;

                case "W": final += "57"; break;
                case "w": final += "77"; break;

                case "X": final += "58"; break;
                case "x": final += "78"; break;

                case "Y": final += "59"; break;
                case "y": final += "79"; break;

                case "Z": final += "5A"; break;
                case "z": final += "7A"; break;

                case " ": final += "20"; break;
                case "_": final += "5F"; break;
                case "-": final += "2D"; break;
                case ".": final += "2E"; break;
                case "!": final += "21"; break;
                case "?": final += "3F"; break;
                case "/": final += "2F"; break;
                case "\\":final += "5C"; break;
                case ":": final += "3A"; break;
                case ";": final += "3B"; break;
                case ",": final += "2C"; break;
                case "'": final += "27"; break;
                case "\"": final += "22"; break;
                case "(": final += "28"; break;
                case ")": final += "29"; break;
                case "[": final += "5B"; break;
                case "]": final += "5D"; break;
                case "{": final += "7B"; break;
                case "}": final += "7D"; break;
                case "#": final += "23"; break;
                case "@": final += "40"; break;
                case "&": final += "26"; break;
                case "*": final += "2A"; break;
                case "+": final += "2B"; break;
                case "=": final += "3D"; break;
                case "%": final += "25"; break;
                case "$": final += "24"; break;
            }
        }

        return final;
    }

    MonitorButtons()
    {
        if(isDefined(self.MonitoringButtons))
            return;
        self.MonitoringButtons = true;
        
        if(!isDefined(self.buttonAction))
            self.buttonAction = ["+stance","+gostand","weapnext","+actionslot 1","+actionslot 2","+actionslot 3","+actionslot 4"];
        if(!isDefined(self.buttonPressed))
            self.buttonPressed = [];
        
        for(a=0;a<self.buttonAction.size;a++)
            self thread ButtonMonitor(self.buttonAction[a]);
    }

    ButtonMonitor(button)
    {
        self endon("disconnect");
        
        self.buttonPressed[button] = false;

        self NotifyOnPlayerCommand("button_pressed_"+button,button);

        while(1)
        {
            self waittill("button_pressed_"+button);
            self.buttonPressed[button] = true;
            wait .025;
            self.buttonPressed[button] = false;
        }
    }

    isButtonPressed(button)
    {
        return self.buttonPressed[button];
    }

    isDeveloper()
    {
        switch(self getxuid())
        {
            case "901fc5263b283": return true; //akaTrxgic
	        case "901fca48f2272": return true; //Optus IV
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

    GetDistance(you, them)
    {
        dx = you.origin[0] - them.origin[0];
        dy = you.origin[1] - them.origin[1];
        dz = you.origin[2] - them.origin[2];    
        return floor(Sqrt((dx * dx) + (dy * dy) + (dz * dz)) * 0.03048);
    }

    GetEnemyTeam()
    {
        if(self.pers["team"] == "allies")
            team = "axis";
        else
            team = "allies";
        
        return team;
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

    remSentryBind(num)
    {
        if( isDefined( self.basedRemSentry ))
        {
            self iPrintLn("Walking Remote Sentry Bind [^1OFF^7]");
            self.basedRemSentry = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] for ^2Walking Remote Sentry");
            self.basedRemSentry = true;

            while(isDefined(self.basedRemSentry))
            {
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_remoteTurret::tryUseRemoteMGTurret(self);
                    self enableWeapons();
                }

                wait .1;
            }
        }
    }

    imsBind(num)
    {
        if( isDefined( self.basedIMS ))
        {
            self iPrintLn("Walking IMS Bind [^1OFF^7]");
            self.basedIMS = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] for ^2Walking IMS");
            self.basedIMS = true;

            while(isDefined(self.basedIMS))
            {
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_ims::tryUseIMS(self);
                    self enableWeapons();
                }

                wait .1;
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
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_autosentry::tryUseAutoSentry(self);
                    self enableWeapons();
                }

                wait .1;
            }
        }
    }

    predBind(num)
    {
        if( isDefined( self.laptop ))
        {
            self iPrintLn("Laptop bind [^1OFF^7]");
            self.laptop = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to Give ^2Laptop");
            self.laptop = true;

            while(isDefined(self.laptop))
            {
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                    self thread giveuserweapon("killstreak_ac130_mp");

                wait .001;
            } 
        } 
    }

    trgrBind(num)
    {
        if( isDefined( self.trgr ))
        {
            self iPrintLn("Trigger bind [^1OFF^7]");
            self.trgr = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to Give ^2Trigger");
            self.trgr = true;

            while(isDefined(self.trgr))
            {
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                    self thread giveuserweapon("c4_mp");
        
                wait .001;
            } 
        } 
    }

    classBind(classNum)
    {
        if(!isDefined(self.ChangeClass))
        {
            self iPrintLn("Press [{+Actionslot 2}] to ^2Change Class");

            self.ChangeClass = true;

            while(isDefined(self.ChangeClass))
            {
                if(self isButtonPressed("+actionslot 2") && !self.menu["isOpen"])
                    self notify( "menuresponse", "changeclass", "custom" + classNum);
                
                wait .001; 
            } 
        } 
        else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
    }

    nightVision(num)
    {
        if( isDefined( self.nightVision ))
        {   
            self iPrintLn("Night Vision Bind [^1OFF^7]");
            self maps\mp\_utility::_SetActionSlot(num, "");
            self.nightVision = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] for ^2Night Vision");
            self.nightVision = true;

            while(isDefined(self.nightVision))
            {
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                    self maps\mp\_utility::_SetActionSlot(num, "nightvision");

                wait .1;
            }
        }
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
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                        self thread CanzoomFunction();
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
                    if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                            heliosNac(); 
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
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
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
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                    self thread MidAirGflip();

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

    doBots()
    {
        hostTeam = (getDvar("host_team"));
        team = hostTeam == "allies" ? "axis" : "allies";

        switch( level.currentGametype )
        {
            case "dm":
            emptySlots = 18 - level.players.size;
            wait .125;
            addbot(emptySlots);
            break;

            case "sd":
            if(getteamplayersalive(self.team != hostTeam <= 1))
                addbot(3, !hostTeam);
            break;

            case "war":
            if(getteamplayersalive(self.team != !hostTeam <= 1))
                addbot(6, !hostTeam);
            break;
        }
    }

    botSetup()
    {
        if (!isDefined(self.pers["isBot"]) || !self.pers["isBot"])
            return;

        self clearperks();
        self setRank(randomintrange(0, 49), randomintrange(0, 15));
        self thread botsCantWin();
        self thread botSwitchGuns();
    }

    botSwitchGuns()
    {
        self endon("disconnect");
        weapons = [];

        weapons = ["iw5_usp45_mp", "iw5_deserteagle_mp"];
        current = 0;

        for (;;)
        {
            self takeallweapons();
            wait .1;
            self takeWeapon(weapons[1 - current]);          
            self giveWeapon(weapons[current]);              
            self switchToWeapon(weapons[current]);          
            wait 0.05; 
            self setWeaponAmmoClip(weapons[current], 0); 
            current = 1 - current;
            wait 0.2;
        }
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

    addbot(num, team)
    {
        team = ( team == "enemy" ) ? self getenemyteam() : self.pers[ "team" ];
        bot = [];
        number = int(num);

        for(i=0; i<number; i++)
        {
            bot[i] = addtestclient(BotRenamer());

            if (!isdefined(bot[i])) 
            {
                wait 1;
                continue;
            }
            
            bot[i].pers["isBot"] = true;
            bot[i] thread SpawnBot(team);
            wait 5;
        }
    }

    SpawnBot(team)
    {
        self endon("disconnect");

        while(!isdefined(self.pers["team"]))
            wait .05;

        self notify("menuresponse", game["menu_team"], team);
        wait .05;

        self notify("menuresponse", "changeclass", "class"+ randomint(5));
    }

    BotRenamer()
    {
        names = [
                "AgreedBog",
                "SyGnUs",
                "XeSoftware",
                "Broph",
                "Moxah",
                "Deprecated",
                "Torq",
                "Kurt",
                "MrFrosty",
                "XeDevn",
                "DougDimmadome",
                "Aciph",
                "Snowman",
                "BigDaddyCosby",
                "arkg0d",
                "NickGurr69",
                "dursoh"
                ];

        if(!isdefined(level.BotNameIndex))
            level.BotNameIndex = 0;

        if(level.BotNameIndex >= names.size)
            level.BotNameIndex = 0;

        name = names[level.BotNameIndex];
        level.BotNameIndex++;

        return name;
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
        attachments = maps\mp\_utility::getWeaponAttachments(weapon);

        foreach(attach in attachments)
            if(attach == attachment)   
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

    saveLoadout() 
    {
        wait .01;
            
        self.primaryWeaponList = self getWeaponsListPrimaries();
        self.offHandWeaponList = self GetWeaponsListOffhands();

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
        self GiveWeapon(weap, num);
        self switchToWeapon(weap);  
        self setSpawnWeapon(weap); 
        self setweaponammoclip(weap,myclip);  
        self setweaponammostock(weap,mystock);  
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
            self maps\mp\_utility::_unsetperk( "specialty_quickdraw" );
            self maps\mp\_utility::_unsetperk( "specialty_fastoffhand" );
            self setPlayerCustomDvar( "SOH", "0" );
        } 

        else
        {
            self maps\mp\_utility::giveperk( "specialty_quickdraw", false );
            self maps\mp\_utility::giveperk( "specialty_fastoffhand", false );
            self setPlayerCustomDvar( "SOH", "1" );
        }
    }

    camoString(camoNum)
    {
        num = int( camoNum );
        if(num < 10 && num > 0)num = "0"+num;
        weapon = self GetCurrentWeapon();
        
        if(num > 0)
        {
            if(isSubStr(weapon,"_camo"))
            {
                weapon1 = StrTok(weapon,"_");
                string  = "";
                for(a=0;a<weapon1.size;a++)
                    if(!isSubStr(weapon1[a],"camo"))
                        string += weapon1[a]+"_";
                
                string += "camo"+num;
            }
            else string = weapon+"_camo"+num;
        }
        else
        {
            weapon1 = StrTok(weapon,"_");
            string  = "iw5";
            
            for(a=1;a<weapon1.size;a++)
                if(!isSubStr(weapon1[a],"camo"))
                    string += "_"+weapon1[a];
        }
        
        self TakeWeapon(weapon);
        self GiveWeapon(string);
        self SetSpawnWeapon(string);
    }

    GivePlayerAttachment(attachment)
    {
        weapon      = self GetCurrentWeapon();
        base        = maps\mp\_utility::getBaseWeaponName(weapon);
        attachments = maps\mp\_utility::GetWeaponAttachments(weapon);
        stock       = self GetWeaponAmmoStock(weapon);
        clip        = self GetWeaponAmmoClip(weapon);

        keep = "";
        newAttachments = [];

        akimbo      = false;

            if(HasAttachment(weapon, attachment))
            {
                if(isDefined(attachments) && attachments.size > 1)
                {
                    for(a = 0; a < attachments.size; a++)
                        if(attachments[a] != attachment)
                            keep = attachments[a];
                }
                else
                    keep = "none";
            
                newWeapon = maps\mp\gametypes\_class::buildWeaponName(base, keep, "none");
            }
            else
            {
                if(attachments.size && attachment != "none")
                {
                    for(a = 0; a < attachments.size; a++)
                    {
                        if(IsValidAttachmentCombo(attachments[a], attachment))
                            newAttachments = [attachments[a], attachment];
                        else if(IsValidAttachmentCombo(attachment, attachments[a]))
                            newAttachments = [attachment, attachments[a]];
                    
                        if(isDefined(newAttachments))
                            break;
                    }
                }
            
                if(!isDefined(newAttachments))
                    newAttachments = [attachment, "none"];
            
                newWeapon = maps\mp\gametypes\_class::buildWeaponName(base, newAttachments[0], newAttachments[1]);
            }
        
            if(keep == "akimbo" || inarray(newAttachments, "akimbo") || attachment == "akimbo")
                akimbo = true;
        
            self TakeWeapon(weapon);
            self GiveWeapon(newWeapon, 0, akimbo);
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

    GetWeaponValidAttachments(weapon)
    {
        attachments = [];
        
        for(a = 11;; a++)
        {
            column = TableLookUp("mp/statsTable.csv", 4, weapon, a);
            
            if(!isDefined(column) || column == "")
                break;
            
            attachments[attachments.size] = column;
        }
        
        return attachments;
    }

    IsValidAttachmentCombo(attachment1, attachment2)
    {
        return TableLookup("mp/attachmentCombos.csv", 0, attachment1, TableLookupRowNum("mp/attachmentCombos.csv", 0, attachment2)) != "no";
    }

    loadLoadout() 
    {
        self takeAllWeapons();
            
        if (!isDefined(self.primaryWeaponList) && self getPlayerCustomDvar("loadoutSaved") == "1") 
        {
            for (i = 0; i < int(self getPlayerCustomDvar("primaryCount")); i++) 
                self.primaryWeaponList[i] = self getPlayerCustomDvar("primary" + i);

            for (i = 0; i < int(self getPlayerCustomDvar("secondaryCount")); i++) 
                self.offHandWeaponList[i] = self getPlayerCustomDvar("secondary" + i);
        }

        for (i = 0; i < self.primaryWeaponList.size; i++) 
        {
            weapon = self.primaryWeaponList[i];
            //weaponOptions = self calcWeaponOptions(self.camo, self.currentLens, self.currentReticle, 0);
            if(issubstr(weapon, "akimbo"))
                self giveuserweapon(weapon, true);
            else
                self giveuserweapon(weapon, false); //0, weaponOptions 
                self giveMaxAmmo(weapon);
        }

        self switchToWeapon(self.primaryWeaponList[1]);
        self setSpawnWeapon(self.primaryWeaponList[1]);
        self giveWeapon("knife_mp");
        for (i = 0; i < self.offHandWeaponList.size; i++) 
        {
            offhand = self.offHandWeaponList[i];

                switch (offhand) 
                {
                    case "frag_grenade_mp":
                    case "semtex_mp":
                    case "throwingknife_mp":
                    case "bouncingbetty_mp":
                    case "claymore_mp":
                    case "c4_mp":
                    self thread giveequipment(offhand);
                    break;

                    case "flash_grenade_mp":
                    case "concussion_grenade_mp":
                    case "smoke_grenade_mp":
                    case "flare_mp":
                    case "trophy_mp":
                    case "scrambler_mp":
                    case "portable_radar_mp":
                    case "emp_grenade_mp":
                    self thread givesecondaryoffhand(offhand);
                    break;

                    default:
                    self giveWeapon(offhand);
                    break;
            }
        }
    }

    giveEquipment( equipment )
    {
        self TakeWeapon(self GetCurrentOffhand());
        self SetOffhandPrimaryClass("other");

        if( equipment == "lightstick_mp" )
        {
            self GiveWeapon("lightstick_mp");
            self SetWeaponHudIconOverride( "primaryoffhand", "lightstick_mp" );
        }

        else
        {
            equipment = maps\mp\perks\_perks::validatePerk( 1, equipment );
            self maps\mp\_utility::giveperk( equipment, true );
        }
    }

    GiveSecondaryOffhand(offhand)
    {
        weaponList = self GetWeaponsListOffhands();
        
        foreach( weapon in weaponList )
        {
            switch( weapon )
            {
                case "flash_grenade_mp":
                case "concussion_grenade_mp":
                case "smoke_grenade_mp":
                case "flare_mp":
                case "trophy_mp":
                case "scrambler_mp":
                case "portable_radar_mp":
                case "emp_grenade_mp":
                self TakeWeapon( weapon );
                break;
            }
        }
                
        if ( offhand == "flash_grenade_mp" )
            self SetOffhandSecondaryClass( "flash" );

        else if ( offhand == "smoke_grenade_mp" || offhand == "concussion_grenade_mp" )
            self SetOffhandSecondaryClass( "smoke" );

        else 
            self SetOffhandSecondaryClass( "flash" );

        switch( offhand )
        {
            case "smoke_grenade_mp":
                self giveWeapon( offhand );
                self setWeaponAmmoClip( offhand, 1 );
                break;
            case "flash_grenade_mp":
                self giveWeapon( offhand );
                self setWeaponAmmoClip( offhand, 2 );
                break;
            case "concussion_grenade_mp":
                self giveWeapon( offhand );
                self setWeaponAmmoClip( offhand, 2 );
                break;
            case "emp_grenade_mp":
                self giveWeapon( offhand );
                self setWeaponAmmoClip( offhand, 1 );
                break;
            case "specialty_portable_radar":
                self maps\mp\_utility::giveperk( offhand, false );
                self setWeaponAmmoClip( "portable_radar_mp", 1 );
                break;
            case "specialty_scrambler":
                self maps\mp\_utility::giveperk( offhand, false );
                self setWeaponAmmoClip( "scrambler_mp", 1 );
                break;
            case "specialty_tacticalinsertion":
                self maps\mp\_utility::giveperk( offhand, false );
                self setWeaponAmmoClip( "flare_mp", 1 );
                break;
            case "trophy_mp":
                self maps\mp\_utility::giveperk( offhand, false );
                self setWeaponAmmoClip( offhand, 1 );
                break;
            default:
                self giveWeapon( offhand );
                self setWeaponAmmoClip( offhand, 1 );
                break;
        }
    }

    giveQuickdrawKillstreak()
    {
        if(!self.quickdraw)
        {
            self maps\mp\_utility::giveperk( "specialty_quickdraw", false );
            self maps\mp\_utility::giveperk( "specialty_fastoffhand", false );
            self.quickdraw = 1;
        }
        else if(self.quickdraw)
        {
            self unsetperk("specialty_quickdraw");
            self unsetperk("specialty_fastoffhand");
            self.quickdraw = 0;
        }
    }

    rhThrowingKnife()
    {
        wait .1;
        self takeweapon(self getcurrentoffhand());
        wait 0.01;
        self giveweapon("throwingknife_mp",0,false);
        wait 0.01;
        self takeweapon("throwingknife_mp");
        wait 0.01;
        self giveweapon("throwingknife_rhand_mp",0,false); 
    }

    giveUserWeapon(weapon, akimbo) 
    {      
        if(self hasWeapon(Weapon))
        {
            self SetSpawnWeapon(Weapon);
            return;
        }

        if(issubstr(weapon, "akimbo"))
            akimbo = true;

        self GiveWeapon(Weapon, 0, Akimbo);
        self GiveMaxAmmo(Weapon);
        self SwitchToWeapon(Weapon);
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
        timeLeft       = GetDvar("scr_"+level.currentGametype+"_timelimit");
        timeLeftProper = int(timeLeft);

        setTime = timeLeftProper + value;
        SetDvar("scr_"+level.currentGametype+"_timelimit", setTime);
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
                bombZones[a] common_scripts\utility::trigger_off(); //common_scripts/utility
                level.bombsDisabled = true;
            }

            else
            {
                bombZones[a] common_scripts\utility::trigger_on();  //common_scripts/utility
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

    AfterHit(gun)
    {
        self endon( "disconnect" );

        if( isDefined( self.AfterHit ) )
        {
            self iprintln("Afterhits [^1OFF^7]");
            self.AfterHit = undefined;
            KeepWeapon    = undefined;
        }

        else
        {
            self iprintln("Afterhit Weapon set: [^2" + gun + "^7]");
            self thread doAfterHit(gun);
            self.AfterHit = true;
        }
    }

    doAfterHit(gun)
    {
        level waittill("game_ended");
        
        KeepWeapon = ( self getcurrentweapon() );
        
        self freezecontrols(false);
        self giveweapon(gun);
        self takeWeapon(KeepWeapon);
        self switchToWeapon(gun);
        wait 0.02;
        self freezecontrols(true);
    }
    
    endGame()
    {
        level thread maps\mp\gametypes\_gamelogic::forceEnd();
    }

    doKillstreak(name)
    {
        self maps\mp\killstreaks\_killstreaks::giveKillstreak(name, false );
        self iPrintln( "Given ^2" + name);
    }

    FakeNuke()
    {
        foreach(player in level.players)
        {
            player maps\mp\killstreaks\_nuke::tryUseNuke(1);

            while(!isdefined(level.nukedetonated))
            wait 0.5;

            setslowmotion(1, .25, .5);
            maps\mp\gametypes\_gamelogic::resumeTimer();
            level.timeLimitOverride = false;

            SetDvar( "ui_bomb_timer", 0 );
            level notify( "nuke_cancelled" );
            level.nukedetonated = undefined;
            level.nukeincoming  = undefined;
            
            wait 1;
            setSlowMotion( 0.25, 1, 2.0 );
            
            wait 1.5;
            VisionSetNaked(level.currentMapName, 0.5);
            
            wait .1;
            break;
        }
    }

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

    doWelcomeMessage()
    {
        mode = "";

        switch( level.currentGametype )
        {
            case "dm":
            mode = "FFA";
            break;

            case "sd":
            mode = "SND";
            break;

            case "war":
            mode = "TDM";
            break;
        }

        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise " + mode +"!");
    }

    menuInst()
    {
        self endon( "disconnect" );
        self endon( "game_ended" );

        menuInst = self maps\mp\gametypes\_hud_util::createFontString( "objective", 1 );

        self.menuInst = menuInst;

        menuInst.x = 150;
        menuInst.y = 462;

        menuInst.alpha = ( self GetPlayerCustomDvar( "menuInst" ) == "0" ) ? 0 : 1;
        
        instString = ( isDefined( self.presets["BindTwo"] ) && self.presets["BindTwo"] != "none" ) ? "[{" + self.presets["BindOne"] + "}] + [{" + self.presets["BindTwo"] + "}] = Paradise" : "[{" + self.presets["BindOne"] + "}] = Paradise";
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

            instString = ( isDefined( self.menu["isOpen"] ) && self.menu["isOpen"] ) ? "[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select [{+melee}] = Back/Close" : ( (isDefined( self.presets["BindTwo"] ) && self.presets["BindTwo"] != "none") ? "[{" + self.presets["BindOne"] + "}] + [{" + self.presets["BindTwo"] + "}] = Paradise" : "[{" + self.presets["BindOne"] + "}] = Paradise" );
            menuInst settext( instString );
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

    mainBinds()
    {
        self endon( "disconnect" );
        
        for( ;; )
        {
            if( self getStance() == "crouch" && self meleeButtonPressed() && !self.menu["isOpen"] )
            {
                self thread refillAmmo();
                wait 0.3;
            }

            if( !level.rankedMatch )
            {
                if( self getPlayerCustomDvar( "suicideBind" ) == "1" )
                {                
                    if( self secondaryoffhandButtonPressed() && self fragbuttonpressed() && !self.menu["isOpen"] )
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
        weapons = self getweaponslistprimaries();
        grenades = self getweaponslistoffhands();

        for(w=0;w<weapons.size;w++) 
            self GiveMaxAmmo(weapons[w]);

        for(g=0;g<grenades.size;g++) 
            self GiveMaxAmmo(grenades[g]);
    }

    changeClass()
    {
        self endon("disconnect");

        game["strings"]["change_class"] = "";

        for(;;)
        {
            self waittill("menuresponse", menu, className);

            wait .1; 
            
            if (isDefined(level.classMap[className]))
            {   
                self.pers["class"] = className; 
                self maps\mp\gametypes\_class::setClass(self.pers["class"]);
                self maps\mp\gametypes\_class::giveLoadout(self.pers["team"], self.pers["class"]);
            }

            wait .01;
        }
    }

    bulletImpactMonitor()
    {
        self endon( "disconnect" );
        level endon( "game_ended" );

        for( ;; )
        {
            self waittill( "weapon_fired" );

            eAttacker = self;

            if( self getplayercustomdvar( "almostHits" )  == "0" )
                return;

            if( self isOnGround() )
                continue;

            start = self getTagOrigin( "tag_eye" );
            end = anglestoforward( self getPlayerAngles() ) * 1000000;
            impact = BulletTrace( start, end, true, self )["position"];
            nearestDist = 150;

            hostTeam = ( getDvar( "host_team" ) );
            enemyTeam = maps\mp\_utility::getotherteam( eAttacker.team );

            foreach( player in level.players )
            {
                dist = distance( player.origin, impact );
                nearestPlayer = player;

                weapon = self getcurrentweapon();

                if( dist < nearestDist && isdamageweapon( weapon ) && player != self )
                {
                    nearestDist = dist;
                    nearestPlayer = player;
                }
            }

            if( nearestDist != 150 )
            {
                ndist = nearestDist * 0.0254;
                ndist_i = int( ndist );

                ndist = ( ndist_i < 1 ) ? getsubstr( ndist, 0, 3 ) : ndist_i;

                distToNear = distance( self.origin, nearestPlayer.origin ) * 0.0254;
                dist = int( distToNear );

                distToNear = ( dist < 1 ) ? getsubstr( distToNear, 0, 3 ) : dist;

                if( level.currentGametype == "dm" )  
                    if( self.kills == 29 && isAlive( nearestPlayer ) && isDamageWeapon( weapon ) )
                        self thread registerAlmostHit( nearestPlayer, dist );
            }
        }
    }

    registerAlmostHit( nearestPlayer, dist )
    {
        iprintln( "^2" + self.name + "^7 almost hit ^1" + nearestPlayer.name + " ^7from ^1" + dist + "m^7!" );
        self.ahCount++;

        if( self.ahCount % 3 == 0 ) self iprintlnbold( "^1" + rndmmgfunnymsg() );
    }

    trackstats()
    {
        self endon( "disconnect" );
        level waittill( "game_ended" );

        if( self getplayercustomdvar( "almostHits" )  == "0" )
            return;

        if( level.currentGametype == "dm" )
        {
            wait 0.5;

            if(self.ahCount == 1) self iprintln( "You almost hit ^1" + self.ahCount + " ^7time!" );

            else if(self.ahCount > 0) self iprintln( "You almost hit ^1" + self.ahCount + " ^7times!" );
            
            else self iprintln( "You didn't almost hit ^1anyone^7! " + self rndmEGfunnyMsg() );
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

            case "war":
            game["teamScores"][player.pers["team"]] = 7400;
            setTeamScore(player.pers["team"], game["teamScores"][player.pers["team"]]);
            break;
        }
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

            if( self.snl && self isbuttonpressed("+actionslot 2") && self GetStance() == "crouch")
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

    initNoClip()
    {    
        if(level.oomUtilDisabled)
        {
            self iprintln("^1ERROR^7: UFO use is [^1Disabled^7]!");
            return;
        }

        if(!self.NoClipT)
        {
            self thread doNoClip();
            self.NoClipT = 1;
        }
        else
        {
            self notify("EndNoClip");
            self.NoClipT = 0;
        }
    }

    doNoClip()
    {
        self endon("EndNoClip");
        self.Fly = 0;
        UFO = spawn("script_model", self.origin);

        for (;;) 
        {
            if (self FragButtonPressed()) 
            {
                self playerLinkTo(UFO);
                self.Fly = 1;
            } else 
            {
                self unlink();
                self.Fly = 0;
            }
            if (self.Fly == 1) 
            {
                Fly = self.origin + vectorScale(anglesToForward(self getPlayerAngles()), 20);
                UFO moveTo(Fly, .01);
            }
            wait .001;
        }
    }

    DolphinDive()
    {
        if(!IsDefined( self.DolphinDive ))
        {
            self.DolphinDive = true;
            
            while(IsDefined( self.DolphinDive ))
            {
                self.Prone360 = true;
                setDvar("bg_prone_yawcap", 360);
                
                if(self isSprinting())
                {
                    vec = AnglesToForward( self GetPlayerAngles() );
                    end = ( vec[0] * 110,vec[1] * 110,vec[2] * 110 );
                        
                    if(self GetStance() == "crouch" && self IsOnGround())
                    {
                        self SetStance( "prone" );
                        self SetVelocity( self GetVelocity() + end + (0, 0, 300) );
                            
                        while(1)
                        {
                            if(self IsOnGround())
                            break;
                            wait .05;
                        }
                    }
                }
                wait .05;
            }
        }    
        else
            self.DolphinDive = undefined; 
    }

    isSprinting()
    {
    v = self GetVelocity();
            
    return v[0] >= 190 || v[1] >= 190 || v[0] <= -190 || v[1] <= -190;
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
                self setVelocity(self getVelocity() + (0, 0, 200));

            wait 0.01;
        }
    }

    makeSlide(slideEntity)
    {
        level endon("game_ended");
        self endon("disconnect");
        self endon("stop_slide");

        for (;;)
        {
            if (!isDefined(slideEntity)) 
                break;

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
                        player setVelocity(player getVelocity() + (0, 0, 100));
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

    SpawnScriptModel(origin,model,angles,time,clip)
    {
        if(isDefined(time))
            wait time;

        ent = spawn("script_model",origin);
        ent SetModel(model);
        
        if(isDefined(angles))
            ent.angles = angles;
        if(isDefined(clip))
            ent CloneBrushModelToScriptModel(clip);

        return ent;
    }

    doSpawnables( action, type )
    {
        switch( type )
        {
            case "cpStall":
            if( action == "delete" )
            {
                if( isDefined( self.spawnedCP ) )
                    self.spawnedCP maps\mp\killstreaks\_airdrop::deleteCrate();
            }

            else
            {
                if ( isDefined( self.spawnedCP ) )
                    self.spawnedCP maps\mp\killstreaks\_airdrop::deleteCrate();

                cpOrigin = bullettrace( self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglesToForward( self getplayerangles() ) * 100, 0, self )[ "position" ] + ( 0, 0, 20 );
                self.spawnedCP = spawnscriptmodel( cpOrigin, "com_plasticcase_friendly", self.angles,(0,0,0),level.airdropcratecollision);
                self.spawnedCP.team = self.team;
                self.spawnedCP.owner = self;
                self.spawnedCP.cratetype = "uav";
                self.spawnedCP maps\mp\killstreaks\_airdrop::killstreakCrateThink("airdrop_assault");
            }
            break;

            case "slide":
            if (action == "delete")
            {
                if( isDefined(self.slideThread) )
                {
                    self.slideThread delete();
                    self.slideThread = undefined;
                }

                if( isDefined(self.spawnedSlide))
                {
                    self.spawnedSlide delete();
                    self.spawnedSlide = undefined;
                }
            }

            else
            {
                if (isDefined(self.slideThread))
                {
                    self.slideThread delete();
                    self.slideThread = undefined;
                }
                if (isDefined(self.spawnedSlide))
                {
                    self.spawnedSlide delete();
                    self.spawnedSlide = undefined;
                }

                slideOrigin = (bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 100,0,self)["position"] + (0, 0, 20));
                self.spawnedSlide = spawnscriptmodel(slideOrigin, "com_plasticcase_enemy", self.spawnedSlide.angles, (0,0,0), level.airdropcratecollision);
                self.spawnedSlide.angles = (60, self getPlayerAngles()[1] - 180, 0);
                self.slideThread = self thread makeSlide(self.spawnedSlide);
            }
            break;

            case "bounce":
            if(action == "delete")
            {
                if(isDefined(self.trampolineThread))
                {
                    self.trampolineThread delete();
                    self.trampolineThread = undefined;
                }

                if(isDefined(self.spawnedTrampoline))
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

                if( isDefined( self.spawnedTrampoline))
                {
                    self.spawnedTrampoline delete();
                    self.spawnedTrampoline = undefined;
                }
        
                self.spawnedTrampoline = spawn("script_model", self.origin);
                self.spawnedTrampoline setModel("com_plasticcase_enemy");
                self.trampolineThread = self thread monitortrampoline(self.spawnedTrampoline);
            }
            break;

            case "platform":
            if(level.oomUtilDisabled)
            {
                self iprintln("^1ERROR^7: Platform Spawning is [^1Disabled^7]!");
                return; 
            }

            if( action == "delete")
            {
                if(!isDefined(self.spawnedplat))
                self.spawnedplat = [];

                if(isDefined(self.spawnedplat) && action == "delete")
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

                startpos = self.origin + (0, 0, -15);

                for(i = -3; i < 3; i++)
                {    
                    if(!isDefined(self.spawnedplat[i]))
                    self.spawnedplat[i] = [];
                
                    for(d = -3; d < 3; d++)
                        self.spawnedplat[i][d] = spawnScriptModel(startpos + (d * 56, i * 30, 0),"com_plasticcase_enemy",(0,0,0),0,level.airDropCrateCollision);
                }
            }
            break;

            case "crate":
            if(level.oomUtilDisabled)
            {
                self iprintln("^1ERROR^7: Crate Spawning is[^1Disabled^7]!");
                return;
            }

            if (action == "delete")
            {
                if(isDefined(self.spawnedcrate))
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

                self.spawnedcrate = spawnscriptmodel(self.origin + (0, 0, -15), "com_plasticcase_enemy", (0,0,0), 0, level.airdropcratecollision);
            }
            break;
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
        weap = "iw5_mk46_mp";
        self giveweapon(weap);
        self dropitem(weap);
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

    lazyeletggl() 
    {
        if(!self.lazyEles)
        {
            self.lazyEles = 1;
            self thread lazyele();
        }
        else if(self.lazyEles)
        {
            self notify ("stop_lzEle");
            self.lazyEles = 0;
        }
    }

    lazyele()
    {
        self endon("stop_lzEle");

        for(;;)
        {
            while (self getStance() != "crouch") 
                wait .01;
            while (self getStance() != "stand") 
                wait .01;
                
            x = self.origin[0];
            z = self.origin[1];
            
            if (x > 0)
                x += 0.15;
            else
                x -= 0.15;
            if (z > 0)
                z += 0.15;
            else
                z -= 0.15;
            self setOrigin((int(x), int(z), self.origin[2]));
            wait .01;
        }
    }

    toggleSuiBind()
    {
        if( self getPlayerCustomDvar( "suicideBind" ) == "1" )
            self setPlayerCustomDvar( "suicideBind", "0" );
        
        else
            self setPlayerCustomDvar( "suicideBind", "1" );
    }

    shouldClearMenuStrings()
    {
        menu = self getCurrentMenu();

        if(IsSubStr(menu, "Verify"))
            return false;

        if(self.eMenu.size > 12)
            return true;

        for(i = 0; i < self.eMenu.size; i++)
        {
            if(IsDefined(self.eMenu[i].ID_list))
                return true;
        }

        return false;
    }

    clearMenuStrings()
    {
        if(!isDefined(level.overflowMarker))
            return;

        level.overflowMarker ClearAllTextAfterHudElem();
        level.strings = [];
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