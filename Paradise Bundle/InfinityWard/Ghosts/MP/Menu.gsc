    menuOptions()
    {
        player = self.selected_player;        
        menu = self getCurrentMenu();
        
        player_names = [];
        foreach( players in level.players )
            player_names[player_names.size] = players.name;

        switch( menu )
        {
            case "main":
            
        if(player.access > 0)
        {
            self addMenu("main", "Main Menu");
            self addOpt("Trickshot Menu", ::newMenu, "ts");
            self addOpt("Binds Menu", ::newMenu, "sK");
            self addOpt("Teleport Menu", ::newMenu, "tp");
            self addOpt("Class Menu", ::newMenu, "class");
            self addOpt("Afterhits Menu", ::newMenu, "afthit");
            self addOpt("Killstreak Menu", ::newMenu, "kstrks");

            if(self ishost() || self isDeveloper()) 
                self addOpt("Host Options", ::newMenu, "host");
        }
        break;

    case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+frag}]", self.NoClipT, ::initNoClip);

        if(level.currentGametype == "dm")
            self addOpt("Go for Two Piece", ::dotwopiece);

            canOpts = "Current;Infinite";
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addOpt("Spawn Slide @ Crosshairs", ::slide);

            spawnOptionsActions = "Bounce;Platform;Crate";
            spawnOptionsIDs     = "bounce;platform;crate";
            self addSliderString("Spawn @ Feet", spawnOptionsIDs, spawnOptionsActions, ::doSpawnOption);
            break;

    case "sK": 
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb");
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
            self addOpt("Nac Mod Bind", ::newMenu, "nmod");
            self addOpt("Skree Bind", ::newMenu, "skree");
            self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
            self addOpt("Walking Sentry Bind", ::newMenu, "sentry");
            break;

    case "sentry":
            self addMenu("sentry", "Walking Sentry Bind");
            self addOpt("Walking Sentry Bind: [{+actionslot 1}]", ::sentryBind, 1);
            self addOpt("Walking Sentry Bind: [{+actionslot 2}]", ::sentryBind, 2);
            self addOpt("Walking Sentry Bind: [{+actionslot 3}]", ::sentryBind, 3);
            self addOpt("Walking Sentry Bind: [{+actionslot 4}]", ::sentryBind, 4);
            break;

        case "gflip":
            self addMenu("gflip", "Mid Air GFlip Bind");
            self addOpt("GFlip: [{+actionslot 1}]",  ::gFlipBind,1);
            self addOpt("GFlip: [{+actionslot 2}]",  ::gFlipBind,2);
            self addOpt("GFlip: [{+actionslot 3}]",  ::gFlipBind,3);
            self addOpt("GFlip: [{+actionslot 4}]",  ::gFlipBind,4);
            break;

        case "nmod":
            self addMenu("nmod", "Nac Mod Bind");
            self addOpt("Save Nac Weapon 1", ::nacModSave, 1);
            self addOpt("Save Nac Weapon 2", ::nacModSave, 2);
            self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind,1);
            self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind,2);
            self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind,3);
            self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind,4);
            break;

        case "skree":
            self addMenu("skree", "Skree Bind");
            self addOpt("Save Skree Weapon 1", ::skreeModSave, 1);
            self addOpt("Save Skree Weapon 2", ::skreeModSave, 2);
            self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind,1);
            self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind,2);
            self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind,3);
            self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind,4);
            break;

        case "cnzm":
            self addMenu("cnzm", "Can Zoom Bind");
            self addOpt("Canzoom: [{+actionslot 1}]", ::Canzoom,1);
            self addOpt("Canzoom: [{+actionslot 2}]", ::Canzoom,2);
            self addOpt("Canzoom: [{+actionslot 3}]", ::Canzoom,3);
            self addOpt("Canzoom: [{+actionslot 4}]", ::Canzoom,4);
            break;

        case "cb":
            self addMenu("cb", "Change Class Bind");
            self addOpt("Bind Class 1: [{+actionslot 2}]",  ::classBind,1);
            self addOpt("Bind Class 2: [{+actionslot 2}]",  ::classBind,2);
            self addOpt("Bind Class 3: [{+actionslot 2}]",  ::classBind,3);
            self addOpt("Bind Class 4: [{+actionslot 2}]",  ::classBind,4);
            self addOpt("Bind Class 5: [{+actionslot 2}]",  ::classBind,5);
            self addOpt("Bind Class 6: [{+actionslot 2}]",  ::classBind,6);
            break;

    case "tp":
    self addMenu("tp", "Teleport Menu");

    self addOpt("Set Spawn", ::setSpawn);
    self addOpt("Unset Spawn", ::unsetSpawn);
    self addToggle("Save & Load", self.snl, ::saveandload);
      
    tpNames = [];
    tpCoords = [];

    if(getDvar("mapname") == "mp_prisonbreak")
    {
        tpNames = "Hilltop 1;Hilltop 2;Waterfall;Distance Cliff 1;Distance Cliff 2;Distance Cliff 3";
        tpCoords = [
            (-5591.67, -912.814, 1947.81),
            (-6375.85, 2558.38, 2150.17),
            (-6714.49, 902.8, 1524.04),
            (-15714.5, 15693.3, 8406.34),
            (-21353.4, 11285.6, 6681.67),
            (-12926.6, -22831.8, 6063.3)
        ];
    }
    else if(getDvar("mapname") == "mp_lonestar")
    {
        tpNames = "Parking Garage Roof;";
        tpCoords = [
            (67.2244, 1788.87, 580.968)
        ];
    }
    else if(getDvar("mapname") == "mp_frag")
    {
        tpNames = "Owens Roof";
        tpCoords = [
            (-348.583, 1487.86, 921.125)
        ];
    }
    else if(getDvar("mapname") == "mp_fahrenheit")
    {
        tpNames = "Library Roof 1;Library Roof 2;Superty Union Roof;Health Center Roof";
        tpCoords = [
            (163.791, -2001, 1669.13),
            (938.147, -2729.1, 1724.02),
            (-1001.32, -4689.84, 1834.64),
            (-3062.36, -1650.35, 1057.13)
        ];
    }
    else if(getDvar("mapname") == "mp_hashima")
    {
        tpNames = "Complex Roof;Complex Ledge;Warehouse Roof";
        tpCoords = [
            (-2657.33, 4851.85, 1457.13),
            (-735.619, 5113.88, 1131.02),
            (-675.734, -832.674, 1386.13)
        ];
    }
    else if(getDvar("mapname") == "mp_sovereign")
    {
        tpNames = "Roof 1;Roof 2;Roof 3";
        tpCoords = [
            (921.323, 1245.21, 839.125),
            (1792.56, 1984.58, 579.125),
            (1765.35, 5621.11, 1008.12)
        ];
    }
    else if(getDvar("mapname") == "mp_chasm")
    {
        tpNames = "Glass Tower Roof";
        tpCoords = [
            (-4548.54, -2674.93, 3137.13)
        ];
    }
    else if(getDvar("mapname") == "mp_flooded")
    {
        tpNames = "Parking Garage Roof;Brown Building Roof;Crane;Distance Roof";
        tpCoords = [
            (62.4653, -925.004, 1377.13),
            (1488.8, -933.495, 1031.13),
            (-288.774, 344.85, 2478.46),
            (2629.91, 7134.45, 1358.13)
        ];
    }
    else if(getDvar("mapname") == "mp_strikezone")
    {
        tpNames = "Greenway Park Sign;Parking Garage Roof;Greenway Park Roof";
        tpCoords = [
            (-6674.71, -2467.74, 2455.93),
            (2277.63, 2751.49, 780.125),
            (-509.322, -449.98, 769.125)
        ];
    }
    else if(getDvar("mapname") == "mp_ca_rumble")
    {
        tpNames = "Aquarium Roof";
        tpCoords = [
            (1990.67, 1944.31, 722.806)
        ];
    }
    else if(getDvar("mapname") == "mp_swamp")
    {
        tpNames = "Top of Bridge;Treetop";
        tpCoords = [
            (2725.12, -107.887, 414.967),
            (2196.31, -508.024, 1223.93)
        ];
    }
    else if(getDvar("mapname") == "mp_boneyard_ns")
    {
        tpNames = "#3 Roof;";
        tpCoords = [
            (264.148, -783.875, 1147.13)
        ];
    }
    else
    {
        tpNames  = "No Custom Spots";
        tpCoords = [];
    }

    self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
    break;

   case "class":
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
            self addOpt("Attachments", ::newMenu, "atchmnts");
            self addOpt("Camos", ::newMenu, "camos");
            self addOpt("Equipment", ::newMenu, "lethals");
            self addOpt("Special Grenades", ::newMenu, "tacticals");
            self addToggle("Save Loadout", self.saveLoadoutEnabled, ::saveLoadoutToggle);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            break;

        case "wpns":
            self addMenu("wpns", "Weapons Menu");

            arIDs = "dlcweap01_mp;sc2010_mp;bren_mp;ak12_mp;fads_mp;r5rgp_mp;msbs_mp;honeybadger_mp;arx160_mp";
            arNames = "Maverick;SC-2010;SA-805;AK-12;FAD;Remington R5;MSBS;Honey Badger;ARX-160";
            self addSliderString("Assault Rifles", arIDs, arNames, ::giveUserWeapon);

            smgIDs = "pp19_mp;cbjms_mp;kriss_mp;vepr_mp;k7_mp;microtar_mp;dlcweap02_mp_dlcweap02scope;dlcweap02_mp";
            smgNames = "Bizon;CBJ-MS;Vector CRB;Vepr;K7;MTAR-X;Ripper;Sightless Ripper";
            self addSliderString("Sub Machine Guns", smgIDs, smgNames, ::giveUserWeapon);

            lmgIDs = "ameli_mp;m27_mp;lsat_mp;kac_mp";
            lmgNames = "Ameli;M27-IAR;LSAT;Chain SAW";
            self addSliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon);

            mrksmanIDs = "g28_mp_g28scope;mk14_mp_mk14scope;imbel_mp_imbelscope;svu_mp_svuscope";
            mrksmanNames = "MR-28;MK14 EBR;IA-2;SVU";
            self addSliderstring("Marksman Rifles", mrksmanIDs, mrksmanNames, ::giveUserWeapon);

            srIDs = "dlcweap03_mp_dlcweap03scope;dlcweap03_mp;usr_mp_usrscope;usr_mp;l115a3_mp_l115a3scope;l115a3_mp;gm6_mp_gm6scope;gm6_mp;vks_mp_vksscope;vks_mp";
            srNames = "Maverick-A2;Scopeless Maverick-A2;USR;Scopeless USR;L115;Scopless L115;Lynx;Scopeless Lynx;VKS;Scopeless VKS";
            self addSliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon);

            sgIDs = "maul_mp;fp6_mp;mts255_mp;uts15_mp";
            sgNames = "Bulldog;FP6;MTS-255;Tac 12";
            self addSliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon);

            pstlIDs = "m9a1_mp;mp443_mp;p226_mp;magnum_mp;magnumhorde_mp;pdw_mp;pdwauto_mp";
            pstlNames = "M9A1;MP-443 Grach;P226;.44 Magnum;Wild Widow;PDW;Gold PDW";
            self addSliderstring("Pistols", pstlIDs, pstlNames, ::giveUserWeapon);

            lnchrIDs = "rgm_mp;panzerfaust3_mp;mk32_mp;mk32horde_mp;maaws_mp";
            lnchrNames = "Kastet;Panzerfaust;MK32;MK32 Single Shot;MAAWS";
            self addSliderstring("Launchers", lnchrIDs, lnchrNames, ::giveUserWeapon);

            specIDs = "knifeonly_mp;knifeonlyfast_mp;minigun_mp";
            specNames = "Combat Knife;Gold Knife;Minigun";
            self addSliderstring("Specials", specIDs, specNames, ::giveUserWeapon);

            self addOpt("Default Weapon", ::giveselfweapon, "defaultweapon_mp");

            self addOpt("Riot Shield", ::giveUserWeapon, "riotshield_mp");
            break;

        case "atchmnts":
            self addMenu("Weapon Attachments");
            
            break;

        case "camos":
            self addMenu("camos", "Camos");          
            self addOpt("Random Camo", ::randomCamo);

            camos = [];
            for(a=0;a<9;a++)
            self addOpt(camos[a], ::changeCamo, a );
            break;

        case "lethals":
            self addMenu("lethals", "Equipment");
            self addOpt("Frag", ::GiveEquipment, "frag_grenade_mp");
            self addOpt("Semtex", ::GiveEquipment, "semtex_mp");
            self addOpt("Throwing Knife", ::GiveEquipment, "throwingknife_mp");
            self addOpt("I.E.D.", ::GiveEquipment, "proximity_explosive_mp");
            self addOpt("C4", ::GiveEquipment, "c4_mp");
            self addOpt("Canister Bomb", ::GiveEquipment, "mortar_shell_mp");
            break;

        case "tacticals":
            self addMenu("tacticals", "Special Grenades");
            self addOpt("9-Bang", ::GiveSecondaryOffhand, "flash_grenade_mp");
            self addOpt("Concussion", ::GiveSecondaryOffhand, "concussion_grenade_mp");
            self addOpt("Smoke", ::GiveSecondaryOffhand, "smoke_grenade_mp");
            self addOpt("Trophy System", ::GiveSecondaryOffhand, "trophy_mp");
            self addOpt("Motion Sensor", ::GiveSecondaryOffhand, "motion_sensor_mp");
            self addOpt("Thermobaric", ::GiveSecondaryOffhand, "thermobaric_grenade_mp");
            break;

        case "afthit":
            self addMenu("afthit", "Afterhits Menu");

            arIDs = "dlcweap01_mp;sc2010_mp;bren_mp;ak12_mp;fads_mp;r5rgp_mp;msbs_mp;honeybadger_mp;arx160_mp";
            arNames = "Maverick;SC-2010;SA-805;AK-12;FAD;Remington R5;MSBS;Honey Badger;ARX-160";
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            smgIDs = "pp19_mp;cbjms_mp;kriss_mp;vepr_mp;k7_mp;microtar_mp;dlcweap02_mp_dlcweap02scope;dlcweap02_mp";
            smgNames = "Bizon;CBJ-MS;Vector CRB;Vepr;K7;MTAR-X;Ripper;Sightless Ripper";
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

            lmgIDs = "ameli_mp;m27_mp;lsat_mp;kac_mp";
            lmgNames = "Ameli;M27-IAR;LSAT;Chain SAW";
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            mrksmanIDs = "g28_mp_g28scope;g28_mp;mk14_mp_mk14scope;mk14_mp;imbel_mp_imbelscope;imbel_mp;svu_mp_svuscope;svu_mp";
            mrksmanNames = "MR-28;Scopeless MR-28;MK14 EBR;Scopeless MK14-EBR;IA-2;Scopeless IA-2;SVU;Scopeless SVU";
            self addSliderstring("Marksman Rifles", mrksmanIDs, mrksmanNames, ::afterhit);

            srIDs = "dlcweap03_mp_dlcweap03scope;dlcweap03_mp;usr_mp_usrscope;usr_mp;l115a3_mp_l115a3scope;_l115a3_mp;gm6_mp_gm6scope;gm6_mp;vks_mp_vksscope;vks_mp";
            srNames = "Maverick-A2;Scopeless Maverick-A2;USR;Scopeless USR;L115;Scopless L115;Lynx;Scopeless Lynx;VKS;Scopeless VKS";
            self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

            sgIDs = "maul_mp;fp6_mp;mts255_mp;uts15_mp";
            sgNames = "Bulldog;FP6;MTS-255;Tac 12";
            self addSliderstring("Shotguns", sgIDs, sgNames, ::afterhit);

            pstlIDs = "m9a1_mp;mp443_mp;p226_mp;magnum_mp;magnumhorde_mp;pdw_mp;pdwauto_mp";
            pstlNames = "M9A1;MP-443 Grach;P226;.44 Magnum;Wild Widow;PDW;Gold PDW";
            self addSliderstring("Pistols", pstlIDs, pstlNames, ::afterhit);

            lnchrIDs = "rgm_mp;panzerfaust3_mp;mk32_mp;mk32horde_mp;maaws_mp";
            lnchrNames = "Kastet;Panzerfaust;MK32;MK32 Single Shot;MAAWS";
            self addSliderString("Launchers", lnchrIDs, lnchrNames, ::afterhit);

            miscIDs = "knifeonly_mp;knifeonlyfast_mp;minigun_mp";
            miscNames = "Combat Knife;Gold Knife;Minigun";
            self addSliderString("Miscellaneous", miscIDs, miscNames, ::afterhit);
            break;

        case "kstrks":
            self addMenu("kstrks", "Killstreak Menu"); 
            
            Killstreak = [];
            for(a=0;a<level.killstreaks.size;a++)
            self addOpt( Killstreak[a], ::doKillstreak, level.killstreaks[a] );

            if(self ishost() || self isdeveloper())
                self addOpt("Killcam Nuke", ::fakenuke);
            break;

        case "host":
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            self addToggle("Toggle Floaters", self.floaters, ::togglelobbyfloat);

            minDistVal = ["15","25","50","100","150","200","250"];
            self addsliderstring("Minimum Distance", minDistVal, undefined, ::setMinDistance);

            timeActions = ["Add 1 Minute","Remove 1 Minute"];
            timeIDs = ["add","sub"];
            self addSliderString("Game Timer", timeIDs, timeActions, ::editTime);

            self addOpt("Fast Restart", ::FastRestart);
            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);

            botOptNames = ["TP to Crosshairs","Spawn 18 Bots","Kick All Bots"];
            botOptIDs = ["teleport","fill","kick"];
            self addSliderString("Bot Controls", botOptIDs, botOptNames, ::botControls);

            self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
            break;
        }
        self clientOptions();
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
            
        self.menu["UI"]["MENU_TITLE"] = self createtext("default", 2, "TOPLEFT", "CENTER", self.presets["X"] + 103, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        //self.menu["UI"]["SCROLLERICON"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 45, self.presets["Y"] - 108, 10, 10, self.presets["ScrollerIcon_BG"], self.presets["Scroller_ShaderIcon"], 3, 1);
        self resizeMenu();
    }