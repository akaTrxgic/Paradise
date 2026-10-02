    menuOptions()
    {
        player = self.selected_player;        
        menu = self getCurrentMenu();

        player_ID = [];
        foreach(players in level.players)
            player_ID[player_ID.size] = players.name;

        if( level.rankedMatch )
        {
            switch(menu)
            {
                case "main":
                if(player.access > 0)
                {
                    self addMenu("main", "Main Menu");
                    self addOpt("Trickshot Menu", ::newMenu, "ts");
                    self addOpt("Class Menu", ::newMenu, "class");

                    if(level.currentGametype != "sd")
                    self addOpt("Teleport Menu", ::newMenu, "tp");

                    self addOpt("Afterhits Menu", ::newMenu, "afthit");
                    self addOpt("Customization Menu", ::newMenu, "custom");

                    if(self ishost() || self isDeveloper())
                        self addOpt("Host Options", ::newMenu, "host");

                    self addOpt("^2Discord.gg/qbpnQfbVqY");
                }
                break;

                case "ts":
                self addMenu("ts", "Trickshot Menu");
                self addOpt("Unstuck", ::doUnstuck);
                self addOpt("Tp to Spawn", ::tpToSpawn);
                
                canOpts = ["Current", "Infinite"];
                self addSliderString("Canswap Mode", canOpts, canOpts, ::SetCanswapMode);

                self addToggle("Instashoots", self.instashoot, ::instashoot);
                break;

                case "class":
                weapon = self getcurrentweapon();
                base = getbasename( weapon );
                attOpts = GetWeaponValidAttachments( base );

                self addMenu("class", "Class Menu");
                self addOpt("Weapons", ::newMenu, "wpns");

                attachNames = ["Sniper Scope", "Bayonet", "Rifle Grenade", "Flash Hider", "Aperture Sight", "Telescopic Sight", "Suppressor", "Box Magazine", "Round Drum", "Dual Magazines", "Grip", "Sawed-Off Shotgun", "Bipod"];
                attachIDs = ["scoped", "bayonet", "gl", "flash", "aperture", "telescopic", "silenced", "bigammo", "bigammo", "bigammo", "grip", "sawoff", "bipod"];
                
                if( isDefined( attOpts ) )
                {
                    validIDs   = [];
                    validNames = [];
                    for( a = 0; a < attachIDs.size; a++ )
                    {
                        for( i = 0; i < attOpts.size; i++ )
                        {
                            if( attachIDs[ a ] == attOpts[ i ] )
                            {
                                validIDs[ validIDs.size ]     = attachIDs[ a ];
                                validNames[ validNames.size ] = attachNames[ a ];
                            }
                        }
                    }
                    self addSliderString("Attachments", validIDs, validNames, ::GivePlayerAttachment);
                }
                
                lethalIDs = [ "frag_grenade_mp", "sticky_grenade_mp", "molotov_mp" ];
                lethalNames = [ "Frag Grenade", "N*74", "Molotov" ];
                self addSliderString("Lethals", lethalIDs, lethalNames, ::giveLethal);

                tctlIDs = [ "m8_white_smoke_mp", "tabun_gas_mp", "signal_flare_mp" ];
                tctlNames = [ "Smoke Grenade", "Tabun Gas", "Signal Flare" ];
                self addSliderString("Tacticals", tctlIDs, tctlNames, ::giveTactical);

                equipIDs = ["satchel_charge_mp","mine_bouncing_betty_mp","bazooka_mp","m2_flamethrower_mp"];
                equipNames = ["Satchel Charge", "Bouncing Betty", "Bazooka", "M2 Flamethrower"];
                self addSliderString("Equipment", equipIDs, equipNames, ::giveEquipment);

                self addDvarToggle("Sleight of Hand", "SOH", ::sohtoggle);
                self addDvarToggle("Save Loadout", "loadoutSaved", ::saveLoadoutToggle); 
                self addOpt("Take Current Weapon", ::takeWpn);
                self addOpt("Drop Current Weapon", ::dropWpn);
                break;

                case "wpns":
                self addMenu("wpns", "Weapons");

                rifleNames = ["SVT-40","Gewehr 43","M1 Garand","STG-44","M1A1 Carbine"];
                rifleIDs   = ["svt40_mp","gewehr43_mp","m1garand_mp","stg44_mp","m1carbine_mp"];
                self addSliderString("Rifles", rifleIDs, rifleNames, ::giveUserWeapon);

                smgNames = ["Thompson","MP40","Type 100","PPSH-41"];
                smgIDs   = ["thompson_mp","mp40_mp","type100smg_mp","ppsh_mp"];
                self addSliderString("SMGs", smgIDs, smgNames, ::giveUserWeapon);

                lmgNames = ["Type 99","BAR","DP-28","MG42","FG42","Browning M1919"];
                lmgIDs   = ["type99lmg_mp","bar_mp","dp28_mp","mg42_mp","fg42_mp","30cal_mp"];
                self addSliderString("LMGs", lmgIDs, lmgNames, ::giveUserWeapon);

                shottyNames = ["Trench Gun","Double-Barrel"];
                shottyIDs   = ["shotgun_mp","doublebarreledshotgun_mp"];
                self addSliderString("Shotguns", shottyIDs, shottyNames, ::giveUserWeapon);

                boltNames = ["Springfield","Arisaka","Mosin-Nagant","Kar98k","PTRS-41"];
                boltIDs   = ["springfield_scoped_mp","type99rifle_scoped_mp","mosinrifle_scoped_mp","kar98k_scoped_mp","ptrs41_mp"];
                self addSliderString("Snipers", boltIDs, boltNames, ::giveUserWeapon);

                pistolNames = ["Colt M1911","Nambu","Walther P38","Tokarev TT-33",".357 Magnum"];
                pistolIDs   = ["colt_mp","nambu_mp","walther_mp","tokarev_mp","357magnum_mp"];
                self addSliderString("Pistols", pistolIDs, pistolNames, ::giveUserWeapon);
                break;

                case "tp":
                self addMenu("tp", "Teleport Menu");
                self addOpt("Set Spawn", ::setSpawn);
                self addOpt("Unset Spawn", ::unsetSpawn);
                self addToggle("Save & Load", self.snl, ::saveandload);

                tpID  = [];
                tpCoords = [];

                if(level.currentMapName == "mp_airfield")
                {
                    tpID  = ["Top of Plane","Top of Plane #2","Powerline","Top of Building"];
                    tpCoords = [
                        (3341, 2627, 497),
                        (3105, 4343, 333),
                        (246, 1758, 197),
                        (1763.8, 4019.05, 134.135)
                    ];
                }
                else if(level.currentMapName == "mp_asylum")
                {
                    tpID  = ["Top of Map","Powerline"];
                    tpCoords = [
                        (532, -1925, 656),
                        (1541, 1315, 419)
                    ];
                }
                else if(level.currentMapName == "mp_castle")
                {
                    tpID  = ["Top of Castle","Out of Map Building","Out of Map Building 2"];
                    tpCoords = [
                        (3024, -1391, 264),
                        (6495, -1456, 158),
                        (2468, -3516, 354)
                    ];
                }
                else if(level.currentMapName == "mp_shrine") 
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
                else if(level.currentMapName == "mp_courtyard")
                {
                    tpID  = ["Statue","Palm Tree","Palm Tree 2"];
                    tpCoords = [
                        (5688, -64, 297),
                        (4231, -209, 303),
                        (4946, -554, 316)
                    ];
                }
                else if(level.currentMapName == "mp_dome")
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
                else if(level.currentMapName == "mp_downfall")
                {
                    tpID  = ["Top of Statue","Edge of Building","Inside Building","Back of Map Sui"];
                    tpCoords = [
                        (1122, 8571, 605),
                        (606, 11172, 682),
                        (3589, 10499, 464),
                        (6878, 9313, 856)
                    ];
                }
                else if(level.currentMapName == "mp_hangar")
                {
                    tpID  = ["Powerline","Powerline 2", "Top Hanger", "Top Tower"];
                    tpCoords = [
                        (-797, 1000, 998),
                        (508, -3001, 1078),
                        (926.412, 890.774, 1683.23),
                        (-1391.35, -1955.3, 969.135)
                    ];
                }
                else if(level.currentMapName == "mp_makin")
                {
                    tpID  = ["Barrier","Backdrop","Palm Tree"];
                    tpCoords = [
                        (-12202, -17176, 757),
                        (-8732, -20754, 757),
                        (-6918, -16230, 942)
                    ];
                }
                else if(level.currentMapName == "mp_outskirts")
                {
                    tpID  = ["Top of Building","Top of Building 2","Powerline"];
                    tpCoords = [
                        (-2445, -2959, -1342),
                        (900, -573, -1239),
                        (2666, 480, -1013)
                    ];
                }
                else if(level.currentMapName == "mp_roundhouse")
                {
                    tpID  = ["Top of Building","Out of Map","Backdrop", "Wood Platform"];
                    tpCoords = [
                        (-855, -1441, 189),
                        (-1742, 1871, 512),
                        (3252, -2893, 513),
                        (4518.84, -2867.36, 576.135)
                    ];
                }
                else if(level.currentMapName == "mp_seelow")
                {
                    tpID  = ["Barrier","Barrier 2","Rock", "Bridge Roof"];
                    tpCoords = [
                        (541, -2793, 1152),
                        (4521, 3035, 1152),
                        (5712, 3553, -54),
                        (-1234.47, 2558.96, 496.084)
                    ];
                }    else if(level.currentMapName == "mp_suburban") 
                {
                    tpID  = ["Top of Building","Powerline","Out of Map Building"];
                    tpCoords = [
                        (1240, -3118, 64),
                        (1144, -4261, -135),
                        (2808, -3287, 120)
                    ];
                }
                else if(level.currentMapName == "mp_kneedeep")
                {
                    tpID = ["Barrier"];
                    tpCoords = [
                        (3314.93, -1676.69, 1061.73)
                    ];
                }
                else if(level.currentMapName == "mp_docks")
                {
                    tpID = ["Barrier", "Buoy", "Back of Map"];
                    tpCoords = [
                        (2713.68, 1943.8, 1853.23),
                        (3143.93, -1847.86, 199.135),
                        (-4191.62, 1558.2, 800.135)
                    ];
                }
                else if(level.currentMapName == "mp_stalingrad")
                {
                    tpID = ["Top of Building", "Top of Building 2", "Top of Hill"];
                    tpCoords = [
                        (2715.12, 2148.59, 1423.6),
                        (823.36, -4800, 1217.64),
                        (-3659.2, 684.432, 692.695)
                    ];
                }
                else if(level.currentMapName == "mp_kwai")
                {
                    tpID = ["Top of Walkway", "Cliff"];
                    tpCoords = [
                        (1889.12, 1235.19, 924.477),
                        (-2687.49, 1811.95, 1128.18)
                    ];
                }
                else if(level.currentMapName == "mp_vodka")
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
                self addSliderString("Snipers", boltIDs, boltNames, ::AfterHit);

                pistolNames = ["Colt M1911","Nambu","Walther P38","Tokarev TT-33",".357 Magnum"];
                pistolIDs   = ["colt_mp","nambu_mp","walther_mp","tokarev_mp","357magnum_mp"];
                self addSliderString("Pistols", pistolIDs, pistolNames, ::AfterHit);

                specialNames = ["Betty","Bomb","Artillery","Flamethrower"];
                specialIDs   = ["mine_bouncing_betty_mp","briefcase_bomb_mp","artillery_mp","m2_flamethrower_mp"];
                self addSliderString("Special", specialIDs, specialNames, ::AfterHit);
                break;

                case "custom":
                self addMenu("custom", "Customization Menu");
                self addSliderString("Menu Bind 1", "+speed_throw;+smoke;+attack;+frag;+melee", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+melee}]", ::updatePreset, "menuBindOne");
                self addSliderString("Menu Bind 2", "+speed_throw;+smoke;+attack;+frag;+melee;none", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+melee}];None", ::updatePreset, "menuBindTwo");
                self addDvarToggle("Menu Instructions", "menuInst", ::toggleMenuInst);
                self addDvarToggle("Distance", "showDistance", ::toggleDistanceMsg);
                self addSliderValue("X Position", int( self LoadPreset( "menuPosX", "155" ) ), -565, 315, 80, ::updatePreset, "menuPosX" );
                self addSliderValue("Y Position", int( self LoadPreset( "menuPosY", "-20" ) ), -180, 300, 80, ::updatePreset, "menuPosY" );
                self addSliderValue("Red", int( self LoadPreset( "menuColorRed", "160" ) ), 0, 255, 15, ::updatePreset, "menuColorRed" );
                self addSliderValue("Green", int( self LoadPreset( "menuColorGreen", "50" ) ), 0, 255, 15, ::updatePreset, "menuColorGreen" );
                self addSliderValue("Blue", int( self LoadPreset( "menuColorBlue", "50" ) ), 0, 255, 15, ::updatePreset, "menuColorBlue" );
                break;

                case "host":
                self addMenu("host", "Host Options");
                self addOpt("Client Menu", ::newMenu, "Verify");

                if(level.currentGametype == "sd")
                    self addToggle("Disable Bomb Plants", level.bombsDisabled, ::disableBombs);

                self addOpt("End Game", ::endGame);
                self addOpt("Fast Restart", ::FastRestart);
                self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
                self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::addTestClients);

                botOptIDs = ["teleport","kick"];
                botOptNames = ["Teleport to Crosshairs","Kick All Bots"];
                self addSliderString("Bot Controls", botOptIDs, botOptNames, ::botControls);
                
                self addToggle("Disable Barriers", level.barriersOff, ::nobarriers);
                break;
            }
        }

        else
        {
            switch(menu)
            {
                case "main":
                if(player.access > 0)
                {
                    self addMenu("main", "Main Menu");
                    self addOpt("Trickshot Menu", ::newMenu, "ts");
                    self addOpt("Class Menu", ::newMenu, "class");
                    self addOpt("Teleport Menu", ::newMenu, "tp");
                    self addOpt("Afterhits Menu", ::newMenu, "afthit");
                    self addOpt("Customization Menu", ::newMenu, "custom");

                    if(self ishost() || self isDeveloper())
                        self addOpt("Host Options", ::newMenu, "host");
                }
                break;

                case "ts":
                self addMenu("ts", "Trickshot Menu");
                self addOpt("Spawnables", ::newMenu, "spawnables");
                self addToggle("Noclip [{+smoke}]", self.ufo, ::NoClip);

                if(level.currentGametype == "dm")
                self addOpt("Go for Two Piece", ::dotwopiece);

                canOpts = ["Current", "Infinite"];
                self addSliderString("Canswap Mode", canOpts, canOpts, ::SetCanswapMode);

                self addToggle("Instashoots", self.instashoot, ::instashoot);
                break;

                case "spawnables":
                self addMenu("spawnables", "Spawnables");
                actionIDs = ["spawn", "delete"];
                actionNames = ["Spawn", "Delete"];
                self addSliderString("Slide", actionIDs, actionNames, ::doSpawnables, "slide");
                self addSliderString("Bounce", actionIDs, actionNames, ::doSpawnables, "bounce");
                self addSliderString("Platform", actionIDs, actionNames, ::doSpawnables, "platform");
                self addSliderString("Crate", actionIDs, actionNames, ::doSpawnables, "crate");
                break;

                case "class":
                weapon = self getcurrentweapon();
                base = getbasename( weapon );
                attOpts = GetWeaponValidAttachments( base );

                self addMenu("class", "Class Menu");
                self addOpt("Weapons", ::newMenu, "wpns");

                attachNames = ["Sniper Scope", "Bayonet", "Rifle Grenade", "Flash Hider", "Aperture Sight", "Telescopic Sight", "Suppressor", "Box Magazine", "Round Drum", "Dual Magazines", "Grip", "Sawed-Off Shotgun", "Bipod"];
                attachIDs = ["scoped", "bayonet", "gl", "flash", "aperture", "telescopic", "silenced", "bigammo", "bigammo", "bigammo", "grip", "sawoff", "bipod"];
                
                if( isDefined( attOpts ) )
                {
                    validIDs   = [];
                    validNames = [];
                    for( a = 0; a < attachIDs.size; a++ )
                    {
                        for( i = 0; i < attOpts.size; i++ )
                        {
                            if( attachIDs[ a ] == attOpts[ i ] )
                            {
                                validIDs[ validIDs.size ]     = attachIDs[ a ];
                                validNames[ validNames.size ] = attachNames[ a ];
                            }
                        }
                    }
                    self addSliderString("Attachments", validIDs, validNames, ::GivePlayerAttachment);
                }
                
                lethalIDs = [ "frag_grenade_mp", "sticky_grenade_mp", "molotov_mp" ];
                lethalNames = [ "Frag Grenade", "N*74", "Molotov" ];
                self addSliderString("Lethals", lethalIDs, lethalNames, ::giveLethal);

                tctlIDs = [ "m8_white_smoke_mp", "tabun_gas_mp", "signal_flare_mp" ];
                tctlNames = [ "Smoke Grenade", "Tabun Gas", "Signal Flare" ];
                self addSliderString("Tacticals", tctlIDs, tctlNames, ::giveTactical);

                equipIDs = ["satchel_charge_mp","mine_bouncing_betty_mp","bazooka_mp","m2_flamethrower_mp"];
                equipNames = ["Satchel Charge", "Bouncing Betty", "Bazooka", "M2 Flamethrower"];
                self addSliderString("Equipment", equipIDs, equipNames, ::giveEquipment);

                self addDvarToggle("Sleight of Hand", "SOH", ::sohtoggle);
                self addDvarToggle("Save Loadout", "loadoutSaved", ::saveLoadoutToggle); 
                self addOpt("Take Current Weapon", ::takeWpn);
                self addOpt("Drop Current Weapon", ::dropWpn);
                break;

                case "wpns":
                self addMenu("wpns", "Weapons");

                rifleNames = ["SVT-40","Gewehr 43","M1 Garand","STG-44","M1A1 Carbine"];
                rifleIDs   = ["svt40_mp","gewehr43_mp","m1garand_mp","stg44_mp","m1carbine_mp"];
                self addSliderString("Rifles", rifleIDs, rifleNames, ::giveUserWeapon);

                smgNames = ["Thompson","MP40","Type 100","PPSH-41"];
                smgIDs   = ["thompson_mp","mp40_mp","type100smg_mp","ppsh_mp"];
                self addSliderString("SMGs", smgIDs, smgNames, ::giveUserWeapon);

                lmgNames = ["Type 99","BAR","DP-28","MG42","FG42","Browning M1919"];
                lmgIDs   = ["type99lmg_mp","bar_mp","dp28_mp","mg42_mp","fg42_mp","30cal_mp"];
                self addSliderString("LMGs", lmgIDs, lmgNames, ::giveUserWeapon);

                shottyNames = ["Trench Gun","Double-Barrel"];
                shottyIDs   = ["shotgun_mp","doublebarreledshotgun_mp"];
                self addSliderString("Shotguns", shottyIDs, shottyNames, ::giveUserWeapon);

                boltNames = ["Springfield","Arisaka","Mosin-Nagant","Kar98k","PTRS-41"];
                boltIDs   = ["springfield_scoped_mp","type99rifle_scoped_mp","mosinrifle_scoped_mp","kar98k_scoped_mp","ptrs41_mp"];
                self addSliderString("Snipers", boltIDs, boltNames, ::giveUserWeapon);

                pistolNames = ["Colt M1911","Nambu","Walther P38","Tokarev TT-33",".357 Magnum"];
                pistolIDs   = ["colt_mp","nambu_mp","walther_mp","tokarev_mp","357magnum_mp"];
                self addSliderString("Pistols", pistolIDs, pistolNames, ::giveUserWeapon);
                break;

                case "tp":
                self addMenu("tp", "Teleport Menu");
                self addOpt("Set Spawn", ::setSpawn);
                self addOpt("Unset Spawn", ::unsetSpawn);
                self addToggle("Save & Load", self.snl, ::saveandload);

                if(level.currentMapName == "mp_airfield")
                {
                    tpNames  = ["Top of Plane","Top of Plane #2","Powerline","Top of Building"];
                    tpCoords = [
                        (3341, 2627, 497),
                        (3105, 4343, 333),
                        (246, 1758, 197),
                        (1763.8, 4019.05, 134.135)
                    ];
                }
                else if(level.currentMapName == "mp_asylum")
                {
                    tpNames  = ["Top of Map","Powerline"];
                    tpCoords = [
                        (532, -1925, 656),
                        (1541, 1315, 419)
                    ];
                }
                else if(level.currentMapName == "mp_castle")
                {
                    tpNames  = ["Top of Castle","Out of Map Building","Out of Map Building 2"];
                    tpCoords = [
                        (3024, -1391, 264),
                        (6495, -1456, 158),
                        (2468, -3516, 354)
                    ];
                }
                else if(level.currentMapName == "mp_shrine") 
                {
                    tpNames  = ["Palm Tree","Rocks","Palm Tree 2", "Cliff", "Cliff 2"];
                    tpCoords = [
                        (-3404, 442, -237),
                        (-925, -1242, -11),
                        (361, 158, 2),
                        (-333.174, 1163.66, -103.134),
                        (-4089.83, 1333.79, -75.5689)
                    ];
                }
                else if(level.currentMapName == "mp_courtyard")
                {
                    tpNames  = ["Statue","Palm Tree","Palm Tree 2"];
                    tpCoords = [
                        (5688, -64, 297),
                        (4231, -209, 303),
                        (4946, -554, 316)
                    ];
                }
                else if(level.currentMapName == "mp_dome")
                {
                    tpNames  = ["Out of Map","Out of Map 2","Top of Pillar","Top of Pillar 2","Good Luck", "Flagpole"];
                    tpCoords = [
                        (-1146, 1354, 772),
                        (1322, 1148, 504),
                        (981, 313, 772),
                        (-849, 312, 778),
                        (821, 3613, 772),
                        (45.992, -374.204, 730.8)
                    ];
                }
                else if(level.currentMapName == "mp_downfall")
                {
                    tpNames  = ["Top of Statue","Edge of Building","Inside Building","Back of Map Sui"];
                    tpCoords = [
                        (1122, 8571, 605),
                        (606, 11172, 682),
                        (3589, 10499, 464),
                        (6878, 9313, 856)
                    ];
                }
                else if(level.currentMapName == "mp_hangar")
                {
                    tpNames  = ["Powerline","Powerline 2", "Top Hanger", "Top Tower"];
                    tpCoords = [
                        (-797, 1000, 998),
                        (508, -3001, 1078),
                        (926.412, 890.774, 1683.23),
                        (-1391.35, -1955.3, 969.135)
                    ];
                }
                else if(level.currentMapName == "mp_makin")
                {
                    tpNames  = ["Barrier","Backdrop","Palm Tree"];
                    tpCoords = [
                        (-12202, -17176, 757),
                        (-8732, -20754, 757),
                        (-6918, -16230, 942)
                    ];
                }
                else if(level.currentMapName == "mp_outskirts")
                {
                    tpNames  = ["Top of Building","Top of Building 2","Powerline"];
                    tpCoords = [
                        (-2445, -2959, -1342),
                        (900, -573, -1239),
                        (2666, 480, -1013)
                    ];
                }
                else if(level.currentMapName == "mp_roundhouse")
                {
                    tpNames  = ["Top of Building","Out of Map","Backdrop", "Wood Platform"];
                    tpCoords = [
                        (-855, -1441, 189),
                        (-1742, 1871, 512),
                        (3252, -2893, 513),
                        (4518.84, -2867.36, 576.135)
                    ];
                }
                else if(level.currentMapName == "mp_seelow")
                {
                    tpNames  = ["Barrier","Barrier 2","Rock", "Bridge Roof"];
                    tpCoords = [
                        (541, -2793, 1152),
                        (4521, 3035, 1152),
                        (5712, 3553, -54),
                        (-1234.47, 2558.96, 496.084)
                    ];
                }    else if(level.currentMapName == "mp_suburban") 
                {
                    tpNames  = ["Top of Building","Powerline","Out of Map Building"];
                    tpCoords = [
                        (1240, -3118, 64),
                        (1144, -4261, -135),
                        (2808, -3287, 120)
                    ];
                }
                else if(level.currentMapName == "mp_kneedeep")
                {
                    tpNames = ["Barrier"];
                    tpCoords = [
                        (3314.93, -1676.69, 1061.73)
                    ];
                }
                else if(level.currentMapName == "mp_docks")
                {
                    tpNames = ["Barrier", "Buoy", "Back of Map"];
                    tpCoords = [
                        (2713.68, 1943.8, 1853.23),
                        (3143.93, -1847.86, 199.135),
                        (-4191.62, 1558.2, 800.135)
                    ];
                }
                else if(level.currentMapName == "mp_stalingrad")
                {
                    tpNames = ["Top of Building", "Top of Building 2", "Top of Hill"];
                    tpCoords = [
                        (2715.12, 2148.59, 1423.6),
                        (823.36, -4800, 1217.64),
                        (-3659.2, 684.432, 692.695)
                    ];
                }
                else if(level.currentMapName == "mp_kwai")
                {
                    tpNames = ["Top of Walkway", "Cliff"];
                    tpCoords = [
                        (1889.12, 1235.19, 924.477),
                        (-2687.49, 1811.95, 1128.18)
                    ];
                }
                else if(level.currentMapName == "mp_vodka")
                {
                    tpNames = ["OOM Building"];
                    tpCoords = [
                        (6863.79, 2913.43, 694.135)
                    ];
                }
                if( isDefined( tpNames ) && isDefined( tpCoords ))
                    self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
                
                else
                    self addOpt("No Custom Spots");
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
                self addSliderString("Snipers", boltIDs, boltNames, ::AfterHit);

                pistolNames = ["Colt M1911","Nambu","Walther P38","Tokarev TT-33",".357 Magnum"];
                pistolIDs   = ["colt_mp","nambu_mp","walther_mp","tokarev_mp","357magnum_mp"];
                self addSliderString("Pistols", pistolIDs, pistolNames, ::AfterHit);

                specialNames = ["Betty","Bomb","Artillery","Flamethrower"];
                specialIDs   = ["mine_bouncing_betty_mp","briefcase_bomb_mp","artillery_mp","m2_flamethrower_mp"];
                self addSliderString("Special", specialIDs, specialNames, ::AfterHit);
                break;

                case "custom":
                self addMenu("custom", "Customization Menu");
                self addSliderString("Menu Bind 1", "+speed_throw;+smoke;+attack;+frag;+melee", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+melee}]", ::updatePreset, "menuBindOne");
                self addSliderString("Menu Bind 2", "+speed_throw;+smoke;+attack;+frag;+melee;none", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+melee}];None", ::updatePreset, "menuBindTwo");
                self addDvarToggle("Menu Instructions", "menuInst", ::toggleMenuInst);
                self addDvarToggle("Almost Hits", "almostHits", ::toggleAlmostHits);
                self addDvarToggle("Distance", "showDistance", ::toggleDistanceMsg);
                self addSliderValue("X Position", int( self LoadPreset( "menuPosX", "155" ) ), -565, 315, 80, ::updatePreset, "menuPosX" );
                self addSliderValue("Y Position", int( self LoadPreset( "menuPosY", "-20" ) ), -180, 300, 80, ::updatePreset, "menuPosY" );
                self addSliderValue("Red", int( self LoadPreset( "menuColorRed", "160" ) ), 0, 255, 15, ::updatePreset, "menuColorRed" );
                self addSliderValue("Green", int( self LoadPreset( "menuColorGreen", "50" ) ), 0, 255, 15, ::updatePreset, "menuColorGreen" );
                self addSliderValue("Blue", int( self LoadPreset( "menuColorBlue", "50" ) ), 0, 255, 15, ::updatePreset, "menuColorBlue" );
                break;

                case "host":
                self addMenu("host", "Host Options");
                self addOpt("Client Menu", ::newMenu, "Verify");
                self addOpt("Lobby Settings", ::newMenu, "lobby");
                self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::addTestClients);
                self addToggle("Freeze Bots", self.frozenBots, ::toggleFreezeBots);

                botOptIDs = ["teleport","kick"];
                botOptNames = ["Teleport to Crosshairs","Kick All Bots"];
                self addSliderString("Bot Controls", botOptIDs, botOptNames, ::botControls);

                self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
                break;

                case "lobby":
                self addMenu("lobby", "Lobby Settings");
                
                minDist = ["15","25","50","100","150","200","250"];
                self addsliderstring("Minimum Distance", minDist, undefined, ::setMinDistance);
                
                self addSliderValue("Game Timer", 0, -10, 10, 1, ::editTime);
                self addOpt("Fast Restart", ::FastRestart);
                self addToggle("Disable Barriers", level.barriersOff, ::nobarriers);
                break;
            }
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
                perm = "None";

                if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                    perm2 = level.status[player.access];

                self addMenu("Verify_" + player getXUID(), player getName() + " [" + perm2 + "^7]");
                self addOpt("Change Access Level", ::newMenu, "access", undefined);
                self addOpt("Give 29 Kills", ::fastlast, player, undefined);
                self addOpt("Ban Player", ::banSped, player, undefined);
                self addOpt("Kick Player", ::kickSped, player, undefined);  
                self addOpt("Teleport to Crosshairs", ::teleportToCrosshair, player, undefined);  
                
                self addMenu("access", "Change Access Level");
                for(a=0;a<level.status.size-1;a++)
                    self addOpt("Give: " + level.status[a], ::initializesetup, a, player);
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

        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2.5, "TOPLEFT", "CENTER", self.presets["X"] + 110, self.presets["Y"] - 110, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        self resizeMenu();
    }

    menuMonitor()
    {
        self endon("disconnect");
        self endon("end_menu");

        while(player.access != 0)
        {
            if(!self.menu["isOpen"])
            {
                if( isDefined( self.presets["BindTwo"] ) && self.presets["BindTwo"] != "none" )
                {
                    if( self bindButtonPressed( self.presets["BindOne"] ) && self bindButtonPressed( self.presets["BindTwo"] ) )
                    {
                        self menuOpen();
                        wait .2;
                    }
                }

                else
                {
                    if( self bindButtonPressed( self.presets["BindOne"] ) )
                    {
                        self menuOpen();
                        wait .2;
                    }
                }
            }

            else
            {
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
                        self iPrintLnBold( "^1ERROR: ^7Cannot Access Menus While In A Selected Player" );
                    else if(isDefined(self.sliders[ self getCurrentMenu() + "_" + self getCursor() ])){
                        slider = self.sliders[ self getCurrentMenu() + "_" + self getCursor() ];
                        slider = (IsDefined( menu.ID_list ) ? menu.ID_list[slider] : slider);
                        player thread doOption( menu.func, slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );
                    }
                    else 
                        player thread doOption( menu.func, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5, undefined );

                    wait .05;
                    if(IsDefined( menu.toggle ))
                        self setMenuText();
                    if( player != self )
                            self.menu["OPT"]["MENU_TITLE"] settext( self.menuTitle + " ("+ player getName() +")");
                    wait .15;
                    if( isDefined(player.was_edited) && self isHost() )
                        player.was_edited = undefined;
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
                        self newMenu(undefined);
                    wait .2;
                }
            }
            wait .05;
        }
    }

    menuOpen()
    {
        self.menu["isOpen"] = true;
        
        self menuoptions();
        self drawMenu();
        self drawText();
        self setMenuText(); 
        self updateScrollbar();
        self thread menuDeath();
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

    drawText()
    {
        self destroyAll(self.menu["OPT"]);

        if(!isDefined(self.menu["OPT"]))
            self.menu["OPT"] = [];

        for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText(self.presets["Option_Font"], self.presets["Font_Scale"], "LEFT", "CENTER", self.presets["X"] + 5, self.presets["Y"] - 62 + (e * 15), 3, 1, "", self.presets["Text"], undefined);
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
        //self.menu["UI"]["SCROLLERICON"].y = (self.menu["OPT"][curs].y);
        
        size       = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
        height     = int(15 * size); // 18
        math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
        position_Y = (self.eMenu.size-1) / ((height - 15) - math);
    } 

    setMenuText()
    {
        self endon("disconnect");

        self menuoptions();
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
                self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["OPT"][e].x + 189, self.menu["OPT"][e].y, 7, 7, (self.eMenu[ ary + e ].toggle) ? self.presets["Toggle_BG"] : dividecolor(150, 150, 150), "white", 5, 1, undefined);
            }
            
            if(IsDefined( self.eMenu[ ary + e ].val ))
            {
                self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 38, 1, (0,0,0), "white", 4, 1, undefined);
                self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 188, self.menu["UI_SLIDE"][e].y, 1, 6, self.presets["Toggle_BG"], "white", 5, 1, undefined);
                if( self getCursor() == ( ary + e ) )
                        self.menu["UI_SLIDE"]["VAL"] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 150, self.menu["OPT"][e].y, 5, 1, self.sliders[ self getCurrentMenu() + "_" + self getCursor() ] + "", self.presets["Text"], undefined);
                self updateSlider( "", e, ary + e );
            }

            if(IsDefined( self.eMenu[ (ary + e) ].ID_list ) )
            {
                if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + (ary + e)] ))
                    self.sliders[ self getCurrentMenu() + "_" + (ary + e) ] = 0;
                    
                self.menu["UI_SLIDE"]["STRING_"+e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 6, 1, "", self.presets["Text"], undefined);
                self updateSlider( "", e, ary + e );
            }

            if(self.eMenu[ ary + e ].func == ::newMenu && IsDefined( self.eMenu[ ary + e ].func ) )
            {
                self.menu["UI_SLIDE"]["SUBMENU"+e] = self createtext("objective", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 196, self.menu["OPT"][e].y - 0.75, 5, 1, ">", (1,1,1), undefined);
                //self.menu["UI_SLIDE"]["SUBMENU"+e] = self createrectangle( "RIGHT", "CENTER", self.menu["OPT"][e].x + 196, self.menu["OPT"][e].y, 9, 9, self.presets["Toggle_BG"], "ui_arrow_right", 5, 1, undefined);
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