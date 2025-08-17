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
            if(self.hasMenu == true)
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
            self addOpt("Nac Mod Bind", ::newMenu, "nmod");
            self addOpt("Skree Bind", ::newMenu, "skree");

            cowboyIDs = strTok("1;2;3;4", ";");
            cowboyNames = strtok("[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}]", ";");
            self addSliderString("Cowboy Bind", cowboyIDs, cowboyNames, ::cowboyBind);

            rvrsIDs = strTok("1;2;3;4", ";");
            rvrsNames = strtok("[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}]", ";");
            self addSliderString("Reverse Cowboy Bind", rvrsIDs, rvrsNames, ::cowboyBind);

            gflipIDs = strTok("1;2;3;4", ";");
            gflipNames = strtok("[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}]", ";");
            self addSliderString("Mid Air GFip Bind", gflipIDs, gflipNames, ::cowboyBind);

            czmIDs = strTok("1;2;3;4", ";");
            czmNames = strtok("[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}]", ";");
            self addSliderString("Canzoom Bind", czmIDs, czmNames, ::cowboyBind);

            tiIDs = strTok("1;2;3;4", ";");
            tiNames = strtok("[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}]", ";");
            self addSliderString("Third Eye Bind", tiIDs, tiNames, ::cowboyBind);
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
            self addOpt("iPad", ::giveUserWeapon, "");
            break;

        case "camos":
            self addMenu("camos", "Camos");
            self addOpt("Remove Camo", ::changeCamo, 0);
            self addOpt("Random Camo", ::randomCamo);

            baseIDS = strtok("1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16", ";");
            baseNames = strtok("DEVGRU;A-TACS AU;ERDL;Siberia;Choco;Blue Tiger;Bloodshot;Ghostex: Delta 6;Kryptek: Typhon;Carbon Fiber;Cherry Blossom;Art of War;Ronin;Skulls;Gold;Diamond", ";");
            self addSliderString("Base Camos", baseIDs, baseNames, ::changeCamo);

            dlcIDS = strtok("17;21;22;23;24;25;26;27;28;32;31;34;35;36;37;38;39;20;30;33;44;40;41;42;43", ";");
            dlcNames = strtok("Elite;Benjamins;Dia De Muertos;Graffiti;Kawaii;Party Rock;Zombies;Viper;Bacon;Dragon;Cyborg;Aqua;Breach;Coyote;Glam;Rogue;Pack-a-Punch;UK Punk;Paladin;Comics;Afterlife;Dead Mans Hand;Beast;Octane;Weaponized 115", ";");
            self addSliderString("DLC Camos", dlcIDs, dlcNames, ::changeCamo);

            secretIDS = strtok("18;29;45", ";");
            secretNames = strtok("Digital;Ghosts;Advanced Warfare", ";");
            self addSliderString("Secret Camos", secretIDs, secretNames, ::changeCamo);
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
                if (self adsbuttonpressed() && self actionslottwobuttonpressed())
                {
                    self menuOpen();
                    wait .2;
                }
            }
            else
            {
                // SCROLLING UP & DOWN
                if (self actionSlotOneButtonPressed("+actionslot 1"))
                {
                    self.menu[self getCurrentMenu() + "_cursor"] -= 1;
                    self scrollingSystem();
                    wait .08;
                }
                else if (self actionSlotTwoButtonPressed("+actionslot 2"))
                {
                    self.menu[self getCurrentMenu() + "_cursor"] += 1;
                    self scrollingSystem();
                    wait .08;
                }

                // SLIDERS
                else if (self actionslotthreeButtonPressed("+actionslot 3") || self actionslotfourButtonPressed("+actionslot 4"))
                {
                    if (isDefined(self.eMenu[self getCursor()].val) || isDefined(self.eMenu[self getCursor()].ID_list))
                    {
                        if (self actionslotthreeButtonPressed("+actionslot 3"))
                            self updateSlider("L2");
                        if (self actionslotfourButtonPressed("+actionslot 4"))
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
    #ifdef XBOX self.menu["UI"]["TITLE_BG"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 95.5, 200, 47, self.presets["Title_BG"], "gradient_top", 1, 1);
    self.menu["UI"]["MENU_TITLE"] = self createtext("Objective", 1.8, "TOPLEFT", "CENTER", self.presets["X"] + 106, self.presets["Y"] - 100, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]); #endif
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
