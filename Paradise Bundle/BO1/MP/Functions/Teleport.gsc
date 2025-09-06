tpToSpot(coords)
{
    self setorigin(coords);
}

saveandload()
{
    if(!self.snl)
    {
        self iprintln( "To Save: Prone + [{+Attack}]");
        self iprintln( "To Load: Crouch + [{+Actionslot 2}]" );
        self thread dosaveandload();
        self.snl = 1;
    }
    else
    {
        self iprintln( "Save and Load [^1OFF^7]" );
        self.snl = 0;
        self notify( "SaveandLoad" );
    }
}

setSpawn()
{
    if(!self.savedPos || self.savedPos)
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


dosaveandload()
{
    self endon( "disconnect" );
    self endon( "SaveandLoad" );

    while(self.pers["SavingandLoading"])
    {
        if( self.snl && self attackbuttonpressed()  && self GetStance() == "prone" )
        {
            self.o = self.origin;
            self.a = self.angles;
            self.pers["location"] = self.origin;
            self.pers["savedLocation"] = self.origin;
            self iprintln( "Position ^2Saved" );
            wait 2;
        }
        if( self.snl && self actionslottwobuttonpressed() && self GetStance() == "crouch")
        {
            self setplayerangles(self.a);
            self setOrigin(self.pers["savedLocation"]);
            wait 2;
        }
        wait 0.05;
    }
}

