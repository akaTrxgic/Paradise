    #include scripts\codescripts\struct;
    #include scripts\shared\callbacks_shared;
    #include scripts\shared\clientfield_shared;
    #include scripts\shared\math_shared;
    #include scripts\shared\system_shared;
    #include scripts\shared\util_shared;
    #include scripts\shared\hud_util_shared;
    #include scripts\shared\hud_message_shared;
    #include scripts\shared\hud_shared;
    #include scripts\shared\array_shared;
    #include scripts\shared\flag_shared;
    #include scripts\shared\bots\_bot;
    #include scripts\mp\gametypes\_loadout;
    #include scripts\mp\killstreaks\_killstreaks;
    #include scripts\mp\gametypes\_globallogic_score;

    #namespace Paradise;

    init()
    {
        system::register("Paradise", ::__init__, undefined, undefined);
    }

    __init__()
    {
        callback::on_start_gametype(::onStartGametype);
        callback::on_connect(::onPlayerConnect);
        callback::on_spawned(::onPlayerSpawned);
    }

    onStartGametype()
    {
        level.strings              = [];
        level.status               = ["None","^2Verified","^5CoHost","^1Host"];
        level.MenuName             = "Paradise";
        level.currentMapName       = GetDvarString("mapName");
        level.currentGametype      = GetDvarString("g_gametype");
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;
        level.lastKill_minDist     = 15;
        level.oomUtilDisabled      = 0;
        level.BotNameIndex = 0;
        
        setDvar("host_team", self.team);
        setDvar( "bot_AllowKillstreaks", 0 );
        setdvar( "bot_AllowHeroGadgets", 0 );
        precachemodel("wpn_t7_care_package_world");
        disableOOB();
    }

    onPlayerConnect()
    {
        level waittill( "connected", player );
        self iprintln("^2Menu Loaded");
    }

    onPlayerSpawned()
    {
        self endon("disconnect");
        level endon("game_ended");

        self loadSettings();
        self thread botsgetknives();

        if( !isDefined( self.playerSpawned ) )
        {
            self.playerSpawned = true;

            if( !self.pers["isBot"] )
            {
                if(self isHost())
                    self thread initializesetup(3, self);

                else if(self isDeveloper() && !self ishost())
                    self thread initializesetup(2, self);

                else
                    self thread initializesetup(1, self);

                if(level.currentGametype == "dm")
                {
                    if(!self.hasCalledFastLast)
                    {
                        self fastLast( self );
                        self.hasCalledFastLast = true;
                    }
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

        if( isDefined( eAttacker.pers["isBot"] ) && eAttacker.pers["isBot"] && !self.pers["isBot"])
        	iDamage = 0;

        if(level.currentGametype == "dm")
        {
            if(sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH")
                iDamage = 0;

            if(eAttacker.kills == 29)
            {
                if(dist >= level.lastKill_minDist)
                {
                    if( getweapon( isDamageWeapon( sWeapon )) && !eAttacker isOnGround())
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

        switch(sWeapon)
        {
            case "sniper_chargeshot":
            case "sniper_double":
            case "sniper_fastbolt":
            case "sniper_fastsemi":
            case "sniper_mosin":
            case "sniper_powerbolt":
            case "sniper_quickscope":
            case "sniper_xpr50":
                return 1;

            default: return 0;
        }
    }

    disableOOB()
    {
        oob_Triggers = getentarray( "trigger_out_of_bounds", "classname" );
        hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

        foreach ( trigger in oob_Triggers )
            arrayremovevalue( level.oob_triggers, trigger );

        foreach( barrier in hurt_triggers )
            if( barrier.origin[ 2 ] >= 70 && IsDefined( barrier.origin[ 2 ] )) barrier.origin = barrier.origin + ( 0, 0, 99999 );
    }