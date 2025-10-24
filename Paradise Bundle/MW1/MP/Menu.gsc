pMapName()
{
    self iprintln("^1" + getdvar("mapname"));
}
pOrigin()
{
    self iprintln("^2" + self getorigin());
}
menuOptions()
{
    player = self.selected_player;        
    menu = self getCurrentMenu();

    player_ID = [];
    foreach(players in level.players)
        player_ID[player_ID.size] = players.name;

    switch(menu)
{
    case "main":
        if(self.access > 0) // Verified
        {
            self addMenu("main", "Main Menu");
            self addOpt("Trickshot Menu", ::newMenu, "ts");
            self addOpt("Weapon Menu", ::newMenu, "wpn");
            self addOpt("Teleport Menu", ::newMenu, "tp");
            self addOpt("Afterhits Menu", ::newMenu, "afthit");

            if(self ishost() || self isDeveloper())
            {
                self addOpt("Host Options", ::newMenu, "host");
                //self addOpt("Print Map Name", ::pMapName);
                //self addOpt("Print Origin", ::pOrigin);
            }
        }
        break;

    case "ts":  // Trickshot Menu
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+smoke}]", self.ufo, ::NoClip);
            self addOpt("Go for Two Piece", ::dotwopiece);

            canswapActions = ["Current", "Infinite"];
            canswapIDs     = ["Current","Infinite"]; 
            self addSliderString("Canswap Mode", canswapIDs, canswapActions, ::SetCanswapMode);

            self addToggle("Toggle Instashoots", self.instashoot, ::instashoot);
            self addOpt("Spawn Slide", ::slide);

            spawnOptionsActions = ["Bounce","Platform","Crate"];
            spawnOptionsIDs     = ["bounce","platform","crate"];
            self addSliderString("Spawn @ Feet", spawnOptionsIDs, spawnOptionsActions, ::doSpawnOption);
            break;

// WEAPON MENU
case "wpn":
    self addMenu("wpn", "Weapon Menu");

    arNames = ["M16A4","AK-47","M4 Carbine","G3","G36C", "M14", "MP44"];
    arIDs   = ["m16_mp", "ak47_mp", "m4_mp", "g3_mp", "g36c_mp", "m14_mp", "mp44_mp"];
    self addSliderString("Rifles", arIDs, arNames, ::doGiveWeapon);

    smgNames = ["MP5","Skorpion","Mini-Uzi","AK-74u", "P90"];
    smgIDs   = ["mp5_mp", "skorpion_mp", "uzi_mp", "ak74u_mp", "p90_mp"];
    self addSliderString("SMGs", smgIDs, smgNames, ::doGiveWeapon);

    lmgNames = ["M249 SAW", "RPD", "M60E4"];
    lmgIDs   = ["saw_mp", "rpd_mp", "m60e4_mp"];
    self addSliderString("LMGs", lmgIDs, lmgNames, ::doGiveWeapon);

    shottyNames = ["W1200","M1014"];
    shottyIDs   = ["winchester1200_mp", "m1014_mp"];
    self addSliderString("Shotguns", shottyIDs, shottyNames, ::doGiveWeapon);

    srNames = ["M40A3","M21","Dragunov","R700","Barrett .50cal"];
    srIDs   = ["m40a3_mp", "m21_mp", "dragunov_mp", "remington700_mp", "barret_mp"];
    self addSliderString("Bolt-Actions", srIDs, srNames, ::doGiveWeapon);

    pistolNames = ["M9", "USP .45", "M1911 .45", "Desert Eagle", "Gold Desert Eagle"];
    pistolIDs   = ["beretta_mp", "colt45_mp", "usp_mp", "deserteagle_mp", "deserteaglegold_mp"];
    self addSliderString("Pistols", pistolIDs, pistolNames, ::doGiveWeapon);

    self addOpt("Attachments", ::newMenu, "attach");
    self addOpt("Special Grenades", ::newMenu, "offhands");
    self addOpt("Equipment", ::newMenu, "equipment");    
    self addOpt("Take Current Weapon", ::takeWpn);
    self addOpt("Drop Current Weapon", ::dropWpn);
    break;

    case "attach":
    self addMenu("attach", "Attachments");
    attachNames = ["Grenade Launcher", "Silencer", "Red Dot Sight", "ACOG Scope", "Grip"];
    attachIDs = ["gl", "silencer", "reflex", "acog", "grip"];
    for(a=0;a<attachNames.size;a++)
    self addOpt(attachNames[a], ::giveplayerattachment, attachIDs[a]);
    break;

    case "tp":  // Teleport Menu
    self addMenu("tp", "Teleport Menu");
    self addOpt("Set Spawn", ::setSpawn);
    self addOpt("Unset Spawn", ::unsetSpawn);
    self addToggle("Save & Load", self.snl, ::saveandload);

    tpID  = [];
    tpCoords = [];

    if(getDvar("mapname") == "mp_convoy")
    {
        tpID = "Roof 1;Roof 2";
        tpCoords = [
            (-3324.6, 1091, 209.125),
            (3333.45, 286.406, 241.125)
        ];
    }
    else if(getDvar("mapname") == "mp_backlot")
    {
        tpID = "Complex Roof;Top Construction;OOM Roof";
        tpCoords = [
            (2057.23, -1213.59, 553.125),
            (-886.367, -561.968, 739.125),
            (-1931.07, 964.094, 473.125)
        ];
    }
    else if(getDvar("mapname") == "mp_bloc")
    {
        tpID = "Stairwell;Roof";
        tpCoords = [
            (73.8425, -4612.17, 517.125),
            (4982.57, -6245.23, 1321.13)
        ];
    }
    else if(getDvar("mapname") == "mp_bog")
    {
        tpID = "Tree Spot;Roof Spot 1;Roof Spot 2;Bridge; Way OOM";
        tpCoords = [
            (3006.75, 1994.12, 543.126), 
            (1210.42, 352.161, 459.125),
            (1514.04, -612.295, 407.125),
            (5922.09, 2755.55, 335.125),
            (8796.52, 4227.97, 748.22)
        ];
    }
    else if(getDvar("mapname") == "mp_countdown")
    {
        tpID = "Mountain Ridge;OOM Roof";
        tpCoords = [
            (6173.2, 1472.22, 1696.5),
            (627.775, 5046.09, 227.125)
        ];
    }
    else if(getDvar("mapname") == "mp_crash")
    {
        tpID = "OOM Roof;Tree Spot";
        tpCoords = [
            (383.873, 3345.03, 825.125),
            (49.5953, -1874.56, 481.465)
        ];
    }
    else if(getDvar("mapname") == "mp_crossfire")
    {
        tpID = "Roof Spot;Bridge OOM;Arch Barrier";
        tpCoords = [
            (6547.7, -1495.91, 454.125),
            (6404.73, 899.148, 335.125),
            (3468.97, -121.03, 773.125)
        ];
    }
    else if(getDvar("mapname") == "mp_citystreets")
    {
        tpID = "Roof Spot 1;Roof Spot 2;Complex Roof;OOM Sign";
        tpCoords = [
            (2946.84, -3152.86, 585.125),
            (2702.18, 1996.68, 681.125),
            (7420.01, -722.962, 929.125),
            (7177.58, 820.848, 841.125)
        ];
    }
    else if(getDvar("mapname") == "mp_farm")
    {
        tpID = "Water Tower 1;Water Tower 2";
        tpCoords = [
            (2201.39, -193.515, 1061.9),
            (-2540.36, 2913.32, 1130.12)
        ];
    }
    else if(getDvar("mapname") == "mp_pipeline")
    {
        tpID = "Tower Spot;Pipe Pillar";
        tpCoords = [
            (-1474.99, 2846.11, 983.125),
            (2483.37, 6235.57, 1155.13)
        ];
    }
    else if(getDvar("mapname") == "mp_strike")
    {
        tpID = "OOM Roof 1;OOM Roof 2;OOM Roof 3";
        tpCoords = [
            (1081.26, 2639.13, 665.125),
            (-3011.86, 1851.13, 665.125),
            (-2604.68, 658.431, 573.125)
        ];
    }
    else if(getDvar("mapname") == "mp_vacant")
    {
        tpID = "Lightpole;Telephone Pole";
        tpCoords = [
            (-1543.55, -1798.13, 302.728),
            (2636.17, -452.346, 293.125)
        ];
    }
    else if(getDvar("mapname") == "mp_cargoship")
    {
        tpID = "Crows Nest 1;Crows Nest 2;Mid Bridge 1;Mid Bridge 2";
        tpCoords = [
            (2625.71, 0.746494, 1653.01),
            (-2573.92, -0.69922, 1801.13),
            (1013.81, 36.4078, 1297.63),
            (-570.389, -4.83865, 1297.63)
        ];
    }
    else if(getDvar("mapname") == "mp_broadcast")
    {
        tpID = "Top Archway;OOM Roof";
        tpCoords = [
            (-1855.35, 4119.06, 400.125),
            (-2367.59, 7410.49, 211.726)
        ];
    }
    else if(getDvar("mapname") == "mp_carentan")
    {
        tpID = "Roof Spot 1;Roof Spot 2;Roof Spot 3";
        tpCoords = [
            (-79.9974, -1956.35, 646.125),
            (-140.085, -4558.38, 790.125),
            (-962.154, 1088.41, 457.125)
        ];
    }
    else if(getDvar("mapname") == "mp_killhouse")
    {
        tpID = "Warehouse 1 Roof;Warehouse 2 Roof;Warehouse 4 Roof;Telephone Pole;White Building Roof;Guard Tower";
        tpCoords = [
            (-1131.02, 279.652, 748.125),
            (2325.11, 1730.57, 748.125),
            (2274.45, -2380.51, 725.689),
            (-1232.81, -1055.86, 382.125),
            (690.748, -2409.77, 465.125),
            (4001.15, -1069.72, 561.125)
        ];
    }
    else if(getDvar("mapname") == "mp_creek")
    {
        tpID = "Hilltop;Good luck..";
        tpCoords = [
            (2161.44, 6683.58, 672.77),
            (19009.5, 13575.8, 3188.34)
        ];
    }
    else 
    {
        tpNames  = "No Custom Spots";
        tpCoords = [];
    }
    self addSliderString("Spots", tpCoords, tpID, ::tptospot);
    break;

    case "afthit":  // Afterhits Menu
    self addMenu("afthit", "Afterhits Menu");

    arNames = ["M16A4","AK-47","M4 Carbine","G3","G36C", "M14", "MP44"];
    arIDs   = ["m16_mp", "ak47_mp", "m4_mp", "g3_mp", "g36c_mp", "m14_mp", "mp44_mp"];
    self addSliderString("Rifles", arIDs, arNames, ::afterhit);

    smgNames = ["MP5","Skorpion","Mini-Uzi","AK-74u", "P90"];
    smgIDs   = ["mp5_mp", "skorpion_mp", "uzi_mp", "ak74u_mp", "p90_mp"];
    self addSliderString("SMGs", smgIDs, smgNames, ::afterhit);

    lmgNames = ["M249 SAW", "RPD", "M60E4"];
    lmgIDs   = ["saw_mp", "rpd_mp", "m60e4_mp"];
    self addSliderString("LMGs", lmgIDs, lmgNames, ::afterhit);

    shottyNames = ["W1200","M1014"];
    shottyIDs   = ["winchester1200_mp", "m1014_mp"];
    self addSliderString("Shotguns", shottyIDs, shottyNames, ::afterhit);

    srNames = ["M40A3","M21","Dragunov","R700","Barrett .50cal"];
    srIDs   = ["m40a3_mp", "m21_mp", "dragunov_mp", "remington700_mp", "barret_mp"];
    self addSliderString("Bolt-Actions", srIDs, srNames, ::afterhit);

    pistolNames = ["M9", "USP .45", "M1911 .45", "Desert Eagle", "Gold Desert Eagle"];
    pistolIDs   = ["beretta_mp", "colt45_mp", "usp_mp", "deserteagle_mp", "deserteaglegold_mp"];
    self addSliderString("Pistols", pistolIDs, pistolNames, ::afterhit);
    break;

        case "host":  // Host Options
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");

            minDistVal = ["15","25","50","100","150","200","250"];
            self addsliderstring("Minimum Distance", minDistVal, undefined, ::setMinDistance);

            timeActions = ["Add 1 Minute","Remove 1 Minute"];
            timeIDs = ["add","sub"];
            self addSliderString("Game Timer", timeIDs, timeActions, ::changeTime);

            self addOpt("Fast Restart", ::FastRestart);

            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
            self addOpt("Teleport Bots to Crosshairs", ::tpBots);
            self addOpt("Kick Bots", ::kickAllBots);
            self addOpt("Fill Bots", ::addTestClients);
            break;
    }
    self clientOptions();
}

clientOptions()
{   
    if(self isHost() || self isdeveloper())
    {
        self addMenu("Verify",  "Clients Menu");
        foreach( player in level.players )
        {
            if (isDefined(player.pers) && isDefined(player.pers["isBot"]) && player.pers["isBot"])
                continue;
            perm = "None";
            if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                perm = level.status[player.access];
            
            if (player isDeveloper())
                perm = perm + " ^7| ^6Developer";

            self addOpt(player getname() + " [" + perm + "^7]", ::newmenu, "Verify_" + player getXUID());
        }
        foreach(player in level.players)
        {
            if (isDefined(player.pers) && isDefined(player.pers["isBot"]) && player.pers["isBot"])
                continue;

            perm2 = "None";
            if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                perm2 = level.status[player.access];
            self addMenu("Verify_" + player getXUID(), player getName() + " [" + perm2 + "^7]");
            self addOpt("Kick Player", ::kickSped, player);
            self addOpt("Ban Player", ::banSped, player);  
            self addOpt("Teleport to Crosshairs", ::teleportToCrosshair, player);  
        }
    }
}

    menuMonitor()
    {
        self endon("disconnect");
        self endon("end_menu");

        while( self.access != 0 )
        {
            if(!self.menu["isLocked"])
            {
                if(!self.menu["isOpen"])
                {
                    if( self meleebuttonpressed() && self adsButtonPressed() )
                    {
                        self menuOpen();
                        wait .2;
                    }               
                }
                else{
                    if(self adsbuttonpressed() || self attackbuttonpressed())
                    {
                        if(!self adsbuttonpressed() || !self attackbuttonpressed())
                        {
                            if(!self adsbuttonpressed())
                                self.menu[ self getCurrentMenu() + "_cursor" ] += self attackbuttonpressed();
                            if(!self attackbuttonpressed())
                                self.menu[ self getCurrentMenu() + "_cursor" ] -= self adsbuttonpressed();

                            self scrollingSystem();
                            wait .25;
                        }
                    }
                    else if(self fragButtonPressed() || self secondaryOffhandButtonPressed()){
                        if(!self fragButtonPressed() || !self secondaryOffhandButtonPressed())
                        {
                            if(isDefined(self.eMenu[ self getCursor() ].val) || IsDefined( self.eMenu[ self getCursor() ].ID_list ))
                            {
                                if( self secondaryOffhandButtonPressed() )   
                                    self updateSlider( "L2" );
                                if( self fragButtonPressed())    
                                    self updateSlider( "R2" );
                                wait .25;
                            }
                        }
                    }
                    else if( self useButtonPressed() ){
                        player = self.selected_player;
                        menu = self.eMenu[self getCursor()];

                        if(isDefined(self.sliders[ self getCurrentMenu() + "_" + self getCursor() ])){
                            slider = self.sliders[ self getCurrentMenu() + "_" + self getCursor() ];
                            slider = (IsDefined( menu.ID_list ) ? menu.ID_list[slider] : slider);
                            player thread doOption( menu.func, slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );
                        }
                        else 
                            player thread doOption( menu.func, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );

                        wait .05;
                        if(IsDefined( menu.toggle ))
                            self setMenuText();
                        if( player != self )
                            self.menu["OPT"]["MENU_TITLE"] settext( self.menuTitle + " ("+ player getName() +")");    
                        wait .15;
                        if( isDefined(player.was_edited) && self isHost() )
                            player.was_edited = undefined;
                    }
                    else if( self meleeButtonPressed() ){
                        if( self.selected_player != self )
                        {
                            self.selected_player = self;
                            self setMenuText();
                            self refreshTitle();
                        }
                        else if( self getCurrentMenu() == "main" )
                            self menuClose();
                        else 
                            self newMenu();
                        wait .2;
                    }
                }
            }
            wait .05;
        }
    }

    menuOpen()
    {
        self.menu["isOpen"] = true;

        self menuOptions();
        self drawMenu();
        self drawText();
        self setMenuText(); 
        self updateScrollbar();
        self thread menudeath();
    }

      menuDeath()
    {
        self endon("disconnect");
        self endon("menuClosed");
    
        while(self.menu["isOpen"])
        {
            self waittill_any("death","game_ended","menuresponse");
            self menuClose();
        }
}

    menuClose()
    {
        self destroyAll(self.menu["UI"]); 
        self destroyAll(self.menu["OPT"]);
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);
        self.menu["isOpen"] = false;
    }

    drawMenu()
    {
        if(!isDefined(self.menu["UI"]))
            self.menu["UI"] = [];
        if(!isDefined(self.menu["UI_TOG"]))
            self.menu["UI_TOG"] = [];    
        if(!isDefined(self.menu["UI_SLIDE"]))
            self.menu["UI_SLIDE"] = [];
        if(!isDefined(self.menu["UI_STRING"]))
            self.menu["UI_STRING"] = [];    
            
        #ifdef XBOX self.menu["UI"]["TITLE_BG"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 95.5, 200, 47, self.presets["Title_BG"], "gradient_top", 1, 1);
        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 1.8, "TOPLEFT", "CENTER", self.presets["X"] + 110, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]); #endif
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        self.menu["UI"]["SCROLLERICON"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 45, self.presets["Y"] - 108, 10, 10, self.presets["ScrollerIcon_BG"], self.presets["Scroller_ShaderIcon"], 3, 1);
        self resizeMenu();
    }

    drawText()
    {
        self destroyAll(self.menu["OPT"]);

        if(!isDefined(self.menu["OPT"]))
            self.menu["OPT"] = [];

        for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText(self.presets["Option_Font"], self.presets["Font_Scale"], "LEFT", "CENTER", self.presets["X"] + 5, self.presets["Y"] - 62 + (e * 15), 3, 1, "", self.presets["Text"]);
    }

    refreshTitle()
    {
        self.menu["UI"]["MENU_TITLE"] settext(level.MenuName);
    }
        
    scrollingSystem()
    {
        if(self getCursor() >= self.eMenu.size || self getCursor() < 0 || self getCursor() == 9)
        {
            if(self getCursor() <= 0)
                self.menu[ self getCurrentMenu() + "_cursor" ] = self.eMenu.size -1;
            else if(self getCursor() >= self.eMenu.size)
                self.menu[ self getCurrentMenu() + "_cursor" ] = 0;
        }
        
        self setMenuText();
        self updateScrollbar();
    }

    updateScrollbar()
    {
        curs = (self getCursor() >= 10) ? 9 : self getCursor();  
        self.menu["UI"]["SCROLLER"].y = (self.menu["OPT"][curs].y);
        self.menu["UI"]["SCROLLERICON"].y = (self.menu["OPT"][curs].y);
        
        size       = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
        height     = int(15 * size); // 18
        math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
        position_Y = (self.eMenu.size-1) / ((height - 15) - math);
    }

    setMenuText()
    {
        self endon("disconnect");
        self menuOptions();
        self resizeMenu();

        ary = (self getCursor() >= 10) ? (self getCursor() - 9) : 0;  
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);
        
        for(e=0;e<10;e++)
        {
            self.menu["OPT"][e].x = self.presets["X"] + 61; 
            
            if(isDefined(self.eMenu[ ary + e ].opt))
                self.menu["OPT"][e] settext( self.eMenu[ ary + e ].opt );
            else 
                self.menu["OPT"][e] settext("");
                
            if(IsDefined( self.eMenu[ ary + e ].toggle ))
            {
                self.menu["OPT"][e].x += 0; 
                #ifdef XBOX self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["OPT"][e].x + 189, self.menu["OPT"][e].y, 7, 7, (self.eMenu[ ary + e ].toggle) ? self.presets["Toggle_BG"] : dividecolor(150, 150, 150), "white", 5, 1); #endif
            }
            if(IsDefined( self.eMenu[ ary + e ].val ))
            {
                self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 38, 1, (0,0,0), "white", 4, 1); //BG
                self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 188, self.menu["UI_SLIDE"][e].y, 1, 6, self.presets["Toggle_BG"], "white", 5, 1); //INNER
                if( self getCursor() == ( ary + e ) )
                    self.menu["UI_SLIDE"]["VAL"] = self createText("default", 1.4, "RIGHT", "CENTER", self.menu["OPT"][e].x + 150, self.menu["OPT"][e].y, 5, 1, self.sliders[ self getCurrentMenu() + "_" + self getCursor() ] + "", self.presets["Text"]);
                self updateSlider( "", e, ary + e );
            }
            if(IsDefined( self.eMenu[ (ary + e) ].ID_list ) )
            {
                if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + (ary + e)] ))
                    self.sliders[ self getCurrentMenu() + "_" + (ary + e) ] = 0;
                    
                self.menu["UI_SLIDE"]["STRING_"+e] = self createText("default", 1.4, "RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 6, 1, "", self.presets["Text"]);
                self updateSlider( "", e, ary + e );
            }
            if(self.eMenu[ ary + e ].func == ::newMenu && IsDefined( self.eMenu[ ary + e ].func ) )
            {
                self.menu["UI_SLIDE"]["SUBMENU"+e] = self createrectangle( "RIGHT", "CENTER", self.menu["OPT"][e].x + 196, self.menu["OPT"][e].y, 9, 9, self.presets["Toggle_BG"], "ui_arrow_right", 5, 1);
                self.menu["UI_SLIDE"]["SUBMENU"+e].foreground = true;
            }
        }

    }
        
    resizeMenu()
    {
        size   = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
        height = int(15 * size);
        math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
        
        self.menu["UI"]["OPT_BG"] SetShader( "white", 200, height + 1 );
        self.menu["UI"]["OUTLINE"] SetShader( "white", 204, height + 54 );
    }
