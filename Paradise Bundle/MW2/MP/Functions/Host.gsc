endGame()
{
    level thread maps\mp\gametypes\_gamelogic::forceEnd();
}

changeTime(input)
{
    timeLeft       = GetDvar("scr_"+level.gametype+"_timelimit");
    timeLeftProper = int(timeLeft);

    if(input == "add")
    {  
        setTime = timeLeftProper + 1;
        self iPrintln("^2Added 1 minute");
    }
    else if(input == "sub")
    {
        setTime = timeLeftProper - 1;
        self iPrintln("^1Removed 1 minute"); 
    }
    SetDvar("scr_"+level.gametype+"_timelimit",setTime);
    time = setTime - getMinutesPassed();

    wait .05;
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
    if(!self.floaters)
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
    else if(value == "endGame")
        endGame();
}