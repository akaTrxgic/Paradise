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
                self addOpt("Host Options", ::newMenu, "host");
        }
        break;

    // TRICKSHOT MENU
    case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+smoke}]", self.NoClipT, ::initNoClip);

            canOpts = ["Current", "Infinite"];
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addToggle("Toggle Instashoots", self.instashoot, ::instashoot);
            self addOpt("Spawn Slide @ Crosshairs", ::slide);

            spawnOptionsActions = ["Bounce","Platform","Crate"];
            spawnOptionsIDs     = ["bounce","platform","crate"];
            self addSliderString("Spawn @ Feet", spawnOptionsIDs, spawnOptionsActions, ::doSpawnOption);
            break;

    // BINDS MENU
    case "sK": 
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb");
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
                tpNames = ["Garage Rooftop","Inside Garage","Plaza Building","Undermap Sui","Agora Ledge"];
                tpCoords = [
                    (-670.031, -1063.55, 111.657),
                    (1112.69, 76.0562, 115.125),
                    (1496.2, 3863.82, 133.125),
                    (-634.048, 7441.26, -463.887),
                    (-1778.4, 5631.22, 51.3185)
                ];
            }
            else if(getDvar("mapname") == "mp_dockside")
            {
                tpNames = ["Out of Map Building","Out of Map Ledge"];
                tpCoords = [
                    (-624.898, 5597.46, 231.779),
                    (-10606.7, 2978.56, -54.2118)
                ];
            }
            else if(getDvar("mapname") == "mp_carrier")
            {
                tpNames = ["Undermap Sui","Way Out Net","Helipad 1","Helipad 2"];
                tpCoords = [
                    (-4941.43, -1153.81, -163.875),
                    (2040.76, 836.045, 70.5574),
                    (-177.286, -1350.64, -267.875),
                    (-3661.62, 1314.41, -302.875)
                ];
            }
            else if(getDvar("mapname") == "mp_drone")
            {
                tpNames = ["Hill Top Sui","End of Tunnel Sui","Inside Rock Sui"];
                tpCoords = [
                    (-19462.7, -2026.44, -1809.66),
                    (-347.772, 8793.04, 316.212),
                    (15425.4, -3109.07, 4333.52)
                ];
            }
            else if(getDvar("mapname") == "mp_express")
            {
                tpNames = ["Bomb Spawn Roof","Defenders Spawn Roof","Powerlines","Powerlines 2","Powerlines 3","Top Roof 1","Top Roof 2","Drop Off Sui","End of Tunnel 1","End of Tunnel 2"];
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
            }
            else if(getDvar("mapname") == "mp_hijacked")
            {
                tpNames = ["Top of Barrier","Top of Barrier 2"];
                tpCoords = [
                    (6336.61, -45.2595, 16137.9),
                    (-6175.68, 808.258, 16131.3)
                ];
            }
            else if(getDvar("mapname") == "mp_overflow")
            {
                tpNames = ["Impossible Shot"];
                tpCoords = [
                    (28568, 7357.5, 1873.19)
                ];
            }
            else if(getDvar("mapname") == "mp_nightclub")
            {
                tpNames = ["Top of Barrier"];
                tpCoords = [
                    (-19462.7,-2026.44, -1809.66)
                ];
            }
            else if(getDvar("mapname") == "mp_raid")
            {
                tpNames = ["Sui Roof","Basketball Court Roof","Sui Tree Spot","Other Tree Spot"];
                tpCoords = [
                    (2852.81, 4544.64, 265.129),
                    (-104.969, 3769.45, 240.125),
                    (1814.13, 957.054, 432.095),
                    (2721.5, 4763.77, 137.625)
                ];
            }
            else if(getDvar("mapname") == "mp_slums")
            {   
                tpNames = ["Bomb Spawn Roof","B Roof","Soccer Field Roof","Out of Map Roof","Edge of Map Sui"];
                tpCoords = [
                    (-2499.07, 4351.68, 1297.82),
                    (1732.51, -1828.43, 896.125),
                    (145.815, -6037.59, 991.738),
                    (-2850.07,-3227.78, 1175.54),
                    (-7128.08, -548.743, 1192.19)
                ];
            }
            else if(getDvar("mapname") == "mp_village")
            {
                tpNames = ["Hill Top 1","Hill Top 2","Hill Top 3","Out of Map Roof","Top of Barrier","Barn Ledge"];
                tpCoords = [
                    (-1411.22, 16745.9, 4101.9),
                    (-10215.6, 15513.1, 3895.12),
                    (-1356.28, 3736.36, 288.111),
                    (2075.27, -1293.44, 913.854),
                    (26799.9, 8815.1,2471.32),
                    (856.266, 1548.07, 222.173)
                ];
            }
            else if(getDvar("mapname") == "mp_turbine")
            {
                tpNames = ["Inside Turbine","Stone Path","Top of Bridge","Out of Map Cliff"];
                tpCoords = [
                    (-864.64, 1384.38, 832.125),
                    (-1234.51, -3150.97, 440.166),
                    (-200.276, 3195.93, 607.911),
                    (-207.78, -633.604, -562.192)
                ];
            }
            else if(getDvar("mapname") == "mp_socotra")
            {
                tpNames = ["Defenders Spawn Roof","A Barrier","Staircase Spot","Out of Map Roof","Out of Map Sui"];
                tpCoords = [
                    (818.847, 2835.1, 1165.13),
                    (2466.79, 1417.62, 1132.13),
                    (1448.92, 2711.74, 481.618),
                    (-2136.67,-458.23, 623.151),
                    (-2806.68, 4511.62, 124.697)
                ];
            }
            else if(getDvar("mapname") == "mp_nuketown_2020")
            {
                tpNames = ["Defenders Spawn Roof","Purple House Sui","RC-XD Track Barrier","Under Map Sui","Greenhouse Sui"];
                tpCoords = [
                    (-1544.37, -1190.4, 66.425),
                    (2313.04, 1383.95, 123.136),
                    (65.946, 2442.77, 332.652),
                    (51.3779, -1670.54, 186.523),
                    (-1786.16, 1227.62, 91.9677)
                ];
            }
            else if(getDvar("mapname") == "mp_downhill")
            {
                tpNames = ["Top Half Pipe","Top Half Pipe 2","Barrier","Barrier 2","Mountain Sui"];
                tpCoords = [
                    (-445.155, -6253.96, 1875.99),
                    (618.708, -6218.16, 1882.27),
                    (3109.17, 656.519, 1536.13),
                    (-1430.35, 9408.64, 2597.38),
                    (-8987.19, 327.561, 2942.54)
                ];
            }
            else if(getDvar("mapname") == "mp_mirage")
            {
                tpNames = ["Under Map Sui"];
                tpCoords = [
                    (299.493, 3580.54, -288.084)
                ];
            }
            else if(getDvar("mapname") == "mp_hydro")
            {
                tpNames = ["Bomb Spawn Sui","Bomb Spawn Bridge","Defenders Spawn Sui","Defenders Spawn Bridge"];
                tpCoords = [
                    (3379.91, 3255.91, 216.125),
                    (7962.86, 22554.8, 8040.13),
                    (-3333.74, 4064.11, 216.125),
                    (-11819.2, 22546.4, 8040.13)
                ];
            }
            else if(getDvar("mapname") == "mp_skate")
            {
                tpNames = ["Undermap Sui"];
                tpCoords = [
                    (3317.06, -58.111, -19.875)
                ];
            }
            else if(getDvar("mapname") == "mp_concert")
            {
                tpNames = ["Center Stadium Barrier","A Stadium Barrier","Defenders Undermap"];
                tpCoords = [
                    (63.2687, 3551.01, 448.125),
                    (-2913.65, 1931.51, 448.125),
                    (-1849.62, 527.147, -419.875)
                ];
            }
            else if(getDvar("mapname") == "mp_magma")
            {
                tpNames = ["Lava Barrier","Undermap Sui","OOM Barrier"];
                tpCoords = [
                    (112.567, -1921.86, -305.969),
                    (3614.09, 1368.04, -831.875),
                    (-1248.7, -3339.31, 14.125)
                ];
            }
            else if(getDvar("mapname") == "mp_vertigo")
            {
                tpNames = ["Skyscraper Sui","Helipade Barrier","OOM Helipad 1","OOM Helipad 2","Building Ledge"];
                tpCoords = [
                    (4223.33, 401.677, 1856.13),
                    (-2816.21, -75.111, 624.125),
                    (4227.99, -2380.09, -319.875),
                    (4052.68, 3363.54, -319.875),
                    (-14.5213,-2853.14,-2440.15)
                ];
            }
            else if(getDvar("mapname") == "mp_studio")
            {
                tpNames = ["Defenders Spawn OOM","Mid Map Sui"];
                tpCoords = [
                    (538.681, -1569.16, 220.093),
                    (558.137, 846.333, 145.502)
                ];
            }
            else if(getDvar("mapname") == "mp_detour")
            {
                tpNames = ["Bomb Spawn Bus Sui","OOM Sui"];
                tpCoords = [
                    (-3585.75, -735.356, 223.125),
                    (3951.57, 447.974, -13.8756)
                ];
            }
            else if(getDvar("mapname") == "mp_castaway")
            {
                tpNames = ["Top of Barrier 1","Top of Barrier 2"];
                tpCoords = [
                    (707.339,5926.26, 1604.02),
                    (2099.6, -4079.84, 1604.26)
                ];
            }
            else if(getDvar("mapname") == "mp_dig")
            {
                tpNames = ["Ledge","Undermap Sui","Top of Tower"];
                tpCoords = [
                    (-1230.85, 2097.92, 514.771),
                    (-2150.26, -373.214, -229.744),
                    (383.11, 1591.54, 738.638)
                ];
            }
            else if(getDvar("mapname") == "mp_pod")
            {
                tpNames = ["Top of Pod","Top of Pod 2"];
                tpCoords = [
                    (-3585.75, -735.356, 223.125),
                    (-332.219, 3108.55, 1553.93)
                ];
            }
            else
            {
                self addOpt("tp", "No Custom Teleports");
            }
            self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            break;

   case "class":  // Class Menu
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
            self addOpt("Attachments", ::newMenu, "attach");
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
            self addMenu("wpns", "Weapons Classes");
            smgIDs = ["mp7_mp","pdw57_mp","vector_mp","insas_mp","qcw05_mp","evoskorpion_mp","peacekeeper_mp"];
            smgNames = ["MP7","PDW-57","Vector K10","MSMC","Chicom CQB","Skorpion EVO","Peackeeper"];
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::giveuserweapon);

            arIDs = ["tar21_mp","type95_mp","sig556_mp","sa58_mp","hk416_mp","scar_mp","saritch_mp","xm8_mp","an94_mp"];
            arNames = ["MTAR","Type 95","Swat 556","FAL OSW","M27","Scar-H","SMR","M8A1","AN-94"];
            self addSliderString("Assault Rifles", arIDs, arNames, ::giveuserweapon);

            sgIDs = ["870mcs_mp","saiga12_mp","ksg_mp","srm1216_mp"];
            sgNames = ["Remington 870 MCS","S12","KSG","M1216"];
            self addSliderString("Shotguns", sgIDs, sgNames, ::giveuserweapon);

            lmgIDs = ["mk48_mp","qbb95_mp","lsat_mp","hamr_mp"];
            lmgNames = ["MK48","QBB LSW","LSAT","HAMR"];
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::giveuserweapon);

            srIDs = ["svu_mp","dsr50_mp","ballista_mp","as50_mp"];
            srNames = ["SVU-AS","DSR-50","Ballista","XPR-50"];
            self addSliderString("Sniper Rifles", srIDs, srNames, ::giveuserweapon);

            pstlsIDs = ["fiveseven_mp","fnp45_mp","beretta93r_mp","judge_mp","kard_mp"];
            pstlsNames = ["Five Seven","Tac-45","B23R","Executioner","Kap-40"];
            self addSliderString("Pistols", pstlsIDs, pstlsNames, ::giveuserweapon);


            self addOpt("Launchers", ::newMenu, "lnchrs");
            self addOpt("Specials", ::newMenu, "specs");
            self addOpt("Miscellaneous", ::newMenu, "misc");
            self addOpt("Assault Shield", ::giveUserWeapon, "riotshield_mp");
            break;

        case "attach":
            self addMenu("attach", "Attachments");

            //smh -- CF4
            attachIDs = ["reflex", "fastads", "dualclip", "acog", "grip", "stalker", "rangefinder", "steadyaim", "sf", "holo", "silencer", "fmj", "dualoptic", "extclip", "gl", "mms", "extbarrel", "rf", "vzoom", "ir", "is", "tacknife", "dw", "stackfire"];
            attachNames = ["Reflex", "Quickdraw", "Fast Mag", "ACOG", "Fore Grip", "Stock", "Target Finder", "Laser Sight", "Select Fire", "EO Tech", "Suppressor", "FMJ", "Hybrid Optic", "Extended Clip", "Launcher", "MMS", "Long Barrel", "Rapid Fire", "Variable Zoom", "Dual Band", "Iron Sight", "Knife", "Dual Wield", "Tri-Bolt"];
            for(a=0;a<attachNames.size;a++)
                self addOpt(attachNames[a], ::giveplayerattachment, attachIDs[a]);
            break;
                                   
        case "lnchrs":
            self addMenu("lnchrs", "Launchers");
            self addOpt("SMAW", ::giveUserWeapon, "smaw_mp");
            self addOpt("FHJ-18 AA", ::giveUserWeapon, "fhj18_mp");
            self addOpt("RPG", ::giveUserWeapon, "usrpg_mp");
            break;

        case "specs":
            self addMenu("specs", "Specials");

            cbowIDs = ["crossbow_mp","crossbow_mp+stackfire","crossbow_mp+reflex"];
            cbowNames = ["None","Tri-Bolt","Reflex"];
            self addSliderString("Crossbow", cbowIDs, cbowNames, ::giveUserWeapon);

            self addOpt("Ballistic Knife", ::giveUserWeapon, "knife_ballistic_mp");
            break;

            case "misc":
            self addMenu("misc", "Miscellaneous");

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

            baseCamoNames = ["", "DEVGRU", "A-TACS AU", "ERDL", "Siberia", "Choco", "Blue Tiger", "Bloodshot", "Ghostex: Delta 6", "Kryptek: Typhon", "Carbon Fiber", "Cherry Blossom", "Art of War", "Ronin", "Skulls", "Gold", "Diamond"];
            for(a=1;a<baseCamoNames.size;a++)
            self addOpt(baseCamoNames[a], ::changeCamo, a);
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
            self addOpt("Frag", ::GivePlayerEquipment, "frag_grenade");
            self addOpt("Semtex", ::GivePlayerEquipment, "sticky_grenade");
            self addOpt("Combat Axe", ::GivePlayerEquipment, "hatchet");
            self addOpt("Bouncing Betty", ::GivePlayerEquipment, "bouncingbetty");
            self addOpt("C4", ::GivePlayerEquipment, "satchel_charge");
            self addOpt("Claymore", ::GivePlayerEquipment, "claymore");
            break;

        case "tacticals":
            self addMenu("tacticals", "Tacticals");
            self addOpt("Concussion Grenade", ::GivePlayerEquipment, "concussion_grenade");
            self addOpt("Smoke Grenade", ::GivePlayerEquipment, "willy_pete");
            self addOpt("Sensor Grenade", ::GivePlayerEquipment, "sensor_grenade");
            self addOpt("EMP Grenade", ::GivePlayerEquipment, "emp_grenade");
            self addOpt("Shock Charge", ::GivePlayerEquipment, "proximity_grenade");
            self addOpt("Black Hat", ::GivePlayerEquipment, "pda_hack");
            self addOpt("Flashbang", ::GivePlayerEquipment, "flash_grenade");
            self addOpt("Trophy System", ::GivePlayerEquipment, "trophy_system");
            self addOpt("Tactical Insertion", ::GivePlayerEquipment, "tactical_insertion");
            break;

        case "afthit":  // Afterhits Menu
            self addMenu("afthit", "Afterhits Menu");

            arIDs = ["tar21_mp","type95_mp","sig556_mp","sa58_mp","hk416_mp","scar_mp","saritch_mp","xm8_mp","an94_mp"];
            arNames = ["MTAR","Type 95","Swat 556","FAL OSW","M27","Scar-H","SMR","M8A1","AN-94"];
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            smgIDs = ["mp7_mp","pdw57_mp","vector_mp","insas_mp","qcw05_mp","evoskorpion_mp","peacekeeper_mp"];
            smgNames = ["MP7","PDW-57","Vecto K10","MSMC","Chicom CQB","Skorpion EVO","Peackeeper"];
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

            sgIDs = ["870mcs_mp","saiga12_mp","ksg_mp","srm1216_mp"];
            sgNames = ["Remington 870 MCS","S12","KSG","M1216"];
            self addSliderString("Shotguns", sgIDs, sgNames, ::afterhit);

            lmgIDs = ["mk48_mp","qbb95_mp","lsat_mp","hamr_mp"];
            lmgNames = ["MK48","QBB LSW","LSAT","HAMR"];
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            srIDs = ["svu_mp","dsr50_mp","ballista_mp","as50_mp"];
            srNames = ["SVU-AS","DSR-50","Ballista","XPR-50"];
            self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

            pstlsIDs = ["kard_dw_mp","fnp45_dw_mp","fiveseven_dw_mp","judge_dw_mp","beretta93r_dw_mp","fiveseven_mp","fnp45_mp","beretta93r_mp","judge_mp","kard_mp"];
            pstlsNames = ["Dual Kap-40","Dual Tac-45","Dual Five Seven","Dual Executioner","Dual B23R","Five Seven","Tac-45","B23R","Executioner","Kap-40"];
            self addSliderString("Pistols", pstlsIDs, pstlsNames, ::afterhit);

            lnchrsIDs = ["m32_mp","smaw_mp","fhj18_mp","usrpg_mp"];
            lnchrsNames = ["War Machine","SMAW","FHJ-18","RPG"];
            self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);

            specIDs = ["knife_held_mp","defaultweapon_mp","minigun_mp","riotshield_mp","crossbow_mp","knife_ballistic_mp","briefcase_bomb_mp","claymore_mp","destructible_car_mp"];
            specNames = ["CSGO Knife","Default Weapon","Death Machine","Riot Shield","Crossbow","Ballistic Knife","Bomb","Claymore","Car"];
            self addSliderString("Special Weapons", specIDs, specNames, ::afterhit);
            break;

        case "kstrks": //Killstreak Menu
            self addMenu("kstrks", "Killstreak Menu");
            self addOpt("Fill Streaks", ::fillStreaks); 

            streakIDs = ["radar_mp", "rcbomb_mp", "inventory_missile_drone_mp", "inventory_supply_drop_mp", "counteruav_mp", "microwaveturret_mp", "remote_missile_mp", "planemortar_mp", "autoturret_mp", "inventory_minigun_mp", "inventory_m32_mp", "qrdrone_mp", "inventory_ai_tank_drop_mp", "helicopter_comlink_mp", "radardirection_mp", "helicopter_guard_mp", "emp_mp", "straferun_mp", "remote_mortar_mp", "helicopter_player_gunner_mp", "dogs_mp", "missile_swarm_mp"];
            streakNames = ["UAV", "RC-XD", "Hunter Killer", "Care Package", "Counter-UAV", "Guardian", "Hellstorm", "Lightning Strike", "Sentry Gun", "Death Machine", "War Machine", "Dragonfire", "AGR", "Stealth Chopper", "VSAT", "Escort Drone", "EMP Systems", "Warthog", "Lodestar", "VTOL Warship", "K9 Unit", "Swarm"];
            for(a=0;a<streakNames.size;a++)
            self addOpt(streakNames[a], ::dokillstreak, streakIDs[a]);
            
            break;

        case "host":  // Host Options (host/dev only)
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            self addOpt("Toggle Floaters", ::togglelobbyfloat);
            self addOpt("Restart", ::FastRestart);

            timerIDs = ["add", "subtract"];
            timerNames = ["Add 1 Minute", "Remove 1 Minute"];
            self addsliderstring("Game Timer", timerIDs, timerNames, ::editTime);

            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
            self addOpt("Teleport Bots to Crosshairs", ::tpBots);
            self addOpt("Kick Bots", ::kickAllBots);
            self addOpt("Fill Bots", ::spawnBots,18);

            break;
        }
        self clientOptions();
    }

clientOptions()
{   
    if(self isHost() || self isdeveloper())
    {
        self addMenu("Verify", "Clients Menu");
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
            self addOpt("Teleport to Croshairs", ::teleportToCrosshair, player);  

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
                        }
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
