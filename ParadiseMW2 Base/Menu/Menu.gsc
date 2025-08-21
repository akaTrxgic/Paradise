    menuOptions()
    {
        player = self.selected_player;        
        menu = self getCurrentMenu();
        
        player_names = [];
        foreach( players in level.players )
            player_names[player_names.size] = players.name;

        switch(menu)
{
    case "main":
        if(self.access > 0) // Verified
        {
            self addMenu("main", "Main Menu");
            self addOpt("Trickshot Menu", ::newMenu, "ts");
            self addOpt("Binds Menu", ::newMenu, "sK");
            self addOpt("Teleport Menu", ::newMenu, "tp");
            self addOpt("Class Menu", ::newMenu, "class");
            self addOpt("Afterhits Menu", ::newMenu, "afthit");
            self addOpt("Killstreak Menu", ::newMenu, "kstrks");

            if(self ishost() || self isDeveloper()) 
            {
                self addOpt("Host Options", ::newMenu, "host");
            }
        }
        break;

    
 case "ts":  // Trickshot Menu
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+smoke}]", self.NoClipT, ::initNoClip);

            canOpts = strtok("Current;Infinite", ";");
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);

            self addToggle("Rocket Ride",  self.RPGRide, ::ToggleRPGRide);
            self addToggle("Toggle Instashoots", self.instashoot, ::instashoot);
            self addOpt("Spawn Slide @ Crosshairs", ::slide);

            spawnOptionsActions = strTok("Bounce;Platform;Crate", ";");
            spawnOptionsIDs     = strTok("bounce;platform;crate", ";");
            self addSliderString("Spawn @ Feet", spawnOptionsIDs, spawnOptionsActions, ::doSpawnOption);
            break;

            case "sK":  // Binds Menu (main submenu)
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb");
            self addOpt("Cowboy Bind", ::newMenu, "cwby");
            self addOpt("Reverse Cowboy Bind", ::newMenu, "rcwby");
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
            self addOpt("Nac Mod Bind", ::newMenu, "nmod");
            self addOpt("Skree Bind", ::newMenu, "skree");
            self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
            self addOpt("Third Eye Bind", ::newMenu, "tEye");
            break;

        case "tEye":
            self addMenu("tEye", "Third Eye Bind");
            self addOpt("Third Eye Bind: [{+actionslot 1}]", ::empbind, 1);
            self addOpt("Third Eye Bind: [{+actionslot 2}]", ::empbind, 2);
            self addOpt("Third Eye Bind: [{+actionslot 3}]", ::empbind, 3);
            self addOpt("Third Eye Bind: [{+actionslot 4}]", ::empbind, 4);
            break;

        case "cwby":
            self addMenu("cwby", "Cowboy Bind");
            self addOpt("Cowboy Bind: [{+actionslot 1}]", ::cowboyBind, 1);
            self addOpt("Cowboy Bind: [{+actionslot 2}]", ::cowboyBind, 2);
            self addOpt("Cowboy Bind: [{+actionslot 3}]", ::cowboyBind, 3);
            self addOpt("Cowboy Bind: [{+actionslot 4}]", ::cowboyBind, 4);
            break;


        case "rcwby":  // Reverse Cowboy Bind submenu
            self addMenu("rcwby", "Reverse Cowboy Bind");
            self addOpt("Reverse Cowboy Bind: [{+actionslot 1}]",  ::rvrsCowboyBind, 1);
            self addOpt("Reverse Cowboy Bind: [{+actionslot 2}]",  ::rvrsCowboyBind, 2);
            self addOpt("Reverse Cowboy Bind: [{+actionslot 3}]",  ::rvrsCowboyBind, 3);
            self addOpt("Reverse Cowboy Bind: [{+actionslot 4}]",  ::rvrsCowboyBind, 4);
            break;

        case "gflip":  // Mid Air GFlip Bind submenu
            self addMenu("gflip", "Mid Air GFlip Bind");
            self addOpt("GFlip: [{+actionslot 1}]",  ::gFlipBind,1);
            self addOpt("GFlip: [{+actionslot 2}]",  ::gFlipBind,2);
            self addOpt("GFlip: [{+actionslot 3}]",  ::gFlipBind,3);
            self addOpt("GFlip: [{+actionslot 4}]",  ::gFlipBind,4);
            break;

        case "nmod":  // Nac Mod Bind submenu
            self addMenu("nmod", "Nac Mod Bind");
            self addOpt("Save Nac Weapon 1", ::nacModSave, 1);
            self addOpt("Save Nac Weapon 2", ::nacModSave, 2);
            self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind,1);
            self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind,2);
            self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind,3);
            self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind,4);
            break;

        case "skree":  // Skree Bind submenu
            self addMenu("skree", "Skree Bind");
            self addOpt("Save Skree Weapon 1", ::skreeModSave, 1);
            self addOpt("Save Skree Weapon 2", ::skreeModSave, 2);
            self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind,1);
            self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind,2);
            self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind,3);
            self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind,4);
            break;

        case "cnzm":  // Can Zoom Bind submenu
            self addMenu("cnzm", "Can Zoom Bind");
            self addOpt("Canzoom: [{+actionslot 1}]", ::Canzoom,1);
            self addOpt("Canzoom: [{+actionslot 2}]", ::Canzoom,2);
            self addOpt("Canzoom: [{+actionslot 3}]", ::Canzoom,3);
            self addOpt("Canzoom: [{+actionslot 4}]", ::Canzoom,4);
            break;

        case "cb":  // Change Class Bind submenu
            self addMenu("cb", "Change Class Bind");
            self addOpt("Bind Class 1: [{+actionslot 1}]",  ::class1);
            self addOpt("Bind Class 2: [{+actionslot 1}]",  ::class2);
            self addOpt("Bind Class 3: [{+actionslot 1}]",  ::class3);
            self addOpt("Bind Class 4: [{+actionslot 1}]",  ::class4);
            self addOpt("Bind Class 5: [{+actionslot 1}]",  ::class5);
            break;

        case "tp":  // Teleport Menu
    self addMenu("tp", "Teleport Menu");
    self addOpt("Set Spawn", ::spawn_set);
    self addOpt("Unset Spawn", ::unsetSpawn);
    self addToggle("Save & Load", self.snl, ::saveandload);

    tpNames = [];
    tpCoords = [];

    if(getDvar("mapname") == "mp_crash")
    {
        tpNames   = strTok("Bomb Spawn OOM;Roof Way Out;Hilltop;Great Wall", ";");
        tpCoords  = [
            (524.595, 3381.14, 824.126),
            (-2802.75, -3663.08, 1112.13),
            (6778.43, 1326.18, 715.940),
            (5795.25, -223.995, 584.125)
        ];
    }
    else if(getDvar("mapname") == "mp_overgrown")
    {
        tpNames  = strTok("Water Tower;A Barrier Sui;River Bed Sui", ";");
        tpCoords = [
            (3082.29, -2284.81, 992.126),
            (-1972.75, -1927.23, 992.126),
            (1351.02, 536.997, 992.126)
        ];
    }
    else if(getDvar("mapname") == "mp_storm")
    {
        tpNames  = strTok("A OOM Tower 1;A OOM Tower 2;B OOM Tower 1;Construction Spot", ";");
        tpCoords = [
            (162.407, 3400.21, 1528.14),
            (1362.07, 2732.52, 1068.14),
            (1055.09, -4464.07, 1360.14),
            (-2425, -3082.99, 537.626)
        ];
    }
    else if(getDvar("mapname") == "mp_abandon")
    {
        tpNames  = strTok("Flying Saucer;Overpass;Top of Dome", ";");
        tpCoords = [
            (290.325, 1858.08, 1429.96),
            (677.383, 9410.43, 468.126),
            (-3231.82, -4795.27, 1175.17)
        ];
    }
    else if(getDvar("mapname") == "mp_fuel2")
    {
        tpNames  = strTok("White Tower 1;White Tower 2;Edge of Map", ";");
        tpCoords = [
            (3767.23, -1541.8, 747.095),
            (-2869.46, -92.1384, 1018.86),
            (-11856.7, -4897.51, 1451.46)
        ];
    }
    else if(getDvar("mapname") == "mp_afghan")
    {
        tpNames  = strTok("A Barrier;B Barrier;Cliff Barrier", ";");
        tpCoords = [
            (1507.01, -1331.07, 1296.14),
            (-1435.34, 2687.04, 1296.14),
            (1083.92, 4634.11, 1296.14)
        ];
    }
    else if(getDvar("mapname") == "mp_derail")
    {
        tpNames  = strTok("Yellow Roof;Mountain Ridge;Mountain Peak 1;Mountain Peak 2;Water Tower", ";");
        tpCoords = [
            (-3350.53, -1807.69, 874.126),
            (-6810.06, 856.458, 1872.87),
            (-9719.58, -5325.42, 2553.49),
            (14557.4, -2865.92, 3640.28),
            (-784.772, -1109.62, 695.126)
        ];
    }
    else if(getDvar("mapname") == "mp_estate")
    {
        tpNames  = strTok("A Barrier;B Barrier;Spawn Sui;Hella Far Tree", ";");
        tpCoords = [
            (2415.35, 253.95, 1216.14),
            (1373.09, 4469.03, 1216.14),
            (-4013.6, -1291.56, 1216.14),
            (-712.487, 8924.99, 2038.55)
        ];
    }
    else if(getDvar("mapname") == "mp_favela")
    {
        tpNames  = strTok("A Building OOM;Top of Sign;Defenders Undermap;Attackers Undermap;Jesus Statue;Yellow Building;Cliff Sui", ";");
        tpCoords = [
            (1725.92, -1694.85, 728.126),
            (-1807.83, -504.29, 672.126),
            (-99.8282, -1538.56, -41.876),
            (1813.92, 2064.69, 145.143),
            (9671.63, 18431.6, 13604.1),
            (-7818.56, -514.921, 928.126),
            (-7489.34, -11022.7, 1696.42)
        ];
    }
    else
    {
        tpNames  = strTok("^1Soon...", ";");
        tpCoords = [(0,0,0)];
    }

    self addSliderString("Teleport Spot", tpCoords, tpNames, ::DoTeleport);
break;

// CLASS MENU
case "class":
    self addMenu("class", "Class Menu");
    self addOpt("Option 1", ::test);
    self addOpt("Option 2", ::test);
    self addOpt("Option 3", ::test);
    self addOpt("Option 4", ::test);
    self addOpt("Option 5", ::test);
    break;


// Afterhits Menu
case "afthit":
    self addMenu("afthit", "Afterhits Menu");

    gunIDs = strtok("wa2000_mp;scar_mp;fal_mp;m4_mp;ak47_mp;mp5k_mp;uzi_mp;p90_mp;kriss_mp;tmp_mp", ";");
    gunNames = strtok("WA2000;SCAR-H;FAL;M4;AK-47;MP5K;Uzi;P90;Vector (Kriss);TMP", ";");
    self addSliderString("Guns", gunIDs, gunNames, ::afterhit);

    specIDs = strtok("claymore_mp;briefcase_bomb_mp;onemanarmy_mp;c4_mp;killstreak_ac130_mp;gl_masada_mp", ";");
    specNames = strtok("Claymore;Bomb;One Man Army;C4;AC130;GL Masada", ";");
    self addSliderString("Special", specIDs, specNames, ::afterhit);
    break;


case "kstrks": 
    self addMenu("kstrks", "Killstreak Menu");
    self addOpt("Fill Streaks", ::fillStreaks); 
    self addOpt("UAV", ::doKillstreak, "uav");
    self addOpt("Care Package", ::doKillstreak, "airdrop");
    self addOpt("Counter UAV", ::doKillstreak, "counter_uav");
    self addOpt("Sentry Gun", ::doKillstreak, "airdrop_sentry_minigun");
    self addOpt("Predator Missile", ::doKillstreak, "predator_missile");
    self addOpt("Precision Airstrike", ::doKillstreak, "precision_airstrike");
    self addOpt("Harrier Airstrike", ::doKillstreak, "harrier_airstrike");
    self addOpt("Attack Helicopter", ::doKillstreak, "helicopter");
    self addOpt("Emergency Airdrop", ::doKillstreak, "airdrop_mega");
    self addOpt("Chopper", ::doKillstreak, "helicopter_flares");
    self addOpt("Stealth Bomber", ::doKillstreak, "stealth_airstrike");
    self addOpt("Chopper Gunner", ::doKillstreak, "helicopter_minigun");
    self addOpt("AC-130", ::doKillstreak, "ac130");
    self addOpt("EMP", ::doKillstreak, "emp");
    self addOpt("Tactical Nuke", ::doKillstreak, "nuke");
    break;


case "host":  //(host/dev only)
            self addMenu("host", "Host Options");
            self addOpt("^2Clients^7 Menu", ::newMenu, "Verify");
            self addOpt("Toggle Floaters", ::togglelobbyfloat);
            
            hostActions = strTok("Fast Restart;End Game", ";");     
            hostIDs     = strTok("FastRestart;debugexit", ";");  
            self addSliderString("Restart/End", hostIDs, hostActions, ::doHostAction);

            self addOpt("Ladder Bounce", ::reverseladders);
            self addOpt("Add 1 Minute", ::editTime, "add");
            self addOpt("Remove 1 Minute", ::editTime, "subtract");
            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
            self addOpt("Teleport Bots to Crosshairs", ::tpBots);
            self addOpt("Kick Bots", ::kickAllBots);
            self addOpt("Fill Bots", ::SpawnBotsAmount,18); 
            break;
    }
    self clientOptions();
}

clientOptions()
{   
    if(self isHost() || self isdeveloper())
    {
        self addMenu("Verify", "^2Clients^7 Menu");

        foreach(player in level.players)
        {
            if(!player.pers["isBot"])
                self addOpt(player getName(), ::newmenu, "Verify_" + player getentitynumber());
        }
        foreach(player in level.players)
        {
            if(!player.pers["isBot"])
            {
                self addMenu("Verify_" + player getentitynumber(), player getName());
                self addOpt("Kick Player", ::kickSped, player);
                self addOpt("Ban Player", ::banSped, player);    
            }
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
                    if( self meleeButtonPressed() && self adsButtonPressed() )
                    {
                        self menuOpen();
                        wait .2;
                    }               
                }
                else{
                    if(self isButtonPressed("+actionslot 1") || self isButtonPressed("+actionslot 2"))
                    {
                        if(!self isButtonPressed("+actionslot 1") || !self isButtonPressed("+actionslot 2"))
                        {
                            if(!self isButtonPressed("+actionslot 1"))
                                self.menu[ self getCurrentMenu() + "_cursor" ] += self isButtonPressed("+actionslot 2");
                            if(!self isButtonPressed("+actionslot 2"))
                                self.menu[ self getCurrentMenu() + "_cursor" ] -= self isButtonPressed("+actionslot 1");

                            self scrollingSystem();
                            wait .08;
                        }
                    }
                    else if(self isButtonPressed("+actionslot 3") || self isButtonPressed("+actionslot 4")){
                        if(!self isButtonPressed("+actionslot 3") || !self isButtonPressed("+actionslot 4"))
                        {
                            if(isDefined(self.eMenu[ self getCursor() ].val) || IsDefined( self.eMenu[ self getCursor() ].ID_list ))
                            {
                                if( self isButtonPressed("+actionslot 3") )   
                                    self updateSlider( "L2" );
                                if( self isButtonPressed("+actionslot 4") )    
                                    self updateSlider( "R2" );
                                wait .1;
                            }
                        }
                    }
                    else if( self useButtonPressed() )
                    {
                        player = self.selected_player;
                        menu = self.eMenu[self getCursor()];

                        if( player != self && self isHost() )
                        {
                            player.was_edited = true;
                            self iPrintLnBold( menu.opt + " Has Been Activated" );
                        }
                        
                        if( self.eMenu[ self getCursor() ].func == ::newMenu && self != player )
                            self iPrintLnBold( "^1Error: ^7Cannot Access Menus While In A Selected Player" );
                        else if(isDefined(self.sliders[ self getCurrentMenu() + "_" + self getCursor() ]))
                        {
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
        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2, "TOPLEFT", "CENTER", self.presets["X"] + 109, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]); #endif
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