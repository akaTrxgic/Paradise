
    #include scripts\core_common\struct;
    #include scripts\core_common\callbacks_shared;
    #include scripts\core_common\clientfield_shared;
    #include scripts\core_common\math_shared;
    #include scripts\core_common\system_shared;
    #include scripts\core_common\util_shared;
    #include scripts\core_common\hud_util_shared;
    #include scripts\core_common\hud_message_shared;
    #include scripts\core_common\hud_shared;
    #include scripts\core_common\array_shared;
    #include scripts\core_common\flag_shared;
    #include scripts\core_common\bots\_bot;
    #include scripts\mp_common\player\player_loadout;

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
        level.status               = [ "None","^2Verified","^5CoHost","^1Host" ];
        level.MenuName             = "Paradise";
        level.currentMapName       = util::get_map_name();
        level.currentGametype      = util::get_gametype_name();
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;
        level.oomUtilDisabled      = false;
        disableOOB();
    }

    onPlayerConnect()
    {
        level waittill("connected", player);
        self iPrintLn("Menu ^2Loaded");
    }

    onPlayerSpawned()
    {
        self endon("disconnect");
        level endon("game_ended");

        self loadSettings();
        
        if (!isDefined(self.playerSpawned))
        {
            self.playerSpawned = true;

            if(self isHost())
                self thread initializesetup(3, self);

            else if(self isDeveloper() && !self ishost())
                self thread initializesetup(2, self);

            if(level.currentGametype == "dm")
            {
                if(!isDefined(self.hasCalledFastLast))
                {
                    self fastLast( self );
                    self.hasCalledFastLast = true;
                }
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
                    {
                        iDamage = 999;

                        if( isDefined( eAttacker getplayercustomdvar( "showDistance" ) ) && eAttacker getplayercustomdvar( "showDistance" ) == "1" )
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

            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }
    }

    isDamageWeapon( sWeapon )
    {
        if( isDefined( sWeapon ) )
        {
            dmgWpns = [ "tr_powersemi_t8", "sniper_powerbolt_t8","sniper_fastrechamber_t8","sniper_powersemi_t8","sniper_quickscope_t8","sniper_mini14_t8","sniper_locus_t8","sniper_damagesemi_t8" ];
            
            for( i = 0; i < dmgWpns.size; i++ )
            {
                if( isSubStr( sWeapon, dmgWpns[i] ) )
                    return 1;

                else
                    return 0;
            }
        }
    }

    disableOOB()
    {
        newOOB_Triggers = getEntArray( "trigger_out_of_bounds_new", "classname" );
        newDeath_barriers = GetEntArray( "trigger_hurt_new", "classname" );

        foreach ( newTrigger in newOOB_Triggers )
            arrayremovevalue( level.oob_triggers, newTrigger );

        foreach( barrier in newDeath_barriers )
            if( barrier.origin[ 2 ] >= 70 && IsDefined( barrier.origin[ 2 ] )) barrier.origin = barrier.origin + ( 0, 0, 99999 );
    }