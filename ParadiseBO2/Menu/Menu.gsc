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

    // TRICKSHOT MENU
    case "ts":
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

    // BINDS MENU
    case "sK": 
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

    // TELEPORT MENU
    case "tp": 
            self addMenu("tp", "Teleport Menu");
            self addOpt("Set Spawn",::setSpawn);
            self addOpt("Unset Spawn", ::unsetSpawn);
            self addToggle("Save & Load", self.snl, ::saveandload);

            if(getDvar("mapname") == "mp_la")
            {
                tpNames = strtok("Garage Rooftop;Inside Garage;Plaza Building;Undermap Sui;Agora Ledge", ";");
                tpCoords = [
                    (-670.031, -1063.55, 111.657),
                    (1112.69, 76.0562, 115.125),
                    (1496.2, 3863.82, 133.125),
                    (-634.048, 7441.26, -463.887),
                    (-1778.4, 5631.22, 51.3185)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_dockside")
            {
                tpNames = strtok("Out of Map Building;Out of Map Ledge", ";");
                tpCoords = [
                    (-624.898, 5597.46, 231.779),
                    (-10606.7, 2978.56, -54.2118)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_carrier")
            {
                tpNames = strtok("Undermap Sui;Way Out Net;Helipad 1;Helipad 2", ";");
                tpCoords = [
                    (-4941.43, -1153.81, -163.875),
                    (2040.76, 836.045, 70.5574),
                    (-177.286, -1350.64, -267.875),
                    (-3661.62, 1314.41, -302.875)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_drone")
            {
                tpNames = strtok("Hill Top Sui;End of Tunnel Sui;Inside Rock Sui", ";");
                tpCoords = [
                    (-19462.7, -2026.44, -1809.66),
                    (-347.772, 8793.04, 316.212),
                    (15425.4, -3109.07, 4333.52)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_express")
            {
                tpNames = strtok("Bomb Spawn Roof;Defenders Spawn Roof;Powerlines;Powerlines 2;Powerlines 3;Top Roof 1;Top Roof 2;Drop Off Sui;End of Tunnel 1;End of Tunnel 2", ";");
                tpCoords = [
                    (-10.5211, 2375.24, 150.793),
                    (-24.6459, -2331.52, 155.49),
                    (-3948.26, 4425.08, 1220.14),
                    (-6756.28, -2024.63, 1392.56),
                    (-7042.23, -7373.21, 1392.85),
                    (4073.33, -2969.08, 92.2084),
                    (3637.17, 2872.82, 170.579),
                    (4675.43, 5027.02, 678.605),
                    (5612.52, 3459.54, -793.319),
                    (5551.98, -3458.61, -777.233)
                ];

                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_hijacked")
            {
                tpNames = strtok("Top of Barrier;Top of Barrier 2", ";");
                tpCoords = [
                    (6336.61, -45.2595, 16137.9),
                    (-6175.68, 808.258, 16131.3)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_overflow")
            {
                tpNames = strtok("Impossible Shot", ";");
                tpCoords = [
                    (28568, 7357.5, 1873.19)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_nightclub")
            {
                tpNames = strtok("Top of Barrier", ";");
                tpCoords = [
                    (-19462.7,-2026.44, -1809.66)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_raid")
            {
                tpNames = strtok("Sui Roof;Basketball Court Roof;Sui Tree Spot;Other Tree Spot", ";");
                tpCoords = [
                    (2852.81, 4544.64, 265.129),
                    (-104.969, 3769.45, 240.125),
                    (1814.13, 957.054, 432.095),
                    (2721.5, 4763.77, 137.625)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_slums")
            {   
                tpNames = strtok("Bomb Spawn Roof;B Roof;Soccer Field Roof;Out of Map Roof;Edge of Map Sui", ";");
                tpCoords = [
                    (-2499.07, 4351.68, 1297.82),
                    (1732.51, -1828.43, 896.125),
                    (145.815, -6037.59, 991.738),
                    (-2850.07,-3227.78, 1175.54),
                    (-7128.08, -548.743, 1192.19)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_village")
            {
                tpNames = strtok("Hill Top 1;Hill Top 2;Hill Top 3;Out of Map Roof;Top of Barrier;Barn Ledge", ";");
                tpCoords = [
                    (-1411.22, 16745.9, 4101.9),
                    (-10215.6, 15513.1, 3895.12),
                    (-1356.28, 3736.36, 288.111),
                    (2075.27, -1293.44, 913.854),
                    (26799.9, 8815.1,2471.32),
                    (856.266, 1548.07, 222.173)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_turbine")
            {
                tpNames = strtok("Inside Turbine;Stone Path;Top of Bridge;Out of Map Cliff", ";");
                tpCoords = [
                    (-864.64, 1384.38, 832.125),
                    (-1234.51, -3150.97, 440.166),
                    (-200.276, 3195.93, 607.911),
                    (-207.78, -633.604, -562.192)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_socotra")
            {
                tpNames = strtok("Defenders Spawn Roof;A Barrier;Staircase Spot;Out of Map Roof;Out of Map Sui", ";");
                tpCoords = [
                    (818.847, 2835.1, 1165.13),
                    (2466.79, 1417.62, 1132.13),
                    (1448.92, 2711.74, 481.618),
                    (-2136.67,-458.23, 623.151),
                    (-2806.68, 4511.62, 124.697)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_nuketown_2020")
            {
                tpNames = strtok("Defenders Spawn Roof;Purple House Sui;RC-XD Track Barrier;Under Map Sui;Greenhouse Sui", ";");
                tpCoords = [
                    (-1544.37, -1190.4, 66.425),
                    (2313.04, 1383.95, 123.136),
                    (65.946, 2442.77, 332.652),
                    (51.3779, -1670.54, 186.523),
                    (-1786.16, 1227.62, 91.9677)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_downhill")
            {
                tpNames = strtok("Top Half Pipe;Top Half Pipe 2;Barrier;Barrier 2;Mountain Sui", ";");
                tpCoords = [
                    (-445.155, -6253.96, 1875.99),
                    (618.708, -6218.16, 1882.27),
                    (3109.17, 656.519, 1536.13),
                    (-1430.35, 9408.64, 2597.38),
                    (-8987.19, 327.561, 2942.54)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_mirage")
            {
                tpNames = strtok("Under Map Sui", ";");
                tpCoords = [
                    (299.493, 3580.54, -288.084)
                ];
            }
            else if(getDvar("mapname") == "mp_hydro")
            {
                tpNames = strtok("Bomb Spawn Sui;Bomb Spawn Bridge;Defenders Spawn Sui;Defenders Spawn Bridge", ";");
                tpCoords = [
                    (3379.91, 3255.91, 216.125),
                    (7962.86, 22554.8, 8040.13),
                    (-3333.74, 4064.11, 216.125),
                    (-11819.2, 22546.4, 8040.13)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_skate")
            {
                tpNames = strtok("Undermap Sui", ";");
                tpCoords = [
                    (3317.06, -58.111, -19.875)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_concert")
            {
                tpNames = strtok("Center Stadium Barrier;A Stadium Barrier;Defenders Undermap", ";");
                tpCoords = [
                    (63.2687, 3551.01, 448.125),
                    (-2913.65, 1931.51, 448.125),
                    (-1849.62, 527.147, -419.875)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_magma")
            {
                tpNames = strtok("Lava Barrier;Undermap Sui;OOM Barrier", ";");
                tpCoords = [
                    (112.567, -1921.86, -305.969),
                    (3614.09, 1368.04, -831.875),
                    (-1248.7, -3339.31, 14.125)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_vertigo")
            {
                tpNames = strtok("Skyscraper Sui;Helipade Barrier;OOM Helipad 1;OOM Helipad 2;Building Ledge", ";");
                tpCoords = [
                    (4223.33, 401.677, 1856.13),
                    (-2816.21, -75.111, 624.125),
                    (4227.99, -2380.09, -319.875),
                    (4052.68, 3363.54, -319.875),
                    (-14.5213,-2853.14,-2440.15)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_studio")
            {
                tpNames = strtok("Defenders Spawn OOM;Mid Map Sui", ";");
                tpCoords = [
                    (538.681, -1569.16, 220.093),
                    (558.137, 846.333, 145.502)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_detour")
            {
                tpNames = strtok("Bomb Spawn Bus Sui;OOM Sui");
                tpCoords = [
                    (-3585.75, -735.356, 223.125),
                    (3951.57, 447.974, -13.8756)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_castaway")
            {
                tpNames = strtok("Top of Barrier 1;Top of Barrier 2", ";");
                tpCoords = [
                    (707.339,5926.26, 1604.02),
                    (2099.6, -4079.84, 1604.26)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_dig")
            {
                tpNames = strtok("Ledge;Undermap Sui;Top of Tower", ";");
                tpCoords = [
                    (-1230.85, 2097.92, 514.771),
                    (-2150.26, -373.214, -229.744),
                    (383.11, 1591.54, 738.638)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            }
            else if(getDvar("mapname") == "mp_pod")
            {
                tpNames = strtok("Top of Pod;Top of Pod 2", ";");
                tpCoords = [
                    (-3585.75, -735.356, 223.125),
                    (-332.219, 3108.55, 1553.93)
                ];
                self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
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

            mp7IDs = strtok("mp7_mp;mp7_mp+reflex;mp7_mp+steadyaim;mp7_mp+silencer;mp7_mp+holo;mp7_mp+rangefinder;mp7_mp+sf;mp7_mp+rf;mp7_mp+mms", ";");
            mp7Names = strtok("None;Reflex;Laser Sight;Suppressor;EO Tech;Target Finder;Select Fire;Rapid Fire;MMS", ";");
            self addSliderString("MP7", mp7IDs, mp7Names, ::giveUserWeapon);

            pdwIDs = strtok("pdw57_mp;pdw57_mp+reflex;pdw57_mp+steadyaim;pdw57_mp+silencer;pdw57_mp+holo;pdw57_mp+rangefinder;pdw57_mp+sf;pdw57_mp+rf;pdw57_mp+mms", ";");
            pdwNames = strtok("None;Reflex;Laser Sight;Suppressor;EO Tech;Target Finder;Select Fire;Rapid Fire;MMS", ";");
            self addSliderString("PDW-57", pdwIDs, pdwNames, ::giveUserWeapon);

            vectIDs = strtok("vector_mp;vector_mp+reflex;vector_mp+steadyaim;vector_mp+silencer;vector_mp+holo;vector_mp+rangefinder;vector_mp+sf;vector_mp+rf;vector_mp+mms", ";");
            vectNames = strtok("None;Reflex;Laser Sight;Suppressor;EO Tech;Target Finder;Select Fire;Rapid Fire;MMS", ";");
            self addSliderString("Vector K10", vectIDs, vectNames, ::giveUserWeapon);

            msmcIDs = strtok("insas_mp;insas_mp+reflex;insas_mp+steadyaim;insas_mp+silencer;insas_mp+holo;insas_mp+rangefinder;insas_mp+sf;insas_mp+rf;insas_mp+mms", ";");
            msmcNames = strtok("None;Reflex;Laser Sight;Suppressor;EO Tech;Target Finder;Select Fire;Rapid Fire;MMS", ";");
            self addSliderString("MSMC", msmcIDs, msmcNames, ::giveUserWeapon);

            chicIDs = strtok("qcw05_mp;qcw05_mp+reflex;qcw05_mp+steadyaim;qcw05_mp+silencer;qcw05_mp+holo;qcw05_mp+rangefinder;qcw05_mp+sf;qcw05_mp+rf;qcw05_mp+mms", ";");
            chicNames = strtok("None;Reflex;Laser Sight;Suppressor;EO Tech;Target Finder;Select Fire;Rapid Fire;MMS", ";");
            self addSliderString("Chicom CQB", chicIDs, chicNames, ::giveUserWeapon);

            skorpIDs = strtok("evoskorpion_mp;evoskorpion_mp+reflex;evoskorpion_mp+steadyaim;evoskorpion_mp+silencer;evoskorpion_mp+holo;evoskorpion_mp+rangefinder;evoskorpion_mp+sf;evoskorpion_mp+rf;evoskorpion_mp+mms", ";");
            skorpNames = strtok("None;Reflex;Laser Sight;Suppressor;EO Tech;Target Finder;Select Fire;Rapid Fire;MMS", ";");
            self addSliderString("Skorpion EVO", skorpIDs, skorpNames, ::giveUserWeapon);

            pckprIDs = strtok("peacekeeper_mp;peacekeeper_mp+reflex;peacekeeper_mp+steadyaim;peacekeeper_mp+silencer;peacekeeper_mp+holo;peacekeeper_mp+rangefinder;peacekeeper_mp+sf;peacekeeper_mp+rf;peacekeeper_mp+mms", ";");
            pckprNames = strtok("None;Reflex;Laser Sight;Suppressor;EO Tech;Target Finder;Select Fire;Rapid Fire;MMS", ";");
            self addSliderString("Peacekeeper", pckprIDs, pckprNames, ::giveUserWeapon);
            break;

        case "ars":
            self addMenu("ars", "Assault Rifles");
            
            mtarIDs = strtok("tar21_mp;tar21_mp+reflex;tar21_mp+acog;tar21_mp+rangefinder;tar21_mp+sf;tar21_mp+holo;tar21_mp+silencer;tar21_mp+dualoptic;tar21_mp+gl;tar21_mp+mms", ";");
            mtarNames = strtok("None;Reflex;ACOG;Target Finder;Select Fire;EO Tech;Suppressor;Hyrbid Sight;Grenade Launcher;MMS", ";");
            self addSliderString("MTAR", mtarIDs, mtarNames, ::giveUserWeapon);

            t95IDs = strtok("type95_mp;type95_mp+reflex;type95_mp+acog;type95_mp+rangefinder;type95_mp+sf;type95_mp+holo;type95_mp+silencer;type95_mp+dualoptic;type95_mp+gl;type95_mp+mms", ";");
            t95Names = strtok("None;Reflex;ACOG;Target Finder;Select Fire;EO Tech;Suppressor;Hyrbid Sight;Grenade Launcher;MMS", ";");
            self addSliderString("Type 95", t95IDs, t95Names, ::giveUserWeapon);

            sw556IDs = strtok("sig556_mp;sig556_mp+reflex;sig556_mp+acog;sig556_mp+rangefinder;sig556_mp+sf;sig556_mp+holo;sig556_mp+silencer;sig556_mp+dualoptic;sig556_mp+gl;sig556_mp+mms", ";");
            sw556Names = strtok("None;Reflex;ACOG;Target Finder;Select Fire;EO Tech;Suppressor;Hyrbid Sight;Grenade Launcher;MMS", ";");
            self addSliderString("SWAT 556", sw556IDs, sw556Names, ::giveUserWeapon);

            falIDs = strtok("sa58_mp;sa58_mp+reflex;sa58_mp+acog;sa58_mp+rangefinder;sa58_mp+sf;sa58_mp+holo;sa58_mp+silencer;sa58_mp+dualoptic;sa58_mp+gl;sa58_mp+mms", ";");
            falNames = strtok("None;Reflex;ACOG;Target Finder;Select Fire;EO Tech;Suppressor;Hyrbid Sight;Grenade Launcher;MMS", ";");
            self addSliderString("FAL OSW", falIDs, falNames, ::giveUserWeapon);

            m27IDs = strtok("hk416_mp;hk416_mp+reflex;hk416_mp+acog;hk416_mp+rangefinder;hk416_mp+sf;hk416_mp+holo;hk416_mp+silencer;hk416_mp+dualoptic;hk416_mp+gl;hk416_mp+mms", ";");
            m27Names = strtok("None;Reflex;ACOG;Target Finder;Select Fire;EO Tech;Suppressor;Hyrbid Sight;Grenade Launcher;MMS", ";");
            self addSliderString("M27", m27IDs, m27Names, ::giveUserWeapon);

            scarIDs = strtok("scar_mp;scar_mp+reflex;scar_mp+acog;scar_mp+rangefinder;scar_mp+sf;scar_mp+holo;scar_mp+silencer;scar_mp+dualoptic;scar_mp+gl;scar_mp+mms", ";");
            scarNames = strtok("None;Reflex;ACOG;Target Finder;Select Fire;EO Tech;Suppressor;Hyrbid Sight;Grenade Launcher;MMS", ";");
            self addSliderString("Scar-H", scarIDs, scarNames, ::giveUserWeapon);

            smrIDs = strtok("saritch_mp;saritch_mp+reflex;saritch_mp+acog;saritch_mp+rangefinder;saritch_mp+sf;saritch_mp+holo;saritch_mp+silencer;saritch_mp+dualoptic;saritch_mp+gl;saritch_mp+mms", ";");
            smrNames = strtok("None;Reflex;ACOG;Target Finder;Select Fire;EO Tech;Suppressor;Hyrbid Sight;Grenade Launcher;MMS", ";");
            self addSliderString("SMR", smrIDs, smrNames, ::giveUserWeapon);

            m8a1IDs = strtok("xm8_mp;xm8_mp+reflex;xm8_mp+acog;xm8_mp+rangefinder;xm8_mp+sf;xm8_mp+holo;xm8_mp+silencer;xm8_mp+dualoptic;xm8_mp+gl;xm8_mp+mms", ";");
            m8a1Names = strtok("None;Reflex;ACOG;Target Finder;Select Fire;EO Tech;Suppressor;Hyrbid Sight;Grenade Launcher;MMS", ";");
            self addSliderString("M8A1", m8a1IDs, m8a1Names, ::giveUserWeapon);

            an94IDs = strtok("an94_mp;an94_mp+reflex;an94_mp+acog;an94_mp+rangefinder;an94_mp+sf;an94_mp+holo;an94_mp+silencer;an94_mp+dualoptic;an94_mp+gl;an94_mp+mms", ";");
            an94Names = strtok("None;Reflex;ACOG;Target Finder;Select Fire;EO Tech;Suppressor;Hyrbid Sight;Grenade Launcher;MMS", ";");
            self addSliderString("AN-94", an94IDs, an94Names, ::giveUserWeapon);
            break;

        case "sgs":
            self addMenu("sgs", "Shotguns");

            r870IDs = strtok("870mcs_mp;870mcs_mp+reflex;870mcs_mp+steadyaim;870mcs_mp+silencer;870mcs_mp+fastads;870mcs_mp+mms", ";");
            r870Names = strtok("None;Reflex;Laser Sight;Suppressor;Quickdraw;MMS", ";");
            self addSliderString("Remington 870 MCS", r870IDs, r870Names, ::giveUserWeapon);

            s12IDs = strtok("saiga12_mp;saiga12_mp+reflex;saiga12_mp+steadyaim;saiga12_mp+silencer;saiga12_mp+fastads;saiga12_mp+mms", ";");
            s12Names = strtok("None;Reflex;Laser Sight;Suppressor;Quickdraw;MMS", ";");
            self addSliderString("S12", s12IDs, s12Names, ::giveUserWeapon);

            ksgIDs = strtok("ksg_mp;ksg_mp+reflex;ksg_mp+steadyaim;ksg_mp+silencer;ksg_mp+fastads;ksg_mp+mms", ";");
            ksgNames = strtok("None;Reflex;Laser Sight;Suppressor;Quickdraw;MMS", ";");
            self addSliderString("KSG", ksgIDs, ksgNames, ::giveUserWeapon);

            m12IDs = strtok("srm1216_mp;srm1216_mp+reflex;srm1216_mp+steadyaim;srm1216_mp+silencer;srm1216_mp+fastads;srm1216_mp+mms", ";");
            m12Names = strtok("None;Reflex;Laser Sight;Suppressor;Quickdraw;MMS", ";");
            self addSliderString("M1216", m12IDs, m12Names, ::giveUserWeapon);
            break;

        case "lmgs":
            self addMenu("lmgs", "Light Machine Guns");

            mk48IDs = strtok("mk48_mp;mk48_mp+holo;mk48_mp+reflex;mk48_mp+rangefinder;mk48_mp+acog;mk48_mp+steadyaim;mk48_mp+silencer;mk48_mp+vzoom;mk48_mp+dualoptic;mk48_mp+ir", ";");
            mk48Names = strtok("None;EO Tech;Reflex;Target Finder;ACOG;Laser Sight;Suppressor;Variable Zoom;Hybrid;Dual Band Scope", ";");
            self addSliderString("MK48", mk48IDs, mk48Names, ::giveUserWeapon);

            qbbIDs = strtok("qbb95_mp;qbb95_mp+holo;qbb95_mp+reflex;qbb95_mp+rangefinder;qbb95_mp+acog;qbb95_mp+steadyaim;qbb95_mp+silencer;qbb95_mp+vzoom;qbb95_mp+dualoptic;qbb95_mp+ir", ";");
            qbbNames = strtok("None;EO Tech;Reflex;Target Finder;ACOG;Laser Sight;Suppressor;Variable Zoom;Hybrid;Dual Band Scope", ";");
            self addSliderString("QBB LSW", qbbIDs, qbbNames, ::giveUserWeapon);

            lsatIDs = strtok("lsat_mp;lsat_mp+holo;lsat_mp+reflex;lsat_mp+rangefinder;lsat_mp+acog;lsat_mp+steadyaim;lsat_mp+silencer;lsat_mp+vzoom;lsat_mp+dualoptic;lsat_mp+ir", ";");
            lsatNames = strtok("None;EO Tech;Reflex;Target Finder;ACOG;Laser Sight;Suppressor;Variable Zoom;Hybrid;Dual Band Scope", ";");
            self addSliderString("LSAT", lsatIDs, lsatNames, ::giveUserWeapon);

            hamrIDs = strtok("hamr_mp;hamr_mp+holo;hamr_mp+reflex;hamr_mp+rangefinder;hamr_mp+acog;hamr_mp+steadyaim;hamr_mp+silencer;hamr_mp+vzoom;hamr_mp+dualoptic;hamr_mp+ir", ";");
            hamrNames = strtok("None;EO Tech;Reflex;Target Finder;ACOG;Laser Sight;Suppressor;Variable Zoom;Hybrid;Dual Band Scope", ";");
            self addSliderString("HAMR", hamrIDs, hamrNames, ::giveUserWeapon);
            break;

        case "srs":
            self addMenu("srs", "Sniper Rifles");

            svuIDs = strtok("svu_mp;svu_mp+silencer;svu_mp+vzoom;svu_mp+acog;svu_mp+steadyaim;svu_mp+ir", ";");
            svuNames = strtok("None;Suppressor;Variable Zoom;ACOG;Laser Sight;Dual Band Scope", ";");
            self addSliderString("SVU-AS", svuIDs, svuNames, ::giveUserWeapon);

            dsrIDs = strtok("dsr50_mp;dsr50_mp+silencer;dsr50_mp+vzoom;dsr50_mp+acog;dsr50_mp+steadyaim;dsr50_mp+ir", ";");
            dsrNames = strtok("None;Suppressor;Variable Zoom;ACOG;Laser Sight;Dual Band Scope", ";");
            self addSliderString("DSR-50", dsrIDs, dsrNames, ::giveUserWeapon);

            ballistaIDs = strtok("ballista_mp;ballista_mp+silencer;ballista_mp+vzoom;ballista_mp+acog;ballista_mp+steadyaim;ballista_mp+ir;ballista_mp+is", ";");
            ballistaNames = strtok("None;Suppressor;Variable Zoom;ACOG;Laser Sight;Dual Band Scope;Iron Sight", ";");
            self addSliderString("Ballista", ballistaIDs, ballistaNames, ::giveUserWeapon);

            as50IDs = strtok("as50_mp;as50_mp+silencer;as50_mp+vzoom;as50_mp+acog;as50_mp+steadyaim;as50_mp+ir", ";");
            as50Names = strtok("None;Suppressor;Variable Zoom;ACOG;Laser Sight;Dual Band Scope", ";");
            self addSliderString("XPR-50", as50IDs, as50Names, ::giveUserWeapon);
            break;

        case "secs":
            self addMenu("secs", "Secondary Weapons");
            self addOpt("Pistols", ::newMenu, "hgs");
            self addOpt("Launchers", ::newMenu, "lnchrs");
            self addOpt("Specials", ::newMenu, "specs");
            break;

        case "hgs":
            self addMenu("hgs", "Pistols");

            fvSvIDs = strtok("fiveseven_mp;fiveseven_mp+reflex;fiveseven_mp+extclip;fiveseven_mp+steadyaim;fiveseven_mp+extbarrel;fiveseven_mp+fmj;fiveseven_mp+dualclip;fiveseven_mp+silencer;fiveseven_mp+tacknife;fiveseven_dw_mp", ";");
            fvSvNames = strtok("None;Reflex;Extended Mag;Laser Sight;Long Barrel;FMJ;Fast Mags;Suppressor;Tactical Knife;Dual Wield", ";");
            self addSliderString("Five Seven", fvSvIDs, fvSvNames, ::giveUserWeapon);

            t45IDs = strtok("fnp45_mp;fnp45_mp+reflex;fnp45_mp+extclip;fnp45_mp+steadyaim;fnp45_mp+extbarrel;fnp45_mp+fmj;fnp45_mp+dualclip;fnp45_mp+silencer;fnp45_mp+tacknife;fnp45_dw_mp", ";");
            t45Names = strtok("None;Reflex;Extended Mag;Laser Sight;Long Barrel;FMJ;Fast Mags;Suppressor;Tactical Knife;Dual Wield", ";");
            self addSliderString("Tac-45", t45IDs, t45Names, ::giveUserWeapon);

            b23rIDs = strtok("beretta93r_mp;beretta93r_mp+reflex;beretta93r_mp+extclip;beretta93r_mp+steadyaim;beretta93r_mp+extbarrel;beretta93r_mp+fmj;beretta93r_mp+dualclip;beretta93r_mp+silencer;beretta93r_mp+tacknife;beretta93r_dw_mp", ";");
            b23rNames = strtok("None;Reflex;Extended Mag;Laser Sight;Long Barrel;FMJ;Fast Mags;Suppressor;Tactical Knife;Dual Wield", ";");
            self addSliderString("B23R", b23rIDs, b23rNames, ::giveUserWeapon);

            execIDs = strtok("judge_mp;judge_mp+reflex;judge_mp+extclip;judge_mp+steadyaim;judge_mp+extbarrel;judge_mp+fmj;judge_mp+dualclip;judge_mp+silencer;judge_mp+tacknife;judge_dw_mp", ";");
            execNames = strtok("None;Reflex;Extended Mag;Laser Sight;Long Barrel;FMJ;Fast Mags;Suppressor;Tactical Knife;Dual Wield", ";");
            self addSliderString("Executioner", execIDs, execNames, ::giveUserWeapon);

            k40IDs = strtok("kard_mp;kard_mp+reflex;kard_mp+extclip;kard_mp+steadyaim;kard_mp+extbarrel;kard_mp+fmj;kard_mp+dualclip;kard_mp+silencer;kard_mp+tacknife;kard_dw_mp", ";");
            k40Names = strtok("None;Reflex;Extended Mag;Laser Sight;Long Barrel;FMJ;Fast Mags;Suppressor;Tactical Knife;Dual Wield", ";");
            self addSliderString("KAP-40", k40IDs, k40Names, ::giveUserWeapon);
            break;

        case "lnchrs":
            self addMenu("lnchrs", "Launchers");
            self addOpt("SMAW", ::giveUserWeapon, "smaw_mp");
            self addOpt("FHJ-18 AA", ::giveUserWeapon, "fhj18_mp");
            self addOpt("RPG", ::giveUserWeapon, "usrpg_mp");
            break;

        case "specs":
            self addMenu("specs", "Specials");

            cbowIDs = strtok("crossbow_mp;crossbow_mp+acog;crossbow_mp+stackfire;crossbow_mp+ir;crossbow_mp+reflex;crossbow_mp+vzoom", ";");
            cbowNames = strtok("None;ACOG Sight;Tri-Bolt;Dual Band Scope;Reflex;Variable Zoom", ";");
            self addSliderString("Crossbow", cbowIDs, cbowNames, ::giveUserWeapon);

            self addOpt("Ballistic Knife", ::giveUserWeapon, "knife_ballistic_mp");
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

            arIDs = strtok("tar21_mp;type95_mp;sig556_mp;sa58_mp;hk416_mp;scar_mp;saritch_mp;xm8_mp;an94_mp", ";");
            arNames = strtok("MTAR;Type 95;Swat 556;FAL OSW;M27;Scar-H;SMR;M8A1;AN-94", ";");
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            smgIDs = strtok("mp7_mp;pdw57_mp;vector_mp;insas_mp;qcw05_mp;evoskorpion_mp;peacekeeper_mp", ";");
            smgNames = strtok("MP7;PDW-57;Vecto K10;MSMC;Chicom CQB;Skorpion EVO;Peackeeper", ";");
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

            sgIDs = strtok("870mcs_mp;saiga12_mp;ksg_mp;srm1216_mp", ";");
            sgNames = strtok("Remington 870 MCS;S12;KSG;M1216", ";");
            self addSliderString("Shotguns", sgIDs, sgNames, ::afterhit);

            lmgIDs = strtok("mk48_mp;qbb95_mp;lsat_mp;hamr_mp", ";");
            lmgNames = strtok("MK48;QBB LSW;LSAT;HAMR", ";");
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            srIDs = strtok("svu_mp;dsr50_mp;ballista_mp;as50_mp", ";");
            srNames = strtok("SVU-AS;DSR-50;Ballista;XPR-50", ";");
            self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

            pstlsIDs = strtok("kard_dw_mp;fnp45_dw_mp;fiveseven_dw_mp;judge_dw_mp;beretta93r_dw_mp;fiveseven_mp;fnp45_mp;beretta93r_mp;judge_mp;kard_mp", ";");
            pstlsNames = strtok("Dual Kap-40;Dual Tac-45;Dual Five Seven;Dual Executioner;Dual B23R;Five Seven;Tac-45;B23R;Executioner;Kap-40", ";");
            self addSliderString("Pistols", pstlsIDs, pstlsNames, ::afterhit);

            lnchrsIDs = strtok("m32_mp;smaw_mp;fhj18_mp;usrpg_mp", ";");
            lnchrsNames = strtok("War Machine;SMAW;FHJ-18;RPG", ";");
            self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);

            specIDs = strtok("knife_held_mp;defaultweapon_mp;minigun_mp;riotshield_mp;crossbow_mp;knife_ballistic_mp;briefcase_bomb_mp;claymore_mp;destructible_car_mp", ";");
            specNames = strtok("CSGO Knife;Default Weapon;Death Machine;Riot Shield;Crossbow;Ballistic Knife;Bomb;Claymore;Car", ";");
            self addSliderString("Special Weapons", specIDs, specNames, ::afterhit);
            break;

        case "kstrks": //Killstreak Menu
            self addMenu("kstrks", "Killstreak Menu");
            self addOpt("Fill Streaks", ::fillStreaks); 
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
            self addOpt("Client Menu", ::newMenu, "Verify");
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
        self addMenu("Verify",  "Client Menu");
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
                    self addOpt("Kick Player", ::kickSped, player);
                    self addOpt("Ban Player", ::banSped, player);  
                    self addOpt("Teleport to Croshairs", ::teleportToCrosshair, player);  
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
                    if( self actionslottwobuttonpressed() && self adsButtonPressed() )
                    {
                        self menuOpen();
                        wait .2;
                    }               
                }
                else{
                    if(self actionslotonebuttonpressed() || self actionslottwobuttonpressed())
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
                    else if(self actionslotthreebuttonpressed() || self actionslotfourbuttonpressed()){
                        if(!self actionslotthreebuttonpressed() || !self actionslotfourbuttonpressed())
                        {
                            if(isDefined(self.eMenu[ self getCursor() ].val) || IsDefined( self.eMenu[ self getCursor() ].ID_list ))
                            {
                                if( self actionslotthreebuttonpressed() )   
                                    self updateSlider( "L2" );
                                if( self actionslotfourbuttonpressed() )    
                                    self updateSlider( "R2" );
                                wait .1;
                            }
                        }
                    }
                    else if( self useButtonPressed() ){
                        player = self.selected_player;
                        menu = self.eMenu[self getCursor()];

                        if( player != self && self isHost() )
                        {
                            player.was_edited = true;
                            self iPrintLnBold( menu.opt + " Has Been Activated" );
                        }
                        
                        if( self.eMenu[ self getCursor() ].func == ::newMenu && self != player )
                            self iPrintLnBold( "^1Error: ^7Cannot Access Menus While In A Selected Player" );
                        else if(isDefined(self.sliders[ self getCurrentMenu() + "_" + self getCursor() ])){
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
        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2.0, "TOPLEFT", "CENTER", self.presets["X"] + 125, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]); #endif
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
