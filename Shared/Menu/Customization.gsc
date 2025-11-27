LoadSettings()
{
    self.presets = [];

    self.presets["X"] = 155; // 145
    self.presets["Y"] = -20; // 0

    self.presets["Option_BG"] = dividecolor(0, 0, 0);
    self.presets["Title_BG"] = dividecolor(255, 255, 255); 
    self.presets["ScrollerIcon_BG"] = dividecolor(255, 255, 255);
    self.presets["Outline_BG"] = dividecolor(0, 0, 0);
    self.presets["KB_Outline"] = "rainbow";
    self.presets["Text"] = dividecolor(255, 255, 255);
    self.presets["Option_Font"] = "default";
    
#ifndef MW1
    self.presets["Font_Scale"] = 1;
#else
    self.presets["Font_Scale"] = 1.4;
#endif

#ifdef WAW
	self.presets["Toggle_BG"] = dividecolor(230, 150, 80); 
    self.presets["MenuTitle_Color"] = dividecolor(230, 150, 80); 
    self.presets["Scroller_BG"] = dividecolor(230, 150, 80); 
    self.presets["Scroller_Shader"] = "hudsoftline";
    self.presets["Scroller_ShaderIcon"] = "rank_prestige9";
#endif
#ifdef BO1
    self.presets["Toggle_BG"] = dividecolor(45, 114, 178);
    self.presets["MenuTitle_Color"] = dividecolor(45, 114, 178);
    self.presets["Scroller_BG"] = dividecolor(45, 114, 178); 
    self.presets["Scroller_Shader"] = "hudsoftline";
    self.presets["Scroller_ShaderIcon"] = "rank_prestige15";
#endif
#ifdef BO2
    self.presets["Toggle_BG"] = dividecolor(26, 148, 49);
    self.presets["MenuTitle_Color"] = dividecolor(26, 148, 49);
    self.presets["Scroller_BG"] = dividecolor(26, 148, 49);
    self.presets["Scroller_Shader"] = "line_horizontal";
    self.presets["Scroller_ShaderIcon"] = "rank_prestige09";
#endif
#ifdef MW1 || MWR
    self.presets["Toggle_BG"] = dividecolor(148,75,151);
    self.presets["MenuTitle_Color"] = dividecolor(148,75,151);
    self.presets["Scroller_BG"] = dividecolor(148,75,151);
    self.presets["Scroller_ShaderIcon"] = "rank_prestige4";
    #ifdef MW1
    self.presets["Scroller_Shader"] = "hudsoftline";
    #else
    self.presets["Scroller_Shader"] = "line_horizontal";
    #endif
#endif
#ifdef MW2
    self.presets["Toggle_BG"] = dividecolor(255, 20, 147);
    self.presets["MenuTitle_Color"] = dividecolor(255, 20, 147);
    self.presets["Scroller_BG"] = dividecolor(255, 20, 147);
    self.presets["Scroller_Shader"] = "hudsoftline";
	self.presets["Scroller_ShaderIcon"] = "rank_prestige8";
#endif
#ifdef MW3
    self.presets["Toggle_BG"] = dividecolor(255, 0, 0);
    self.presets["MenuTitle_Color"] = dividecolor(255, 0, 0);
    self.presets["Scroller_BG"] = dividecolor(255, 0, 0);
    self.presets["Scroller_Shader"] = "hudsoftline";
    self.presets["Scroller_ShaderIcon"] = "cardicon_prestige_classic9";
#endif
}

displayVer()
{
    self endon( "disconnect");
#ifdef MW2 || MW3 || MWR
    Instructions = createFontString("objective", 1 );
    Instructions setPoint( "TOPRIGHT", "TOPRIGHT", -10, 10);
#endif
#ifdef MW1
    Instructions = createFontString("objective", 1.4);
    Instructions setPoint( "TOPRIGHT", "TOPRIGHT", 15, -25);
#endif
#ifdef BO1 || BO2
    Instructions = createFontString("objective", 1.20 );
    Instructions setPoint( "TOPRIGHT", "TOPRIGHT", 15, -25);
#endif
#ifdef WAW
    #ifdef XBOX
        Instructions = createFontString("objective", 1.20 );
        Instructions setPoint( "TOPRIGHT", "TOPRIGHT", 15, -25);
    #else
        Instructions = createFontString("objective", 1.20 );
        Instructions setPoint( "TOPRIGHT", "TOPRIGHT", -10, 10);
    #endif 
#endif

    Instructions.alpha = 0.5;

    for( ;; )
    {
        Instructions settext("Paradise");
        wait(2.0);
    }
}

initstrings()
{
   game["strings"]["pregameover"]       = "Paradise";
   game["strings"]["waiting_for_teams"] = "Paradise";
   game["strings"]["intermission"]      = "Paradise";
   game["strings"]["score_limit_reached"] = "Discord.gg^0/^7ProjectParadise";
   game["strings"]["time_limit_reached"]  = "Discord.gg^0/^7ProjectParadise";
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
        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise FFA!");
        self.hasMenu = true;
    }
    else if(level.currentGametype == "sd")
    {
        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise SND!");
        self.hasMenu = true;
    } 
    else
        self iprintlnbold("^1Paradise does not support this gamemode!");
}
watermark()
{
    self endon("disconnect");
    self endon("game_ended");
#ifndef MW1
    wm = self createFontString("objective", 1);
#else
    wm = self createFontString("objective", 1.4);
#endif
#ifdef WAW 
    #ifdef XBOX
        wm.x = -30;
        wm.y = 425;
    #else
        wm.x = 5;
        wm.y = 415;
    #endif
#endif
#ifdef BO1
    wm.x = -30;
    wm.y = 430;
#endif
#ifdef BO2
    wm.x = -340;
    wm.y = 430;
#endif
#ifdef MW1
    wm.x = -25;
    wm.y = 420;
#endif
#ifdef MW2
    wm.x = 0;
    wm.y = 445;
#endif
#ifdef MW3
    wm.x = 150;
    wm.y = 462;
#endif
#ifdef MWR
    wm.x = 10;
    wm.y = 468;
#endif
    wm.alpha = 1; 
    #ifdef WAW || MW1
    wm setText("[{+speed_throw}] + [{+melee}] = Paradise");
    #else
    wm settext("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
    #endif
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
#ifdef WAW || MW1
        if(isDefined(self.menu["isOpen"]) && self.menu["isOpen"])
            wm settext("[{+attack}]/[{+speed_throw}] = Scroll [{+usereload}] = Select  [{+melee}] = Back/Close");
        else
            wm settext("[{+speed_throw}] + [{+melee}] = Paradise");
#else
        if(isDefined(self.menu["isOpen"]) && self.menu["isOpen"])
            wm settext("[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select  [{+melee}] = Back/Close");
        else
            wm settext("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
#endif
    }
}
