    tpToSpot(coords)
    {
        if( level.oomUtilDisabled )
        {
            self iprintln("^1ERROR^7: Teleporting is [^1Disabled^7]!");
            return;
        }

        else
            self setorigin(coords);
    }

    saveandload()
    {
        if( isDefined( self.snl ) )
        {
            self.snl = undefined;
            self notify( "stop_snl" );
        }

        else
        {
            self iprintln( "To Save: Prone + [{+Attack}]");
            self iprintln( "To Load: Crouch + [{+frag}]" );
            self thread dosaveandload();
            self.snl = true;
        }
    }

    dosaveandload()
    {
        self endon( "disconnect" );
        self endon( "stop_snl" );

        while(self.pers["SavingandLoading"])
        {
            if( self.snl && self attackbuttonpressed()  && self GetStance() == "prone" )
            {
                self.a = self.angles;
                self.pers["savedLocation"] = self.origin;
                self iprintln( "Position ^2Saved" );
                wait 2;
            }

            if( self.snl && self fragbuttonpressed() && self GetStance() == "crouch")
            {
                self setplayerangles(self.a);
                self setOrigin(self.pers["savedLocation"]);
                wait 2;
            }
            wait 0.05;
        }
    }

    setSpawn()
    {
        if(!self.savedPos|| self.savedPos)
        {
            self.spawnCoords = self getOrigin(self.origin) + (0, 0, 1);
            self.spawnAngles = self.angles;
            self.savedPos = 1;
            self iprintln("Spawn: ^2Set");

            while(self.savedPos)
            {
                self waittill( "spawned_player" );
                wait .1;
                self setorigin(self.spawnCoords);
                self.angles = self.spawnAngles;
            }
        }
    }

    unsetSpawn()
    {
        if(self.savedPos)
        {
            self.spawnCoords = undefined;
            self.spawnAngles = undefined;
            self.savedPos = 0;
            self iprintln("Spawn: ^1Reset");
        }
    }