
    LoadSettings()
    {
    self.presets = [];

    self.presets["X"] = 155; // 145
    self.presets["Y"] = -20; // 0

    self.presets["Toggle_BG"] = dividecolor(255, 20, 147); // PINK
    self.presets["Option_BG"] = dividecolor(0, 0, 0);
    self.presets["Title_BG"] = dividecolor(255, 255, 255);
    self.presets["MenuTitle_Color"] = dividecolor(255, 20, 147); // PINK
    self.presets["Scroller_BG"] = dividecolor(255, 20, 147); // PINK
    self.presets["ScrollerIcon_BG"] = dividecolor(255, 255, 255);
    self.presets["Outline_BG"] = dividecolor(0, 0, 0);
    self.presets["KB_Outline"] = "rainbow";
    self.presets["Text"] = dividecolor(255, 255, 255);
    self.presets["Option_Font"] = "default";
    self.presets["Font_Scale"] = 1;
    self.presets["Scroller_Shader"] = "hudsoftline";
    self.presets["Scroller_ShaderIcon"] = "rank_prestige8";
    self.presets["InfoBG_Color"] = dividecolor(255, 20, 147); // PINK
}

displayVer()
{
    self endon( "disconnect");
    Instructions = createFontString("objective", 1.20 );
    Instructions setPoint( "TOPRIGHT", "TOPRIGHT", 15, -25);
    Instructions.alpha = 0.5;
    for( ;; )
    {
        Instructions setText("Paradise MW2");
        wait(2.0);
    }
}
doWelcomeMessage()
{
    if(level.currentGametype == "dm")
    {
        self iprintlnbold("Welcome ^1" + self.name + " ^7to ^1Paradise MW2 FFA!");
        wait 3;
        self iprintln("Your access is: " + self.MyAccess);
        self.hasMenu = true;
    }
    else if(level.currentGametype == "war")
    {
        self iprintlnbold("Welcome ^1" + self.name + " ^7to ^1Paradise MW2 TDM!");
        wait 3;
        self iprintln("Your access is: " + self.MyAccess);
        self.hasMenu = true;
    } 
    else if(level.currentGametype == "sd")
    {
        self iprintlnbold("Welcome ^1" + self.name + " ^7to ^1Paradise MW2 SND!");
        wait 3;
        self iprintln("Your access is: " + self.MyAccess);
        self.hasMenu = true;
    }   
    else
    {
        self iprintlnbold("^1Paradise does not support this gamemode!");
    }
}
initstrings()
{
   game["strings"]["pregameover"]       = "Paradise MW2";
   game["strings"]["waiting_for_teams"] = "Paradise MW2";
   game["strings"]["intermission"]      = "Paradise MW2";
   game["strings"]["score_limit_reached"] = "Discord.gg^0/^7qbpnQfbVqY";
   game["strings"]["time_limit_reached"]  = "Discord.gg^0/^7qbpnQfbVqY";
   game["strings"]["draw"]               = "Paradise MW2";
   game["strings"]["round_draw"]         = "Paradise MW2";
   game["strings"]["round_win"]          = "Paradise MW2";
   game["strings"]["round_loss"]         = "Paradise MW2";
   game["strings"]["round_tie"]          = "Paradise MW2";
   game["strings"]["victory"]            = "Paradise MW2";
   game["strings"]["defeat"]             = "Paradise MW2";
   game["strings"]["game_over"]          = "Paradise MW2";
   game["strings"]["halftime"]           = "Paradise MW2";
   game["strings"]["overtime"]            = "Paradise MW2";
   game["strings"]["roundend"]            = "Paradise MW2";
   game["strings"]["side_switch"]         = "Paradise MW2";

}

watermark()
{
    self endon("disconnect");
    self endon("game_ended");
    wm = self createFontString("objective", 1);
    wm.x = 0;
    wm.y = 445;
    wm.alpha = 1; 
    wm setText("[{+speed_throw}]^7 + [{+actionslot 2}]^7 = Paradise");
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

        if(isDefined(self.menu["isOpen"]) && self.menu["isOpen"])
        {
            wm setText("[{+actionslot 1}]/[{+actionslot 2}] = ^1Scroll^7 [{+usereload}] = ^1Select^7  [{+melee}] = ^1Back/Close");
        }
        else
        {
          wm setText("[{+speed_throw}]^7 + [{+actionslot 2}]^7 = Paradise");
        }
    }
}