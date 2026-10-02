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
        level.streaks = ["uav", "deployable_vest", "airdrop_assault", "counter_uav", "sentry", "predator_missile", "ac130", "emp"];

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

    onPlayerSpawned()
    {
        self endon( "disconnect" );

        for(;;)
        {
            self waittill( "spawned_player" );

            self loadCustomDvars();

            if( level.currentGametype == "sd" )
                self givePerk("specialty_falldamage", false);

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

    loadCustomDvars()
    {
        if( self getPlayerCustomDvar( "loadoutSaved" ) == "1" ) 
            self loadLoadout();

        if( !isDefined( self GetPlayerCustomDvar( "menuInst" ) ) )
            self SetPlayerCustomDvar( "menuInst", "1" );

        if( self getPlayerCustomDvar( "SOH" ) == "1" )
        {
            self givePerk( "specialty_quickdraw", false );
            self givePerk( "specialty_fastoffhand", false );
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
            timePassed = getTimePassed() / 1000;
            timeLimit  = getTimeLimit() * 60;

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
        #ifdef XBOX
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
        #endif
    }

    hook maps\mp\_events::firstBlood( killId, weapon, meansOfDeath )
    {
        return;
    }