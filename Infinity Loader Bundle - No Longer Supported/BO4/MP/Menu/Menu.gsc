    printOrigin()
    {
        ilog(self getorigin());
    }

    printmapname()
    {
        ilog(level.currentMapName );
    }

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
            if(self.access > 0)
            {
                self addMenu("main", "Main Menu");
                //self addOpt("Log mapname", ::printmapname, undefined, undefined);
                //self addOpt("Log origin", ::printOrigin, undefined, undefined);
                self addOpt("Trickshot Menu", ::newMenu, "ts", undefined);
                self addOpt("Binds Menu", ::newMenu, "sK", undefined);
                self addOpt("Teleport Menu", ::newMenu, "tp", undefined);
                self addOpt("Class Menu", ::newMenu, "class", undefined);
                self addOpt("Afterhits Menu", ::newMenu, "afthit", undefined);
                self addOpt("Killstreak Menu", ::newMenu, "kstrks", undefined);
                self addOpt("Customization Menu", ::newMenu, "custom", undefined);

                if(self ishost() || self isDeveloper())
                    self addOpt("Host Options", ::newMenu, "host", undefined);
            }
            break;

            case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addOpt("Spawnables", ::newMenu, "spawnables", undefined);
            self addToggle("Noclip [{+frag}]", self.NoClip, ::initNoClip);

            if( level.currentGametype == "dm" )
                self addOpt("Go for Two Piece", ::doTwoPiece, undefined, undefined);
            
            canOpts = ["Current", "Infinite"];
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode, undefined, undefined);

            //self addToggle("Instashoots", self.instashoot, ::instashoot);
            break;

            case "spawnables":
            self addMenu("spawnables", "Spawnables");

            spawnOptions = ["Spawn", "Delete"];

            self addSliderString("Slide", spawnOptions, spawnOptions, ::doSpawnables, "slide", undefined);
            self addSliderString("Bounce", spawnOptions, spawnOptions, ::doSpawnables, "bounce", undefined);
            self addSliderString("Platform", spawnOptions, spawnOptions, ::doSpawnables, "platform", undefined);
            self addSliderString("Crate", spawnOptions, spawnOptions, ::doSpawnables, "crate", undefined);
            break;

            case "sK":
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb", undefined);
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip", undefined);
            self addOpt("Nac Mod Bind", ::newMenu, "nmod", undefined);
            self addOpt("Skree Bind", ::newMenu, "skree", undefined);
            self addOpt("Can Zoom Bind", ::newMenu, "cnzm", undefined);
            break;

            case "gflip":
            self addMenu("gflip", "Mid Air GFlip Bind");
            self addOpt("GFlip: [{+actionslot 1}]", ::gFlipBind, 1, undefined);
            self addOpt("GFlip: [{+actionslot 2}]", ::gFlipBind, 2, undefined);
            self addOpt("GFlip: [{+actionslot 3}]", ::gFlipBind, 3, undefined);
            self addOpt("GFlip: [{+actionslot 4}]", ::gFlipBind, 4, undefined);
            break;

            case "nmod":
            self addMenu("nmod", "Nac Mod Bind");
            self addOpt("Save Nac Weapon 1", ::nacModSave, 1, undefined);
            self addOpt("Save Nac Weapon 2", ::nacModSave, 2, undefined);
            self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind, 1, undefined);
            self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind, 2, undefined);
            self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind, 3, undefined);
            self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind, 4, undefined);
            break;

            case "skree":
            self addMenu("skree", "Skree Bind");
            self addOpt("Save Skree Weapon 1", ::skreeModSave, 1, undefined);
            self addOpt("Save Skree Weapon 2", ::skreeModSave, 2, undefined);
            self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind, 1, undefined);
            self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind, 2, undefined);
            self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind, 3, undefined);
            self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind, 4, undefined);
            break;

            case "cb":
            self addMenu("cb", "Change Class Bind");
            self addOpt("Bind Class 1: [{+actionslot 2}]", ::classBind, 1, undefined);
            self addOpt("Bind Class 2: [{+actionslot 2}]", ::classBind, 2, undefined);
            self addOpt("Bind Class 3: [{+actionslot 2}]", ::classBind, 3, undefined);
            self addOpt("Bind Class 4: [{+actionslot 2}]", ::classBind, 4, undefined);
            self addOpt("Bind Class 5: [{+actionslot 2}]", ::classBind, 5, undefined);
            self addOpt("Bind Class 6: [{+actionslot 2}]", ::classBind, 6, undefined);
            self addOpt("Bind Class 7: [{+actionslot 2}]", ::classBind, 7, undefined);
            self addOpt("Bind Class 8: [{+actionslot 2}]", ::classBind, 8, undefined);
            self addOpt("Bind Class 9: [{+actionslot 2}]", ::classBind, 9, undefined);
            self addOpt("Bind Class 10: [{+actionslot 2}]", ::classBind, 10, undefined);
            self addOpt("Bind Class 11: [{+actionslot 2}]", ::classBind, 11, undefined);
            self addOpt("Bind Class 12: [{+actionslot 2}]", ::classBind, 12, undefined);
            break;

            case "cnzm":
            self addMenu("cnzm", "Can Zoom Bind");
            self addOpt("Canzoom: [{+actionslot 1}]", ::Canzoom, 1, undefined);
            self addOpt("Canzoom: [{+actionslot 2}]", ::Canzoom, 2, undefined);
            self addOpt("Canzoom: [{+actionslot 3}]", ::Canzoom, 3, undefined);
            self addOpt("Canzoom: [{+actionslot 4}]", ::Canzoom, 4, undefined);
            break;

            case "tp":
            self addMenu("tp", "Teleport Menu");
            self addOpt("Set Spawn",::setSpawn, undefined, undefined);
            self addOpt("Unset Spawn", ::unsetSpawn, undefined, undefined);
            self addToggle("Save Position", self.posSaved, ::savepos);
            self addOpt("Load Saved Position", ::loadpos, undefined, undefined);

            if( level.currentMapName == "mp_urban" )
            {
                tpNames = [ "Diaylser Roof", "Burning Roof", "Bridge" ];
                tpCoords = [
                    (2450.33, -4818.56, 1288.13),
                    (2840.32, -14859.1, 2528.13),
                    (-1059.83, -11946.2, 682.125)
                ];
            }

            else if( level.currentMapName == "mp_firingrange2" )
            {
                tpNames = [ "Fake Wall" ];
                tpCoords = [
                    (-984.138, 2770.91, 352.125)
                ];
            }

            else if( level.currentMapName == "mp_gridlock" )
            {
                tpNames = [ "Skyscraper", "Rooftop 1", "Rooftop 2" ];
                tpCoords = [
                    (-6050.89, -1504.37, 5248.13),
                    (-3942.97, 2507.15, 3150.16),
                    (5346.97, -1371.38, 1561.13)
                ];
            }

            else if( level.currentMapName == "mp_hacienda" )
            {
                tpNames = [ "Top of Ridge" ];
                tpCoords = [
                    (3863.79, 16918.8, 2300.19)
                ];
            }

            else if( level.currentMapName == "mp_icebreaker" )
            {
                tpNames = [ "Ship Crane", "Top of Ship", "Sub Fin", "Cliff" ];
                tpCoords = [
                    (-6925.67, -5941.42, 1536.13),
                    (-4416.57, -4158.66, 2440.34),
                    (-5834.78, 6017.78, 439.146),
                    (8755.7, 9489.74, 4558.17)
                ];
            }

            else if( level.currentMapName == "mp_morocco" )
            {
                tpNames = [ "OOM Wall" ];
                tpCoords = [
                    (3404.08, 3542.47, 504.125)
                ];
            }

            else if( level.currentMapName == "mp_silo" )
            {
                tpNames = [ "Silo Roof 1", "Silo Roof 2", "Undermap" ];
                tpCoords = [
                    (-5707.78, -13806.4, 3228.71),
                    (-6413.69, -4671.71, 2233.13),
                    (-10254.5, -7305.75, 184.056)
                ];
            }

            else if( level.currentMapName == "mp_seaside" )
            {
                tpNames = [ "Bridge Spot" ];
                tpCoords = [
                    (3322.95, -1148.41, 584.125)
                ];
            }

            else if( level.currentMapName == "" )
            {
                tpNames = [];
                tpCoords = [

                ];
            }

            else if( level.currentMapName == "" )
            {
                tpNames = [];
                tpCoords = [

                ];
            }

            break;

            case "class":
            self addMenu("class", "Class Menu");
            self addOpt("Weapons", ::newMenu, "wpns", undefined);
            self addOpt("Attachments", ::test, undefined, undefined);
            self addOpt("Camos", ::test, undefined, undefined);
            self addOpt("Lethals", ::test, undefined, undefined);
            self addOpt("Tacticals", ::test, undefined, undefined);
            //self addDvarToggle("Save Loadout", "loadoutSaved", ::test);
            self addOpt("Take Weapon", ::takeWpn, undefined, undefined);
            self addOpt("Drop Weapon", ::dropWpn, undefined, undefined);
            break;

            case "wpns":
            self addMenu("wpns", "Weapons");

            arIDs = ["ar_accurate_t8","ar_damage_t8","ar_modular_t8","ar_stealth_t8","ar_fastfire_t8","ar_standard_t8","ar_galil_t8","ar_peacekeeper_t8","ar_an94_t8","ar_doublebarrel_t8"];
            arNames = ["ICR-7","Rampart 17","KN-57","VAPR-XKG","Maddox RFB","SWAT RFT","Grav","Peacekeeper","AN-94","Doublecross"];
            self addsliderstring("Assault Rifles", arIDs, arNames, ::giveUserWeapon, undefined, undefined);

            smgIDs = ["smg_standard_t8","smg_accurate_t8","smg_fastfire_t8","smg_capacity_t8","smg_handling_t8","smg_fastburst_t8","smg_folding_t8","smg_vmp_t8","smg_minigun_t8"];
            smgNames = ["MX9","GKS","Spitfire","Cordite","SAUG 9mm","Daemon 3XB","Switchblade X9","VMP","Micromg 9mm"];
            self addsliderstring("Submachine Guns", smgIDs, smgNames, ::giveUserWeapon, undefined, undefined);

            trIDs = ["tr_powersemi_t8","tr_midburst_t8","tr_longburst_t8","tr_flechette_t8","tr_damageburst_t8"];
            trNames = ["Auger DMR","ABR 223","Swordfish","S6 Stingray","M16"];
            self addsliderstring("Tactical Rifles", trIDs, trNames, ::giveUserWeapon, undefined, undefined);

            lmgIDs = ["lmg_standard_t8","lmg_spray_t8","lmg_heavy_t8","lmg_stealth_t8"];
            lmgNames = ["Titan","Hades","VKM 750","Tigershark"];
            self addsliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon, undefined, undefined);

            srIDs = ["sniper_powerbolt_t8","sniper_fastrechamber_t8","sniper_powersemi_t8","sniper_quickscope_t8","sniper_mini14_t8","sniper_locus_t8","sniper_damagesemi_t8"];
            srNames = ["Paladin HB50","Outlaw","SDM","Koshka","Vendetta","Locus","Havelina AA50"];
            self addsliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon, undefined, undefined);

            pstlIDs = ["pistol_standard_t8","pistol_burst_t8","pistol_revolver_t8","pistol_fullauto_t8"];
            pstlNames = ["Strife","RK7 Garrison","Mozu","KAP-45"];
            self addsliderstring("Pistols", pstlIDs, pstlNames, ::giveUserWeapon, undefined, undefined);

            sgIDs = ["shotgun_pump_t8","shotgun_semiauto_t8","shotgun_fullauto_t8","shotgun_precision_t8"];
            sgNames = ["MOG 12","SG12","Rampage","Argus"];
            self addsliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon, undefined, undefined);

            lnchrIDs = ["launcher_standard_t8"];
            lnchrNames = ["Hellion Salvo"];
            self addsliderstring("Launchers", lnchrIDs, lnchrNames, ::giveUserWeapon, undefined, undefined);

            meleeIDs = ["knife_loadout","melee_secretsanta_t8","melee_slaybell_t8","melee_demohammer_t8","melee_coinbag_t8","melee_club_t8","melee_cutlass_t8","melee_stopsign_t8","melee_zombiearm_t8","melee_actionfigure_t8","melee_amuletfist_t8"];
            meleeNames = ["Combat Knife","Secret Santa","Slay Bell","Home Wrecker","Cha-Ching","Nifo'oti","Rising Tide","Full Stop","Backhander","Series 6 Outrider","Eye of Apophis"];
            self addsliderstring("Melee", meleeIDs, meleeNames, ::giveUserWeapon, undefined, undefined);

            specIDs = ["special_ballisticknife_t8_dw","special_ballisticknife_t8_dw_dw","special_crossbow_t8"];
            specNames = ["Ballistic Knife","Dual Ballistic Knife","Reaver C86"];
            self addsliderstring("Special", specIDs, specNames, ::giveUserWeapon, undefined, undefined);

            miscIDs = ["bare_hands","defaultweapon","ball","melee_bowie_bloody","ray_gun"];
            miscNames = ["Fists","Default Weapon","Uplink Ball","Bowie Knife","Ray Gun"];
            self addsliderstring("Miscellaneous", miscIDs, miscNames, ::giveUserWeapon, undefined, undefined);
            break;

            case "afthit":
            self addMenu("afthit", "Afterhit Menu");
            self addOpt("Option 1", ::test, undefined, undefined);
            self addOpt("Option 2", ::test, undefined, undefined);
            self addOpt("Option 3", ::test, undefined, undefined);
            self addOpt("Option 4", ::test, undefined, undefined);
            self addOpt("Option 5", ::test, undefined, undefined);
            break;

            case "kstrks":
            self addMenu("kstrks", "Killstreak Menu");

            //self addOpt("Fill Streaks", ::give_killstreaks, undefined, undefined);

            kstrkIDs = [ "dart_mp", "recon_car_mp", "uav_mp", "", "counteruav_mp", "" ];
            kstrkNames = [ "Dart", "RC-XD", "UAV", "Care Package", "Counter-UAV", "Lightning Strike", "Sentry", "Hellstorm", "Drone Squad", "Sniper's Nest", "Mantis", "Thresher", "Attack Chopper", "Strike Team", "Gunship" ];

            for( i = 0; i < kstrkIDs.size; i++ )
                self addOpt(kstrkNames[i], ::test, kstrkIDs[i], undefined);
            break;

            case "custom":
            self addMenu("custom", "Customization Menu");

            bindIDs = ["+speed_throw","+smoke","+attack","+frag","+actionslot 1","+actionslot 2","+actionslot 3","+actionslot 4","+melee"];
            bindNames = ["[{+speed_throw}]","[{+smoke}]","[{+attack}]","[{+frag}]","[{+actionslot 1}]","[{+actionslot 2}]","[{+actionslot 3}]","[{+actionslot 4}]","[{+melee}]"];
            self addSliderString("Menu Bind 1", bindIDs, bindNames, ::updatePreset, "menuBindOne", undefined);
            
            bind2IDs = ["+speed_throw","+smoke","+attack","+frag","+actionslot 1","+actionslot 2","+actionslot 3","+actionslot 4","+melee","none"];
            bind2Names = ["[{+speed_throw}]","[{+smoke}]","[{+attack}]","[{+frag}]","[{+actionslot 1}]","[{+actionslot 2}]","[{+actionslot 3}]","[{+actionslot 4}]","[{+melee}]","None"];
            self addSliderString("Menu Bind 2", bind2IDs, bind2Names, ::updatePreset, "menuBindTwo", undefined);
            
            self addDvarToggle("Menu Instructions", "menuInst", ::toggleMenuInst);
            //self addDvarToggle("Almost Hits", "almostHits", ::toggleAlmostHits);
            self addDvarToggle("Distance", "showDistance", ::toggleDistanceMsg);
            self addSliderValue("X Position", int( self LoadPreset( "menuPosX", "155" ) ), -565, 315, 80, ::updatePreset, "menuPosX" );
            self addSliderValue("Y Position", int( self LoadPreset( "menuPosY", "-20" ) ), -180, 300, 80, ::updatePreset, "menuPosY" );
            self addSliderValue("Red", int( self LoadPreset( "menuColorRed", "0" ) ), 0, 255, 15, ::updatePreset, "menuColorRed" );
            self addSliderValue("Green", int( self LoadPreset( "menuColorGreen", "100" ) ), 0, 255, 15, ::updatePreset, "menuColorGreen" );
            self addSliderValue("Blue", int( self LoadPreset( "menuColorBlue", "255" ) ), 0, 255, 15, ::updatePreset, "menuColorBlue" );
            break;

            case "host":
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify", undefined);
            self addOpt("Lobby Settings", ::newMenu, "lobby", undefined);
        
            break;

            case "lobby":
            self addMenu("lobby", "Lobby Settings");

            self addOpt("Option 1", ::test, undefined, undefined);
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
                perm = "None";
                if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                    perm = level.status[player.access];
                
                if (player isDeveloper())
                    perm = perm + " ^7| ^6Developer";

                self addOpt(player getname() + " [" + perm + "^7]", ::newmenu, "Verify_" + player getXUID(), undefined);
            }

            foreach(player in level.players)
            {
                perm2 = "None";
                if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                    perm2 = level.status[player.access];
                self addMenu("Verify_" + player getXUID(), player getName() + " [" + perm2 + "^7]");
                self addOpt("Change Access Level", ::newMenu, "access", undefined);

                self addMenu("access", "Change Access Level");
                self addOpt("[None]", ::initializesetup, 0, player);
                self addOpt("[^2Verified^7]", ::initializesetup, 1, player);
                self addOpt("[^5CoHost^7]", ::initializesetup, 2, player);
                self addOpt("[^1Host^7]", ::initializesetup, 3, player);
            }
        }
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
            
        self.menu["UI"]["MENU_TITLE"] = self createtext("default", 2, "TOPLEFT", "CENTER", self.presets["X"] + 115, self.presets["Y"] - 105, 5, 1, level.MenuName, (0, 0, 0), self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 55.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1); 
        self resizeMenu();
    }

    menuMonitor()
    {
        self endon("disconnect");
        self endon("end_menu");

        while( isDefined(self.access) && self.access != 0 )
        {
            if(!self.menu["isOpen"])
            {
                if( self actionslottwobuttonpressed() && self adsButtonPressed() )
                {
                    self menuOpen();
                    wait .2;
                }
            }
            
            else
            {
                if( self actionslottwobuttonpressed() && self adsButtonPressed() )
                {
                    self menuClose();
                    wait .2;
                }
                else if(self actionslotonebuttonpressed() || self actionslottwobuttonpressed())
                {
                    if(!self actionslotonebuttonpressed() || !self actionslottwobuttonpressed())
                    {
                        if(!self actionslotonebuttonpressed())
                            self.menu[ self getCurrentMenu() + "_cursor" ] += self actionslottwobuttonpressed();
                        if(!self actionslottwobuttonpressed())
                            self.menu[ self getCurrentMenu() + "_cursor" ] -= self actionslotonebuttonpressed();

                        self scrollingSystem();
                        wait .08;
                    }
                }
                else if(self actionslotthreebuttonpressed() || self actionslotfourbuttonpressed())
                {
                    cursor = self getCursor();
                    if(isDefined(self.eMenu) && isDefined(self.eMenu[cursor]))
                    {
                        if(isDefined(self.eMenu[cursor].val) || IsDefined( self.eMenu[cursor].ID_list ))
                        {
                            if( self actionslotthreebuttonpressed() )   
                                self updateSlider( "L2" );
                            if( self actionslotfourbuttonpressed() )    
                                self updateSlider( "R2" );
                            wait .1;
                        }
                    }
                }

                else if( self useButtonPressed() )
                {
                    cursor = self getCursor();
                    if(isDefined(self.eMenu) && isDefined(self.eMenu[cursor]))
                    {
                        player = self.selected_player;
                        menu = self.eMenu[cursor];

                        if( player != self && self isHost() )
                        {
                            player.was_edited = true;
                            self iPrintLnBold( menu.opt + " Has Been Activated" );
                        }
                        
                        if(isDefined(menu.submenu) && menu.submenu)
                        {
                            if(self != player)
                                self iPrintLnBold( "^1ERROR: ^7Cannot Access Menus While In A Selected Player" );
                            else
                                self newMenu(menu.p1, "");
                        }
                        else if(isDefined(self.sliders[ self getCurrentMenu() + "_" + cursor ]))
                        {
                            slider = self.sliders[ self getCurrentMenu() + "_" + cursor ];
                            slider = (IsDefined( menu.ID_list ) ? menu.ID_list[slider] : slider);
                            player thread doOption( menu.func, slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );
                        }
                        
                        else 
                            player thread doOption( menu.func, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5, undefined );

                        wait .05;
                        if(IsDefined( menu.toggle ))
                            self setMenuText();
                        if( player != self )
                            self.menu["UI"]["MENU_TITLE"] settext( self.menuTitle + " ("+ player getName() +")");
                        wait .15;
                        if( isDefined(player.was_edited) && self isHost() )
                            player.was_edited = undefined;
                    }
                    wait .05;
                }
                else if( self meleeButtonPressed() )
                {
                    if( self.selected_player != self )
                    {
                        self.selected_player = self;
                        self setMenuText();
                        self refreshTitle();
                    }
                    else if( self getCurrentMenu() == "main" )
                        self menuClose();
                    else 
                        self newMenu( "", "" );
                    wait .2;
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
        self.menu["isOpen"] = false;

        self destroyAll(self.menu["UI"]);
        self destroyAll(self.menu["OPT"]);
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);
        self destroyAll(self.menu["UI_STRING"]);

        self.menu["UI"] = [];
        self.menu["OPT"] = [];
        self.menu["UI_TOG"] = [];
        self.menu["UI_SLIDE"] = [];
        self.menu["UI_STRING"] = [];
    }

    drawText()
    {
        self destroyAll(self.menu["OPT"]);

        if(!isDefined(self.menu["OPT"]))
            self.menu["OPT"] = [];

        for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText(self.presets["Option_Font"], self.presets["Font_Scale"], "LEFT", "CENTER", self.presets["X"] + 5, self.presets["Y"] - 62 + (e * 15), 3, 1, "", (0, 0, 0), self.presets["Text"]);
    }

    refreshTitle()
    {
        if(isDefined(self.menu["UI"]) && isDefined(self.menu["UI"]["MENU_TITLE"]))
            self.menu["UI"]["MENU_TITLE"] settext(level.MenuName);
    }
        
    scrollingSystem()
    {
        if(!isDefined(self.eMenu) || self.eMenu.size <= 0)
            return;

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
        if(!isDefined(self.eMenu) || self.eMenu.size <= 0)
            return;

        curs = (self getCursor() >= 10) ? 9 : self getCursor();  
        if(isDefined(self.menu["UI"]) && isDefined(self.menu["UI"]["SCROLLER"]) && isDefined(self.menu["OPT"]) && isDefined(self.menu["OPT"][curs]))
            self.menu["UI"]["SCROLLER"].y = self.menu["OPT"][curs].y;
    } 

    setMenuText()
    {
        self endon("disconnect");

        self menuoptions();
        self resizeMenu();

        if(!isDefined(self.menu["OPT"]))
            return;

        ary = (self getCursor() >= 10) ? (self getCursor() - 9) : 0;
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);

        for(e = 0; e < 10; e++)
        {
            self.menu["OPT"][e].x = self.presets["X"] + 61;

            if(!isDefined(self.eMenu[ary + e]))
            {
                self.menu["OPT"][e] settext("");
                continue;
            }

            if(isDefined(self.eMenu[ary + e].opt))
                self.menu["OPT"][e] settext(self.eMenu[ary + e].opt);
            else
                self.menu["OPT"][e] settext("");

            if(isDefined(self.eMenu[ary + e].toggle))
            {
                self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["OPT"][e].x + 189, self.menu["OPT"][e].y, 7, 7, (self.eMenu[ary + e].toggle) ? self.presets["Toggle_BG"] : dividecolor(150, 150, 150), "white", 5, 1);
            }

            if(isDefined(self.eMenu[ary + e].val))
            {
                if(!isDefined(self.sliders[self getCurrentMenu() + "_" + (ary + e)]))
                    self.sliders[self getCurrentMenu() + "_" + (ary + e)] = self.eMenu[ary + e].val;

                self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 38, 1, (0,0,0), "white", 4, 1);
                self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 188, self.menu["UI_SLIDE"][e].y, 1, 6, self.presets["Toggle_BG"], "white", 5, 1);

                if(self getCursor() == (ary + e))
                    self.menu["UI_SLIDE"]["VAL"] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 150, self.menu["OPT"][e].y, 5, 1, self.sliders[self getCurrentMenu() + "_" + (ary + e)] + "", (0, 0, 0), self.presets["Text"]);

                self updateSlider("", e, ary + e);
            }

            if(isDefined(self.eMenu[ary + e].ID_list))
            {
                if(!isDefined(self.sliders[self getCurrentMenu() + "_" + (ary + e)]))
                    self.sliders[self getCurrentMenu() + "_" + (ary + e)] = 0;

                self.menu["UI_SLIDE"]["STRING_" + e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 6, 1, "", (0, 0, 0), self.presets["Text"]);
                self updateSlider("", e, ary + e);
            }

            if(isDefined(self.eMenu[ary + e].submenu) && self.eMenu[ary + e].submenu)
            {
                self.menu["UI_SLIDE"]["SUBMENU" + e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 196, self.menu["OPT"][e].y - 0.75, 5, 1, ">", (0, 0, 0), (1,1,1));
                self.menu["UI_SLIDE"]["SUBMENU" + e].foreground = true;
            }
        }
    }
        
    resizeMenu()
    {
        if(!isDefined(self.menu["UI"]) || !isDefined(self.menu["UI"]["OPT_BG"]) || !isDefined(self.menu["UI"]["OUTLINE"]))
            return;

        size   = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
        height = int(15 * size);
        
        self.menu["UI"]["OPT_BG"] SetShader( "white", 200, height + 1 );
        self.menu["UI"]["OUTLINE"] SetShader( "white", 204, height + 54 );
    }