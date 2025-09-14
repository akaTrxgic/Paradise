
editTime(type)
{
    if(type == "add")
    {
        setgametypesetting( "timelimit", getgametypesetting( "timelimit" ) + 1);
        self iPrintln("^2Added 1 Minute");
    }
    else if(type == "subtract")
    {
        setgametypesetting( "timelimit", getgametypesetting( "timelimit" ) - 1);
        self iPrintln("^1Subtracted 1 Minute");
    }
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
