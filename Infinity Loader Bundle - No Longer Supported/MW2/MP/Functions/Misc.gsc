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