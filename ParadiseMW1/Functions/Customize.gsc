 displayVer()
{
    self endon( "disconnect");
    Instructions = createFontString("hudsmall", 1.20 );
    Instructions setPoint( "TOPRIGHT", "TOPRIGHT", 15, -25);
    Instructions.alpha = 0.5;
    for( ;; )
    {
        Instructions setText("Paradise");
        wait(2.0);
    }
}
initstrings()
{
   game["strings"]["pregameover"]       = "Paradise";
   game["strings"]["waiting_for_teams"] = "Paradise";
   game["strings"]["intermission"]      = "Paradise";
   game["strings"]["score_limit_reached"] = "Discord.gg^0/^7qbpnQfbVqY";
   game["strings"]["time_limit_reached"]  = "Discord.gg^0/^7qbpnQfbVqY";
   game["strings"]["draw"]               = "Paradise";
   game["strings"]["round_draw"]         = "Paradise";
   game["strings"]["round_win"]          = "Paradise";
   game["strings"]["round_loss"]         = "Paradise";
   game["strings"]["round_tie"]          = "Paradise";
   game["strings"]["victory"]            = "Paradise";
   game["strings"]["defeat"]             = "Paradise";
   game["strings"]["game_over"]          = "Paradise";
   game["strings"]["halftime"]           = "Paradise";
   game["strings"]["overtime"]            = "Paradise";
   game["strings"]["roundend"]            = "Paradise";
   game["strings"]["side_switch"]         = "Paradise";
}
doWelcomeMessage()
{
    if(level.currentGametype == "dm")
    {
        self iprintlnbold("Welcome ^1" + self.name + " ^7to ^1Paradise FFA!");
        self.hasMenu = true;
    }
    else if(level.currentGametype == "war")
    {
        self iprintlnbold("Welcome ^1" + self.name + " ^7to ^1Paradise TDM!");
        self.hasMenu = true;
    } 
    else if(level.currentGametype == "sd")
    {
        self iprintlnbold("Welcome ^1" + self.name + " ^7to ^1Paradise SND!");
        self.hasMenu = true;
    }   
    else
    {
        self iprintlnbold("^1Paradise does not support this gamemode!");
    }
}
watermark()
{
    self endon("disconnect");
    self endon("game_ended");

    wm = self createFontString("objective", 0.2); 
    wm setPoint("BOTTOMLEFT", "BOTTOMLEFT", 10, 20);
    wm.alpha = 1; 
    wm.label = "wm"; // store for debugging
    wm setText("[{+speed_throw}] + [{+melee}] = Paradise");

    self thread monitorMenuState(wm);

    return wm;
}

monitorMenuState(wm)
{
    self endon("disconnect");
    self endon("game_ended");

    for(;;)
    {
        wait 0.05;

        if(self.IsMenuOpen)
        {
            // shorter line = guaranteed render
            wm setText("[{+attack}]/[{+speed_throw}] = Scroll  [{+usereload}] = Select  [{+melee}] = Back");
        }
        else
        {
            wm setText("[{+speed_throw}] + [{+melee}] = Paradise");
        }
    }
}



