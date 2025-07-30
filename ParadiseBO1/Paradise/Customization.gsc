

    LoadSettings()
    {
        self.presets = [];

        self.presets["X"] = 155; // 145
        self.presets["Y"] = -20; // 0

        self.presets["Toggle_BG"] = GetSetting( "Toggle_BG" );
        self.presets["Option_BG"] = GetSetting( "Option_BG" );
        self.presets["Title_BG"] = GetSetting( "Title_BG" );
        self.presets["MenuTitle_Color"] = GetSetting( "MenuTitle_Color" );
        self.presets["Scroller_BG"] = GetSetting( "Scroller_BG" );
        self.presets["ScrollerIcon_BG"] = GetSetting( "ScrollerIcon_BG" );
        self.presets["Outline_BG"] = GetSetting( "Outline_BG" );
        self.presets["KB_Outline"] = GetSetting( "KB_Outline" );
        self.presets["Text"] = GetSetting( "Text" );
        self.presets["Option_Font"] = GetSetting( "Option_Font" );
        self.presets["Font_Scale"] = GetSetting( "Font_Scale" );
        self.presets["Scroller_Shader"] = GetSetting( "Scroller_Shader" );
        self.presets["Scroller_ShaderIcon"] = GetSetting( "Scroller_ShaderIcon" );
        self.presets["InfoBG_Color"] = GetSetting( "InfoBG_Color" );
    }

    GetSetting(preset)
{
    if(preset == "X" )
        return 0;
    if(preset == "Y" )
        return 0;
    if(preset == "Toggle_BG")
        return dividecolor(0, 255, 255); // was (255, 40, 40)
    if(preset == "Option_BG")
        return dividecolor(0, 0, 0);
    if(preset == "Title_BG")
        return dividecolor(255, 255, 255);
    if(preset == "MenuTitle_Color")
        return dividecolor(0, 255, 255); // was (255, 40, 40)
    if(preset == "Scroller_BG")
        return dividecolor(0, 255, 255); // was (255, 1, 1)
    if(preset == "ScrollerIcon_BG")
        return dividecolor(255, 255, 255);
    if(preset == "InfoBG_Color")
        return dividecolor(0, 255, 255); // was (255, 40, 40)
    if(preset == "Outline_BG")
        return dividecolor(0, 0, 0);
    if(preset == "KB_Outline")
        return "rainbow";
    if(preset == "Text")
        return dividecolor(255, 255, 255);
    if(preset == "Option_Font")
        return "default";
    if(preset == "Font_Scale")
        return 1;
    if(preset == "Scroller_Shader")
        return "white";
    #ifdef STEAM 
        if(preset == "Scroller_ShaderIcon")
            return "rank_prestige4";
    #endif
    #ifdef XBOX
        if(preset == "Scroller_ShaderIcon")
            return "rank_prestige4";
    #endif
}



    MenuFont(font)
    {
        self.presets["Option_Font"] = font;

        if(font == "default")
            self.presets["Font_Scale"] = 1;
        if(font == "hudsmall")
            self.presets["Font_Scale"] = 0.5;
        if(font == "hudbig")
            self.presets["Font_Scale"] = 0.3;
        if(font == "objective")
            self.presets["Font_Scale"] = 0.8;
        if(font == "bigfixed")
            self.presets["Font_Scale"] = 0.4;
        if(font == "smallfixed")
            self.presets["Font_Scale"] = 0.7;

        self thread refreshMenu( true );
    }

    MenuShader(shader)
    {
        self.presets["Scroller_Shader"] = shader;

        if(shader == "default")
            self.presets["Scroller_Shader"] = "hudsoftline";
        if(shader == "Gradient Center")
            self.presets["Scroller_Shader"] = "gradient_center";
        if(shader == "Gradient FadeIn")
            self.presets["Scroller_Shader"] = "gradient_fadein";
        if(shader == "Solid")
            self.presets["Scroller_Shader"] = "white";
        if(shader == "Minimap Scanlines")
            self.presets["Scroller_Shader"] = "minimap_scanlines";
        if(shader == "Lock Box")
            self.presets["Scroller_Shader"] = "viper_locking_box";
        if(shader == "Compass Ping")
            self.presets["Scroller_Shader"] = "compassping_enemyfiring";
        if(shader == "Checkerboard")
            self.presets["Scroller_Shader"] = "checkerboard";
        if(shader == "Clouds")
            self.presets["Scroller_Shader"] = "mw2_popup_bg_fogscroll";
        if(shader == "Vertical Line")
            self.presets["Scroller_Shader"] = "line_vertical";
        if(shader == "Camera")
            self.presets["Scroller_Shader"] = "dof_near_coc";
        if(shader == "Hud Scorebar")
            self.presets["Scroller_Shader"] = "hud_scorebar_topbar";
        if(shader == "Popup Selection Bar")
            self.presets["Scroller_Shader"] = "popup_button_selection_bar";
        if(shader == "Minimap Light")
            self.presets["Scroller_Shader"] = "minimap_light_on";
        if(shader == "Explosion")
            self.presets["Scroller_Shader"] = "compassping_explosion";
       // if(shader == "Solid Triangle")
          //  self.presets["Scroller_Shader"] = "solid_triangle";
        if(shader == "Static")
            self.presets["Scroller_Shader"] = "javelin_overlay_grain";
        if(shader == "Camo")
            self.presets["Scroller_Shader"] = "cardtitle_camo_urban";
        if(shader == "Combat Overlay")
            self.presets["Scroller_Shader"] = "combathigh_overlay";
    
        self thread refreshMenu( true );
    }

    MenuShaderIcon(icon)
    {
        self.presets["Scroller_ShaderIcon"] = icon;

        if(icon == "default")
            self.presets["Scroller_Shader"] = "cardicon_iw";
        if(icon == "UI Star")
            self.presets["Scroller_Shader"] = "ui_host";
        if(icon == "Nuke")
            self.presets["Scroller_Shader"] = "dpad_killstreak_nuke";
        if(icon == "EMP")
            self.presets["Scroller_Shader"] = "dpad_killstreak_emp";
        if(icon == "10th Prestige")
            self.presets["Scroller_Shader"] = "rank_prestige10";
        if(icon == "9th Prestige")
            self.presets["Scroller_Shader"] = "rank_prestige9";
        if(icon == "C4")
            self.presets["Scroller_Shader"] = "hud_icon_c4";
        if(icon == "Weed")
            self.presets["Scroller_Shader"] = "cardicon_weed";
        if(icon == "Spinning Cross")
            self.presets["Scroller_Shader"] = "cardicon_prestige10";
        if(icon == "Spinning Skull")
            self.presets["Scroller_Shader"] = "cardicon_prestige10_02";

        self thread refreshMenu( true );
    }

    MenuOpenAnim()
    {
        if(!isdefined(self.MenuOpenAnim))
        {
            self.MenuOpenAnim = true;
            self.LaptopGiven = false;
            self.SavedWeapon = self GetCurrentWeapon();
            
            while(isdefined(self.MenuOpenAnim))
            {
                if(self.menu["isOpen"] && !self.LaptopGiven)
                {
                    self giveweapon("killstreak_ac130_mp");
                    self switchtoweapon("killstreak_ac130_mp");
                    self.LaptopGiven = true;
                }
                else if(!self.menu["isOpen"] && self.LaptopGiven){
                    self takeweapon("killstreak_ac130_mp");
                    self giveweapon(self.SavedWeapon);
                    self switchtoweapon(self.SavedWeapon);
                    self.LaptopGiven = false;
                }

                wait 0.05;
            }
        }
        else{
            self.MenuOpenAnim = undefined;

            if(isdefined(self.LaptopGiven) && self.LaptopGiven)
            {
                self takeweapon("killstreak_ac130_mp");
                self giveweapon(self.SavedWeapon);
                self switchtoweapon(self.SavedWeapon);
            }
            
            self.LaptopGiven = undefined;
            self.SavedWeapon = undefined;
        }
    }

displayVer()
{
    self endon("disconnect");

    Instructions = createFontString("objective", 1.20);
    Instructions setPoint("TOPRIGHT", "TOPRIGHT", 15, -25);
    Instructions.alpha = 0.5; 
    for (;;)
    {
        Instructions setText("Paradise BO1");
        wait(2.0);
    }
}

doWelcomeMessage()
{
    if(level.currentGametype == "dm")
    {
        self iprintlnbold("Welcome ^1" + self.name + " ^7to ^1Paradise BO1 FFA!");
        wait 3;
        self iprintln("[{+speed_throw}] + [{+actionslot 2}] to open menu");
        wait 3;
        self iprintln("Your access is: " + self.MyAccess);
        self.hasMenu = true;
    }
    else if(level.currentGametype == "tdm")
    {
        self iprintlnbold("Welcome ^1" + self.name + " ^7to ^1Paradise BO1 TDM!");
        wait 3;
        self iprintln("[{+speed_throw}] + [{+actionslot 2}] to open menu");
        wait 3;
        self iprintln("Your access is: " + self.MyAccess);
        self.hasMenu = true;
    } 
    else if(level.currentGametype == "sd")
    {
        self iprintlnbold("Welcome ^1" + self.name + " ^7to ^1Paradise BO1 SND!");
        wait 3;
        self iprintln("[{+speed_throw}] + [{+actionslot 2}] to open menu");
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
   game["strings"]["pregameover"]       = "Paradise BO1";
   game["strings"]["waiting_for_teams"] = "Paradise BO1";
   game["strings"]["intermission"]      = "Paradise BO1";
   game["strings"]["score_limit_reached"] = "Discord.gg^0/^7qbpnQfbVqY";
   game["strings"]["time_limit_reached"]  = "Discord.gg^0/^7qbpnQfbVqY";
   game["strings"]["draw"]               = "Paradise BO1";
   game["strings"]["round_draw"]         = "Paradise BO1";
   game["strings"]["round_win"]          = "Paradise BO1";
   game["strings"]["round_loss"]         = "Paradise BO1";
   game["strings"]["round_tie"]          = "Paradise BO1";
   game["strings"]["victory"]            = "Paradise BO1";
   game["strings"]["defeat"]             = "Paradise BO1";
   game["strings"]["game_over"]          = "Paradise BO1";
   game["strings"]["halftime"]           = "Paradise BO1";
   game["strings"]["overtime"]            = "Paradise BO1";
   game["strings"]["roundend"]            = "Paradise BO1";
   game["strings"]["side_switch"]         = "Paradise BO1";

}



