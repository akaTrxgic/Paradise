    #include common_scripts\utility;
    #include maps\mp\_utility;
    #include maps\mp\gametypes\_hud_util;

    init()
    {
        level.strings  = [];
        level.status = [ "None","^2Verified","^3VIP","^5CoHost","^1Host" ];
		level.MenuName = "Paradise MW2";
        precacheshader("hudsoftline");
        precacheshader("rank_prestige11");

        level thread onPlayerConnect();
    }

    onPlayerConnect()
    {
        for(;;)
        {
            level waittill( "connected", player );

            player thread monitorbuttons();
            player thread onPlayerSpawned();
        }
    }

    onPlayerSpawned()
    {
        self endon( "disconnect" );

        for(;;)
        {
            self waittill( "spawned_player" );

            self FreezeControls(false);
            self thread overflowfix();

            if(self IsHost() || self isdeveloper())
            {
                if(self isdeveloper() && !self isHost())
                    self thread initializeSetup(3, self);
                else
                {
                    self thread initializeSetup(4, self);
                }
            }

            if(IsDefined( self.playerSpawned ))
                continue;   
            self.playerSpawned = true;
        }
    }

    overflowfix()
    {
        level.overflow = newHudElem();
        level.overflow.alpha = 0;
        level.overflow setText( "marker" );

        for(;;)
        {
            level waittill( "CHECK_OVERFLOW" );
            if(level.strings.size >= 45)
            {
                level.overflow ClearAllTextAfterHudElem();
                level.strings = [];
                level notify( "FIX_OVERFLOW" );
            }
        }
    }

    test()
    {
        self iprintln("^1Paradise Test");
    }

    toggletest()
    {
        if(self.paradise == 0)
        {
            self.paradise = 1;
            self iprintln("^2Paradise Test");
        }
        else
        {
            self.paradise = 0;
        }
    }