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
        level.lastKill_minDist     = 15;
        level.oomUtilDisabled      = 0;
        level.BotNameIndex = 0;

        precacheshader("ui_arrow_right");
        precacheshader("line_horizontal");
        precachemodel("com_plasticcase_green_big");

        initDvars();
        level thread onPlayerConnect();
    }

    onPlayerConnect()
    {
        for(;;)
        {
            level waittill( "connected", player );

            if(GetDvar("Paradise_" + player GetXUID()) == "Banned")
                Kick(player GetEntityNumber(),"EXE_PLAYERKICKED_INACTIVE");

            player loadsettings();
            player thread MonitorButtons();
            player thread overflowInit();
            player thread OnPlayerSpawned();
        }
    }

    onPlayerSpawned()
    {
        self endon( "disconnect" );

        for(;;)
        {
            self waittill( "spawned_player" );

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

                    if(level.currentGametype == "sd")
                        setDvar("host_team", self.team);
                }
                else if(self isDeveloper() && !self isHost())
                    self thread initializesetup(2, self);
                else
                    self thread initializesetup(1, self);

                wait .01;

                if(level.currentGametype == "dm" && !self.hasCalledFastLast)
                {
                    self FastLast();
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

        if(isDamageWeapon(sWeapon)) iDamage = 999;

        if( isDefined( eAttacker.pers["isBot"] ) && eAttacker.pers["isBot"] && !self.pers["isBot"] || !eAttacker.pers["isBot"] && !self.pers["isBot"] )
        	iDamage = 0;

        if(level.currentGametype == "dm")
        {
            if(sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH")
                iDamage = 0;

            if(eAttacker.kills == 24)
            {
                if(dist >= level.lastKill_minDist)
                {
                    if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                        iprintln("[^1" + dist + "m^7]");
                    
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

            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }
    }

    isdamageweapon(sweapon)
    {
        if(!IsDefined(sweapon))
            return 0;

        sub = strTok(sWeapon,"_");

        switch(sub[1])
        {
            case "m40a3":
            case "m21":
            case "dragunov":
            case "remington700":
            case "barrett":
            case "febsnp":
            case "junsnp":
            case "g3":
            case "m14":
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
        SetDvar("bg_compassShowEnemies", 1);
    }

    hook maps\mp\_events::firstbloodevent( var_0, var_1, var_2 )
    {
        return;
    }