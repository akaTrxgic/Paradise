    //Main.gsc
    init()
    {
        level.strings              = [];
        level.status               = strtok("None;^2Verified;^5CoHost;^1Host", ";");
        level.MenuName             = "Paradise";
        level.currentMapName       = getDvar("mapname");
        level.currentGametype      = getDvar("g_gametype");
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;
        level.streaks              = strtok("uav;airdrop;counter_uav;airdrop_sentry_minigun;predator_missile;precision_airstrike;harrier_airstrike;helicopter;airdrop_mega;helicopter_flares;stealth_airstrike;helicopter_minigun;ac130;emp", ";");

        if( !level.rankedMatch )
        {
            level.lastKill_minDist      = 15;
            level.oomUtilDisabled       = 0;
            level.BotNameIndex          = 0;
        }

        else
            level.bombsDisabled = true;

        mw2Precache();
        initDvars();

        if( level.currentGametype != "sd" )
            level thread autoFakeNuke();
            
        level thread onPlayerConnect();
    }

    mw2Precache()
    {
        precacheshader("hudsoftline");
        precacheitem("lightstick_mp");
        precacheitem("deserteaglegolden_mp");
        precacheitem("throwingknife_rhand_mp");
        precachemodel("com_plasticcase_enemy");
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

            player loadsettings();
            player thread MonitorButtons();
            player thread kcAntiQuit();
            player thread ServerSettings();
            player SetClientDvar("motd", "^0Thanks For Playing! ^7|| ^0discord.gg/qbpnQfbVqY ^7|| ^0Menu By: ^1akaTrxgic ^7& ^2Deprecated");
            player thread OnPlayerSpawned();
        }
    }

    OnPlayerSpawned()
    {
        self endon( "disconnect" );

        for(;;)
        {
            self waittill( "spawned_player" );

            if( self getPlayerCustomDvar( "loadoutSaved" ) == "1" ) 
                self loadLoadout();

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
                        self thread maps\mp\killstreaks\_uav::launchUAV( self, self.team, 9999, false );

                        if( level.currentGametype == "war" )
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
                    setDvar("testClients_doAttack", 1);
                    setDvar("testClients_doCrouch", 0);
                    setDvar("testClients_doMove", 1);
                    setDvar("testClients_doReload", 1);
                    setDvar("testClients_watchKillcam",0);
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
                iDamage = 999;
                
                if( eAttacker getplayercustomdvar( "showDistance" ) == "1" )
                    eAttacker iprintln("[^1" + dist + "m^7]");
            } 

            else
            {
                if(sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH")
                    iDamage = 0;

                else if(eAttacker.kills == 29)
                {
                    if(dist >= level.lastKill_minDist)
                    {
                        if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
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

                        else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand"))
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
                        
                        else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand"))
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

                return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
            }
        }
    }

    isdamageweapon(sweapon)
    {
        if(!IsDefined(sweapon))
            return 0;

        if(issubstr(sWeapon, "fal") || issubstr(sweapon, "cheytac") || issubstr(sWeapon, "barrett") || issubstr(sweapon, "wa2000") || issubstr(sweapon, "m21"))
            return 1;
        else
            return 0;
    }

    initDvars()
    {
        setDvar("host_team", self.team);
        setDvar("bg_bounces", 1 );
        setDvar("bg_elevators", 2 );
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

    autoFakeNuke()
    {
        level endon("game_ended");
        level waittill("prematch_over");

        while(1)
        {
            timePassed = getTimePassed() / 1000;
            timeLimit  = getTimeLimit() * 60;

            timeRemaining = timeLimit - timePassed;

            if(timeRemaining <= 3 && timeRemaining > 0)
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

    hook_firstBlood( killId )
    {
        return;
    }

    ServerSettings()
    {
        //BulletPenetration
        WriteFloat("0x82008898", 9999999.0);

        WriteByte( "0x820E217C", 0x60 ); //BG_GetSurfacePenetrationDepth(bne(branch if not equal) call to loc_820E218C)
        WriteByte( "0x820E217D", 0x00 );
        WriteByte( "0x820E217E", 0x00 );
        WriteByte( "0x820E217F", 0x00 );

        WriteByte( "0x820E2184", 0x60 ); //BG_GetSurfacePenetrationDepth(lfs(load floating point single) from __real_00000000)
        WriteByte( "0x820E2185", 0x00 );
        WriteByte( "0x820E2186", 0x00 );
        WriteByte( "0x820E2187", 0x00 );

        //Range
        WriteByte( "0x821CF3E4", 0xC3 ); //Bullet_Fire(lfs(load floating point single) from aF_0)
        WriteByte( "0x821CF3E5", 0xEB );
        WriteByte( "0x821CF3E6", 0x88 );
        WriteByte( "0x821CF3E7", 0x98 );

        WriteByte( "0x821CF3C4", 0x48 ); //Bullet_Fire(beq(branch if equal) to loc_821CF3DC) -- Force branch to loc_821CF3DC(Allow all weapons to have max bullet range)
        WriteByte( "0x821CF3C5", 0x00 );
    }

    //Menu.gsc
    menuOptions()
    {
        player = self.selected_player;        
        menu = self getCurrentMenu();
        
        player_names = [];
        foreach( players in level.players )
            player_names[player_names.size] = players.name;

        if( level.rankedMatch )
        {
            if( menu == "main" )
            {
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

                    if(self ishost() || self isDeveloper() || player.access == 2) 
                        self addOpt("Host Options", ::newMenu, "host");

                    self addOpt("^2Discord.gg/qbpnQfbVqY");
                }
            }

            else if( menu == "ts" )
            {
                self addMenu("ts", "Trickshot Menu");
                self addOpt("Unstuck", ::doUnstuck);
                self addOpt("Tp to Spawn", ::tpToSpawn);
                self addToggle("Lazy Elevators", self.lazyEles, ::lazyeletggl);

                if(level.currentGametype == "dm")
                    self addOpt("Go for Two Piece", ::dotwopiece);

                self addOpt("Drop Canswap", ::dropCanswap);
                self addSliderString("Canswaps", "Current;Infinite", "Current;Infinite", ::SetCanswapMode);
                self addToggle("Instashoots", self.instashoot, ::instashoot);                
                self addToggle("Dolphin Dive", self.DolphinDive, ::DolphinDive);
                self addToggle("Riot Shield Knife", self.riotKnife, ::riotKnife);
                self addToggle("Laptop Knife", self.predKnife, ::predKnife);
                self addOpt("Spawn CP Stall", ::doSpawnables, "cpStall");
                self addOpt("Suicide", ::kys);
            }

            else if( menu == "sK" )
            {
                self addMenu("sK", "Binds Menu");
                self addOpt("Change Class Bind", ::newMenu, "cb");
                self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
                self addOpt("Nac Mod Bind", ::newMenu, "nmod");
                self addOpt("Skree Bind", ::newMenu, "skree");
                self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
                self addOpt("Walking Sentry Bind", ::newMenu, "sentry");
                self addOpt("Laptop Bind", ::newMenu, "laptop");
                self addOpt("Bomb Briefcase Bind", ::newMenu, "bomb");
                self addOpt("Trigger Bind", ::newMenu, "trgr");
                self addOpt("Night Vision Bind", ::newMenu, "nightVis");
            }

            else if( menu == "nightVis" )
            {
                self addMenu("nightVis", "Night Vision Bind");
                self addOpt("Night Vision Bind: [{+actionslot 1}]", ::nightVision, 1);
                self addOpt("Night Vision Bind: [{+actionslot 2}]", ::nightVision, 2);
                self addOpt("Night Vision Bind: [{+actionslot 3}]", ::nightVision, 3);
                self addOpt("Night Vision Bind: [{+actionslot 4}]", ::nightVision, 4);
            }

            else if( menu == "sentry" )
            {
                self addMenu("sentry", "Walking Sentry Bind");
                self addOpt("Walking Sentry Bind: [{+actionslot 1}]", ::sentryBind, 1);
                self addOpt("Walking Sentry Bind: [{+actionslot 2}]", ::sentryBind, 2);
                self addOpt("Walking Sentry Bind: [{+actionslot 3}]", ::sentryBind, 3);
                self addOpt("Walking Sentry Bind: [{+actionslot 4}]", ::sentryBind, 4);
            }

            else if( menu == "laptop" )
            {
                self addMenu("laptop", "Laptop Bind");
                self addOpt("Laptop Bind: [{+actionslot 1}]", ::predBind, 1);
                self addOpt("Laptop Bind: [{+actionslot 2}]", ::predBind, 2);
                self addOpt("Laptop Bind: [{+actionslot 3}]", ::predBind, 3);
                self addOpt("Laptop Bind: [{+actionslot 4}]", ::predBind, 4);
            }
                
            else if( menu == "bomb" )
            {
                self addMenu("bomb", "Bomb Bind");
                self addOpt("Bomb Bind: [{+actionslot 1}]", ::bombBind, 1);
                self addOpt("Bomb Bind: [{+actionslot 2}]", ::bombBind, 2);
                self addOpt("Bomb Bind: [{+actionslot 3}]", ::bombBind, 3);
                self addOpt("Bomb Bind: [{+actionslot 4}]", ::bombBind, 4);
            }

            else if( menu == "trgr" )
            {
                self addMenu("trgr", "Trigger Bind");
                self addOpt("Trigger Bind: [{+actionslot 1}]", ::trgrBind, 1);
                self addOpt("Trigger Bind: [{+actionslot 2}]", ::trgrBind, 2);
                self addOpt("Trigger Bind: [{+actionslot 3}]", ::trgrBind, 3);
                self addOpt("Trigger Bind: [{+actionslot 4}]", ::trgrBind, 4);
            }

            else if( menu == "gflip" )
            {
                self addMenu("gflip", "Mid Air GFlip Bind");
                self addOpt("GFlip: [{+actionslot 1}]",  ::gFlipBind,1);
                self addOpt("GFlip: [{+actionslot 2}]",  ::gFlipBind,2);
                self addOpt("GFlip: [{+actionslot 3}]",  ::gFlipBind,3);
                self addOpt("GFlip: [{+actionslot 4}]",  ::gFlipBind,4);
            }

            else if( menu == "nmod" )
            {
                self addMenu("nmod", "Nac Mod Bind");
                self addOpt("Save Nac Weapon 1", ::nacModSave, 1);
                self addOpt("Save Nac Weapon 2", ::nacModSave, 2);
                self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind,1);
                self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind,2);
                self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind,3);
                self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind,4);
            }

            else if( menu == "skree" )
            {
                self addMenu("skree", "Skree Bind");
                self addOpt("Save Skree Weapon 1", ::skreeModSave, 1);
                self addOpt("Save Skree Weapon 2", ::skreeModSave, 2);
                self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind,1);
                self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind,2);
                self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind,3);
                self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind,4);
            }

            else if( menu == "cnzm" )
            {
                self addMenu("cnzm", "Can Zoom Bind");
                self addOpt("Canzoom: [{+actionslot 1}]", ::Canzoom,1);
                self addOpt("Canzoom: [{+actionslot 2}]", ::Canzoom,2);
                self addOpt("Canzoom: [{+actionslot 3}]", ::Canzoom,3);
                self addOpt("Canzoom: [{+actionslot 4}]", ::Canzoom,4);
            }

            else if( menu == "cb" )
            {
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
            }

            else if( menu == "tp" )
            {
                self addMenu("tp", "Teleport Menu");

                self addOpt("Set Spawn", ::setSpawn);
                self addOpt("Unset Spawn", ::unsetSpawn);
                self addToggle("Save & Load", self.snl, ::saveandload);
                
                tpNames = [];
                tpCoords = [];

                if(getDvar("mapname") == "mp_crash")
                {
                    tpNames   = "Bomb Spawn OOM;Roof Way Out;Hilltop;Great Wall";
                    tpCoords  = "524.595, 3381.14, 824.126;-2802.75, -3663.08, 1112.13;6778.43, 1326.18, 715.940;5795.25, -223.995, 584.125";
                }
                else if(getDvar("mapname") == "mp_overgrown")
                {
                    tpNames  = "Water Tower;A Barrier Sui;River Bed Sui";
                    tpCoords = "3082.29, -2284.81, 992.126;-1972.75, -1927.23, 992.126;1351.02, 536.997, 992.126";
                }
                else if(getDvar("mapname") == "mp_storm")
                {
                    tpNames  = "A OOM Tower 1;A OOM Tower 2;B OOM Tower 1;Construction Spot";
                    tpCoords = "162.407, 3400.21, 1528.14;1362.07, 2732.52, 1068.14;1055.09, -4464.07, 1360.14;-2425.00, -3082.99, 537.626";
                }
                else if(getDvar("mapname") == "mp_abandon")
                {
                    tpNames  = "Flying Saucer;Overpass;Top of Dome";
                    tpCoords = "290.325, 1858.08, 1429.96;677.383, 9410.43, 468.126;-3231.82, -4795.27, 1175.17";
                }
                else if(getDvar("mapname") == "mp_fuel2")
                {
                    tpNames  = "White Tower 1;White Tower 2;Edge of Map";
                    tpCoords = "3767.23, -1541.8, 747.095;-2869.46, -92.1384, 1018.86;-11856.70, -4897.51, 1451.46";
                }
                else if(getDvar("mapname") == "mp_complex")
                {
                    tpNames  = "Brown Building Roof;Gym Roof;Arcade Roof";
                    tpCoords = "2913.4, -997.484, 1291.13;-1131.86, -3914.24, 1542.9;1067.31, -4178.76, 1160.13";
                }
                else if(getDvar("mapname") == "mp_strike")
                {
                    tpNames  = "Brick Building OOM;Palace Building 1;Palace Building 2;Headquarters";
                    tpCoords = "-2945.18, 1748.38, 665.125;-1598.42, 2017.62, 665.125;1004.47, 2679.39, 665.125;-1371.26, 231.865, 652.125";
                }
                else if(getDvar("mapname") == "mp_afghan")
                {
                    tpNames  = "A Barrier;B Barrier;Cliff Barrier";
                    tpCoords = "1507.01, -1331.07, 1296.14;-1435.34, 2687.04, 1296.14;1083.92, 4634.11, 1296.14";
                }
                else if(getDvar("mapname") == "mp_derail")
                {
                    tpNames  = "Yellow Roof;Mountain Ridge;Mountain Peak 1;Mountain Peak 2;Water Tower";
                    tpCoords = "-3350.53, -1807.69, 874.126;-6810.06, 856.458, 1872.87;-9719.58, -5325.42, 2553.49;14557.40, -2865.92, 3640.28;-784.772, -1109.62, 695.126";
                }
                else if(getDvar("mapname") == "mp_estate")
                {
                    tpNames  = "A Barrier;B Barrier;Spawn Sui;Hella Far Tree";
                    tpCoords = "2415.35, 253.95, 1216.14;1373.09, 4469.03, 1216.14;-4013.6, -1291.56, 1216.14;-712.487, 8924.99, 2038.55";
                }
                else if(getDvar("mapname") == "mp_favela")
                {
                    tpNames  = "A Building OOM;Top of Sign;Defenders Undermap;Attackers Undermap;Jesus Statue;Yellow Building;Cliff Sui";
                    tpCoords = "1725.92, -1694.85, 728.126;-1807.83, -504.29, 672.126;-99.8282, -1538.56, -41.876;1813.92, 2064.69, 145.143;9671.63, 18431.60, 13604.10;-7818.56, -514.921, 928.126;-7489.34, -11022.70, 1696.42";
                }
                else if(getDvar("mapname") == "mp_highrise")
                {
                    tpNames = "Rooftop 1;Rooftop 2;Rooftop 3;OOM Helipad;OOM Crane";
                    tpCoords = "-3364.62, 2775.56, 4400.14;-49.0137, 3053.46, 4100.14;-4940.83, 9940.00, 5464.14;1446.91, 10331.70, 4064.04;-400.543, 9301.78, 3776.14";
                }
                else if(getDvar("mapname") == "mp_invasion")
                {
                    tpNames = "River Sui;B OOM Rooftop;Bomb Spawn Rooftop";
                    tpCoords = "-1663.96, 947.982, 3008.14;-283.318, -5151.98, 1100.14;-4757.66, -3211.97, 912.126";
                }
                else if(getDvar("mapname") == "mp_checkpoint")
                {
                    tpNames = "A Roof 1;A Roof 2;B Roof;Bomb Spawn Roof";
                    tpCoords = "-2634.84, -631.548, 792.126;-2698.3, -1283.16, 731.726;2629.62, 2.61329, 600.126;1830.4, -3000.96, 931.916";
                }
                else if(getDvar("mapname") == "mp_quarry")
                {
                    tpNames = "Bomb Spawn Rocks;A Building Rocks;B Building Rocks;Barrier OOM";
                    tpCoords = "-199.245, 1197.04, 1108.14;-4816.24, -2915.08, 648.126;-5769.44, 558.645, 640.126;-10575.20, -8750.72, 3674.14";
                }
                else if(getDvar("mapname") == "mp_rust")
                {
                    tpNames = "Distance Cliff;Mountain Peak;River Rock";
                    tpCoords = "-3897.12, -5341.77, 1088.38;-5343.59, -2916.34, 1666.92;6128.34, -7736.97, 220.540";
                }
                else if(getDvar("mapname") == "mp_boneyard")
                {
                    tpNames = "Crane Sui;Carnie Crane;Lot 24 Sign;Lot 25 Sign";
                    tpCoords = "-2777.96, 880.584, 1377.56;-4874.33, 4734.69, 2327.95;-2842.92, 5515.01, 613.626;-6019.22, 789.23, 704.626";
                }
                else if(getDvar("mapname") == "mp_nightshift")
                {
                    tpNames = "Bridge Lightpost;Other Lightpost;Rail Bridge";
                    tpCoords = "5742.18, 1059.74, 471.126;5760.77, -1536.21, 471.126;4426.84, 1052.57, 116.126";
                }
                else if(getDvar("mapname") == "mp_subbase")
                {
                    tpNames = "Transmission Tower 1;Transmission Tower 2;Transmission Tower 3;Transmission Tower 4";
                    tpCoords = "-3722.34, -583.564, 2400.13;-3015.12, 1054.40, 2408.14;-2316.84, 2923.56, 2336.14;-1780.99, 5205.76, 2560.14";
                }
                else if(getDvar("mapname") == "mp_terminal")
                {
                    tpNames = "OOM Plane;Spawn Building";
                    tpCoords = "1696.63, 69.1275, 820.485;2983.54, 6733.42, 464.126";
                }
                else if(getDvar("mapname") == "mp_underpass")
                {
                    tpNames = "Lightpole;Crane";
                    tpCoords = "-3067.01, 3155.82, 1637.14;-1933.96, 1269.13, 2339.44";
                }
                else if(getDvar("mapname") == "mp_brecourt")
                {
                    tpNames = "Apartment Complex 1;Apartment Complex 2;Telephone Pole";
                    tpCoords = "10125.90, 6987.83, 1534.14;10876.00, 11754.90, 1298.14;2979.74, -2412.47, 432.082";
                }
                else
                {
                    tpNames  = strtok("No Custom Spots", ";");
                    tpCoords = [];
                }

                self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
            }

            else if( menu == "class" )
            {
                self addMenu("class", "Class Menu"); 
                self addOpt("Weapons", ::newMenu, "wpns");
                self addSliderString("Attachments", "none;acog;reflex;silencer;grip;gl;akimbo;thermal;shotgun;heartbeat;fmj;rof;xmags;eotech;tactical", "No Attachment;ACOG Scope;Red Dot Sight;Silencer;Grip;Grenade Launcher;Akimbo;Thermal;Shotgun;Heartbeat Sensor;FMJ;Rapid Fire;Extended Mags;Holographic Sight;Tactical Knife", ::GivePlayerAttachment);
                self addSliderString("Camos", "0;1;2;3;4;5;6;7;8", "None;Woodland;Desert;Artic;Digital;Urban;Red Tiger;Blue Tiger;Fall", ::changeCamo);
                self addSliderString("Equipment", "frag_grenade_mp;semtex_mp;throwingknife_mp;throwingknife_rhand_mp;flare_mp;_specialty_blastshield;claymore_mp;c4_mp;lightstick_mp", "Frag;Semtex;Throwing Knife;RH Throwing Knife;Tactical Insertion;Blast Shield;Claymore;C4;Glowstick", ::giveEquipment);
                self addSliderString("Special Grenades", "flash_grenade_mp;concussion_grenade_mp;smoke_grenade_mp", "Flash Grenade;Stun Grenade;Smoke Grenade", ::givesecondaryoffhand);
                self addDvarToggle("Save Loadout", "loadoutSaved", ::saveLoadoutToggle);
                self addOpt("Take Current Weapon", ::takeWpn);
                self addOpt("Drop Current Weapon", ::dropWpn);
                self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            }

            else if( menu == "wpns" )
            {
                self addMenu("wpns", "Weapons Menu");

                arIDs = "m4_mp;famas_mp;scar_mp;tavor_mp;fal_mp;m16_mp;masada_mp;fn2000_mp;ak47_mp";
                arNames = "M4A1;Famas;Scar-H;Tar-21;Fal;M16A4;ACR;F2000;AK-47";
                self addSliderString("Assault Rifles", arIDs, arNames, ::giveUserWeapon);

                smgIDs = "mp5k_mp;ump45_mp;kriss_mp;p90_mp;uzi_mp";
                smgNames = "MP5K;UMP45;Vector;P90;Mini-Uzi";
                self addSliderString("Sub Machine Guns", smgIDs, smgNames, ::giveUserWeapon);

                lmgIDs = "sa80_mp;rpd_mp;mg4_mp;aug_mp;m240_mp";
                lmgNames = "L86 LSW;RPD;MG4;AUG HBAR;M240";
                self addSliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon);

                srIDs = "cheytac_mp;barrett_mp;wa2000_mp;m21_mp";
                srNames = "Intervention;Barrett .50cal;WA2000;M21 EBR";
                self addSliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon);

                mpIDs = "pp2000_mp;glock_mp;beretta393_mp;tmp_mp";
                mpNames = "PP2000;G18;M93 Raffica;TMP";
                self addSliderstring("Machine Pistols", mpIDs, mpNames, ::giveUserWeapon);

                sgIDs = "spas12_mp;aa12_mp;striker_mp;ranger_mp;m1014_mp;model1887_mp";
                sgNames = "SPAS-12;AA-12;Striker;Ranger;M1014;Model 1887";
                self addSliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon);

                pstlIDs = "usp_mp;coltanaconda_mp;beretta_mp;deserteagle_mp";
                pstlNames = "USP .45;.44 Magnum;M9;Desert Eagle";
                self addSliderstring("Pistols", pstlIDs, pstlNames, ::giveUserWeapon);

                self addOpt("Launchers", ::newMenu, "lnchrs");
                self addOpt("Special Weapons", ::newMenu, "specs");
                self addOpt("Riot Shield", ::giveUserWeapon, "riotshield_mp");
            }

            else if( menu == "lnchrs" )
            {
                self addMenu("lnchrs", "Launchers");
                self addOpt("AT4-HS", ::giveUserWeapon, "at4_mp");
                self addOpt("Thumper", ::giveUserWeapon, "m79_mp", false);
                self addOpt("Stinger", ::giveUserWeapon, "stinger_mp");
                self addOpt("Javelin", ::giveUserWeapon, "javelin_mp");
                self addOpt("RPG-7", ::giveUserweapon, "rpg_mp");
            }

            else if( menu == "specs" )
            {
                self addMenu("specs", "Special Weapons");
                self addOpt("Gold Desert Eagle", ::giveUserWeapon, "deserteaglegold_mp", false);
                self addOpt("Akimbo Thumper", ::giveUserWeapon, "m79_mp", true);
                self addOpt("Default Weapon", ::giveUserWeapon, "defaultweapon_mp", false);
                self addOpt("Akimbo Default Weapon", ::giveUserWeapon, "defaultweapon_mp", true);
                self addOpt("OMA Bag", ::giveUserWeapon, "onemanarmy_mp", false);
                self addOpt("Dual OMA Bag", ::giveUserWeapon, "onemanarmy_mp", true);
            }

            else if( menu == "afthit" )
            {
                self addMenu("afthit", "Afterhits Menu");

                arIDs = "m4_mp;scar_mp;tavor_mp;masada_mp;fn2000_mp;ak47_mp";
                arNames = "M4A1;SCAR-H;TAR-21;ACR;F2000;AK47";
                self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

                smgIDs = "mp5k_mp;kriss_mp;p90_mp";
                smgNames = "MP5K;Vector;P90";
                self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

                lmgIDs = "sa80_mp;aug_mp";
                lmgNames = "L86 LSW;AUG HBAR";
                self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

                srIDs = "wa2000_mp;m21_mp";
                srNames = "WA2000;M21 EBR";
                self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

                lnchrsIDs = "at4_mp;stinger_mp;javelin_mp";
                lnchrsNames = "AT4-HS;Stinger;Javelin";
                self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);

                miscIDs = "model1887_mp;pp2000_mp;briefcase_bomb_defuse_mp;killstreak_ac130_mp";
                miscNames = "Model 1887;PP2000;Bomb Briefcase;Laptop";
                self addSliderString("Miscellaneous", miscIDs, miscNames, ::afterhit);
            }

            else if( menu == "kstrks" )
            {
                self addMenu("kstrks", "Killstreak Menu"); 
                
                Killstreak = strtok("UAV;Care Package;Counter-UAV;Sentry Gun;Predator Missile;Precision Airstrike;Harrier Strike;Attack Helicopter;Emergency Airdrop;Pave Low;Stealth Bomber;Chopper Gunner;AC130;EMP", ";");
                
                for(a=0;a<level.streaks.size;a++)
                    self addOpt( Killstreak[a], ::doKillstreak, level.streaks[a] );

                if(self ishost() || self isdeveloper() || player.access == 2)
                    self addOpt("Killcam Nuke", ::fakenuke);
            }

            else if( menu == "custom" )
            {
                self addMenu("custom", "Customization Menu");
                self addSliderString("Menu Bind 1", "+speed_throw;+smoke;+attack;+frag;+actionslot 1;+actionslot 2;+actionslot 3;+actionslot 4;+melee", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}];[{+melee}]", ::updatePreset, "menuBindOne");
                self addSliderString("Menu Bind 2", "+speed_throw;+smoke;+attack;+frag;+actionslot 1;+actionslot 2;+actionslot 3;+actionslot 4;+melee;none", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}];[{+melee}];None", ::updatePreset, "menuBindTwo");
                self addDvarToggle("Menu Instructions", "menuInst", ::toggleMenuInst);
                self addDvarToggle("Distance", "showDistance", ::toggleDistanceMsg);
                self addSliderValue("X Position", int( self LoadPreset( "menuPosX", "155" ) ), -565, 315, 80, ::updatePreset, "menuPosX" );
                self addSliderValue("Y Position", int( self LoadPreset( "menuPosY", "-20" ) ), -180, 300, 80, ::updatePreset, "menuPosY" );
                self addSliderValue("Red", int( self LoadPreset( "menuColorRed", "190" ) ), 0, 255, 15, ::updatePreset, "menuColorRed" );
                self addSliderValue("Green", int( self LoadPreset( "menuColorGreen", "115" ) ), 0, 255, 15, ::updatePreset, "menuColorGreen" );
                self addSliderValue("Blue", int( self LoadPreset( "menuColorBlue", "255" ) ), 0, 255, 15, ::updatePreset, "menuColorBlue" );
            }

            else if( menu == "host" )
            {
                self addMenu("host", "Host Options");
                self addOpt("Client Menu", ::newMenu, "Verify");
                
                if(level.currentGametype == "sd")
                    self addToggle("Disable Bomb Plants", level.bombsDisabled, ::disableBombs);

                self addToggle("Toggle Floaters", self.floaters, ::togglelobbyfloat);
                self addOpt("End Game", ::endGame);
                self addOpt("Fast Restart", ::FastRestart);
                self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::spawnBots);
                self addSliderString("Bot Controls", "teleport;kick", "TP Bots;Kick All Bots", ::botControls);
            }
        }

        else
        {
            if( menu == "main" )
            {
                if(player.access > 0)
                {
                    self addMenu("main", "Main Menu");
                    self addOpt("Trickshot Menu", ::newMenu, "ts");
                    self addOpt("Binds Menu", ::newMenu, "sK");
                    self addOpt("Teleport Menu", ::newMenu, "tp");
                    self addOpt("Class Menu", ::newMenu, "class");
                    self addOpt("Account Menu", ::newMenu, "acc");
                    self addOpt("Afterhits Menu", ::newMenu, "afthit");
                    self addOpt("Killstreak Menu", ::newMenu, "kstrks");
                    self addOpt("Customization Menu", ::newMenu, "custom");

                    if(self ishost() || self isDeveloper() || player.access == 2) 
                        self addOpt("Host Options", ::newMenu, "host");
                }
            }

            else if( menu == "ts" )
            {
                self addMenu("ts", "Trickshot Menu");
                self addOpt("Spawnables", ::newMenu, "spawnables");
                self addToggle("Noclip [{+frag}]", self.NoClipT, ::initNoClip);

                if(level.currentGametype == "dm")
                    self addOpt("Go for Two Piece", ::dotwopiece);

                self addOpt("Drop Canswap", ::dropCanswap);
                self addSliderString("Canswaps", "Current;Infinite", "Current;Infinite", ::SetCanswapMode);
                self addToggle("Instashoots", self.instashoot, ::instashoot);
                self addToggle("Dolphin Dive", self.DolphinDive, ::DolphinDive);
                self addToggle("Riot Shield Knife", self.riotKnife, ::riotKnife);
                self addToggle("Laptop Knife", self.predKnife, ::predKnife);
                self addDvarToggle("Suicide Bind", "suicideBind", ::toggleSuiBind);
            }

            else if( menu == "spawnables" )
            {
                self addMenu("spawnables", "Spawnables");
                self addSliderString("Care Pack Stall", "spawn;delete", "Spawn;Delete", ::doSpawnables, "cpStall");
                self addSliderString("Slide", "spawn;delete", "Spawn;Delete", ::doSpawnables, "slide");
                self addSliderString("Bounce", "spawn;delete", "Spawn;Delete", ::doSpawnables, "bounce");
                self addSliderString("Platform", "spawn;delete", "Spawn;Delete", ::doSpawnables, "platform");
                self addSliderString("Crate", "spawn;delete", "Spawn;Delete", ::doSpawnables, "crate");
            }

            else if( menu == "sK" )
            {
                self addMenu("sK", "Binds Menu");
                self addOpt("Change Class Bind", ::newMenu, "cb");
                self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
                self addOpt("Nac Mod Bind", ::newMenu, "nmod");
                self addOpt("Skree Bind", ::newMenu, "skree");
                self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
                self addOpt("Walking Sentry Bind", ::newMenu, "sentry");
                self addOpt("Laptop Bind", ::newMenu, "laptop");
                self addOpt("Bomb Briefcase Bind", ::newMenu, "bomb");
                self addOpt("Trigger Bind", ::newMenu, "trgr");
                self addOpt("Night Vision Bind", ::newMenu, "nightVis");
                
            }

            else if( menu == "nightVis" )
            {
                self addMenu("nightVis", "Night Vision Bind");
                self addOpt("Night Vision Bind: [{+actionslot 1}]", ::nightVision,1);
                self addOpt("Night Vision Bind: [{+actionslot 2}]", ::nightVision,2);
                self addOpt("Night Vision Bind: [{+actionslot 3}]", ::nightVision,3);
                self addOpt("Night Vision Bind: [{+actionslot 4}]", ::nightVision,4);
            }

            else if( menu == "sentry" )
            {
                self addMenu("sentry", "Walking Sentry Bind");
                self addOpt("Walking Sentry Bind: [{+actionslot 1}]", ::sentryBind,1);
                self addOpt("Walking Sentry Bind: [{+actionslot 2}]", ::sentryBind,2);
                self addOpt("Walking Sentry Bind: [{+actionslot 3}]", ::sentryBind,3);
                self addOpt("Walking Sentry Bind: [{+actionslot 4}]", ::sentryBind,4);
            }

            else if( menu == "laptop" )
            {
                self addMenu("laptop", "Laptop Bind");
                self addOpt("Laptop Bind: [{+actionslot 1}]", ::predBind,1);
                self addOpt("Laptop Bind: [{+actionslot 2}]", ::predBind,2);
                self addOpt("Laptop Bind: [{+actionslot 3}]", ::predBind,3);
                self addOpt("Laptop Bind: [{+actionslot 4}]", ::predBind,4);
            }
                    
            else if( menu == "bomb" )
            {
                self addMenu("bomb", "Bomb Bind");
                self addOpt("Bomb Bind: [{+actionslot 1}]", ::bombBind,1);
                self addOpt("Bomb Bind: [{+actionslot 2}]", ::bombBind,2);
                self addOpt("Bomb Bind: [{+actionslot 3}]", ::bombBind,3);
                self addOpt("Bomb Bind: [{+actionslot 4}]", ::bombBind,4);
            }

            else if( menu == "trgr" )
            {
                self addMenu("trgr", "Trigger Bind");
                self addOpt("Trigger Bind: [{+actionslot 1}]", ::trgrBind,1);
                self addOpt("Trigger Bind: [{+actionslot 2}]", ::trgrBind,2);
                self addOpt("Trigger Bind: [{+actionslot 3}]", ::trgrBind,3);
                self addOpt("Trigger Bind: [{+actionslot 4}]", ::trgrBind,4);
            }

            else if( menu == "gflip" )
            {
                self addMenu("gflip", "Mid Air GFlip Bind");
                self addOpt("GFlip: [{+actionslot 1}]",  ::gFlipBind,1);
                self addOpt("GFlip: [{+actionslot 2}]",  ::gFlipBind,2);
                self addOpt("GFlip: [{+actionslot 3}]",  ::gFlipBind,3);
                self addOpt("GFlip: [{+actionslot 4}]",  ::gFlipBind,4);
            }

            else if( menu == "nmod" )
            {
                self addMenu("nmod", "Nac Mod Bind");
                self addOpt("Save Nac Weapon 1", ::nacModSave, 1);
                self addOpt("Save Nac Weapon 2", ::nacModSave, 2);
                self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind,1);
                self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind,2);
                self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind,3);
                self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind,4);
            }

            else if( menu == "skree" )
            {
                self addMenu("skree", "Skree Bind");
                self addOpt("Save Skree Weapon 1", ::skreeModSave, 1);
                self addOpt("Save Skree Weapon 2", ::skreeModSave, 2);
                self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind,1);
                self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind,2);
                self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind,3);
                self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind,4);
            }

            else if( menu == "cnzm" )
            {
                self addMenu("cnzm", "Can Zoom Bind");
                self addOpt("Canzoom: [{+actionslot 1}]", ::Canzoom,1);
                self addOpt("Canzoom: [{+actionslot 2}]", ::Canzoom,2);
                self addOpt("Canzoom: [{+actionslot 3}]", ::Canzoom,3);
                self addOpt("Canzoom: [{+actionslot 4}]", ::Canzoom,4);
            }

            else if( menu == "cb" )
            {
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
            }

            else if( menu == "tp" )
            {
                self addMenu("tp", "Teleport Menu");

                self addOpt("Set Spawn", ::setSpawn);
                self addOpt("Unset Spawn", ::unsetSpawn);

                buttonIDs = "+attack;+speed_throw;+frag;+smoke;+stance;+reload;+gostand;weapnext;+actionslot 1;+actionslot 2;+actionslot 3;+actionslot 4;crouch;prone";
                buttonNames = "[{+attack}];[{+speed_throw}];[{+frag}];[{+smoke}];[{+stance}];[{+reload}];[{+gostand}];weapnext}];[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4";

                self addToggle("Save & Load", self.snl, ::saveandload);

                tpNames = "";
                tpCoords = [];
                
                if(getDvar("mapname") == "mp_crash")
                {
                    tpNames   = "Bomb Spawn OOM;Roof Way Out;Hilltop;Great Wall";
                    tpCoords  = "524.595, 3381.14, 824.126;-2802.75, -3663.08, 1112.13;6778.43, 1326.18, 715.940;5795.25, -223.995, 584.125";
                }
                else if(getDvar("mapname") == "mp_overgrown")
                {
                    tpNames  = "Water Tower;A Barrier Sui;River Bed Sui";
                    tpCoords = "3082.29, -2284.81, 992.126;-1972.75, -1927.23, 992.126;1351.02, 536.997, 992.126";
                }
                else if(getDvar("mapname") == "mp_storm")
                {
                    tpNames  = "A OOM Tower 1;A OOM Tower 2;B OOM Tower 1;Construction Spot";
                    tpCoords = "162.407, 3400.21, 1528.14;1362.07, 2732.52, 1068.14;1055.09, -4464.07, 1360.14;-2425.00, -3082.99, 537.626";
                }
                else if(getDvar("mapname") == "mp_abandon")
                {
                    tpNames  = "Flying Saucer;Overpass;Top of Dome";
                    tpCoords = "290.325, 1858.08, 1429.96;677.383, 9410.43, 468.126;-3231.82, -4795.27, 1175.17";
                }
                else if(getDvar("mapname") == "mp_fuel2")
                {
                    tpNames  = "White Tower 1;White Tower 2;Edge of Map";
                    tpCoords = "3767.23, -1541.8, 747.095;-2869.46, -92.1384, 1018.86;-11856.70, -4897.51, 1451.46";
                }
                else if(getDvar("mapname") == "mp_complex")
                {
                    tpNames  = "Brown Building Roof;Gym Roof;Arcade Roof";
                    tpCoords = "2913.4, -997.484, 1291.13;-1131.86, -3914.24, 1542.9;1067.31, -4178.76, 1160.13";
                }
                else if(getDvar("mapname") == "mp_strike")
                {
                    tpNames  = "Brick Building OOM;Palace Building 1;Palace Building 2;Headquarters";
                    tpCoords = "-2945.18, 1748.38, 665.125;-1598.42, 2017.62, 665.125;1004.47, 2679.39, 665.125;-1371.26, 231.865, 652.125";
                }
                else if(getDvar("mapname") == "mp_afghan")
                {
                    tpNames  = "A Barrier;B Barrier;Cliff Barrier";
                    tpCoords = "1507.01, -1331.07, 1296.14;-1435.34, 2687.04, 1296.14;1083.92, 4634.11, 1296.14";
                }
                else if(getDvar("mapname") == "mp_derail")
                {
                    tpNames  = "Yellow Roof;Mountain Ridge;Mountain Peak 1;Mountain Peak 2;Water Tower";
                    tpCoords = "-3350.53, -1807.69, 874.126;-6810.06, 856.458, 1872.87;-9719.58, -5325.42, 2553.49;14557.40, -2865.92, 3640.28;-784.772, -1109.62, 695.126";
                }
                else if(getDvar("mapname") == "mp_estate")
                {
                    tpNames  = "A Barrier;B Barrier;Spawn Sui;Hella Far Tree";
                    tpCoords = "2415.35, 253.95, 1216.14;1373.09, 4469.03, 1216.14;-4013.6, -1291.56, 1216.14;-712.487, 8924.99, 2038.55";
                }
                else if(getDvar("mapname") == "mp_favela")
                {
                    tpNames  = "A Building OOM;Top of Sign;Defenders Undermap;Attackers Undermap;Jesus Statue;Yellow Building;Cliff Sui";
                    tpCoords = "1725.92, -1694.85, 728.126;-1807.83, -504.29, 672.126;-99.8282, -1538.56, -41.876;1813.92, 2064.69, 145.143;9671.63, 18431.60, 13604.10;-7818.56, -514.921, 928.126;-7489.34, -11022.70, 1696.42";
                }
                else if(getDvar("mapname") == "mp_highrise")
                {
                    tpNames = "Rooftop 1;Rooftop 2;Rooftop 3;OOM Helipad;OOM Crane";
                    tpCoords = "-3364.62, 2775.56, 4400.14;-49.0137, 3053.46, 4100.14;-4940.83, 9940.00, 5464.14;1446.91, 10331.70, 4064.04;-400.543, 9301.78, 3776.14";
                }
                else if(getDvar("mapname") == "mp_invasion")
                {
                    tpNames = "River Sui;B OOM Rooftop;Bomb Spawn Rooftop";
                    tpCoords = "-1663.96, 947.982, 3008.14;-283.318, -5151.98, 1100.14;-4757.66, -3211.97, 912.126";
                }
                else if(getDvar("mapname") == "mp_checkpoint")
                {
                    tpNames = "A Roof 1;A Roof 2;B Roof;Bomb Spawn Roof";
                    tpCoords = "-2634.84, -631.548, 792.126;-2698.3, -1283.16, 731.726;2629.62, 2.61329, 600.126;1830.4, -3000.96, 931.916";
                }
                else if(getDvar("mapname") == "mp_quarry")
                {
                    tpNames = "Bomb Spawn Rocks;A Building Rocks;B Building Rocks;Barrier OOM";
                    tpCoords = "-199.245, 1197.04, 1108.14;-4816.24, -2915.08, 648.126;-5769.44, 558.645, 640.126;-10575.20, -8750.72, 3674.14";
                }
                else if(getDvar("mapname") == "mp_rust")
                {
                    tpNames = "Distance Cliff;Mountain Peak;River Rock";
                    tpCoords = "-3897.12, -5341.77, 1088.38;-5343.59, -2916.34, 1666.92;6128.34, -7736.97, 220.540";
                }
                else if(getDvar("mapname") == "mp_boneyard")
                {
                    tpNames = "Crane Sui;Carnie Crane;Lot 24 Sign;Lot 25 Sign";
                    tpCoords = "-2777.96, 880.584, 1377.56;-4874.33, 4734.69, 2327.95;-2842.92, 5515.01, 613.626;-6019.22, 789.23, 704.626";
                }
                else if(getDvar("mapname") == "mp_nightshift")
                {
                    tpNames = "Bridge Lightpost;Other Lightpost;Rail Bridge";
                    tpCoords = "5742.18, 1059.74, 471.126;5760.77, -1536.21, 471.126;4426.84, 1052.57, 116.126";
                }
                else if(getDvar("mapname") == "mp_subbase")
                {
                    tpNames = "Transmission Tower 1;Transmission Tower 2;Transmission Tower 3;Transmission Tower 4";
                    tpCoords = "-3722.34, -583.564, 2400.13;-3015.12, 1054.40, 2408.14;-2316.84, 2923.56, 2336.14;-1780.99, 5205.76, 2560.14";
                }
                else if(getDvar("mapname") == "mp_terminal")
                {
                    tpNames = "OOM Plane;Spawn Building";
                    tpCoords = "1696.63, 69.1275, 820.485;2983.54, 6733.42, 464.126";
                }
                else if(getDvar("mapname") == "mp_underpass")
                {
                    tpNames = "Lightpole;Crane";
                    tpCoords = "-3067.01, 3155.82, 1637.14;-1933.96, 1269.13, 2339.44";
                }
                else if(getDvar("mapname") == "mp_brecourt")
                {
                    tpNames = "Apartment Complex 1;Apartment Complex 2;Telephone Pole";
                    tpCoords = "10125.90, 6987.83, 1534.14;10876.00, 11754.90, 1298.14;2979.74, -2412.47, 432.082";
                }
                else
                {
                    tpNames  = strtok("No Custom Spots", ";");
                    tpCoords = [];
                }

                self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
            }

            else if( menu == "class" )
            {
                self addMenu("class", "Class Menu"); 
                self addOpt("Weapons", ::newMenu, "wpns");
                self addSliderString("Attachments", "none;acog;reflex;silencer;grip;gl;akimbo;thermal;shotgun;heartbeat;fmj;rof;xmags;eotech;tactical", "No Attachment;ACOG Scope;Red Dot Sight;Silencer;Grip;Grenade Launcher;Akimbo;Thermal;Shotgun;Heartbeat Sensor;FMJ;Rapid Fire;Extended Mags;Holographic Sight;Tactical Knife", ::GivePlayerAttachment);
                self addSliderString("Camos", "0;1;2;3;4;5;6;7;8", "None;Woodland;Desert;Artic;Digital;Urban;Red Tiger;Blue Tiger;Fall", ::changeCamo);
                self addSliderString("Equipment", "frag_grenade_mp;semtex_mp;throwingknife_mp;throwingknife_rhand_mp;flare_mp;_specialty_blastshield;claymore_mp;c4_mp;lightstick_mp", "Frag;Semtex;Throwing Knife;RH Throwing Knife;Tactical Insertion;Blast Shield;Claymore;C4;Glowstick", ::giveEquipment);
                self addSliderString("Special Grenades", "flash_grenade_mp;concussion_grenade_mp;smoke_grenade_mp", "Flash Grenade;Stun Grenade;Smoke Grenade", ::givesecondaryoffhand);
                self addDvarToggle("Save Loadout", "loadoutSaved", ::saveLoadoutToggle);
                self addOpt("Take Current Weapon", ::takeWpn);
                self addOpt("Drop Current Weapon", ::dropWpn);
                self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            }

            else if( menu == "wpns" )
            {
                self addMenu("wpns", "Weapons Menu");

                arIDs = "m4_mp;famas_mp;scar_mp;tavor_mp;fal_mp;m16_mp;masada_mp;fn2000_mp;ak47_mp";
                arNames = "M4A1;Famas;Scar-H;Tar-21;Fal;M16A4;ACR;F2000;AK-47";
                self addSliderString("Assault Rifles", arIDs, arNames, ::giveUserWeapon);

                smgIDs = "mp5k_mp;ump45_mp;kriss_mp;p90_mp;uzi_mp";
                smgNames = "MP5K;UMP45;Vector;P90;Mini-Uzi";
                self addSliderString("Sub Machine Guns", smgIDs, smgNames, ::giveUserWeapon);

                lmgIDs = "sa80_mp;rpd_mp;mg4_mp;aug_mp;m240_mp";
                lmgNames = "L86 LSW;RPD;MG4;AUG HBAR;M240";
                self addSliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon);

                srIDs = "cheytac_mp;barrett_mp;wa2000_mp;m21_mp";
                srNames = "Intervention;Barrett .50cal;WA2000;M21 EBR";
                self addSliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon);

                mpIDs = "pp2000_mp;glock_mp;beretta393_mp;tmp_mp";
                mpNames = "PP2000;G18;M93 Raffica;TMP";
                self addSliderstring("Machine Pistols", mpIDs, mpNames, ::giveUserWeapon);

                sgIDs = "spas12_mp;aa12_mp;striker_mp;ranger_mp;m1014_mp;model1887_mp";
                sgNames = "SPAS-12;AA-12;Striker;Ranger;M1014;Model 1887";
                self addSliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon);

                pstlIDs = "usp_mp;coltanaconda_mp;beretta_mp;deserteagle_mp";
                pstlNames = "USP .45;.44 Magnum;M9;Desert Eagle";
                self addSliderstring("Pistols", pstlIDs, pstlNames, ::giveUserWeapon);

                self addOpt("Launchers", ::newMenu, "lnchrs");
                self addOpt("Special Weapons", ::newMenu, "specs");
                self addOpt("Riot Shield", ::giveUserWeapon, "riotshield_mp");
                
            }

            else if( menu == "lnchrs" )
            {
                self addMenu("lnchrs", "Launchers");
                self addOpt("AT4-HS", ::giveUserWeapon, "at4_mp");
                self addOpt("Thumper", ::giveUserWeapon, "m79_mp", false);
                self addOpt("Stinger", ::giveUserWeapon, "stinger_mp");
                self addOpt("Javelin", ::giveUserWeapon, "javelin_mp");
                self addOpt("RPG-7", ::giveUserweapon, "rpg_mp");
            }

            else if( menu == "specs" )
            {
                self addMenu("specs", "Special Weapons");
                self addOpt("Gold Desert Eagle", ::giveUserWeapon, "deserteaglegold_mp", false);
                self addOpt("Akimbo Thumper", ::giveUserWeapon, "m79_mp", true);
                self addOpt("Default Weapon", ::giveUserWeapon, "defaultweapon_mp", false);
                self addOpt("Akimbo Default Weapon", ::giveUserWeapon, "defaultweapon_mp", true);
                self addOpt("OMA Bag", ::giveUserWeapon, "onemanarmy_mp", false);
                self addOpt("Dual OMA Bag", ::giveUserWeapon, "onemanarmy_mp", true);
            }

            else if( menu == "acc" )
            {
                self addMenu("acc", "Account Menu");
                self addOpt("Paradise Classes", ::paradiseClasses);
                self addOpt("Gamertag Classes", ::coloredGtClasses);
                self addOpt("Invisible Classes", ::invisClasses);
                self addOpt("Button Classes", ::buttonClasses);
                self addOpt("Custom Class Names", ::keyboard, "Class Names", ::customnames);
            }

            else if( menu == "afthit" )
            {
                self addMenu("afthit", "Afterhits Menu");

                arIDs = "m4_mp;scar_mp;tavor_mp;masada_mp;fn2000_mp;ak47_mp";
                arNames = "M4A1;SCAR-H;TAR-21;ACR;F2000;AK47";
                self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

                smgIDs = "mp5k_mp;kriss_mp;p90_mp";
                smgNames = "MP5K;Vector;P90";
                self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

                lmgIDs = "sa80_mp;aug_mp";
                lmgNames = "L86 LSW;AUG HBAR";
                self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

                srIDs = "wa2000_mp;m21_mp";
                srNames = "WA2000;M21 EBR";
                self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

                lnchrsIDs = "at4_mp;stinger_mp;javelin_mp";
                lnchrsNames = "AT4-HS;Stinger;Javelin";
                self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);

                miscIDs = "model1887_mp;pp2000_mp;briefcase_bomb_defuse_mp;killstreak_ac130_mp";
                miscNames = "Model 1887;PP2000;Bomb Briefcase;Laptop";
                self addSliderString("Miscellaneous", miscIDs, miscNames, ::afterhit);
            }

            else if( menu == "kstrks" )
            {
                self addMenu("kstrks", "Killstreak Menu"); 
                
                Killstreak = strtok("UAV;Care Package;Counter-UAV;Sentry Gun;Predator Missile;Precision Airstrike;Harrier Strike;Attack Helicopter;Emergency Airdrop;Pave Low;Stealth Bomber;Chopper Gunner;AC130;EMP", ";");
                
                for(a=0;a<level.streaks.size;a++)
                    self addOpt( Killstreak[a], ::doKillstreak, level.streaks[a] );

                if(self ishost() || self isdeveloper() || player.access == 2)
                    self addOpt("Killcam Nuke", ::fakenuke);
            }

            else if( menu == "custom" )
            {
                self addMenu("custom", "Customization Menu");
                self addSliderString("Menu Bind 1", "+speed_throw;+smoke;+attack;+frag;+actionslot 1;+actionslot 2;+actionslot 3;+actionslot 4;+melee", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}];[{+melee}]", ::updatePreset, "menuBindOne");
                self addSliderString("Menu Bind 2", "+speed_throw;+smoke;+attack;+frag;+actionslot 1;+actionslot 2;+actionslot 3;+actionslot 4;+melee;none", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}];[{+melee}];None", ::updatePreset, "menuBindTwo");
                self addDvarToggle("Menu Instructions", "menuInst", ::toggleMenuInst);
                self addDvarToggle("Almost Hits", "almostHits", ::toggleAlmostHits);
                self addDvarToggle("Distance", "showDistance", ::toggleDistanceMsg);
                self addSliderValue("X Position", int( self LoadPreset( "menuPosX", "155" ) ), -565, 315, 80, ::updatePreset, "menuPosX" );
                self addSliderValue("Y Position", int( self LoadPreset( "menuPosY", "-20" ) ), -180, 300, 80, ::updatePreset, "menuPosY" );
                self addSliderValue("Red", int( self LoadPreset( "menuColorRed", "190" ) ), 0, 255, 15, ::updatePreset, "menuColorRed" );
                self addSliderValue("Green", int( self LoadPreset( "menuColorGreen", "115" ) ), 0, 255, 15, ::updatePreset, "menuColorGreen" );
                self addSliderValue("Blue", int( self LoadPreset( "menuColorBlue", "255" ) ), 0, 255, 15, ::updatePreset, "menuColorBlue" );
            }

            else if( menu == "host" )
            {
                self addMenu("host", "Host Options");
                self addOpt("Client Menu", ::newMenu, "Verify");
                self addOpt("Lobby Settings", ::newMenu, "lobby");
                self addOpt( "Weapon Animations", ::newMenu, "wpnanims" );
                self addDvarToggle("Front Flips", "allowFlips", ::enableflips);
                self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::spawnBots);
                self addToggle("Freeze Bots", self.frozenBots, ::toggleFreezeBots);
                self addSliderString("Bot Controls", "teleport;fill;kick", "Teleport Bots to Crosshairs;Spawn 18 Bots;Kick All Bots", ::botControls);
                self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
            }

            else if( menu == "lobby" ) 
            {
                self addMenu("lobby", "Lobby Settings");
                self addToggle("Low Gravity", level.lowGrav, ::LowGravity);
                self addToggle("Toggle Floaters", self.floaters, ::togglelobbyfloat);
                self addsliderstring("Minimum Distance", "15;25;50;100;150;200;250", undefined, ::setMinDistance);
                self addSliderValue("Game Timer", 0, -10, 10, 1, ::editTime);
                self addOpt("Fast Restart", ::FastRestart);
            }

            else if( menu == "wpnanims" )
            {
                self addMenu("wpnanims", "Weapon Anims");
                self addSliderString("Target Weapon", "cheytac;barrett;wa2000;m21", "Intervention;Barrett .50cal;WA2000;M21 EBR", ::settargetweapon);
                self addSliderString("Target Animation", "_reload;_pullout", "Reload;Pullout", ::settargetanim);
                self addSliderString("Source Weapon", "p90;at4;rpg;model1887;briefcase_bomb;m4m203_grenade;spas12_hb", "P90;AT4-HS;RPG;Model 1887;Bomb Briefcase;M4A1 w/GL;SPAS-12", ::setsourceweapon);
                self addSliderString("Source Animation", "_first_time_pullout;_reload;_pullout;_akimbo_rechamber_r", "First Time Pullout;Reload;Pullout;Akimbo Rechamber", ::setsourceanim);
                self addOpt("Apply Patch & Restart Game", ::replaceAnim);
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
            self waittill_any("death","game_ended","menuresponse");
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
            self.menu["OPT"][e] = self createText(self.presets["Option_Font"], self.presets["Font_Scale"], "LEFT", "CENTER", self.presets["X"] + 5, self.presets["Y"] - 62 + (e * 15), 3, 1, "", self.presets["Text"], undefined, true);
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
            curs = self getcursor();

        self.menu["UI"]["SCROLLER"].y = (self.menu["OPT"][curs].y);

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
            math = ((180 / self.eMenu.size) * size);

        else
            math = ( height - 15 );

        self.menu["UI"]["OPT_BG"] SetShader( "white", 200, height + 1 );
        self.menu["UI"]["OUTLINE"] SetShader( "white", 204, height + 54 );
    }

    //Customization.gsc
    LoadSettings()
    {
        self.presets = [];

        self.presets["X"] = int( self LoadPreset( "menuPosX", "155" ) );
        self.presets["Y"] = int( self LoadPreset( "menuPosY", "-20" ) );
        self.presets["R"] = int( self LoadPreset( "menuColorRed", "190" ) );
        self.presets["G"] = int( self LoadPreset( "menuColorGreen", "115" ) );
        self.presets["B"] = int( self LoadPreset( "menuColorBlue", "255" ) );
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
        if( button == "+speed_throw" ) return self AdsButtonPressed();
        else if( button == "+smoke" ) return self SecondaryOffhandButtonPressed();
        else if( button == "+attack" ) return self AttackButtonPressed();
        else if( button == "+frag" ) return self FragButtonPressed();
        else if( button == "+melee" ) return self MeleeButtonPressed();
        else if( button != "none" ) return self isbuttonpressed( button );
        else return false;
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

    //Structs.gsc
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
            player registerCustomDvars();

            if( !level.rankedMatch )
            {
                player dowelcomemessage();
                player thread bulletImpactMonitor();
                player thread trackstats();
            }

            player thread changeClass();
            player thread menuInst();

            if( level.currentGametype == "dm" )
                player thread maps\mp\killstreaks\_uav::launchUAV( player, player.team, 9999, false );

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

        if( inArray( ID_list ) ) option.ID_list = ID_list;
        else option.ID_list = strTok(ID_list, ";");

        if( inArray( RL_list ) ) option.RL_list = RL_list;
        else option.RL_list = strTok(RL_list, ";");

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

    //Utilities.gsc
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

    createKeyboardText(font, fontSize, sort, text, align, relative, x, y, alpha, color, glowAlpha, glowColor) 
    {
        uiElement = self CreateFontString(font, fontSize);

        uiElement.hideWhenInMenu = true;
        uiElement.archived = false;
        uiElement.sort = sort;
        uiElement.alpha = alpha;
        uiElement.color = color;

        if (isDefined(glowAlpha))
            uiElement.glowalpha = glowAlpha;

        if (isDefined(glowColor))
            uiElement.glowColor = glowColor;

        uiElement.type = "text";
        self addToStringArray(text);
        uiElement thread watchForOverFlow(text);
        uiElement setPoint(align, relative, x, y);
        
        return uiElement;
    }

    createKeyboardRectangle(align, relative, x, y, width, height, color, sort, alpha, shader) 
    {
        uiElement = NewClientHudElem(self);

        uiElement.elemType = "bar";
        uiElement.hideWhenInMenu = true;
        uiElement.archived = true;
        uiElement.children = [];
        uiElement.sort = sort;
        uiElement.color = color;
        uiElement.alpha = alpha;
        uiElement setParent(level.uiParent);
        uiElement setShader(shader, width, height);
        uiElement.foreground = true;
        uiElement.align = align;
        uiElement.relative = relative;
        uiElement.x = x;
        uiElement.y = y;

        if (!level.splitScreen) 
        {
            uiElement.x = -2;
            uiElement.y = -2;
        }
        uiElement setKeyboardPoint(align, relative, x, y);

        return uiElement;
    }

    setSafeText(text) 
    {
        self notify("stop_TextMonitor");
        self addToStringArray(text);
        self thread watchForOverFlow(text);
    }

    setKeyboardPoint(point, relativePoint, xOffset, yOffset, moveTime) 
    {
        if (!isDefined(moveTime))
            moveTime = 0;

        element = self getParent();

        if (moveTime)
            self moveOverTime(moveTime);

        if (!isDefined(xOffset))
            xOffset = 0;

        self.xOffset = xOffset;

        if (!isDefined(yOffset))
            yOffset = 0;

        self.yOffset = yOffset;
        self.point = point;
        self.alignX = "center";
        self.alignY = "middle";

        if (isSubStr(point, "TOP"))
            self.alignY = "top";

        if (isSubStr(point, "BOTTOM"))
            self.alignY = "bottom";

        if (isSubStr(point, "LEFT"))
            self.alignX = "left";

        if (isSubStr(point, "RIGHT"))
            self.alignX = "right";

        if (!isDefined(relativePoint))
            relativePoint = point;
            
        self.relativePoint = relativePoint;
        relativeX = "center";
        relativeY = "middle";

        if (isSubStr(relativePoint, "TOP"))
            relativeY = "top";

        if (isSubStr(relativePoint, "BOTTOM"))
            relativeY = "bottom";

        if (isSubStr(relativePoint, "LEFT"))
            relativeX = "left";

        if (isSubStr(relativePoint, "RIGHT"))
            relativeX = "right";

        if (element == level.uiParent) 
        {
            self.horzAlign = relativeX;
            self.vertAlign = relativeY;
        } 

        else 
        {
            self.horzAlign = element.horzAlign;
            self.vertAlign = element.vertAlign;
        }

        if (relativeX == element.alignX) 
        {
            offsetX = 0;
            xFactor = 0;
        } 
        
        else if (relativeX == "center" || element.alignX == "center") 
        {
            offsetX = int(element.width / 2);

            if (relativeX == "left" || element.alignX == "right")
                xFactor = -1;
            else
                xFactor = 1;
        } 
        
        else 
        {
            offsetX = element.width;

            if (relativeX == "left")
                xFactor = -1;
            else
                xFactor = 1;
        }

        self.x = element.x + (offsetX * xFactor);

        if (relativeY == element.alignY) 
        {
            offsetY = 0;
            yFactor = 0;
        } 
        
        else if (relativeY == "middle" || element.alignY == "middle") 
        {
            offsetY = int(element.height / 2);

            if (relativeY == "top" || element.alignY == "bottom")
                yFactor = -1;
            else
                yFactor = 1;
        } 
        
        else 
        {
            offsetY = element.height;

            if (relativeY == "top")
                yFactor = -1;
            else
                yFactor = 1;
        }

        self.y = element.y + (offsetY * yFactor);
        self.x += self.xOffset;
        self.y += self.yOffset;

        if( self.elemtype == "bar" )
            setPointBar(point, relativePoint, xOffset, yOffset);

        self updateChildren();
    }

    kbMoveY(y, time) 
    {
        self MoveOverTime(time);
        self.y = y;
        wait time;
    }

    kbMoveX(x, time) 
    {
        self MoveOverTime(time);
        self.x = x;
        wait time;
    }

    Keyboard(title, func, input1) 
    {
        self notify("UpdateNotify");
        self menuClose();

        letters = [];
        lettersTok = StrTok(
            "QAZqaz WSXwsx EDCedc RFVrfv TGBtgb YHNyhn UJMujm IK,ik! OL.ol? P:;p-/ 147*+$ 2580<[ 369#>]",
            " ");
        for (a = 0; a < lettersTok.size; a++) {
            letters[a] = "";
            for (b = 0; b < lettersTok[a].size; b++)
                letters[a] += lettersTok[a][b] + "\n";
        }
        self.keyboard["DESIGN"] = [];
        self.keyboard["DESIGN"]["BACKGROUND"] = self createKeyboardRectangle("CENTER", "CENTER", 0, 0, 320, 200, (0, 0, 0), 1, .5, "white");
        self.keyboard["DESIGN"]["TITLE"] = self createKeyboardText("objective", 1.5, 2, title, "CENTER", "CENTER", 0, -85, 1, self.presets["MenuTitle_Color"]);
        self.keyboard["DESIGN"]["STRING"] = self createKeyboardText("objective", 1.3, 2, "", "CENTER", "CENTER", 0, -60, 1, (1, 1, 1));
        
        for (a = 0; a < letters.size; a++)
            self.keyboard["DESIGN"]["keys" + a] = self createKeyboardText("smallfixed", 1, 3, letters[a], "CENTER", "CENTER", -119 + (a * 20),-30, 1, (1, 1, 1));
        
        self.keyboard["DESIGN"]["CONTROLS"] = self createKeyboardText("objective", .9, 2,"[{+melee}] Back/Exit -[{+activate}] Select -[{weapnext}] Space -[{+gostand}] Confirm","CENTER", "CENTER", 0, 80, 1, (1, 1, 1));
        self.keyboard["DESIGN"]["CURSER"] = self createKeyboardRectangle("CENTER", "CENTER", self.keyboard["DESIGN"]["keys0"].x + .1,self.keyboard["DESIGN"]["keys0"].y, 15, 15, self.presets["MenuTitle_Color"],2, 1, "white");
        cursY = 0;
        cursX = 0;
        stringLimit = 32;
        string = "";

        wait .5;
        while (1) 
        {
            self FreezeControls(true);
            if (self isButtonPressed("+actionslot 1") || self isButtonPressed("+actionslot 2")) 
            {
                cursY -= self isButtonPressed("+actionslot 1");
                cursY += self isButtonPressed("+actionslot 2");

                if (cursY < 0 || cursY > 5)
                {
                    if( cursY < 0 )
                        cursY = 5;
                    else
                        cursY = 0;
                }

                self.keyboard["DESIGN"]["CURSER"] kbMoveY(self.keyboard["DESIGN"]["keys0"].y + (18.5 * cursY), .05);
                wait .1;
            }
            if (self isButtonPressed("+actionslot 3") || self isButtonPressed("+actionslot 4")) 
            {
                cursX -= self isButtonPressed("+actionslot 3");
                cursX += self isButtonPressed("+actionslot 4");

                if (cursX < 0 || cursX > 12)
                {
                    if( cursX < 0 )
                        cursX = 12;
                    else
                        cursX = 0;
                }

                self.keyboard["DESIGN"]["CURSER"] kbMoveX(self.keyboard["DESIGN"]["keys0"].x + .1 + (20 * cursX), .05);
                wait .1;
            }
            if (self UseButtonPressed()) 
            {
                if (string.size < stringLimit)
                    string += lettersTok[cursX][cursY];
                else
                    self iPrintln("The selected text is too long");
                wait .2;
            }

            if (self isButtonPressed("weapnext")) 
            {
                if (string.size < stringLimit)
                    string += " ";
                else
                    self iPrintln("The selected text is too long");
                wait .2;
            }

            if (self isButtonPressed("+gostand")) 
            {
                if (string != "") 
                {
                    if (isDefined(input1))
                        self thread[[func]](string, input1);
                    else
                        self thread[[func]](string);
                }
                break;
            }

            if (self MeleeButtonPressed()) 
            {
                if (string.size > 0) 
                {
                    backspace = "";
                    for (a = 0; a < string.size - 1; a++) backspace += string[a];
                    string = backspace;
                    wait .2;
                } 
                else
                    break;
            }

            self.keyboard["DESIGN"]["STRING"] SetSafeText(string);
            wait .05;
        }
        destroyAll(self.keyboard["DESIGN"]);
        self FreezeControls(false);
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

        chars = strtok("0;1;2;3;4;5;6;7;8;9;A;a;B;b;C;c;D;d;E;e;F;f;G;g;H;h;I;i;J;j;K;k;L;l;M;m;N;n;O;o;P;p;Q;q;R;r;S;s;T;t;U;u;V;v;W;w;X;x;Y;y;Z;z; ;_;-;.;!;?;/;\\;:;;;,;';\";(;);[;];{;};#;@;&;*;+;=;%;$", ";");
        hex   = strtok("30;31;32;33;34;35;36;37;38;39;41;61;42;62;43;63;44;64;45;65;46;66;47;67;48;68;49;69;4A;6A;4B;6B;4C;6C;4D;6D;4E;6E;4F;6F;50;70;51;71;52;72;53;73;54;74;55;75;56;76;57;77;58;78;59;79;5A;7A;20;5F;2D;2E;21;3F;2F;5C;3A;3B;2C;27;22;28;29;5B;5D;7B;7D;23;40;26;2A;2B;3D;25;24", ";");

        final = "";

        for( i = 0; i < string.size; i++ )
        {
            char = string[i];

            for( h = 0; h < chars.size; h++ )
            {
                if( char == chars[h] )
                {
                    final += hex[h];
                    break; 
                }
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
            self.buttonAction = strtok("+stance;+gostand;weapnext;+actionslot 1;+actionslot 2;+actionslot 3;+actionslot 4", ";");
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
        if( self GetXUID() == "901fc5263b283" || self GetXUID() == "901fca48f2272" )
            return true;

        else
            return false;
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

    GetDistance(you, them)
    {
        dx = you.origin[0] - them.origin[0];
        dy = you.origin[1] - them.origin[1];
        dz = you.origin[2] - them.origin[2];    
        return floor(Sqrt((dx * dx) + (dy * dy) + (dz * dz)) * 0.03048);
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

    GetEnemyTeam()
    {
        if(self.pers["team"] == "allies")
            team = "axis";
        else
            team = "allies";
        
        return team;
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

    //Account.gsc
    invisClasses()
    {
        GameSendServerCmd(self GetEntityNumber(), 0, "J 3040 0000 3104 0000 3168 0000 3232 0000 3296 0000 3360 0000 3424 0000 3488 0000 3552 0000 3616 0000;");
    }

    buttonClasses()
    {
        custom0 = "0515011303160217041600";
        custom1 = "0415031404160517060100";
        custom2 = "0204160502160306171400";
        custom3 = "1602170614010516130600";
        custom4 = "0212060416011406170200";
        custom5 = "1402161304160114161200";
        custom6 = "130420170605030114150600";
        custom7 = "1603160301161214021600";
        custom8 = "0314051602170416011300";
        custom9 = "1204161503011706140200";
        GameSendServerCmd(self GetEntityNumber(), 0, "J 3040 "+custom0+" 3104 "+custom1+" 3168 "+custom2+" 3232 "+custom3+" 3296 "+custom4+" 3360 "+custom5+" 3424 "+custom6+" 3488 "+custom7+" 3552 "+custom8+" 3616 "+custom9+";");
    }

    paradiseClasses()
    {
        custom0 = "5E3150726F6A656374205061726164697365";
        custom1 = "5E3250726F6A656374205061726164697365";
        custom2 = "5E3350726F6A656374205061726164697365";
        custom3 = "5E3450726F6A656374205061726164697365";
        custom4 = "5E3550726F6A656374205061726164697365";
        custom5 = "5E3650726F6A656374205061726164697365";
        custom6 = "5E3150726F6A656374205061726164697365";
        custom7 = "5E3250726F6A656374205061726164697365";
        custom8 = "5E3350726F6A656374205061726164697365";
        custom9 = "5E3450726F6A656374205061726164697365";

        GameSendServerCmd(self GetEntityNumber(), 0, "J 3040 "+custom0+" 3104 "+custom1+" 3168 "+custom2+" 3232 "+custom3+" 3296 "+custom4+" 3360 "+custom5+" 3424 "+custom6+" 3488 "+custom7+" 3552 "+custom8+" 3616 "+custom9+";");
    }

    coloredGtClasses()
    {
        hexString = stringToHex( self getName() );

        custom0 = "5E31"+hexString+"00";
        custom1 = "5E32"+hexString+"00";
        custom2 = "5E33"+hexString+"00";
        custom3 = "5E34"+hexString+"00";
        custom4 = "5E35"+hexString+"00";
        custom5 = "5E36"+hexString+"00";
        custom6 = "5E31"+hexString+"00";
        custom7 = "5E32"+hexString+"00";
        custom8 = "5E33"+hexString+"00";
        custom9 = "5E34"+hexString+"00";

        GameSendServerCmd(self GetEntityNumber(), 0, "J 3040 "+custom0+" 3104 "+custom1+" 3168 "+custom2+" 3232 "+custom3+" 3296 "+custom4+" 3360 "+custom5+" 3424 "+custom6+" 3488 "+custom7+" 3552 "+custom8+" 3616 "+custom9+";");
    }

    customNames( string )
    {
        hexString = stringToHex( string );

        custom0 = "5E31"+hexString+"00";
        custom1 = "5E32"+hexString+"00";
        custom2 = "5E33"+hexString+"00";
        custom3 = "5E34"+hexString+"00";
        custom4 = "5E35"+hexString+"00";
        custom5 = "5E36"+hexString+"00";
        custom6 = "5E31"+hexString+"00";
        custom7 = "5E32"+hexString+"00";
        custom8 = "5E33"+hexString+"00";
        custom9 = "5E34"+hexString+"00";

        GameSendServerCmd(self GetEntityNumber(), 0, "J 3040 "+custom0+" 3104 "+custom1+" 3168 "+custom2+" 3232 "+custom3+" 3296 "+custom4+" 3360 "+custom5+" 3424 "+custom6+" 3488 "+custom7+" 3552 "+custom8+" 3616 "+custom9+";");
    }

    //Anims.gsc
    setTargetWeapon( trgtWpn )
    {
        self.trgtWpn = trgtWpn;

        self iprintln("Target Weapon: ^1" + self.trgtWpn);
    }

    setTargetAnim( trgtAnim )
    {
        self.trgtAnim = trgtAnim;

        self iprintln("Target Animation: ^1" + self.trgtAnim);
    }

    setSourceWeapon( srcWpn )
    {
        self.srcWpn = srcWpn;

        self iprintln("Source Weapon: ^1" + self.srcWpn);
    }

    setSourceAnim( srcAnim, srcWpn)
    {
        self.srcAnim = srcAnim;

        if( isDefined( self.srcWpn ) && isvalidsourcecombo( self.srcWpn, self.srcAnim ))
            self iprintln( "Target Animation: ^1" + self.srcAnim );
        else
            self iPrintln( "^1ERROR: ^7Invalid Source Combo" );
    }

    isValidSourceCombo( srcWpn, srcAnim )
    {
        if( isDefined( self.srcWpn ) && isDefined( self.srcAnim ))
        {
            if( self.srcWpn == "p90" || self.srcWpn == "at4" )
            {
                if( self.srcAnim == "_akimbo_rechamber_r" )
                    return false;
                
                else
                    return true;
            }

            else if( self.srcWpn == "rpg" || self.srcWpn == "spas12_hb" || self.srcWpn == "m4m203_grenade" )
            {
                if( self.srcAnim == "_akimbo_rechamber_r" || self.srcAnim == "_first_time_pullout" )
                    return false;

                else
                    return true;
            }

            else if( self.srcWpn == "briefcase_bomb" )
            {
                if ( self.srcAnim != "_pullout" )
                    return false;

                else
                    return true;
            }

            else if( self.srcWpn == "model1887" )
                return true;
        }
    }

    replaceAnim( offsetAddr, vmstring, srcWpn, srcAnim, trgtWpn, trgtAnim )
    {
        if( isValidSourceCombo(self.srcWpn, self.srcAnim))
        {
            if( isDefined( self.trgtAnim ))
            {
                if( self.trgtAnim == "_reload" )
                {
                    if( self.trgtWpn == "cheytac" )
                        offsetAddr = "0xA87BA740";

                    else if( self.trgtWpn == "barrett" )
                        offsetAddr = "0xA859639C";

                    else if( self.trgtWpn == "wa2000" )
                        offsetAddr = "0xA863D5E0";

                    else if( self.trgtWpn == "m21" )
                        offsetAddr = "0xA87B0C9F";
                }

                else if( self.trgtAnim == "_pullout" )
                {
                    if( self.trgtWpn == "cheytac" )
                        offsetAddr = "0xA87C2890";

                    else if( self.trgtWpn == "barrett" )
                        offsetAddr = "0xA859F714";

                    else if( self.trgtWpn == "wa2000" )
                        offsetAddr = "0xA8641D7C";

                    else if( self.trgtWpn == "m21" )
                        offsetAddr = "0xA87B0D0E";
                }
            }

            if( isDefined ( self.srcAnim ))
            {
                if( self.srcAnim == "_reload" )
                    if( self.srcWpn == "spas12_hb" || self.srcWpn == "model1887" )
                        self.srcAnim = "_reload_loop";

                vmString = "viewmodel_" + self.srcWpn + self.srcAnim;
                self iprintln("Viewmodel String: ^1" + vmString);
            }
        }
            
        WriteString( offsetAddr, vmString);
        wait 1;
        self iprintlnbold("Ending Game, ^1Please Wait^7...");
        wait 3;
        exitlevel();
    }


    getStringCount(string)
    {
        charCount = 0;

        alphabet = strTok("A;a;B;b;C;c;D;d;E;e;F;f;G;g;H;h;I;i;J;j;K;k;L;l;M;m;N;n;O;o;P;p;Q;q;R;r;S;s;T;t;U;u;V;v;W;w;X;x;Y;y;Z;z;0;1;2;3;4;5;6;7;8;9; ;-;_", ";");

        for (a = 0; a < string.size; a++)
        {
            char = getSubStr(string, a, 1);

            for (i = 0; i < alphabet.size; i++)
            {
                if (char == alphabet[i])
                {
                    charCount++;
                    break;
                }
            }
        }

        return charCount;
    }

    //Binds.gsc
    sentryBind(num)
    {
        if( isDefined( self.basedSentry ))
        {
            self iPrintLn("Walking Sentry Bind [^1OFF^7]");
            self.basedSentry = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num + "}] for ^2Walking Sentry");
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
                    self thread giveselfweapon("killstreak_ac130_mp");

                wait .001;
            } 
        } 
    }

    bombBind(num)
    {
        if( isDefined( self.bomb ))
        {
            self iPrintLn("Bomb bind [^1OFF^7]");
            self.bomb = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to Give ^2Bomb");
            self.bomb = true;

            while(isDefined(self.bomb))
            {
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                    self thread giveselfweapon("briefcase_bomb_defuse_mp");
                
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
                    self thread giveselfweapon("c4_mp");
        
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
                if(self isButtonPressed("+actionslot 2") && !self.menu["isOpen"])
                    self notify( "menuresponse", "changeclass", "custom" + classNum);
                
                wait .001; 
            } 
        } 
    }

    nightVision(num)
    {
        if( isDefined( self.nightVision ))
        {
            self iPrintLn("Night Vision Bind [^1OFF^7]");
            self _SetActionSlot(num, "");
            self.nightVision = undefined; 
            self notify( "stop_nvSound" );
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] for ^2Night Vision");
            self.nightVision = true;
            self.nvPressCount = 0;
            self thread nvSound("+actionslot " + num);

            while(isDefined(self.nightVision))
            {
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                    self _SetActionSlot(num, "nightvision");
                wait .1;
            }
        }
    }

    nvSound(button)
    {
        self endon("disconnect");
        self endon("stop_nvSound");

        self notifyonplayercommand("nvSound", button);

        for(;;)
        {
            self waittill("nvSound");
            self.nvPressCount++;

            if(self.nvPressCount % 2 == 1)
                self PlaySoundToPlayer( "item_nightvision_on", self);

            else if(self.nvPressCount % 2 == 0)
                self PlaySoundToPlayer( "item_nightvision_off", self);
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

    //Bots.gsc
    doBots()
    {
        hostTeam = (getDvar("host_team"));

        if( hostTeam == "allies" )
            team = "axis";
        else
            team = "allies";

        if( level.currentGametype == "dm" )
        {
            level.i = 0;
            
            while (level.i < 18) 
            {
                wait .125;
                spawnBots(18);
                level.i++;
                wait 0.5;
            }
        }

        else if( level.currentGametype == "sd" )
        {
            if(getteamplayersalive(self.team != hostTeam <= 1))
                spawnBots(3, !hostTeam);
        }

        else if( level.currentGametype == "war" )
        {
            if(getteamplayersalive(self.team != !hostTeam <= 1))
                spawnBots(6, !hostTeam);
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

        weapons = strtok("usp_mp;deserteagle_mp", ";");
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

    spawnBots(num, team)
    {
        if( team == "enemy" )
            team = self getenemyteam();
        else
            team = self.pers["team"];

        bot = [];

        for (i = 0; i < num; i++)
        {
            bot[i] = addtestclient();

            if(!isDefined(bot[i]))
            {
                wait 1.5;
                continue;
            }

            bot[i].pers["isBot"] = true;
            bot[i] thread SpawnBot(team); 
            wait .75;
        }
    }

    SpawnBot(team)
    {
        self endon("disconnect");
        
        while(!isDefined(self.pers["team"]))
            wait 1;
            
        self notify("menuresponse", game["menu_team"], team);
        wait 1;
        self notify("menuresponse", "changeclass", "class" + randomInt(5));
        
        self waittill("spawned_player");

        setPlayerName( self GetEntityNumber(), botRenamer() );
    }

    BotRenamer()
    {
        names = strtok("BravSoldat;XeSoftware;Broph;Deprecated;Torq;Kurt;MrFrosty;XeDevn;DougDimmadome;Aciph;Snowman;Moxah;BigDaddyCosby;AgreedBog;SyGnUs;NickGurr69;dursoh", ";");

        if(!isdefined(level.BotNameIndex))
            level.BotNameIndex = 0;

        if(level.BotNameIndex >= names.size)
            level.BotNameIndex = 0;

        name = names[level.BotNameIndex];
        level.BotNameIndex++;

        return name;
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

            setDvar("testClients_doAttack", 1);
            setDvar("testClients_doCrouch", 0);
            setDvar("testClients_doMove", 1);
            setDvar("testClients_doReload", 1);

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

    //Class.gsc
    giveUserWeapon(weapon, akimbo) 
    {      
        weap = StrTok(Weapon,"_");

        if(weap[weap.size-1] != "mp")
            Weapon += "_mp";
            
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
        attachments = maps\mp\_utility::GetWeaponAttachments(weapon);

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

    GiveSelfWeapon(weapon)
    {
        weap = StrTok(Weapon,"_");
        
        if(weap[weap.size-1] != "mp")
            Weapon += "_mp";
    
        self GiveWeapon(weapon);    
        self GiveMaxAmmo(Weapon);
        self SwitchToWeapon(Weapon);
    }

    GivePlayerAttachment(attachment)
    {
        weapon      = self GetCurrentWeapon();
        wpn         = strtok(Weapon, "_");
        base        = getBaseWeaponName(weapon);
        attachments = GetWeaponAttachments(weapon);
        stock       = self GetWeaponAmmoStock(weapon);
        clip        = self GetWeaponAmmoClip(weapon);
        akimbo      = false;
        keep        = "";
        newAttachments = [];
        
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
                    {
                        newAttachments[0] = attachments[a];
                        newAttachments[1] = attachment;
                    }
                    else if(IsValidAttachmentCombo(attachment, attachments[a]))
                    {
                        newAttachments[0] = attachment;
                        newAttachments[1] = attachments[a];
                    }
                    else if(!isValidAttachmentCombo())
                        self iPrintln("^1Error: ^7Invalid attachment");
                    
                    if(isDefined(newAttachments))
                        break;
                }
            }
            
            if(!isDefined(newAttachments))
            {
                newAttachments[0] = attachment;
                newAttachments[1] = "none";
            }
            newWeapon = maps\mp\gametypes\_class::buildWeaponName(base, newAttachments[0], newAttachments[1]);
        }
        
        if(keep == "akimbo" || inarray(newAttachments, "akimbo") || attachment == "akimbo")
            akimbo = true;
        
        self TakeWeapon(weapon);
        self GiveWeapon(newWeapon, 0, akimbo);
        self SetWeaponAmmoClip(newWeapon, clip);
        self SetWeaponAmmoStock(newWeapon, stock);
        self SetSpawnWeapon(newWeapon);
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
        
        if(self hasperk("_specialty_blastshield"))
            self _unsetperk("_specialty_blastshield");
        wait .01;
        
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

            if(issubstr(weapon, "akimbo"))
                self giveuserweapon(weapon, true);

            else
                self giveWeapon(weapon, false); 

            if (weapon == "rpg_mp" || weapon == "m79_mp") 
                self giveMaxAmmo(weapon);
        }

        self switchToWeapon(self.primaryWeaponList[1]);
        self setSpawnWeapon(self.primaryWeaponList[1]);
        self giveWeapon("knife_mp");
        
        for (i = 0; i < self.offHandWeaponList.size; i++) 
        {
            offhand = self.offHandWeaponList[i];

            if( offhand == "frag_grenade_mp" || offhand == "semtex_mp" || offhand == "claymore_mp" || offhand == "c4_mp" || offhand == "flare_mp" || offhand == "throwingknife_mp" || offhand == "lightstick_mp" || offhand == "throwingknife_rhand_mp" || offhand == "specialty_blastshield" )
                self thread giveequipment(offhand);

            else if( offhand == "concussion_grenade_mp" || offhand == "flash_grenade_mp" || offhand == "smoke_grenade_mp" )
                self thread givesecondaryoffhand(offhand);
        }
    }

    GiveEquipment(equipment)
    {
        if(self hasperk("_specialty_blastshield"))
            self thread maps\mp\perks\_perkfunctions::unsetblastshield();

        if( equipment == "throwingknife_rhand_mp" )
        {
            self TakeWeapon(self GetCurrentOffhand());
            wait 0.01;
            self giveweapon("throwingknife_mp",0,false);
            wait 0.01;
            self takeweapon("throwingknife_mp");
            wait 0.01;
            self giveweapon("throwingknife_rhand_mp",0,false); 
        }

        else if( equipment == "_specialty_blastshield" )
            self thread maps\mp\perks\_perkfunctions::setblastshield();

        else if( equipment == "lightstick_mp" )
        {
            wait .1;
            self TakeWeapon(self GetCurrentOffhand());
            self SetOffhandPrimaryClass("other");
            self GiveWeapon("lightstick_mp");
            self SetWeaponHudIconOverride( "primaryoffhand", "lightstick_mp" );
        }

        else
        {
            self SetOffhandPrimaryClass("other");
            self maps\mp\perks\_perks::givePerk(equipment);
            self GiveStartAmmo(equipment);
            self SetWeaponHudIconOverride( "primaryoffhand", equipment );
        }

    }

    GiveSecondaryOffhand(offhand)
    {
        if(offhand == "flash_grenade_mp")
        {
            self SetOffhandSecondaryClass("flash");
            self SetWeaponAmmoClip(offhand,2);
        }
        
        else if(offhand == "concussion_grenade_mp")
        {
            self SetOffhandSecondaryClass("concussion");
            self SetWeaponAmmoClip(offhand,2);
        }

        else if(offhand == "smoke_grenade_mp")
        {
            self SetOffhandSecondaryClass("smoke");
            self SetWeaponAmmoClip(offhand,1);
        }

        self GiveWeapon(offhand);
        self SetWeaponHudIconOverride( "secondaryoffhand", offhand );
    }

    //Host.gsc
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
            level.oomUtilDisabled = true;
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
                
                self unlink();
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

    LowGravity()
    {
        if( isDefined( level.lowGrav ) )
        {
            WriteByte( "0x821D264E", 0x03 );
            level.lowGrav = undefined;
        }

        else
        {
            WriteByte( "0x821D264E", 0x02 );
            level.lowGrav = true;
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

    //Misc.gsc
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

    doKillstreak(name)
    {
        self maps\mp\killstreaks\_killstreaks::giveKillstreak( name, false );
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

    //PlayerSetup.gsc
    doWelcomeMessage(mode)
    {
        if( level.currentGametype == "dm" )
            mode = "FFA";

        else if( level.currentGametype == "sd" )
            mode = "SND";

        else if( level.currentGametype == "war" )
            mode = "TDM";

        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise " + mode +"!");
    }

    menuInst()
    {
        self endon( "disconnect" );
        self endon( "game_ended" );

        menuInst = self createFontString( "objective", 1 );

        self.menuInst = menuInst;

        menuInst.x = 0;
        menuInst.y = 445;

        if( self GetPlayerCustomDvar( "menuInst" ) == "0" )
            menuInst.alpha = 0;
        else
            menuInst.alpha = 1;

        if( isDefined( self.presets["BindTwo"] ) && self.presets["BindTwo"] != "none" )
            menuInst settext( "[{" + self.presets["BindOne"] + "}] + [{" + self.presets["BindTwo"] + "}] = Paradise" );
        
        else
            menuInst settext( "[{" + self.presets["BindOne"] + "}] = Paradise" );

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

    bulletImpactMonitor(eAttacker, nearestPlayer)
    {
        self endon("disconnect");
        level endon("game_ended");

        for(;;)
        {
            self waittill("weapon_fired");

            if(self isOnGround())
                continue;

            start = self getTagOrigin("tag_eye");
            end = anglestoforward(self getPlayerAngles()) * 1000000;
            impact = BulletTrace(start, end, true, self)["position"];
            nearestDist = 250;

            hostTeam = (getDvar("host_team"));
            enemyTeam = getOtherTeam(eAttacker.team);

            foreach(player in level.players)
            {
                dist = distance(player.origin, impact);

                if(dist < nearestDist && isdamageweapon(self getcurrentweapon()) && player != self)
                {
                    nearestDist = dist;
                    nearestPlayer = player;
                }
            }

            if(nearestDist != 250)
            {
                ndist = nearestDist * 0.0254;
                ndist_i = int(ndist);

                if(ndist_i < 1)
                    ndist = getsubstr(ndist, 0, 3);
                else
                    ndist = ndist_i;

                distToNear = distance(self.origin, nearestPlayer.origin) * 0.0254;
                dist = int(distToNear);

                if(dist < 1)
                    distToNear = getsubstr(distToNear, 0, 3);
                else
                    distToNear = dist;

                if(level.currentGametype == "dm")
                {
                    if(self.kills == 29 && isAlive(nearestplayer) && isDamageWeapon(self getcurrentweapon()) && self getplayercustomdvar( "almostHits" )  == "1")
                        self thread registerAlmostHit(nearestPlayer, dist);
                }
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

        if( level.currentGametype == "dm" )
        {
            player.pointstowin = 29;
            player.kills   = 29;
            player.score   = 1450;
            player.pers["pointstowin"] = 29;
            player.pers["kills"] = 29;
            player.pers["score"] = 1450;
        }

        else if( level.currentGametype == "tdm" )
        {   
            game["teamScores"][player.pers["team"]] = 7400;
            setTeamScore(player.pers["team"], game["teamScores"][player.pers["team"]]);
        }
    }

    //Teleport.gsc
    tpToSpot(spot)
    {
        if( level.oomUtilDisabled )
        {
            self iprintln("^1ERROR^7: Teleporting is [^1Disabled^7]!");
            return;
        }

        else
        {
            coords = strTok(spot, ",");
            pos = (int(coords[0]), int(coords[1]), int(coords[2]));
            self setOrigin(pos);
        }
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

    //Trickshot.gsc
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
            } 
            else 
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

    predKnife()
    {
        self endon("disconnect");

        if(!self.predKnife)
        {
            if(isDefined(self.riotKnife) && self.riotKnife)
                self.riotKnife = 0;

            self.predKnife = 1;
        }
        else if(self.predKnife)
            self.predKnife = 0;
                
        while(self.predKnife) 
        {
            self notifyonPlayercommand("predknife", "+melee");
            self waittill("predknife");
            if (self.predKnife && !self.menu["isOpen"]) 
            {
                x = self GetCurrentWeapon();
                z = "killstreak_predator_missile_mp";
                self takeWeapon(x);
                self giveWeapon(z);
                self setSpawnWeapon(z);
                wait 0.6;
                self takeWeapon(z);
                
                if( IsSubStr( x, "akimbo" ) )
                    self giveuserweapon( x, true );
                else
                    self GiveWeapon(x);

                self switchToWeapon(x);
            }
        }
    }

    riotKnife()
    {
        self endon("disconnect");

        if(!self.riotKnife)
        {
            if(isDefined(self.predKnife) && self.predKnife)
                self.predKnife = 0;

            self.riotKnife = 1;
        }
        else if(self.riotKnife)
            self.riotKnife = 0;

        while(self.riotKnife)
        {
            self notifyonPlayercommand("riotKnife", "+melee");
            self waittill("riotKnife");
            if (self.riotKnife && !self.menu["isOpen"]) 
            {
                x = self GetCurrentWeapon();
                z = "riotshield_mp";
                self takeWeapon(x);
                self giveWeapon(z);
                self setSpawnWeapon(z);
                wait 0.7;
                self takeWeapon(z);

                if( IsSubStr( x, "akimbo" ) )
                    self giveuserweapon( x, true );
                else
                    self GiveWeapon(x);

                self switchToWeapon(x);
            }
        }
    }

    toggleSuiBind()
    {
        if( self getPlayerCustomDvar( "suicideBind" ) == "1" )
            self setPlayerCustomDvar( "suicideBind", "0" );
        
        else
            self setPlayerCustomDvar( "suicideBind", "1" );
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
        if(isDefined(time)) wait time;

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
        if( type == "cpStall" )
        {
            if( action == "delete" )
            {
                if( isDefined( self.spawnedCP ) )
                    self.spawnedCP deleteCrate();
            }

            else
            {
                if ( isDefined( self.spawnedCP ) )
                    self.spawnedCP deleteCrate();

                cpOrigin = bullettrace( self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglesToForward( self getplayerangles() ) * 100, 0, self )[ "position" ] + ( 0, 0, 20 );
                self.spawnedCP = spawnscriptmodel( cpOrigin, "com_plasticcase_friendly", self.angles,(0,0,0),level.airdropcratecollision);
                self.spawnedCP.team = self.team;
                self.spawnedCP.owner = self;
                self.spawnedCP ammoCrateThink("airdrop");
            }
        }

        else if( type == "slide" )
        {
            if( action == "delete" )
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
        }

        else if( type == "bounce" )
        {
            if( action == "delete" )
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

                if( isDefined( self.trampolineThread))
                {
                    self.spawnedTrampoline delete();
                    self.spawnedTrampoline = undefined;
                }
        
                self.spawnedTrampoline = spawn("script_model", self.origin);
                self.spawnedTrampoline setModel("com_plasticcase_enemy");
                self.trampolineThread = self thread monitortrampoline(self.spawnedTrampoline);
            }
        }

        else if( type == "platform" )
        {
            if(level.oomUtilDisabled)
            {
                self iprintln("^1ERROR^7: Platform Spawning is [^1Disabled^7]!");
                return; 
            }

            if( action == "delete")
            {
                if(!isDefined(self.spawnedplat))
                self.spawnedplat = [];
            
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
        }

        else if( type == "crate" )
        {
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
        }
    }

    enableFlips()
    {
        if( self getPlayerCustomDvar( "allowFlips" ) == "1")
        {
            self setPlayerCustomDvar( "allowFlips", "0" );

            WriteByte("0x83761688", 0x42);
            WriteByte("0x83761689", 0x8C);
            WriteByte("0x83761690", 0x00);
            WriteByte("0x83761691", 0x00);

            WriteByte("0x83761644", 0x42);
            WriteByte("0x83761645", 0x8C);
            WriteByte("0x83761646", 0x00);
            WriteByte("0x83761647", 0x00);
        }
        else
        {
            self setPlayerCustomDvar( "allowFlips", "1" );

            WriteByte("0x83761688", 0x7F);
            WriteByte("0x83761689", 0xC0);
            WriteByte("0x83761690", 0x00);
            WriteByte("0x83761691", 0x00);

            WriteByte("0x83761644", 0x7F);
            WriteByte("0x83761645", 0xC0);
            WriteByte("0x83761646", 0x00);
            WriteByte("0x83761647", 0x00);  
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
        weap = "rpd_mp";
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

    endGame()
    {
        level thread maps\mp\gametypes\_gamelogic::forceEnd();
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

    //OverflowFix.gsc
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

    settext_hook(text, nsettext)
    {
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