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
    self.presets["Font_Scale"] = 1;

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
    Instructions = createFontString("objective", 1 );
    Instructions setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0);

    Instructions.alpha = 0.5;

    for( ;; )
    {
        Instructions settext("Paradise");
        wait(2.0);
    }
}
doWelcomeMessage()
{
    if(level.currentGametype == "sd")
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

    wm = self createFontString("objective", 1);

#ifdef MW2
    wm.x = 0;
    wm.y = 445;
#endif
#ifdef MW3
    wm.x = 150;
    wm.y = 462;
#endif

    wm.alpha = 1; 
    wm settext("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
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
            wm settext("[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select  [{+melee}] = Back/Close");
        else
            wm settext("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
    }
}
