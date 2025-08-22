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
            }
        }
        break;
     case "ts":  // Trickshot Menu
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+smoke}]", self.ufo, ::NoClip);

            canswapActions = strTok("Current;Infinite", ";");
            canswapIDs     = strTok("Current;Infinite", ";"); 
            self addSliderString("Canswap Mode", canswapIDs, canswapActions, ::SetCanswapMode);

            self addToggle("Toggle Instashoots", self.instashoot, ::instashoot);
            self addOpt("Spawn Slide", ::slide);
            self addOpt("Spawn Bounce", ::normalbounce);
            break;

            // WEAPON MENU
case "wpn":
    self addMenu("wpn", "Weapon Menu");
    self addOpt("Bolt-Actions", ::newMenu, "wpn_bolt");
    self addOpt("Rifles", ::newMenu, "wpn_rifle");
    self addOpt("SMGs", ::newMenu, "wpn_smg");
    self addOpt("Shotguns", ::newMenu, "wpn_shotty");
    self addOpt("LMGs", ::newMenu, "wpn_lmg");
    self addOpt("Pistols", ::newMenu, "wpn_pistol");
    break;

// BOLT-ACTIONS
case "wpn_bolt":
    self addMenu("wpn_bolt", "Bolt-Actions");
    self addOpt("Springfield", ::doGiveWeapon, "springfield_mp");
    self addOpt("Arisaka", ::doGiveWeapon, "type99rifle_mp");
    self addOpt("Mosin-Nagant", ::doGiveWeapon, "mosinrifle_mp");
    self addOpt("Kar98k", ::doGiveWeapon, "kar98k_mp");
    self addOpt("PTRS-41", ::doGiveWeapon, "ptrs41_mp");
    break;

// RIFLES
case "wpn_rifle":
    self addMenu("wpn_rifle", "Rifles");
    self addOpt("SVT-40", ::doGiveWeapon, "svt40_mp");
    self addOpt("Gewehr 43", ::doGiveWeapon, "gewehr43_mp");
    self addOpt("M1 Garand", ::doGiveWeapon, "m1garand_mp");
    self addOpt("STG-44", ::doGiveWeapon, "stg44_mp");
    self addOpt("M1A1 Carbine", ::doGiveWeapon, "m1carbine_mp");
    break;

// SMGS
case "wpn_smg":
    self addMenu("wpn_smg", "Submachine Guns");
    self addOpt("Thompson", ::doGiveWeapon, "thompson_mp");
    self addOpt("MP40", ::doGiveWeapon, "mp40_mp");
    self addOpt("Type 100", ::doGiveWeapon, "type100smg_mp");
    self addOpt("PPSh-41", ::doGiveWeapon, "ppsh_mp");
    break;

// SHOTGUNS
case "wpn_shotty":
    self addMenu("wpn_shotty", "Shotguns");
    self addOpt("Trench Gun", ::doGiveWeapon, "shotgun_mp");
    self addOpt("Double-Barrel", ::doGiveWeapon, "doublebarreledshotgun_mp");
    break;

// LMGs
case "wpn_lmg":
    self addMenu("wpn_lmg", "Light Machine Guns");
    self addOpt("Type 99", ::doGiveWeapon, "type99lmg_mp");
    self addOpt("BAR", ::doGiveWeapon, "bar_mp");
    self addOpt("DP-28", ::doGiveWeapon, "dp28_mp");
    self addOpt("MG42", ::doGiveWeapon, "mg42_mp");
    self addOpt("FG42", ::doGiveWeapon, "fg42_mp");
    self addOpt("Browning M1919", ::doGiveWeapon, "30cal_mp");
    break;

// PISTOLS
case "wpn_pistol":
    self addMenu("wpn_pistol", "Pistols");
    self addOpt("Colt M1911", ::doGiveWeapon, "colt_mp");
    self addOpt("Nambu", ::doGiveWeapon, "nambu_mp");
    self addOpt("Walther P38", ::doGiveWeapon, "walther_mp");
    self addOpt("Tokarev TT-33", ::doGiveWeapon, "tokarev_mp");
    self addOpt(".357 Magnum", ::doGiveWeapon, "357magnum_mp");
    break;


    case "tp":  // Teleport Menu
    self addMenu("tp", "Teleport Menu");
    self addOpt("Set Spawn", ::setSpawn);
    self addOpt("Unset Spawn", ::unsetSpawn);
    self addToggle("Save & Load", self.snl, ::saveandload);

    tpID  = [];
    tpCoords = [];

    if(getDvar("mapname") == "mp_airfield")
    {
        tpID  = strTok("Top of Plane;Top of Plane #2;Powerline;Top of Building;Bounce Drop", ";");
        tpCoords = [
            (3341, 2627, 497),
            (3105, 4343, 333),
            (246, 1758, 197),
            (1941, 4123, 1460),
            (4320, 7000, 4)
        ];
    }
    else if(getDvar("mapname") == "mp_asylum")
    {
        tpID  = strTok("Top of Map;Powerline", ";");
        tpCoords = [
            (532, -1925, 656),
            (1541, 1315, 419)
        ];
    }
    else if(getDvar("mapname") == "mp_castle")
    {
        tpID  = strTok("Top of Castle;Out of Map Building;Out of Map Building 2", ";");
        tpCoords = [
            (3024, -1391, 264),
            (6495, -1456, 158),
            (2468, -3516, 354)
        ];
    }
    else if(getDvar("mapname") == "mp_shrine") // Cliffside
    {
        tpID  = strTok("Palm Tree;Something;Palm Tree 2", ";");
        tpCoords = [
            (-3404, 442, -237),
            (-925, -1242, -11),
            (361, 158, 2)
        ];
    }
    else if(getDvar("mapname") == "mp_courtyard")
    {
        tpID  = strTok("Statue;Palm Tree;Palm Tree 2", ";");
        tpCoords = [
            (5688, -64, 297),
            (4231, -209, 303),
            (4946, -554, 316)
        ];
    }
    else if(getDvar("mapname") == "mp_dome")
    {
        tpID  = strTok("Out of Map;Out of Map 2;Top of Pillar;Top of Pillar 2;Good Luck", ";");
        tpCoords = [
            (-1146, 1354, 772),
            (1322, 1148, 504),
            (981, 313, 772),
            (-849, 312, 778),
            (821, 3613, 772)
        ];
    }
    else if(getDvar("mapname") == "mp_downfall")
    {
        tpID  = strTok("Top of Statue;Edge of Building;Inside Building;Back of Map Sui", ";");
        tpCoords = [
            (1122, 8571, 605),
            (606, 11172, 682),
            (3589, 10499, 464),
            (6878, 9313, 856)
        ];
    }
    else if(getDvar("mapname") == "mp_hangar")
    {
        tpID  = strTok("Powerline;Powerline 2", ";");
        tpCoords = [
            (-797, 1000, 998),
            (508, -3001, 1078)
        ];
    }
    else if(getDvar("mapname") == "mp_makin")
    {
        tpID  = strTok("Barrier;Backdrop;Palm Tree", ";");
        tpCoords = [
            (-12202, -17176, 757),
            (-8732, -20754, 757),
            (-6918, -16230, 942)
        ];
    }
    else if(getDvar("mapname") == "mp_outskirts")
    {
        tpID  = strTok("Top of Building;Top of Building 2;Powerline", ";");
        tpCoords = [
            (-2445, -2959, -1342),
            (900, -573, -1239),
            (2666, 480, -1013)
        ];
    }
    else if(getDvar("mapname") == "mp_roundhouse")
    {
        tpID  = strTok("Top of Building;Out of Map;Backdrop", ";");
        tpCoords = [
            (-855, -1441, 189),
            (-1742, 1871, 512),
            (3252, -2893, 513)
        ];
    }
    else if(getDvar("mapname") == "mp_seelow")
    {
        tpID  = strTok("Barrier;Barrier 2;Rock", ";");
        tpCoords = [
            (541, -2793, 1152),
            (4521, 3035, 1152),
            (5712, 3553, -54)
        ];
    }
    else if(getDvar("mapname") == "mp_suburban") // Upheaval
    {
        tpID  = strTok("Top of Building;Powerline;Out of Map Building", ";");
        tpCoords = [
            (1240, -3118, 64),
            (1144, -4261, -135),
            (2808, -3287, 120)
        ];
    }
    else
    {
        tpID  = strTok("^1Soon...", ";");
        tpCoords = [(0,0,0)];
    }
    self addSliderString("Teleport Spot", tpCoords, tpID, ::tptospot);
    break;

    case "afthit":  // Afterhits Menu
    self addMenu("afthit", "Afterhits Menu");
    self addOpt("Bolt-Actions", ::newMenu, "afthit_bolt");
    self addOpt("Rifles", ::newMenu, "afthit_rifle");
    self addOpt("SMGs", ::newMenu, "afthit_smg");
    self addOpt("Shotguns", ::newMenu, "afthit_shotty");
    self addOpt("LMGs", ::newMenu, "afthit_lmg");
    self addOpt("Pistols", ::newMenu, "afthit_pistol");
    self addOpt("Special", ::newMenu, "afthit_special");
    break;

// Bolt-Actions submenu
case "afthit_bolt":
    self addMenu("afthit_bolt", "Bolt-Actions");
    self addOpt("Springfield", ::AfterHit, "springfield_mp");
    self addOpt("Arisaka", ::AfterHit, "type99rifle_mp");
    self addOpt("Mosin-Nagant", ::AfterHit, "mosinrifle_mp");
    self addOpt("Kar98k", ::AfterHit, "kar98k_mp");
    self addOpt("PTRS-41", ::AfterHit, "ptrs41_mp");
    break;

// Rifles submenu
case "afthit_rifle":
    self addMenu("afthit_rifle", "Rifles");
    self addOpt("SVT-40", ::AfterHit, "svt40_mp");
    self addOpt("Gewehr 43", ::AfterHit, "gewehr43_mp");
    self addOpt("M1 Garand", ::AfterHit, "m1garand_mp");
    self addOpt("STG-44", ::AfterHit, "stg44_mp");
    self addOpt("M1A1 Carbine", ::AfterHit, "m1carbine_mp");
    break;

// SMGs submenu
case "afthit_smg":
    self addMenu("afthit_smg", "Submachine Guns");
    self addOpt("Thompson", ::AfterHit, "thompson_mp");
    self addOpt("MP40", ::AfterHit, "mp40_mp");
    self addOpt("Type 100", ::AfterHit, "type100smg_mp");
    self addOpt("PPSh-41", ::AfterHit, "ppsh_mp");
    break;

// Shotguns submenu
case "afthit_shotty":
    self addMenu("afthit_shotty", "Shotguns");
    self addOpt("Trench Gun", ::AfterHit, "shotgun_mp");
    self addOpt("Double-Barrel", ::AfterHit, "doublebarreledshotgun_mp");
    break;

// LMGs submenu
case "afthit_lmg":
    self addMenu("afthit_lmg", "Light Machine Guns");
    self addOpt("Type 99", ::AfterHit, "type99lmg_mp");
    self addOpt("BAR", ::AfterHit, "bar_mp");
    self addOpt("DP-28", ::AfterHit, "dp28_mp");
    self addOpt("MG42", ::AfterHit, "mg42_mp");
    self addOpt("FG42", ::AfterHit, "fg42_mp");
    self addOpt("Browning M1919", ::AfterHit, "30cal_mp");
    break;

// Pistols submenu
case "afthit_pistol":
    self addMenu("afthit_pistol", "Pistols");
    self addOpt("Colt M1911", ::AfterHit, "colt_mp");
    self addOpt("Nambu", ::AfterHit, "nambu_mp");
    self addOpt("Walther P38", ::AfterHit, "walther_mp");
    self addOpt("Tokarev TT-33", ::AfterHit, "tokarev_mp");
    self addOpt(".357 Magnum", ::AfterHit, "357magnum_mp");
    break;

// Special submenu (ONLY special weapons)
case "afthit_special":
    self addMenu("afthit_special", "Special");
    self addOpt("Betty", ::AfterHit, "mine_bouncing_betty_mp");
    self addOpt("Bomb", ::AfterHit, "briefcase_bomb_mp");
    self addOpt("Artillery", ::AfterHit, "artillery_mp");
    self addOpt("Flamethrower", ::AfterHit, "m2_flamethrower_mp");
    break;

   case "host":  // Host Options (host/dev only)
            self addMenu("host", "Host Options");
            self addOpt("End Game", ::debugexit);
            self addOpt("Fast Restart", ::FastRestart);
            self addToggle("Soft Lands", self.SoftLandsS, ::Softlands);
            self addOpt("Ladder Bounce", ::reverseladders);
            //self addOpt("Add 1 Minute",::add);
            //self addOpt("Remove 1 Minute",::subtract);
            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
            self addOpt("Teleport Bots to Crosshairs", ::tpBots);
            self addOpt("Kick Bots", ::kickAllBots);
            self addOpt("Fill Bots", ::addTestClients);
            break;
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
                            wait .08;
                        }
                    }
                    else if(self fragButtonPressed() || self secondaryOffhandButtonPressed()){
                        if(!self fragButtonPressed() || !self secondaryOffhandButtonPressed())
                        {
                            if(isDefined(self.eMenu[ self getCursor() ].val) || IsDefined( self.eMenu[ self getCursor() ].ID_list ))
                            {
                                if( self fragButtonPressed() )   
                                    self updateSlider( "L2" );
                                if( self secondaryOffhandButtonPressed() )    
                                    self updateSlider( "R2" );
                                wait .1;
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
                            self.menu["OPT"]["MENU_TITLE"] setSafeText( self.menuTitle + " ("+ player getName() +")");    
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
        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 1.8, "TOPLEFT", "CENTER", self.presets["X"] + 120, self.presets["Y"] - 100, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]); #endif
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
        self.menu["UI"]["MENU_TITLE"] setSafeText(level.MenuName);
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
                self.menu["OPT"][e] setSafeText( self.eMenu[ ary + e ].opt );
            else 
                self.menu["OPT"][e] setSafeText("");
                
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
                    self.menu["UI_SLIDE"]["VAL"] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 150, self.menu["OPT"][e].y, 5, 1, self.sliders[ self getCurrentMenu() + "_" + self getCursor() ] + "", self.presets["Text"]);
                self updateSlider( "", e, ary + e );
            }
            if(IsDefined( self.eMenu[ (ary + e) ].ID_list ) )
            {
                if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + (ary + e)] ))
                    self.sliders[ self getCurrentMenu() + "_" + (ary + e) ] = 0;
                    
                self.menu["UI_SLIDE"]["STRING_"+e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 6, 1, "", self.presets["Text"]);
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
