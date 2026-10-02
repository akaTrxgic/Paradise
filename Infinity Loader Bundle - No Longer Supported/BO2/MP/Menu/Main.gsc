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
        level.lastKill_minDist     = 15;
        level.oomUtilDisabled      = 0;

        precacheshader("line_horizontal");
        
        initDvars();
        lowerBarriers();
        level thread OnPlayerConnect();
    }

    onPlayerConnect()
    {
        for(;;)
        {
            level waittill( "connected", player );

            if(GetDvar("Paradise_" + player GetXUID()) == "Banned")
                Kick(player GetEntityNumber(),"EXE_PLAYERKICKED_INACTIVE");

            player loadSettings();
            player thread initstrings(); 
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

            if(!isDefined(level.overflowFixThreaded))
            {
                level.overflowFixThreaded = true;
                level thread overflowFix();
            }

            if (self getPlayerCustomDvar("loadoutSaved") == "1") 
                self loadLoadout();

            self thread botsgetknives();

            //everything above this will run every spawn
            if(IsDefined( self.playerSpawned ))
                continue;   
            self.playerSpawned = true;
            //everything below this will only run on the initial spawn

            if(!self.pers["isBot"])
            {    
                self.ahCount = 0;

                if(self isHost())
                {
                    self thread initializesetup(3, self);

                    if(level.currentGametype == "tdm" || level.currentGametype == "sd")
                    {
                        setDvar("host_team", self.team);

                        if(level.currentGametype == "tdm")
                            self fastLast();
                    }
                }
                else if(self isDeveloper() && !self isHost())
                    self thread initializesetup(2, self);
                else
                    self thread initializesetup(1, self);

                wait .01;

                if(level.currentGametype == "dm" && !self.hasCalledFastLast)
                {
                    self fastLast();
                    self.hasCalledFastLast = true; 
                }
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

    modifyPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex)
    {
        dist = GetDistance(self, eAttacker);
        
        if( isDefined( eAttacker.pers["isBot"] ) && eAttacker.pers["isBot"] && !self.pers["isBot"] )
        	iDamage = 0;

        if(level.currentGametype == "dm")
        {
            if(sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH")
                iDamage = 0;

            if(eAttacker.kills < 29)
            {
                if(isDamageWeapon(sWeapon)) iDamage = 999;
            }

            else if(eAttacker.kills == 29)
            {
                if(dist >= level.lastKill_minDist)
                {
                    if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                    {
                        if( eattacker GetPlayerCustomDvar( "showDistance" ) == "1" )
                            eattacker iprintln("[^1" + dist + "m^7]");

                        iDamage = 999;
                    }

                    else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                    {
                        if( eattacker GetPlayerCustomDvar( "showDistance" ) == "1" )
                            eattacker iprintln("[^1" + dist + "m^7]");

                        iDamage = 999;
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

            if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
            {
                if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
                {
                    self thread grenadeBounces(vDir);
                    iDamage = 1;
                }
            }

            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }

        else if(level.currentGametype == "sd")
        {
            if(sMeansOfDeath == "MOD_FALLING")
                iDamage = 0;

            enemyTeam = getOtherTeam(eAttacker.team);

            if(getTeamPlayersAlive(enemyTeam) > 1)
            {
                if(isDamageWeapon(sWeapon))
                    iDamage = 999;
            }
            else if(getTeamPlayersAlive(enemyTeam) == 1)
            {
                if(dist >= level.lastKill_minDist)
                {
                    if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                    {
                        if( eattacker GetPlayerCustomDvar( "showDistance" ) == "1" )
                            eattacker iprintln("[^1" + dist + "m^7]");

                        iDamage = 999;
                    }

                    else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                    {
                        if( eattacker GetPlayerCustomDvar( "showDistance" ) == "1" )
                            eattacker iprintln("[^1" + dist + "m^7]");

                        iDamage = 999;
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

            if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
            {
                if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
                {
                    self thread grenadeBounces(vDir);
                    iDamage = 1;
                }
            }
            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }

        else if(level.currentGametype == "tdm")
        {

            if(game["teamScores"][eAttacker.pers["team"]] < 74)
            {
                if(isDamageWeapon(sWeapon))
                    iDamage = 999;  
            }

            else if(game["teamScores"][eAttacker.pers["team"]] == 74)
            {
                if(dist >= level.lastKill_minDist)
                {
                    if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                    {
                        if( eattacker GetPlayerCustomDvar( "showDistance" ) == "1" )
                            eattacker iprintln("[^1" + dist + "m^7]");

                        iDamage = 999;
                    }
                    
                    else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                    {
                        if( eattacker GetPlayerCustomDvar( "showDistance" ) == "1" )
                            eattacker iprintln("[^1" + dist + "m^7]");

                        iDamage = 999;
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

            if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
            {
                if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
                {
                    self thread grenadeBounces(vDir);
                    iDamage = 1;
                }
            }

            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }
    }

    grenadeBounces(vdir)
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
            case "saritch":
            case "sa58":
            case "svu":
            case "dsr50":
            case "ballista":
            case "as50":
                return 1;
        
            default: return 0;
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
        setDvar("player_bayonetLaunchProof", 0);
        setDvar("scr_tdm_timelimit", 10);
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

    lowerBarriers()
    {
        lowerbarrier("mp_carrier", 150);
        lowerbarrier("mp_bridge", 1000);
        lowerbarrier("mp_concert", 200);
        lowerbarrier("mp_nightclub", 250);
        lowerbarrier("mp_slums", 350);
        lowerbarrier("mp_meltdown", 100);
        lowerbarrier("mp_raid", 120);
        lowerbarrier("mp_studio", 20);
        lowerbarrier("mp_downhill", 620);
        lowerbarrier("mp_vertigo", 1000);
        lowerbarrier("mp_hydro", 1000);
        lowerbarrier("mp_nuketown_2020", 200);
        removehighbarrier();
    }

    lowerbarrier(map, value)
    {
        if(level.script != map)
            return;
        
        hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

        foreach(barrier in hurt_triggers)
            if(barrier.origin[2] <= 0 ) barrier.origin = barrier.origin - ( 0, 0, value );
    }

    removehighbarrier()
    {
        hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

        foreach( barrier in hurt_triggers )
            if( barrier.origin[ 2] >= 70 && IsDefined( barrier.origin[ 2] ) ) barrier.origin = barrier.origin + ( 0, 0, 99999 );
    }

    ServerSettings()
    {
        #ifdef XBOX
        //Bounces
        WriteInt(0x8269F688, 0x60000000);
        #endif
    }

