    //Main.gsc
    init()
    {
        level._strings              = [];
        level._status               = strtok("None;^2Verified;^5CoHost;^1Host", ";");
        level._MenuName             = "Paradise";
        level._currentMapName       = getDvar("mapname");
        level._currentGametype      = getDvar("g_gametype");
        level._callDamage           = level._callbackPlayerDamage;
        level._callbackPlayerDamage = ::modifyPlayerDamage;
        level._streaks              = strtok("uav;counter_uave;airdrop;minigun_turret;airdrop_sentry_minigun;predator_missile;precision_airstrike;harrier_airstrike;lockseekdie;helicopter;EMP;remote_mortar;airdrop_mega;exosuit;helicopter_flares;stealth_airstrike;helicopter_minigun;ac130", ";");
        level._lastKill_minDist     = 15;
        level._oomUtilDisabled      = 0;
        level._BotNameIndex         = 0;

        nx1Precache();
        initDvars();

        /*
        if( level._currentGametype != "sd" )
            level thread autoFakeNuke();

        else
        */
        if( level._currentGametype == "sd" )
            level._bombsDisabled = true;
            
        level thread onPlayerConnect();
    }

    nx1Precache()
    {
        precacheshader("hudsoftline");
        precacheitem("lightstick_mp");
        precacheitem("deserteaglegold_mp");
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

            player thread initstrings(); 

            if( level._currentGametype == "sd" )
            {
                bombZones = GetEntArray("bombzone", "targetname");
                shouldDisable = !AreBombsDisabled();

                if(!isDefined(bombZones) || !bombZones.size)
                    return;

                for(a = 0; a < bombZones.size; a++)
                {
                    bombZones[a] common_scripts\utility::trigger_off();
                    level._bombsDisabled = true;
                }
            }

            player loadsettings();
            player thread ServerSettings();
            player thread MonitorButtons();
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

            if( !self.pers["isBot"] )
            {
                if( self isHost() )
                {
                    self thread initializesetup( 3, self );

                    if( level._currentGametype == "war" || level._currentGametype == "sd" )
                    {
                        setDvar("host_team", self.team);

                        if( level._currentGametype == "war" )
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

    modifyPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex)
    {
        dist = GetDistance(self, eAttacker);

        if( isDefined( eAttacker.pers["isBot"] ) && eAttacker.pers["isBot"] && !self.pers["isBot"] )
        	iDamage = 0;

        if(level._currentGametype == "dm")
        {
            if(sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH")
                iDamage = 0;

            else if(eAttacker.kills == 29)
            {
                if(dist >= level._lastKill_minDist)
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
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level._lastKill_minDist + "m^7!");
                    }
                }

                else
                {
                    if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        iDamage = 0;
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level._lastKill_minDist + "m^7!");
                    }
                }
            }
            return [[level._callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }

        else if(level._currentGametype == "sd")
        {
            if(sMeansOfDeath == "MOD_FALLING") iDamage = 0;

            enemyTeam = maps\mp\_utility::getOtherTeam(eAttacker.team);
    
            if(getTeamPlayersAlive(enemyTeam) == 1)
            {
                if(dist >= level._lastKill_minDist)
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
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level._lastKill_minDist + "m^7!");
                    }
                }
                
                else
                {
                    if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        iDamage = 0;
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level._lastKill_minDist + "m^7!");
                    }
                }
            }
            return [[level._callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }

        else if(level._currentGametype == "war")
        {
            if(game["teamScores"][eAttacker.pers["team"]] == 7400)
            {
                if(dist >= level._lastKill_minDist)
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
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level._lastKill_minDist + "m^7!");
                    }
                }
                else
                {
                    if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        iDamage = 0;
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level._lastKill_minDist + "m^7!");
                    }
                }
                return [[level._callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
            }
        }
    }

    isdamageweapon(sweapon)
    {
        if(!IsDefined(sweapon))
            return 0;

        if(issubstr(sWeapon, "fal") || issubstr(sweapon, "cheytac") || issubstr(sWeapon, "barrett") || issubstr(sweapon, "m21"))
            return 1;
        else
            return 0;
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
        setDvar("cg_drawFPS", 0);
        setDvar("cg_drawViewpos", 0);
        setDvar("com_statmon", 0);
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

    ServerSettings()
    {
        //BulletPenetration
        WriteFloat( "0x8200BC30", "9999999.0" );
        WriteInt( "0x8211CC7C", "0x60000000" ); //BG_GetSurfacePenetrationDepth(bne(branch if not equal) call to loc_8211CC8C)
        WriteInt( "0x8211CC84", "0xC02BBC30" );//BG_GetSurfacePenetrationDepth(lfs(load floating point single) from __real_00000000)

        //Range
        WriteInt( "0x82260070", "0xC3EBBC30" ); //Bullet_Fire(lfs(load floating point single) from __real_46000000)
        WriteShort( "0x82260050", "0x4800" ); //Bullet_Fire(beq(branch if equal) to loc_82260068) -- Force branch to loc_82260068(Allow all weapons to have max bullet range)
    
        //Bounces
        WriteShort("0x8210966C", "0x4800");
        WriteInt("0x82113578", "0x48000018");
        WriteInt("0x82100C10", "0x60000000");

        //Elevators
        WriteShort("0x821106CC", "0x4800");
        WriteInt("0x8211067C", "0x60000000");  

        addresses = strtok("0x8210CB70;0x8210CBFC;0x8210CC90", ";");
        for (a = 0; a < addresses.size; a++)
            WriteInt(addresses[a], "0x60000000");
    }

    //Menu.gsc
    menuOptions()
    {
        player = self.selected_player;        
        menu = self getCurrentMenu();
        
        player_names = [];
        foreach( players in level._players )
            player_names[player_names.size] = players.name;

        if( menu == "main" )
        {
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

                if(self ishost() || self isDeveloper() || player.access == 2) 
                    self addOpt("Host Options", ::newMenu, "host");
            }
        }

        else if( menu == "ts" )
        {
            self addMenu("ts", "Trickshot Menu");
            self addOpt("Spawnables", ::newMenu, "spawnables");
            self addToggle("Noclip [{+frag}]", self.noClip, ::initNoClip);

            if(level._currentGametype == "dm")
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
            self addToggle("Save & Load", self.snl, ::saveandload);

            tpNames = "";
            tpCoords = "";
            
            if(level._currentMapName == "mp_nx_pitstop")
            {
                tpNames   = "Crane Base;Car Stack 1;Car Stack 2";
                tpCoords  = "4245.73,-453.023,168.984;2751.04,959.321,271.125;4365.91,868.045,177.125";
            }
            else if(level._currentMapName == "mp_nx_galleria")
            {
                tpNames = "Rooftop 1;Rooftop 2;Rooftop 3;Distance Rooftop;Distance Rooftop 2";
                tpCoords = "2148.1,2810.51,1472.13;5527.53,1387.29,1624.13;10596.8,4018.72,2152.13;4503.25,-8653.79,4136.13;13001.5,-2026.44,4600.13";
            }
            else if(level._currentMapName == "mp_nx_stasis")
            {
                tpNames = "Concrete Path;Rooftop;Distance Rooftop;";
                tpCoords = "5836.87,5026.11,411.125;4055.36,8650.02,216.125;-3269.69,11663.5,1684.13";
            }
            else if(level._currentMapName == "mp_nx_border")
            {
                tpNames = "Concrete Wall;White Roof;Brick Roof";
                tpCoords = "-1128.03,-4640.16,448.125;-2300.7,326.376,744.125;253.866,-3848.28,184.125";
            }
            else if(level._currentMapName == "mp_nx_contact")
            {
                tpNames = "Skyscraper;Brown Roof;Sat Roof";
                tpCoords = "-3363.48,3506.43,969.625;273.768,1936.83,222.125;-655.953,5622.68,322.125";
            }
            else if(level._currentMapName == "mp_nx_ugvcontact")
            {
                tpNames = "Skyscraper;Brown Roof;Sat Roof";
                tpCoords = "-3363.48,3506.43,969.625;273.768,1936.83,222.125;-655.953,5622.68,322.125";
            }
            else if(level._currentMapName == "mp_nx_ugvhh")
            {
                tpNames = "Yellow Roof;Yellow Roof 2;Train Rail;";
                tpCoords = "6443.22,1507.72,1822.13;-4146.66,1674.83,1712.13;-358.548,5133.21,626.125";
            }
            else if(level._currentMapName == "mp_nx_deadzone")
            {
                tpNames = "Store Roof;White Roof;";
                tpCoords = "-186.288,5863.99,264.125;2359.37,8114.34,169.125;";
            }
            else if(level._currentMapName == "mp_nx_import")
            {
                tpNames = "Crate Crane;Brick Roof;Grain Bin";
                tpCoords = "1139.5,-6307.19,730.121;-70.4117,-6878.96,575.125;-477.934,-12734.2,752.125";
            }
            else if(level._currentMapName == "mp_nx_monorail")
            {
                tpNames = "Garage Roof;Train Rail;Rooftop";
                tpCoords = "139.137,-4760.34,1648.13;-3127.69,733.397,330.125;3004.18,-2838.27,1299.13";
            }
            else if(level._currentMapName == "mp_nx_seaport")
            {
                tpNames = "OOM Boat;Bell Tower";
                tpCoords = "5832.99,5642,96.125;1503.63,8215.04,424.125";
            }
            else if(level._currentMapName == "mp_nx_skylab")
            {
                tpNames = "Skyscraper;Roof 1;Roof 2";
                tpCoords = "-1408.8,857.394,872.125;-1237.98,1464.36,350.125;732.812,263.932,373.125";
            }
            else if(level._currentMapName == "mp_nx_streets")
            {
                tpNames = "Brick Roof;Distance Roof;Distance Roof 2";
                tpCoords = "123.143,1018.78,912.125;-4695.4,4209.81,2822.41;-3050.7,6083.82,3346.13";
            }
            else if(level._currentMapName == "mp_nx_subyard")
            {
                tpNames = "Cargo Crane;OOM Crane;Warehouse Roof";
                tpCoords = "-578.771,480.672,449.625;2643.95,-2383.91,384.125;4195.42,2748,638.928";
            }
            else if(level._currentMapName == "mp_nx_whiteout")
            {
                tpNames = "Bridge;Bridge Tower;Pipeline;Cliff";
                tpCoords = "-6382.23,-1218.29,875.621;-12179,-2883.63,3029.13;7033.6,554.313,331.026;12512.1,4317.6,-114.584";
            }
            else if(level._currentMapName == "mp_nx_leg_crash")
            {
                tpNames = "Rooftop 1;Roof 2;Concrete Wall";
                tpCoords = "245.278,3142.63,824.125;1204.96,-4689.41,1262.13;5561.54,3.45292,584.125";
            }
            else if(level._currentMapName == "mp_nx_leg_over")
            {
                tpNames = "Water Tower;A Barrier Sui;River Bed Sui";
                tpCoords = "3082.29,-2284.81,992.126;-1972.75,-1927.23,992.126;1351.02,536.997,992.126";
            }
            else if(level._currentMapName == "mp_nx_leg_term")
            {
                tpNames = "Plane Wing;Spawn Roof;Spawn Roof 2;OOM Roof;";
                tpCoords = "1698.55,-5.81747,819.645;2878.44,6952.26,464.088;3421.62,2104.86,464.125;-867.22,4225.9,744.125;";
            }
            else
                tpNames  = "No Custom Spots";

            self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
        }

        else if( menu == "class" )
        {
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
            self addSliderString("Attachments", "none;acog;reflex;silencer;grip;gl;akimbo;thermal;fmj;hrof;lrof;xmags;tactical;jhp;match;astock;plusone", "None;ACOG Scope;Red Dot Sight;Silencer;Grip;Grenade Launcher;Akimbo;Thermal;FMJ;Rapid Fire;Decreased Rate;Extended Mags;Tactical Knife;Jacketed Hollow Point;Match Grade Ammo;Adjustable Stock;Extra Shot", ::GivePlayerAttachment);
            self addSliderString("Camos", "0;1;2;3;4;5;6;7;8;9", "None;Woodland;Desert;Artic;Digital;Urban;Red Tiger;Blue Tiger;Fall;Active Camo", ::changeCamo);
            self addSliderString("Lethals", "frag_grenade_mp;semtex_mp;throwingknife_mp;throwingknife_rhand_mp;lightstick_mp", "Frag;Semtex;Throwing Knife;RH Throwing Knife;Glowstick", ::giveLethal);
            self addSliderString("Equipment", "claymore_mp;c4_mp;flare_mp", "Claymore;C4;Tactical Insertion", ::giveEquipment);
            self addSliderString("Tacticals", "emp_grenade_mp;lidar_grenade_mp;gas_grenade_mp;flash_grenade_mp;concussion_grenade_mp;smoke_grenade_mp", "EMP Grenade;Lidar Grenade;Gas Grenade;Flash Grenade;Stun Grenade;Smoke Grenade", ::givesecondaryoffhand);
            self addDvarToggle("Save Loadout", "loadoutSaved", ::saveLoadoutToggle);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
        }

        else if( menu == "wpns" )
        {
            self addMenu("wpns", "Weapons Menu");

            arIDs = "scar2_mp;scar_mp;ecr_mp;pulserifle_mp;xm108_mp;fal_mp;asmk27_mp";
            arNames = "SCAR Mod 2;SCAR-H;ECR Phoenix;Pulse Rifle;XM108 SEAR;FAL;Atlas Mk.27";
            self addSliderString("Assault Rifles", arIDs, arNames, ::giveUserWeapon);

            smgIDs = "type104_mp;ump45_mp;p90_mp";
            smgNames = "Type 104;UMP45;P90";
            self addSliderString("Sub Machine Guns", smgIDs, smgNames, ::giveUserWeapon);

            lmgIDs = "glo_mp;rpd_mp;m240_mp";
            lmgNames = "G-L0 7.62mm;RPD;M240";
            self addSliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon);

            srIDs = "lasersniper_mp;cheytac_mp;barrett_mp;m21_mp";
            srNames = "ESR;Intervention;Barrett .50cal;M21 EBR";
            self addSliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon);

            sgIDs = "ksg_mp;spas12_mp;aa12_mp;m1014_mp";
            sgNames = "KSG;SPAS-12;AA-12;M1014";
            self addSliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon);

            mpIDs = "glock_mp;beretta393_mp";
            mpNames = "G18;M93 Raffica";
            self addSliderstring("Machine Pistols", mpIDs, mpNames, ::giveUserWeapon);

            pstlIDs = "coltanaconda_mp;beretta_mp";
            pstlNames = ".44 Magnum;M9";
            self addSliderstring("Pistols", pstlIDs, pstlNames, ::giveUserWeapon);

            lnchrIDs = "ajax_mp;needler_mp;m320_mp;stinger_mp;rpg_mp;javelin_mp";
            lnchrNames = "AJAX;Sticky Grenade Launcher;M320;Stinger;RPG-7;Javelin";
            self addSliderstring("Launchers", lnchrIDs, lnchrNames, ::giveUserWeapon);
            
            shldIDs = "riotshield_mp;riotshieldcloak_mp;riotshieldcover_mp";
            shldNames = "Riot Shield;Cloaking Shield;Deployable Shield";
            self addSliderstring("Shields", shldIDs, shldNames, ::giveUserWeapon);

            self addOpt("Special Weapons", ::newMenu, "specs");
        }

        else if( menu == "specs" )
        {
            self addMenu("specs", "Special Weapons");
            self addOpt("Default Weapon", ::giveUserWeapon, "defaultweapon_mp", false);
            self addOpt("Akimbo Default Weapon", ::giveUserWeapon, "defaultweapon_mp", true);
            self addOpt("OMA Bag", ::giveUserWeapon, "onemanarmy_mp", false);
            self addOpt("Dual OMA Bag", ::giveUserWeapon, "onemanarmy_mp", true);
        }

        else if( menu == "afthit" )
        {
            self addMenu("afthit", "Afterhits Menu");

            arIDs = "scar2_mp;scar_mp;ecr_mp;pulserifle_mp;xm108_mp;fal_mp;asmk27_mp";
            arNames = "SCAR Mod 2;SCAR-H;ECR Phoenix;Pulse Rifle;XM108 SEAR;FAL;Atlas Mk.27";
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            smgIDs = "type104_mp;ump45_mp;p90_mp";
            smgNames = "Type 104;UMP45;P90";
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

            lmgIDs = "glo_mp;rpd_mp;m240_mp";
            lmgNames = "G-L0 7.62mm;RPD;M240";
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            srIDs = "lasersniper_mp;cheytac_mp;barrett_mp;m21_mp";
            srNames = "ESR;Intervention;Barrett .50cal;M21 EBR";
            self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

            lnchrIDs = "ajax_mp;needler_mp;m320_mp;stinger_mp;rpg_mp;javelin_mp";
            lnchrNames = "AJAX;Sticky Grenade Launcher;M320;Stinger;RPG-7;Javelin";
            self addSliderString("Launchers", lnchrIDs, lnchrNames, ::afterhit);

            miscIDs = "briefcase_bomb_defuse_mp;killstreak_ac130_mp";
            miscNames = "Bomb Briefcase;Laptop";
            self addSliderString("Miscellaneous", miscIDs, miscNames, ::afterhit);
        }

        else if( menu == "kstrks" )
        {
            self addMenu("kstrks", "Killstreak Menu"); 

            Killstreak = strtok("UAV;Counter-UAV;Care Package;Minigun Turret;Sentry Gun;Predator Missile;Precision Airstrike;Harrier Airstrike;Night Raven;Attack Helicopter;EMP;Rods of God;Emergency Airdrop;Ares;Pave Low;Stealth Bomber;Chopper Gunner;AC130", ";");

            for(a=0;a<level._streaks.size;a++)
                self addOpt( Killstreak[a], ::doKillstreak, level._streaks[a] );

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
            self addSliderValue("Red", int( self LoadPreset( "menuColorRed", "255" ) ), 0, 255, 15, ::updatePreset, "menuColorRed" );
            self addSliderValue("Green", int( self LoadPreset( "menuColorGreen", "36" ) ), 0, 255, 15, ::updatePreset, "menuColorGreen" );
            self addSliderValue("Blue", int( self LoadPreset( "menuColorBlue", "0" ) ), 0, 255, 15, ::updatePreset, "menuColorBlue" );
        }

        else if( menu == "host" )
        {
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            self addOpt("Lobby Settings", ::newMenu, "lobby");
            self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::spawnBots);
            self addToggle("Freeze Bots", self.frozenBots, ::toggleFreezeBots);
            self addSliderString("Bot Controls", "teleport;fill;kick", "Teleport Bots to Crosshairs;Spawn 18 Bots;Kick All Bots", ::botControls);
            self addToggle("Disable OOM Utilities", level._oomUtilDisabled, ::oomToggle);
        }

        else if( menu == "lobby" ) 
        {
            self addMenu("lobby", "Lobby Settings");
            self addToggle("Toggle Floaters", self.floaters, ::togglelobbyfloat);
            self addsliderstring("Minimum Distance", "15;25;50;100;150;200;250", undefined, ::setMinDistance);
            self addSliderValue("Game Timer", 0, -10, 10, 1, ::editTime);
            self addOpt("Fast Restart", ::FastRestart);
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

        foreach( player in level._players )
        {
            perm = self getPlayerPermLabel(player);
            self addOpt(player getName() + " [" + perm + "^7]", ::newMenu, "Verify_" + player GetEntityNumber());
        }

        targetPlayer = undefined;
        foreach( player in level._players )
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

            for(i = 0; i < level._status.size - 1; i++)
                self addOpt("Give: " + level._status[i], ::initializesetup, i, self.menuVerifyTarget);
        }
    }

    getPlayerPermLabel(player)
    {
        perm = "None";

        if(isDefined(level._status) && isDefined(player.access) && isDefined(level._status[player.access]))
            perm = level._status[player.access];

        if(player isDeveloper())
            perm = perm + " ^7| ^6Developer";

        return perm;
    }

    getPlayerByXuid(xuid)
    {
        for(i = 0; i < level._players.size; i++)
        {
            if(level._players[i] getXUID() == xuid)
                return level._players[i];
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

        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2, "TOPLEFT", "CENTER", self.presets["X"] + 109, self.presets["Y"] - 105, 5, 1, level._MenuName, self.presets["MenuTitle_Color"]);
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
            self.menu["OPT"][e] = self createText(self.presets["Option_Font"], self.presets["Font_Scale"], "LEFT", "CENTER", self.presets["X"] + 5, self.presets["Y"] - 62 + (e * 15), 3, 1, "", self.presets["Text"], undefined, true);
    }

    refreshTitle()
    {
        self.menu["UI"]["MENU_TITLE"] settext(level._MenuName);
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

        self.presets["X"] = int( self LoadPreset( "menuPosX", "155" ) ); //155
        self.presets["Y"] = int( self LoadPreset( "menuPosY", "-20" ) );
        self.presets["R"] = int( self LoadPreset( "menuColorRed", "255" ) );
        self.presets["G"] = int( self LoadPreset( "menuColorGreen", "36" ) );
        self.presets["B"] = int( self LoadPreset( "menuColorBlue", "0" ) );
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
            player dowelcomemessage();
            player thread bulletImpactMonitor();
            player thread trackstats();
            player thread changeClass();
            player thread menuInst();

            if( level._currentGametype == "dm" )
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
            textElem = level maps\mp\gametypes\_hud_util::createServerFontString(font, fontScale);

        else
            textElem = self maps\mp\gametypes\_hud_util::createFontString(font, fontScale);

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
        boxElem maps\mp\gametypes\_hud_util::setPoint(align, relative, x, y);
        boxElem thread watchDeletion(player);
        
        player.hud_amount++;
        return boxElem;
    }

    createKeyboardText(font, fontSize, sort, text, align, relative, x, y, alpha, color, glowAlpha, glowColor) 
    {
        uiElement = self maps\mp\gametypes\_hud_util::CreateFontString(font, fontSize);

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
        uiElement maps\mp\gametypes\_hud_util::setPoint(align, relative, x, y);
        
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
        uiElement maps\mp\gametypes\_hud_util::setParent(level._uiParent);
        uiElement setShader(shader, width, height);
        uiElement.foreground = true;
        uiElement.align = align;
        uiElement.relative = relative;
        uiElement.x = x;
        uiElement.y = y;

        if (!level._splitScreen) 
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

        element = self maps\mp\gametypes\_hud_util::getParent();

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

        if (element == level._uiParent) 
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
            maps\mp\gametypes\_hud_util::setPointBar(point, relativePoint, xOffset, yOffset);

        self maps\mp\gametypes\_hud_util::updateChildren();
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
        for(i=0; i < level._players.size; i++)
        {
            if(isDefined(level._players[i].pers["isBot"]) && level._players[i].pers["isBot"])
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
            self maps\mp\_utility::_SetActionSlot(num, "");
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
                    self maps\mp\_utility::_SetActionSlot(num, "nightvision");
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

        if( level._currentGametype == "dm" )
        {
            level._i = 0;
            
            while (level._i < 18) 
            {
                wait .125;
                spawnBots(18);
                level._i++;
                wait 0.5;
            }
        }

        else if( level._currentGametype == "sd" )
        {
            if(getteamplayersalive(self.team != hostTeam <= 1))
                spawnBots(3, !hostTeam);
        }

        else if( level._currentGametype == "war" )
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
        if(team == "enemy")
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
            bot[i] thread spawnBot(team);
            wait 1;
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

        //self RenamePlayer( botrenamer(), self );
    }

/*
    RenamePlayer(string,player)
    {
        if(self != player)
            return;

        client = "0x83366214" + (player GetEntityNumber() * "0x3B00");

        name = ReadString(client);
        for(a=0;a<name.size;a++) WriteByte( client+a, "0x00" );
        
        WriteString( client, string );
    } 

    BotRenamer()
    {
        names = strtok("BravSoldat;XeSoftware;Broph;Deprecated;Torq;Kurt;MrFrosty;XeDevn;DougDimmadome;Aciph;Snowman;Moxah;BigDaddyCosby;AgreedBog;SyGnUs;NickGurr69;dursoh", ";");

        if(!isdefined(level._BotNameIndex))
            level._BotNameIndex = 0;

        if(level._BotNameIndex >= names.size)
            level._BotNameIndex = 0;

        name = names[level._BotNameIndex];
        level._BotNameIndex++;

        return name;
    }
*/

    botControls(action)
    {
        if(action == "teleport")
            self tpBots();

        else if(action == "kick")
            self kickallbots();
    }

    kickAllBots()
    {
        players = level._players;

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
            players = level._players;
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
            players = level._players;
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
        players = level._players;

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
        base        = maps\mp\_utility::getBaseWeaponName(weapon);
        attachments = maps\mp\_utility::GetWeaponAttachments(weapon);
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

            if (weapon == "rpg_mp") 
                self giveMaxAmmo(weapon);
        }

        self switchToWeapon(self.primaryWeaponList[1]);
        self setSpawnWeapon(self.primaryWeaponList[1]);
        self giveWeapon("knife_mp");
        
        for (i = 0; i < self.offHandWeaponList.size; i++) 
        {
            offhand = self.offHandWeaponList[i];

            if( offhand == "frag_grenade_mp" || offhand == "semtex_mp" || offhand == "throwingknife_mp" || offhand == "lightstick_mp" || offhand == "throwingknife_rhand_mp" )
                self thread giveLethal(offhand);

            else if( offhand == "claymore_mp" || offhand == "c4_mp" || offhand == "flare_mp" )
                self thread giveequipment(offhand);

            else if( offhand == "emp_grenade_mp" || offhand == "lidar_grenade_mp" || offhand == "gas_grenade_mp" || offhand == "concussion_grenade_mp" || offhand == "flash_grenade_mp" || offhand == "smoke_grenade_mp" )
                self thread givesecondaryoffhand(offhand);
        }
    }

    giveLethal(equipment)
    {
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

    giveEquipment( equipment )
    {
        specWpns = strtok("c4_mp;rpg_mp;claymore_mp",";");
        for( i = 0; i < specWpns.size; i++ )
        {
            if( self hasWeapon( specWpns[i] ) )
                self takeweapon( specWpns[i] );
        }

        self setActionSlot(1, "");
        wait .01;
        self giveWeapon( equipment );
        self setActionSlot(1, "weapon", equipment);
    }

    GiveSecondaryOffhand(offhand)
    {
        if(offhand == "flash_grenade_mp")
        {
            self SetOffhandSecondaryClass("flash");
            self SetWeaponAmmoClip(offhand, 2);
        }
        
        else if(offhand == "concussion_grenade_mp")
        {
            self SetOffhandSecondaryClass("concussion");
            self SetWeaponAmmoClip(offhand, 2);
        }

        else if(offhand == "smoke_grenade_mp")
        {
            self SetOffhandSecondaryClass("smoke");
            self SetWeaponAmmoClip(offhand, 1);
        }

        else if( offhand == "emp_grenade_mp" )
        {
            self SetOffhandSecondaryClass("emp");
            self SetWeaponAmmoClip(offhand, 2);
        }

        else if( offhand == "gas_grenade_mp" )
        {
            self SetOffhandSecondaryClass("gas");
            self SetWeaponAmmoClip(offhand, 1);
        }

        else if( offhand == "lidar_grenade_mp" )
        {
            self SetOffhandSecondaryClass("lidar");
            self SetWeaponAmmoClip(offhand, 2);
        }

        self GiveWeapon(offhand);
        self SetWeaponHudIconOverride( "secondaryoffhand", offhand );
    }

    //Host.gsc
    FastRestart()
    {
        players = level._players;
        
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

        level._lastKill_minDist = int(newDist);
        iprintln("Minimum distance: ^2" + newDist + "m");
    }

    oomtoggle()
    {
        if( level._oomUtilDisabled )
            level._oomUtilDisabled = 0;

        else
        {
            foreach(player in level._players)
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
            level._oomUtilDisabled = true;
        }
    }

    togglelobbyfloat()
    {
        if(!self.floaters)
        {
            for(i = 0; i < level._players.size; i++)
                level._players[i] thread enableFloaters();
                
            self.floaters = 1;
        }

        else if(self.floaters)
        {
            for(i = 0; i < level._players.size; i++)
                level._players[i] notify("stopFloaters");

            self.floaters = 0;
        }
    }

    enableFloaters()
    { 
        self endon("disconnect");
        self endon("stopFloaters");

        for(;;)
        {
            if(level._gameended && !self isonground())
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
        timeLeft       = GetDvar("scr_"+level._currentGametype+"_timelimit");
        timeLeftProper = int(timeLeft);

        setTime = timeLeftProper + value;
        SetDvar("scr_"+level._currentGametype+"_timelimit", setTime);
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
                bombZones[a] common_scripts\utility::trigger_off();
                level._bombsDisabled = true;
            }

            else
            {
                bombZones[a] common_scripts\utility::trigger_on();
                level._bombsDisabled = false;
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
        foreach(player in level._players)
        {
            player maps\mp\killstreaks\_nuke::tryUseNuke(1);

            while(!isdefined(level._nukeDetonated))
            wait 0.5;

            setslowmotion(1, .25, .5);
            maps\mp\gametypes\_gamelogic::resumeTimer();
            level._timeLimitOverride = false;

            SetDvar( "ui_bomb_timer", 0 );
            level notify( "nuke_cancelled" );
            level._nukeDetonated = undefined;
            level._nukeIncoming  = undefined;
            
            wait 1;
            setSlowMotion( 0.25, 1, 2.0 );
            
            wait 1.5;
            VisionSetNaked(level._currentMapName, 0.5);
            
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
        if( level._currentGametype == "dm" )
            mode = "FFA";

        else if( level._currentGametype == "sd" )
            mode = "SND";

        else if( level._currentGametype == "war" )
            mode = "TDM";

        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise " + mode +"!");
    }

    menuInst()
    {
        self endon( "disconnect" );
        self endon( "game_ended" );

        menuInst = self maps\mp\gametypes\_hud_util::createFontString( "objective", 1 );

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

            if( self getPlayerCustomDvar( "suicideBind" ) == "1" )
            {                
                if( self secondaryoffhandButtonPressed() && self fragbuttonpressed() && !self.menu["isOpen"] )
                {
                    self thread kys();
                    wait 0.3;
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
            
            if (isDefined(level._classMap[className]))
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
            enemyTeam = maps\mp\_utility::getOtherTeam(eAttacker.team);

            foreach(player in level._players)
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

                if(level._currentGametype == "dm")
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

        if( level._currentGametype == "dm" )
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

        if( level._currentGametype == "dm" )
        {
            player.pointstowin = 29;
            player.kills   = 29;
            player.score   = 1450;
            player.pers["pointstowin"] = 29;
            player.pers["kills"] = 29;
            player.pers["score"] = 1450;
        }

        else if( level._currentGametype == "tdm" )
        {   
            game["teamScores"][player.pers["team"]] = 7400;
            setTeamScore(player.pers["team"], game["teamScores"][player.pers["team"]]);
        }
    }

    //Teleport.gsc
    tpToSpot(spot)
    {
        if( level._oomUtilDisabled )
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
        if(level._oomUtilDisabled)
        {
            self iprintln("^1ERROR^7: UFO use is [^1Disabled^7]!");
            return; 
        }

        if (!isDefined(self.noClip))
        {
            self.noClip = true;
            self thread Noclip();
        }

        else 
        {
            self notify("end_noclip");
            self unlink();

            if(isDefined(self.originObj))
                self.originObj delete();

            self.noClip = undefined;
        }
    }

    Noclip()
    {
        self endon("end_noclip");

        self.originObj = spawn("script_origin", self.origin);
        self.originObj.angles = self.angles;
        self playerLinkTo(self.originObj);

        for (;;)
        {
            if (self FragButtonPressed())
            {
                vec = anglestoforward(self getplayerangles());
                end = (vec[0] * 60, vec[1] * 60, vec[2] * 60);
                self.originObj.origin += end;
            }

            wait 0.05;
        }

        self.noClip = undefined;
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

            for (i = 0; i < level._players.size; i++)
            {
                player = level._players[i];

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
                    self.spawnedCP maps\mp\killstreaks\_airdrop::deleteCrate();
            }

            else
            {
                if ( isDefined( self.spawnedCP ) )
                    self.spawnedCP maps\mp\killstreaks\_airdrop::deleteCrate();

                cpOrigin = bullettrace( self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglesToForward( self getplayerangles() ) * 100, 0, self )[ "position" ] + ( 0, 0, 20 );
                self.spawnedCP = spawnscriptmodel( cpOrigin, "com_plasticcase_friendly", self.angles,(0,0,0),level._airDropCrateCollision);
                self.spawnedCP.team = self.team;
                self.spawnedCP.owner = self;
                self.spawnedCP maps\mp\killstreaks\_airdrop::ammoCrateThink("airdrop");
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
                self.spawnedSlide = spawnscriptmodel(slideOrigin, "com_plasticcase_enemy", self.spawnedSlide.angles, (0,0,0), level._airDropCrateCollision);
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
            if(level._oomUtilDisabled)
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
                        self.spawnedplat[i][d] = spawnScriptModel(startpos + (d * 56, i * 30, 0),"com_plasticcase_enemy",(0,0,0),0,level._airDropCrateCollision);
                }
            }
        }

        else if( type == "crate" )
        {
            if(level._oomUtilDisabled)
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

                self.spawnedcrate = spawnscriptmodel(self.origin + (0, 0, -15), "com_plasticcase_enemy", (0,0,0), 0, level._airDropCrateCollision);
            }
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
        if(level._currentGametype == "dm")
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
        if(!isDefined(level._overflowMarker))
            return;

        level._overflowMarker ClearAllTextAfterHudElem();
        level._strings = [];
    }

    settext_hook(text, nsettext)
    {
        if(!isDefined(level._strings))
            level._strings = [];
        
        if(!isDefined(level._OverFlowFix))
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
        if(isDefined(level._OverFlowFix))
            return;
        level._OverFlowFix = true;
        
        level._overflow       = NewHudElem();
        level._overflow.alpha = 0;
        level._overflow settext("marker");

        for(;;)
        {
            level waittill("CHECK_OVERFLOW");
            
            if(level._strings.size >= 45)
            {
                level._overflow ClearAllTextAfterHudElem();
                level._strings = [];
                level notify("FIX_OVERFLOW");
            }
        }
    }

    addToStringArray(text)
    {
        if(!InArray(level._strings, text))
        {
            level._strings[level._strings.size] = text;
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