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
        if(self.access > 0)
        {
            self addMenu("main", "Main Menu");
            self addOpt("Trickshot Menu", ::newMenu, "ts");
            self addOpt("Class Menu", ::newMenu, "class");
            self addOpt("Teleport Menu", ::newMenu, "tp");
            self addOpt("Afterhits Menu", ::newMenu, "afthit");

            if(self ishost() || self isDeveloper())
                self addOpt("Host Options", ::newMenu, "host");
        }
        break;

    case "ts":
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

case "class":
    self addMenu("class", "Class Menu");

    rifleNames = ["SVT-40","Gewehr 43","M1 Garand","STG-44","M1A1 Carbine"];
    rifleIDs   = ["svt40_mp","gewehr43_mp","m1garand_mp","stg44_mp","m1carbine_mp"];
    self addSliderString("Rifles", rifleIDs, rifleNames, ::doGiveWeapon);

    smgNames = ["Thompson","MP40","Type 100","PPSH-41"];
    smgIDs   = ["thompson_mp","mp40_mp","type100smg_mp","ppsh_mp"];
    self addSliderString("SMGs", smgIDs, smgNames, ::doGiveWeapon);

    lmgNames = ["Type 99","BAR","DP-28","MG42","FG42","Browning M1919"];
    lmgIDs   = ["type99lmg_mp","bar_mp","dp28_mp","mg42_mp","fg42_mp","30cal_mp"];
    self addSliderString("LMGs", lmgIDs, lmgNames, ::doGiveWeapon);

    shottyNames = ["Trench Gun","Double-Barrel"];
    shottyIDs   = ["shotgun_mp","doublebarreledshotgun_mp"];
    self addSliderString("Shotguns", shottyIDs, shottyNames, ::doGiveWeapon);

    boltNames = ["Springfield","Arisaka","Mosin-Nagant","Kar98k","PTRS-41"];
    boltIDs   = ["springfield_scoped_mp","type99rifle_scoped_mp","mosinrifle_scoped_mp","kar98k_scoped_mp","ptrs41_mp"];
    self addSliderString("Bolt-Actions", boltIDs, boltNames, ::doGiveWeapon);

    pistolNames = ["Colt M1911","Nambu","Walther P38","Tokarev TT-33",".357 Magnum"];
    pistolIDs   = ["colt_mp","nambu_mp","walther_mp","tokarev_mp","357magnum_mp"];
    self addSliderString("Pistols", pistolIDs, pistolNames, ::doGiveWeapon);

    self addOpt("Attachments", ::newMenu, "attach");
    self addOpt("Lethals", ::newMenu, "lethals");
    self addOpt("Tacticals", ::newMenu, "equipment");    
    self addOpt("Take Current Weapon", ::takeWpn);
    self addOpt("Drop Current Weapon", ::dropWpn);
    break;

    case "attach":
    weapon = self getcurrentweapon();
    base = getbasename(weapon);
    attOpts = GetWeaponValidAttachments(base);

    self addMenu("attach", "Attachments");

    attachNames = ["Sniper Scope", "Bayonet", "Rifle Grenade", "Flash Hider", "Aperture Sight", "Telescopic Sight", "Suppressor", "Box Magazine", "Round Drum", "Dual Magazines", "Grip", "Sawed-Off Shotgun", "Bipod"];
    attachIDs = ["scoped", "bayonet", "gl", "flash", "aperture", "telescopic", "silenced", "bigammo", "bigammo", "bigammo", "grip", "sawoff", "bipod"];
    
    if(isDefined(attOpts))
    {
        for(a=0;a<attachIDs.size;a++)
        {
            for(i=0;i<attOpts.size;i++)
            {
                if(attachIDs[a] == attOpts[i])
                    self addOpt( attachNames[a], ::GivePlayerAttachment, attachIDs[a]);
            }
        }
    }
    else
        self addOpt("No Valid Attachments!");
    break;

    case "lethals":
    self addMenu("lethals", "Lethals");
    self addOpt("Frag Grenade", ::giveLethal, "frag_grenade_mp");
    self addOpt("N*74", ::giveLethal, "sticky_grenade_mp");
    self addOpt("Molotov", ::giveLethal, "molotov_mp");
    break;

    case "equipment":
    self addMenu("equipment", "Tacticals");
    self addOpt("Smoke Grenade", ::giveTactical, "m8_white_smoke_mp");
    self addOpt("Tabun Gas", ::giveTactical, "tabun_gas_mp");
    self addOpt("Signal Flare", ::giveTactical, "signal_flare_mp");
    break;

    case "tp":
    self addMenu("tp", "Teleport Menu");
    self addOpt("Set Spawn", ::setSpawn);
    self addOpt("Unset Spawn", ::unsetSpawn);
    self addToggle("Save & Load", self.snl, ::saveandload);

    tpID  = [];
    tpCoords = [];

    if(getDvar("mapname") == "mp_airfield")
    {
        tpID  = ["Top of Plane","Top of Plane #2","Powerline","Top of Building"];
        tpCoords = [
            (3341, 2627, 497),
            (3105, 4343, 333),
            (246, 1758, 197),
            (1763.8, 4019.05, 134.135)
        ];
    }
    else if(getDvar("mapname") == "mp_asylum")
    {
        tpID  = ["Top of Map","Powerline"];
        tpCoords = [
            (532, -1925, 656),
            (1541, 1315, 419)
        ];
    }
    else if(getDvar("mapname") == "mp_castle")
    {
        tpID  = ["Top of Castle","Out of Map Building","Out of Map Building 2"];
        tpCoords = [
            (3024, -1391, 264),
            (6495, -1456, 158),
            (2468, -3516, 354)
        ];
    }
    else if(getDvar("mapname") == "mp_shrine") 
    {
        tpID  = ["Palm Tree","Rocks","Palm Tree 2", "Cliff", "Cliff 2"];
        tpCoords = [
            (-3404, 442, -237),
            (-925, -1242, -11),
            (361, 158, 2),
            (-333.174, 1163.66, -103.134),
            (-4089.83, 1333.79, -75.5689)
        ];
    }
    else if(getDvar("mapname") == "mp_courtyard")
    {
        tpID  = ["Statue","Palm Tree","Palm Tree 2"];
        tpCoords = [
            (5688, -64, 297),
            (4231, -209, 303),
            (4946, -554, 316)
        ];
    }
    else if(getDvar("mapname") == "mp_dome")
    {
        tpID  = ["Out of Map","Out of Map 2","Top of Pillar","Top of Pillar 2","Good Luck", "Flagpole"];
        tpCoords = [
            (-1146, 1354, 772),
            (1322, 1148, 504),
            (981, 313, 772),
            (-849, 312, 778),
            (821, 3613, 772),
            (45.992, -374.204, 730.8)
        ];
    }
    else if(getDvar("mapname") == "mp_downfall")
    {
        tpID  = ["Top of Statue","Edge of Building","Inside Building","Back of Map Sui"];
        tpCoords = [
            (1122, 8571, 605),
            (606, 11172, 682),
            (3589, 10499, 464),
            (6878, 9313, 856)
        ];
    }
    else if(getDvar("mapname") == "mp_hangar")
    {
        tpID  = ["Powerline","Powerline 2", "Top Hanger", "Top Tower"];
        tpCoords = [
            (-797, 1000, 998),
            (508, -3001, 1078),
            (926.412, 890.774, 1683.23),
            (-1391.35, -1955.3, 969.135)
        ];
    }
    else if(getDvar("mapname") == "mp_makin")
    {
        tpID  = ["Barrier","Backdrop","Palm Tree"];
        tpCoords = [
            (-12202, -17176, 757),
            (-8732, -20754, 757),
            (-6918, -16230, 942)
        ];
    }
    else if(getDvar("mapname") == "mp_outskirts")
    {
        tpID  = ["Top of Building","Top of Building 2","Powerline"];
        tpCoords = [
            (-2445, -2959, -1342),
            (900, -573, -1239),
            (2666, 480, -1013)
        ];
    }
    else if(getDvar("mapname") == "mp_roundhouse")
    {
        tpID  = ["Top of Building","Out of Map","Backdrop", "Wood Platform"];
        tpCoords = [
            (-855, -1441, 189),
            (-1742, 1871, 512),
            (3252, -2893, 513),
            (4518.84, -2867.36, 576.135)
        ];
    }
    else if(getDvar("mapname") == "mp_seelow")
    {
        tpID  = ["Barrier","Barrier 2","Rock", "Bridge Roof"];
        tpCoords = [
            (541, -2793, 1152),
            (4521, 3035, 1152),
            (5712, 3553, -54),
            (-1234.47, 2558.96, 496.084)
        ];
    }    else if(getDvar("mapname") == "mp_suburban") 
    {
        tpID  = ["Top of Building","Powerline","Out of Map Building"];
        tpCoords = [
            (1240, -3118, 64),
            (1144, -4261, -135),
            (2808, -3287, 120)
        ];
    }
    else if(getDvar("mapname") == "mp_kneedeep")
    {
        tpID = ["Barrier"];
        tpCoords = [
            (3314.93, -1676.69, 1061.73)
        ];
    }
    else if(getdvar("mapname") == "mp_docks")
    {
        tpID = ["Barrier", "Buoy", "Back of Map"];
        tpCoords = [
            (2713.68, 1943.8, 1853.23),
            (3143.93, -1847.86, 199.135),
            (-4191.62, 1558.2, 800.135)
        ];
    }
    else if(getdvar("mapname") == "mp_stalingrad")
    {
        tpID = ["Top of Building", "Top of Building 2", "Top of Hill"];
        tpCoords = [
            (2715.12, 2148.59, 1423.6),
            (823.36, -4800, 1217.64),
            (-3659.2, 684.432, 692.695)
        ];
    }
    else if(getdvar("mapname") == "mp_kwai")
    {
        tpID = ["Top of Walkway", "Cliff"];
        tpCoords = [
            (1889.12, 1235.19, 924.477),
            (-2687.49, 1811.95, 1128.18)
        ];
    }
    else if(getdvar("mapname") == "mp_vodka")
    {
        tpID = ["OOM Building"];
        tpCoords = [
            (6863.79, 2913.43, 694.135)
        ];
    }
    else
    {
        tpID  = [""];
        tpCoords = [(0,0,0)];
    }
    self addSliderString("Custom Spot", tpCoords, tpID, ::tptospot);
    break;

    case "afthit":
    self addMenu("afthit", "Afterhits Menu");

    rifleNames = ["SVT-40","Gewehr 43","M1 Garand","STG-44","M1A1 Carbine"];
    rifleIDs   = ["svt40_mp","gewehr43_mp","m1garand_mp","stg44_mp","m1carbine_mp"];
    self addSliderString("Rifles", rifleIDs, rifleNames, ::AfterHit);

    smgNames = ["Thompson","MP40","Type 100","PPSh-41"];
    smgIDs   = ["thompson_mp","mp40_mp","type100smg_mp","ppsh_mp"];
    self addSliderString("SMGs", smgIDs, smgNames, ::AfterHit);

    lmgNames = ["Type 99","BAR","DP-28","MG42","FG42","Browning M1919"];
    lmgIDs   = ["type99lmg_mp","bar_mp","dp28_mp","mg42_mp","fg42_mp","30cal_mp"];
    self addSliderString("LMGs", lmgIDs, lmgNames, ::AfterHit);

    shottyNames = ["Trench Gun","Double-Barrel"];
    shottyIDs   = ["shotgun_mp","doublebarreledshotgun_mp"];
    self addSliderString("Shotguns", shottyIDs, shottyNames, ::AfterHit);

    boltNames = ["Springfield","Arisaka","Mosin-Nagant","Kar98k","PTRS-41"];
    boltIDs   = ["springfield_mp","type99rifle_mp","mosinrifle_mp","kar98k_mp","ptrs41_mp"];
    self addSliderString("Bolt-Actions", boltIDs, boltNames, ::AfterHit);

    pistolNames = ["Colt M1911","Nambu","Walther P38","Tokarev TT-33",".357 Magnum"];
    pistolIDs   = ["colt_mp","nambu_mp","walther_mp","tokarev_mp","357magnum_mp"];
    self addSliderString("Pistols", pistolIDs, pistolNames, ::AfterHit);

    specialNames = ["Betty","Bomb","Artillery","Flamethrower"];
    specialIDs   = ["mine_bouncing_betty_mp","briefcase_bomb_mp","artillery_mp","m2_flamethrower_mp"];
    self addSliderString("Special", specialIDs, specialNames, ::AfterHit);
    break;

        case "host":
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");

            minDistVal = ["15","25","50","100","150","200","250"];
            self addsliderstring("Minimum Distance", minDistVal, undefined, ::setMinDistance);

            timeActions = ["Add 1 Minute","Remove 1 Minute"];
            timeIDs = ["add","sub"];
            self addSliderString("Game Timer", timeIDs, timeActions, ::editTime);

            self addOpt("Fast Restart", ::FastRestart);

            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
            botOptNames = "TP Bots;Spawn 18 Bots;Kick All Bots";
            botOptIDs = "teleport;fill;kick";
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

        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 1.8, "TOPLEFT", "CENTER", self.presets["X"] + 120, self.presets["Y"] - 100, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        self.menu["UI"]["SCROLLERICON"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 45, self.presets["Y"] - 108, 10, 10, self.presets["ScrollerIcon_BG"], self.presets["Scroller_ShaderIcon"], 3, 1);
        self resizeMenu();
    }