    AfterHit(gun)
    {
        self endon("afterhit");
        self endon( "disconnect" );

        if(!isDefined(self.AfterHit))
        {
            self iprintln("Afterhit Weapon set: [^2" + gun + "^7]");
            self thread doAfterHit(gun);
            self.AfterHit = true;
        }
        else
        {
            self iprintln("Afterhits [^1OFF^7]");
            self.AfterHit = undefined;
            KeepWeapon = "";
            self notify("afterhit");
        }
    }

    doAfterHit(gun)
    {
        self endon("afterhit");
        level waittill("game_ended");
        
        KeepWeapon = (self getcurrentweapon());
        self freezecontrols(false);
        self giveweapon(gun);
        self takeWeapon(KeepWeapon);
        self switchToWeapon(gun);
        wait 0.02;
        self freezecontrols(true);
    }

    doKillstreak(name)
    {
        self thread maps\mp\killstreaks\_killstreaks::giveKillstreak( name, false, false, self );
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
            VisionSetNaked(GetDvar("mapname"), 0.5);
            
            wait .1;
            break;
        }
    }