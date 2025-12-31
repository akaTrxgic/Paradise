tpToSpot(coords)
{
    self setorigin(coords);
}

saveandload()
{
    if(!self.snl)
    {
        self iprintln( "To Save: Prone + [{+Attack}]");
        #ifdef WAW || MW1
        self iprintln( "To Load: Crouch + [{+frag}]" );
        #else
        self iprintln( "To Load: Crouch + [{+actionslot 2}]" );
        #endif
        self thread dosaveandload();
        self.snl = 1;
    }
    else
    {
        self.snl = 0;
        self notify( "SaveandLoad" );
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

dosaveandload()
{
    self endon( "disconnect" );
    self endon( "SaveandLoad" );

    while(self.pers["SavingandLoading"])
    {
        if( self.snl && self attackbuttonpressed()  && self GetStance() == "prone" )
        {
            self.a = self.angles;
            self.pers["savedLocation"] = self.origin;
            self iprintln( "Position ^2Saved" );
            wait 2;
        }
        #ifdef WAW || MW1
        if( self.snl && self fragbuttonpressed() && self GetStance() == "crouch")
        {
            self setplayerangles(self.a);
            self setOrigin(self.pers["savedLocation"]);
            wait 2;
        }
        #endif
        #ifdef MW2 || MW3 || MWR || Ghosts
        if( self.snl && self isbuttonpressed("+actionslot 2") && self GetStance() == "crouch")
        {
            self setplayerangles(self.a);
            self setOrigin(self.pers["savedLocation"]);
            wait 2;
        }
        #endif
        #ifdef BO1 || BO2
        if( self.snl && self actionslottwobuttonpressed() && self GetStance() == "crouch")
        {
            self setplayerangles(self.a);
            self setOrigin(self.pers["savedLocation"]);
            wait 2;
        }
        #endif
        wait 0.05;
    }
}