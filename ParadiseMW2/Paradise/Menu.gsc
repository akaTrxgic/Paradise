newMenus()
{
    player = self.selected_player;
    menu = self getCurrentMenu();

    player_names = [];
    foreach(players in level.players)
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
                    self addOpt("Bot Menu", ::newMenu, "bots");
                    self addOpt("Host Options", ::newMenu, "host");
                }
            }
            break;

        case "ts":  // Trickshot Menu
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip", self.NoClipT, ::initNoClip);
            self addToggle("Current Canswap",  self.currCan, ::CurrCanswap);
            self addToggle("Infinite Canswap", self.InfiniteCan, ::InfCanswap);
            self addToggle("Rocket Ride",  self.RPGRide, ::ToggleRPGRide);
            self addToggle("Toggle Instashoots", self.instashoot, ::instashoot);
            self addOpt("Spawn Slide @ Crosshairs", ::slide);
            self addOpt("Spawn Bounce @ Feet", ::normalbounce);
            self addOpt("Spawn Platform @ Feet", ::Platform);
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
            self addOpt("Set Spawn",::spawn_set);
            self addOpt("Unset Spawn", ::unsetSpawn);
            self addToggle("Save & Load", self.snl, ::saveandload);

            if(getDvar("mapname") == "mp_la")
            {
                self addOpt("Garage Rooftop", ::tpToSpot, (-670.031, -1063.55, 111.657));
                self addOpt("Inside Garage", ::tpToSpot, (1112.69, 76.0562, 115.125));
                self addOpt("Plaza Building", ::tpToSpot, (1496.2, 3863.82, 133.125));
            }
            else if(getDvar("mapname") == "mp_carrier")
            {
                self addOpt("Undermap Sui", ::tpToSpot, (-4941.43, -1153.81, -163.875));
                self addOpt("Way Out Net", ::tpToSpot, (2040.76, 836.045, 70.5574));
                self addOpt("Helipad 1", ::tpToSpot, (-177.286, -1350.64, -267.875));
                self addOpt("Helipad 2", ::tpToSpot, (-3661.62, 1314.41, -302.875));
            }
            else if(getDvar("mapname") == "mp_express")
            {
                self addOpt("Bomb Spawn Roof", ::tpToSpot, (-10.5211, 2375.24, 150.793));
                self addOpt("Defenders Spawn Roof", ::tpToSpot, (-24.6459, -2331.52, 155.49));
                self addOpt("Powerlines", ::tpToSpot, (-3948.26, 4425.08, 1220.14));
                self addOpt("Top Roof 1", ::tpToSpot, (4073.33, -2969.08, 92.2084));
                self addOpt("Top Roof 2", ::tpToSpot, (3637.17, 2872.82, 170.579));
            }
            else if(getDvar("mapname") == "mp_raid")
            {
                self addOpt("Sui Roof", ::tpToSpot, (2852.81, 4544.64, 265.129));
                self addOpt("Basketball Court Roof", ::tpToSpot, (-104.969, 3769.45, 240.125));
                self addOpt("Sui Tree Spot", ::tpToSpot, (1814.13, 957.054, 432.095));
                self addOpt("Other Tree Spot", ::tpToSpot, (2721.5, 4763.77, 137.625));
            }
            else if(getDvar("mapname") == "mp_slums")
            {   
                self addOpt("Bomb Spawn Roof", ::tpToSpot, (-2499.07, 4351.68, 1297.82));
                self addOpt("B Roof", ::tpToSpot, (1732.51, -1828.43, 896.125));
                self addOpt("Soccer Field Roof", ::tpToSpot, (145.815, -6037.59, 991.738));
            }
            else if(getDvar("mapname") == "mp_village")
            {
                self addOpt("Hill Top 1", ::tpToSpot, (-1411.22, 16745.9, 4101.9));
                self addOpt("Hill Top 2", ::tpToSpot, (-10215.6, 15513.1, 3895.12));
            }
            else if(getDvar("mapname") == "mp_turbine")
            {
                self addOpt("Inside Turbine", ::tpToSpot, (-864.64, 1384.38, 832.125));
                self addOpt("Stone Path", ::tpToSpot, (-1234.51, -3150.97, 440.166));
            }
            else if(getDvar("mapname") == "mp_socotra")
            {
                self addOpt("Defenders Spawn Roof", ::tpToSpot, (818.847, 2835.1, 1165.13));
                self addOpt("A Barrier", ::tpToSpot, (2466.79, 1417.62, 1132.13));
                self addOpt("Staircase Spot", ::tpToSpot, (1448.92, 2711.74, 481.618)); 
            }
            else if(getDvar("mapname") == "mp_nuketown_2020")
            {
                 self addOpt("Defenders Spawn Roof", ::tpToSpot, (-1544.37, -1190.4, 66.425));
            }
            else if(getDvar("mapname") == "mp_downhill")
            {
                self addOpt("Top Half Pipe", ::tpToSpot, (-445.155, -6253.96, 1875.99));
                self addOpt("A Barrier", ::tpToSpot, (3109.17, 656.519, 1536.13)); 
            }
            else if(getDvar("mapname") == "mp_hydro")
            {
                self addOpt("Bomb Spawn Sui", ::tpToSpot, (3379.91, 3255.91, 216.125));
                self addOpt("Bomb Spawn Bridge", ::tpToSpot, (7962.86, 22554.8, 8040.13));
                self addOpt("Defenders Spawn Sui", ::tpToSpot, (-3333.74, 4064.11, 216.125));
                self addOpt("Defenders Spawn Bridge", ::tpToSpot, (-11819.2, 22546.4, 8040.13));
            }
            else if(getDvar("mapname") == "mp_skate")
            {
                self addOpt("Undermap Sui", ::tpToSpot, (3317.06, -58.111, -19.875));
            }
            else if(getDvar("mapname") == "mp_concert")
            {
                self addOpt("Center Staduim Barrier", ::tpToSpot, (63.2687, 3551.01, 448.125));
                self addOpt("A Stadium Barrier", ::tpToSpot, (-2913.65, 1931.51, 448.125));
                self addOpt("Defenders Undermap", ::tpToSpot, (-1849.62, 527.147, -419.875));
            }
            else if(getDvar("mapname") == "mp_magma")
            {
                self addOpt("Lava Barrier", ::tpToSpot, (112.567, -1921.86, -305.969));
                self addOpt("Undermap Sui", ::tpToSpot, (3614.09, 1368.04, -831.875));
                self addOpt("magtp", "OOM Barrier", ::tpToSpot, (-1248.7, -3339.31, 14.125));
            }
            else if(getDvar("mapname") == "mp_vertigo")
            {
                self addOpt("Skyscraper Sui", ::tpToSpot, (4223.33, 401.677, 1856.13));
                self addOpt("Helipad Barrier", ::tpToSpot, (-2816.21, -75.111, 624.125));
                self addOpt("OOM Helipad 1", ::tpToSpot, (4227.99, -2380.09, -319.875));
                self addOpt("OOM Helipad 2", ::tpToSpot, (4052.68, 3363.54, -319.875));
            }
            else if(getDvar("mapname") == "mp_studio")
            {
                self addOpt("Defenders Spawn OOM", ::tpToSpot, (538.681, -1569.16, 220.093));
                self addOpt("Mid Map Sui", ::tpToSpot, (558.137, 846.333, 145.502));
            }
            else if(getDvar("mapname") == "mp_detour")
            {
                self addOpt("Bomb Spawn Bus Sui", ::tpToSpot, (-3585.75, -735.356, 223.125));
                self addOpt("OOM Sui", ::tpToSpot, (3951.57, 447.974, -13.8756));
            }
            else
            {
                self addOpt("tp", "No Custom Teleports");
            }
            break;

            case "class":  // Class Menu
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
            self addOpt("Camos", ::newMenu, "camos");
            self addOpt("Lethals", ::newMenu, "lethals");
            self addOpt("Tacticals", ::newMenu, "tacticals");
            self addOpt("Save Loadout", ::saveLoadout);
            self addOpt("Delete Saved Loadout", ::deleteSavedLoadout);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            break;

        case "wpns":
            self addMenu("wpns", "Weapons");
            self addOpt("Primary Weapons", ::newMenu, "prims");
            self addOpt("Secondary Weapons", ::newMenu, "secs");
            self addOpt("Special Weapons", ::newMenu, "sWpns");
            break;

        case "prims":
            self addMenu("prims", "Primary Weapons");
            self addOpt("Submachine Guns", ::newMenu, "smgs");
            self addOpt("Assault Rifles", ::newMenu, "ars");
            self addOpt("Shotguns", ::newMenu, "sgs");
            self addOpt("Light Machine Guns", ::newMenu, "lmgs");
            self addOpt("Sniper Rifles", ::newMenu, "srs");
            self addOpt("Assault Shield", ::giveUserWeapon, "riotshield_mp");
            break;

        case "smgs":
            self addMenu("smgs", "Submachine Guns");
            self addOpt("MP7", ::newMenu, "mp7Att");
            self addOpt("PDW-57", ::newMenu, "pdwAtt");
            self addOpt("Vector K10", ::newMenu, "vectAtt");
            self addOpt("MSMC", ::newMenu, "msmcAtt");
            self addOpt("Chicom CQB", ::newMenu, "chicAtt");
            self addOpt("Skorpion EVO", ::newMenu, "skorpAtt");
            self addOpt("Peacekeeper", ::newMenu, "pckprAtt");
            break;

        case "mp7Att":
            self addMenu("mp7Att", "MP7 Attachments");
            self addOpt("None", ::giveUserWeapon, "mp7_mp");
            self addOpt("Reflex", ::giveUserWeapon, "mp7_mp+reflex");
            self addOpt("Laser Sight", ::giveUserWeapon, "mp7_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "mp7_mp+silencer");
            self addOpt("EO Tech", ::giveUserWeapon, "mp7_mp+holo");
            self addOpt("Target Finder", ::giveUserWeapon, "mp7_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "mp7_mp+sf");
            self addOpt("Rapid Fire", ::giveUserWeapon, "mp7_mp+rf");
            self addOpt("MMS", ::giveUserWeapon, "mp7_mp+mms");
            break;

        case "pdwAtt":
            self addMenu("pdwAtt", "PDW-57 Attachments");
            self addOpt("None", ::giveUserWeapon, "pdw57_mp");
            self addOpt("Reflex", ::giveUserWeapon, "pdw57_mp+reflex");
            self addOpt("Laser Sight", ::giveUserWeapon, "pdw57_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "pdw57_mp+silencer");
            self addOpt("EO Tech", ::giveUserWeapon, "pdw57_mp+holo");
            self addOpt("Target Finder", ::giveUserWeapon, "pdw57_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "pdw57_mp+sf");
            self addOpt("Rapid Fire", ::giveUserWeapon, "pdw57_mp+rf");
            self addOpt("MMS", ::giveUserWeapon, "pdw57_mp+mms");
            break;

        case "vectAtt":
            self addMenu("vectAtt", "Vector K10 Attachments");
            self addOpt("None", ::giveUserWeapon, "vector_mp");
            self addOpt("Reflex", ::giveUserWeapon, "vector_mp+reflex");
            self addOpt("Laser Sight", ::giveUserWeapon, "vector_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "vector_mp+silencer");
            self addOpt("EO Tech", ::giveUserWeapon, "vector_mp+holo");
            self addOpt("Target Finder", ::giveUserWeapon, "vector_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "vector_mp+sf");
            self addOpt("Rapid Fire", ::giveUserWeapon, "vector_mp+rf");
            self addOpt("MMS", ::giveUserWeapon, "vector_mp+mms");
            break;

        case "msmcAtt":
            self addMenu("msmcAtt", "MSMC Attachments");
            self addOpt("None", ::giveUserWeapon, "insas_mp");
            self addOpt("Reflex", ::giveUserWeapon, "insas_mp+reflex");
            self addOpt("Laser Sight", ::giveUserWeapon, "insas_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "insas_mp+silencer");
            self addOpt("EO Tech", ::giveUserWeapon, "insas_mp+holo");
            self addOpt("Target Finder", ::giveUserWeapon, "insas_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "insas_mp+sf");
            self addOpt("Rapid Fire", ::giveUserWeapon, "insas_mp+rf");
            self addOpt("MMS", ::giveUserWeapon, "insas_mp+mms");
            break;

        case "chicAtt":
            self addMenu("chicAtt", "Chicom CQB Attachments");
            self addOpt("None", ::giveUserWeapon, "qcw05_mp");
            self addOpt("Reflex", ::giveUserWeapon, "qcw05_mp+reflex"); // Fixed typo
            self addOpt("Laser Sight", ::giveUserWeapon, "qcw05_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "qcw05_mp+silencer");
            self addOpt("EO Tech", ::giveUserWeapon, "qcw05_mp+holo");
            self addOpt("Target Finder", ::giveUserWeapon, "qcw05_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "qcw05_mp+sf");
            self addOpt("Rapid Fire", ::giveUserWeapon, "qcw05_mp+rf");
            self addOpt("MMS", ::giveUserWeapon, "qcw05_mp+mms");
            break;

        case "skorpAtt":
            self addMenu("skorpAtt", "Skorpion EVO Attachments");
            self addOpt("None", ::giveUserWeapon, "evoskorpion_mp");
            self addOpt("Reflex", ::giveUserWeapon, "evoskorpion_mp+reflex");
            self addOpt("Laser Sight", ::giveUserWeapon, "evoskorpion_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "evoskorpion_mp+silencer");
            self addOpt("EO Tech", ::giveUserWeapon, "evoskorpion_mp+holo");
            self addOpt("Target Finder", ::giveUserWeapon, "evoskorpion_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "evoskorpion_mp+sf");
            self addOpt("Rapid Fire", ::giveUserWeapon, "evoskorpion_mp+rf");
            self addOpt("MMS", ::giveUserWeapon, "evoskorpion_mp+mms");
            break;

        case "pckprAtt":
            self addMenu("pckprAtt", "Peacekeeper Attachments");
            self addOpt("None", ::giveUserWeapon, "peacekeeper_mp");
            self addOpt("Reflex", ::giveUserWeapon, "peacekeeper_mp+reflex");
            self addOpt("Laser Sight", ::giveUserWeapon, "peacekeeper_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "peacekeeper_mp+silencer");
            self addOpt("EO Tech", ::giveUserWeapon, "peacekeeper_mp+holo");
            self addOpt("Target Finder", ::giveUserWeapon, "peacekeeper_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "peacekeeper_mp+sf");
            self addOpt("Rapid Fire", ::giveUserWeapon, "peacekeeper_mp+rf");
            self addOpt("MMS", ::giveUserWeapon, "peacekeeper_mp+mms");
            break;

        case "ars":
            self addMenu("ars", "Assault Rifles");
            self addOpt("MTAR", ::newMenu, "mtarAtt");
            self addOpt("Type 95", ::newMenu, "t95Att");
            self addOpt("Swat 556", ::newMenu, "sw556Att");
            self addOpt("FAL OSW", ::newMenu, "falAtt");
            self addOpt("M27", ::newMenu, "m27Att");
            self addOpt("Scar-H", ::newMenu, "scarAtt");
            self addOpt("SMR", ::newMenu, "smrAtt");
            self addOpt("M8A1", ::newMenu, "m8a1Att");
            self addOpt("AN-94", ::newMenu, "an94Att");
            break;

        case "mtarAtt":
            self addMenu("mtarAtt", "MTAR Attachments");
            self addOpt("None", ::giveUserWeapon, "tar21_mp");
            self addOpt("Reflex", ::giveUserWeapon, "tar21_mp+reflex");
            self addOpt("ACOG", ::giveUserWeapon, "tar21_mp+acog");
            self addOpt("Target Finder", ::giveUserWeapon, "tar21_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "tar21_mp+sf");
            self addOpt("EO Tech", ::giveUserWeapon, "tar21_mp+holo");
            self addOpt("Suppressor", ::giveUserWeapon, "tar21_mp+silencer");
            self addOpt("Hybrid Sight", ::giveUserWeapon, "tar21_mp+dualoptic");
            self addOpt("Grenade Launcher", ::giveUserWeapon, "tar21_mp+gl");
            self addOpt("MMS", ::giveUserWeapon, "tar21_mp+mms");
            break;

        case "t95Att":
            self addMenu("t95Att", "Type 95 Attachments");
            self addOpt("None", ::giveUserWeapon, "type95_mp");
            self addOpt("Reflex", ::giveUserWeapon, "type95_mp+reflex");
            self addOpt("ACOG", ::giveUserWeapon, "type95_mp+acog");
            self addOpt("Target Finder", ::giveUserWeapon, "type95_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "type95_mp+sf");
            self addOpt("EO Tech", ::giveUserWeapon, "type95_mp+holo");
            self addOpt("Suppressor", ::giveUserWeapon, "type95_mp+silencer");
            self addOpt("Hybrid Sight", ::giveUserWeapon, "type95_mp+dualoptic");
            self addOpt("Grenade Launcher", ::giveUserWeapon, "type95_mp+gl");
            self addOpt("MMS", ::giveUserWeapon, "type95_mp+mms");
            break;

        case "sw556Att":
            self addMenu("sw556Att", "Swat 556 Attachments");
            self addOpt("None", ::giveUserWeapon, "sig556_mp");
            self addOpt("Reflex", ::giveUserWeapon, "sig556_mp+reflex");
            self addOpt("ACOG", ::giveUserWeapon, "sig556_mp+acog");
            self addOpt("Target Finder", ::giveUserWeapon, "sig556_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "sig556_mp+sf");
            self addOpt("EO Tech", ::giveUserWeapon, "sig556_mp+holo");
            self addOpt("Suppressor", ::giveUserWeapon, "sig556_mp+silencer");
            self addOpt("Hybrid Sight", ::giveUserWeapon, "sig556_mp+dualoptic");
            self addOpt("Grenade Launcher", ::giveUserWeapon, "sig556_mp+gl");
            self addOpt("MMS", ::giveUserWeapon, "sig556_mp+mms");
            break;

        case "falAtt":
            self addMenu("falAtt", "FAL OSW Attachments");
            self addOpt("None", ::giveUserWeapon, "sa58_mp");
            self addOpt("Reflex", ::giveUserWeapon, "sa58_mp+reflex");
            self addOpt("ACOG", ::giveUserWeapon, "sa58_mp+acog");
            self addOpt("Target Finder", ::giveUserWeapon, "sa58_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "sa58_mp+sf");
            self addOpt("EO Tech", ::giveUserWeapon, "sa58_mp+holo");
            self addOpt("Suppressor", ::giveUserWeapon, "sa58_mp+silencer");
            self addOpt("Hybrid Sight", ::giveUserWeapon, "sa58_mp+dualoptic");
            self addOpt("Grenade Launcher", ::giveUserWeapon, "sa58_mp+gl");
            self addOpt("MMS", ::giveUserWeapon, "sa58_mp+mms");
            break;

        case "m27Att":
            self addMenu("m27Att", "M27 Attachments");
            self addOpt("None", ::giveUserWeapon, "hk416_mp");
            self addOpt("Reflex", ::giveUserWeapon, "hk416_mp+reflex");
            self addOpt("ACOG", ::giveUserWeapon, "hk416_mp+acog");
            self addOpt("Target Finder", ::giveUserWeapon, "hk416_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "hk416_mp+sf");
            self addOpt("EO Tech", ::giveUserWeapon, "hk416_mp+holo");
            self addOpt("Suppressor", ::giveUserWeapon, "hk416_mp+silencer");
            self addOpt("Hybrid Sight", ::giveUserWeapon, "hk416_mp+dualoptic");
            self addOpt("Grenade Launcher", ::giveUserWeapon, "hk416_mp+gl");
            self addOpt("MMS", ::giveUserWeapon, "hk416_mp+mms");
            break;

        case "scarAtt":
            self addMenu("scarAtt", "Scar-H Attachments");
            self addOpt("None", ::giveUserWeapon, "scar_mp");
            self addOpt("Reflex", ::giveUserWeapon, "scar_mp+reflex");
            self addOpt("ACOG", ::giveUserWeapon, "scar_mp+acog");
            self addOpt("Target Finder", ::giveUserWeapon, "scar_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "scar_mp+sf");
            self addOpt("EO Tech", ::giveUserWeapon, "scar_mp+holo");
            self addOpt("Suppressor", ::giveUserWeapon, "scar_mp+silencer");
            self addOpt("Hybrid Sight", ::giveUserWeapon, "scar_mp+dualoptic");
            self addOpt("Grenade Launcher", ::giveUserWeapon, "scar_mp+gl");
            self addOpt("MMS", ::giveUserWeapon, "scar_mp+mms");
            break;

        case "smrAtt":
            self addMenu("smrAtt", "SMR Attachments");
            self addOpt("None", ::giveUserWeapon, "saritch_mp");
            self addOpt("Reflex", ::giveUserWeapon, "saritch_mp+reflex");
            self addOpt("ACOG", ::giveUserWeapon, "saritch_mp+acog");
            self addOpt("Target Finder", ::giveUserWeapon, "saritch_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "saritch_mp+sf");
            self addOpt("EO Tech", ::giveUserWeapon, "saritch_mp+holo");
            self addOpt("Suppressor", ::giveUserWeapon, "saritch_mp+silencer");
            self addOpt("Hybrid Sight", ::giveUserWeapon, "saritch_mp+dualoptic");
            self addOpt("Grenade Launcher", ::giveUserWeapon, "saritch_mp+gl");
            self addOpt("MMS", ::giveUserWeapon, "saritch_mp+mms");
            break;

        case "m8a1Att":
            self addMenu("m8a1Att", "M8A1 Attachments");
            self addOpt("None", ::giveUserWeapon, "xm8_mp");
            self addOpt("Reflex", ::giveUserWeapon, "xm8_mp+reflex");
            self addOpt("ACOG", ::giveUserWeapon, "xm8_mp+acog");
            self addOpt("Target Finder", ::giveUserWeapon, "xm8_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "xm8_mp+sf");
            self addOpt("EO Tech", ::giveUserWeapon, "xm8_mp+holo");
            self addOpt("Suppressor", ::giveUserWeapon, "xm8_mp+silencer");
            self addOpt("Hybrid Sight", ::giveUserWeapon, "xm8_mp+dualoptic");
            self addOpt("Grenade Launcher", ::giveUserWeapon, "xm8_mp+gl");
            self addOpt("MMS", ::giveUserWeapon, "xm8_mp+mms");
            break;

        case "an94Att":
            self addMenu("an94Att", "AN-94 Attachments");
            self addOpt("None", ::giveUserWeapon, "an94_mp");
            self addOpt("Reflex", ::giveUserWeapon, "an94_mp+reflex");
            self addOpt("ACOG", ::giveUserWeapon, "an94_mp+acog");
            self addOpt("Target Finder", ::giveUserWeapon, "an94_mp+rangefinder");
            self addOpt("Select Fire", ::giveUserWeapon, "an94_mp+sf");
            self addOpt("EO Tech", ::giveUserWeapon, "an94_mp+holo");
            self addOpt("Suppressor", ::giveUserWeapon, "an94_mp+silencer");
            self addOpt("Hybrid Sight", ::giveUserWeapon, "an94_mp+dualoptic");
            self addOpt("Grenade Launcher", ::giveUserWeapon, "an94_mp+gl");
            self addOpt("MMS", ::giveUserWeapon, "an94_mp+mms");
            break;

        case "sgs":
            self addMenu("sgs", "Shotguns");
            self addOpt("Remington 870 MCS", ::newMenu, "r870Att");
            self addOpt("S12", ::newMenu, "s12Att");
            self addOpt("KSG", ::newMenu, "ksgAtt");
            self addOpt("M1216", ::newMenu, "m12Att");
            break;

        case "r870Att":
            self addMenu("r870Att", "Remington 870 MCS Attachments");
            self addOpt("None", ::giveUserWeapon, "870mcs_mp");
            self addOpt("Reflex", ::giveUserWeapon, "870mcs_mp+reflex");
            self addOpt("Laser Sight", ::giveUserWeapon, "870mcs_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "870mcs_mp+silencer");
            self addOpt("Quickdraw", ::giveUserWeapon, "870mcs_mp+fastads");
            self addOpt("MMS", ::giveUserWeapon, "870mcs_mp+mms");
            break;

        case "s12Att":
            self addMenu("s12Att", "S12 Attachments");
            self addOpt("None", ::giveUserWeapon, "saiga12_mp");
            self addOpt("Reflex", ::giveUserWeapon, "saiga12_mp+reflex");
            self addOpt("Laser Sight", ::giveUserWeapon, "saiga12_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "saiga12_mp+silencer");
            self addOpt("Quickdraw", ::giveUserWeapon, "saiga12_mp+fastads");
            self addOpt("MMS", ::giveUserWeapon, "saiga12_mp+mms");
            break;

        case "ksgAtt":
            self addMenu("ksgAtt", "KSG Attachments");
            self addOpt("None", ::giveUserWeapon, "ksg_mp");
            self addOpt("Reflex", ::giveUserWeapon, "ksg_mp+reflex");
            self addOpt("Laser Sight", ::giveUserWeapon, "ksg_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "ksg_mp+silencer");
            self addOpt("Quickdraw", ::giveUserWeapon, "ksg_mp+fastads");
            self addOpt("MMS", ::giveUserWeapon, "ksg_mp+mms");
            break;

        case "m12Att":
            self addMenu("m12Att", "M1216 Attachments");
            self addOpt("None", ::giveUserWeapon, "srm1216_mp");
            self addOpt("Reflex", ::giveUserWeapon, "srm1216_mp+reflex");
            self addOpt("Laser Sight", ::giveUserWeapon, "srm1216_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "srm1216_mp+silencer");
            self addOpt("Quickdraw", ::giveUserWeapon, "srm1216_mp+fastads");
            self addOpt("MMS", ::giveUserWeapon, "srm1216_mp+mms");
            break;

        case "lmgs":
            self addMenu("lmgs", "Light Machine Guns");
            self addOpt("MK48", ::newMenu, "mk48Att");
            self addOpt("QBB LSW", ::newMenu, "qbbAtt");
            self addOpt("LSAT", ::newMenu, "lsatAtt");
            self addOpt("HAMR", ::newMenu, "hamrAtt");
            break;

        case "mk48Att":
            self addMenu("mk48Att", "MK48 Attachments");
            self addOpt("None", ::giveUserWeapon, "mk48_mp");
            self addOpt("EO Tech", ::giveUserWeapon, "mk48_mp+holo");
            self addOpt("Reflex", ::giveUserWeapon, "mk48_mp+reflex");
            self addOpt("Target Finder", ::giveUserWeapon, "mk48_mp+rangefinder");
            self addOpt("ACOG", ::giveUserWeapon, "mk48_mp+acog");
            self addOpt("Laser Sight", ::giveUserWeapon, "mk48_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "mk48_mp+silencer");
            self addOpt("Variable Zoom", ::giveUserWeapon, "mk48_mp+vzoom");
            self addOpt("Hybrid", ::giveUserWeapon, "mk48_mp+dualoptic");
            self addOpt("Dual Band Scope", ::giveUserWeapon, "mk48_mp+ir");
            break;

        case "qbbAtt":
            self addMenu("qbbAtt", "QBB LSW Attachments");
            self addOpt("None", ::giveUserWeapon, "qbb95_mp");
            self addOpt("EO Tech", ::giveUserWeapon, "qbb95_mp+holo");
            self addOpt("Reflex", ::giveUserWeapon, "qbb95_mp+reflex");
            self addOpt("Target Finder", ::giveUserWeapon, "qbb95_mp+rangefinder");
            self addOpt("ACOG", ::giveUserWeapon, "qbb95_mp+acog");
            self addOpt("Laser Sight", ::giveUserWeapon, "qbb95_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "qbb95_mp+silencer");
            self addOpt("Variable Zoom", ::giveUserWeapon, "qbb95_mp+vzoom");
            self addOpt("Hybrid", ::giveUserWeapon, "qbb95_mp+dualoptic");
            self addOpt("Dual Band Scope", ::giveUserWeapon, "qbb95_mp+ir");
            break;

        case "lsatAtt":
            self addMenu("lsatAtt", "LSAT Attachments");
            self addOpt("None", ::giveUserWeapon, "lsat_mp");
            self addOpt("EO Tech", ::giveUserWeapon, "lsat_mp+holo");
            self addOpt("Reflex", ::giveUserWeapon, "lsat_mp+reflex");
            self addOpt("Target Finder", ::giveUserWeapon, "lsat_mp+rangefinder");
            self addOpt("ACOG", ::giveUserWeapon, "lsat_mp+acog");
            self addOpt("Laser Sight", ::giveUserWeapon, "lsat_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "lsat_mp+silencer");
            self addOpt("Variable Zoom", ::giveUserWeapon, "lsat_mp+vzoom");
            self addOpt("Hybrid", ::giveUserWeapon, "lsat_mp+dualoptic");
            self addOpt("Dual Band Scope", ::giveUserWeapon, "lsat_mp+ir");
            break;

        case "hamrAtt":
            self addMenu("hamrAtt", "HAMR Attachments");
            self addOpt("None", ::giveUserWeapon, "hamr_mp");
            self addOpt("EO Tech", ::giveUserWeapon, "hamr_mp+holo");
            self addOpt("Reflex", ::giveUserWeapon, "hamr_mp+reflex");
            self addOpt("Target Finder", ::giveUserWeapon, "hamr_mp+rangefinder");
            self addOpt("ACOG", ::giveUserWeapon, "hamr_mp+acog");
            self addOpt("Laser Sight", ::giveUserWeapon, "hamr_mp+steadyaim");
            self addOpt("Suppressor", ::giveUserWeapon, "hamr_mp+silencer");
            self addOpt("Variable Zoom", ::giveUserWeapon, "hamr_mp+vzoom");
            self addOpt("Hybrid", ::giveUserWeapon, "hamr_mp+dualoptic");
            self addOpt("Dual Band Scope", ::giveUserWeapon, "hamr_mp+ir");
            break;

        case "srs":
            self addMenu("srs", "Sniper Rifles");
            self addOpt("SVU-AS", ::newMenu, "svuAtt");
            self addOpt("DSR-50", ::newMenu, "dsr50Att");
            self addOpt("Ballista", ::newMenu, "ballistaAtt");
            self addOpt("XPR-50", ::newMenu, "as50Att");
            break;

        case "svuAtt":
            self addMenu("svuAtt", "SVU-AS Attachments");
            self addOpt("None", ::giveUserWeapon, "svu_mp");
            self addOpt("Suppressor", ::giveUserWeapon, "svu_mp+silencer");
            self addOpt("Variable Zoom", ::giveUserWeapon, "svu_mp+vzoom");
            self addOpt("ACOG", ::giveUserWeapon, "svu_mp+acog");
            self addOpt("Laser Sight", ::giveUserWeapon, "svu_mp+steadyaim");
            self addOpt("Dual Band Scope", ::giveUserWeapon, "svu_mp+ir");
            break;

        case "dsr50Att":
            self addMenu("dsr50Att", "DSR-50 Attachments");
            self addOpt("None", ::giveUserWeapon, "dsr50_mp");
            self addOpt("Suppressor", ::giveUserWeapon, "dsr50_mp+silencer");
            self addOpt("Variable Zoom", ::giveUserWeapon, "dsr50_mp+vzoom");
            self addOpt("ACOG", ::giveUserWeapon, "dsr50_mp+acog");
            self addOpt("Laser Sight", ::giveUserWeapon, "dsr50_mp+steadyaim");
            self addOpt("Dual Band Scope", ::giveUserWeapon, "dsr50_mp+ir");
            break;

        case "ballistaAtt":
            self addMenu("ballistaAtt", "Ballista Attachments");
            self addOpt("None", ::giveUserWeapon, "ballista_mp");
            self addOpt("Suppressor", ::giveUserWeapon, "ballista_mp+silencer");
            self addOpt("Variable Zoom", ::giveUserWeapon, "ballista_mp+vzoom");
            self addOpt("ACOG", ::giveUserWeapon, "ballista_mp+acog");
            self addOpt("Laser Sight", ::giveUserWeapon, "ballista_mp+steadyaim");
            self addOpt("Dual Band Scope", ::giveUserWeapon, "ballista_mp+ir");
            self addOpt("Iron Sight", ::giveUserWeapon, "ballista_mp+is");
            break;

        case "as50Att":
            self addMenu("as50Att", "XPR-50 Attachments");
            self addOpt("None", ::giveUserWeapon, "as50_mp");
            self addOpt("Suppressor", ::giveUserWeapon, "as50_mp+silencer");
            self addOpt("Variable Zoom", ::giveUserWeapon, "as50_mp+vzoom");
            self addOpt("ACOG", ::giveUserWeapon, "as50_mp+acog");
            self addOpt("Laser Sight", ::giveUserWeapon, "as50_mp+steadyaim");
            self addOpt("Dual Band Scope", ::giveUserWeapon, "as50_mp+ir");
            break;

        case "secs":
            self addMenu("secs", "Secondary Weapons");
            self addOpt("Pistols", ::newMenu, "hgs");
            self addOpt("Launchers", ::newMenu, "lnchrs");
            self addOpt("Specials", ::newMenu, "specs");
            break;

        case "hgs":
            self addMenu("hgs", "Pistols");
            self addOpt("Five Seven", ::newMenu, "57Att");
            self addOpt("Tac-45", ::newMenu, "t45Att");
            self addOpt("B23R", ::newMenu, "b23rAtt");
            self addOpt("Executioner", ::newMenu, "execAtt");
            self addOpt("KAP-40", ::newMenu, "k40Att");
            break;

        case "57Att":
            self addMenu("57Att", "Five Seven Attachments");
            self addOpt("None", ::giveUserWeapon, "fiveseven_mp");
            self addOpt("Reflex", ::giveUserWeapon, "fiveseven_mp+reflex");
            self addOpt("Extended Mag", ::giveUserWeapon, "fiveseven_mp+extclip");
            self addOpt("Laser Sight", ::giveUserWeapon, "fiveseven_mp+steadyaim");
            self addOpt("Long Barrel", ::giveUserWeapon, "fiveseven_mp+extbarrel");
            self addOpt("FMJ", ::giveUserWeapon, "fiveseven_mp+fmj");
            self addOpt("Fast Mags", ::giveUserWeapon, "fiveseven_mp+dualclip");
            self addOpt("Suppressor", ::giveUserWeapon, "fiveseven_mp+silencer");
            self addOpt("Tactical Knife", ::giveUserWeapon, "fiveseven_mp+tacknife");
            self addOpt("Dual Wield", ::giveUserWeapon, "fiveseven_dw_mp");
            break;

        case "t45Att":
            self addMenu("t45Att", "Tac-45 Attachments");
            self addOpt("None", ::giveUserWeapon, "fnp45_mp");
            self addOpt("Reflex", ::giveUserWeapon, "fnp45_mp+reflex");
            self addOpt("Extended Mag", ::giveUserWeapon, "fnp45_mp+extclip");
            self addOpt("Laser Sight", ::giveUserWeapon, "fnp45_mp+steadyaim");
            self addOpt("Long Barrel", ::giveUserWeapon, "fnp45_mp+extbarrel");
            self addOpt("FMJ", ::giveUserWeapon, "fnp45_mp+fmj");
            self addOpt("Fast Mags", ::giveUserWeapon, "fnp45_mp+dualclip");
            self addOpt("Suppressor", ::giveUserWeapon, "fnp45_mp+silencer");
            self addOpt("Tactical Knife", ::giveUserWeapon, "fnp45_mp+tacknife");
            self addOpt("Dual Wield", ::giveUserWeapon, "fnp45_dw_mp");
            break;

        case "b23rAtt":
            self addMenu("b23rAtt", "B23R Attachments");
            self addOpt("None", ::giveUserWeapon, "beretta93r_mp");
            self addOpt("Reflex", ::giveUserWeapon, "beretta93r_mp+reflex");
            self addOpt("Extended Mag", ::giveUserWeapon, "beretta93r_mp+extclip");
            self addOpt("Laser Sight", ::giveUserWeapon, "beretta93r_mp+steadyaim");
            self addOpt("Long Barrel", ::giveUserWeapon, "beretta93r_mp+extbarrel");
            self addOpt("FMJ", ::giveUserWeapon, "beretta93r_mp+fmj");
            self addOpt("Fast Mags", ::giveUserWeapon, "beretta93r_mp+dualclip");
            self addOpt("Suppressor", ::giveUserWeapon, "beretta93r_mp+silencer");
            self addOpt("Tactical Knife", ::giveUserWeapon, "beretta93r_mp+tacknife");
            self addOpt("Dual Wield", ::giveUserWeapon, "beretta93r_dw_mp");
            break;

        case "execAtt":
            self addMenu("execAtt", "Executioner Attachments");
            self addOpt("None", ::giveUserWeapon, "judge_mp");
            self addOpt("Reflex", ::giveUserWeapon, "judge_mp+reflex");
            self addOpt("Extended Mag", ::giveUserWeapon, "judge_mp+extclip");
            self addOpt("Laser Sight", ::giveUserWeapon, "judge_mp+steadyaim");
            self addOpt("Long Barrel", ::giveUserWeapon, "judge_mp+extbarrel");
            self addOpt("FMJ", ::giveUserWeapon, "judge_mp+fmj");
            self addOpt("Fast Mags", ::giveUserWeapon, "judge_mp+dualclip");
            self addOpt("Suppressor", ::giveUserWeapon, "judge_mp+silencer");
            self addOpt("Tactical Knife", ::giveUserWeapon, "judge_mp+tacknife");
            self addOpt("Dual Wield", ::giveUserWeapon, "judge_dw_mp");
            break;

        case "k40Att":
            self addMenu("k40Att", "KAP-40 Attachments");
            self addOpt("None", ::giveUserWeapon, "kard_mp");
            self addOpt("Reflex", ::giveUserWeapon, "kard_mp+reflex");
            self addOpt("Extended Mag", ::giveUserWeapon, "kard_mp+extclip");
            self addOpt("Laser Sight", ::giveUserWeapon, "kard_mp+steadyaim");
            self addOpt("Long Barrel", ::giveUserWeapon, "kard_mp+extbarrel");
            self addOpt("FMJ", ::giveUserWeapon, "kard_mp+fmj");
            self addOpt("Fast Mags", ::giveUserWeapon, "kard_mp+dualclip");
            self addOpt("Suppressor", ::giveUserWeapon, "kard_mp+silencer");
            self addOpt("Tactical Knife", ::giveUserWeapon, "kard_mp+tacknife");
            self addOpt("Dual Wield", ::giveUserWeapon, "kard_dw_mp");
            break;

        case "lnchrs":
            self addMenu("lnchrs", "Launchers");
            self addOpt("SMAW", ::giveUserWeapon, "smaw_mp");
            self addOpt("FHJ-18 AA", ::giveUserWeapon, "fhj18_mp");
            self addOpt("RPG", ::giveUserWeapon, "usrpg_mp");
            break;

        case "specs":
            self addMenu("specs", "Specials");
            self addOpt("Crossbow", ::newMenu, "cbowAtt");
            self addOpt("Ballistic Knife", ::giveUserWeapon, "knife_ballistic_mp");
            break;

        case "cbowAtt":
            self addMenu("cbowAtt", "Crossbow Attachments");
            self addOpt("None", ::giveUserWeapon, "crossbow_mp");
            self addOpt("ACOG Sight", ::giveUserWeapon, "crossbow_mp+acog");
            self addOpt("Tri-Bolt", ::giveUserWeapon, "crossbow_mp+stackfire");
            self addOpt("Dual Band Scope", ::giveUserWeapon, "crossbow_mp+ir");
            self addOpt("Reflex", ::giveUserWeapon, "crossbow_mp+reflex");
            self addOpt("Variable Zoom", ::giveUserWeapon, "crossbow_mp+vzoom");
            break;

        case "sWpns":
            self addMenu("sWpns", "Special Weapons");
            self addOpt("Bomb Briefcase", ::giveUserWeapon, "briefcase_bomb_defuse_mp");
            self addOpt("Shield Knife", ::giveUserWeapon, "knife_held_mp");
            self addOpt("Default Weapon", ::giveUserWeapon, "defaultweapon_mp");
            break;

        case "camos":
            self addMenu("camos", "Camos");
            self addOpt("Remove Camo", ::changeCamo, 0);
            self addOpt("Random Camo", ::randomCamo);
            self addOpt("Base Camos", ::newMenu, "baseCamos");
            self addOpt("DLC Camos", ::newMenu, "dlcCamos");
            self addOpt("Secret Camos", ::newMenu, "secretCamos");
            break;

        case "baseCamos":
            self addMenu("baseCamos", "Base Camos");
            self addOpt("DEVGRU", ::changeCamo, 1);
            self addOpt("A-TACS AU", ::changeCamo, 2);
            self addOpt("ERDL", ::changeCamo, 3);
            self addOpt("Siberia", ::changeCamo, 4);
            self addOpt("Choco", ::changeCamo, 5);
            self addOpt("Blue Tiger", ::changeCamo, 6);
            self addOpt("Bloodshot", ::changeCamo, 7);
            self addOpt("Ghostex: Delta 6", ::changeCamo, 8);
            self addOpt("Kryptek: Typhon", ::changeCamo, 9);
            self addOpt("Carbon Fiber", ::changeCamo, 10);
            self addOpt("Cherry Blossom", ::changeCamo, 11);
            self addOpt("Art of War", ::changeCamo, 12);
            self addOpt("Ronin", ::changeCamo, 13);
            self addOpt("Skulls", ::changeCamo, 14);
            self addOpt("Gold", ::changeCamo, 15);
            self addOpt("Diamond", ::changeCamo, 16);
            break;

        case "dlcCamos":
            self addMenu("dlcCamos", "DLC Camos");
            self addOpt("Elite", ::changeCamo, 17);
            self addOpt("Benjamins", ::changeCamo, 21);
            self addOpt("Dia De Muertos", ::changeCamo, 22);
            self addOpt("Graffiti", ::changeCamo, 23);
            self addOpt("Kawaii", ::changeCamo, 24);
            self addOpt("Party Rock", ::changeCamo, 25);
            self addOpt("Zombies", ::changeCamo, 26);
            self addOpt("Viper", ::changeCamo, 27);
            self addOpt("Bacon", ::changeCamo, 28);
            self addOpt("Dragon", ::changeCamo, 32);
            self addOpt("Cyborg", ::changeCamo, 31);
            self addOpt("Aqua", ::changeCamo, 34);
            self addOpt("Breach", ::changeCamo, 35);
            self addOpt("Coyote", ::changeCamo, 36);
            self addOpt("Glam", ::changeCamo, 37);
            self addOpt("Rogue", ::changeCamo, 38);
            self addOpt("Pack-a-Punch", ::changeCamo, 39);
            self addOpt("UK Punk", ::changeCamo, 20);
            self addOpt("Paladin", ::changeCamo, 30);
            self addOpt("Comics", ::changeCamo, 33);
            self addOpt("Afterlife", ::changeCamo, 44);
            self addOpt("Dead Mans Hand", ::changeCamo, 40);
            self addOpt("Beast", ::changeCamo, 41);
            self addOpt("Octane", ::changeCamo, 42);
            self addOpt("Weaponized 115", ::changeCamo, 43);
            break;

        case "secretCamos":
            self addMenu("secretCamos", "Secret Camos");
            self addOpt("Digital", ::changeCamo, 18);
            self addOpt("Ghosts", ::changeCamo, 29);
            self addOpt("Advanced Warfare", ::changeCamo, 45);
            break;

        case "lethals":
            self addMenu("lethals", "Lethals");
            self addOpt("Frag", ::giveUserLethal, "frag_grenade_mp");
            self addOpt("Semtex", ::giveUserLethal, "sticky_grenade_mp");
            self addOpt("Combat Axe", ::giveUserLethal, "hatchet_mp");
            self addOpt("Bouncing Betty", ::giveUserLethal, "bouncingbetty_mp");
            self addOpt("C4", ::giveUserLethal, "satchel_charge_mp");
            self addOpt("Claymore", ::giveUserLethal, "claymore_mp");
            break;

        case "tacticals":
            self addMenu("tacticals", "Tacticals");
            self addOpt("Concussion Grenade", ::giveUserTactical, "concussion_grenade_mp");
            self addOpt("Smoke Grenade", ::giveUserTactical, "willy_pete_mp");
            self addOpt("Sensor Grenade", ::giveUserTactical, "sensor_grenade_mp");
            self addOpt("EMP Grenade", ::giveUserTactical, "emp_grenade_mp");
            self addOpt("Shock Charge", ::giveUserTactical, "proximity_grenade_aoe_mp");
            self addOpt("Black Hat", ::giveUserTactical, "pda_hack_mp");
            self addOpt("Flashbang", ::giveUserTactical, "flash_grenade_mp");
            self addOpt("Trophy System", ::giveUserTactical, "trophy_system_mp");
            self addOpt("Tactical Insertion", ::giveUserTactical, "tactical_insertion_mp");
            break;


                case "afthit":  // Afterhits Menu
            self addMenu("afthit", "Afterhits Menu");
            self addOpt("Assault Rifles", ::newMenu, "afthit_ar");
            self addOpt("Submachine Guns", ::newMenu, "afthit_smg");
            self addOpt("Shotguns", ::newMenu, "afthit_shot");
            self addOpt("Light Machine Guns", ::newMenu, "afthit_lmg");
            self addOpt("Sniper Rifles", ::newMenu, "afthit_snp");
            self addOpt("Pistols", ::newMenu, "afthit_pist");
            self addOpt("Launchers", ::newMenu, "afthit_lchr");
            self addOpt("Special Weapons", ::newMenu, "afthit_spec");
            break;

        case "afthit_ar":
            self addMenu("afthit_ar", "Assault Rifles");
            self addOpt("TAR-21", ::AfterHit, "tar21_mp");
            self addOpt("Type 95", ::AfterHit, "type95_mp");
            self addOpt("Sig 556", ::AfterHit, "sig556_mp");
            self addOpt("SA58", ::AfterHit, "sa58_mp");
            self addOpt("HK416", ::AfterHit, "hk416_mp");
            self addOpt("SCAR-H", ::AfterHit, "scar_mp");
            self addOpt("M27", ::AfterHit, "saritch_mp");
            self addOpt("XM8", ::AfterHit, "xm8_mp");
            self addOpt("AN-94", ::AfterHit, "an94_mp");
            break;

        case "afthit_smg":
            self addMenu("afthit_smg", "Submachine Guns");
            self addOpt("MP7", ::AfterHit, "mp7_mp");
            self addOpt("PDW-57", ::AfterHit, "pdw57_mp");
            self addOpt("Vector", ::AfterHit, "vector_mp");
            self addOpt("Chicom CQB", ::AfterHit, "insas_mp");
            self addOpt("QCW-05", ::AfterHit, "qcw05_mp");
            self addOpt("Skorpion EVO", ::AfterHit, "evoskorpion_mp");
            self addOpt("Peacekeeper", ::AfterHit, "peacekeeper_mp");
            break;

        case "afthit_shot":
            self addMenu("afthit_shot", "Shotguns");
            self addOpt("870 MCS", ::AfterHit, "870mcs_mp");
            self addOpt("Saiga 12", ::AfterHit, "saiga12_mp");
            self addOpt("KSG", ::AfterHit, "ksg_mp");
            self addOpt("SRM 1216", ::AfterHit, "srm1216_mp");
            break;

        case "afthit_lmg":
            self addMenu("afthit_lmg", "Light Machine Guns");
            self addOpt("MK48", ::AfterHit, "mk48_mp");
            self addOpt("QBB-95", ::AfterHit, "qbb95_mp");
            self addOpt("LSAT", ::AfterHit, "lsat_mp");
            self addOpt("HAMR", ::AfterHit, "hamr_mp");
            break;

        case "afthit_snp":
            self addMenu("afthit_snp", "Sniper Rifles");
            self addOpt("SVU-AS", ::AfterHit, "svu_mp");
            self addOpt("DSR-50", ::AfterHit, "dsr50_mp");
            self addOpt("Ballista", ::AfterHit, "ballista_mp");
            self addOpt("XPR-50", ::AfterHit, "as50_mp");
            break;

        case "afthit_pist":
            self addMenu("afthit_pist", "Pistols");
            self addOpt("Dual Kap-40", ::AfterHit, "kard_dw_mp");
            self addOpt("Dual TAC-45", ::AfterHit, "fnp45_dw_mp");
            self addOpt("Dual Five-Seven", ::AfterHit, "fiveseven_dw_mp");
            self addOpt("Dual Executioner", ::AfterHit, "judge_dw_mp");
            self addOpt("Dual B23R", ::AfterHit, "beretta93r_dw_mp");
            self addOpt("Dual Five-Seven", ::AfterHit, "fiveseven_mp");
            self addOpt("TAC-45", ::AfterHit, "fnp45_mp");
            self addOpt("B23R", ::AfterHit, "beretta93r_mp");
            self addOpt("Executioner", ::AfterHit, "judge_mp");
            self addOpt("Kap-40", ::AfterHit, "kard_mp");
            break;

        case "afthit_lchr":
            self addMenu("afthit_lchr", "Launchers");
            self addOpt("War Machine", ::AfterHit, "m32_mp");
            self addOpt("SMAW", ::AfterHit, "smaw_mp");
            self addOpt("FHJ-18", ::AfterHit, "fhj18_mp");
            self addOpt("RPG", ::AfterHit, "usrpg_mp");
            break;

        case "afthit_spec":
            self addMenu("afthit_spec", "Special Weapons");
            self addOpt("CSGO Knife", ::AfterHit, "knife_held_mp");
            self addOpt("Default Weapon", ::AfterHit, "defaultweapon_mp");
            self addOpt("Death Machine", ::AfterHit, "minigun_mp");
            self addOpt("Riot Shield", ::AfterHit, "riotshield_mp");
            self addOpt("Crossbow", ::AfterHit, "crossbow_mp");
            self addOpt("Ballistic Knife", ::AfterHit, "knife_ballistic_mp");
            self addOpt("Bomb", ::AfterHit, "briefcase_bomb_mp");
            self addOpt("Claymore", ::AfterHit, "claymore_mp");
            self addOpt("Car", ::AfterHit, "destructible_car_mp");
            break;


        case "kstrks": 
            self addMenu("kstrks", "Killstreak Menu");
            self addOpt("UAV", ::doKillstreak, "radar_mp");
            self addOpt("RC-XD", ::doKillstreak, "rcbomb_mp");
            self addOpt("Hunter Killer", ::doKillstreak, "inventory_missile_drone_mp");
            self addOpt("Care Package", ::doKillstreak, "inventory_supply_drop_mp");
            self addOpt("Counter-UAV", ::doKillstreak, "counteruav_mp");
            self addOpt("Guardian", ::doKillstreak, "microwaveturret_mp");
            self addOpt("Hellstorm", ::doKillstreak, "remote_missile_mp");
            self addOpt("Lightning Strike", ::doKillstreak, "planemortar_mp");
            self addOpt("Sentry Gun", ::doKillstreak, "autoturret_mp");
            self addOpt("Death Machine", ::doKillstreak, "inventory_minigun_mp");
            self addOpt("War Machine", ::doKillstreak, "inventory_m32_mp");
            self addOpt("Dragonfire", ::doKillstreak, "qrdrone_mp");
            self addOpt("AGR", ::doKillstreak, "inventory_ai_tank_drop_mp");
            self addOpt("Stealth Chopper", ::doKillstreak, "helicopter_comlink_mp");
            self addOpt("VSAT", ::doKillstreak, "radardirection_mp");
            self addOpt("Escort Drone", ::doKillstreak, "helicopter_guard_mp");
            self addOpt("EMP Systems", ::doKillstreak, "emp_mp");
            self addOpt("Warthog", ::doKillstreak, "straferun_mp");
            self addOpt("Lodestar", ::doKillstreak, "remote_mortar_mp");
            self addOpt("VTOL Warship", ::doKillstreak, "helicopter_player_gunner_mp");
            self addOpt("K9 Unit", ::doKillstreak, "dogs_mp");
            self addOpt("Swarm", ::doKillstreak, "missile_swarm_mp");
            break;

        case "bots":  // Bot Menu (host/dev only)
            self addMenu("bots", "Bot Menu");
            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
            self addOpt("Teleport Bots to Crosshairs", ::tpBots);
            self addOpt("Kick Bots", ::kickAllBots);
            self addOpt("Fill Bots", ::SpawnBotsAmount,18); 
            break;

        case "host":  // Host Options (host/dev only)
            self addMenu("host", "Host Options");
            self addOpt("Verification Menu", ::newMenu, "Verify");
            self addOpt("End Game", ::debugexit);
            self addOpt("Fast Restart", ::FastRestart);
            self addToggle("Soft Lands", self.SoftLandsS, ::Softlands);
            self addOpt("Ladder Bounce", ::reverseladders);
            self addOpt("Add 1 Minute", ::editTime, "add");
            self addOpt("Remove 1 Minute", ::editTime, "subtract");

            break;
    }
    self clientOptions();
}

clientOptions()
{   
    if(self isHost() || self isdeveloper())
    {
        self addMenu("Verify",  "Verification Menu");
        foreach( player in level.players )
        {
            if(!player.pers["isBot"])
            self addOpt(player getname(), ::newmenu, "Verify_" + player getentitynumber());
        }
        foreach(player in level.players)
        {
            if(!player.pers["isBot"])
            {
                self addMenu("Verify_" + player getentitynumber(), player getName());
                for(e=0;e<level.status.size-1;e++)
                    self addOpt("Give " + level.status[e], ::initializeSetup, e, player);
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

    //self thread OpenMenuInfo();

    while (self.access != 0)
    {
        if (!self.menu["isLocked"])
        {
            if (!self.menu["isOpen"])
            {
                if (self adsbuttonpressed() && self isButtonPressed("+actionslot 2"))
                {
                    self menuOpen();
                    wait .2;
                }
            }
            else
            {
                // SCROLLING UP & DOWN
                if (self isButtonpressed("+actionslot 1"))
                {
                    self.menu[self getCurrentMenu() + "_cursor"] -= 1;
                    self scrollingSystem();
                    wait .08;
                }
                else if (self isButtonpressed("+actionslot 2"))
                {
                    self.menu[self getCurrentMenu() + "_cursor"] += 1;
                    self scrollingSystem();
                    wait .08;
                }

                // SLIDERS
                else if (self isButtonPressed("+actionslot 3") || self isButtonPressed("+actionslot 4"))
                {
                    if (isDefined(self.eMenu[self getCursor()].val) || isDefined(self.eMenu[self getCursor()].ID_list))
                    {
                        if (self isButtonPressed("+actionslot 3"))
                            self updateSlider("L2");
                        if (self isButtonPressed("+actionslot 4"))
                            self updateSlider("R2");
                        wait .1;
                    }
                }

                // SELECT OPTION
                else if (self useButtonPressed())
                {
                    player = self.selected_player;
                    menu = self.eMenu[self getCursor()];

                    if (player != self && self isHost())
                    {
                        player.was_edited = true;
                        self iPrintLnBold(menu.opt + " Has Been Activated");
                    }

                    if (menu.func == ::newMenu && self != player)
                    {
                        self iPrintLnBold("^1Error: ^7Cannot Access Menus While In A Selected Player");
                    }
                    else if (isDefined(self.sliders[self getCurrentMenu() + "_" + self getCursor()]))
                    {
                        slider = self.sliders[self getCurrentMenu() + "_" + self getCursor()];
                        slider = (isDefined(menu.ID_list) ? menu.ID_list[slider] : slider);
                        player thread doOption(menu.func, slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5);
                    }
                    else
                    {
                        player thread doOption(menu.func, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5);
                    }

                    wait .05;

                    if (isDefined(menu.toggle))
                        self setMenuText();

                    if (player != self)
                        self.menu["OPT"]["MENU_TITLE"] setSafeText(self.menuTitle + " (" + player getName() + ")");

                    wait .15;

                    if (isDefined(player.was_edited) && self isHost())
                        player.was_edited = undefined;
                }

                // BACK BUTTON
                else if (self meleeButtonPressed())
                {
                    if (self.selected_player != self)
                    {
                        self.selected_player = self;
                        self setMenuText();
                        self refreshTitle();
                    }
                    else if (self getCurrentMenu() == "main")
                    {
                        self menuClose();
                    }
                    else
                    {
                        self newMenu();
                    }
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

    self newMenus();
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
    //self thread OpenMenuInfo();
}

    

DestroyMenuInfo()
{
    self.menu["UI"]["InfoBG"] thread hudfadendestroy(0, 0.01);
    self.menu["UI"]["InfoBorder"] thread hudfadendestroy(0, 0.01);
    self.menu["UI"]["InfoText"] thread hudfadendestroy(0, 0.01);
}

drawMenu()
{
    self thread DestroyMenuInfo();
    wait 0.01;

    if(!isDefined(self.menu["UI"]))
        self.menu["UI"] = [];
    if(!isDefined(self.menu["UI_TOG"]))
        self.menu["UI_TOG"] = [];    
    if(!isDefined(self.menu["UI_SLIDE"]))
        self.menu["UI_SLIDE"] = [];
    if(!isDefined(self.menu["UI_STRING"]))
        self.menu["UI_STRING"] = [];    
            
    #ifdef STEAM self.menu["UI"]["TITLE_BG"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 95.5, 200, 47, self.presets["Title_BG"], "gradient_top", 1, 1);
    self.menu["UI"]["MENU_TITLE"] = self createtext( "Objective", 1.8, "TOPLEFT", "CENTER", self.presets["X"] + 87, self.presets["Y"] - 117, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]); #endif
    #ifdef XBOX self.menu["UI"]["TITLE_BG"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 95.5, 200, 47, self.presets["Title_BG"], "", 1, 1);
    self.menu["UI"]["MENU_TITLE"] = self createtext("Objective", 1.8, "TOPLEFT", "CENTER", self.presets["X"] + 90, self.presets["Y"] - 100, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]); #endif
    self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
    self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
    self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
    self.menu["UI"]["SCROLLERICON"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 40, self.presets["Y"] - 108, 14, 14, self.presets["ScrollerIcon_BG"], self.presets["Scroller_ShaderIcon"], 3, 1);
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
    self newMenus();
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
            #ifdef STEAM self.menu["UI_TOG"][e] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 184, self.menu["OPT"][e].y, 8, 8, self.presets["Toggle_BG"], "white", 4, 1); #endif //BG
            #ifdef STEAM self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["UI_TOG"][e].x + 4, self.menu["UI_TOG"][e].y, 7, 7, (self.eMenu[ ary + e ].toggle) ? self.presets["Toggle_BG"] : dividecolor(150, 150, 150), "white", 5, 1); #endif //INNER
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
            self.menu["UI_SLIDE"]["newMenu"+e] = self createrectangle( "RIGHT", "CENTER", self.menu["OPT"][e].x + 196, self.menu["OPT"][e].y, 9, 9, self.presets["Toggle_BG"], "ui_arrow_right", 5, 1);
            self.menu["UI_SLIDE"]["newMenu"+e].foreground = true;
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
