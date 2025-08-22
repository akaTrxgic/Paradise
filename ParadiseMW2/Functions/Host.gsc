debugexit()
{
   wait 0.4;
    exitlevel( 1 );
    wait 0.1;
}

reverseladders()
{
    if ( getdvar( "jump_ladderPushVel" ) == "128" )
    {
        setDvar("jump_ladderPushVel", 500);
        self iPrintln("Reverse Ladder Bounces: [^2ON^7]");
    }
    else
    {
        setDvar("jump_ladderPushVel", 128);
        self iPrintln("Reverse Ladder Bounces: [^1OFF^7]");
    }
}

editTime(input)
{
    timeLeft       = GetDvar("scr_"+level.gametype+"_timelimit");
    timeLeftProper = int(timeLeft);
    if(input == "add")
        setTime = timeLeftProper + 1;
    if(input == "subtract")
        setTime = timeLeftProper - 1;
    SetDvar("scr_"+level.gametype+"_timelimit",setTime);
    time = setTime - getMinutesPassed();
    wait .05;
    
    if(input == "add")
        self iPrintln("^2Added 1 minute");
    else
        self iPrintln("^1Removed 1 minute");
}

FastRestart()
{
    for(i = 0; i < level.players.size; i++)
    {
        if (isDefined( level.players[i].pers["isBot"])) 
        {
            kick ( level.players[i] getEntityNumber() );
        }
    }
    wait 1;
    map_restart( 0 );
}

togglelobbyfloat()
{
    if(self.floaters == false)
    {
        for(i = 0; i < level.players.size; i++)level.players[i] thread enableFloaters();
        self iprintln("Floaters [^2ON^7]");
        self.floaters = true;
    }
    else
    {
        for(i = 0; i < level.players.size; i++)level.players[i] notify("stopFloaters");
        self iprintln("Floaters [^1OFF^7]");
        self.floaters = false;
    }
}

enableFloaters()
{ 
    self endon("disconnect");
    self endon("stopFloaters");

    for(;;)
    {
        if(level.gameended && !self isonground())
        {
            floatersareback = spawn("script_model", self.origin);
            self playerlinkto(floatersareback);
            self freezecontrols(true);
            for(;;)
            {
                floatermovingdown = self.origin - (0,0,0.5);
                floatersareback moveTo(floatermovingdown, 0.01);
                wait 0.01;
            } 
            wait 6;
            floatersareback delete();
        }
        wait 0.05;
    }
}
doHostAction(value)
{
    if(value == "FastRestart")
        FastRestart();
    else if(value == "debugexit")
        debugexit();
}