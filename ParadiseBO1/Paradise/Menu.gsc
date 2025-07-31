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
            self addToggle("Noclip", self.UFOMode, ::UFOMode);
            self addToggle("Current Canswap",  self.currCan, ::CurrCanswap);
            self addToggle("Infinite Canswap", self.InfiniteCan, ::InfCanswap);
            self addToggle("RPG Ride",  self.RPGRide, ::ToggleRPGRide);
            self addToggle("Toggle Instashoots", self.instashoot, ::instashoot);
            self addOpt("Spawn Slide @ Crosshairs", ::slide);
            self addOpt("Spawn Bounce @ Feet", ::normalbounce);
            self addOpt("Spawn Platform @ Feet", ::Platform);
            break;

        case "sK":  // Binds Menu 
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb");
            self addOpt("Cowboy Bind", ::newMenu, "cwby");
            self addOpt("Reverse Cowboy Bind", ::newMenu, "rcwby");
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
            self addOpt("Nac Mod Bind", ::newMenu, "nmod");
            self addOpt("Skree Bind", ::newMenu, "skree");
            self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
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

           if (getDvar("mapname") == "mp_array")
    {
        self addOpt("Satellite Barrier", ::tpToSpot, (-2911.79, 1275.46, 967.126));
        self addOpt("Platform OOM", ::tpToSpot, (-3693.71, 12239.5, 3943.98)); 
        self addOpt("End of Road Sui", ::tpToSpot, (-4316.74, 4201.55, 558.828));
    } 
    else if (getDvar("mapname") == "mp_firingrange") 
    {
        self addOpt("Guard Tower 1", ::tpToSpot, (-1498.27, -2445.87, 351.149));
        self addOpt("Guard Tower 2", ::tpToSpot, (3215.73, -976.481, 320.606)); 
        self addOpt("Trailer Sign", ::tpToSpot, (150.43, 2682.4, 473.125));
    }
    else if (getDvar("mapname") == "mp_nuked") 
    {
        self addOpt("Nuke Tower", ::tpToSpot, (3722.89, 12221.2, 3779.54));
        self addOpt("Where TF Am I", ::tpToSpot, (-176.716, -8530.06, 3101.12)); 
        self addOpt("BackYard", ::tpToSpot, (-6044.9, 840.61, 2905.33));
    } 
    else if (getDvar("mapname") == "mp_cracked") 
    {
        self addOpt("Spawn Barrier", ::tpToSpot, (1667.4, -4.04464, 1185.13));
        self addOpt("Platform", ::tpToSpot, (-1746.1, -4883.62, 575.742));
        self addOpt("Spawn Barrier 2", ::tpToSpot, (-3532.51, 1.30511, 1185.13));
    }
    else if (getDvar("mapname") == "mp_crisis") 
    {
        self addOpt("Spawn Platform 1", ::tpToSpot, (-5748.65, 415.442, 1786.82));
        self addOpt("Spawn Platform 2", ::tpToSpot, (10115.2, 424.233, 4230.95));
        self addOpt("Tower Spot", ::tpToSpot, (-2649.62, -41.9161, 1158.6));
    }
    else if (getDvar("mapname") == "mp_duga") 
    {
        self addOpt("Transmission Tower", ::tpToSpot, (108.001, 2328.06, 3248.2));
        self addOpt("Bunker Spot", ::tpToSpot, (-3508.49, -1569.76, 265.125));
        self addOpt("Barrier Spot", ::tpToSpot, (-2631.85, -5976.45, 2497.13));
    }
    else if (getDvar("mapname") == "mp_hanoi") 
    {
        self addOpt("Barrier Spot 1", ::tpToSpot, (-410.636, -3174.41, 1473.13));
        self addOpt("Barrier Spot 2", ::tpToSpot, (2820.77, -1266.35, 1473.13)); 
        self addOpt("Barrier Spot 3", ::tpToSpot, (-5614.77, -843.344, 3375.09)); 
    }
    else if (getDvar("mapname") == "mp_cosmodrome") 
    {
        self addOpt("Platform 1", ::tpToSpot, (2531.77, -2217.04, 1888.63)); 
        self addOpt("Platform 2", ::tpToSpot, (2534.833, -6.35055, 1888.23));
        self addOpt("Barrier", ::tpToSpot, (-2100.69, 684.469, 2008.51));
    }  
    else if (getDvar("mapname") == "mp_radiation") 
    {
        self addOpt("Power Lines", ::tpToSpot, (-4291.16, 785.343, 2004.31));
        self addOpt("Blade Platform", ::tpToSpot, (-817.408, -5206.03, 2638.54));
        self addOpt("Treetops", ::tpToSpot, (-376.241, 7292.82, 1806.27));
    } 
    else if (getDvar("mapname") == "mp_mountain")
    {
        self addOpt("Top Small Tower", ::tpToSpot, (4665.13, 1613.21, 1117.93));
        self addOpt("Top Tall Tower", ::tpToSpot, (3397.42, -5086.48, 2837.9)); 
        self addOpt("Platform Spot", ::tpToSpot, (-368.874, 333.844, 1857.18));
    } 
    else if (getDvar("mapname") == "mp_villa") 
    {
        self addOpt("Top Barrier", ::tpToSpot, (6655.1, -396.045, 1281.13));
        self addOpt("Driveway ", ::tpToSpot, (3493.13, 5486.89, 1261.13));
        self addOpt("Sea Sui", ::tpToSpot, (-166.727, -1005.7, 1281.13));
        self addOpt("tp", 6, "Platform Spot", ::tpToSpot, (10348.4, 4352.82, 3908.41));
    } 
    else if (getDvar("mapname") == "mp_russianbase") 
    {
        self addOpt("Treetop", ::tpToSpot, (2126.6, -4917, 3735.69));
        self addOpt("Top Watchtower", ::tpToSpot, (-1334.47, 3209.59, 792.472));
        self addOpt("Crate Spot", ::tpToSpot, (3955.7, 919.906, 2156.37));
    } 
    else if(getDvar("mapname") == "mp_silo")
    {
        self addOpt("Platform", ::tpToSpot, (7042.24, 6759.94, 4057.78));
    }
    else
    {
    self addOpt("tp", 0, "No Teleport Spots!");
    }
            break;

           case "class":  // Class Menu
    self addMenu("class", "Class Menu"); 
    self addOpt("Weapons", ::newMenu, "wpns");
    self addOpt("Camos", ::newMenu, "camos");
    self addOpt("Lethals", ::newMenu, "lethals");
    self addOpt("Tacticals", ::newMenu, "tacticals");
    self addOpt("Equipment", ::newMenu, "equip");
    self addOpt("Save Loadout", ::saveLoadout);
    self addOpt("Delete Saved Loadout", ::deleteSavedLoadout);
    self addOpt("Take Current Weapon", ::takeWpn);
    self addOpt("Drop Current Weapon", ::dropWpn);
    self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
    break;

case "camos":
    self addMenu("camos", "Camos");
    self addOpt("Random Camo", ::randomcamo);
    self addOpt("Remove Camo", ::changeCamo, 1);
    self addOpt("Dusty", ::changeCamo, 2);
    self addOpt("Ice", ::changeCamo, 3);
    self addOpt("Red", ::changeCamo, 4);
    self addOpt("Olive", ::changeCamo, 5);
    self addOpt("Nevada", ::changeCamo, 6);
    self addOpt("Sahara", ::changeCamo, 7);
    self addOpt("ERDL", ::changeCamo, 8);
    self addOpt("Tiger", ::changeCamo, 9);
    self addOpt("Berlin", ::changeCamo, 10);
    self addOpt("Warsaw", ::changeCamo, 11);
    self addOpt("Siberia", ::changeCamo, 12);
    self addOpt("Yukon", ::changeCamo, 13);
    self addOpt("Woodland", ::changeCamo, 14);
    self addOpt("Flora", ::changeCamo, 15);
    self addOpt("Gold", ::changeCamo, 16);
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
    self addOpt("MP5K", ::newMenu, "mp5kAtt");
    self addOpt("Skorpion", ::newMenu, "skorpAtt");
    self addOpt("MAC11", ::newMenu, "mac11Att");
    self addOpt("AK74u", ::newMenu, "ak74uAtt");
    self addOpt("Uzi", ::newMenu, "uziAtt");
    self addOpt("PM63", ::newMenu, "pm63Att");
    self addOpt("MPL", ::newMenu, "mplAtt");
    self addOpt("Spectre", ::newMenu, "spectAtt");
    self addOpt("Kiparis", ::newMenu, "kipaAtt");
    break;

case "mp5kAtt":
    self addMenu("mp5kAtt", "MP5K Attachments");
    self addOpt("None", ::giveUserWeapon, "mp5k_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "mp5k_extclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "mp5k_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "mp5k_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "mp5k_reflex_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "mp5k_silencer_mp");
    self addOpt("Rapid Fire", ::giveUserWeapon, "mp5k_rf_mp");
    break;

case "skorpAtt":
    self addMenu("skorpAtt", "Skorpion Attachments");
    self addOpt("None", ::giveUserWeapon, "skorpion_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "skorpion_extclip_mp");
    self addOpt("Grip", ::giveUserWeapon, "skorpion_grip_mp");
    self addOpt("Dual Wield", ::giveUserWeapon, "skorpiondw_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "skorpion_silencer_mp");
    self addOpt("Rapid Fire", ::giveUserWeapon, "skorpion_rf_mp");
    break;

case "mac11Att":
    self addMenu("mac11Att", "MAC11 Attachments");
    self addOpt("None", ::giveUserWeapon, "mac11_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "mac11_extclip_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "mac11_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "mac11_reflex_mp");
    self addOpt("Grip", ::giveUserWeapon, "mac11_grip_mp");
    self addOpt("Dual Wield", ::giveUserWeapon, "mac11dw_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "mac11_silencer_mp");
    self addOpt("Rapid Fire", ::giveUserWeapon, "mac11_rf_mp");
    break;

case "ak74uAtt":
    self addMenu("ak74uAtt", "AK74u Attachments");
    self addOpt("None", ::giveUserWeapon, "ak74u_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "ak74u_extclip_mp");
    self addOpt("Dual Mag", ::giveUserWeapon, "ak74u_dualclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "ak74u_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "ak74u_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "ak74u_reflex_mp");
    self addOpt("Grip", ::giveUserWeapon, "ak74u_grip_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "ak74u_silencer_mp");
    self addOpt("Grenade Launcher", ::giveUserWeapon, "ak74u_gl_mp");
    self addOpt("Rapid Fire", ::giveUserWeapon, "ak74u_rf_mp");
    break;

case "uziAtt":
    self addMenu("uziAtt", "Uzi Attachments");
    self addOpt("None", ::giveUserWeapon, "uzi_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "uzi_extclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "uzi_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "uzi_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "uzi_reflex_mp");
    self addOpt("Grip", ::giveUserWeapon, "uzi_grip_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "uzi_silencer_mp");
    self addOpt("Rapid Fire", ::giveUserWeapon, "uzi_rf_mp");
    break;

case "pm63Att":
    self addMenu("pm63Att", "PM63 Attachments");
    self addOpt("None", ::giveUserWeapon, "pm63_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "pm63_extclip_mp");
    self addOpt("Grip", ::giveUserWeapon, "pm63_grip_mp");
    self addOpt("Dual Wield", ::giveUserWeapon, "pm63dw_mp");
    self addOpt("Rapid Fire", ::giveUserWeapon, "pm63_rf_mp");
    break;

case "mplAtt":
    self addMenu("mplAtt", "MPL Attachments");
    self addOpt("None", ::giveUserWeapon, "mpl_mp");
    self addOpt("Dual Mag", ::giveUserWeapon, "mpl_dualclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "mpl_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "mpl_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "mpl_reflex_mp");
    self addOpt("Grip", ::giveUserWeapon, "mpl_grip_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "mpl_silencer_mp");
    self addOpt("Rapid Fire", ::giveUserWeapon, "mpl_rf_mp");
    break;

case "spectAtt":
    self addMenu("spectAtt", "Spectre Attachments");
    self addOpt("None", ::giveUserWeapon, "spectre_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "spectre_extclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "spectre_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "spectre_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "spectre_reflex_mp");
    self addOpt("Grip", ::giveUserWeapon, "spectre_grip_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "spectre_silencer_mp");
    self addOpt("Rapid Fire", ::giveUserWeapon, "spectre_rf_mp");
    break;

case "kipaAtt":
    self addMenu("kipaAtt", "Kiparis Attachments");
    self addOpt("None", ::giveUserWeapon, "kiparis_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "kiparis_extclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "kiparis_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "kiparis_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "kiparis_reflex_mp");
    self addOpt("Grip", ::giveUserWeapon, "kiparis_grip_mp");
    self addOpt("Dual Wield", ::giveUserWeapon, "kiparisdw_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "kiparis_silencer_mp");
    self addOpt("Rapid Fire", ::giveUserWeapon, "kiparis_rf_mp");
    break;

case "ars":
    self addMenu("ars", "Assault Rifles");
    self addOpt("M16", ::newMenu, "m16Att");
    self addOpt("Enfield", ::newMenu, "enfAtt");
    self addOpt("M14", ::newMenu, "m14Att");
    self addOpt("Famas", ::newMenu, "famAtt");
    self addOpt("Galil", ::newMenu, "galAtt");
    self addOpt("AUG", ::newMenu, "augAtt");
    self addOpt("FN FAL", ::newMenu, "falAtt");
    self addOpt("AK47", ::newMenu, "ak47Att");
    self addOpt("Commando", ::newMenu, "comAtt");
    self addOpt("G11", ::newMenu, "g11Att");
    break;

case "m16Att":
    self addMenu("m16Att", "M16 Attachments");
    self addOpt("None", ::giveUserWeapon, "m16_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "m16_extclip_mp");
    self addOpt("Dual Mag", ::giveUserWeapon, "m16_dualclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "m16_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "m16_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "m16_reflex_mp");
    self addOpt("Masterkey", ::giveUserWeapon, "m16_mk_mp");
    self addOpt("Flamethrower", ::giveUserWeapon, "m16_ft_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "m16_ir_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "m16_silencer_mp");
    self addOpt("Grenade Launcher", ::giveUserWeapon, "m16_gl_mp");
    break;

case "enfAtt":
    self addMenu("enfAtt", "Enfield Attachments");
    self addOpt("None", ::giveUserWeapon, "enfield_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "enfield_extclip_mp");
    self addOpt("Dual Mag", ::giveUserWeapon, "enfield_dualclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "enfield_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "enfield_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "enfield_reflex_mp");
    self addOpt("Masterkey", ::giveUserWeapon, "enfield_mk_mp");
    self addOpt("Flamethrower", ::giveUserWeapon, "enfield_ft_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "enfield_ir_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "enfield_silencer_mp");
    self addOpt("Grenade Launcher", ::giveUserWeapon, "enfield_gl_mp");
    break;

case "m14Att":
    self addMenu("m14Att", "M14 Attachments");
    self addOpt("None", ::giveUserWeapon, "m14_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "m14_extclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "m14_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "m14_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "m14_reflex_mp");
    self addOpt("Grip", ::giveUserWeapon, "m14_grip_mp");
    self addOpt("Masterkey", ::giveUserWeapon, "m14_mk_mp");
    self addOpt("Flamethrower", ::giveUserWeapon, "m14_ft_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "m14_ir_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "m14_silencer_mp");
    self addOpt("Grenade Launcher", ::giveUserWeapon, "m14_gl_mp");
    break;

case "famAtt":
    self addMenu("famAtt", "Famas Attachments");
    self addOpt("None", ::giveUserWeapon, "famas_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "famas_extclip_mp");
    self addOpt("Dual Mag", ::giveUserWeapon, "famas_dualclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "famas_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "famas_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "famas_reflex_mp");
    self addOpt("Masterkey", ::giveUserWeapon, "famas_mk_mp");
    self addOpt("Flamethrower", ::giveUserWeapon, "famas_ft_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "famas_ir_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "famas_silencer_mp");
    self addOpt("Grenade Launcher", ::giveUserWeapon, "famas_gl_mp");
    break;

case "galAtt":
    self addMenu("galAtt", "Galil Attachments");
    self addOpt("None", ::giveUserWeapon, "galil_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "galil_extclip_mp");
    self addOpt("Dual Mag", ::giveUserWeapon, "galil_dualclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "galil_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "galil_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "galil_reflex_mp");
    self addOpt("Masterkey", ::giveUserWeapon, "galil_mk_mp");
    self addOpt("Flamethrower", ::giveUserWeapon, "galil_ft_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "galil_ir_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "galil_silencer_mp");
    self addOpt("Grenade Launcher", ::giveUserWeapon, "galil_gl_mp");
    break;

case "augAtt":
    self addMenu("augAtt", "AUG Attachments");
    self addOpt("None", ::giveUserWeapon, "aug_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "aug_extclip_mp");
    self addOpt("Dual Mag", ::giveUserWeapon, "aug_dualclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "aug_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "aug_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "aug_reflex_mp");
    self addOpt("Masterkey", ::giveUserWeapon, "aug_mk_mp");
    self addOpt("Flamethrower", ::giveUserWeapon, "aug_ft_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "aug_ir_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "aug_silencer_mp");
    self addOpt("Grenade Launcher", ::giveUserWeapon, "aug_gl_mp");
    break;

case "falAtt":
    self addMenu("falAtt", "FN FAL Attachments");
    self addOpt("None", ::giveUserWeapon, "fnfal_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "fnfal_extclip_mp");
    self addOpt("Dual Mag", ::giveUserWeapon, "fnfal_dualclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "fnfal_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "fnfal_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "fnfal_reflex_mp");
    self addOpt("Masterkey", ::giveUserWeapon, "fnfal_mk_mp");
    self addOpt("Flamethrower", ::giveUserWeapon, "fnfal_ft_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "fnfal_ir_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "fnfal_silencer_mp");
    self addOpt("Grenade Launcher", ::giveUserWeapon, "fnfal_gl_mp");
    break;

case "ak47Att":
    self addMenu("ak47Att", "AK47 Attachments");
    self addOpt("None", ::giveUserWeapon, "ak47_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "ak47_extclip_mp");
    self addOpt("Dual Mag", ::giveUserWeapon, "ak47_dualclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "ak47_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "ak47_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "ak47_reflex_mp");
    self addOpt("Masterkey", ::giveUserWeapon, "ak47_mk_mp");
    self addOpt("Flamethrower", ::giveUserWeapon, "ak47_ft_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "ak47_ir_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "ak47_silencer_mp");
    self addOpt("Grenade Launcher", ::giveUserWeapon, "ak47_gl_mp");
    break;

case "comAtt":
    self addMenu("comAtt", "Commando Attachments");
    self addOpt("None", ::giveUserWeapon, "commando_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "commando_extclip_mp");
    self addOpt("Dual Mag", ::giveUserWeapon, "commando_dualclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "commando_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "commando_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "commando_reflex_mp");
    self addOpt("Masterkey", ::giveUserWeapon, "commando_mk_mp");
    self addOpt("Flamethrower", ::giveUserWeapon, "commando_ft_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "commando_ir_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "commando_silencer_mp");
    self addOpt("Grenade Launcher", ::giveUserWeapon, "commando_gl_mp");
    break;

case "g11Att":
    self addMenu("g11Att", "G11 Attachments");
    self addOpt("None", ::giveUserWeapon, "g11_mp");
    self addOpt("Low Power Scope", ::giveUserWeapon, "g11_lps_mp");
    self addOpt("Variable Zoom", ::giveUserWeapon, "g11_vzoom_mp");
    break;

case "sgs":
    self addMenu("sgs", "Shotguns");
    self addOpt("Olympia", ::giveUserWeapon, "rottweil72_mp");
    self addOpt("Stakeout", ::newMenu, "stkAtt");
    self addOpt("SPAS-12", ::newMenu, "spasAtt");
    self addOpt("HS10", ::newMenu, "hs10Att");
    break;

case "stkAtt":
    self addMenu("stkAtt", "Stakeout Attachments");
    self addOpt("None", ::giveUserWeapon, "ithaca_mp");
    self addOpt("Grip", ::giveUserWeapon, "ithaca_grip_mp");
    break;

case "spasAtt":
    self addMenu("spasAtt", "SPAS-12 Attachments");
    self addOpt("None", ::giveUserWeapon, "spas12_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "spas12_silencer_mp");
    break;

case "hs10Att":
    self addMenu("hs10Att", "HS10 Attachments");
    self addOpt("None", ::giveUserWeapon, "hs10_mp");
    self addOpt("Dual Wield", ::giveUserWeapon, "hs10dw_mp");
    break;

case "lmgs":
    self addMenu("lmgs", "Light Machine Guns");
    self addOpt("HK21", ::newMenu, "hk21Att");
    self addOpt("RPK", ::newMenu, "rpkAtt");
    self addOpt("M60", ::newMenu, "m60Att");
    self addOpt("Stoner63", ::newMenu, "stnrAtt");
    break;

case "hk21Att":
    self addMenu("hk21Att", "HK21 Attachments");
    self addOpt("None", ::giveUserWeapon, "hk21_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "hk21_extclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "hk21_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "hk21_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "hk21_reflex_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "hk21_ir_mp");
    break;

case "rpkAtt":
    self addMenu("rpkAtt", "RPK Attachments");
    self addOpt("None", ::giveUserWeapon, "rpk_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "rpk_extclip_mp");
    self addOpt("Dual Mag", ::giveUserWeapon, "rpk_dualclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "rpk_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "rpk_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "rpk_reflex_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "rpk_ir_mp");
    break;

case "m60Att":
    self addMenu("m60Att", "M60 Attachments");
    self addOpt("None", ::giveUserWeapon, "m60_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "m60_extclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "m60_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "m60_elbit_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "m60_reflex_mp");
    self addOpt("Grip", ::giveUserWeapon, "m60_grip_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "m60_ir_mp");
    break;

case "stnrAtt":
    self addMenu("stnrAtt", "Stoner63 Attachments");
    self addOpt("None", ::giveUserWeapon, "stoner63_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "stoner63_acog_mp");
    self addOpt("Red Dot Sight", ::giveUserWeapon, "stoner63_elbit_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "stoner63_extclip_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "stoner63_ir_mp");
    self addOpt("Reflex Sight", ::giveUserWeapon, "stoner63_reflex_mp");
    break;

case "srs":
    self addMenu("srs", "Sniper Rifles");
    self addOpt("Dragunov", ::newMenu, "drgAtt");
    self addOpt("WA2000", ::newMenu, "wa2kAtt");
    self addOpt("L96A1", ::newMenu, "l96Att");
    self addOpt("PSG1", ::newMenu, "psgAtt");
    break;

case "drgAtt":
    self addMenu("drgAtt", "Dragunov Attachments");
    self addOpt("None", ::giveUserWeapon, "dragunov_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "dragunov_extclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "dragunov_acog_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "dragunov_ir_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "dragunov_silencer_mp");
    self addOpt("Variable Zoom", ::giveUserWeapon, "dragunov_vzoom_mp");
    break;

case "wa2kAtt":
    self addMenu("wa2kAtt", "WA2000 Attachments");
    self addOpt("None", ::giveUserWeapon, "wa2000_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "wa2000_extclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "wa2000_acog_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "wa2000_ir_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "wa2000_silencer_mp");
    self addOpt("Variable Zoom", ::giveUserWeapon, "wa2000_vzoom_mp");
    break;

case "l96Att":
    self addMenu("l96Att", "L96A1 Attachments");
    self addOpt("None", ::giveUserWeapon, "l96a1_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "l96a1_extclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "l96a1_acog_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "l96a1_ir_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "l96a1_silencer_mp");
    self addOpt("Variable Zoom", ::giveUserWeapon, "l96a1_vzoom_mp");
    break;

case "psgAtt":
    self addMenu("psgAtt", "PSG1 Attachments");
    self addOpt("None", ::giveUserWeapon, "psg1_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "psg1_extclip_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "psg1_acog_mp");
    self addOpt("Infrared Scope", ::giveUserWeapon, "psg1_ir_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "psg1_silencer_mp");
    self addOpt("Variable Zoom", ::giveUserWeapon, "psg1_vzoom_mp");
    break;

case "secs":
    self addMenu("secs", "Secondary Weapons");
    self addOpt("Pistols", ::newMenu, "hgs");
    self addOpt("Launchers", ::newMenu, "lnchrs");
    self addOpt("Specials", ::newMenu, "specs");
    break;

case "hgs":
    self addMenu("hgs", "Pistols");
    self addOpt("ASP", ::newMenu, "aspAtt");
    self addOpt("M1911", ::newMenu, "m1911Att");
    self addOpt("Makarov", ::newMenu, "makAtt");
    self addOpt("Python", ::newMenu, "pythAtt");
    self addOpt("CZ75", ::newMenu, "cz75Att");
    break;

case "aspAtt":
    self addMenu("aspAtt", "ASP Attachments");
    self addOpt("None", ::giveUserWeapon, "asp_mp");
    self addOpt("Dual Wield", ::giveUserWeapon, "aspdw_mp");
    break;

case "m1911Att":
    self addMenu("m1911Att", "M1911 Attachments");
    self addOpt("None", ::giveUserWeapon, "m1911_mp");
    self addOpt("Upgraded Iron Sights", ::giveUserWeapon, "m1911_upgradesight_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "m1911_extclip_mp");
    self addOpt("Dual Wield", ::giveUserWeapon, "m1911dw_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "m1911_silencer_mp");
    break;

case "makAtt":
    self addMenu("makAtt", "Makarov Attachments");
    self addOpt("None", ::giveUserWeapon, "makarov_mp");
    self addOpt("Upgraded Iron Sights", ::giveUserWeapon, "makarov_upgradesight_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "makarov_extclip_mp");
    self addOpt("Dual Wield", ::giveUserWeapon, "makarovdw_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "makarov_silencer_mp");
    break;

case "pythAtt":
    self addMenu("pythAtt", "Python Attachments");
    self addOpt("None", ::giveUserWeapon, "python_mp");
    self addOpt("ACOG Sight", ::giveUserWeapon, "python_acog_mp");
    self addOpt("Snub Nose", ::giveUserWeapon, "python_snub_mp");
    self addOpt("Speed Reloader", ::giveUserWeapon, "python_speed_mp");
    self addOpt("Dual Wield", ::giveUserWeapon, "pythondw_mp");
    break;

case "cz75Att":
    self addMenu("cz75Att", "CZ75 Attachments");
    self addOpt("None", ::giveUserWeapon, "cz75_mp");
    self addOpt("Upgraded Iron Sights", ::giveUserWeapon, "cz75_upgradesight_mp");
    self addOpt("Extended Mag", ::giveUserWeapon, "cz75_extclip_mp");
    self addOpt("Dual Wield", ::giveUserWeapon, "cz75dw_mp");
    self addOpt("Suppressor", ::giveUserWeapon, "cz75_silencer_mp");
    self addOpt("Full Auto Upgrade", ::giveUserWeapon, "cz75_auto_mp");
    break;

case "lnchrs":
    self addMenu("lnchrs", "Launchers");
    self addOpt("M72 LAW", ::giveUserWeapon, "m72_law_mp");
    self addOpt("RPG", ::giveUserWeapon, "rpg_mp");
    self addOpt("Strela-3", ::giveUserWeapon, "strela_mp");
    self addOpt("China Lake", ::giveUserWeapon, "china_lake_mp");
    break;

case "specs":
    self addMenu("specs", "Specials");
    self addOpt("Ballistic Knife", ::giveUserWeapon, "knife_ballistic_mp");
    self addOpt("Crossbow", ::giveUserWeapon, "crossbow_explosive_mp");
    break;

case "sWpns":
    self addMenu("sWpns", "Special Weapons");
    self addOpt("Bomb Briefcase", ::giveUserWeapon, "briefcase_bomb_defuse_mp");
    self addOpt("Radio", ::giveUserWeapon, "airstrike_mp");
    self addOpt("Broken ASP", ::giveUserWeapon, "asplh_mp");
    self addOpt("Broken M1911", ::giveUserWeapon, "m1911lh_mp");
    self addOpt("Broken Makarov", ::giveUserWeapon, "makarovlh_mp");
    self addOpt("Broken Python", ::giveUserWeapon, "pythonlh_mp");
    self addOpt("Broken CZ75", ::giveUserWeapon, "cz75lh_mp");
    self addOpt("Broken HS10", ::giveUserWeapon, "hs10lh_mp");
    self addOpt("Stun Trigger", ::giveUserWeapon, "autoturret_mp");
    self addOpt("Default Weapon", ::giveUserWeapon, "defaultweapon_mp");
    self addOpt("WTF even is this..", ::giveUserWeapon, "dog_bite_mp");
    break;

case "lethals":
    self addMenu("lethals", "Lethals");
    self addOpt("Frag", ::giveUserLethal, "frag_grenade_mp");
    self addOpt("Semtex", ::giveUserLethal, "sticky_grenade_mp");
    self addOpt("Tomahawk", ::giveUserLethal, "hatchet_mp");
    break;

case "tacticals":
    self addMenu("tacticals", "Tacticals");
    self addOpt("Willy Pete", ::giveUserTactical, "willy_pete_mp");
    self addOpt("Nova Gas", ::giveUserTactical, "tabun_gas_mp");
    self addOpt("Flashbang", ::giveUserTactical, "flash_grenade_mp");
    self addOpt("Concussion", ::giveUserTactical, "concussion_grenade_mp");
    self addOpt("Decoy", ::giveUserTactical, "nightingale_mp");
    break;

case "equip":
    self addMenu("equip", "Equipment");
    self addOpt("Camera Spike", ::giveUserEquipment, "camera_spike_mp");
    self addOpt("C4", ::giveUserEquipment, "satchel_charge_mp");
    self addOpt("Tactical Insertion", ::giveUserEquipment, "tactical_insertion_mp");
    self addOpt("Jammer", ::giveUserEquipment, "scrambler_mp");
    self addOpt("Motion Sensor", ::giveUserEquipment, "acoustic_sensor_mp");
    self addOpt("Claymore", ::giveUserEquipment, "claymore_mp");
    break;


        case "afthit":
            self addMenu("afthit", "Assault Rifles");
            self addOpt("RC Car", ::AfterHit, "rcbomb_mp");
            self addOpt("Valkyrie", ::AfterHit, "m202_flash_mp");
            self addOpt("Bomb", ::AfterHit, "briefcase_bomb_mp");
            self addOpt("Minigun", ::AfterHit, "minigun_mp");
            self addOpt("Claymore", ::AfterHit, "claymore_mp");
            self addOpt("Jammer", ::AfterHit, "scrambler_mp");
            break;


        case "kstrks": 
            self addMenu("kstrks", "Killstreak Menu");
            self addOpt("Fill Streaks", ::fillStreaks); 
            self addOpt("RC-XD", ::doKillstreak, "rcbomb_mp");
            self addOpt("Sam Turret", ::doKillstreak, "auto_tow_mp");
            self addOpt("Care Package", ::doKillstreak, "supply_drop_mp");
            self addOpt("Sentry Gun", ::doKillstreak, "autoturret_mp");
            self addOpt("Valkyrie Rockets", ::doKillstreak, "m220_tow_mp");
            self addOpt("Gunship", ::doKillstreak, "helicopter_player_firstperson_mp");
            self addOpt("Grim Reaper", ::doKillstreak, "m202_flash_mp");
            break;

        case "bots":  // Bot Menu (host/dev only)
            self addMenu("bots", "Bot Menu");
            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
            self addOpt("Teleport Bots to Crosshairs", ::tpBots);
            self addOpt("Kick Bots", ::kickAllBots);
            self addOpt("Fill Bots", ::fillLobby); 
            break;

        case "host":  // Host Options (host/dev only)
            self addMenu("host", "Host Options");
            self addOpt("Verification Menu", ::newMenu, "Verify");
            self addOpt("End Game", ::debugexit);
            self addOpt("Fast Restart", ::FastRestart);
            self addToggle("Soft Lands", self.SoftLandsS, ::Softlands);
            self addOpt("Ladder Bounce", ::reverseladders);
            self addOpt("Add 1 Minute", ::add1min);
            self addOpt("Remove 1 Minute", ::sub1min);

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
                if (self adsbuttonpressed() && self meleebuttonpressed())
                {
                    self menuOpen();
                    wait .2;
                }
            }
            else
            {
                // SCROLLING UP & DOWN
                if (self secondaryoffhandbuttonpressed())
                {
                    self.menu[self getCurrentMenu() + "_cursor"] -= 1;
                    self scrollingSystem();
                    wait .08;
                }
                else if (self fragbuttonpressed())
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
