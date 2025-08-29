
    LoadSettings()
    {
        self.presets = [];

        self.presets["X"] = 155; // 145
        self.presets["Y"] = -20; // 0

        self.presets["Toggle_BG"] = dividecolor(26, 148, 49);
        self.presets["Option_BG"] = dividecolor(0, 0, 0);
        self.presets["Title_BG"] = dividecolor(255, 255, 255);
        self.presets["MenuTitle_Color"] = dividecolor(26, 148, 49);
        self.presets["Scroller_BG"] = dividecolor(26, 148, 49); 
        self.presets["ScrollerIcon_BG"] = dividecolor(255, 255, 255);
        self.presets["Outline_BG"] = dividecolor(0, 0, 0);
        self.presets["KB_Outline"] = "rainbow";
        self.presets["Text"] = dividecolor(255, 255, 255);
        self.presets["Option_Font"] = "default";
        self.presets["Font_Scale"] = 1;
        self.presets["Scroller_Shader"] = "white";
        self.presets["Scroller_ShaderIcon"] = "rank_prestige09";
    }

displayVer()
{
    self endon( "disconnect");
    Instructions = createFontString("objective", 1.20 );
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
    else if(level.currentGametype == "tdm")
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
    wm = self createFontString("hudsmall", 1);
    wm.x = -340;
    wm.y = 430;
    wm.alpha = 1; 
    wm setText("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
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
            wm setText("[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select  [{+melee}] = Back/Close");
        }
        else
        {
            wm setText("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
        }
    }
}