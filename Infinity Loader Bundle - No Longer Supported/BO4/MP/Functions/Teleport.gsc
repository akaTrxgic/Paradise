    savePos()
    {
        if( isDefined( self.posSaved ) )
        {
            self.savedAngles   = undefined;
            self.savedLocation = undefined;
            self.posSaved      = undefined;

            self iprintln( "Saved Position ^1Deleted" );
        }
        else
        {
            self.savedAngles   = self getPlayerAngles();
            self.savedLocation = self getOrigin();
            self.posSaved      = true;

            self iprintln( "Position ^2Saved" );
        }
    }

    loadPos()
    {
        if( isDefined( self.savedLocation ) && isDefined( self.savedAngles ) )
        {
            self setOrigin( self.savedLocation );
            waittillframeend;
            self setPlayerAngles( self.savedAngles );
        }
        else
            self iprintln( "Save a position first!" );
    }

    setSpawn()
    {
        if( !isDefined( self.savedPos ) )
        {
            self.spawnCoords = self getOrigin(self.origin) + (0, 0, 1);
            self.spawnAngles = self.angles;
            self.savedPos = true;
            self iprintln( "Spawn: ^2Set" );
            self thread spawnThread();
        }
    }

    spawnThread()
    {
        self endon( "disconnect" );
        self endon( "unsetSpawn" );

        while( isDefined( self.savedPos ) )
        {
            self waittill( #"spawned_player" );

            wait 0.1;

            if( isDefined( self.spawnCoords ) )
            {
                self setOrigin( self.spawnCoords );
                self setPlayerAngles( self.spawnAngles );
            }
        }
    }

    unsetSpawn()
    {
        if( !isDefined( self.savedPos ) )
        return;

        self notify("unsetSpawn");

        self.spawnCoords = undefined;
        self.spawnAngles = undefined;
        self.savedPos    = undefined;

        self iprintln("Spawn: ^1Reset");
    }