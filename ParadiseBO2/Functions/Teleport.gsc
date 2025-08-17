tpToSpot(coords)
{
    self setorigin(coords);
}

spawn_set()
{
    self.spawn_origin = self.origin + (0, 0, 1);
    self.spawn_angles = self.angles;
    self iprintln( "Spawn: ^2Set" );
}
unsetSpawn()
{
    self.spawn_origin = undefined;
    self.spawn_angles = undefined;
    self iprintln( "Spawn: ^1Reset" );
}
saveandload()
{
    if( self.snl == 0 )
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

dosaveandload()
{
    self endon( "disconnect" );
    self endon( "SaveandLoad" );

    while(self.pers["SavingandLoading"] == true)
    {
        if( self.snl == 1 && self attackbuttonpressed()  && self GetStance() == "prone" )
        {
            self.o = self.origin;
            self.a = self.angles;
            self.pers["location"] = self.origin;
            self.pers["savedLocation"] = self.origin;
            self iprintln( "Position ^2Saved" );
            wait 2;
        }
        if( self.snl == 1 && self actionslottwobuttonpressed() && self GetStance() == "crouch")
        {
            self setplayerangles(self.a);
            self setOrigin(self.pers["savedLocation"]);
            wait 2;
        }
        wait 0.05;
    }
}
waitframe()
{
    wait 0.05;
}
