    #include maps\mp\_utility;
    #include common_scripts\utility;
    #include maps\mp\gametypes\_hud_util;
    #include maps\mp\gametypes\_hud_message;
    #include maps\mp\killstreaks\_killstreaks;

    init()
    {
        level.strings              = [];
        level.status               = ["None","^2Verified","^5CoHost","^1Host"];
        level.MenuName             = "Paradise";
        level.currentMapName       = getDvar("mapname");
        level.currentGametype      = getDvar("g_gametype");
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;
        level.streaks = ["uav", "airdrop", "counter_uav", "airdrop_sentry_minigun", "predator_missile", "precision_airstrike", "harrier_airstrike", "helicopter", "airdrop_mega", "helicopter_flares", "stealth_airstrike", "helicopter_minigun", "ac130", "emp"];

        if( !level.rankedMatch )
        {
            level.lastKill_minDist     = 15;
            level.oomUtilDisabled      = 0;
            level.BotNameIndex = 0;
            level.airDropCrates         = GetEntArray("care_package","targetname");
            level.airDropCrateCollision = GetEnt(level.airDropCrates[0].target,"targetname");
            PMColor();
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

            player thread MonitorButtons();
            player thread ServerSettings();
            player thread kcAntiQuit();
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

        if( isDefined( eAttacker.pers["isBot"] ) && eAttacker.pers["isBot"] && !self.pers["isBot"] || !eAttacker.pers["isBot"] && !self.pers["isBot"] )
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

                        else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand") )
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
                enemyTeam = getOtherTeam(eAttacker.team);
    
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

        switch(sub[0])
        {
            case "fal":
            case "cheytac":
            case "barrett":
            case "wa2000":
            case "m21":
                return 1;
        
            default: return 0;
        }
    }

    PMColor()
    {
        if(!isConsole())
            return;
        WriteString( 0xA50D9218, "^0Project Paradise" );
        setRGB(0xA50D90AC, 1.0, 0.4, 0.8); // Private Match Text - pink
        setRGB(0xA50D9294, 0.9, 0.3, 0.9); // Recommend Players Colour - pinkish purple
        setRGB(0xA50D9920, 0.8, 0.2, 0.9); // Map Name Colour - soft pink-purple
        setRGB(0xA50DA9E4, 0.7, 0.1, 0.95); // Line 1 - pink-purple
        setRGB(0xA50DBB78, 0.6, 0.0, 1.0); // Line 2 - violet
        setRGB(0xA50DEDA8, 0.45, 0.1, 1.0); // Rank Colour - blue-purple
        setRGB(0xA50DF0CC, 0.3, 0.2, 1.0);  // Score Colour - blue
        setRGB(0xA50D878C, 0.2, 0.3, 1.0);  // PM Cloud Colour 1 - blue
        setRGB(0xA50D8964, 0.4, 0.4, 1.0);  // PM Cloud Colour 2 - bluish
        setRGB(0xA50D85C0, 0.6, 0.5, 1.0);  // PM Cloud Colour 3 - blue-pink blend
        setRGB(0xA50D8B34, 0.8, 0.6, 1.0);  // Mock Up Glow 1 - light purple
        setRGB(0xA50D8D0C, 0.9, 0.7, 1.0);  // Mock Up Glow 2 - soft pink-purple
        setRGB(0xA50D8EDC, 1.0, 0.8, 1.0);  // Left Side Colour - pale pink
        // setRGB(0xA50D9754, 1.0, 0.7, 1.0); // Map Background - magenta (uncomment for full gradient)
        setRGB(0xA50DC314, 0.9, 0.4, 1.0);  // Change Map Text - magenta end
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

    ServerSettings()
    {
        #ifdef XBOX 
        //Bounces
        WriteShort(0x820D216C, 0x4800);     //Force Bounce(PM_ProjectVelocity)
        WriteInt(0x820DABE4, 0x48000018);   //Bounces(PM_StepSlideMove)

        //Elevators
        WriteShort(0x820D8360, 0x4800);   //Elevators(PM_CorrectAllSolid)
        WriteInt(0x820D8310, 0x60000000); //PM_CorrectAllSolid(For Easy Elevators)

        //PM_CheckDuck(For Easy Elevators)
        addresses = [0x820D4E74, 0x820D4F34, 0x820D5020];
        for(a = 0; a < addresses.size; a++)
        WriteInt(addresses[a], 0x60000000);

        //BulletPenetration
        WriteFloat(0x82008898, 9999999.0);
        WriteInt(0x820E217C, 0x60000000); //BG_GetSurfacePenetrationDepth(bne(branch if not equal) call to loc_820E218C)
        WriteInt(0x820E2184, 0xC02B8898); //BG_GetSurfacePenetrationDepth(lfs(load floating point single) from __real_00000000)

        //Range
        WriteInt(0x821CF3E4, 0xC3EB8898); //Bullet_Fire(lfs(load floating point single) from aF_0)
        WriteShort(0x821CF3C4, 0x4800);   //Bullet_Fire(beq(branch if equal) to loc_821CF3DC) -- Force branch to loc_821CF3DC(Allow all weapons to have max bullet range)
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

    hook maps\mp\_events::firstBlood( killId )
    {
        return;
    }