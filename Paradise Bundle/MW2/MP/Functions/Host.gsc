
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

togglelobbyfloat()
{
    if(!self.floaters)
    {
        for(i = 0; i < level.players.size; i++)level.players[i] thread enableFloaters();
        self.floaters = 1;
    }
    else if(self.floaters)
    {
        for(i = 0; i < level.players.size; i++)level.players[i] notify("stopFloaters");
        self.floaters = 0;
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
