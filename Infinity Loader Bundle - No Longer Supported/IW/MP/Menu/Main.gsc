    #include maps\mp\_utility;
    #include common_scripts\utility;
    #include scripts\mp\utility;
    #include scripts\mp\_hud_util;
    #include scripts\mp\bot\_bots;
    #include scripts\mp\bots\_bots_util;

    init()
    {
        level.strings              = [];
        level.status               = ["None","^2Verified","^5CoHost","^1Host"];
        level.MenuName             = "Paradise";
        level.currentMapName       = getDvar("mapname");
        level.currentGametype      = getDvar("g_gametype");
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;
        level.airDropCrates         = GetEntArray("care_package","targetname");
        level.airdropcratecollision = GetEnt(level.airDropCrates[0].target,"targetname");
        level.lastKill_minDist     = 15;
        level.oomUtilDisabled      = 0;
        level.BotNameIndex = 0;

        disableoob();
        initDvars();
        level thread OnPlayerConnect();
    }

    onPlayerConnect()
    {
        for(;;)
        {
            level waittill( "connected", player );

            if(GetDvar("Paradise_" + player GetXUID()) == "Banned")
                Kick(player GetEntityNumber(),"EXE_PLAYERKICKED_INACTIVE");

            player thread MonitorButtons();
            player thread overflowInit();
            player loadSettings();
            player thread OnPlayerSpawned();
        }
    }

    onPlayerSpawned()
    {
        self endon( "disconnect" );

        for(;;)
        {
            self waittill( "spawned_player" );

            if( isDefined( self.savedPos ) && self.savedPos )
            {
                wait .1;
                self setorigin(self.spawnCoords);
                self.angles = self.spawnAngles;
            }

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

        if(isDamageWeapon(sWeapon)) iDamage = 999;

        if( isDefined( eAttacker.pers["isBot"] ) && eAttacker.pers["isBot"] && !self.pers["isBot"] || !eAttacker.pers["isBot"] && !self.pers["isBot"] )
        	iDamage = 0;

        if(level.currentGametype == "dm")
        {
            if(sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH")
                iDamage = 0;

            if(eAttacker.kills == 29)
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
            case "kbs":
            case "cheytac":
            case "m8":
            case "m1":
            case "ba50cal":
            case "longshot":
                return 1;
        
            default: return 0;
        }
    }

    initDvars()
    {
        setDvar("host_team", self.team);
    }

    disableOOB()
    {
        oob_Triggers = GetEntArray( "OutOfBounds", "targetname" );
        hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

        foreach( trigger in oob_Triggers )
            if( isDefined( trigger ))
                trigger delete();

        foreach( barrier in hurt_triggers )
            if( barrier.origin[ 2 ] >= 70 && IsDefined( barrier.origin[ 2 ] )) barrier.origin = barrier.origin + ( 0, 0, 99999 );
    }